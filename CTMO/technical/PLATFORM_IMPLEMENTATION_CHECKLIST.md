# Platform Implementation Checklist
**CTMO Build Tracking — 36-Hour Sprint**
**Start Date:** 2026-03-29
**Target Completion:** 2026-03-31 (36 hours)

---

## PHASE 1: SETUP & FOUNDATIONS (Hours 0-3)

### Credentials Acquisition
- [ ] **Gumroad:** Log in → Settings → API → Generate token
  - Token saved to: `./credentials/gumroad.token`
  - Verified: Test `GET /me` endpoint

- [ ] **Etsy:** Create developer account → Create app
  - Client ID: ___________________
  - Client Secret: ___________________
  - Saved to: `./credentials/etsy.env`
  - OAuth redirect URI set: `https://<n8n-instance>/rest/oauth2/callback?service=etsy`
  - Scopes requested: `listings_r, transactions_r, shops_r`
  - Verified: OAuth flow completed, access token obtained

- [ ] **Medium:** Log in → Settings → Integration tokens → Create
  - Token saved to: `./credentials/medium.token`
  - Verified: Test `GET /me` endpoint

- [ ] **WordPress:** Log in → Users → Profile → Application Passwords
  - App name: "MakinMoves-n8n"
  - Password generated: ___________________
  - Stored as: `username:password` (Base64 encoded in n8n)
  - Verified: Test `GET /wp-json/wp/v2/me` endpoint

- [ ] **Redbubble:** N/A - Dashboard access only
  - Dashboard URL bookmarked: https://www.redbubble.com/dashboard/analytics
  - Manual logging process documented

### Database Setup
- [ ] PostgreSQL instance running (`docker ps | grep postgres`)
- [ ] Database created: `makinmoves`
- [ ] Run migrations:
  ```bash
  psql -U postgres -d makinmoves -f ./migrations/001_schema_gumroad.sql
  psql -U postgres -d makinmoves -f ./migrations/002_schema_etsy.sql
  psql -U postgres -d makinmoves -f ./migrations/003_schema_wordpress.sql
  psql -U postgres -d makinmoves -f ./migrations/004_schema_medium.sql
  psql -U postgres -d makinmoves -f ./migrations/005_schema_redbubble.sql
  psql -U postgres -d makinmoves -f ./migrations/006_schema_revenue_summary.sql
  psql -U postgres -d makinmoves -f ./migrations/007_schema_api_errors.sql
  ```
- [ ] Test connection: `psql -U postgres -d makinmoves -c "SELECT version();"`
- [ ] Verify tables created: `\dt` (in psql)

### n8n Setup
- [ ] n8n instance running (`docker ps | grep n8n`)
- [ ] n8n accessible: http://localhost:5678
- [ ] User account created + logged in
- [ ] PostgreSQL connection configured in n8n
- [ ] Test: Create test query node, execute successfully

---

## PHASE 2: DAY 1 - PROOF OF CONCEPT (Hours 4-10)

### Gumroad Integration (Estimated: 4 hours)

**Credentials Setup in n8n**
- [ ] n8n: Credentials → New → Gumroad
- [ ] Paste Gumroad API token
- [ ] Test: HTTP Request node with Gumroad credentials
  - Endpoint: `GET https://api.gumroad.com/v2/me`
  - Expected: Returns user info
  - Actual result: ___________________

**Workflow: Gumroad Hourly Poll**
- [ ] Create new workflow: "Gumroad Hourly Revenue"
- [ ] Add trigger: Interval (1 hour)
- [ ] Add node: HTTP Request
  - Method: GET
  - URL: `https://api.gumroad.com/v2/products`
  - Auth: Gumroad credentials
- [ ] Add node: Loop (for each product)
- [ ] Add node: HTTP Request (nested)
  - Method: GET
  - URL: `https://api.gumroad.com/v2/products/{{$item.json.id}}/sales`
  - Auth: Gumroad credentials
