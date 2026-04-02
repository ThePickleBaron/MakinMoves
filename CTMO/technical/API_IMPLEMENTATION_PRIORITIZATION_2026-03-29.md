# API Implementation Prioritization — 36-Hour Sprint Plan
**Date:** 2026-03-29 17:50 UTC
**Task:** Sequence API integrations for maximum autonomous revenue by March 31 23:59
**Owner:** CTMO
**Timeline:** 36 hours (20 CTMO hours + 16 buffer)

---

## PRINCIPLE: Revenue First, Complexity Second

Build in order of:
1. **Time to first revenue** (what generates $ fastest?)
2. **Technical simplicity** (what can be built in 2–3 hours?)
3. **Scaling confidence** (what doesn't need rework at 10x revenue?)

---

## PHASED ROLLOUT

### PHASE 0: Setup (Today 2026-03-29, 2 hours)

**What:** Prepare environment for all integrations

**Tasks:**
- [ ] Verify n8n paid tier is active
- [ ] Verify PostgreSQL is running (docker ps)
- [ ] Create all required tables:
  ```sql
  CREATE TABLE gumroad_sales (...);
  CREATE TABLE etsy_sales (...);
  CREATE TABLE content_queue (...);
  CREATE TABLE publishing_log (...);
  CREATE TABLE affiliate_clicks (...);
  CREATE TABLE workflow_executions (...);
  CREATE TABLE error_logs (...);
  ```
- [ ] Store API credentials in n8n credentials manager (encrypted):
  - [ ] Gumroad token
  - [ ] Etsy OAuth (Client ID + Secret)
  - [ ] WordPress app password
  - [ ] Bitly API key
  - [ ] Claude API key

**Done:** 2 hours

**Owner:** CTMO

---

### PHASE 1: Revenue Capture (Gumroad) — 2026-03-29 Eve, 4 hours

**Why First:** Simplest API (bearer token), fastest to deploy, first revenue signal

**What:** Build n8n Workflow 1 (Revenue Capture)

**Tasks:**
- [ ] HTTP Request node: GET `/v2/products` (list all products)
- [ ] For-each loop: Poll each product's `/v2/products/{id}/sales`
- [ ] Transform node: Hash emails, format data
- [ ] PostgreSQL node: INSERT into gumroad_sales (with dedup)
- [ ] Error handler: Log 401 (token), log 429 (backoff), log 5xx (retry)
- [ ] Schedule: Hourly cron trigger (`0 * * * *`)

**Test:**
- [ ] Trigger manually, verify sales appear in gumroad_sales table
- [ ] Test with 0 sales (empty response handling)
- [ ] Test error handling (mock 401)

**Expected Output:** Revenue data flowing into PostgreSQL hourly

**Done:** 4 hours total (2 hours setup + 2 hours build + test)

**Owner:** CTMO

---

### PHASE 2: Revenue Capture (Etsy) — 2026-03-30 Morning, 4 hours

**Why Second:** Largest revenue platform, more complex OAuth but well-documented

**What:** Extend Workflow 1 with Etsy branch

**Tasks:**
- [ ] OAuth token refresh mechanism (if needed)
- [ ] HTTP Request node: GET `/v3/transactions` (with OAuth)
- [ ] Rate limit check: Query etsy_rate_limit_tracking before call
- [ ] For-each loop: Process each transaction
- [ ] Transform: Extract transaction_id, amount, listing_id, buyer_id
- [ ] PostgreSQL: INSERT into etsy_sales (with dedup)
- [ ] Error handler: 401 (token refresh), 429 (alert + backoff)
- [ ] Schedule: Same hourly cron (branch off from main workflow)

**Test:**
- [ ] Trigger manually, verify sales captured
- [ ] Verify rate limit tracking increments
- [ ] Test 429 handling (should not crash)

**Expected Output:** Etsy sales flowing in, all revenue capture working

**Done:** 4 hours (2 hours build + 2 hours testing + refinement)

**Owner:** CTMO

---

### PHASE 3: Content Generation (Claude API) — 2026-03-30 Afternoon, 3 hours

**Why Third:** Generates foundation for publishing. Must work before publishing can begin.

**What:** Build n8n Workflow 2 (Content Generation)

**Tasks:**
- [ ] Code node: Build Claude prompt for digital products
- [ ] HTTP Request: POST to Claude API (`/v1/messages`)
- [ ] Parse response: Extract JSON
- [ ] PostgreSQL: INSERT into content_queue (status='pending')
- [ ] Repeat for PoD designs (same pattern)
- [ ] Repeat for affiliate articles (same pattern)
- [ ] Schedule: Daily at 06:00 UTC
- [ ] Error handler: 429 (queue retry), 401 (alert)

**Test:**
- [ ] Trigger manually, verify 3 items appear in content_queue
- [ ] Verify JSON parsing works
- [ ] Verify quality is acceptable for auto-publish (or flag for review)

**Expected Output:** 3 content items daily in queue, ready for publishing

**Done:** 3 hours (1.5 hours build + 1.5 hours testing)

**Owner:** CTMO

---

### PHASE 4: Publishing (WordPress) — 2026-03-30 Afternoon, 3 hours

**Why Fourth:** Easiest publishing API (REST + app password), proven automation

**What:** Build n8n Workflow 3 (Publishing Pipeline)

**Tasks:**
- [ ] PostgreSQL: SELECT * FROM content_queue WHERE status='approved'
- [ ] For-each approved article:
  - [ ] Transform to WordPress post format
  - [ ] HTTP Request: POST to `/wp-json/wp/v2/posts`
  - [ ] Auth: Basic Auth (app_user:app_password)
  - [ ] Include affiliate disclaimer
  - [ ] Insert Bitly shortened links from metadata
- [ ] Log to publishing_log: published_url, status='published'
- [ ] Update content_queue: status='published', published_at=NOW()
- [ ] Schedule: Daily at 09:00 UTC (3 hours after content generation)
- [ ] Error handler: 401 (alert), 400 (validation error), 5xx (retry)

**Test:**
- [ ] Manually approve an article in content_queue (set status='approved')
- [ ] Trigger Workflow 3 manually
- [ ] Verify article appears on WordPress site
- [ ] Verify publishing_log shows published URL

**Expected Output:** Articles auto-publishing to WordPress daily

**Done:** 3 hours (1.5 hours build + 1.5 hours testing)

**Owner:** CTMO

---

### PHASE 5: Publishing (Etsy) — 2026-03-30 Evening, 3 hours

**Why Fifth:** Largest revenue platform for publishing, moderate complexity

**What:** Add Etsy publishing branch to Workflow 3

**Tasks:**
- [ ] For-each approved digital_product in content_queue:
  - [ ] Check if already published (query gumroad_products table)
  - [ ] Transform to Etsy listing format
  - [ ] HTTP Request: POST to `/v3/listings` (with OAuth)
  - [ ] Upload product image: POST to `/v3/listings/{id}/images`
  - [ ] Store listing_id in publishing_log
- [ ] For-each approved pod_design:
  - [ ] Check if already published
  - [ ] Transform to PoD listing format
  - [ ] POST to Etsy `/listings`
  - [ ] Store listing_id
- [ ] Error handler: Same as WordPress
- [ ] Schedule: Append to Workflow 3 (09:00 UTC)

**Test:**
- [ ] Manually approve a product in content_queue
- [ ] Trigger Workflow 3
- [ ] Verify product appears on Etsy seller dashboard
- [ ] Verify listing_id stored in publishing_log

**Expected Output:** Products + PoD designs auto-publishing to Etsy daily

**Done:** 3 hours (1.5 hours build + 1.5 hours testing)

**Owner:** CTMO

---

### PHASE 6: Link Tracking (Bitly) — 2026-03-30 Evening, 2 hours

**Why Sixth:** Light integration, needed for affiliate revenue attribution

**What:** Integrate Bitly into WordPress publishing workflow

**Tasks:**
- [ ] Integrate into Workflow 3 (WordPress publishing branch):
  - [ ] For each affiliate product in article:
    - [ ] Extract affiliate link from metadata
    - [ ] HTTP Request: POST to Bitly `/v4/bitlinks` (create short link)
    - [ ] Store shortened URL in article_text
  - [ ] INSERT shortened URL into article content
- [ ] Parallel: Setup hourly click polling
  - [ ] HTTP Request: GET `/bitlinks/{id}/clicks` for all tracked links
  - [ ] Parse click count
  - [ ] INSERT into affiliate_clicks table
- [ ] Schedule: Hourly for click polling (same as revenue capture)

**Test:**
- [ ] Publish article with Bitly links
- [ ] Verify shortened links work (can click)
- [ ] Verify clicks appear in affiliate_clicks table

**Expected Output:** Affiliate links auto-shortened + tracked hourly

**Done:** 2 hours (1 hour build + 1 hour testing)

**Owner:** CTMO

---

### PHASE 7: Error Monitoring & Alerts — 2026-03-30 Evening, 1 hour

**Why Seventh:** Support for all workflows, catch failures early

**What:** Build n8n Workflow 4 (Error Monitoring)

**Tasks:**
- [ ] Create Slack/Email integration (alert channel)
- [ ] Monitor error_logs table:
  - [ ] If severity='CRITICAL' (auth failures): Alert immediately
  - [ ] If severity='WARNING' (rate limits): Alert CFO
  - [ ] If error_count > 3 in 1 hour: Page CTMO
- [ ] Scheduled query (hourly):
  - [ ] SELECT COUNT(*) FROM workflow_executions WHERE status != 'success' AND executed_at > NOW() - 1 hour
  - [ ] If count > 0: Log warning, alert
- [ ] Scheduled check (every 6 hours):
  - [ ] SELECT MAX(executed_at) FROM workflow_executions WHERE workflow_id='revenue_capture'
  - [ ] If > 2 hours ago: Alert "Revenue capture stalled"

**Test:**
- [ ] Trigger intentional error in a workflow
- [ ] Verify error logged to error_logs
- [ ] Verify alert sent (email/Slack)

**Expected Output:** CTMO alerted to any failures within 1 hour

**Done:** 1 hour

**Owner:** CTMO

---

### PHASE 8: Testing & Validation — 2026-03-30 Evening through 2026-03-31 Morning, 3 hours

**What:** End-to-end testing before user hands off

**Tasks:**
- [ ] Test all workflows in sequence:
  - [ ] Workflow 1 (revenue capture) runs, captures sales
  - [ ] Workflow 2 (content gen) runs at 06:00 UTC
  - [ ] Manually approve content (set status='approved')
  - [ ] Workflow 3 (publishing) runs at 09:00 UTC
  - [ ] Verify articles on WordPress
  - [ ] Verify products on Etsy
  - [ ] Verify sales captured from both platforms
  - [ ] Verify Bitly links tracked
  - [ ] Verify CFO can query revenue_summary

- [ ] Dry run (24-hour simulation):
  - [ ] Run all workflows manually in sequence (skip sleep)
  - [ ] Verify all data flows correctly
  - [ ] Spot-check for errors

- [ ] Rollback & recovery test:
  - [ ] Simulate API failure (mock 500 error)
  - [ ] Verify error handling + retry
  - [ ] Verify graceful degradation

**Expected Output:** All workflows green, ready for autonomous operation

**Done:** 3 hours

**Owner:** CTMO

---

### PHASE 9: Documentation & Runbooks — 2026-03-31 Morning, 1 hour

**What:** Document procedures for manual intervention if needed

**Tasks:**
- [ ] Create fallback runbooks:
  - [ ] "Gumroad token expired — how to refresh"
  - [ ] "Etsy rate limit exceeded — how to debug"
  - [ ] "WordPress API failure — how to check + resume"
  - [ ] "PostgreSQL connection lost — how to restart"
- [ ] Create monitoring checklist:
  - [ ] Monthly: Refresh API tokens
  - [ ] Weekly: Check error_logs
  - [ ] Daily: Verify revenue_log entries
- [ ] Create escalation procedures:
  - [ ] Who to contact (CTMO)
  - [ ] When to escalate (critical errors)
  - [ ] What data to provide (workflow_id, timestamp, error)

**Expected Output:** CTMO can troubleshoot any failure in <30 min

**Done:** 1 hour

**Owner:** CTMO

---

## TIME ALLOCATION SUMMARY

| Phase | Task | Hours | Cumulative | Deadline |
|-------|------|-------|-----------|----------|
| 0 | Setup | 2 | 2 | 2026-03-29 20:00 |
| 1 | Gumroad Revenue | 4 | 6 | 2026-03-29 23:00 |
| 2 | Etsy Revenue | 4 | 10 | 2026-03-30 12:00 |
| 3 | Content Generation | 3 | 13 | 2026-03-30 15:00 |
| 4 | WordPress Publishing | 3 | 16 | 2026-03-30 18:00 |
| 5 | Etsy Publishing | 3 | 19 | 2026-03-30 21:00 |
| 6 | Bitly Link Tracking | 2 | 21 | 2026-03-30 23:00 |
| 7 | Error Monitoring | 1 | 22 | 2026-03-31 00:00 |
| 8 | Testing & Validation | 3 | 25 | 2026-03-31 06:00 |
| 9 | Documentation | 1 | 26 | 2026-03-31 12:00 |
| | **BUFFER** | **10** | **36** | 2026-03-31 23:59 |

**Status:** 20 hours of work, 10 hours of buffer = **ALL GREEN**

---

## CRITICAL PATH (Must Complete by March 31 23:59)

1. ✅ Setup (2h) → needed for everything
2. ✅ Gumroad Revenue (4h) → first revenue signal
3. ✅ Etsy Revenue (4h) → scales revenue capture
4. ✅ Content Generation (3h) → needed for publishing
5. ✅ WordPress Publishing (3h) → first affiliate revenue
6. ✅ Etsy Publishing (3h) → largest revenue stream
7. ✅ Error Monitoring (1h) → catch failures early

**Total: 20 hours (well within 36-hour window)**

Optional but recommended:
- Bitly Link Tracking (2h) — for affiliate attribution
- Testing (3h) — for confidence
- Documentation (1h) — for troubleshooting

---

## PARALLEL WORK (COO + CFO)

While CTMO builds workflows:

**COO (2 hours):**
- [ ] Pre-create 5 digital product templates on Gumroad (UI only, no API)
- [ ] Set up Etsy seller account + API credentials
- [ ] Set up WordPress site + App Password
- [ ] Prepare list of 10 evergreen affiliate keywords

**CFO (1 hour):**
- [ ] Create PostgreSQL tables (with CTMO)
- [ ] Build revenue_summary view (hourly roll-up)
- [ ] Test queries (hourly revenue, daily summary)

**No bottleneck:** All can happen in parallel, CTMO doesn't wait

---

## GO/NO-GO CHECKPOINTS

### Checkpoint 1: 2026-03-29 23:00 (Phase 1 Complete)
- ✓ Gumroad revenue capture working (sales flowing in)
- ✓ First real revenue signal captured
- ✓ CTMO ready to proceed to Etsy

**If GO:** Continue to Etsy
**If NO-GO:** Debug Gumroad, delay Etsy, adjust timeline

### Checkpoint 2: 2026-03-30 12:00 (Phase 2 Complete)
- ✓ Etsy revenue capture working
- ✓ Both revenue streams active
- ✓ CTMO ready to content generation

**If GO:** Continue to content generation
**If NO-GO:** Debug Etsy, compress remaining timeline

### Checkpoint 3: 2026-03-30 15:00 (Phase 3 Complete)
- ✓ Content generation producing 3 items daily
- ✓ Content quality acceptable (or flagged for review)
- ✓ CTMO ready to start publishing

**If GO:** Continue to publishing
**If NO-GO:** Adjust Claude prompts, delay publishing

### Checkpoint 4: 2026-03-30 21:00 (Phases 4 & 5 Complete)
- ✓ WordPress publishing working
- ✓ Etsy publishing working
- ✓ All revenue + publishing streams operational

**If GO:** Begin testing & documentation
**If NO-GO:** Prioritize highest-revenue stream, skip lower-priority

### Final GO/NO-GO: 2026-03-31 12:00 (All Phases Complete)
- ✓ All workflows deployed + tested
- ✓ 24-hour dry run completed successfully
- ✓ Error monitoring + fallback procedures documented
- ✓ User can hand off with confidence

**If GO:** March 31 23:59 autonomous operation begins ✓
**If NO-GO:** Identify which components are unstable, prioritize stabilization before handoff

---

## CONTINGENCY: If Timeline Slips

### If 6 Hours Behind Schedule (by 2026-03-30 18:00):

**Immediate action:**
1. SKIP Phase 6 (Bitly link tracking) — can add later
2. SKIP Phase 9 (Documentation) — CTMO writes during gaps after hand-off
3. Compress Phase 8 (Testing) to 1.5 hours (smoke test only)
4. Focus on Phases 1–5 (revenue capture + publishing)

**New timeline:** 20 hours → 18 hours (still safe)

---

### If 12 Hours Behind Schedule (by 2026-03-31 00:00):

**Immediate action:**
1. SKIP Phase 6 (Bitly) — manual affiliate tracking
2. SKIP Phase 9 (Documentation) — verbal handoff only
3. SKIP Phase 7 (Error Monitoring) — basic log checking only
4. Run Phase 8 as parallel smoke tests (not sequential)
5. Focus on: Gumroad + Etsy revenue (must work) + WordPress publishing (must work)

**New timeline:** 20 hours → 13 hours (still green)

---

### If 18 Hours Behind Schedule (by 2026-03-31 06:00):

**Immediate action:**
1. Accept manual workaround: Etsy publishing requires COO manual upload (5 min/day)
2. SKIP everything except: Gumroad + Etsy revenue capture + WordPress affiliate publishing
3. Autonomous operation with partial manual approval gates
4. Fully autonomous by April 7 (after user return + approval)

**Outcome:** Partial autonomy by March 31, full autonomy by April 7

---

## SUCCESS DEFINITION

✅ **FULLY AUTONOMOUS (All revenue + content streams):**
- Gumroad sales captured hourly
- Etsy sales captured hourly
- Content generated daily
- Articles published to WordPress daily
- Products published to Etsy daily
- Affiliate links tracked hourly
- Zero human input required

✅ **SEMI-AUTONOMOUS (With optional approval gates):**
- Revenue capture fully automated
- Content generation automated (COO approves daily)
- Publishing automated (after approval)
- Affiliate tracking automated

❌ **NOT ACCEPTABLE:**
- Manual workarounds for core workflows
- Missing revenue capture
- Broken publishing pipelines
- Unmonitored errors

---

## OWNER APPROVAL

**CTMO:** I commit to completing this plan by 2026-03-31 23:59

**CEO:** I approve this timeline and will support CTMO with:
- [ ] Verify n8n paid tier is active
- [ ] Coordinate COO for parallel prep work
- [ ] Ensure no blockers from other teams

**COO:** I commit to having all account setup + template prep ready by 2026-03-30 12:00

**CFO:** I commit to PostgreSQL setup + revenue_summary ready by 2026-03-29 22:00

---

**Plan Owner:** CTMO
**Status:** FINAL APPROVED
**Execution Start:** 2026-03-29 18:00 UTC
**Target Completion:** 2026-03-31 23:59 UTC
