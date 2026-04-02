# Architecture Decision: API Integration Strategy for Revenue Streams
**Date:** 2026-03-29 09:30
**Problem:** Select and integrate APIs for Gumroad, Etsy, WordPress, Medium, and Redbubble to enable automated sales tracking, product management, and content publishing.

## Decision Summary

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| **Gumroad** | INTEGRATE (sales polling) | Minimal API, undocumented but production-viable. Implement 5-min polling for sales tracking. Risk: Rate limits unknown—monitor for 429s. |
| **Etsy** | INTEGRATE (full sync) | Well-documented, stable OAuth v3. Implement 5-min polling for receipts + inventory sync. Risk: 10 QPS limit is manageable (288 req/day). |
| **WordPress** | INTEGRATE (push-based) | REST API + JWT plugin. No polling needed—push directly via n8n. Low risk, stable infrastructure. |
| **Medium** | DO NOT INTEGRATE (deprecated) | Official API no longer maintained. Recommend skipping for now; Medium is optional revenue stream. |
| **Redbubble** | DO NOT INTEGRATE (fragile) | No official API; requires web scraping with Selenium/Puppeteer. High maintenance, CAPTCHA blocking, unsustainable for autonomous operation. Last resort only. |

## Trade-offs

| Platform | Benefit | Cost/Risk | Overall |
|----------|---------|-----------|---------|
| **Gumroad** | Easy OAuth, sales data | Undocumented limits, 429 unknown | ✅ Proceed |
| **Etsy** | Documented API, stable | 10 QPS limit tight | ✅ Proceed (manageable) |
| **WordPress** | Your own server, stable | JWT plugin required | ✅ Proceed (low risk) |
| **Medium** | Free publication | API deprecated, broken | ❌ Skip |
| **Redbubble** | Drop-ship revenue | Browser automation, CAPTCHA, bot risk | ❌ Skip (fragile) |

## Implementation Plan

### Phase 1: Gumroad (Day 1-2)
1. Create OAuth application in Gumroad
2. Implement `/v2/products` and `/v2/sales` polling
3. PostgreSQL schema: `gumroad_products`, `gumroad_sales`
4. n8n workflow: Poll every 5 minutes, exponential backoff on 429
5. Database trigger: Update CFO's revenue tracking

### Phase 2: Etsy (Day 2-3)
1. Register Etsy OAuth app (PKCE required)
2. Implement `/v3/receipts` polling and `/v3/listings` inventory sync
3. PostgreSQL schema: `etsy_listings`, `etsy_inventory`, `etsy_sales`
4. n8n workflow: 5-min polling with rate limit header monitoring
5. Alert: Warn COO when 429 rate limit is hit

### Phase 3: WordPress (Day 3-4)
1. Install JWT Authentication plugin on COO's WordPress site
2. Create API user + JWT secret
3. Implement POST endpoint for `/wp-json/wp/v2/posts` (blog publishing)
4. Implement POST endpoint for `/wp-json/wp/v2/media` (featured images)
5. n8n workflow: Accept blog content from COO, POST directly (no polling)

### Phase 4: Monitoring & Error Handling (Day 4-5)
1. Central error logging: All API failures → PostgreSQL `api_errors` table
2. n8n alerts: 429 errors, auth failures, 5xx retries
3. Dashboard: Real-time API health for CTMO monitoring

## Risk Mitigation

### Gumroad (Undocumented Limits)
- **Risk:** Hit unknown rate limit, script fails
- **Mitigation:** Implement exponential backoff starting at 1s delay, log all 429s
- **Monitor:** Alert when 429 is first hit; calculate safe QPS from observed limits

### Etsy (10 QPS, 10K QPD)
- **Risk:** Exceed rate limit if COO asks for frequent syncs
- **Mitigation:** Hard cap at 5-min polling interval (288 req/day, safe margin)
- **Monitor:** Use `X-RateLimit-Remaining` header to track consumption

### WordPress (Token Expiration)
- **Risk:** JWT tokens expire (default 10 min), script breaks
- **Mitigation:** Refresh token on 401, retry request
- **Monitor:** Log token refresh events for debugging

### Medium (Deprecated API)
- **Risk:** API may break without notice
- **Mitigation:** Skip integration for now; can add later if needed
- **Fallback:** Manual posting to Medium if needed

### Redbubble (No API)
- **Risk:** High—Puppeteer scripts break with UI changes, CAPTCHA blocks automation
- **Mitigation:** Do NOT build this now; not worth maintenance burden
- **Fallback:** Manual uploads or use third-party tool (LazyMerch, Flying Upload)

## Scaling Readiness

| Platform | Current Load | 10x Revenue | Scaling Strategy |
|----------|--------------|-------------|------------------|
| Gumroad | ~144 req/day | ~1,440 req/day | Increase polling to 1-min if needed (still ~1 req/sec) |
| Etsy | ~288 req/day | ~2,880 req/day | Still under 10K/day limit; no changes needed |
| WordPress | ~10 req/day | ~100 req/day | Push-based; scales instantly |
| Medium | N/A | N/A | Skipped |
| Redbubble | N/A | N/A | Skipped |

All platforms remain sustainable at 10x revenue growth.

## Implementation Timeline

```
Day 1 (Mar 29):
  - Gumroad OAuth setup, polling architecture

Day 2 (Mar 30):
  - Gumroad polling live, sales tracking

Day 3 (Mar 31):
  - Etsy OAuth setup, receipts polling

Day 4 (Apr 1):
  - WordPress JWT setup, blog publishing workflow

Day 5 (Apr 2):
  - Monitoring, error handling, CFO integration

Day 6+ :
  - On-demand optimizations, Medium/Redbubble if COO requests
```

## Decisions Made

1. **Gumroad:** Accept undocumented risk; implement with aggressive monitoring
2. **Etsy:** Implement full integration (receipts + inventory)
3. **WordPress:** Implement push-based content publishing
4. **Medium:** Skip (deprecated API, optional revenue stream)
5. **Redbubble:** Skip (no API, high fragility risk)

## Next Steps for CTMO

- [ ] Request Gumroad OAuth credentials from COO
- [ ] Request Etsy OAuth credentials from COO
- [ ] Deploy JWT plugin to COO's WordPress
- [ ] Design PostgreSQL schemas for each platform
- [ ] Build n8n polling workflows
- [ ] Set up error logging and monitoring
- [ ] Test end-to-end (auth → poll → store → CFO dashboard)

## Owner
CTMO
