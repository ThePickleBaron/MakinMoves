# Pre-Launch Verification Checklist
## Must Complete By 2026-03-31 23:59 (12 Hours Before Week 1)

**Owner:** CTMO + CFO + COO
**Status:** CRITICAL (If any item fails, Week 1 launch is delayed)
**Last Updated:** 2026-03-29 17:00

---

## SECTION A: INFRASTRUCTURE (CTMO)

### Docker Services
- [ ] PostgreSQL running (`docker ps | grep postgres`)
- [ ] n8n running (`docker ps | grep n8n`)
- [ ] Redis running (`docker ps | grep redis`)
- [ ] Selenium running (`docker ps | grep selenium`)
- [ ] All services auto-start on reboot (`docker-compose.yml` configured)

**Test:**
```bash
docker-compose down
docker-compose up -d
sleep 30
docker ps
```
**Expected:** 5 services green, all started < 30 seconds

### PostgreSQL Database
- [ ] Database `makinmoves` exists
- [ ] User `makinmoves` exists with password
- [ ] All 5 schemas created:
  - [ ] `recovery_tracker` (target = $10,000)
  - [ ] `revenue_summary` (empty, ready for data)
  - [ ] `content_queue` (empty, ready for data)
  - [ ] `publishing_log` (empty, ready for data)
  - [ ] `error_logs` (empty, ready for logging)

**Test:**
```bash
docker exec mm-postgres psql -U makinmoves -d makinmoves -c "\dt"
```
**Expected:** 5 tables listed

### PostgreSQL Backup
- [ ] Backup script created (`scripts/backup-postgres.sh`)
- [ ] Backup runs daily (cron or scheduler)
- [ ] Backup location: `data/exports/postgres_backup_YYYY-MM-DD.sql`
- [ ] Test restore (verify backup works)

**Test:**
```bash
docker exec mm-postgres pg_dump -U makinmoves makinmoves > /tmp/test_backup.sql
wc -l /tmp/test_backup.sql  # Should be > 100 lines
```
**Expected:** Backup file > 100 lines

---

## SECTION B: n8n WORKFLOWS (CTMO)

### Workflow 1: Revenue Capture (Hourly)

- [ ] Workflow created in n8n
- [ ] Trigger: Cron `00 * * * *` (hourly, top of hour)
- [ ] Steps implemented:
  - [ ] Query Gumroad API
  - [ ] Query Etsy API
  - [ ] Query Redbubble API
  - [ ] Query Medium API/RSS
  - [ ] Normalize responses
  - [ ] INSERT into revenue_summary
  - [ ] Error handler (log failures)

**Test (run manually):**
```
n8n UI: Open Workflow 1 → Click "Execute" → Verify:
- Each API returns data (or empty if no sales yet)
- Data inserted into revenue_summary
- No errors in n8n execution log
```
**Expected:** 5 API calls, 0 errors, revenue_summary updated

### Workflow 2: Content Generation (Daily, 06:00)

- [ ] Workflow created in n8n
- [ ] Trigger: Cron `00 06 * * *` (daily, 06:00 AM)
- [ ] Steps implemented:
  - [ ] Call Claude API (Prompt A: Digital product)
  - [ ] Call Claude API (Prompt B: PoD design)
  - [ ] Call Claude API (Prompt C: Affiliate article)
  - [ ] Format responses (JSON/Markdown)
  - [ ] INSERT 3 records into content_queue
  - [ ] Status: "generated"
  - [ ] Error handler

**Test (run manually):**
```
n8n UI: Open Workflow 2 → Click "Execute" → Verify:
- 3 items generated (check Claude responses)
- 3 INSERTs into content_queue
- Status all "generated"
- No errors
```
**Expected:** 3 items in content_queue, status="generated"

### Workflow 3: Publishing (Daily, 09:00)

- [ ] Workflow created in n8n
- [ ] Trigger: Cron `00 09 * * *` (daily, 09:00 AM)
- [ ] Steps implemented:
  - [ ] Query content_queue for status="approved"
  - [ ] For each item, call appropriate platform API:
    - [ ] Gumroad POST /products
    - [ ] Etsy POST /listings
    - [ ] Redbubble POST /designs
    - [ ] WordPress POST /posts
    - [ ] Medium POST /stories (or RSS sync)
  - [ ] Capture published URLs
  - [ ] INSERT into publishing_log
  - [ ] UPDATE content_queue (status="published")
  - [ ] Error handler

