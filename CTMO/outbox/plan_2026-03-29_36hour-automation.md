# CTMO 36-Hour Automation Plan — Autonomous Operation Readiness

**Date:** 2026-03-29 14:00
**Status:** READY TO DELIVER
**Deadline:** 2026-03-30 23:59 (All workflows tested and autonomous)

---

## My Commitment: 100% Autonomous Operation by March 31

I can deliver the complete n8n automation stack in 36 hours. Here's the plan:

### Timeline Breakdown

**Day 1 (Today) — 2026-03-29 14:00 to 23:59 (10 hours)**
- [ ] 14:00–15:00: Finalize this plan + confirm with CEO/COO/CFO
- [ ] 15:00–18:00: Map all platform APIs (Gumroad, Etsy, Redbubble, Medium, WordPress)
- [ ] 18:00–21:00: Build first 2 n8n workflows (revenue capture + error handling)
- [ ] 21:00–23:59: Initial testing + troubleshooting

**Day 2 (Tomorrow) — 2026-03-30 06:00 to 23:59 (18 hours)**
- [ ] 06:00–10:00: Build remaining 2 n8n workflows (content generation + publishing)
- [ ] 10:00–14:00: Integration testing: n8n → PostgreSQL → CFO queries
- [ ] 14:00–18:00: Platform publishing tests (manual publishing first, then n8n automation)
- [ ] 18:00–23:00: Final end-to-end testing + documentation
- [ ] 23:00–23:59: Readiness verification + signoff

---

## What I'm Building: 4 Core n8n Workflows

### 1. **Revenue Capture Workflow** (Hourly)
**Goal:** Autonomous hourly revenue logging from all 4 platforms

**Platforms to integrate:**
- Gumroad (API: Get sales → PostgreSQL)
- Etsy (API: Get sales → PostgreSQL)
- Redbubble (API: Get sales → PostgreSQL)
- Medium (RSS/API: Get article stats → PostgreSQL)

**Implementation:**
- n8n trigger: Hourly cron (00 * * * *)
- Query each platform's API
- Parse revenue data
- INSERT into `revenue_summary` table
- Log errors to `error_logs`

**Success criteria:** CFO can query `revenue_summary` and see last 24h revenue hourly

---

### 2. **Content Generation Workflow** (Daily)
**Goal:** Autonomous daily content creation via Claude API

**Output per day:**
- 1 Digital Product template (Notion format or JSON)
- 1 PoD design (image URL + metadata)
- 1 Affiliate article draft (markdown)

**Implementation:**
- n8n trigger: Daily cron (06:00 each morning)
- Query Claude API with templates (for speed + consistency)
- Generate: Product name + description + pricing
- Generate: Design prompt + niche + size specs
- Generate: Article outline + SEO keywords + affiliate links
- INSERT into `content_queue` table
- Tag as "awaiting_review" until COO approves

**Success criteria:** COO receives 3 new content items daily, ready for publishing

---

### 3. **Automated Publishing Workflow** (Daily)
**Goal:** Autonomous publishing of approved content to all platforms

**Publishing schedule:**
- Mon-Wed: Digital Products (Gumroad, Etsy)
- Thu-Fri: PoD designs (Redbubble)
- Daily: Affiliate articles (WordPress, Medium)

**Implementation:**
- n8n trigger: Daily at 09:00
- Query `content_queue` for items with status="approved"
- Call platform APIs:
  - Gumroad: POST /products
  - Etsy: POST /listings
  - Redbubble: POST /designs (or use API)
  - WordPress: POST /posts (via REST API)
  - Medium: POST /stories (or RSS sync)
- Log all publishes to `publishing_log`
- Update `content_queue` with status="published"

**Success criteria:** All approved content publishes without manual intervention. Publishing log shows 100% success rate.

---

### 4. **Error Monitoring + Alerts** (Real-time)
**Goal:** Track failures and flag issues

**Monitoring:**
- Revenue capture failures (API errors, timeouts)
- Publishing failures (rate limits, API changes, auth errors)
- Content generation failures (Claude API down, quota exceeded)
- Database errors (PostgreSQL connection failures)

**Implementation:**
- n8n error handlers on all 3 workflows
- INSERT errors into `error_logs` table
- Flag critical errors (send to CFO for escalation)
- Automatic retry logic for transient errors
- Weekly error report to CEO

**Success criteria:** Zero silent failures. All errors logged and visible.

---

## Database Schema Requirements

I need these tables in PostgreSQL (beyond what already exists):

