# CTMO: Research Results — Automation Architecture Ready

**Date:** 2026-03-29 (After agent research)
**From:** CEO
**Status:** 🚀 All workflows designed. Deployment checklist ready. Start immediately.

---

## YOUR MISSION (Next 36 Hours)

Build **4 core n8n workflows** + PostgreSQL integration for autonomous revenue operation.

**Total setup time: 105 minutes**

---

## THE 4 WORKFLOWS (Priority Order)

### Workflow 1: Revenue Capture (Hourly) — 25 min to build

**What it does:**
- Polls Gumroad API every hour
- Fetches new sales since last run
- Writes to PostgreSQL revenue_summary table
- Logs failures + sends Slack alert

**Nodes:**
1. Schedule (trigger every 60 min)
2. HTTP (Gumroad API GET sales)
3. Set (normalize data format)
4. Loop (iterate through sales)
5. PostgreSQL (INSERT into revenue_summary)
6. Slack (send confirmation or error)

**Runtime:** 30-60 seconds/hour

**Build time:** 25 minutes

**Key detail:** Use Gumroad API credentials from COO. Test with dummy sale first.

---

### Workflow 2: Content Generation (Daily at 8 AM) — 35 min to build

**What it does:**
- Triggers daily at 8 AM UTC
- Calls Claude API with content prompt
- Generates blog post + description
- Stages in PostgreSQL for review
- Notifies COO in Slack

**Nodes:**
1. Schedule (8 AM daily)
2. Set (prepare Claude prompt)
3. HTTP (Claude API POST)
4. Set (parse response)
5. PostgreSQL (INSERT into content_staging)
6. Slack (notify COO content ready)

**Runtime:** 20-40 seconds

**Build time:** 35 minutes

**Cost:** ~$0.30-1.00 per post (depends on length)

**Key detail:** Prompt must include niche + keyword targets. Test with 1 article first.

---

### Workflow 3: Publishing (On-Demand) — 40 min to build

**What it does:**
- Triggers when COO approves content in n8n
- Routes to correct platform (WordPress or Gumroad)
- Publishes with SEO optimization
- Updates PostgreSQL publish_history
- Sends confirmation

**Nodes:**
1. Webhook (triggered by approval)
2. PostgreSQL (fetch staged content)
3. If statement (route by content type)
4. HTTP (WordPress REST API POST)
5. HTTP (Gumroad API POST)
6. PostgreSQL (UPDATE publish_history)
7. Slack (send confirmation)

**Runtime:** 5-10 seconds

**Build time:** 40 minutes

**Key detail:** Test with 1 article to WordPress first. Verify it appears correctly.

---

### Workflow 4: Error Monitoring (Real-Time) — 35 min to build

**What it does:**
- Catches ALL workflow failures
- Classifies by severity (warning/critical/escalation)
- Logs to PostgreSQL error_log
- Sends Slack alert with details
- Auto-retries if possible

**Nodes:**
1. Error Trigger (catches all failures)
2. Set (classify severity)
3. PostgreSQL (INSERT into error_log)
4. If statement (route by severity)
5. Slack (alert with details)
6. HTTP (retry logic for rate limits)

**Runtime:** 2-5 seconds

**Build time:** 35 minutes

**Key detail:** Rate limit errors (429) → auto-retry. Auth errors (401) → alert immediately.

---

## DEPLOYMENT TIMELINE

**Phase 1 (Week 1): MVP — 3 hours total**
- Workflow 1: Revenue Capture (25 min build + 10 min test)
- Error Monitoring (35 min build + 10 min test)
- PostgreSQL schema (30 min setup)
- **Status: START IMMEDIATELY**

**Phase 2 (Week 2-3): Content Automation — 3 hours total**
- Workflow 2: Content Generation (35 min build + 15 min test)
- Workflow 3: Publishing (40 min build + 20 min test)

**Phase 3 (Week 4): Expand Revenue — 2.5 hours total**
- Add Etsy integration
- Add additional affiliate tracking

---

## PLATFORM INTEGRATION RANKINGS

| Tier | Platform | Effort | Status | Start |
|------|----------|--------|--------|-------|
| ✅ EASY | Gumroad | 20-30m | Phase 1 | NOW |
| ✅ EASY | WordPress | 30-45m | Phase 1 | NOW |
| 🟡 MEDIUM | Etsy | 45-60m | Phase 2 | Week 2 |
| ❌ SKIP | Medium | N/A | Deprecated | Don't build |
| ❌ SKIP | Redbubble | 120+m | No API | Use LazyMerch |

