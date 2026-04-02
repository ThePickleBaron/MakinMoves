# Platform API Mapping & Implementation Prioritization
**Date:** 2026-03-29
**Objective:** Map 5 revenue platforms for n8n integration in 36 hours
**Platforms:** Gumroad, Etsy, Redbubble, Medium, WordPress

---

## Executive Summary

**Bottom Line Up Front:**
- **Day 1 (Proof of Concept):** Gumroad + Etsy (both have solid API docs, n8n nodes)
- **Day 2 (Scale):** Add Medium (read-only), WordPress (flexible), Redbubble (scraping fallback)
- **Simplest First:** Gumroad (OAuth token-based, n8n Trigger node exists, clear endpoints)
- **Fastest Revenue Signal:** Etsy (highest transaction volume, hourly possible)
- **Time Budget:** Gumroad 4h, Etsy 6h, Medium 3h, WordPress 4h, Redbubble 2h (scraping)

---

## 1. API CAPABILITY MATRIX

| Platform | Publishing API | Revenue API | Auth Method | Rate Limit | Free Tier | n8n Node | Priority |
|----------|---|---|---|---|---|---|---|
| **Gumroad** | ❌ No | ✅ Yes | OAuth 2.0 | Undocumented (429 on exceed) | ✅ Free | ✅ Built-in Trigger | **P0** |
| **Etsy** | ✅ Yes | ✅ Yes | OAuth 2.0 | 10 QPS / 10K QPD | ✅ Free tier (10K/day) | ✅ HTTP Request | **P0** |
| **Redbubble** | ❌ No | ⚠️ Dashboard only | None required | N/A | ✅ Analytics dashboard | ❌ Scraping only | **P2** |
| **Medium** | ✅ Publishing API | ❌ Read-only | API Key | Not documented | ✅ Free | ❌ HTTP only | **P1** |
| **WordPress** | ✅ REST API | ✅ Custom via plugins | App Password / Basic | Host-dependent | ✅ Free | ✅ Built-in + HTTP | **P1** |

---

## 2. DETAILED PLATFORM ANALYSIS

### Platform 1: GUMROAD (P0 - Day 1)

**Overview:**
Gumroad is a simple digital product platform with straightforward API access for revenue tracking.

**API Capabilities:**
- **Publishing:** NO - cannot create products via API
- **Revenue/Sales:** YES - full transaction history available
- **Base URL:** `https://api.gumroad.com/v2/`
- **Key Endpoints:**
  - `GET /products` - List all products
  - `GET /products/{id}/sales` - Get sales for product
  - `POST /products/{id}/files` - Add files to product (workaround for "publishing")
  - `GET /me` - Get account info

**Authentication:**
- Method: OAuth 2.0 access token (simpler: direct API token generation)
- Where to get: Gumroad dashboard → "Generate access token" button
- Format: Bearer token in Authorization header
- **Credentials format:** Single token string

**Rate Limits:**
- Publicly documented: NO
- Observed behavior: 429 responses when exceeded
- Recommendation: Implement 1-2 second delays between requests
- Conservative estimate: 30-60 requests/minute safe

**Revenue Data Access:**
- Granularity: Per-transaction data available
- Update frequency: Real-time via API
- Data points: `amount`, `customer_email`, `product_id`, `created_at`, `license_key`
- Hourly polling: YES, feasible (likely 100-200 sales/hour max per product)