- [ ] Add node: Code (hash emails)
  ```javascript
  const crypto = require('crypto');
  return items.map(item => ({
    ...item.json,
    customer_email_hash: crypto.createHash('sha256')
      .update(item.json.customer_email)
      .digest('hex')
  }));
  ```
- [ ] Add node: PostgreSQL Insert
  - Table: `gumroad_sales`
  - Columns: `product_id, sale_id, amount, customer_email_hash, created_at`
- [ ] Add error handler: Log to `api_errors` table
- [ ] Dry-run: Test workflow manually
  - Verify: Data inserted into `gumroad_sales` table
  - Row count: ___________________
  - Sample data: ___________________
- [ ] Deploy: Activate schedule

**Database Verification**
- [ ] Query: `SELECT COUNT(*) FROM gumroad_sales;`
  - Expected: > 0
  - Actual: ___________________
- [ ] Query: `SELECT * FROM gumroad_sales LIMIT 1;`
  - Verify fields: `product_id, sale_id, amount, customer_email_hash, created_at`
  - Sample output: ___________________

### Etsy Integration (Estimated: 6 hours)

**Credentials Setup in n8n**
- [ ] n8n: Credentials → New → HTTP Request (custom)
- [ ] Configure OAuth:
  - Client ID: (from Etsy app)
  - Client Secret: (from Etsy app)
  - Auth URL: `https://www.etsy.com/oauth/authorize`
  - Access Token URL: `https://api.etsy.com/v3/oauth/token`
  - Scope: `listings_r transactions_r shops_r`
  - Redirect URL: `https://<n8n-instance>/rest/oauth2/callback`
- [ ] Test: Initiate OAuth flow
  - Get authorization code: ___________________
  - Exchange for access token: Success / Failure
  - Access token stored: Yes / No

**Workflow: Etsy Daily Stats Poll**
- [ ] Create new workflow: "Etsy Daily Revenue"
- [ ] Add trigger: Cron (daily, 2am UTC: `0 2 * * *`)
- [ ] Add node: Postgres (check rate limit)
  ```sql
  SELECT requests_today, last_reset FROM etsy_rate_limit_tracking WHERE id=1;
  ```
- [ ] Add node: HTTP Request
  - Method: GET
  - URL: `https://api.etsy.com/v3/users/me`
  - Auth: Etsy OAuth credentials
- [ ] Add node: HTTP Request (get shop listings)
  - Method: GET
  - URL: `https://api.etsy.com/v3/shops/{{$json.user_id}}/listings/active`
  - Auth: Etsy OAuth
- [ ] Add node: Loop (for each listing, max 50)
- [ ] Add node: HTTP Request (nested, with retry)
  - Method: GET
  - URL: `https://api.etsy.com/v3/listings/{{$item.json.listing_id}}/stats`
  - Auth: Etsy OAuth
  - Retry On Fail: 3 attempts, 2s wait
- [ ] Add node: Code (transform + hash)
  ```javascript
  const crypto = require('crypto');
  return items.map(item => ({
    listing_id: item.json.listing_id,
    amount: item.json.stats?.gross_sales || 0,
    created_at: new Date().toISOString()
  }));
  ```
- [ ] Add node: Postgres Insert
  - Table: `etsy_sales`
  - Columns: `listing_id, amount, created_at`
- [ ] Add node: Postgres Update (rate limit tracker)
  ```sql
  UPDATE etsy_rate_limit_tracking SET requests_today = requests_today + {{$execution.startTime.getHours() === 2 ? 5 : 0}};
  ```
- [ ] Add error handler: Check for 429, log if rate limited
- [ ] Dry-run: Test workflow
  - Verify: Data inserted into `etsy_sales`
  - Row count: ___________________
  - Sample data: ___________________
- [ ] Deploy: Activate schedule

**Database Verification**
- [ ] Query: `SELECT COUNT(*) FROM etsy_sales;`
  - Expected: > 0
  - Actual: ___________________
- [ ] Query: `SELECT * FROM etsy_sales LIMIT 1;`
  - Verify fields: `listing_id, amount, created_at`
  - Sample output: ___________________