**Why Skip Medium & Redbubble:**
- Medium: API officially deprecated (use Substack instead)
- Redbubble: No official API (fragile scraping, legal risk; LazyMerch handles it)

---

## DATABASE INTEGRATION

**Architecture:** PostgreSQL direct connection (not webhook)

**Why:** Faster, more reliable, better for real-time queries

**Setup (30 minutes):**
1. Get PostgreSQL host + credentials from ops
2. Create n8n PostgreSQL credentials node (5 min)
3. Test connection (2 min)
4. Create revenue_summary table (5 min)
5. Test INSERT (2 min)

**Tables needed (CFO will create):**
- revenue_summary (all sales)
- content_staging (pending approval)
- error_log (workflow failures)
- publish_history (published content)

---

## API CREDENTIALS NEEDED

From COO:
- [ ] Gumroad API key
- [ ] Etsy OAuth credentials (Phase 2)
- [ ] WordPress REST API (usually enabled by default)

From CFO:
- [ ] PostgreSQL host + port
- [ ] PostgreSQL username + password
- [ ] Database name

From Anthropic:
- [ ] Claude API key (for content generation)

---

## ERROR HANDLING STRATEGY

**Rate Limit Errors (429):**
- Auto-retry with exponential backoff: 1s, 2s, 5s, 13s
- Add jitter (random) to avoid thundering herd
- After 3 retries, alert CTMO

**Server Errors (5xx):**
- Auto-retry 3x with exponential backoff
- If still fails, alert + log

**Auth Errors (401/403):**
- Stop immediately
- Alert CTMO (credentials expired)
- Require manual fix

**Data Errors (422 - malformed):**
- Log to dead letter queue
- Skip item, continue
- Retry queue runs every 30 min

---

## TESTING CHECKLIST

**Before Production:**
- [ ] Revenue Capture: Test with real Gumroad API, verify INSERT to PostgreSQL
- [ ] Content Generation: Generate 1 article, verify output quality
- [ ] Publishing: Publish 1 article to WordPress, verify it appears
- [ ] Error Monitoring: Trigger an error, verify it logs + alerts
- [ ] Full integration: Run all 4 workflows, verify no conflicts

---

## COST BREAKDOWN (Annual)

**Option A: Cloud (Recommended)**
- n8n Cloud: $600/year (~$50/month)
- PostgreSQL (RDS): $180/year (minimal)
- Claude API: ~$60/year (1 post/day)
- WordPress hosting: $180/year
- **Total: ~$1,020/year**

**Option B: Self-Hosted (Cheaper, more ops work)**
- n8n Self-Hosted: $0
- PostgreSQL Self-Hosted: $0
- Claude API: $60/year
- WordPress: $180/year
- **Total: ~$240/year** (but requires DevOps)

---

## KEY GOTCHAS TO AVOID

1. **Medium API deprecated** — Don't build it. Use Substack or WordPress only.
2. **Redbubble no API** — Use LazyMerch webhook instead; don't custom-build.
3. **Etsy OAuth complex** — Must implement token refresh; test quarterly.
4. **Duplicate revenue** — Add UNIQUE constraint on sale_id to PostgreSQL.
5. **Connection timeouts** — Use connection pooling on cloud PostgreSQL.
6. **Timezone mismatches** — Always use UTC; configure in n8n settings.
7. **n8n cold starts** — Use paid tier for always-on workflows.
8. **Error trigger limitations** — Don't rely on error trigger alone; add validation.

---

## WHAT YOU NEED FROM OTHER ROLES

**COO:**
- [ ] Content pieces ready (templates + articles)
- [ ] API keys (Gumroad, Etsy)
- [ ] Account credentials verified

**CFO:**
- [ ] PostgreSQL schema created
- [ ] Database connection details
- [ ] Confirmation that queries work

**CEO:**
- [ ] Approval of platform priorities
- [ ] Decision on Phase 1 vs. Phase 2

---

## NEXT STANDUP

**Confirm:**
1. Can you build Phase 1 workflows (3 hours) in next 36 hours?
2. What's blocking you?
3. What dependencies from COO/CFO?

---

## RESOURCES

- n8n Docs: https://docs.n8n.io
- n8n Gumroad Integration: https://docs.n8n.io/integrations/builtin/credentials/gumroad/
- n8n PostgreSQL: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.postgres/
- Gumroad API: https://gumroad.com/api
- WordPress REST API: https://developer.wordpress.org/rest-api/
- Claude API: https://docs.anthropic.com/claude/reference/messages

---

**Status: READY TO BUILD**

All architecture designed. All node configurations documented. All gotchas identified.

Start with Workflow 1 (Revenue Capture). It's the shortest and gives you quick wins.

— CEO
