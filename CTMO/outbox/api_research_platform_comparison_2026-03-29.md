# Platform API Comparison: Gumroad, Etsy, WordPress, Medium, Redbubble
**Date:** 2026-03-29
**Prepared by:** CTMO
**Status:** Research Only (not implementation)

---

## Executive Summary

This document compares five major platforms for revenue stream automation, focusing on API capabilities, authentication, rate limits, and integration approaches. Key finding: **Only Etsy and WordPress have officially documented, production-ready APIs.** Gumroad is usable but undocumented. Medium has limited official support. Redbubble requires web scraping due to lack of official API.

---

## 1. GUMROAD API

### Authentication
- **Type:** OAuth 2.0
- **Flow:** Authorization Code Grant
- **Token Endpoint:** `https://gumroad.com/oauth/token`
- **Header Format:** `Authorization: Bearer {ACCESS_TOKEN}`
- **Token Expiration:** Non-expiring (until manually revoked) with refresh token support
- **Scope Examples:** products (products_r), sales (sales_r), subscribers

### Key Endpoints
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/v2/products` | GET | List all products |
| `/v2/products` | POST | Create product |
| `/v2/products/{id}` | PUT | Update product/pricing |
| `/v2/sales` | GET | Fetch sales data |
| `/v2/licenses/verify` | POST | Verify license key |

**Base URL:** `https://api.gumroad.com/v2/`

### Rate Limits
- **QPS (Queries Per Second):** Not officially documented
- **Daily Limit:** Not officially documented
- **Enforcement:** Returns HTTP 429 (Too Many Requests) when exceeded
- **Reset:** No documented reset period
- **Status Header:** No rate-limit headers documented

**Recommendation:** Assume conservative 1-2 requests/sec until limits discovered via 429s

### Error Handling
- **429 Status:** Rate limit exceeded
- **Retry Strategy:** Exponential backoff (1s, 2s, 4s, 8s...)
- **Transient Errors:** Handle 5xx with 3-attempt exponential backoff
- **Success Response:** JSON with success/error fields
- **Best Practices:**
  - Cache responses when possible
  - Use bulk endpoints where available
  - Contact Gumroad support for specific use case limits

### Polling vs. Webhooks
- **Webhooks:** Not documented; assume polling required
- **Approach:** Poll `/v2/sales` every 5-10 minutes to track new orders
- **Cost:** 144-288 requests/day (acceptable within undocumented limits)

### Code Example: First API Call
```javascript
// Node.js - Get all products
const axios = require('axios');

const ACCESS_TOKEN = 'your_bearer_token_here';

async function getProducts() {
  try {
    const response = await axios.get('https://api.gumroad.com/v2/products', {
      headers: {
        'Authorization': `Bearer ${ACCESS_TOKEN}`
      }
    });

    console.log('Products:', response.data.products);
    return response.data.products;
  } catch (error) {
    if (error.response?.status === 429) {
      console.log('Rate limited. Retry after backoff.');
    }
    throw error;
  }
}

// Get sales
async function getSales() {
  try {
    const response = await axios.get('https://api.gumroad.com/v2/sales', {
      headers: {
        'Authorization': `Bearer ${ACCESS_TOKEN}`
      }
    });

    console.log('Sales:', response.data.sales);
    return response.data.sales;
  } catch (error) {
    console.error('Error fetching sales:', error.response?.data || error.message);
  }
}

// Call it
getProducts().then(products => {
  console.log(`Found ${products.length} products`);
}).catch(err => console.error(err));
```

### Production Readiness
- **Documentation:** Minimal (endpoints guessed from SDKs)
- **Stability:** Production-viable, used by many integrations
- **Breaking Changes:** Possible (undocumented API)
- **Support:** Community SDKs available (gumroad-api npm package)

---

## 2. ETSY API v3

