# n8n Workflow Implementation Guide
## Detailed Technical Setup for Autonomous Operation

**Owner:** CTMO
**Timeline:** 6–8 hours (Days 1–2)
**Status:** Instructions for building 4 autonomous workflows

---

## Prerequisites (Before Starting)

- [ ] n8n running on Docker (`docker ps` shows n8n container)
- [ ] PostgreSQL running and accessible
- [ ] All API keys obtained:
  - Gumroad API key
  - Etsy OAuth credentials
  - Redbubble API status (check if available)
  - Medium API key or RSS feed access
  - WordPress REST API credentials
  - Claude API key (for Anthropic)
  - Stripe/PayPal (if using for unified payment tracking)
- [ ] n8n credential manager accessible (http://localhost:5678 → Credentials)

---

## WORKFLOW 1: Revenue Capture (Hourly)

**File:** `board/CTMO/n8n_workflows/revenue_capture_hourly.json`

**Purpose:** Every hour, pull sales data from all platforms → store in PostgreSQL

### Build Steps

#### Step 1: Create n8n Workflow
1. Open n8n: http://localhost:5678
2. Create new workflow: `revenue_capture_hourly`
3. Add **Trigger node:** "Cron" (interval: Every hour at :00)

#### Step 2: Add Gumroad Revenue Step
1. Add node: "Gumroad" (or HTTP request if native node unavailable)
2. Authentication: Use saved Gumroad API credential
3. API call: `GET /api/v2/sales` with parameters:
   - `limit: 100`
   - `sort_order: desc`
   - `sort_by: created_at`
4. Parse response: Extract transactions from last hour
   ```javascript
   // Transform data into standardized format
   $json.data.map(sale => ({
     platform: 'gumroad',
     transaction_id: sale.id,
     amount: sale.price,
     fees: sale.price * 0.08,  // Gumroad is ~8% fees
     net: sale.price * 0.92,
     timestamp: new Date(sale.created_at),
     status: 'captured'
   }))
   ```

#### Step 3: Add Etsy Revenue Step
1. Add node: "Etsy" (or HTTP request)
2. Authentication: Use saved Etsy API credential
3. API call: `GET /v3/application/shops/{shopId}/orders`
   - Filter: Created in last hour
4. Parse response:
   ```javascript
   $json.results.map(order => ({
     platform: 'etsy',
     transaction_id: order.receipt_id,
     amount: order.total_price,
     fees: order.total_price * 0.1,  // Etsy is ~10% + payment
     net: order.total_price * 0.85,
     timestamp: new Date(order.create_timestamp * 1000),
     status: 'captured'
   }))
   ```

#### Step 4: Add Redbubble Revenue Step
**Note:** Redbubble may not have official API. Fallback options:
- Option A: Use CSV export (manual monthly, not real-time)
- Option B: Use Selenium to scrape dashboard (unreliable)
- Option C: Skip for now; start with Gumroad + Etsy

If API available:
1. Add node: "Redbubble" (HTTP request)
2. API call: Get sales from last hour
3. Parse response similarly to above

If using manual export:
1. Add a note: "Redbubble revenue captured manually via CSV export"
2. Schedule manual import weekly

#### Step 5: Add Medium Revenue Step
**Note:** Medium Partner Program has limited API access.

Option A: Use Medium RSS + email notifications
- Medium sends weekly payout summaries to email
- Parse those emails for revenue data

Option B: Manual monthly import
- Add a note: "Medium revenue tracked via earnings dashboard"
- Import monthly once received

#### Step 6: Add WordPress Affiliate Step
1. Add node: "WordPress" (HTTP request using REST API)
2. Authentication: Use saved WordPress credential
3. API call: Query affiliate plugin database or API
   ```
   GET /wp-json/affiliate_plugin/v1/earnings
   Filter: created in last hour
   ```
4. Parse response:
   ```javascript
   $json.data.map(affiliate => ({
     platform: 'wordpress_affiliate',
     transaction_id: affiliate.id,
     amount: affiliate.commission,
     fees: 0,  // No platform fees on affiliates
     net: affiliate.commission,
     timestamp: new Date(affiliate.created_at),
     status: 'captured'
   }))
   ```

#### Step 7: Merge All Transactions
1. Add node: "Merge" (combine Gumroad, Etsy, Redbubble, Medium, WordPress outputs)
2. Output: Single array of all transactions

#### Step 8: Insert Into PostgreSQL
1. Add node: "PostgreSQL" (Postgres Execute Query)
2. Credentials: Use saved PostgreSQL credential
3. Query: Insert all transactions
   ```sql
   INSERT INTO revenue_summary
   (platform, transaction_id, amount, fees, net, timestamp, status)
   VALUES
   ($1, $2, $3, $4, $5, $6, $7)
   ON CONFLICT (transaction_id) DO NOTHING;
   ```
4. Map input: Each transaction field → parameter

#### Step 9: Log Results
1. Add node: "File Write"
2. Output: Write success/failure log
   ```
   /logs/revenue_capture_YYYY-MM-DD_HH.log

   Timestamp: [NOW]
   Transactions captured:
   - Gumroad: X
   - Etsy: Y
   - Redbubble: Z
   - Medium: A
   - WordPress: B
   Total: X+Y+Z+A+B
   Status: Success/Failed
   ```

#### Step 10: Error Handling
1. Add "Catch" node after each platform step
2. On error:
   - Log error to file with platform name + error message
   - Continue workflow (don't stop)
   - Retry logic: Add "Retry" node with 3 attempts, exponential backoff

#### Step 11: Test Workflow
1. Click "Test" in n8n
2. Verify output:
   - All 5 platforms return data ✓
   - Data inserted into PostgreSQL ✓
   - Log file created ✓
3. Check PostgreSQL:
   ```sql
   SELECT COUNT(*), platform FROM revenue_summary
   WHERE timestamp > NOW() - INTERVAL '1 hour'
   GROUP BY platform;
   ```

#### Step 12: Deploy & Schedule
1. Save workflow
2. Deploy to live environment
3. Configure trigger: Every hour at :00
4. Test: Wait for next hour boundary; verify data captured

---

## WORKFLOW 2: Content Generation (Daily)

**File:** `board/CTMO/n8n_workflows/content_generation_daily.json`

**Purpose:** Every morning at 06:00 AM, generate new content via Claude API

### Build Steps

#### Step 1: Create n8n Workflow
1. Create new workflow: `content_generation_daily`
2. Add **Trigger node:** "Cron" (Every day at 06:00 AM)

#### Step 2: Query Content Queue
1. Add node: "PostgreSQL" (Postgres Execute Query)
2. Query: Get next content idea from queue
   ```sql
   SELECT * FROM content_ideas
   WHERE status = 'pending'
   ORDER BY priority DESC, created_at ASC
   LIMIT 1;
   ```
3. Output: One content idea with type, niche, description

#### Step 3: Generate Digital Product (Claude API)
1. Add node: "HTTP Request" (Call Claude API)
2. URL: `https://api.anthropic.com/v1/messages`
3. Method: POST
4. Headers:
   ```
   x-api-key: [CLAUDE_API_KEY]
   anthropic-version: 2023-06-01
   content-type: application/json
   ```
5. Body:
   ```json
   {
     "model": "claude-3-5-sonnet-20241022",
     "max_tokens": 2000,
     "messages": [
       {
         "role": "user",
         "content": "Generate a digital product template for the [NICHE] niche:\n- Type: [PRODUCT_TYPE]\n- Target audience: [AUDIENCE]\n- Format: [Notion table, PDF guide, etc.]\n- Quality: Professional, ready to sell\n- Price point: $[PRICE]\n\nProvide:\n1. Product title\n2. Description (50 words)\n3. Content outline (main sections)\n4. Preview text (what buyer gets)\n5. Suggested variations (3 ideas)\n\nMake it specific, actionable, and valuable."
       }
     ]
   }
   ```
6. Parse response: Extract content from Claude output
   ```javascript
   const response = $json.content[0].text;
   return {
     type: 'digital_product',
     title: response.match(/Product title:\s*(.+)/i)[1],
     description: response.match(/Description:\s*(.+)/i)[1],
     content: response,
     niche: $json.niche,
     generated_at: new Date(),
     quality_score: 8  // Default good score
   }
   ```

#### Step 4: Generate PoD Design (Claude API)
1. Add node: "HTTP Request" (Call Claude API)
2. Body:
   ```json
   {
     "model": "claude-3-5-sonnet-20241022",
     "max_tokens": 1500,
     "messages": [
       {
         "role": "user",
         "content": "Design a Print-on-Demand product for [NICHE]:\n- Format: T-shirt, hoodie, or mug design\n- Style: Modern, trendy, professional\n- Text: Include witty phrase or quote\n- Color palette: 2–3 colors max\n\nProvide:\n1. Design title\n2. Visual description (what to create in Canva)\n3. Text content for design\n4. Color recommendations\n5. Suggested products (t-shirt, hoodie, mug, etc.)\n\nBe specific enough that someone could execute in Canva in 5 minutes."
       }
     ]
   }
   ```
3. Parse response:
   ```javascript
   const response = $json.content[0].text;
   return {
     type: 'pod_design',
     title: response.match(/Design title:\s*(.+)/i)[1],
     description: response.match(/Visual description:\s*(.+?)(?=Text content|$)/is)[1],
     text_content: response.match(/Text content for design:\s*(.+?)(?=Color|$)/is)[1],
     colors: response.match(/Color recommendations:\s*(.+?)(?=Suggested|$)/is)[1],
     suggested_products: response.match(/Suggested products:\s*(.+?)$/is)[1],
     generated_at: new Date(),
     quality_score: 8
   }
   ```

#### Step 5: Generate Affiliate Article (Claude API)
1. Add node: "HTTP Request" (Call Claude API)
2. Body:
   ```json
   {
     "model": "claude-3-5-sonnet-20241022",
     "max_tokens": 3000,
     "messages": [
       {
         "role": "user",
         "content": "Write an affiliate article for [NICHE]:\n- Topic: [TOPIC]\n- Audience: [AUDIENCE]\n- Affiliate products: [PRODUCTS to link]\n- Length: 1200–1500 words\n- Tone: Friendly, helpful, not salesy\n- Include: Introduction, 3–4 main sections, comparison table, conclusion\n\nFormat as Markdown with:\n- H1 title\n- H2 section headers\n- [AFFILIATE_LINK] placeholders for links\n- Bullet points where appropriate\n- Clear value proposition\n\nMake it SEO-friendly and conversion-ready."
       }
     ]
   }
   ```
3. Parse response:
   ```javascript
   const response = $json.content[0].text;
   return {
     type: 'affiliate_article',
     title: response.match(/^# (.+)/m)[1],
     content: response,
     word_count: response.split(/\s+/).length,
     generated_at: new Date(),
     quality_score: 8,
     affiliate_links: (response.match(/\[AFFILIATE_LINK\]/g) || []).length
   }
   ```

#### Step 6: Store All Generated Content
1. Add node: "PostgreSQL" (Postgres Execute Query)
2. Query: Insert 3 items into `generated_content` table
   ```sql
   INSERT INTO generated_content
   (type, title, description, content, niche, generated_at, status, quality_score)
   VALUES
   ($1, $2, $3, $4, $5, $6, 'pending_review', $7)
   RETURNING id;
   ```

#### Step 7: Update Content Queue
1. Add node: "PostgreSQL" (Mark content idea as used)
2. Query:
   ```sql
   UPDATE content_ideas
   SET status = 'generated', generated_count = generated_count + 1
   WHERE id = $1;
   ```

#### Step 8: Log Generation
1. Add node: "File Write"
2. Output:
   ```
   /logs/content_generation_YYYY-MM-DD.log

   Generated at: [TIME]
   - Product: [TITLE]
   - Design: [TITLE]
   - Article: [TITLE] ([WORD_COUNT] words)
   All stored in generated_content table
   Status: Ready for quality review
   ```

#### Step 9: Error Handling
1. Add "Catch" node for Claude API failures
2. On error: Log failure; retry 1x after 5 minutes
3. If 2nd attempt fails: Skip content generation for day; log escalation

#### Step 10: Test Workflow
1. Ensure content_ideas table has ≥1 pending idea
2. Click "Test"
3. Verify:
   - Claude API returns content ✓
   - Content stored in PostgreSQL ✓
   - Log file created ✓
4. Check database:
   ```sql
   SELECT type, COUNT(*) FROM generated_content
   WHERE generated_at::date = TODAY()
   GROUP BY type;
   ```

#### Step 11: Deploy & Schedule
1. Save workflow
2. Deploy to live
3. Schedule: Every day at 06:00 AM
4. Test: Wait until 6 AM; verify content generated

---

## WORKFLOW 3: Publishing (Daily)

**File:** `board/CTMO/n8n_workflows/content_publishing_daily.json`

**Purpose:** Every morning at 09:00 AM, auto-publish generated content to all platforms

### Build Steps

#### Step 1: Create n8n Workflow
1. Create new workflow: `content_publishing_daily`
2. Add **Trigger node:** "Cron" (Every day at 09:00 AM)

#### Step 2: Query Ready Content
1. Add node: "PostgreSQL" (Get publishable content)
2. Query:
   ```sql
   SELECT * FROM generated_content
   WHERE status = 'approved' AND published_at IS NULL
   ORDER BY type, generated_at ASC
   LIMIT 10;  -- Publish up to 10 items/day
   ```
3. Output: Array of 3–10 content items

#### Step 3: Route by Content Type
1. Add node: "Switch" (conditional routing)
2. Condition 1: `type == 'digital_product'` → Publish to Gumroad
3. Condition 2: `type == 'pod_design'` → Publish to Etsy + Redbubble
4. Condition 3: `type == 'affiliate_article'` → Publish to WordPress + Medium

#### Step 4: Publish Digital Product to Gumroad
1. Add node: "Gumroad" (HTTP request)
2. URL: `https://api.gumroad.com/v2/products`
3. Method: POST
4. Body:
   ```json
   {
     "name": "[TITLE]",
     "description": "[DESCRIPTION]",
     "price": 19.99,
     "tags": "[NICHE], template, digital-product",
     "require_email": false,
     "content_email": "[BODY_PREVIEW]"
   }
   ```
5. Handle response:
   ```javascript
   return {
     platform: 'gumroad',
     product_id: $json.product.id,
     url: $json.product.url,
     published_at: new Date()
   }
   ```

#### Step 5: Publish PoD Design to Etsy
1. Add node: "Etsy" (HTTP request)
2. URL: `https://api.etsy.com/v3/application/shops/{shopId}/listings`
3. Method: POST
4. Body:
   ```json
   {
     "title": "[TITLE]",
     "description": "[DESCRIPTION]",
     "quantity": 999,
     "price": 1599,
     "tags": ["[NICHE]", "design", "print-on-demand"],
     "images": [
       {
         "rank": 0,
         "url": "[PREVIEW_IMAGE_URL]"
       }
     ]
   }
   ```

#### Step 6: Publish PoD Design to Redbubble
**Note:** Redbubble API may be limited. If unavailable, use this fallback:
1. Add node: "Manual step or skip"
2. Note: "Redbubble design queued for manual upload"
3. Output log for COO to review

Or if API available:
1. Add node: "Redbubble" (HTTP request)
2. API call: POST new design
3. Map design content to Redbubble product format

#### Step 7: Publish Article to WordPress
1. Add node: "WordPress" (HTTP request)
2. URL: `http://your-site.com/wp-json/wp/v2/posts`
3. Method: POST
4. Body:
   ```json
   {
     "title": "[ARTICLE_TITLE]",
     "content": "[ARTICLE_CONTENT_WITH_AFFILIATE_LINKS]",
     "excerpt": "[FIRST_100_WORDS]",
     "status": "publish",
     "categories": [5],
     "tags": ["[NICHE]", "affiliate"],
     "date": "2026-04-01T09:00:00"
   }
   ```
5. Handle response:
   ```javascript
   return {
     platform: 'wordpress',
     post_id: $json.id,
     url: $json.link,
     published_at: new Date()
   }
   ```

#### Step 8: Cross-Post to Medium
1. Add node: "Medium" (HTTP request or RSS import)
2. Option A: If Medium API available:
   ```
   POST https://api.medium.com/v1/users/{userId}/posts
   With article content
   ```
3. Option B: If no API, use RSS:
   - Configure WordPress RSS feed
   - Medium can import from RSS automatically
   - Set up Medium publication to auto-import from WordPress feed

#### Step 9: Update Publishing Log
1. Add node: "PostgreSQL"
2. Query:
   ```sql
   UPDATE generated_content
   SET published_at = NOW(),
       status = 'published',
       platform_urls = $1
   WHERE id = $2;

   INSERT INTO publishing_log
   (content_id, platform, url, published_at)
   VALUES ($2, $3, $4, NOW());
   ```

#### Step 10: Log All Publishes
1. Add node: "File Write"
2. Output:
   ```
   /logs/publishing_YYYY-MM-DD.log

   Published at: [TIME]

   Digital Products:
   - [TITLE] → Gumroad ([URL])

   PoD Designs:
   - [TITLE] → Etsy ([URL])
   - [TITLE] → Redbubble ([STATUS])

   Affiliate Articles:
   - [TITLE] → WordPress ([URL])
   - [TITLE] → Medium ([STATUS])

   Total: X items published
   ```

#### Step 11: Error Handling
1. Add "Catch" nodes for each platform
2. On publish failure:
   - Log error with platform + content ID
   - Mark content as `status = 'publish_failed'`
   - Retry next day
   - Alert if failure persists

#### Step 12: Test Workflow
1. Prepare test content in `generated_content` table
2. Mark as `status = 'approved'`
3. Click "Test"
4. Verify:
   - Content posted to Gumroad ✓
   - Content posted to Etsy ✓
   - Content posted to WordPress ✓
   - Publishing log created ✓

#### Step 13: Deploy & Schedule
1. Save workflow
2. Deploy to live
3. Schedule: Every day at 09:00 AM (3 hours after content generation)
4. Test: Create test content day before; verify it publishes next morning

---

## WORKFLOW 4: Error Monitoring & Alerts (Continuous)

**File:** `board/CTMO/n8n_workflows/error_monitoring_continuous.json`

**Purpose:** Every 15 minutes, check for failures and escalate issues

### Build Steps

#### Step 1: Create n8n Workflow
1. Create new workflow: `error_monitoring_continuous`
2. Add **Trigger node:** "Cron" (Every 15 minutes)

#### Step 2: Check Workflow Execution History
1. Add node: "PostgreSQL"
2. Query: Get recent failed transactions
   ```sql
   SELECT platform, COUNT(*) as error_count, MAX(timestamp) as last_error
   FROM revenue_summary
   WHERE status = 'failed' AND timestamp > NOW() - INTERVAL '1 hour'
   GROUP BY platform
   HAVING COUNT(*) > 0;
   ```
3. Output: List of platforms with errors

#### Step 3: Check API Authentication Failures
1. Add node: "PostgreSQL"
2. Query:
   ```sql
   SELECT DISTINCT platform, error_message
   FROM automation_logs
   WHERE status = 'failed'
     AND error_message LIKE '%401%' OR error_message LIKE '%auth%'
   AND timestamp > NOW() - INTERVAL '1 hour'
   LIMIT 5;
   ```
3. Output: Authentication failures (API key expired, etc.)

#### Step 4: Check Platform Bans/Suspensions
1. Add node: "HTTP Request" (check platform status)
2. For each active platform:
   - Check if account is still active
   - Check if any listings suspended
   - Check for policy violations
3. Example for Gumroad:
   ```
   GET https://api.gumroad.com/v2/user
   If status != 'active' → Flag as account issue
   ```

#### Step 5: Categorize Alerts
1. Add node: "Switch" (categorize by severity)
2. Category 1: **RED ALERT** (revenue capture failing)
   - Condition: 5+ platforms with errors in last hour
   - Action: Escalate immediately
3. Category 2: **AUTH ALERT** (API key expired)
   - Condition: Authentication failures detected
   - Action: Flag for manual refresh
4. Category 3: **PLATFORM ALERT** (Account suspended)
   - Condition: Account status not active
   - Action: Escalate immediately

#### Step 6: Create CRITICAL Escalation
1. Add node: "File Write"
2. If RED ALERT or PLATFORM ALERT:
   ```
   /alerts/CRITICAL_[YYYY-MM-DD_HHMM].md

   # CRITICAL ALERT — [ISSUE_TYPE]
   **Timestamp:** [TIME]
   **Severity:** CRITICAL

   ## Issue
   [DESCRIPTION OF PROBLEM]

   ## Affected Platform(s)
   - [PLATFORM]: [ERROR_MESSAGE]

   ## Required Action
   - CTMO: Check API credentials
   - CFO: Pause automation if revenue capture failing
   - CEO: Review escalation

   ---
   Auto-generated by error_monitoring_continuous
   ```

#### Step 7: Create WARNING Log
1. Add node: "File Write"
2. For YELLOW/WARNING conditions:
   ```
   /alerts/WARNING_[YYYY-MM-DD_HHMM].md

   # WARNING — [ISSUE_TYPE]
   **Timestamp:** [TIME]
   **Severity:** WARNING

   ## Issue
   [DESCRIPTION]

   ## Metrics
   - Failed transactions: X
   - Affected platform(s): [LIST]
   - Last occurrence: [TIME]

   ## Recommendation
   [AUTO-GENERATED SUGGESTION]

   ---
   Auto-generated by error_monitoring_continuous
   ```

#### Step 8: Post to Slack (If Integrated)
1. Add node: "Slack" (if Slack credential available)
2. For CRITICAL alerts:
   ```
   Channel: #automation-critical
   Message:
   :red_circle: **CRITICAL ALERT**
   [ISSUE_TYPE]: [PLATFORM]
   Action required: [WHAT TO DO]
   Timestamp: [TIME]
   ```
3. For WARNING alerts:
   ```
   Channel: #automation-alerts
   Message:
   :yellow_circle: **WARNING**
   [ISSUE_TYPE]: [DETAILS]
   ```

#### Step 9: Count Workflow Failures
1. Add node: "PostgreSQL"
2. Query: Get execution success/failure stats
   ```sql
   SELECT workflow_name, COUNT(*) as total_runs,
     COUNT(CASE WHEN status='success' THEN 1 END) as successes,
     COUNT(CASE WHEN status='failed' THEN 1 END) as failures,
     ROUND(100.0 * COUNT(CASE WHEN status='success' THEN 1 END) / COUNT(*), 1) as success_rate
   FROM automation_logs
   WHERE timestamp > NOW() - INTERVAL '1 day'
   GROUP BY workflow_name;
   ```

#### Step 10: Create Daily Summary Log
1. Add node: "File Write"
2. Daily at 23:55 (append to daily automation report):
   ```
   /logs/automation_health_YYYY-MM-DD.log

   # Automation Health Summary — [DATE]

   ## Workflow Execution
   - revenue_capture_hourly: X runs, Y% success rate
   - content_generation_daily: X runs, Y% success rate
   - content_publishing_daily: X runs, Y% success rate
   - error_monitoring_continuous: X runs, Y% success rate

   ## Critical Issues
   [COUNT] critical alerts
   [LIST if any]

   ## Warnings
   [COUNT] warnings
   [LIST if any]

   ## Recommendation
   [AUTO-GENERATED NEXT STEPS]
   ```

#### Step 11: Test Workflow
1. Manually insert failed transaction into revenue_summary
2. Click "Test"
3. Verify:
   - Error detected ✓
   - Alert file created ✓
   - Correct severity assigned ✓
   - Slack message sent (if configured) ✓

#### Step 12: Deploy & Schedule
1. Save workflow
2. Deploy to live
3. Schedule: Every 15 minutes
4. Monitor: First day, check alert accuracy

---

## POSTGRESQL AUTOMATION FUNCTIONS

**File:** `board/CTMO/postgres_automation_setup.sql`

```sql
-- Create automation_logs table
CREATE TABLE IF NOT EXISTS automation_logs (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100),
  status VARCHAR(20),  -- 'success', 'failed', 'error'
  error_message TEXT,
  execution_time TIMESTAMP DEFAULT NOW(),
  duration_seconds INT
);

-- Create automated log function
CREATE OR REPLACE FUNCTION log_automation_event(
  p_workflow_name VARCHAR,
  p_status VARCHAR,
  p_details TEXT DEFAULT NULL,
  p_duration INT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
  INSERT INTO automation_logs (workflow_name, status, error_message, duration_seconds)
  VALUES (p_workflow_name, p_status, p_details, p_duration);
END;
$$ LANGUAGE plpgsql;

-- Create content queue view
CREATE OR REPLACE VIEW content_queue_status AS
SELECT
  type,
  COUNT(*) as total,
  COUNT(CASE WHEN status='pending' THEN 1 END) as pending,
  COUNT(CASE WHEN status='generated' THEN 1 END) as generated,
  COUNT(CASE WHEN status='published' THEN 1 END) as published
FROM generated_content
GROUP BY type;

-- Create recovery progress function
CREATE OR REPLACE FUNCTION get_recovery_progress()
RETURNS TABLE (
  total_recovered DECIMAL,
  goal DECIMAL,
  percent_complete DECIMAL,
  projected_completion_date DATE
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COALESCE(SUM(net), 0)::DECIMAL as total_recovered,
    10000::DECIMAL as goal,
    ROUND(COALESCE(SUM(net), 0) / 10000 * 100, 1)::DECIMAL as percent_complete,
    CURRENT_DATE + INTERVAL '1 day' * (10000 - COALESCE(SUM(net), 0)) /
      NULLIF(COALESCE(SUM(net), 0) / EXTRACT(DAY FROM (CURRENT_DATE - '2026-03-31'::DATE)), 0) as projected_completion_date
  FROM revenue_summary
  WHERE timestamp >= '2026-03-31'::TIMESTAMP;
END;
$$ LANGUAGE plpgsql;
```

---

## TESTING CHECKLIST

Before deploying workflows to production:

- [ ] Workflow 1 (revenue): Tested with all 5 platforms ✓
- [ ] Workflow 2 (generation): Tested with Claude API ✓
- [ ] Workflow 3 (publishing): Tested with all 5 platforms ✓
- [ ] Workflow 4 (monitoring): Tested error detection ✓
- [ ] All error handling: Catches and retries tested ✓
- [ ] PostgreSQL queries: All functions execute without errors ✓
- [ ] Logging: All workflows generate logs ✓
- [ ] Scheduling: All cron triggers scheduled ✓
- [ ] API credentials: All verified and working ✓
- [ ] Backups: n8n workflows backed up to JSON ✓

---

## DEPLOYMENT CHECKLIST

Before going live April 1:

- [ ] All 4 workflows deployed to n8n production
- [ ] All schedules activated (revenue hourly, generation 6 AM, publishing 9 AM, monitoring every 15 min)
- [ ] All logging configured
- [ ] All alerts configured (Slack + file-based)
- [ ] PostgreSQL functions tested and active
- [ ] Backup system operational
- [ ] CTMO verified all systems working
- [ ] CEO sign-off on automation readiness

---

**Status:** Ready for implementation
**Timeline:** 6–8 hours
**Owner:** CTMO
**Next:** Execute, test, deploy by 2026-03-30 23:59