**Testing - Rate Limits**
- [ ] Simulate high load: Manual workflow run with 100+ listings
  - Expected: Respects Etsy rate limits, no 429 errors
  - Actual behavior: ___________________
- [ ] Verify backoff: On 429, check wait delay applied
  - Exponential backoff formula applied: Yes / No

---

## PHASE 3: DAY 1.5 - DIVERSIFY (Hours 11-19)

### WordPress Integration (Estimated: 4 hours)

**Setup Custom Post Type**
- [ ] SSH into WordPress server
- [ ] Create/edit `functions.php` (or mu-plugins):
  ```php
  add_action('init', function() {
    register_post_type('earnings', [
      'labels' => ['name' => 'Earnings'],
      'public' => false,
      'supports' => ['title', 'custom-fields'],
      'show_in_rest' => true
    ]);
  });
  ```
- [ ] Verify: Reload WordPress, check CPT registered
  - Verify: `GET /wp-json/wp/v2/earnings` returns empty array

**Credentials Setup in n8n**
- [ ] n8n: Credentials → New → HTTP Request (WordPress)
- [ ] Configure Basic Auth:
  - Username: (WordPress user)
  - Password: (application password, NOT user password)
  - Format: base64(username:apppassword)
- [ ] Test: HTTP Request to `GET https://yoursite.com/wp-json/wp/v2/me`
  - Expected: Returns authenticated user info
  - Actual: ___________________

**Workflow: Daily Earnings Log (Manual)**
- [ ] Create new workflow: "WordPress Daily Earnings"
- [ ] Add trigger: Manual (for now; can be automated with form)
- [ ] Add nodes: Form input for:
  - Affiliate program (dropdown: amazon_associates, refersion, etc.)
  - Earnings amount (number)
  - Clicks (number)
- [ ] Add node: Create post (HTTP Request)
  - Method: POST
  - URL: `https://yoursite.com/wp-json/wp/v2/earnings`
  - Auth: WordPress Basic Auth
  - Body:
    ```json
    {
      "title": "{{$input.json.date}} - {{$input.json.program}}",
      "meta": {
        "affiliate_program": "{{$input.json.program}}",
        "earnings": {{$input.json.earnings}},
        "clicks": {{$input.json.clicks}}
      },
      "status": "publish"
    }
    ```
- [ ] Add node: Postgres Insert (mirror to analytics DB)
  - Table: `wordpress_earnings`
- [ ] Dry-run: Create test earnings post
  - Verify: Post created in WordPress admin
  - Verify: Custom fields populated
  - Verify: Row inserted in postgres table

**Database Verification**
- [ ] Query: `SELECT * FROM wordpress_earnings LIMIT 1;`
  - Verify fields: `post_id, affiliate_program, earnings, clicks, date`

### Medium Integration (Estimated: 3 hours)

**Setup: Manual Dashboard Logging**
- [ ] Document process:
  - Each day (morning): Visit https://medium.com/me/stats
  - Note earnings for yesterday
  - Log to form (same as WordPress workflow)
- [ ] Create n8n workflow: "Medium Daily Earnings (Manual)"
- [ ] Add trigger: Manual
- [ ] Add nodes: Form input for:
  - Earnings amount
  - Views
  - Reads
- [ ] Add node: Postgres Insert
  - Table: `medium_earnings`
- [ ] Test: Submit sample data
  - Verify: Row inserted in database

**Optional: Scraping Workflow**
- [ ] If scraping justified (50+ articles, high volume):
  - Create workflow with Puppeteer
  - Login to Medium, navigate to stats
  - Parse earnings from dashboard HTML
  - Extract yesterday's data
  - Risk: Fragile, Medium may block
  - Recommendation: Use manual for MVP

**Database Verification**
- [ ] Query: `SELECT * FROM medium_earnings LIMIT 1;`
  - Verify fields: `earnings, views, reads, date`

### Redbubble Integration (Estimated: 2 hours)

