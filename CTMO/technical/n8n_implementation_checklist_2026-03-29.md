# n8n Implementation Checklist: 36-Hour Sprint

**Purpose:** Step-by-step breakdown of what to build during the 2026-03-29 16:35 through 2026-03-30 23:59 sprint
**Status:** Ready to execute
**CTMO Owner:** All build tasks
**Timeline:** 36 hours total with defined checkpoints

---

## Phase 1: Setup & Infrastructure (2026-03-29 16:35 to 18:00 — 1.5 hours)

### Checkpoint: First Workflow Skeleton Complete (Target: 18:00)

#### Task 1.1: n8n Instance Configuration (30 min)
- [ ] Create n8n Cloud account (Professional tier)
- [ ] Verify instance is running
- [ ] Access web UI at https://n8n-instance.eu.n8n.cloud/
- [ ] Create admin user account
- [ ] **Credentials Added to n8n:**
  - [ ] Gumroad API token (labeled `gumroad_api_token`)
  - [ ] PostgreSQL connection string (labeled `postgres_makinmoves`)
  - [ ] Claude API key (labeled `anthropic_api_key`)
  - [ ] WordPress app password (labeled `wordpress_api`)
  - [ ] Slack bot token if using alerts (labeled `slack_webhook`)

**Exit Criteria:**
- n8n dashboard loads without errors
- All 5 credentials stored and marked "ready"
- Can create new workflow

#### Task 1.2: PostgreSQL Database Setup (20 min)
- [ ] AWS RDS PostgreSQL instance created (or Railway)
- [ ] Database `makinmoves` created
- [ ] Run `DATABASE_SCHEMA.sql` to initialize all tables
- [ ] Verify all 8 tables exist:
  - [ ] `gumroad_sales`
  - [ ] `etsy_sales`
  - [ ] `content_queue`
  - [ ] `publishing_log`
  - [ ] `error_logs`
  - [ ] `workflow_executions`
  - [ ] `workflow_metrics`
  - [ ] `revenue_summary`
- [ ] Run initial test query: `SELECT COUNT(*) FROM gumroad_sales;` (returns 0)
- [ ] Test connection from n8n (successful)

**Exit Criteria:**
- PostgreSQL connection string works in n8n
- All tables visible via SELECT query
- Connection pooling working

#### Task 1.3: n8n Workflow: Revenue Capture Skeleton (40 min)
- [ ] Create new workflow: `workflow_revenue_capture_hourly`
- [ ] Add Cron Trigger node
  - [ ] Set schedule: `0 * * * *` (hourly at :00)
  - [ ] Verify timezone: UTC
- [ ] Add placeholder for Gumroad API call (HTTP Request node)
  - [ ] Add test URL: `https://api.gumroad.com/v2/products`
  - [ ] Add Bearer token auth (from credentials)
  - [ ] Add error handling path
- [ ] Add placeholder PostgreSQL INSERT (PostgreSQL node)
  - [ ] Test dummy INSERT into `gumroad_sales` table
  - [ ] Add ON CONFLICT handling
- [ ] Save workflow
- [ ] Test deploy (manual trigger)
- [ ] Verify: No errors on save

**Exit Criteria:**
- Workflow created and saved
- Can see it in n8n workflows list
- Manual trigger returns success or expected error
- No syntax errors

---

## Phase 2: Workflow 1 — Revenue Capture (2026-03-29 18:00 to 21:00 — 3 hours)

### Checkpoint: First Successful Revenue Capture (Target: 21:00)

#### Task 2.1: Gumroad API Integration (1.5 hours)
- [ ] Complete HTTP Request node: GET `/products`
  - [ ] Endpoint: `https://api.gumroad.com/v2/products`
  - [ ] Auth: Bearer token from credentials
  - [ ] Error handling: Catch 401, 429, 5xx
  - [ ] Response format: Expect `{ products: [...] }`
- [ ] Add Loop node: For each product
  - [ ] Loop over `products` array
  - [ ] For each: GET `/products/{id}/sales`
