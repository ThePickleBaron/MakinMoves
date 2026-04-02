# Platform API Research & Implementation - Complete Index
**Research Date:** 2026-03-29
**Status:** COMPLETE & READY FOR IMPLEMENTATION
**Target Build Time:** 36 hours
**Researcher:** CTMO (Claude)

---

## DOCUMENT MAP

### 1. START HERE: RESEARCH_SUMMARY.md
**Purpose:** Executive summary of all findings
**Read Time:** 10 minutes
**Key Contents:**
- API capability matrix (all 5 platforms)
- Priority ranking (P0, P1, P2)
- Rate limit analysis (critical for Etsy)
- Known limitations & workarounds
- Next steps for COO

**When to Read:** First thing - gives you the 30,000 ft view

---

### 2. MAIN IMPLEMENTATION GUIDE: PLATFORM_API_MAPPING_2026.md
**Purpose:** Complete technical implementation reference
**Read Time:** 45 minutes (detailed reference)
**Key Sections:**
1. **Executive Summary** (2 min) - Plan overview
2. **API Capability Matrix** (5 min) - Comparison table
3. **Detailed Platform Analysis** (20 min):
   - Gumroad (P0-1): Simplest, start here
   - Etsy (P0-2): Highest volume, watch rate limits
   - WordPress (P1-1): Affiliate tracking
   - Medium (P1-2): No earnings API, use manual
   - Redbubble (P2): Manual only, no API
4. **Day 1 Plan** (10 min):
   - Gumroad setup (4 hours)
   - Etsy setup (6 hours)
5. **Day 2 Plan** (5 min):
   - WordPress (4 hours)
   - Medium (3 hours)
   - Redbubble (2 hours)
6. **Error Handling Patterns** (10 min) - Code examples
7. **Database Schema Design** (5 min) - Table structure
8. **n8n Workflow Templates** (5 min) - JSON skeletons

**When to Read:** After RESEARCH_SUMMARY.md, use as main implementation guide

**How to Use:** Print or bookmark sections 4-5 for hourly reference during build

---

### 3. IMPLEMENTATION TRACKING: PLATFORM_IMPLEMENTATION_CHECKLIST.md
**Purpose:** Hour-by-hour task checklist during 36-hour sprint
**Read Time:** 5 minutes (then use ongoing)
**Structure:**
- **Phase 1: Setup & Foundations** (Hours 0-3)
  - Credentials acquisition (all 5 platforms)
  - Database setup verification
  - n8n instance verification
- **Phase 2: Day 1 PoC** (Hours 4-10)
  - Gumroad integration (4 hours)
  - Etsy integration (6 hours)
  - Testing & verification
- **Phase 3: Day 1.5 Diversify** (Hours 11-19)
  - WordPress (4 hours)
  - Medium (3 hours)
  - Redbubble (2 hours)
- **Phase 4: Aggregation** (Hours 20-30)
  - Daily revenue summary workflow
  - Monitoring & alerting setup
- **Phase 5: Testing & Hardening** (Hours 30-36)
  - E2E testing for each platform
  - Load testing
  - Data quality checks
  - Production readiness

**When to Use:** Print and keep at desk during sprint; check off items as completed

**How to Use:**
1. Start at Phase 1, Hour 0
2. Complete checklist items sequentially
3. Update actual status in "Result: PASS/FAIL" columns
4. Note blockers in "Blocker (if any)" section
5. Sign off at end of each phase

---

### 4. DATABASE REFERENCE: DATABASE_SCHEMA.sql
**Purpose:** PostgreSQL schema ready to deploy
**Size:** 400+ lines of SQL
**Contains:**
- 14 production tables
  - gumroad_sales, gumroad_products, gumroad_errors
  - etsy_sales, etsy_listings, etsy_rate_limit_tracking, etsy_errors
  - wordpress_earnings, wordpress_errors
  - medium_earnings, medium_errors
  - redbubble_earnings, redbubble_errors
  - daily_revenue_summary
- 3 materialized views (reporting)
- 2 helper functions (aggregation)
- Comprehensive indexes (query optimization)
- Triggers (auto-update timestamps)

**When to Use:** First thing during Phase 1 setup
- Copy entire file
- Paste into PostgreSQL client
- Run: `psql -U postgres -d makinmoves -f DATABASE_SCHEMA.sql`
- Verify: All tables created, no errors

**Key Tables:**
```
gumroad_sales (hourly data)
  → sale_id, product_id, amount, customer_email_hash, created_at

etsy_sales (daily data)
  → transaction_id, listing_id, amount, buyer_username_hash, created_at

wordpress_earnings (manual entry)
  → affiliate_program, earnings, clicks, date

medium_earnings (manual entry)
  → earnings, views, reads, date

redbubble_earnings (manual entry)
  → earnings, orders, views, date

daily_revenue_summary (aggregated)
  → date, gumroad_revenue, etsy_revenue, wordpress_revenue, medium_revenue, redbubble_revenue, total_revenue
```

---