**Setup: Manual Dashboard Logging**
- [ ] Document process:
  - Each day (morning): Visit https://www.redbubble.com/dashboard/analytics
  - Note earnings for yesterday
  - Log to form
- [ ] Create n8n workflow: "Redbubble Daily Earnings (Manual)"
- [ ] Add trigger: Manual
- [ ] Add nodes: Form input for:
  - Earnings amount
  - Orders
  - Views
- [ ] Add node: Postgres Insert
  - Table: `redbubble_earnings`
- [ ] Test: Submit sample data
  - Verify: Row inserted in database

**Database Verification**
- [ ] Query: `SELECT * FROM redbubble_earnings LIMIT 1;`
  - Verify fields: `earnings, orders, views, date`

---

## PHASE 4: AGGREGATION & MONITORING (Hours 20-30)

### Revenue Aggregation Workflow (Estimated: 4 hours)

**Workflow: Daily Revenue Summary**
- [ ] Create new workflow: "Daily Revenue Summary"
- [ ] Add trigger: Cron (daily, 3am UTC: `0 3 * * *`)
- [ ] Add nodes: Query each platform (yesterday's data)
  - Gumroad: SUM revenue
  - Etsy: SUM revenue
  - WordPress: SUM earnings
  - Medium: SUM earnings
  - Redbubble: SUM earnings
- [ ] Add node: Calculate total
  ```javascript
  return {
    date: new Date(new Date().setDate(new Date().getDate() - 1)).toISOString().split('T')[0],
    gumroad: $input.gumroad_total || 0,
    etsy: $input.etsy_total || 0,
    wordpress: $input.wp_total || 0,
    medium: $input.medium_total || 0,
    redbubble: $input.rb_total || 0,
    total: (($input.gumroad_total || 0) + ($input.etsy_total || 0) + ...)
  };
  ```
- [ ] Add node: Postgres Insert
  - Table: `daily_revenue_summary`
- [ ] Add node: Send email (to COO/CEO)
  - Subject: `Daily Revenue Summary - {{$json.date}}`
  - Body: Formatted revenue breakdown + total
- [ ] Dry-run: Trigger manually
  - Verify: Row inserted
  - Verify: Email sent with correct data

### Monitoring & Alerting (Estimated: 2 hours)

**Error Monitoring**
- [ ] Create workflow: "API Error Alert"
- [ ] Trigger: Whenever any API returns error (429, 401, 5xx)
- [ ] Action: Log to `api_errors` table + send alert email to CTMO
- [ ] Enable: All workflows have error handlers configured

**Rate Limit Monitoring (Etsy)**
- [ ] Create workflow: "Rate Limit Check"
- [ ] Trigger: Every 6 hours
- [ ] Action: Check `etsy_rate_limit_tracking` table
  - If requests_today > 8000 (80%), send warning
  - If requests_today > 9500 (95%), send critical alert
- [ ] Deploy: Active schedule

**Health Check Dashboard**
- [ ] Create PostgreSQL query: Last 24h by platform
  ```sql
  SELECT
    'gumroad' as platform, COUNT(*) as records, SUM(amount) as total
  FROM gumroad_sales
  WHERE created_at > NOW() - INTERVAL '24 hours'
  UNION ALL
  SELECT
    'etsy' as platform, COUNT(*), SUM(amount)
  FROM etsy_sales
  WHERE created_at > NOW() - INTERVAL '24 hours'
  -- ... repeat for all platforms
  ```
- [ ] Create n8n dashboard widget (visualize results)
- [ ] Set up cron job to email daily summary

---

## PHASE 5: TESTING & HARDENING (Hours 30-36)

### End-to-End Testing
- [ ] **Gumroad E2E:**
  - [ ] Trigger workflow manually
  - [ ] Verify data flows: API → Hashing → Database
  - [ ] Check for duplicate records
  - [ ] Verify no PII in logs
  - Result: PASS / FAIL

- [ ] **Etsy E2E:**
  - [ ] Trigger workflow manually
  - [ ] Verify rate limiting respected (check request count)
  - [ ] Check OAuth token refresh works
  - [ ] Verify no timeout errors
  - Result: PASS / FAIL

- [ ] **WordPress E2E:**
  - [ ] Manually submit earnings form
  - [ ] Verify post created in WordPress
  - [ ] Verify custom fields set correctly
  - [ ] Verify Postgres row created
  - Result: PASS / FAIL

- [ ] **Medium E2E:**
  - [ ] Manually submit earnings form
  - [ ] Verify Postgres row created
  - [ ] Result: PASS / FAIL

- [ ] **Redbubble E2E:**
  - [ ] Manually submit earnings form
  - [ ] Verify Postgres row created
  - [ ] Result: PASS / FAIL

### Load Testing
- [ ] **Gumroad Stress Test:**
  - [ ] Manually trigger 5x workflow runs in parallel
  - [ ] Verify no database deadlocks
  - [ ] Verify no API rate limits hit
  - [ ] Result: PASS / FAIL

- [ ] **Etsy Rate Limit Test:**
  - [ ] Query 100+ listings in single run
  - [ ] Verify backoff/retry logic engages
  - [ ] Check rate_limit_tracking updated correctly
  - [ ] Result: PASS / FAIL

### Data Quality Checks
- [ ] No NULL values in critical columns
  ```sql
  SELECT * FROM gumroad_sales WHERE amount IS NULL OR created_at IS NULL;
  SELECT * FROM etsy_sales WHERE amount IS NULL OR created_at IS NULL;
  ```
- [ ] No duplicate records
  ```sql
  SELECT sale_id, COUNT(*) FROM gumroad_sales GROUP BY sale_id HAVING COUNT(*) > 1;
  SELECT transaction_id, COUNT(*) FROM etsy_sales GROUP BY transaction_id HAVING COUNT(*) > 1;
  ```
- [ ] Revenue totals reasonable
  - Check: SUM(amount) matches platform dashboards (manual spot check)

### Error Handling Tests
- [ ] Gumroad: Simulate 401 (invalid token)
  - [ ] Verify error logged
  - [ ] Verify alert sent to CTMO
  - [ ] Result: PASS / FAIL

- [ ] Etsy: Simulate 429 (rate limit)
  - [ ] Verify exponential backoff applied
  - [ ] Verify max retries (3x) honored
  - [ ] Verify still succeeds on final retry
  - Result: PASS / FAIL

- [ ] All platforms: Simulate network timeout
  - [ ] Verify timeout handled gracefully
  - [ ] Verify retry logic works
  - [ ] Result: PASS / FAIL

### Documentation Check
- [ ] [ ] All workflows have descriptions + comments
- [ ] [ ] Error handlers documented (expected errors, retry logic)
- [ ] [ ] Database schema documented (./technical/SCHEMA.md)
- [ ] [ ] Credential names match documentation
- [ ] [ ] Runbooks created for manual operations (Medium, Redbubble)

### Production Readiness
- [ ] [ ] All workflows deployed (not just test)
- [ ] [ ] Schedules enabled + verified active
- [ ] [ ] Monitoring alerts configured (email to CTMO)
- [ ] [ ] Backup/recovery plan documented
- [ ] [ ] Logging configured (all errors captured)

---

## SIGN-OFF

**Gumroad:** Complete / In Progress / Blocked
- Blocker (if any): ___________________

**Etsy:** Complete / In Progress / Blocked
- Blocker (if any): ___________________

**WordPress:** Complete / In Progress / Blocked
- Blocker (if any): ___________________

**Medium:** Complete / In Progress / Blocked
- Blocker (if any): ___________________

**Redbubble:** Complete / In Progress / Blocked
- Blocker (if any): ___________________

**Overall Status:** ON TRACK / AT RISK / OFF TRACK

**Hours Used:** _____ / 36

**Issues Found & Resolved:**
1. ___________________
2. ___________________
3. ___________________

**Date Completed:** ___________________

**Sign-off by CTMO:** ___________________
