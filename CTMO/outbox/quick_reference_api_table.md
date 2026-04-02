# Quick Reference: Platform API Comparison Table

## At-a-Glance Comparison

| Feature | Gumroad | Etsy | WordPress | Medium | Redbubble |
|---------|---------|------|-----------|--------|-----------|
| **API Type** | REST OAuth 2.0 | REST OAuth 2.0 PKCE | REST JWT/App Pass | REST OAuth 2.0 | Web Scraping |
| **Docs** | Minimal | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent | Limited | N/A |
| **Production Ready** | ✅ Yes (risky) | ✅ Yes (stable) | ✅ Yes (stable) | ❌ No (deprecated) | ❌ No (fragile) |
| **Auth Complexity** | 🟢 Low | 🟡 Medium | 🟢 Low | 🟢 Low | 🔴 High |
| **Rate Limit (QPS)** | ❓ Unknown | 10/sec | Unlimited | ❓ Unknown | 1/min (safe) |
| **Rate Limit (Daily)** | ❓ Unknown | 10,000 | Unlimited | ❓ Unknown | ~50 |
| **Polling Cost** | 144 req/day | 288 req/day | 0 (push) | 0 (push) | 50+ actions |
| **Webhooks** | ❌ No | ❌ No | Custom | ❌ No | N/A |
| **Auth Header** | Bearer token | Bearer token | JWT token | Bearer token | Browser session |
| **CTMO Recommendation** | ✅ **INTEGRATE** | ✅ **INTEGRATE** | ✅ **INTEGRATE** | ❌ **SKIP** | ❌ **SKIP** |

---

## Authentication Quick Start

### Gumroad
```bash
# Get access token (manual or OAuth flow)
curl -X POST https://gumroad.com/oauth/token \
  -d "client_id=YOUR_ID&client_secret=YOUR_SECRET&code=AUTH_CODE&grant_type=authorization_code"

# Make API call
curl https://api.gumroad.com/v2/products \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Etsy
```bash
# OAuth flow (PKCE required)
# 1. Get authorization code
# 2. Exchange for token (with PKCE proof)
# 3. Use token in header

curl https://api.etsy.com/v3/application/shops/YOUR_SHOP_ID/listings \
  -H "Authorization: Bearer YOUR_OAUTH_TOKEN"
```

### WordPress
```bash
# Get JWT token
curl -X POST https://yourdomain.com/wp-json/jwt-auth/v1/token \
  -d "username=YOUR_USER&password=YOUR_PASSWORD"

# Create post
curl -X POST https://yourdomain.com/wp-json/wp/v2/posts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"title":"My Post","content":"Hello","status":"publish"}'
```

### Medium
```bash
# Use self-issued token (no OAuth needed)
curl https://api.medium.com/v1/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Redbubble
```javascript
// No API—use Puppeteer to automate browser
const browser = await puppeteer.launch();
const page = await browser.newPage();
// ... fill forms, upload images, click buttons
```

---

## Rate Limit Strategy

### Gumroad
- **Safe Polling Interval:** 5-10 minutes
- **Requests/Day:** 144-288
- **Error Handling:** Exponential backoff on 429
- **Monitoring:** Log all 429 errors to discover actual limits

### Etsy
- **Safe Polling Interval:** 5 minutes
- **Requests/Day:** 288 (well under 10,000 limit)
- **Error Handling:** Exponential backoff + jitter on 429
- **Monitoring:** Check `X-RateLimit-Remaining` header

### WordPress
- **Polling:** Not needed (push-based)
- **Safe Frequency:** 1-2 posts/min (no rate limit by default)
- **Error Handling:** Refresh JWT token on 401, retry

### Medium
- **Polling:** Not needed (push-based)
- **Safe Frequency:** Unknown; assume 1 post/min
- **Error Handling:** Check 403 (user not writer/editor)

### Redbubble
- **Polling:** N/A
- **Safe Frequency:** 1 upload per 60 seconds
- **Error Handling:** CAPTCHA → manual intervention needed

---

## Endpoint Quick Reference