**Privacy/PII Considerations:**
- Customer email addresses are returned in sales data
- Must comply with GDPR (store, encrypt, don't expose in logs)
- Recommendation: Hash emails before logging, use separate PII database

**n8n Integration:**
- Native node: YES - `Gumroad Trigger` (for webhooks)
- Alternative: HTTP Request node (preferred for polling)
- Credentials: API token in n8n credentials manager
- Setup time: 15 minutes

**Limitations:**
- Cannot create/publish products via API
- Rate limits not documented (trial & observe)
- No bulk operations
- Webhook support via n8n Trigger node

---

### Platform 2: ETSY (P0 - Day 1)

**Overview:**
Etsy has mature REST API v3 with full publishing + analytics capabilities.

**API Capabilities:**
- **Publishing:** YES - create/update listings, upload images
- **Analytics:** YES - hourly/daily stats, revenue data
- **Base URL:** `https://api.etsy.com/v3/` or `https://openapi.etsy.com/v3/`
- **Key Endpoints:**
  - `GET /users/{user_id}/listings/active` - List active listings
  - `GET /shops/{shop_id}/listings/{listing_id}/stats` - Sales stats
  - `POST /listings` - Create new listing
  - `GET /users/{user_id}/payments` - Payment history

**Authentication:**
- Method: OAuth 2.0 (required for all v3 endpoints)
- Scopes: Varies by endpoint (e.g., `listings_r`, `transactions_r`, `shops_r`)
- Setup: Create app in Etsy developer portal, get client ID/secret
- Token lifetime: Long-lived if using refresh tokens

**Rate Limits (Critical):**
- Queries Per Second (QPS): 10 requests/second max
- Queries Per Day (QPD): 10,000 requests/24 hours (rolling window)
- Algorithm: Sliding window (not fixed 24h blocks)
- Behavior: 429 Too Many Requests when exceeded
- Header details: Returns `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

**Revenue Data Access:**
- Granularity: Per-transaction (via payments or transaction endpoints)
- Update frequency: Near real-time (5-15 min delay typical)
- Data points: `transaction_id`, `amount`, `buyer_username`, `listing_id`, `quantity`, `created_date`
- Hourly polling: YES, but must respect rate limits
- Daily polling: Highly recommended (safer, same-day data)

**Privacy/PII Considerations:**
- Buyer usernames returned (pseudonymous, not direct email)
- Minimal PII exposure vs. Gumroad
- Still log safely, no customer data in unencrypted logs

**n8n Integration:**
- Native node: YES - `HTTP Request` can use predefined Etsy credentials
- Alternative: Build custom with HTTP Request + OAuth
- Credentials: Client ID + Client Secret + OAuth token management
- Setup time: 30-45 minutes (OAuth callback configuration)

**Limitations:**
- OAuth setup more complex than Gumroad
- Rate limits require careful batching
- Scopes must be requested per app
- Limited to Etsy's defined listing fields (no custom metadata)

**Recommendation:**
- Use sliding window rate limit tracking
- Cache listing data (doesn't change hourly)
- Query stats once per day (safer, still gives daily revenue)
- Batch multiple stats queries in single workflow run

---

### Platform 3: MEDIUM (P1 - Day 2)

**Overview:**
Medium has limited API access; no earnings API. Must use dashboard scraping or read stats manually.

**API Capabilities:**
- **Publishing:** YES - via official but deprecated API
- **Analytics/Revenue:** PARTIAL - read-only stats page, no direct API
- **Base URL:** `https://api.medium.com/v1/` (deprecated)
- **Key Endpoints:**
  - `GET /me` - Get authenticated user info
  - `POST /users/{id}/posts` - Create post (deprecated, may not work)
  - Stats: Scrape from `https://medium.com/me/stats` (dashboard only)

**Authentication:**
- Method: API Key (integration token)
- Where to get: Medium dashboard → Settings → Integration tokens
- Format: Bearer token in Authorization header
- Limitation: Archive removed March 2, 2023 — API deprecated but tokens still work for basic ops

**Rate Limits:**
- Officially documented: NO
- Safe assumption: 100 requests/hour (very conservative)
- Recommendation: Batch all Medium operations, run once/day

**Revenue Data Access:**
- Direct API: NO - earnings API does not exist
- Workaround 1: Scrape Medium stats page (requires session management)
- Workaround 2: Manual daily check + manual logging
- 2026 Changes: Medium restructured Partner Program starting October 2025
  - Now rewards external traffic (from social, Reddit, other blogs)
  - Earnings updated daily, finalized in 48 hours
- Recommendation: Daily manual check preferred (simpler than scraping)

**Privacy/PII Considerations:**
- No customer data exposed via API
- Only user's own stats accessible
- Low PII risk

**n8n Integration:**
- Native node: NO
- Method: HTTP Request node (read posts, create posts)
- Status page scraping: Requires Puppeteer or Cheerio (HTML parsing)
- Setup time: 30 minutes (HTTP) + 60 minutes (scraping, optional)

**Limitations:**
- API deprecated (unsupported but functional)
- No earnings API available
- Scraping Medium's stats page fragile (HTML structure can change)
- Rate limits unknown, keep requests minimal

**Recommendation for CTMO:**
- **Skip API publishing** (deprecated)
- **Use manual dashboard checks** + log to database daily
- **Implement dashboard scraper only if volume justifies** (e.g., 50+ articles)
- For MVP: Simple daily reminder to check + log earnings manually

---

### Platform 4: WORDPRESS (P1 - Day 1.5)

**Overview:**
WordPress REST API is flexible and powerful; rate limits depend on hosting.

**API Capabilities:**
- **Publishing:** YES - create/update posts, pages, custom post types
- **Analytics:** CONDITIONAL - requires analytics plugin (e.g., MonsterInsights, Jetpack)
- **Base URL:** `https://yoursite.com/wp-json/wp/v2/`
- **Key Endpoints:**
  - `GET /posts` - List posts
  - `POST /posts` - Create new post
  - `PUT /posts/{id}` - Update post
  - Custom analytics: Depends on plugin (no standard endpoint)

**Authentication:**
- Method 1: Application Passwords (recommended for n8n)
  - What: 24-character auto-generated API key
  - Where to get: Users → Your Profile → Application Passwords section
  - Requires: WordPress 5.6+, HTTPS, Administrator/Editor role
  - Format: Basic Auth (username + app password as password)
- Method 2: OAuth 2.0 (if site configured)
- Method 3: JWT (custom plugins)

**Rate Limits:**
- Core WP REST API: NO global limits
- Provider-specific:
  - Self-hosted: Depends on server/CDN configuration
  - WordPress.com: Explicit rate limits + fair-use policy
  - Managed hosts (WP Engine, etc.): May implement rate limiting
- Best practice: Check with hosting provider

**Revenue Data Access:**
- Direct API: NO (REST API doesn't track earnings)
- Workaround: Use affiliate tracking plugins (e.g., Refersion, AAWP, LeadDyno)
  - These plugins expose data via REST endpoints (custom)
  - Or manual export from plugin dashboards
- Affiliate plugin options:
  - Amazon Associates Widget Pro (AAWP) - has API
  - Refersion - has API
  - Custom post type for affiliate clicks/earnings
- Recommendation: Create custom post type `affiliate_earnings` (manual daily log)

**Privacy/PII Considerations:**
- Custom post types can be private (not exposed via API)
- Application Passwords are revokable per integration
- No customer data exposed (posts are public)
- Low PII risk if using private CPTs for earnings

**n8n Integration:**
- Native node: YES - `WordPress` node (basic posts)
- HTTP Request: YES - full REST API access
- Affiliate data: HTTP Request node (custom plugin endpoints)
- Setup time: 20 minutes (Application Password) + 30 min (custom post type setup)

**Limitations:**
- No built-in analytics API
- Custom post types must be registered (code required)
- Rate limiting depends entirely on hosting
- Affiliate plugin compatibility varies

**Recommendation for CTMO:**
- Use Application Password authentication (simplest)
- Create custom post type for earnings tracking:
  ```php
  register_post_type( 'affiliate_earnings', [
    'public' => false,
    'supports' => ['title', 'custom-fields']
  ]);
  ```
- Query via REST: `GET /wp/v2/affiliate_earnings` (private to authenticated users)
- Expose revenue data as post custom fields
- n8n workflow: Daily check, create/update earnings post via HTTP Request

---

### Platform 5: REDBUBBLE (P2 - Day 2, Optional)

**Overview:**
Redbubble has NO official public API. Revenue tracking requires scraping or manual dashboard access.

**API Capabilities:**
- **Publishing:** NO official API
- **Revenue:** NO API - analytics dashboard only
- **Alternative:** Third-party scraping APIs (Apify, Oxylabs)

**Authentication:**
- Method: Web scraping (session cookies, user agent spoofing)
- No official API key mechanism
- Rate limits: Redbubble actively blocks scrapers (403 Forbidden)

**Rate Limits:**
- Scraping: Blocked/rate-limited by Redbubble
- Recommended: Use legit dashboard access only (manual)
- Third-party APIs: Pay services like Apify ($)

**Revenue Data Access:**
- Official method: Redbubble Artist Analytics Dashboard
  - Link: https://www.redbubble.com/dashboard/analytics
  - Data: Sales, views, conversion rates, earnings (daily)
  - Manual export: CSV or manual logging
- Scraping option: Risky, may violate ToS, blocks applied frequently

**Privacy/PII Considerations:**
- Manual dashboard access: No PII exposure risk
- Scraping: Mimics user behavior (technically ToS violation)
- Recommendation: Use official dashboard only

**n8n Integration:**
- Native node: NO
- Scraping node: Puppeteer (browser automation) - fragile
- Third-party APIs: Apify/Oxylabs (costs money)
- Best option: Manual daily dashboard check + log earnings

**Limitations:**
- NO official API
- Scraping violates ToS
- Rate limiting by Redbubble (IP blocking)
- No programmatic revenue data access

**Recommendation for CTMO:**
- **SKIP API integration** (not feasible without ToS violation)
- **Use manual daily dashboard logging** (5 minutes/day)
- **Log earnings as custom post type** (same structure as WordPress affiliate earnings)
- **Consider only if Redbubble volume justifies** (i.e., >$50/day)

---

## 3. IMPLEMENTATION PRIORITY RANKING

### Ranking Rationale

| Rank | Platform | Why | Time | Revenue Potential | n8n Readiness |
|------|----------|-----|------|-------------------|---|
| **P0-1** | **Gumroad** | Simplest API, clear docs, n8n Trigger ready, immediate revenue signal | 4h | Medium (20-100/day) | ⭐⭐⭐ Ready |
| **P0-2** | **Etsy** | Highest transaction volume, mature API, hourly possible, proven automation | 6h | High (100-500+/day) | ⭐⭐⭐ Ready |
| **P1-1** | **WordPress** | Flexible, auth simple, custom post types easy, affiliate data trackable | 4h | Medium (50-200/day) | ⭐⭐⭐ Ready |
| **P1-2** | **Medium** | Low setup, but no earnings API (manual workaround), lower priority | 3h | Low (10-50/day) | ⭐⭐ Partial |
| **P2** | **Redbubble** | NO API, scraping blocks applied, manual only | 2h setup | Medium (depends) | ❌ Not feasible |

### Recommended Rollout Schedule

**Day 1 (36h starting now):**
- **Hour 0-4:** Gumroad (proof of concept, first $$$ signal)
- **Hour 4-10:** Etsy (scale revenue capture)
- **Hour 10-14:** WordPress (diversify revenue sources)
- **Hour 14-17:** Medium (read-only, lightweight)
- **Hour 17-19:** Redbubble (manual fallback)
- **Hour 19-36:** Testing, error handling, redundancy, documentation

---

## 4. DAY 1 IMPLEMENTATION PLAN (PoC: Gumroad + Etsy)

### Goal
Capture first real revenue transaction data from Gumroad + Etsy within 12 hours. Prove workflow automation works end-to-end.

### Step-by-Step: GUMROAD

**4.1.1 Get API Token**
1. Log into Gumroad dashboard
2. Click account menu (top-right)
3. Settings → API section
4. Click "Generate access token"
5. Copy token, store securely in n8n credentials

**4.1.2 Database Schema**
```sql
CREATE TABLE gumroad_sales (
  id SERIAL PRIMARY KEY,
  product_id TEXT NOT NULL,
  sale_id TEXT UNIQUE NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  customer_email_hash TEXT NOT NULL,  -- Hash, not plaintext
  created_at TIMESTAMP NOT NULL,
  fetched_at TIMESTAMP DEFAULT NOW(),
  source TEXT DEFAULT 'gumroad'
);

CREATE TABLE gumroad_products (
  id SERIAL PRIMARY KEY,
  product_id TEXT UNIQUE NOT NULL,
  product_name TEXT,
  last_synced TIMESTAMP DEFAULT NOW()
);
```

**4.1.3 n8n Workflow: Gumroad Hourly Poll**
```
Start (hourly trigger)
  ↓
Get Gumroad Products (HTTP GET /products)
  ↓
Loop: For Each Product
  ├→ Get Sales (HTTP GET /products/{id}/sales)
  ├→ Filter: Only new sales (since last_synced)
  ├→ Transform: Hash email, format data
  └→ Write to gumroad_sales table
  ↓
Update product last_synced timestamps
  ↓
Log: Rows inserted, total revenue
  ↓
Error handler: Log failures, alert CTMO on retry exhaustion
```

**4.1.4 Error Handling for Gumroad**
- Expected errors:
  - 401 Unauthorized → Token expired/invalid
  - 429 Too Many Requests → Rate limited
  - Network timeout → Retry with exponential backoff
- Strategy:
  - Implement 2-second delay between product queries
  - Catch 429 → Wait 30s, retry (max 3 times)
  - Catch 401 → Alert CTMO (token issue)
  - Log all failures to `gumroad_errors` table

**4.1.5 Authentication Checklist - GUMROAD**
- [ ] API token generated in Gumroad dashboard
- [ ] Token stored in n8n credentials (encrypted)
- [ ] Token format validated (Bearer: `Authorization: Bearer <token>`)
- [ ] Test API call successful (GET /me)
- [ ] Database credentials added to n8n PostgreSQL config
- [ ] Encryption key for customer email hash configured

---

### Step-by-Step: ETSY

**4.2.1 OAuth Setup (15 min)**
1. Go to https://www.etsy.com/developers
2. Click "Create an app"
3. Fill in app details, agree to ToS
4. Save Client ID + Client Secret
5. Set OAuth redirect URI in n8n config:
   ```
   https://<n8n-instance>/rest/oauth2/callback?service=etsy
   ```
6. Store credentials in n8n Etsy integration

**4.2.2 Database Schema**
```sql
CREATE TABLE etsy_sales (
  id SERIAL PRIMARY KEY,
  listing_id TEXT NOT NULL,
  transaction_id TEXT UNIQUE NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  buyer_username_hash TEXT NOT NULL,
  quantity INT DEFAULT 1,
  created_at TIMESTAMP NOT NULL,
  fetched_at TIMESTAMP DEFAULT NOW(),
  source TEXT DEFAULT 'etsy'
);

CREATE TABLE etsy_listings (
  id SERIAL PRIMARY KEY,
  listing_id TEXT UNIQUE NOT NULL,
  listing_title TEXT,
  last_stats_fetch TIMESTAMP DEFAULT NOW()
);

CREATE TABLE etsy_rate_limit_tracking (
  id SERIAL PRIMARY KEY,
  requests_today INT DEFAULT 0,
  last_reset TIMESTAMP DEFAULT NOW(),
  rolling_window_start TIMESTAMP DEFAULT NOW()
);
```

**4.2.3 n8n Workflow: Etsy Daily Stats Poll**
```
Start (daily trigger, 2am UTC)
  ↓
Check rate limit budget (queries remaining?)
  ↓
Get user's shop info (OAuth, GET /users/me)
  ↓
Get listings (GET /shops/{shop_id}/listings/active)
  ↓
For Each Listing (max 50/day to stay under 10K QPD quota)
  ├→ Get stats (GET /listings/{id}/stats)
  ├→ Parse: transactions, revenue
  ├→ Transform & hash buyer usernames
  └→ Write to etsy_sales table
  ↓
Update rate limit tracker
  ↓
Log: Total revenue, transactions, rate limit remaining
  ↓
Error handler: Log 429 errors, alert if approaching daily limit
```

**4.2.4 Rate Limit Management - ETSY**
- Daily budget: 10,000 QPD
- Conservative allocation:
  - Hourly checks: 100 queries/hour × 24 = 2,400 (sales polling)
  - Daily batch: 1,000 queries (stats, listing updates)
  - Reserve: 6,600 (headroom for retries, manual checks)
- Implementation:
  - Track requests in `etsy_rate_limit_tracking` table
  - Implement sliding window counter (last 24h)
  - If approaching 80% usage, slow down polling
  - Implement jitter (randomize query times) to avoid thundering herd

**4.2.5 Error Handling - ETSY**
- Expected errors:
  - 429 Too Many Requests → Hit rate limit
  - 401 Unauthorized → OAuth token expired
  - 403 Forbidden → Insufficient scopes
- Strategy:
  - Catch 429 → Check Retry-After header, wait + retry (max 3)
  - Catch 401 → Trigger OAuth refresh
  - Catch 403 → Alert CTMO (need to request additional scopes)
  - All errors → Log with timestamp, API endpoint, request details

**4.2.6 Authentication Checklist - ETSY**
- [ ] App created in Etsy developer dashboard
- [ ] Client ID + Secret stored in n8n (encrypted)
- [ ] OAuth redirect URI configured correctly
- [ ] Test OAuth flow completed (get access token)
- [ ] API scopes requested: `listings_r`, `transactions_r`, `shops_r`
- [ ] Access token stored + refresh token mechanism set up
- [ ] Test API call successful (GET /users/me)

---

### Day 1 Testing Checklist
- [ ] Gumroad: Successfully polled 1+ product, fetched sales data
- [ ] Etsy: Successfully authenticated, fetched listings + stats
- [ ] Database: Both tables populated with test data
- [ ] n8n: Both workflows deployed, tested with dry-run
- [ ] Error handling: Tested 429 retry logic, logging
- [ ] Rate limits: Verified no blocks, no excessive requests

---

## 5. DAY 2 SCALING PLAN (Add Medium + WordPress + Redbubble Fallback)

### 5.1 WordPress Integration (4h)

**Setup Application Password**
1. Log into WordPress admin
2. Users → Your Profile
3. Scroll to "Application Passwords"
4. Enter app name: "MakinMoves-n8n"
5. Generate, copy password
6. Store in n8n credentials (username + app password, Basic Auth)

**Create Earnings Custom Post Type**
Register in WordPress functions.php or via plugin:
```php
add_action( 'init', function() {
  register_post_type( 'earnings', [
    'labels' => [ 'name' => 'Earnings' ],
    'public' => false,
    'supports' => [ 'title', 'custom-fields' ],
    'show_in_rest' => true,  // CRITICAL: Expose via REST API
  ]);
});
```

**Database Schema**
```sql
CREATE TABLE wordpress_earnings (
  id SERIAL PRIMARY KEY,
  post_id INT NOT NULL,
  affiliate_program TEXT,  -- e.g., "amazon_associates", "refersion"
  earnings DECIMAL(10, 2),
  clicks INT,
  date DATE NOT NULL,
  fetched_at TIMESTAMP DEFAULT NOW()
);
```

**n8n Workflow: Daily Earnings Log**
```
Start (daily trigger)
  ↓
Check WordPress for latest earnings post
  ↓
If not exists: Create new post for today
  ↓
Update custom fields: affiliate_program, earnings, clicks
  ↓
Sync to analytics database
  ↓
Log success
```

### 5.2 Medium Integration (3h)

**Note:** Medium API deprecated; recommended manual dashboard check.

**Option A: Manual Logging (RECOMMENDED)**
- Daily reminder check: https://medium.com/me/stats
- Copy earnings for day into n8n form or database
- Store in `medium_earnings` table

**Option B: Scraping (if volume justifies)**
- Use Puppeteer in n8n Code node
- Simulate login, navigate to stats page
- Parse earnings from dashboard HTML
- Risk: High fragility, Medium may block

**Database Schema**
```sql
CREATE TABLE medium_earnings (
  id SERIAL PRIMARY KEY,
  earnings DECIMAL(10, 2),
  views INT,
  reads INT,
  date DATE NOT NULL,
  manual_entry BOOLEAN DEFAULT true,
  fetched_at TIMESTAMP DEFAULT NOW()
);
```

### 5.3 Redbubble: Manual Fallback (2h setup)

**Manual Process:**
1. Daily: Check Redbubble dashboard (https://www.redbubble.com/dashboard/analytics)
2. Copy earnings for day
3. Log via form or API call to database

**Database Schema**
```sql
CREATE TABLE redbubble_earnings (
  id SERIAL PRIMARY KEY,
  earnings DECIMAL(10, 2),
  orders INT,
  views INT,
  date DATE NOT NULL,
  manual_entry BOOLEAN DEFAULT true,
  fetched_at TIMESTAMP DEFAULT NOW()
);
```

---

## 6. UNIFIED REVENUE CAPTURE WORKFLOW

### Database: Revenue Summary Table
```sql
CREATE TABLE daily_revenue_summary (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL,
  gumroad_revenue DECIMAL(10, 2) DEFAULT 0,
  etsy_revenue DECIMAL(10, 2) DEFAULT 0,
  wordpress_revenue DECIMAL(10, 2) DEFAULT 0,
  medium_revenue DECIMAL(10, 2) DEFAULT 0,
  redbubble_revenue DECIMAL(10, 2) DEFAULT 0,
  total_revenue DECIMAL(10, 2) GENERATED ALWAYS AS (
    gumroad_revenue + etsy_revenue + wordpress_revenue + medium_revenue + redbubble_revenue
  ),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Master Aggregation Workflow (n8n)
```
Start (daily at 3am UTC)
  ↓
Query gumroad_sales (yesterday)
  ├→ SUM(amount) as gumroad_revenue
  ↓
Query etsy_sales (yesterday)
  ├→ SUM(amount) as etsy_revenue
  ↓
Query wordpress_earnings (yesterday)
  ├→ earnings as wordpress_revenue
  ↓
Query medium_earnings (yesterday)
  ├→ earnings as medium_revenue
  ↓
Query redbubble_earnings (yesterday)
  ├→ earnings as redbubble_revenue
  ↓
INSERT daily_revenue_summary (all revenues)
  ↓
Send summary to CEO/COO:
  - Email with daily revenue breakdown
  - Total daily revenue, trend vs. 7-day avg
  - Top performer (which platform)
  - Alerts if any platform errored
  ↓
Log success
```

---

## 7. ERROR HANDLING PATTERNS

### Pattern 1: Rate Limit (429) Retry

**Implementation (n8n Code Node):**
```javascript
// After HTTP Request node fails with 429
const retryAfter = json.headers?.['retry-after'] || 30; // seconds
const exponentialBackoff = (attempt) => Math.min(2 ** attempt, 300); // cap at 5min

for (let attempt = 0; attempt < 3; attempt++) {
  const waitTime = exponentialBackoff(attempt) * 1000; // ms
  await new Promise(r => setTimeout(r, waitTime));

  // Retry HTTP request here
  // If success, break loop
  // If still 429, continue loop
}
```

**n8n Workflow Visual:**
```
HTTP Request (Gumroad)
  ↓ (on error)
Error Trigger
  ├→ Check: Is error 429?
  │   ├→ YES: Wait node (exponential backoff)
  │   │   └→ HTTP Request (retry)
  │   └→ NO: Log error, skip
  ↓
Continue workflow
```

### Pattern 2: Authentication Failure (401/403)

**Implementation:**
```javascript
// On 401: Token likely expired
if (error.statusCode === 401) {
  // For Gumroad: Alert CTMO (no refresh mechanism)
  // For Etsy: Trigger OAuth refresh
  // For WordPress: Refresh app password

  throw new Error("AUTH_FAILURE: Token expired. Alert CTMO.");
}

if (error.statusCode === 403) {
  // For Etsy: Missing scopes
  throw new Error("SCOPE_MISSING: Need to request additional scopes from Etsy.");
}
```

### Pattern 3: Network Timeout Retry

**Implementation (n8n HTTP Request node):**
- Enable "Retry On Fail"
- Max retries: 3
- Wait between retries: 2 seconds (+ exponential backoff with jitter)
- Backoff formula: `base * multiplier^attempt + random(0, jitter)`

### Pattern 4: Logging All Failures

**Error Table (PostgreSQL):**
```sql
CREATE TABLE api_errors (
  id SERIAL PRIMARY KEY,
  platform TEXT NOT NULL,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_data JSONB,
  response_data JSONB,
  attempt_number INT,
  occurred_at TIMESTAMP DEFAULT NOW(),
  resolved BOOLEAN DEFAULT false
);
```

**n8n Logging Node:**
```javascript
// After any error
const errorRecord = {
  platform: "gumroad",
  endpoint: "/products/sales",
  error_code: error.statusCode,
  error_message: error.message,
  request_data: {}, // sanitized (no tokens!)
  response_data: {}, // sanitized
  attempt_number: $execution.retryCount || 1
};

// Write to api_errors table
```

---

## 8. REVENUE CAPTURE SPECIFICS

### Data Points Per Transaction

**Gumroad:**
```json
{
  "id": "sale_id_12345",
  "product_id": "prod_123",
  "amount": 29.99,
  "currency": "usd",
  "customer_email": "customer@example.com",  // MUST HASH
  "created_at": "2026-03-29T14:30:00Z",
  "license_key": "xxx"  // If licensing enabled
}
```

**Etsy:**
```json
{
  "transaction_id": "123456789",
  "listing_id": "456789",
  "amount": 35.50,
  "currency": "usd",
  "buyer_username": "buyer_user123",  // Pseudonymous, HASH anyway
  "quantity": 1,
  "created_date": "2026-03-29"
}
```

**WordPress (Custom):**
```json
{
  "post_id": 789,
  "affiliate_program": "amazon_associates",
  "amount": 15.00,
  "clicks": 3,
  "date": "2026-03-29"
}
```

### Hourly vs. Daily Polling

| Platform | Recommended | Reason |
|----------|---|---|
| **Gumroad** | Hourly | Low volume, fast API, good for real-time revenue signal |
| **Etsy** | Daily (safe) / 2x daily (ambitious) | Rate limits tight; daily = 1-2% of budget; 2x daily = 5% |
| **Medium** | Daily | Manual only; no API for earnings |
| **WordPress** | Daily | Depends on plugin; daily safer |
| **Redbubble** | Daily | Manual only |

### Privacy/PII Redaction Checklist

- [ ] Customer emails NEVER logged in plaintext
  - Use: `crypto.createHash('sha256').update(email).digest('hex')`
- [ ] n8n logs: Configure to exclude PII fields from execution logs
- [ ] Database: Encrypt sensitive columns (e.g., `pgcrypto` extension in PostgreSQL)
- [ ] API responses: Strip PII before storing in database
- [ ] Backups: Ensure encrypted backups, isolated access

---

## 9. n8n WORKFLOW TEMPLATES

### Template 1: Gumroad Hourly Polls

**File:** `gumroad_hourly_poll.json`

```json
{
  "nodes": [
    {
      "name": "Trigger",
      "type": "n8n-nodes-base.trigger",
      "typeVersion": 1,
      "position": [250, 300],
      "parameters": {
        "triggerType": "interval",
        "unit": "minutes",
        "value": 60
      }
    },
    {
      "name": "Get Products",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4,
      "position": [450, 300],
      "parameters": {
        "method": "GET",
        "url": "=https://api.gumroad.com/v2/products",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "gumroad",
        "options": {}
      }
    },
    {
      "name": "Loop Products",
      "type": "n8n-nodes-base.functionItem",
      "position": [650, 300],
      "parameters": {
        "functionCode": "return items;"
      }
    },
    {
      "name": "Fetch Sales",
      "type": "n8n-nodes-base.httpRequest",
      "position": [850, 300],
      "parameters": {
        "method": "GET",
        "url": "=https://api.gumroad.com/v2/products/{{ $item.json.id }}/sales",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "gumroad"
      }
    },
    {
      "name": "Hash Email",
      "type": "n8n-nodes-base.code",
      "position": [1050, 300],
      "parameters": {
        "language": "javascript",
        "jsCode": "const crypto = require('crypto');\nreturn items.map(item => ({\n  ...item.json,\n  customer_email_hash: crypto.createHash('sha256')\n    .update(item.json.customer_email)\n    .digest('hex')\n}));"
      }
    },
    {
      "name": "Write to DB",
      "type": "n8n-nodes-base.postgres",
      "position": [1250, 300],
      "parameters": {
        "operation": "insert",
        "table": "gumroad_sales",
        "columns": ["product_id", "sale_id", "amount", "customer_email_hash", "created_at"],
        "values": "={{ $item.json }}"
      }
    },
    {
      "name": "Error Handler",
      "type": "n8n-nodes-base.errorTrigger",
      "position": [850, 450],
      "parameters": {}
    }
  ],
  "connections": {
    "Trigger": { "main": [[ { "node": "Get Products", "branch": 0 } ]] },
    "Get Products": { "main": [[ { "node": "Loop Products", "branch": 0 } ]] },
    "Loop Products": { "main": [[ { "node": "Fetch Sales", "branch": 0 } ]] },
    "Fetch Sales": { "main": [[ { "node": "Hash Email", "branch": 0 } ]] },
    "Hash Email": { "main": [[ { "node": "Write to DB", "branch": 0 } ]] }
  }
}
```

### Template 2: Etsy Daily Stats

**File:** `etsy_daily_stats.json`

```json
{
  "nodes": [
    {
      "name": "Daily Trigger",
      "type": "n8n-nodes-base.trigger",
      "typeVersion": 1,
      "parameters": {
        "triggerType": "cron",
        "cronExpression": "0 2 * * *"  // 2am UTC daily
      }
    },
    {
      "name": "Check Rate Limit",
      "type": "n8n-nodes-base.postgres",
      "parameters": {
        "operation": "executeQuery",
        "query": "SELECT requests_today FROM etsy_rate_limit_tracking WHERE id=1"
      }
    },
    {
      "name": "Get User Info",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "method": "GET",
        "url": "https://api.etsy.com/v3/users/me",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "etsy"
      }
    },
    {
      "name": "Get Shop Listings",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "method": "GET",
        "url": "=https://api.etsy.com/v3/shops/{{ $json.user.user_id }}/listings/active",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "etsy"
      }
    },
    {
      "name": "Loop Listings",
      "type": "n8n-nodes-base.functionItem",
      "parameters": {
        "functionCode": "return items;"
      }
    },
    {
      "name": "Fetch Listing Stats",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "method": "GET",
        "url": "=https://api.etsy.com/v3/listings/{{ $item.json.listing_id }}/stats",
        "authentication": "predefinedCredentialType",
        "nodeCredentialType": "etsy",
        "options": {
          "retry": { "maxRetries": 3, "backoff": { "exponential": true } }
        }
      }
    },
    {
      "name": "Transform & Hash",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "language": "javascript",
        "jsCode": "const crypto = require('crypto');\nreturn items.map(item => ({\n  listing_id: item.json.listing_id,\n  amount: item.json.stats?.gross_sales || 0,\n  buyer_username_hash: crypto.createHash('sha256')\n    .update(item.json.buyer?.username || 'unknown')\n    .digest('hex'),\n  created_at: item.json.date\n}));"
      }
    },
    {
      "name": "Write to DB",
      "type": "n8n-nodes-base.postgres",
      "parameters": {
        "operation": "insert",
        "table": "etsy_sales",
        "columns": ["listing_id", "amount", "buyer_username_hash", "created_at"]
      }
    },
    {
      "name": "Error: Rate Limit",
      "type": "n8n-nodes-base.errorTrigger",
      "parameters": {}
    }
  ]
}
```

---

## 10. AUTHENTICATION CHECKLIST (Master)

### Gumroad
- [ ] Account created, confirmed
- [ ] API token generated (Settings → API)
- [ ] Token stored in n8n credentials (type: "Gumroad")
- [ ] Test API call: `GET /me` returns account info
- [ ] Secret stored in encrypted n8n vault
- [ ] No token in logs or git history

### Etsy
- [ ] Developer account created
- [ ] App created, Client ID + Secret saved
- [ ] OAuth redirect URI configured in app settings
- [ ] Redirect URI matches n8n instance: `https://<n8n>/rest/oauth2/callback?service=etsy`
- [ ] OAuth flow tested (get authorization code, exchange for token)
- [ ] Scopes requested: `listings_r`, `transactions_r`, `shops_r`
- [ ] Access token + refresh token stored in n8n
- [ ] Test API call: `GET /users/me` returns user ID
- [ ] Tokens refreshed automatically before expiry