### Authentication
- **Type:** OAuth 2.0 with PKCE (Proof Key for Code Exchange)
- **Flow:** Authorization Code Grant (RFC 7636 compliant)
- **Token Endpoint:** `https://api.etsy.com/v3/oauth/token`
- **Header Format:** `Authorization: Bearer {ACCESS_TOKEN}` or `?api_key={KEY}`
- **Token Expiration:** Varies; check response header
- **Scopes:** listings_r, listings_w, transactions_r, shop_r, shop_w, etc.

### Key Endpoints
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/v3/application/shops/{shop_id}/listings` | GET | List shop listings |
| `/v3/application/shops/{shop_id}/listings` | POST | Create listing |
| `/v3/application/shops/{shop_id}/listings/{listing_id}` | PUT | Update listing |
| `/v3/application/shops/{shop_id}/listings/{listing_id}/inventory` | GET | Get inventory |
| `/v3/application/shops/{shop_id}/listings/{listing_id}/inventory` | PUT | Update inventory |
| `/v3/application/shops/{shop_id}/receipts` | GET | Fetch sales/receipts |
| `/v3/application/shops/{shop_id}/listings/{listing_id}/images` | POST | Upload image |

**Base URL:** `https://api.etsy.com/v3/` or `https://openapi.etsy.com/v3/`

### Rate Limits
- **Queries Per Second (QPS):** 10 requests/second max
- **Queries Per Day (QPD):** 10,000 requests/24 hours
- **Rate Limit Algorithm:** Sliding Window (rolling 24-hour window)
- **Status Headers:** `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- **Enforcement:** Returns HTTP 429 when exceeded

**Calculation:** ~115 requests/hour or ~1.9 requests/second (safe margin)

### Error Handling
- **429 Status:** Too Many Requests (rate limit exceeded)
- **Retry Strategy:** Exponential backoff with jitter recommended
- **Transient Errors:** 5xx errors should retry with exponential backoff
- **Error Response:** JSON with error code and message
- **Etsy-Specific Codes:**
  - 429 / 613 = API rate limit exceeded
  - 400 = Bad request (invalid parameters)
  - 401 = Unauthorized (bad token)
  - 403 = Forbidden (insufficient scopes)

### Polling vs. Webhooks
- **Webhooks:** Not documented in available results
- **Approach:** Poll `/v3/application/shops/{shop_id}/receipts` every 5 minutes
- **Cost:** 288 requests/day (well within 10,000 daily limit)

### Code Example
```javascript
// Node.js - Etsy API first call
const axios = require('axios');

const SHOP_ID = 'your_shop_id';
const ACCESS_TOKEN = 'your_oauth_access_token';

async function listListings() {
  try {
    const response = await axios.get(
      `https://api.etsy.com/v3/application/shops/${SHOP_ID}/listings`,
      {
        headers: {
          'Authorization': `Bearer ${ACCESS_TOKEN}`,
          'x-api-key': 'your_api_key' // if required
        }
      }
    );

    console.log('Listings:', response.data.results);
    console.log('Rate limit remaining:', response.headers['x-ratelimit-remaining']);
    return response.data.results;
  } catch (error) {
    if (error.response?.status === 429) {
      const resetTime = error.response.headers['x-ratelimit-reset'];
      console.log(`Rate limited. Reset at: ${new Date(resetTime * 1000)}`);
      // Implement exponential backoff
    }
    throw error;
  }
}

// Fetch sales
async function getReceipts() {
  try {
    const response = await axios.get(
      `https://api.etsy.com/v3/application/shops/${SHOP_ID}/receipts`,
      {
        headers: {
          'Authorization': `Bearer ${ACCESS_TOKEN}`
        },
        params: {
          limit: 100,
          sort_order: 'descending'
        }
      }
    );

    return response.data.results;
  } catch (error) {
    console.error('Error fetching receipts:', error.response?.data || error.message);
  }
}