**Test (manual insert + run):**
```sql
-- Insert 1 test item
INSERT INTO content_queue (content_type, title, description, status)
VALUES ('digital_product', 'Test Product', 'Test', 'approved');

-- Run Workflow 3
n8n UI: Click "Execute"

-- Verify
SELECT * FROM publishing_log ORDER BY id DESC LIMIT 1;
SELECT * FROM content_queue WHERE title='Test Product';
```
**Expected:** publishing_log has 1+ entries, content_queue status="published"

### Workflow 4: Error Monitoring (Real-time)

- [ ] Error handlers attached to all 3 workflows
- [ ] All errors → error_logs table
- [ ] Severity levels: info, warning, critical
- [ ] Retry logic for transient errors

**Test:**
```sql
SELECT COUNT(*) as error_count FROM error_logs;
```
**Expected:** 0 errors (clean start)

---

## SECTION C: API CREDENTIALS (CTMO)

### Environment Variables (.env)

- [ ] `.env` file exists at project root
- [ ] File NOT committed to git (in .gitignore)
- [ ] Contains:
  ```
  GUMROAD_API_KEY=[key]
  ETSY_API_KEY=[key]
  ETSY_SHOP_ID=[id]
  REDBUBBLE_API_KEY=[key]
  MEDIUM_API_KEY=[key]
  WORDPRESS_REST_USER=[user]
  WORDPRESS_REST_PASSWORD=[password]
  WORDPRESS_API_URL=[url]
  CLAUDE_API_KEY=[key]
  STRIPE_SECRET_KEY=[key]
  POSTGRES_PASSWORD=makinmoves
  POSTGRES_USER=makinmoves
  POSTGRES_DB=makinmoves
  POSTGRES_HOST=localhost
  POSTGRES_PORT=5432
  ```

**Test (n8n environment):**
```
n8n UI: Settings → Environment → Check all variables loaded
```
**Expected:** No "undefined" variables in n8n workflows

### API Key Validation

- [ ] Gumroad API key works (GET /me returns your account)
- [ ] Etsy API key works (GET /shops/{shop_id} returns your shop)
- [ ] Redbubble API key works (GET /account returns account)
- [ ] Medium API key works (GET /me returns your profile)
- [ ] WordPress API works (GET /wp-json/wp/v2/posts returns posts)
- [ ] Claude API key works (single test call succeeds)
- [ ] Stripe API key works (GET /customers returns paginated list)

**Test Script (create `scripts/validate-keys.sh`):**
```bash
#!/bin/bash
echo "Validating API keys..."

# Gumroad
curl -H "Authorization: Bearer $GUMROAD_API_KEY" \
  https://api.gumroad.com/v2/me
echo "✓ Gumroad"

# Etsy
curl -H "Authorization: Bearer $ETSY_API_KEY" \
  "https://api.etsy.com/v3/application/users/me"
echo "✓ Etsy"

# Redbubble (adjust based on actual API)
curl -H "X-API-Key: $REDBUBBLE_API_KEY" \
  https://api.redbubble.com/account
echo "✓ Redbubble"

# WordPress
curl -u "$WORDPRESS_REST_USER:$WORDPRESS_REST_PASSWORD" \
  "$WORDPRESS_API_URL/wp-json/wp/v2/posts?per_page=1"
echo "✓ WordPress"

# Claude
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $CLAUDE_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-sonnet-20240229","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
echo "✓ Claude"

echo "All keys validated!"
```

**Run:**
```bash
bash scripts/validate-keys.sh
```
**Expected:** All ✓ marks, no 401/403 errors

---

## SECTION D: DATABASE QUERIES (CFO)

### Query 1: Daily Revenue Summary
- [ ] Query returns results (even if 0 rows for new database)
- [ ] Columns: platform, transactions, daily_revenue
- [ ] No SQL errors

**Test:**
```sql
SELECT
  COALESCE(platform, 'TOTAL') as platform,
  COUNT(*) as transactions,
  SUM(revenue_amount) as daily_revenue
FROM public.revenue_summary
WHERE DATE_TRUNC('day', captured_at) = CURRENT_DATE
GROUP BY ROLLUP(platform);
```
**Expected:** Returns, likely 0 rows (no revenue yet)

### Query 2: Recovery Progress
- [ ] Query returns recovery_tracker record
- [ ] Target = $10,000
- [ ] recovered_amount = 0 (starting value)

**Test:**
```sql
SELECT
  target_amount,
  recovered_amount,
  (target_amount - recovered_amount) as remaining,
  ROUND((recovered_amount / target_amount * 100), 2) as pct_complete
FROM public.recovery_tracker
ORDER BY created_at DESC LIMIT 1;
```
**Expected:** target=10000, recovered=0, pct_complete=0.00