### Medium
- [ ] Account created, confirmed
- [ ] Integration token generated (Settings → Integration tokens)
- [ ] Token stored in n8n credentials
- [ ] Test API call: `GET /me` returns user info
- [ ] Acknowledge API is deprecated (may break anytime)

### WordPress
- [ ] WordPress 5.6+ installed, HTTPS enabled
- [ ] User account with Editor/Administrator role
- [ ] Application Password generated (Users → Profile)
- [ ] Password stored securely (n8n credentials + local backup encrypted)
- [ ] Basic Auth credentials: `base64(username:apppassword)`
- [ ] Test API call: `GET /wp-json/wp/v2/me` returns authenticated user
- [ ] Custom post type registered + exposed via REST API
- [ ] Test: `GET /wp-json/wp/v2/earnings` returns posts

### Redbubble
- [ ] N/A (no API; manual dashboard only)
- [ ] Analytics dashboard bookmarked: `https://www.redbubble.com/dashboard/analytics`
- [ ] Daily check process documented

---

## 11. COMMON FAILURE MODES & RESOLUTION

| Failure Mode | Platform | Symptom | Cause | Fix |
|---|---|---|---|---|
| **Rate Limit Hit** | Etsy | 429 Too Many Requests | Exceeded QPD/QPS | Check rate_limit_tracking, slow requests, retry with backoff |
| **Token Expired** | Gumroad | 401 Unauthorized | Token expired or revoked | Regenerate token in dashboard, update n8n |
| **OAuth Failure** | Etsy | 403 Forbidden / Invalid scope | Scopes not requested | Request scopes in developer app settings |
| **Custom Post Type Missing** | WordPress | 404 on GET /earnings | CPT not registered or not exposed to REST | Register CPT, set `show_in_rest => true` |
| **Network Timeout** | All | Request hangs, no response | Slow network, API down, or firewall | Implement timeouts (30s), retry with backoff |
| **Email Hash Collision** | Gumroad/Etsy | Duplicate customer records | Multiple customers with same email (unlikely) | Query by transaction ID instead |
| **Database Connection Lost** | All | Cannot write to database | Connection pool exhausted, network issue | Check PostgreSQL status, restart pool |