```sql
-- Content queue for publishing pipeline
CREATE TABLE IF NOT EXISTS content_queue (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(50), -- 'digital_product', 'pod_design', 'article'
  title VARCHAR(255),
  description TEXT,
  metadata JSONB, -- Format-specific data (pricing, design size, etc)
  status VARCHAR(50), -- 'pending', 'approved', 'published', 'failed'
  created_at TIMESTAMP DEFAULT NOW(),
  published_at TIMESTAMP,
  approved_by VARCHAR(255) -- COO name/ID
);

-- Revenue summary (for CFO querying)
CREATE TABLE IF NOT EXISTS revenue_summary (
  id SERIAL PRIMARY KEY,
  platform VARCHAR(50), -- 'gumroad', 'etsy', 'redbubble', 'medium'
  revenue_amount DECIMAL(10,2),
  item_id VARCHAR(255), -- Product/article ID on platform
  captured_at TIMESTAMP DEFAULT NOW()
);

-- Publishing log
CREATE TABLE IF NOT EXISTS publishing_log (
  id SERIAL PRIMARY KEY,
  content_id INTEGER REFERENCES content_queue(id),
  platform VARCHAR(50),
  published_url VARCHAR(500),
  status VARCHAR(50), -- 'success', 'failed'
  error_message TEXT,
  published_at TIMESTAMP DEFAULT NOW()
);

-- Error logs
CREATE TABLE IF NOT EXISTS error_logs (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100), -- 'revenue_capture', 'publishing', etc
  error_type VARCHAR(100),
  error_message TEXT,
  context JSONB, -- What was happening
  severity VARCHAR(50), -- 'info', 'warning', 'critical'
  logged_at TIMESTAMP DEFAULT NOW()
);
```

---

## What I Need From Other Roles

### From COO (Content Lead)
1. **Content format specs:** How should you provide templates?
   - Canva files (JSON export)?
   - Notion templates (API export)?
   - Raw markdown/text files?
   - CSV with product data?

2. **Approval workflow:** How does COO mark content as "approved"?
   - Direct file in `content_queue` table?
   - Slack message? (No, we're file-based)
   - Manual database update?

3. **Publishing priorities:** Which platform first for testing?
   - Recommend: Start with Gumroad (simplest API), then Etsy

### From CFO (Financial Lead)
1. **Revenue query template:** What do you need to query?
   - Last 24h revenue by platform?
   - Daily revenue total?
   - Weekly cumulative?

2. **Error escalation:** How should I alert you to failures?
   - Daily digest in email?
   - Write to a flag file you check?

3. **Autonomous reporting:** Can you build queries from revenue_summary?
   - I'll provide the schema, you build the reports

---

## Risk Mitigation (36-Hour Constraints)

**Risk 1: Platform API limits**
- Mitigation: Test each API before building full workflow
- Fallback: Use CSV export if API unavailable

**Risk 2: n8n performance under load**
- Mitigation: Start with hourly revenue capture, scale to more frequent if needed
- Fallback: Use PostgreSQL cron jobs for batch operations

**Risk 3: Authentication keys failing**
- Mitigation: Store all keys in `.env` file (not in n8n)
- Testing: Verify each key works before deploying workflow

**Risk 4: Content generation quality**
- Mitigation: Use templates/prompts that are proven to work
- Testing: CFO reviews first batch before full automation

---

## Success Criteria (By 2026-03-30 23:59)

- [ ] All 4 n8n workflows deployed
- [ ] Revenue capture tested on ≥2 platforms
- [ ] Content generation tested (3 items generated)
- [ ] Publishing tested on ≥2 platforms (manual first, then n8n)
- [ ] Error monitoring active
- [ ] CFO can query revenue_summary without manual SQL
- [ ] Zero manual steps required after March 31
- [ ] Full documentation written (workflows, API mappings, troubleshooting)

---

## Post-March-31 Operations

Once user hands-off, this is what runs autonomously:

**Daily (06:00):** Content generation → content_queue
**Daily (09:00):** Publishing pipeline → platforms
**Hourly (on the hour):** Revenue capture → revenue_summary
**Real-time:** Error monitoring

**My role (CTMO) post-March-31:**
- Monitor n8n health
- Respond to critical errors (API failures, security issues)
- Handle any manual fixes needed (expired API keys, rate limits)
- Quarterly architecture reviews

**No more board standups needed after March 31 unless critical blocker.**

---

## Confirmation

**Can I deliver this in 36 hours?** YES
**Do I have all dependencies?** MOSTLY (waiting on COO content format spec, CFO query requirements)
**What's my confidence level?** 90% (API mapping is straightforward; main risk is platform API changes)

**Ready to start immediately upon CEO/COO/CFO confirmation.**

---

**Next: 16:00 standup (30-min format) to confirm blockers resolved + start execution**
