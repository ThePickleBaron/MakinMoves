# Technical Architecture — Autonomous Revenue Operation

**Date:** 2026-03-29 14:30
**Status:** READY FOR 36-HOUR EXECUTION
**Deadline:** 2026-03-30 23:59

---

## System Overview

**Goal:** Zero-touch autonomous revenue generation after 2026-03-31

**Three Pillars:**
1. **Content Pipeline** — Claude + n8n generate daily content
2. **Publishing Pipeline** — n8n auto-publish to 5 platforms
3. **Financial Pipeline** — n8n capture revenue hourly → CFO query autonomously

---

## Architecture Layers

```
┌──────────────────────────────────────────────────────────┐
│  COO INPUT LAYER (Hands-off after March 31)              │
│  - Content templates (one-time, Days 1-2)                │
│  - Platform credentials + API keys (one-time setup)      │
│  - Approval flags (minimal, just "publish this" / "skip")│
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  CONTENT GENERATION (n8n + Claude API)                   │
│  - Daily 06:00 AM: Generate 1 product + 1 design + 1 article
│  - Input: Templates, niches, prompts                     │
│  - Output: content_queue table (awaiting approval)       │
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  APPROVAL LOGIC (Minimal human touch)                    │
│  - Mark items "approved" in content_queue                │
│  - Or: Automatic approval after 24h (if COO unavailable)│
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  PUBLISHING PIPELINE (n8n automation)                    │
│  - Daily 09:00 AM: Publish all approved items            │
│  - Platforms: Gumroad, Etsy, Redbubble, Medium, WordPress
│  - Output: publishing_log (track what went where)        │
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  REVENUE CAPTURE (n8n + platform APIs)                   │
│  - Hourly: Query all platform revenue APIs               │
│  - Input: API credentials + rate limiting                │
│  - Output: revenue_summary table (CFO queries this)      │
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  FINANCIAL REPORTING (PostgreSQL + CFO queries)          │
│  - Hourly: revenue_summary updated by n8n               │
│  - Daily: CFO runs get_daily_revenue()                   │
│  - Weekly: CFO runs get_weekly_report()                  │
│  - Monthly: CFO runs get_recovery_forecast()             │
└──────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────┐
│  ERROR MONITORING (Real-time)                            │
│  - n8n error_logs table (all failures tracked)           │
│  - CFO checks daily (5 min review)                       │
│  - Critical errors escalate (immediate alert)            │
└──────────────────────────────────────────────────────────┘
```

---

## Core Services (Running Continuously)

### 1. PostgreSQL Database
- **Tables:** revenue_summary, content_queue, publishing_log, error_logs, recovery_tracker
- **Connection:** n8n + CFO queries (read/write)
- **Backup:** Daily automated backup to `data/exports/`
- **Uptime:** 99.9% (Docker managed)

### 2. n8n Workflow Engine
- **Role:** Orchestrate all automation
- **Resources:** 4 concurrent workflows running
- **Rate limits:** Respect platform API limits (documented per platform)
- **Error handling:** Automatic retry on transient errors, log on fatal
- **Monitoring:** Real-time error tracking to error_logs table

### 3. Claude API Integration
- **Purpose:** Daily content generation (products, designs, articles)
- **Frequency:** Once daily at 06:00 AM
- **Cost:** ~$0.10-0.50/day (estimate)
- **Fallback:** If Claude API down, use pre-written templates

### 4. PostgreSQL Functions
- **get_daily_revenue()** → Today's revenue by platform
- **get_weekly_report()** → Last 7 days summary
- **get_recovery_forecast()** → When hit $10k goal?
- **get_platform_ranking()** → Which platform best performer?

---

## 4 Core n8n Workflows

### Workflow 1: Revenue Capture (Hourly, 00 * * * *)

**Trigger:** Hourly (top of hour)
**Duration:** 5-10 minutes
**Success rate target:** 95%+ (retries on failure)

**Steps:**
1. Query Gumroad API: Get sales since last hour
2. Query Etsy API: Get sales since last hour
3. Query Redbubble API: Get sales since last hour
4. Query Medium API/RSS: Get views + affiliate clicks
5. Parse all responses → normalize to (platform, amount, timestamp, item_id)
6. INSERT into revenue_summary table
7. Log success/failure to error_logs
8. Alert CFO if total_revenue < baseline (anomaly detection)