---

## 12. TESTING CHECKLIST (Pre-Production)

### Unit Tests
- [ ] Email hash function produces consistent output
- [ ] Date parsing handles timezones correctly
- [ ] Rate limit counter increments/decrements properly
- [ ] Exponential backoff formula produces expected wait times

### Integration Tests
- [ ] Gumroad → Database: End-to-end sales fetch + write
- [ ] Etsy → Database: End-to-end stats fetch + write
- [ ] Rate limiting: Verify 10K QPD budget respected over 24h
- [ ] Error handling: Trigger 429, verify retry logic works
- [ ] Authentication: Refresh tokens auto-renew before expiry

### Workflow Tests (n8n)
- [ ] Dry-run: All workflows complete without errors
- [ ] Actual run: Workflows execute on schedule
- [ ] Data quality: No NULL values, correct types
- [ ] Logging: Errors logged to database, alerts sent

### Load Testing (Optional)
- [ ] Gumroad: Poll 10+ products, verify no timeouts
- [ ] Etsy: Query 50+ listings simultaneously (check rate limit handling)
- [ ] Database: Insert 1000+ rows in single workflow, verify performance

---

## 13. DEPLOYMENT & MONITORING

### Deployment Steps
1. Create database schema (all `CREATE TABLE` statements above)
2. Generate all API credentials (Gumroad token, Etsy OAuth, WordPress app password)
3. Import n8n workflow templates (JSON files)
4. Configure credentials in n8n credentials manager
5. Dry-run each workflow
6. Enable production mode (activate schedules)
7. Monitor logs for first 24h