- [ ] Add Transform node: Parse sales response
  - [ ] Extract: sale_id, amount, currency, customer_email_hash (hashed), created_at
  - [ ] Validate: All fields present
  - [ ] Map to PostgreSQL schema
- [ ] **Manual Test:** Create test product on Gumroad, create 1 test sale
  - [ ] Run workflow manually
  - [ ] Verify sales data in PostgreSQL

**Exit Criteria:**
- `gumroad_sales` table has 1+ rows
- No duplicate inserts
- All fields populated correctly

#### Task 2.2: Etsy API Integration (Basic) (1 hour)
- [ ] HTTP Request node: GET `/users/{shop_id}/listings/active`
  - [ ] Auth: OAuth 2.0 token from credentials
  - [ ] Response: List of active listings
- [ ] Add Loop node: For each listing
  - [ ] GET `/listings/{id}/stats`
- [ ] Add Transform: Parse stats into sales format
  - [ ] Extract: transaction_id, amount, created_at
- [ ] Add PostgreSQL INSERT: `etsy_sales` table
  - [ ] Use ON CONFLICT for deduplication

**Exit Criteria:**
- `etsy_sales` table has 1+ test rows
- No duplicate inserts

#### Task 2.3: Error Handling for Revenue Capture (0.5 hours)
- [ ] Add error trigger nodes to all HTTP requests
  - [ ] 401 error: Alert severity CRITICAL, log to error_logs
  - [ ] 429 error: Log to error_logs, trigger retry
  - [ ] 5xx error: Retry 3x, then log
- [ ] Add PostgreSQL error logging
  - [ ] INSERT to `error_logs` table with context
- [ ] Add Slack alert (if available)
  - [ ] Send message for CRITICAL errors only

**Exit Criteria:**
- Intentionally cause 401 error, verify logging
- Verify error_logs table has entries

---

## Phase 3: Workflow 2 — Content Generation (2026-03-30 06:00 to 10:00 — 4 hours)

### Checkpoint: 3 Content Items Generated (Target: 10:00)

#### Task 3.1: Claude API Integration for Product Generation (1.5 hours)
- [ ] Create workflow: `workflow_content_generation_daily`
- [ ] Cron trigger: 06:00 UTC (`0 6 * * *`)
- [ ] Code node: Build product generation prompt
  - [ ] Random topic from predefined list
  - [ ] Request JSON format: `{ product_name, description, target_audience, price_usd, file_format, unique_selling_point }`
- [ ] HTTP Request: POST to Claude API
  - [ ] Endpoint: `https://api.anthropic.com/v1/messages`
  - [ ] Model: `claude-3-5-sonnet-20241022`
  - [ ] Max tokens: 500
  - [ ] Temperature: 0.7
- [ ] Transform node: Parse Claude JSON response
  - [ ] Validate all required fields
- [ ] PostgreSQL INSERT: `content_queue` table
  - [ ] Set status: `pending`
  - [ ] Set content_type: `digital_product`
  - [ ] Store metadata as JSON

**Exit Criteria:**
- 1 product row in `content_queue`
- Can parse Claude response correctly
- No errors on first run

#### Task 3.2: Claude API Integration for PoD Design (1 hour)
- [ ] Duplicate product generation node + modify for designs
- [ ] Code: Build design prompt (different from product)
  - [ ] Request fields: `{ niche, visual_description, color_palette, target_market, products, estimated_price }`
- [ ] HTTP Request: POST to Claude API (same endpoint, different prompt)
- [ ] Transform: Parse response
- [ ] PostgreSQL INSERT: `content_queue`
  - [ ] Set content_type: `pod_design`

**Exit Criteria:**
- 1 design row in `content_queue`

#### Task 3.3: Claude API Integration for Affiliate Article (1 hour)
- [ ] Duplicate design node + modify for articles
- [ ] Code: Build article outline prompt
  - [ ] Select random topic from evergreen list
  - [ ] Request fields: `{ post_title, meta_description, seo_keywords, article_structure, affiliate_products, estimated_word_count }`
- [ ] HTTP Request: POST to Claude API
- [ ] Transform: Parse response
- [ ] PostgreSQL INSERT: `content_queue`
  - [ ] Set content_type: `article`