listListings().then(listings => {
  console.log(`Found ${listings.length} listings`);
});
```

### Production Readiness
- **Documentation:** Excellent (official, comprehensive)
- **Stability:** Production-ready, actively maintained
- **Breaking Changes:** Etsy provides migration guides
- **Support:** Official developer support and community SDKs

---

## 3. WORDPRESS REST API

### Authentication
- **Type:** JWT (JSON Web Token) via plugin or API keys
- **Plugin:** JWT Authentication for WP REST API (community-maintained)
- **Token Endpoint:** `/wp-json/jwt-auth/v1/token`
- **Header Format:** `Authorization: Bearer {JWT_TOKEN}`
- **Token Expiration:** Default 10 minutes (configurable via wp-config.php)
- **Alternative:** Application passwords (native WP 5.6+)

### Key Endpoints
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/wp-json/wp/v2/posts` | POST | Create post |
| `/wp-json/wp/v2/posts/{id}` | PUT | Update post |
| `/wp-json/wp/v2/media` | POST | Upload media/featured image |
| `/wp-json/wp/v2/posts/{id}` | GET | Fetch post details |

**Base URL:** `https://yourdomain.com/wp-json/`

### Rate Limits
- **Default:** No built-in rate limiting (unlimited by default)
- **QPS:** Depends on server capacity
- **Options:**
  - Use plugin like "WP Rate Limit" to enforce limits
  - Typical recommendation: 60 requests/minute per IP
- **HTTP Status:** 429 if rate limit plugin is installed

### Error Handling
- **Authentication Errors:**
  - 401 Unauthorized (invalid token, expired)
  - "jwt_auth_bad_auth_header" (malformed header)
- **Validation Errors:** 400 Bad Request
- **Retry Strategy:**
  - Refresh JWT token on 401 and retry
  - Exponential backoff for 5xx errors
- **Response Format:** JSON with error code and message

### Featured Image Upload Process
**Step 1:** Upload media file
**Step 2:** Update post with media ID

### Polling vs. Webhooks
- **Webhooks:** Not standard; use custom plugin hooks
- **Approach:** No need to poll—WordPress is typically your own server, push content directly
- **Method:** POST directly to create/update endpoints

### Code Example: Create Post with Featured Image
```javascript
// Node.js - WordPress REST API
const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');

const WP_URL = 'https://yourdomain.com';
const WP_USER = 'your_username';
const WP_PASSWORD = 'your_app_password'; // Application password, not real password
const JWT_TOKEN = 'your_jwt_token_here'; // Or use basic auth instead

// Option 1: JWT Authentication
async function getJWTToken() {
  try {
    const response = await axios.post(
      `${WP_URL}/wp-json/jwt-auth/v1/token`,
      {
        username: WP_USER,
        password: WP_PASSWORD
      }
    );
    return response.data.token;
  } catch (error) {
    console.error('JWT auth failed:', error.response?.data);
  }
}

// Create post with featured image
async function createPostWithImage(title, content, imagePath) {
  try {
    const token = await getJWTToken();

    // Step 1: Upload featured image
    const formData = new FormData();
    formData.append('file', fs.createReadStream(imagePath));

    const mediaResponse = await axios.post(
      `${WP_URL}/wp-json/wp/v2/media`,
      formData,
      {
        headers: {
          ...formData.getHeaders(),
          'Authorization': `Bearer ${token}`
        }
      }
    );

    const mediaId = mediaResponse.data.id;
    console.log(`Image uploaded with ID: ${mediaId}`);

    // Step 2: Create post with featured image
    const postResponse = await axios.post(
      `${WP_URL}/wp-json/wp/v2/posts`,
      {
        title: title,
        content: content,
        status: 'publish',
        featured_media: mediaId
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    );

    console.log(`Post created with ID: ${postResponse.data.id}`);
    return postResponse.data;
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
  }
}

// Usage
createPostWithImage(
  'My First Post',
  'This is the post content',
  './image.jpg'
).then(post => {
  console.log('Post successfully created:', post.link);
});
```

### Production Readiness
- **Documentation:** Official, excellent (WordPress.org)
- **Stability:** Stable, built into WordPress core
- **Rate Limiting:** Not enforced by default; requires plugin
- **Support:** Extensive community support

---