**Error handling:**
- Retry on API timeout (3x with exponential backoff)
- Log rate limit errors (check daily, don't retry immediately)
- Log auth errors (alert CFO — key expired?)
- Continue with other platforms if one fails

---

### Workflow 2: Content Generation (Daily, 06:00)

**Trigger:** Daily at 06:00 AM
**Duration:** 5-15 minutes (depends on Claude API response)
**Success rate target:** 90%+ (human review before publish)

**Steps:**
1. Query Claude API with 3 separate prompts:
   - Prompt A: Generate digital product (name + description + pricing)
   - Prompt B: Generate design brief (niche + dimensions + style)
   - Prompt C: Generate article outline (topic + keywords + length)

2. Format outputs:
   - Product: JSON (name, description, price, category)
   - Design: JSON (prompt, dimensions, style, niche)
   - Article: Markdown (outline, outline, keywords, length)

3. INSERT 3 records into content_queue with status="generated"

4. Notify COO (via file or dashboard): "3 new items ready for approval"

5. Log to content_generation_log (for quality tracking)

**Error handling:**
- If Claude API fails: Use templated defaults (pre-written product/article templates)
- If rate limit hit: Wait 1 hour, retry
- Log all AI-generated content (audit trail)

---

### Workflow 3: Automated Publishing (Daily, 09:00)

**Trigger:** Daily at 09:00 AM (after COO has time to approve)
**Duration:** 10-30 minutes (depends on platform response)
**Success rate target:** 85%+ (some platforms may have issues)

**Steps:**
1. Query content_queue: Get all items with status="approved"
2. For each approved item:
   a. Determine platform based on content_type
   b. Call appropriate publishing API:
      - Digital product → POST to Gumroad
      - Digital product → POST to Etsy
      - Design → POST to Redbubble
      - Article → POST to WordPress (via REST API)
      - Article → POST to Medium (via API or RSS)
   c. Capture response (published_url, success/fail)
   d. INSERT into publishing_log
   e. UPDATE content_queue (status="published")

3. Log all publishes (for content tracking + revenue correlation)

4. Alert CFO if any platform fails

**Error handling:**
- Invalid credentials → Alert CFO (key expired?)
- Rate limits → Log, retry tomorrow
- Content rejected (TOS) → Alert CFO (review content quality)
- Partial success (2 of 5 platforms fail) → Log and continue

---

### Workflow 4: Error Monitoring + Alerts (Continuous)

**Trigger:** Real-time (every workflow step)
**Duration:** Immediate (non-blocking)
**Escalation:** Critical errors alert CFO within 5 minutes

**Monitoring:**
- Every n8n workflow error → INSERT into error_logs
- Track error types:
  - API auth failures (key expired?)
  - Rate limits (retry later)
  - Invalid content (review needed)
  - Network failures (retry)

**Alerts:**
- Critical: Platform API down (50%+ failure rate) → Alert CFO immediately
- Warning: Single platform failed (retry tomorrow)
- Info: Minor API warnings → Log only

**Dashboard:** CFO can query error_logs anytime to see issues

---

## Database Schema

### Revenue Summary (Hourly Revenue Feed)
```sql
CREATE TABLE revenue_summary (
  id SERIAL PRIMARY KEY,
  platform VARCHAR(50), -- gumroad, etsy, redbubble, medium, wordpress
  revenue_amount DECIMAL(10,2),
  currency VARCHAR(3) DEFAULT 'USD',
  item_id VARCHAR(255), -- Product/article ID on platform
  item_name VARCHAR(255), -- What sold
  customer_id VARCHAR(255), -- Anonymized
  transaction_id VARCHAR(255),
  captured_at TIMESTAMP DEFAULT NOW(),
  synced_at TIMESTAMP
);
```

### Content Queue (Generation + Approval + Publishing)
```sql
CREATE TABLE content_queue (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(50), -- digital_product, pod_design, article
  title VARCHAR(255),
  description TEXT,
  metadata JSONB, -- Format-specific: pricing, dimensions, keywords
  status VARCHAR(50), -- generated, approved, published, failed
  created_at TIMESTAMP DEFAULT NOW(),
  approved_at TIMESTAMP,
  approved_by VARCHAR(255), -- COO name
  published_at TIMESTAMP,
  published_url VARCHAR(500),
  error_message TEXT
);
```

### Publishing Log (Audit Trail)
```sql
CREATE TABLE publishing_log (
  id SERIAL PRIMARY KEY,
  content_id INTEGER REFERENCES content_queue(id),
  platform VARCHAR(50),
  published_url VARCHAR(500),
  status VARCHAR(50), -- success, failed, rate_limited
  response_code INTEGER,
  error_message TEXT,
  published_at TIMESTAMP DEFAULT NOW()
);
```

### Error Logs (For Monitoring + Debugging)
```sql
CREATE TABLE error_logs (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100), -- revenue_capture, content_gen, publishing, etc
  error_type VARCHAR(100), -- api_auth, rate_limit, timeout, validation, etc
  error_message TEXT,
  context JSONB, -- What was being processed
  severity VARCHAR(50), -- info, warning, critical
  logged_at TIMESTAMP DEFAULT NOW(),
  resolved BOOLEAN DEFAULT FALSE
);
```

### Recovery Tracker (Financial Goal)
```sql
CREATE TABLE recovery_tracker (
  id SERIAL PRIMARY KEY,
  target_amount DECIMAL(12,2), -- $10,000
  recovered_amount DECIMAL(12,2) DEFAULT 0,
  as_of_date DATE,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## Security & Credentials

### API Keys (Stored in .env, NOT in n8n or code)
- Gumroad API key
- Etsy API key
- Redbubble API key
- Medium API token
- WordPress REST API token
- Claude API key
- Stripe API key (for unified tracking, optional)

### Key Rotation Strategy
- Check expiration monthly
- Log when key last used (in error_logs if auth fails)
- Alert CFO if key fails (they contact user if needed)

### Access Control
- n8n runs with minimal privileges (only needs to read/write DB tables it uses)
- PostgreSQL user `makinmoves` has limited schema access
- Error logs visible to CFO only (for debugging)

---

## Failure Modes & Recovery

| Failure Mode | Impact | Auto-Recovery | Manual Escalation |
|---|---|---|---|
| n8n workflow timeout | Revenue not captured this hour | Retry next hour | CFO checks logs |
| Platform API key expired | Platform stops generating revenue | ❌ Manual refresh needed | Alert CFO |
| Claude API rate limit | No new content generated | Wait 1 hour, retry | Use template fallback |
| PostgreSQL down | Revenue not logged | ❌ Critical | Alert CFO immediately |
| Publishing to wrong platform | Content misdirected | Publish to correct platform next day | Log in publishing_log |
| AI content low quality | Publish poor products | ❌ Manual review needed | CFO marks for deletion |

---

## Deployment Checklist (Days 1–2)

- [ ] All API credentials configured in `.env`
- [ ] n8n workflows created + tested individually
- [ ] PostgreSQL schema created + tested
- [ ] Workflow 1 (revenue capture) tested on ≥2 platforms
- [ ] Workflow 2 (content generation) tested (3 samples generated)
- [ ] Workflow 3 (publishing) tested on ≥2 platforms
- [ ] Workflow 4 (error monitoring) logging correctly
- [ ] CFO can query revenue_summary + run reports
- [ ] Error alerting working (CFO receives alerts)
- [ ] Full integration test (generate → approve → publish → revenue capture)
- [ ] Documentation complete (for next CTMO or CFO if questions arise)

---

## Success Metrics (By 2026-03-30 23:59)

**Technical:**
- ✓ All 4 workflows deployed + tested
- ✓ Zero silent failures (all errors logged)
- ✓ Revenue capture 95%+ success rate
- ✓ Publishing 85%+ success rate
- ✓ CFO can run autonomous queries without SQL

**Operational:**
- ✓ 3 months of content templates ready (for fallback)
- ✓ COO can approve/reject items in < 2 minutes
- ✓ n8n dashboard shows all workflow runs
- ✓ Error logs clean (no unresolved critical errors)

**Financial:**
- ✓ Revenue_summary table populated (test data)
- ✓ recovery_tracker initialized ($10,000 goal)
- ✓ CFO weekly/monthly reports generated successfully
- ✓ Cost baseline documented ($X/month for operations)

---

## Ongoing Operations (After March 31)

**Daily (CTMO):**
- Monitor n8n dashboard (5 min)
- Check error_logs for critical issues (5 min)
- Restart any failed workflows manually if needed

**Daily (CFO):**
- Run get_daily_revenue() → email/log result (5 min)

**Weekly (CFO):**
- Run get_weekly_report() → document performance (10 min)

**Monthly (CFO):**
- Run get_recovery_forecast() → update recovery progress (15 min)

**As-needed (Either):**
- Update API credentials if they expire
- Adjust n8n workflows if platform APIs change
- Optimize content generation prompts based on sales data

---

**Owner:** CTMO
**Status:** READY TO EXECUTE
**Next milestone:** Agents return recommendations → Integrate into workflows → Day 1 execution