### Query 3: Error Summary
- [ ] Query runs without error
- [ ] Returns 0 rows (clean slate)

**Test:**
```sql
SELECT
  error_type,
  severity,
  COUNT(*) as count
FROM error_logs
WHERE logged_at >= NOW() - INTERVAL '24 hours'
GROUP BY error_type, severity;
```
**Expected:** 0 rows

### Query 4: Publishing Performance
- [ ] Query runs without error
- [ ] Returns 0 rows initially

**Test:**
```sql
SELECT
  platform,
  COUNT(*) as attempts,
  COUNT(*) FILTER (WHERE status='success') as successes,
  ROUND(100.0 * COUNT(*) FILTER (WHERE status='success') / COUNT(*), 1) as pct
FROM publishing_log
WHERE published_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY platform;
```
**Expected:** 0 rows (no publishes yet)

---

## SECTION E: CONTENT TEMPLATES (COO)

### Digital Product Templates
- [ ] 10+ templates created (product name, description, pricing)
- [ ] Format: JSON or CSV
- [ ] Location: `templates/digital_products_library.json`
- [ ] Each has: name, category, description, base_price, tags

**Sample:**
```json
[
  {
    "name": "Social Media Post Templates Bundle",
    "category": "templates",
    "description": "50+ ready-to-edit templates for Instagram, TikTok, LinkedIn",
    "base_price": 9.99,
    "tags": ["templates", "social-media", "canva"]
  }
]
```

### PoD Design Briefs
- [ ] 10+ design briefs created
- [ ] Format: JSON
- [ ] Location: `templates/pod_design_briefs.json`
- [ ] Each has: niche, product_type, style, color_palette, size_specs

**Sample:**
```json
[
  {
    "niche": "sustainable_living",
    "product_type": "t-shirt",
    "design_prompt": "Minimalist eco-friendly lifestyle graphic",
    "style": "line art, minimal, monochrome",
    "color_palette": ["#2d3436", "#ffffff"],
    "sizes": ["front_chest", "full_back"]
  }
]
```

### Article Outlines
- [ ] 10+ article outlines created
- [ ] Format: Markdown
- [ ] Location: `templates/article_outlines/`
- [ ] Each has: title, keywords, outline, length, affiliate_opportunities

**Sample:**
```markdown
# How to Start a Side Hustle With Zero Upfront Cost

## Keywords
- side hustle, passive income, no money to start, beginner

## Outline
1. Why side hustles matter (intro)
2. 5 ways to start with zero cost
   - Freelance writing
   - Virtual assistant
   - Affiliate marketing
   - Digital products
   - Passive content
3. Fastest to first $100
4. Common mistakes
5. Tools to scale (affiliate links here)

## Length: 1500–2000 words
## Affiliate links: [Tool A], [Tool B], [Course C]
```

---

## SECTION F: CONTENT QUEUE INITIALIZATION (CFO/COO)

### Pre-Load Test Content
- [ ] Insert 3 test items into content_queue
- [ ] Status: "generated" (simulating Claude output)
- [ ] Ready for manual approval test

**Test:**
```sql
INSERT INTO content_queue (content_type, title, description, metadata, status)
VALUES
  ('digital_product', 'Test Product 1', 'Description', '{"price":9.99}', 'generated'),
  ('pod_design', 'Test Design 1', 'Design brief', '{"niche":"tech"}', 'generated'),
  ('article', 'Test Article 1', 'Article outline', '{"keywords":["test"]}', 'generated');

SELECT * FROM content_queue WHERE status='generated';
```
**Expected:** 3 rows, all status="generated"

### Manual Approval Test
- [ ] COO approves 1 item (UPDATE to status="approved")
- [ ] COO rejects 1 item (UPDATE to status="rejected")
- [ ] Workflow 3 publishing triggered with approved item

**Test:**
```sql
UPDATE content_queue SET status='approved' WHERE id=1;
UPDATE content_queue SET status='rejected' WHERE id=2;

-- Check that Workflow 3 can find approved items
SELECT * FROM content_queue WHERE status='approved';
```
**Expected:** 1 row with approved status

---

## SECTION G: EMAIL REPORTING (CFO)

### Email Configuration
- [ ] Email service configured (SMTP or SendGrid)
- [ ] Test email sends successfully
- [ ] Daily email template ready
- [ ] Weekly email template ready