### Monitoring Metrics
- **Gumroad:** Daily revenue, transaction count, API errors
- **Etsy:** Daily revenue, rate limit usage (%), OAuth token age
- **Medium:** Daily earnings (manual check), article views
- **WordPress:** Daily affiliate earnings, custom post count
- **Redbubble:** Daily earnings (manual), product views

### Alerts
- [ ] Setup email alert if daily_revenue_summary.total_revenue = 0 (no data)
- [ ] Alert if any API error rate > 10% (flaky integration)
- [ ] Alert if Etsy rate limit usage > 90% (approaching limit)
- [ ] Alert if any workflow misses scheduled run time by >30min

---

## 14. DELIVERABLES & TIMELINE

| Deliverable | Owner | Due | Status |
|---|---|---|---|
| API credential setup (all 5 platforms) | CTMO | Hour 2 | TODO |
| Database schema + migrations | CTMO | Hour 3 | TODO |
| Gumroad n8n workflow (deploy) | CTMO | Hour 5 | TODO |
| Etsy n8n workflow (deploy) | CTMO | Hour 11 | TODO |
| WordPress setup + custom post type | CTMO | Hour 15 | TODO |
| Medium manual logging process doc | CTMO | Hour 16 | TODO |
| Redbubble manual fallback process doc | CTMO | Hour 18 | TODO |
| Daily revenue aggregation workflow | CTMO | Hour 20 | TODO |
| End-to-end testing + bug fixes | CTMO | Hour 30 | TODO |
| Production deployment + monitoring setup | CTMO | Hour 36 | TODO |