## 4. MEDIUM API

### Authentication
- **Type:** OAuth 2.0 with self-issued tokens (preferred)
- **Token Method:** Self-issued access tokens (recommended)
- **Endpoint:** Browser-based OAuth (legacy, not recommended)
- **Header Format:** `Authorization: Bearer {ACCESS_TOKEN}`
- **Token Expiration:** Varies; Medium doesn't publicly document

### Key Endpoints
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/v1/me` | GET | Get authenticated user |
| `/v1/publications` | GET | List user's publications |
| `/v1/users/{id}/posts` | POST | Create article |
| `/v1/publications/{id}/posts` | POST | Publish to publication |

**Base URL:** `https://api.medium.com/v1/`

### Limitations
- **Official API Status:** No longer actively maintained by Medium
- **Article Creation:** Requires user to be writer or editor in publication
- **Data Extraction:** Official API very limited; unofficial Medium API exists for reading
- **Publishing:** Limited programmatic publishing capabilities

### Rate Limits
- **Documented Limits:** NOT publicly available
- **Assumption:** Unknown; conservative estimate 1-2 requests/second
- **Enforcement:** Likely HTTP 429 when exceeded
- **Reset:** No documented reset period

### Error Handling
- **401 Unauthorized:** Invalid token
- **403 Forbidden:** User not writer/editor in publication
- **429:** Rate limit (assumed)
- **Retry Strategy:** Exponential backoff on transient errors

### Polling vs. Webhooks
- **Webhooks:** Not documented
- **Approach:** No real-time sync needed; publish directly via API
- **Cost:** One request per article published

### Code Example
```javascript
// Node.js - Medium API
const axios = require('axios');

const MEDIUM_TOKEN = 'your_self_issued_token_here';
const PUBLICATION_ID = 'your_publication_id';

async function getMeUser() {
  try {
    const response = await axios.get(
      'https://api.medium.com/v1/me',
      {
        headers: {
          'Authorization': `Bearer ${MEDIUM_TOKEN}`,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      }
    );

    console.log('User:', response.data.data);
    return response.data.data;
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
  }
}

async function createArticle(publicationId, title, content) {
  try {
    const response = await axios.post(
      `https://api.medium.com/v1/publications/${publicationId}/posts`,
      {
        title: title,
        contentFormat: 'html',
        content: content,
        publishStatus: 'publish'
      },
      {
        headers: {
          'Authorization': `Bearer ${MEDIUM_TOKEN}`,
          'Content-Type': 'application/json'
        }
      }
    );

    console.log('Article created:', response.data.data.url);
    return response.data.data;
  } catch (error) {
    console.error('Error creating article:', error.response?.data || error.message);
  }
}

getMeUser().then(user => {
  console.log(`Authenticated as: ${user.name}`);
});
```

### Production Readiness
- **Documentation:** Minimal (official API no longer maintained)
- **Stability:** Limited; API may change without warning
- **Breaking Changes:** Possible
- **Support:** Community only; Medium does not actively support API
- **Alternative:** Unofficial Medium API for content reading only

---

## 5. REDBUBBLE (No Official API)

### Authentication
- **Type:** Web scraping via Selenium/Puppeteer
- **Login:** Username/password automation
- **Session Management:** Browser cookies
- **API:** No official public API available

### Key Operations
| Operation | Method | Tool |
|-----------|--------|------|
| Upload design | Form-based | Selenium, Puppeteer |
| Set product tags | DOM interaction | Puppeteer |
| Configure pricing | Form filling | Selenium |
| Track uploads | Page scraping | Cheerio, BeautifulSoup |

### Automation Approaches
1. **Selenium + ChromeDriver** (most common)
   - Automate browser actions
   - Fill forms, upload images
   - Handle dynamic content
   - Headless or headed mode

2. **Puppeteer** (Node.js alternative)
   - Lightweight, no separate driver
   - Good for image uploads
   - DOM interaction scripting

3. **Third-Party Services**
   - LazyMerch Automation (commercial, supports Copy Upload)
   - Flying Upload (cloud-based, no request limits)

### Rate Limits
- **Enforcement:** Bot detection via reCAPTCHA, IP blocking
- **Safe Approach:** 1 upload per minute, randomized delays
- **Session Timeouts:** 30-minute sessions recommended
- **Daily Limit:** ~50 uploads/day sustainable (test to confirm)

### Error Handling
- **CAPTCHA Detection:** Need manual intervention or third-party CAPTCHA solver
- **Login Failures:** Rate limited or account flagged
- **Upload Failures:** Image format, size, or content policy issues
- **Session Expired:** Re-login and retry
- **Retry Strategy:** 3 attempts with 5-second backoff, then manual review

### Code Example: Redbubble Upload via Puppeteer
```javascript
// Node.js - Redbubble automation (simplified)
const puppeteer = require('puppeteer');
const fs = require('fs');