**Test:**
```
Send test email to user's address
Subject: "Trinity Test Email — 2026-03-31"
Body: "Systems ready for Week 1 launch"
Result: Email received within 5 minutes
```
**Expected:** Email delivered successfully

### Report Templates
- [ ] Daily report template saved (`logs/template_daily_report.md`)
- [ ] Weekly report template saved (`logs/template_weekly_report.md`)
- [ ] Both templates include all required metrics

---

## SECTION H: DOCUMENTATION (CTMO)

### Week 1 Roadmap
- [ ] Completed: `ctmo/outbox/WEEK1_AUTONOMOUS_ROADMAP_TRINITY_2026-04-01-07.md`
- [ ] Contains: Hour-by-hour schedule, checkpoints, decision trees
- [ ] Available at: C:\Users\jsmcl\documents\makinmoves\ctmo\outbox\

### Quick Reference Card
- [ ] Completed: `ctmo/outbox/WEEK1_QUICK_REFERENCE_OPERATIONS.md`
- [ ] Contains: Daily schedule, decision trees, queries, alerts
- [ ] Printable and clear

### Architecture Documentation
- [ ] System architecture updated: `ctmo/technical/`
- [ ] API mappings documented
- [ ] Database schema documented
- [ ] n8n workflow descriptions documented
- [ ] Failure modes and recovery documented

---

## SECTION I: MONITORING & ALERTS (CTMO)

### n8n Monitoring Dashboard
- [ ] n8n dashboard accessible (http://localhost:5678)
- [ ] All 4 workflows scheduled:
  - [ ] Workflow 1: Hourly (00 * * * *)
  - [ ] Workflow 2: Daily 06:00 (00 06 * * *)
  - [ ] Workflow 3: Daily 09:00 (00 09 * * *)
  - [ ] Workflow 4: Real-time error handlers
- [ ] Execution history visible

**Test:**
```
n8n UI → Workflows → Check each workflow:
- Status: Active
- Last run: Success
- Next run: Scheduled correctly
```
**Expected:** All 4 active, all scheduled

### Error Logging
- [ ] error_logs table initialized
- [ ] Error handlers in all n8n workflows
- [ ] Critical errors escalate to error_logs
- [ ] CFO can query error_logs

**Test:**
```sql
SELECT COUNT(*) FROM error_logs;
```
**Expected:** 0 (clean start)

### Alert Trigger Points
- [ ] Revenue = $0 after 48h → Flag
- [ ] Error count > 30/hour → Flag
- [ ] Publishing success < 50% → Flag
- [ ] API auth failures → Flag immediately
- [ ] Database offline → Alert CTMO

---

## SECTION J: ROLLBACK PLAN (Emergency)

### If Launch Must Be Delayed
- [ ] All systems documented for next attempt
- [ ] All API credentials secure (not exposed)
- [ ] No data loss (backups exist)
- [ ] Can retry within 24 hours

**Checklist:**
- [ ] Is there a critical blocker?
- [ ] Can it be fixed in < 2 hours?
- [ ] If not, delay launch to next day

---

## SECTION K: FINAL SIGN-OFF (Before 2026-03-31 23:59)

### CTMO Verification
```
CTMO: Please verify and sign off

Date: _____________
All infrastructure items passing? YES / NO
All n8n workflows tested? YES / NO
All API credentials validated? YES / NO
All documentation complete? YES / NO

Signature/Confirmation: ___________________
```

### CFO Verification
```
CFO: Please verify and sign off

Date: _____________
All database queries working? YES / NO
Recovery tracker initialized? YES / NO
Email reporting ready? YES / NO
Monitoring thresholds set? YES / NO

Signature/Confirmation: ___________________
```

### COO Verification
```
COO: Please verify and sign off

Date: _____________
Content templates ready (30+ items)? YES / NO
Approval workflow tested? YES / NO
Publishing paths tested manually? YES / NO
Understood minimal touch model? YES / NO

Signature/Confirmation: ___________________
```

---

## SCORING: Go/No-Go Decision

**If ANY section has unchecked items:**
→ **NO-GO** (delay launch, fix blockers)

**If ALL sections complete:**
→ **GO** (launch Week 1 at 2026-04-01 00:00)

---

**Status: READY FOR VERIFICATION**
**Deadline: 2026-03-31 23:59**
**Next: Week 1 Launch (2026-04-01 00:00)**

---

**Questions before launch?**
- Contact CTMO (infrastructure)
- Contact CFO (financials/reporting)
- Contact COO (content/operations)

**REMEMBER:** After March 31 midnight, ALL three must operate autonomously. No fixes allowed until April 7.