---

## SUMMARY

**The Plan:**
1. **Day 1:** Gumroad (4h) + Etsy (6h) = revenue capture live by hour 10
2. **Day 1.5:** WordPress (4h) + Medium (3h) = diverse stream tracking
3. **Day 2:** Redbubble fallback (2h) + testing/hardening (8h) + monitoring setup (2h)
4. **Total:** 36 hours → 5 revenue streams feeding real-time data to PostgreSQL

**Key Assumptions:**
- n8n instance already running (Docker/Railway)
- PostgreSQL database accessible
- All platforms have active accounts with some transaction history
- No advanced features needed (simple CRUD polling)

**Risk Mitigation:**
- Gumroad first (lowest complexity, early confidence)
- Etsy rate limits carefully managed (sliding window tracking)
- Manual fallbacks for Medium/Redbubble (no dependency on fragile APIs)
- Error handling prioritizes retries over failures

**Next Steps for COO:**
1. Confirm all 5 accounts active + have transaction history
2. Provide target revenue tracking formats (how should data be exposed?)
3. Confirm database access/credentials ready
4. Set up daily revenue summary distribution (email, dashboard, etc.)

---

**Document Version:** 1.0
**Last Updated:** 2026-03-29
**Status:** Ready for Implementation
**Estimated Build Time:** 36 hours (Day 1 PoC + Day 2 Full Scale)