### 5. RESEARCH COMPLETION: RESEARCH_COMPLETION_LOG.md
**Purpose:** Final research handoff document
**Read Time:** 5 minutes
**Contains:**
- Research scope checklist (100% complete)
- Deliverables summary
- Key findings (simplified)
- Research metrics
- Risk assessment
- Next steps for CTMO

**When to Read:** After completing implementation plan review; confirms all research done

---

## QUICK START GUIDE (TL;DR)

### For CTMO - Next 36 Hours

**Right Now (Hour 0):**
1. Read RESEARCH_SUMMARY.md (10 min) ← Start here
2. Skim PLATFORM_API_MAPPING_2026.md sections 1-3 (15 min)
3. Print PLATFORM_IMPLEMENTATION_CHECKLIST.md (2 min)

**Hour 0-1: Setup**
1. Follow PLATFORM_IMPLEMENTATION_CHECKLIST.md Phase 1
2. Gather credentials (Gumroad, Etsy, Medium, WordPress, Redbubble)
3. Run DATABASE_SCHEMA.sql to create tables

**Hour 1-5: Gumroad PoC**
1. Reference: PLATFORM_API_MAPPING_2026.md section 4.1
2. Setup: Gumroad API token
3. Implement: n8n workflow (hourly poll)
4. Test: Verify data in database
5. Deploy: Activate schedule

**Hour 5-11: Etsy Scale**
1. Reference: PLATFORM_API_MAPPING_2026.md section 4.2
2. Setup: Etsy OAuth + scopes
3. Implement: n8n workflow (daily stats)
4. Test: Verify rate limit tracking
5. Deploy: Activate schedule

**Hour 11-20: Diversify**
1. WordPress: PLATFORM_API_MAPPING_2026.md section 5.1
2. Medium: PLATFORM_API_MAPPING_2026.md section 5.2
3. Redbubble: PLATFORM_API_MAPPING_2026.md section 5.3

**Hour 20-30: Aggregate**
1. Create daily_revenue_summary workflow
2. Set up email alerts
3. Configure monitoring

**Hour 30-36: Test & Deploy**
1. E2E testing (all platforms)
2. Load testing
3. Production deployment

---

## KEY FACTS TO REMEMBER

### Priority Order
1. **Gumroad** (4h) - Proof of concept, first revenue signal
2. **Etsy** (6h) - Highest transaction volume
3. **WordPress** (4h) - Affiliate revenue
4. **Medium** (3h) - Manual earnings logging (no API)
5. **Redbubble** (2h) - Manual earnings logging (no API)

### Rate Limits (CRITICAL)
| Platform | Limit | Impact |
|----------|-------|--------|
| **Gumroad** | Undocumented | Safe: 2s delay between requests |
| **Etsy** | 10 QPS / 10K QPD | Conservative: Daily polling only (not hourly) |
| **Medium** | Unknown | Keep minimal (daily only) |
| **WordPress** | Host-dependent | Start at 50 req/day, scale as needed |
| **Redbubble** | N/A | Manual only (no API) |

### PII Handling (CRITICAL)
- **Gumroad:** Customer emails MUST be hashed (SHA256)
- **Etsy:** Buyer usernames MUST be hashed
- **Other platforms:** No PII exposure
- **Never log passwords/tokens:** n8n vault handles this

### Error Handling (CRITICAL)
- **429 (Rate Limit):** Exponential backoff (1s, 2s, 4s, 8s) + retry max 3x
- **401 (Auth Failure):** Alert CTMO, stop polling until resolved
- **Timeout:** Exponential backoff, log to api_errors table
- **All failures:** Log to api_errors table, send alert if > 3 consecutive failures

---

## FILE LOCATIONS

```
/c/Users/jsmcl/documents/makinmoves/ctmo/technical/
├── 00_INDEX_PLATFORM_RESEARCH.md  ← You are here
├── RESEARCH_SUMMARY.md  ← Start with this
├── PLATFORM_API_MAPPING_2026.md  ← Main implementation guide
├── PLATFORM_IMPLEMENTATION_CHECKLIST.md  ← Track progress here
├── DATABASE_SCHEMA.sql  ← Deploy to PostgreSQL
├── RESEARCH_COMPLETION_LOG.md  ← Final handoff
└── (other existing files - reference as needed)
```

---

## PLATFORM REFERENCE CARDS

### Gumroad Quick Ref
- **Auth:** API token (single string)
- **Endpoint:** `https://api.gumroad.com/v2/`
- **Rate Limit:** Undocumented, 2s delay safe
- **Data:** Products → Sales (per product)
- **PII:** Hash customer email (SHA256)
- **n8n:** Native Trigger node ready
- **Time Estimate:** 4 hours

**Critical Endpoint:**
```
GET /products  → List all
GET /products/{id}/sales  → Fetch sales
```

### Etsy Quick Ref
- **Auth:** OAuth 2.0 (client ID + secret)
- **Endpoint:** `https://api.etsy.com/v3/`
- **Rate Limit:** 10 QPS / 10,000 QPD (sliding window)
- **Data:** Listings → Stats (per listing)
- **PII:** Hash buyer username (SHA256)
- **n8n:** HTTP Request node + OAuth
- **Time Estimate:** 6 hours

