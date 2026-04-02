# API Research Documentation Index

This folder contains comprehensive research on integrating 5 revenue stream platforms: Gumroad, Etsy, WordPress, Medium, and Redbubble.

## Files in This Research

### 1. **summary_api_research_findings.txt** ← START HERE
Quick summary (2 pages) of key findings:
- Which platforms to integrate (3) vs. skip (2)
- Rate limits at a glance
- Authentication types
- Polling vs. webhooks approach
- Implementation priority
- Immediate action items

**Read time:** 5 minutes
**Audience:** CEO, COO, CFO

---

### 2. **quick_reference_api_table.md**
One-page lookup sheet with:
- Side-by-side comparison table
- Authentication quick start (curl examples)
- Rate limit strategy per platform
- Endpoint reference guide
- Error codes cheat sheet
- n8n workflow templates

**Read time:** 5 minutes (reference as needed)
**Audience:** CTMO, COO, developers

---

### 3. **api_research_platform_comparison_2026-03-29.md**
Full technical deep-dive (200+ lines):
- Complete authentication flows with OAuth details
- All key endpoints for each platform
- Detailed rate limit analysis
- Error handling & retry strategies
- Full code examples for authentication + first API calls
- Production readiness assessment
- Polling vs. webhook comparison
- Platform-specific recommendations

**Read time:** 20-30 minutes
**Audience:** CTMO, developers building integrations

---

### 4. **api_decision_2026-03-29_platform_comparison.md**
Architecture decision document:
- Decision matrix (which platforms to integrate)
- Trade-offs analysis
- Risk mitigation strategies
- Implementation timeline
- Scaling readiness at 10x revenue
- Next steps checklist

**Read time:** 5 minutes
**Audience:** CTMO, decision-makers

---

## Quick Decision: What to Build?

### INTEGRATE (High Priority)

**Gumroad** ✅
- What: Sales tracking via REST API polling
- Rate limit: Undocumented (~1-2 QPS assumed)
- Polling: Every 5-10 minutes
- Cost: ~144 requests/day
- Risk: Undocumented limits (mitigated by monitoring)
- Effort: 2 hours setup

**Etsy** ✅
- What: Receipts polling + inventory sync
- Rate limit: 10 QPS / 10K daily
- Polling: Every 5 minutes
- Cost: ~288 requests/day (safe margin)
- Risk: Low (well-documented API)
- Effort: 3 hours setup

**WordPress** ✅
- What: Blog article publishing (push-based)
- Rate limit: No limit (your server)
- Polling: None needed
- Cost: ~10 requests/day
- Risk: Low (stable, documented)
- Effort: 2 hours setup (JWT plugin)

### SKIP (Low Priority)

**Medium** ❌
- Why: Official API deprecated, no longer maintained
- Status: Community-only; use manual posting if needed
- Timeline: Can add later if COO specifically requests

**Redbubble** ❌
- Why: No official API; requires Selenium web scraping
- Risk: High (CAPTCHA blocking, bot detection, UI changes)
- Maintenance: Very high (script breaks frequently)
- Timeline: Skip for now; only if no other POD options

---

## Implementation Roadmap

```
Phase 1 (Day 1-2): Gumroad
  ├─ Get OAuth credentials from COO
  ├─ Implement OAuth 2.0 flow
  ├─ Build n8n polling workflow (/v2/sales every 5 min)
  ├─ Create PostgreSQL schema (gumroad_sales table)
  └─ Test sales tracking end-to-end

Phase 2 (Day 2-3): Etsy
  ├─ Get OAuth credentials from COO (PKCE required)
  ├─ Implement OAuth 2.0 PKCE flow
  ├─ Build n8n polling workflow (/v3/receipts every 5 min)
  ├─ Create PostgreSQL schemas (etsy_listings, etsy_sales)
  ├─ Implement inventory sync
  └─ Test receipts tracking end-to-end

Phase 3 (Day 3-4): WordPress
  ├─ Install JWT Authentication plugin
  ├─ Create API user + JWT secret
  ├─ Build n8n blog publishing workflow
  ├─ Test featured image upload (2-step process)
  └─ Enable COO to publish blog posts via API

Phase 4 (Day 4-5): Monitoring & Integration
  ├─ Central error logging (PostgreSQL table)
  ├─ n8n alerts on 429 rate limits, auth failures
  ├─ CFO dashboard integration (revenue tracking)
  ├─ Health monitoring dashboard for CTMO
  └─ End-to-end testing across all 3 platforms

Timeline: 5-7 days for full integration (3 platforms)
Estimated effort: 8-10 hours CTMO development time
```