**Exit Criteria:**
- 1 article row in `content_queue`

#### Task 3.4: Error Handling for Content Generation (0.5 hours)
- [ ] Add error triggers for Claude API failures
  - [ ] 401: Alert (token expired)
  - [ ] 429: Queue for retry (don't fail entire workflow)
  - [ ] 5xx: Retry 3x
- [ ] Add PostgreSQL error logging
- [ ] Fallback: Even if Claude fails, create placeholder row in error state

**Exit Criteria:**
- Intentionally cause 401, verify error logged
- Verify even on failure, workflow doesn't crash

---

## Phase 4: Workflow 3 — Publishing Pipeline (2026-03-30 10:00 to 14:00 — 4 hours)

### Checkpoint: Content Publishing Verified (Target: 14:00)

#### Task 4.1: Content Approval Workflow (0.5 hours)
- [ ] Understand: COO marks content as approved
  - [ ] Method: Direct SQL update or file-based?
  - [ ] Confirm with COO the approval method
- [ ] Add validation: Workflow fetches approved content only
  - [ ] PostgreSQL query: `SELECT * FROM content_queue WHERE status='approved'`
  - [ ] If none: Skip, log as info
  - [ ] If some: Process each

**Exit Criteria:**
- Can fetch approved content from DB
- Workflow handles "no approved" gracefully

#### Task 4.2: Gumroad Digital Product Publishing (1 hour)
- [ ] Create workflow: `workflow_publishing_pipeline_daily`
- [ ] Cron trigger: 09:00 UTC (`0 9 * * *`)
- [ ] Filter approved content: `content_type='digital_product'`
- [ ] Check if product already exists
  - [ ] Query `gumroad_products` table
  - [ ] If exists: Skip, log
  - [ ] If new: Proceed
- [ ] Note: Gumroad API doesn't support programmatic publishing
  - [ ] Log as "awaiting_manual_publish" (expected)
  - [ ] Insert to `publishing_log` with status `pending_manual`
  - [ ] Notify COO
- [ ] Update `content_queue`: status = `published`

**Exit Criteria:**
- `publishing_log` has entry for test product
- Status shows "pending_manual" (expected)

#### Task 4.3: WordPress Article Publishing (1.5 hours)
- [ ] Filter approved content: `content_type='article'`
- [ ] Transform article to WordPress REST format
  - [ ] Title, content (with affiliate disclaimer + links)
  - [ ] Tags: from `seo_keywords`
  - [ ] Category: e.g., "Affiliate Marketing"
- [ ] HTTP Request: POST to WordPress API
  - [ ] Endpoint: `https://{{ wordpress_domain }}/wp-json/wp/v2/posts`
  - [ ] Auth: Basic auth (app user + app password)
  - [ ] Body: `{ title, content, status: 'publish', tags, categories }`
  - [ ] Response: `{ id, link, ... }`
- [ ] Insert to `publishing_log`
  - [ ] published_url: from response.link
  - [ ] status: `published`
- [ ] Update `content_queue`: status = `published`
- [ ] **Manual Test:** Create test approved article, run workflow
  - [ ] Verify article appears on WordPress staging site

**Exit Criteria:**
- `publishing_log` has entry for test article with live URL
- WordPress shows published article

#### Task 4.4: Error Handling for Publishing (0.5 hours)
- [ ] Add error triggers: HTTP failures, DB errors
- [ ] Retry logic: 3x for 5xx, skip for 400-level
- [ ] Log all failures with context
- [ ] Prevent partial publishes (all-or-nothing per content item)

**Exit Criteria:**
- Intentionally fail WordPress publish, verify error logged
- Next item still publishes (doesn't cascade)

---

## Phase 5: Workflow 4 — Error Monitoring (2026-03-30 14:00 to 18:00 — 4 hours)

### Checkpoint: Error Monitoring Active (Target: 18:00)

#### Task 5.1: Global Error Trigger Setup (1 hour)
- [ ] Create workflow: `workflow_error_monitoring_realtime`
- [ ] Configure error triggers on all 3 workflows (W1, W2, W3)
  - [ ] Attach error trigger to EVERY node in each workflow
  - [ ] Forward errors to centralized handler
- [ ] Create centralized error handler workflow
  - [ ] Receives error context from all 3 workflows
  - [ ] Classifies error (see classification matrix in spec)

**Exit Criteria:**
- All 3 workflows have error triggers attached
- Error classification node created

#### Task 5.2: Error Classification & Logging (1.5 hours)
- [ ] Code node: Classify error by code/message
  - [ ] 401/403 → AUTH_FAILURE
  - [ ] 429 → RATE_LIMIT
  - [ ] 5xx → SERVER_ERROR
  - [ ] 422 → DATA_VALIDATION_ERROR
  - [ ] TIMEOUT → NETWORK_ERROR
  - [ ] DB error → DATABASE_ERROR
- [ ] Assign severity:
  - [ ] CRITICAL: Auth, DB, persistent failures
  - [ ] WARNING: Transient (429, timeout, 5xx)
  - [ ] INFO: Data validation, expected errors
- [ ] PostgreSQL INSERT to `error_logs`
  - [ ] Fields: workflow_name, error_type, error_message, context, severity, logged_at

**Exit Criteria:**
- `error_logs` table has test entries with correct classification
- Can query errors by severity

#### Task 5.3: Alert System (1 hour)
- [ ] Conditional logic: If severity='CRITICAL'
  - [ ] Send Slack alert (if available)
  - [ ] Message format: Error type, workflow, node, message, timestamp
- [ ] If severity='WARNING'
  - [ ] Log only (no alert)
  - [ ] CFO reviews in daily digest
- [ ] If severity='INFO'
  - [ ] Log only
- [ ] Test: Cause CRITICAL error, verify Slack alert sent

**Exit Criteria:**
- Can trigger CRITICAL error and receive Slack alert
- CRITICAL errors don't persist silently

#### Task 5.4: Backup Error Handling (Fallback Queue) (0.5 hours)
- [ ] If an item exhausts all retries, add to `dead_letter_queue` table
  - [ ] Table schema exists
  - [ ] Log reason code
  - [ ] CFO can manually review and retry
- [ ] Test: Cause persistent 5xx, verify dead letter queue entry

**Exit Criteria:**
- `dead_letter_queue` table populated on persistent failures
- Items can be manually retried

---

## Phase 6: Integration Testing (2026-03-30 18:00 to 22:00 — 4 hours)

### Checkpoint: All Workflows Pass Integration Tests (Target: 22:00)

#### Test 6.1: End-to-End Revenue Capture Test
- [ ] Create test sale on Gumroad (or use existing)
- [ ] Create test sale on Etsy (or use existing)
- [ ] Trigger Workflow 1 manually
- [ ] Verify:
  - [ ] `gumroad_sales` table has new row
  - [ ] `etsy_sales` table has new row
  - [ ] No duplicate rows
  - [ ] Amounts correct
  - [ ] Timestamps recent
- [ ] Query CFO revenue_today view: Should show revenue from this morning

**Exit Criteria:** ✅ PASS
- Both platforms captured revenue
- No errors in error_logs

#### Test 6.2: End-to-End Content Generation Test
- [ ] Trigger Workflow 2 manually
- [ ] Verify:
  - [ ] `content_queue` has 3 new rows (product, design, article)
  - [ ] All have status='pending'
  - [ ] Metadata is valid JSON
  - [ ] No nulls in required fields
- [ ] Inspect Claude responses: Are they high quality?

**Exit Criteria:** ✅ PASS
- 3 content items generated
- Metadata parseable

#### Test 6.3: End-to-End Publishing Test
- [ ] Manually update 1 article row: status='approved'
- [ ] Trigger Workflow 3 manually
- [ ] Verify:
  - [ ] Article published to WordPress
  - [ ] `publishing_log` has entry with published_url
  - [ ] `content_queue` row now has status='published'
  - [ ] WordPress post is live and accessible
- [ ] Access WordPress post: Verify content, affiliate disclaimer, links

**Exit Criteria:** ✅ PASS
- Article live on WordPress
- publishing_log shows success

#### Test 6.4: Error Handling Integration Test
- [ ] Simulate 401 error (bad Gumroad token)
- [ ] Trigger Workflow 1, expect failure
- [ ] Verify:
  - [ ] `error_logs` has entry with severity='CRITICAL', error_type='AUTH_FAILURE'
  - [ ] Slack alert sent (if configured)
  - [ ] Workflow marked as failed
- [ ] Fix token, re-run, should succeed

**Exit Criteria:** ✅ PASS
- Error detected, logged, and alerted correctly

#### Test 6.5: Rate Limit Handling Test
- [ ] Simulate 429 response from Etsy API
- [ ] Trigger Workflow 1, expect retry with backoff
- [ ] Verify:
  - [ ] Workflow retries up to 3x
  - [ ] Exponential backoff applied (1s, 2s, 5s)
  - [ ] Eventually succeeds (after mock API recovers)
  - [ ] `error_logs` shows warning, not critical

**Exit Criteria:** ✅ PASS
- Automatic backoff working
- Transient errors don't trigger alerts

#### Test 6.6: Duplicate Detection Test
- [ ] Insert same sale_id twice
- [ ] Verify:
  - [ ] Second insert fails silently (ON CONFLICT)
  - [ ] Only 1 row in gumroad_sales
  - [ ] No error logged (expected behavior)

**Exit Criteria:** ✅ PASS
- Duplicates prevented by UNIQUE constraint

---

## Phase 7: Documentation & Finalization (2026-03-30 22:00 to 23:30 — 1.5 hours)

#### Task 7.1: Workflow Documentation (0.5 hours)
- [ ] Document each workflow:
  - [ ] Purpose, trigger schedule
  - [ ] Node sequence with screenshots
  - [ ] Input/output format
  - [ ] Error paths
  - [ ] Dependencies (API keys, tables)
- [ ] Store in: `CTMO/technical/n8n_workflows_final.md`

**Exit Criteria:**
- All 4 workflows documented
- Screenshots captured

#### Task 7.2: API Mapping Reference (0.5 hours)
- [ ] Update `CTMO/technical/PLATFORM_API_MAPPING_2026.md`
- [ ] For each platform (Gumroad, Etsy, Claude, WordPress):
  - [ ] API endpoint used
  - [ ] Rate limit status
  - [ ] Auth method
  - [ ] Response format
  - [ ] Known issues
- [ ] Add troubleshooting tips

**Exit Criteria:**
- Complete API reference available

#### Task 7.3: Runbooks & Emergency Procedures (0.5 hours)
- [ ] Create `CTMO/technical/n8n_runbooks.md`
- [ ] For each workflow:
  - [ ] How to manually trigger
  - [ ] How to check status
  - [ ] How to troubleshoot common failures
  - [ ] Who to contact if stuck
- [ ] Emergency procedures:
  - [ ] How to disable a workflow (if stuck in loop)
  - [ ] How to check PostgreSQL for data corruption
  - [ ] How to restore from backup

**Exit Criteria:**
- Clear runbooks for all 4 workflows
- Emergency procedures documented

---

## Phase 8: Final Verification (2026-03-30 23:30 to 23:59 — 0.5 hours)

### Final Checklist Before March 31 Autonomy

- [ ] **All 4 Workflows Deployed & Running**
  - [ ] Workflow 1: Revenue Capture (hourly cron enabled)
  - [ ] Workflow 2: Content Generation (daily 06:00 cron enabled)
  - [ ] Workflow 3: Publishing Pipeline (daily 09:00 cron enabled)
  - [ ] Workflow 4: Error Monitoring (real-time error triggers enabled)

- [ ] **PostgreSQL Ready**
  - [ ] All 8 tables exist and are populated
  - [ ] Indexes created
  - [ ] Backups enabled (daily)
  - [ ] No data corruption

- [ ] **Credentials Valid**
  - [ ] Gumroad token: tested
  - [ ] Etsy token: tested, refresh working
  - [ ] Claude API key: tested
  - [ ] WordPress app password: tested
  - [ ] All tokens stored in n8n Credentials Manager

- [ ] **Monitoring Setup**
  - [ ] Slack alerts configured
  - [ ] Email alerts configured (for critical errors)
  - [ ] Dashboard queries created
  - [ ] CFO knows how to query revenue_summary

- [ ] **Error Handling Tested**
  - [ ] Auth errors trigger CRITICAL alerts
  - [ ] Rate limits auto-retry with backoff
  - [ ] Transient errors don't escalate
  - [ ] Duplicate transactions prevented

- [ ] **Integration Tests All Green**
  - [ ] Revenue capture: ✅ PASS
  - [ ] Content generation: ✅ PASS
  - [ ] Publishing pipeline: ✅ PASS
  - [ ] Error monitoring: ✅ PASS
  - [ ] End-to-end flow: ✅ PASS

- [ ] **Documentation Complete**
  - [ ] All workflows documented
  - [ ] API mapping reference complete
  - [ ] Runbooks written
  - [ ] Emergency procedures documented

- [ ] **Sign-Offs Obtained**
  - [ ] CEO: Approves autonomous operation
  - [ ] COO: Content creation process ready
  - [ ] CFO: Knows how to query revenue data
  - [ ] CTMO: Confirms all systems green

---

## Daily Execution Schedule

### Day 1: 2026-03-29 (Saturday)

```
16:35 — CTMO Starts Execution
├─ 16:35–17:00: Confirm CEO/COO/CFO approvals, document decisions
├─ 17:00–17:30: n8n setup + credential configuration
├─ 17:30–18:00: PostgreSQL schema creation + test
├─ 18:00: CHECKPOINT 1 — First workflow skeleton complete ✅
│
├─ 18:00–19:30: Gumroad + Etsy API integration
├─ 19:30–20:00: Error handling setup
├─ 20:00–21:00: Manual testing (create test sale, run workflow)
├─ 21:00: CHECKPOINT 2 — Revenue capture working ✅
│
├─ 21:00–23:00: Initial testing + troubleshooting
├─ 23:00–23:59: Log progress, prepare for Day 2
│
└─ 23:59: END DAY 1 (10 hours elapsed, 26 hours remaining)
```

### Day 2: 2026-03-30 (Sunday)

```
06:00 — Day 2 Resumes
├─ 06:00–10:00: Build Workflow 2 (Content Generation)
├─ 10:00: CHECKPOINT 3 — Content generation working ✅
│
├─ 10:00–14:00: Build Workflow 3 (Publishing Pipeline)
├─ 14:00: CHECKPOINT 4 — Publishing pipeline working ✅
│
├─ 14:00–18:00: Build Workflow 4 (Error Monitoring)
├─ 18:00: CHECKPOINT 5 — Error monitoring active ✅
│
├─ 18:00–22:00: Integration testing (all 5 tests)
├─ 22:00: CHECKPOINT 6 — All tests pass ✅
│
├─ 22:00–23:30: Documentation + final setup
├─ 23:30–23:59: Final verification checklist
│
└─ 23:59: END DAY 2 — AUTONOMOUS OPERATION READY ✅
```

---

## Success Metrics

By 2026-03-30 23:59, CTMO will have delivered:

| Metric | Target | Status |
|--------|--------|--------|
| **Workflows Deployed** | 4 (all building + testing) | ▌▌▌▌ In Progress |
| **Integration Tests Passing** | 6/6 | ▌▌▌▌ In Progress |
| **Error Handling** | 100% coverage | ▌▌▌▌ In Progress |
| **Documentation** | Complete | ▌▌▌▌ In Progress |
| **Sign-Offs** | CEO + COO + CFO | ▌▌▌▌ In Progress |

**Final Sign-Off Statement:**
```
"I (CTMO) confirm that all 4 n8n workflows have been successfully deployed,
tested, and documented. The system is ready for 100% autonomous operation
beginning 2026-03-31 00:00 UTC. Zero manual intervention will be required."
```

---

**Owner:** CTMO
**Status:** Ready to Execute
**Next Step:** Execute immediately upon approvals at standup (16:30 UTC)