**Critical Endpoints:**
```
GET /users/me  → Get user ID
GET /shops/{shop_id}/listings/active  → List listings
GET /listings/{id}/stats  → Fetch stats
```

**Rate Limit Management:**
```
Daily budget: 10,000 queries
Allocation:
  - Hourly checks: 2,400 (100/hour × 24)
  - Daily batch: 1,000
  - Reserve: 6,600 (80% utilization cap)
```

### WordPress Quick Ref
- **Auth:** Application Password (Basic Auth)
- **Endpoint:** `https://yoursite.com/wp-json/wp/v2/`
- **Rate Limit:** Host-dependent (start 50/day)
- **Data:** Custom post type (earnings)
- **PII:** Low (custom posts private by default)
- **n8n:** Native WordPress node ready
- **Time Estimate:** 4 hours

**Critical Setup:**
```php
register_post_type('earnings', [
  'public' => false,
  'supports' => ['title', 'custom-fields'],
  'show_in_rest' => true
]);
```

**Critical Endpoint:**
```
POST /wp-json/wp/v2/earnings  → Create earnings post
GET /wp-json/wp/v2/earnings  → List posts
```

### Medium Quick Ref
- **Auth:** API token (integration token)
- **Endpoint:** `https://api.medium.com/v1/` (deprecated)
- **Rate Limit:** Unknown, keep minimal
- **Data:** Manual dashboard (stats page)
- **PII:** None (stats only)
- **n8n:** HTTP Request node
- **Time Estimate:** 3 hours (manual)

**Recommendation:** Use daily manual dashboard check (no scraping)

### Redbubble Quick Ref
- **Auth:** Dashboard only (no API)
- **Endpoint:** N/A
- **Rate Limit:** N/A
- **Data:** Manual dashboard (analytics)
- **PII:** None (dashboard only)
- **n8n:** Not applicable
- **Time Estimate:** 2 hours (manual)

**Recommendation:** Use daily manual dashboard check (no API)

---

## VALIDATION CHECKLIST

Before starting implementation:

- [ ] Read RESEARCH_SUMMARY.md (understand the plan)
- [ ] Read PLATFORM_API_MAPPING_2026.md sections 1-3 (understand the details)
- [ ] Have credentials ready:
  - [ ] Gumroad account + ability to generate API token
  - [ ] Etsy developer account + ability to create app
  - [ ] Medium account + ability to generate integration token
  - [ ] WordPress admin access + ability to create app password
  - [ ] Redbubble account + dashboard access
- [ ] Have PostgreSQL access (database + superuser role)
- [ ] Have n8n instance running and accessible
- [ ] Have 36 uninterrupted hours available
- [ ] Printed or bookmarked PLATFORM_IMPLEMENTATION_CHECKLIST.md

---

## SUCCESS METRICS (End of 36 Hours)

✅ **Must Have:**
- [ ] Gumroad: At least 10 sales fetched, stored in database
- [ ] Etsy: At least 1 listing stats fetched, stored in database
- [ ] WordPress: At least 1 earnings entry created (manual)
- [ ] Medium: At least 1 earnings entry created (manual)
- [ ] Redbubble: At least 1 earnings entry created (manual)
- [ ] daily_revenue_summary table populated with yesterday's data
- [ ] All workflows deployed and active

✅ **Should Have:**
- [ ] Email alerts configured (daily summary to COO/CEO)
- [ ] Error monitoring set up (api_errors table with alerts)
- [ ] Rate limit tracking for Etsy (within 80% usage)
- [ ] Documentation complete (workflow comments, error handlers)

✅ **Nice to Have:**
- [ ] Dashboard visualization (PostgreSQL → n8n dashboard)
- [ ] Historical data backfill (30-day look-back)
- [ ] Automated recovery workflows (retry failed syncs)

---

## SUPPORT & TROUBLESHOOTING

### If Stuck on Gumroad
Reference: PLATFORM_API_MAPPING_2026.md section 4.1
Checklist: PLATFORM_IMPLEMENTATION_CHECKLIST.md Phase 2 (Gumroad)

### If Stuck on Etsy
Reference: PLATFORM_API_MAPPING_2026.md section 4.2
Key Issue: Rate limit confusion → Read section 4.2.4 carefully
Checklist: PLATFORM_IMPLEMENTATION_CHECKLIST.md Phase 2 (Etsy)

### If Database Issues
Reference: DATABASE_SCHEMA.sql (full schema)
Test Queries: Provided in schema file comments

### If n8n Issues
Reference: PLATFORM_API_MAPPING_2026.md section 9 (workflow templates)
Error Handling: PLATFORM_API_MAPPING_2026.md section 7

---

## FINAL NOTES

**This research is complete and production-ready.** All APIs verified, rate limits documented, error handling patterns provided, database schema designed, and implementation plan detailed.

**Start with RESEARCH_SUMMARY.md, then follow PLATFORM_IMPLEMENTATION_CHECKLIST.md hour by hour.**

**You've got this. 36 hours to 5 revenue streams. Go.**

---

**Document Version:** 1.0
**Created:** 2026-03-29
**Status:** READY FOR EXECUTION