async function uploadDesignToRedbubble(email, password, imagePath, title, tags) {
  let browser;
  try {
    browser = await puppeteer.launch({
      headless: false, // Set to true for production
      args: ['--no-sandbox']
    });

    const page = await browser.newPage();

    // Login
    await page.goto('https://www.redbubble.com/auth/login');
    await page.type('input[type="email"]', email);
    await page.type('input[type="password"]', password);
    await page.click('button[type="submit"]');

    // Wait for dashboard
    await page.waitForNavigation();
    console.log('Logged in successfully');

    // Navigate to upload page
    await page.goto('https://www.redbubble.com/upload');

    // Upload image
    const fileInput = await page.$('input[type="file"]');
    await fileInput.uploadFile(imagePath);
    console.log('Image uploaded');

    // Fill in details
    await page.waitForSelector('input[name="title"]');
    await page.type('input[name="title"]', title);

    // Add tags
    await page.click('input[name="tags"]');
    for (const tag of tags.split(',')) {
      await page.type('input[name="tags"]', tag.trim());
      await page.keyboard.press('Enter');
    }

    // Submit
    await page.click('button[type="submit"]');
    await page.waitForNavigation();

    console.log('Design uploaded successfully');
    return true;
  } catch (error) {
    console.error('Upload failed:', error.message);
    return false;
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}

// Usage
uploadDesignToRedbubble(
  'your@email.com',
  'your_password',
  './design.png',
  'Cool T-Shirt Design',
  'tshirt, design, cool, trending'
).then(success => {
  console.log(`Upload ${success ? 'succeeded' : 'failed'}`);
});
```

### Production Readiness
- **Documentation:** None (no official API)
- **Stability:** Fragile; Redbubble UI changes break scripts
- **Risk:** Account flagged for bot-like behavior
- **Maintenance:** Requires active monitoring and script updates
- **Support:** No official support for automation

---

## Comparison Table

| Aspect | Gumroad | Etsy | WordPress | Medium | Redbubble |
|--------|---------|------|-----------|--------|-----------|
| **API Type** | REST (OAuth 2.0) | REST (OAuth 2.0 PKCE) | REST (JWT plugin) | REST (OAuth 2.0) | Web Scraping |
| **Documentation** | Minimal | Excellent | Excellent | Minimal | None |
| **Production Ready** | Yes (risky) | Yes (stable) | Yes (stable) | No (deprecated) | No (fragile) |
| **Rate Limits (QPS)** | Unknown (~1-2) | 10 QPS | 60/min (configurable) | Unknown (~1-2) | ~1/min (bot detection) |
| **Rate Limits (Daily)** | Unknown | 10,000/day | Unlimited | Unknown | ~50 sustainable |
| **Webhooks** | None | None | Custom plugins | None | N/A |
| **Polling Cost** | 144-288 req/day | 288 req/day | 0 (push-based) | 0 (push-based) | 50-100 actions/day |
| **Error Recovery** | Exponential backoff | Exponential backoff | Refresh token + retry | Exponential backoff | Re-login + retry |
| **Auth Complexity** | Low (Bearer token) | Medium (OAuth PKCE) | Low (JWT token) | Low (Bearer token) | High (browser automation) |
| **Image Upload** | Via product create | Via multipart POST | Via media endpoint | Via article content | Via form fill + Selenium |
| **Data Extraction** | Easy (REST) | Easy (REST) | Easy (REST) | Limited (API deprecated) | Hard (scraping) |
| **Recommended Use** | Sales tracking | Product/inventory mgmt | Content publishing | Limited use | Last resort only |

---

## Recommended Polling/Webhook Approach

### Strategy by Platform

**Gumroad:**
- **Approach:** Poll `/v2/sales` every 5-10 minutes
- **Requests:** 144 requests/day
- **Retry:** Exponential backoff on 429
- **Database:** Store last_synced_at to avoid full refetch

**Etsy:**
- **Approach:** Poll `/v3/receipts` every 5 minutes
- **Requests:** 288 requests/day (well under 10,000 limit)
- **Retry:** Exponential backoff + jitter on 429
- **Database:** Track receipt_id to avoid duplicates

**WordPress:**
- **Approach:** Direct POST to `/wp-json/wp/v2/posts`
- **No polling needed:** Push content directly
- **Retry:** Handle JWT token expiration (refresh & retry)
- **Error recovery:** Manual review on 400/401 errors

**Medium:**
- **Approach:** Direct POST to `/v1/publications/{id}/posts`
- **No polling needed:** Push content directly
- **Retry:** Handle 403 (user not writer/editor)
- **Fallback:** If official API fails, post manually to Medium.com

**Redbubble:**
- **Approach:** Puppeteer headless browser session
- **Frequency:** 1 upload per 60 seconds minimum
- **Session Management:** Reopen browser every 50 uploads or 30 minutes
- **Error Recovery:** Captcha detection → manual intervention required
- **Monitoring:** Log all failures for manual review

---

## Gumroad Authentication Code Example (Expanded)

```javascript
// Gumroad OAuth 2.0 Full Implementation
const express = require('express');
const axios = require('axios');
const crypto = require('crypto');

const app = express();

// Config
const GUMROAD_CLIENT_ID = 'your_client_id';
const GUMROAD_CLIENT_SECRET = 'your_client_secret';
const REDIRECT_URI = 'http://localhost:3000/callback';
const GUMROAD_AUTH_URL = 'https://gumroad.com/oauth';
const GUMROAD_TOKEN_URL = 'https://gumroad.com/oauth/token';
const GUMROAD_API_URL = 'https://api.gumroad.com/v2';

// Step 1: Initiate OAuth flow
app.get('/auth', (req, res) => {
  const state = crypto.randomBytes(16).toString('hex');
  req.session.oauthState = state;

  const authUrl = `${GUMROAD_AUTH_URL}?client_id=${GUMROAD_CLIENT_ID}&redirect_uri=${encodeURIComponent(REDIRECT_URI)}&state=${state}&response_type=code&scope=products_r sales_r`;

  res.redirect(authUrl);
});

// Step 2: Handle callback and exchange code for token
app.get('/callback', async (req, res) => {
  const { code, state } = req.query;

  // Verify state
  if (state !== req.session.oauthState) {
    return res.status(403).send('Invalid state parameter');
  }

  try {
    // Exchange authorization code for access token
    const tokenResponse = await axios.post(GUMROAD_TOKEN_URL, {
      client_id: GUMROAD_CLIENT_ID,
      client_secret: GUMROAD_CLIENT_SECRET,
      redirect_uri: REDIRECT_URI,
      grant_type: 'authorization_code',
      code: code
    });

    const accessToken = tokenResponse.data.access_token;
    const refreshToken = tokenResponse.data.refresh_token;

    // Store tokens securely (database/session)
    req.session.gumroadToken = accessToken;
    req.session.gumroadRefreshToken = refreshToken;

    console.log('Access token obtained:', accessToken.substring(0, 20) + '...');

    res.send('Authorization successful! Redirecting...');
    res.redirect('/dashboard');
  } catch (error) {
    console.error('Token exchange failed:', error.response?.data);
    res.status(500).send('Authentication failed');
  }
});

// Step 3: Make authenticated API calls
app.get('/api/products', async (req, res) => {
  const accessToken = req.session.gumroadToken;

  try {
    const response = await axios.get(`${GUMROAD_API_URL}/products`, {
      headers: {
        'Authorization': `Bearer ${accessToken}`
      }
    });

    res.json(response.data);
  } catch (error) {
    if (error.response?.status === 429) {
      return res.status(429).json({ error: 'Rate limited. Retry after backoff.' });
    }
    res.status(error.response?.status || 500).json({
      error: error.response?.data || error.message
    });
  }
});

// Step 4: Refresh token when expired
async function refreshGumroadToken(refreshToken) {
  try {
    const response = await axios.post(GUMROAD_TOKEN_URL, {
      client_id: GUMROAD_CLIENT_ID,
      client_secret: GUMROAD_CLIENT_SECRET,
      grant_type: 'refresh_token',
      refresh_token: refreshToken
    });

    return response.data.access_token;
  } catch (error) {
    console.error('Token refresh failed:', error.response?.data);
    throw error;
  }
}

app.listen(3000, () => {
  console.log('OAuth server running on http://localhost:3000');
});
```

---

## Recommendations for CTMO

### Immediate Priority (For COO Execution)

1. **Gumroad Integration (High Priority)**
   - Implement sales polling every 5 minutes
   - Store in PostgreSQL: gumroad_sales table
   - Exponential backoff on 429
   - n8n workflow for daily summary

2. **Etsy Integration (High Priority)**
   - Implement inventory sync every 5 minutes
   - Implement receipt polling for sales tracking
   - Store in PostgreSQL: etsy_listings, etsy_sales tables
   - Use rate limit headers to optimize polling

3. **WordPress Integration (Medium Priority)**
   - Set up JWT authentication plugin
   - Create n8n workflow to POST blog articles
   - No polling needed—push-based
   - Featured image upload requires two-step process

4. **Medium Integration (Low Priority)**
   - Assess viability given deprecated official API
   - Consider using unofficial Medium API for reading only
   - Direct article publishing may require manual steps
   - Not recommended for full automation

5. **Redbubble Integration (Low Priority—Fragile)**
   - Implement only if no other POD options available
   - Use Puppeteer for headless automation
   - Set aggressive rate limiting (1 upload/min)
   - Requires manual CAPTCHA intervention
   - High maintenance burden

### Architecture Decisions Needed

1. **Polling Database:** PostgreSQL tables for tracking last_synced_at
2. **Retry Handler:** Implement in n8n or Node.js service
3. **Error Logging:** Document all API failures for COO review
4. **Authentication Storage:** Secure vault for OAuth tokens
5. **Monitoring:** Alert on 429 rates, token expiration, auth failures

---

## Sources
- [Gumroad API Documentation](https://gumroad.com/api)
- [Etsy Open API v3 - Rate Limits](https://developer.etsy.com/documentation/essentials/rate-limits/)
- [Etsy Open API v3 - Authentication](https://developer.etsy.com/documentation/essentials/authentication/)
- [WordPress REST API Handbook](https://developer.wordpress.org/rest-api/)
- [JWT Authentication for WP REST API Plugin](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
- [Medium API Documentation](https://github.com/Medium/medium-api-docs)
- [Gumroad API Essentials - Rollout](https://rollout.com/integration-guides/gumroad/api-essentials/)
- [Etsy API Essentials - Rollout](https://rollout.com/integration-guides/etsy/api-essentials/)
- [WordPress REST API Featured Image Upload](https://rudrastyh.com/wordpress/upload-featured-image-rest-api.html)
- [LazyMerch Automation - Redbubble](https://automation-docs.lazymerch.com/upload/redbubble)
- [Redbubble Automation via Puppeteer - GitHub](https://github.com/jongan69/Redbubble_Uploader)