### Gumroad (`https://api.gumroad.com/v2/`)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/products` | GET | List all products |
| `/products` | POST | Create product |
| `/products/{id}` | PUT | Update product |
| `/sales` | GET | Fetch sales data |
| `/licenses/verify` | POST | Verify license |

### Etsy (`https://api.etsy.com/v3/`)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/application/shops/{shop_id}/listings` | GET | List listings |
| `/application/shops/{shop_id}/listings` | POST | Create listing |
| `/application/shops/{shop_id}/listings/{id}/inventory` | GET | Get inventory |
| `/application/shops/{shop_id}/listings/{id}/inventory` | PUT | Update inventory |
| `/application/shops/{shop_id}/receipts` | GET | Get sales |
| `/application/shops/{shop_id}/listings/{id}/images` | POST | Upload image |

### WordPress (`https://yourdomain.com/wp-json/`)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/wp/v2/posts` | GET | List posts |
| `/wp/v2/posts` | POST | Create post |
| `/wp/v2/posts/{id}` | PUT | Update post |
| `/wp/v2/media` | POST | Upload image |
| `/jwt-auth/v1/token` | POST | Get JWT token |

### Medium (`https://api.medium.com/v1/`)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/me` | GET | Get user info |
| `/publications` | GET | List publications |
| `/publications/{id}/posts` | POST | Create article |

---

## Error Codes Cheat Sheet

| Status | Meaning | Recovery |
|--------|---------|----------|
| **401** | Unauthorized (bad token) | Refresh token / re-authenticate |
| **403** | Forbidden (no permission) | Check OAuth scopes |
| **429** | Rate limited | Exponential backoff; wait before retry |
| **500** | Server error (transient) | Retry with exponential backoff |
| **CAPTCHA** | Bot detection (Redbubble) | Manual intervention required |

---

## Recommended n8n Workflows

### Gumroad Sales Polling
```
Trigger: Every 5 minutes
  → GET /v2/sales
  → Filter new sales (compare against stored list)
  → INSERT into PostgreSQL
  → Notify CFO dashboard
  → On 429: Exponential backoff + alert
```

### Etsy Inventory Sync
```
Trigger: Every 5 minutes
  → GET /v3/receipts (check X-RateLimit-Remaining)
  → Filter new receipts
  → INSERT into PostgreSQL
  → UPDATE Etsy listing status if needed
  → Notify COO of low inventory
  → On 429: Pause polling, alert CTMO
```

### WordPress Blog Publishing
```
Trigger: Manual (COO sends content via email/form)
  → POST /wp-json/wp/v2/posts (title, content)
  → POST /wp-json/wp/v2/media (featured image)
  → PUT /wp-json/wp/v2/posts/{id} (link image to post)
  → Notify COO: Post published at [link]
  → On 401: Refresh JWT, retry
```

---

## Implementation Checklist

- [ ] **Gumroad:** Get OAuth credentials, implement polling, monitor 429s
- [ ] **Etsy:** Get OAuth credentials, implement receipts + inventory sync
- [ ] **WordPress:** Install JWT plugin, create API user
- [ ] **Medium:** Skip for now (deprecated API)
- [ ] **Redbubble:** Skip (no API, high maintenance)
- [ ] PostgreSQL schemas for each platform
- [ ] n8n workflows (polling/publishing)
- [ ] Error logging + monitoring
- [ ] CFO dashboard integration
- [ ] End-to-end testing

---

## Decision: What to Build First

**Priority 1 (Days 1-2):** Gumroad sales polling (simplest OAuth, critical for revenue tracking)
**Priority 2 (Days 2-3):** Etsy receipts polling (highest revenue potential)
**Priority 3 (Days 3-4):** WordPress blog publishing (content distribution)
**Priority 4:** Medium / Redbubble (optional, only if COO requests)

---

## Full Details

See `api_research_platform_comparison_2026-03-29.md` for:
- Complete authentication flows with code examples
- Detailed rate limit strategies
- Error recovery procedures
- Webhook vs. polling analysis
- Production readiness assessment