---

## Key Findings Summary

### Authentication Complexity
- **Easy:** Gumroad, WordPress, Medium (simple Bearer tokens)
- **Medium:** Etsy (OAuth 2.0 with PKCE required)
- **Hard:** Redbubble (browser automation needed)

### Rate Limits
| Platform | QPS Limit | Daily Limit | Polling Interval | Daily Cost |
|----------|-----------|-------------|------------------|-----------|
| Gumroad | Unknown | Unknown | 5-10 min | 144-288 |
| Etsy | 10 | 10,000 | 5 min | 288 |
| WordPress | Unlimited | Unlimited | N/A (push) | ~10 |
| Medium | Unknown | Unknown | N/A (push) | ~1 |
| Redbubble | N/A | N/A | 60 sec+ | 50+ |

### Error Recovery
- **Gumroad:** Exponential backoff on unknown limits
- **Etsy:** Exponential backoff + jitter (documented)
- **WordPress:** JWT refresh token on 401, retry
- **Medium:** Exponential backoff (deprecated API)
- **Redbubble:** Manual intervention on CAPTCHA

---

## Code Examples Included

See `api_research_platform_comparison_2026-03-29.md` for:

1. **Gumroad OAuth 2.0 full flow** (OAuth → token → API call)
2. **Etsy API first call** (OAuth PKCE → list receipts)
3. **WordPress featured image upload** (2-step: upload media → link to post)
4. **Medium article creation** (self-issued token → publish)
5. **Redbubble Puppeteer automation** (login → upload → configure)

All examples in JavaScript (Node.js + axios).

---

## For COO: What You Need to Provide

Before CTMO can build integrations, COO needs to provide:

1. **Gumroad:**
   - Gumroad account login
   - OAuth app credentials (client ID, client secret)

2. **Etsy:**
   - Etsy shop ID
   - OAuth app credentials (client ID, client secret)
   - Shop email for OAuth scope

3. **WordPress:**
   - WordPress site URL
   - Admin user credentials
   - Database access (for JWT secret setup)

4. **Medium:** (Skip for now)
5. **Redbubble:** (Skip for now)

---

## For CFO: Revenue Tracking Integration

Once CTMO builds the APIs, CFO can:

1. **Track Gumroad sales** → Update revenue dashboard
2. **Track Etsy receipts** → Update revenue dashboard
3. **Monitor inventory** → Alert on stockouts
4. **Dashboard updates** → Real-time sales tracking

Data will be stored in PostgreSQL:
- `gumroad_sales` — Gumroad transactions
- `etsy_sales` — Etsy receipts + inventory
- `api_errors` — Failed API calls (for debugging)

---

## Risks & Mitigation

| Risk | Platform | Mitigation |
|------|----------|-----------|
| Rate limits unknown | Gumroad | Log all 429s; calculate safe QPS from observed errors |
| Rate limits tight | Etsy | Monitor X-RateLimit-Remaining header; use conservative polling |
| Token expiration | WordPress | Implement JWT refresh flow; auto-retry on 401 |
| API deprecated | Medium | Skip for now; can add manual fallback later |
| Bot detection | Redbubble | Skip; too fragile for autonomous operation |

---

## Next Steps

**For CTMO:**
1. Review this documentation
2. Request OAuth credentials from COO
3. Design PostgreSQL schemas
4. Build n8n workflows
5. Set up monitoring

**For COO:**
1. Read summary findings
2. Provide OAuth credentials
3. Test integrations as CTMO builds them
4. Prepare to use WordPress publishing workflow

**For CFO:**
1. Understand data sources (Gumroad, Etsy, WordPress)
2. Plan dashboard updates
3. Define revenue tracking metrics

**For CEO:**
1. Review decision summary
2. Approve 3-platform integration plan
3. Monitor progress via CTMO standups

---

## Document Version
- **Date:** 2026-03-29 09:30
- **CTMO:** Claude Code Agent
- **Status:** Research Complete, Ready for Implementation
- **Reviewed by:** Self
- **Next Review:** After Phase 1 (Gumroad integration complete)

---

## Questions?

See the full comparison document for technical details on any platform.
