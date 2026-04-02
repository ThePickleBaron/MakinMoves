# n8n Self-Hosted 36-Hour Execution Playbook
## Autonomous Revenue Recovery — Complete Hour-by-Hour Setup

**Status:** READY FOR EXECUTION
**Timeline:** 2026-03-29 16:00 to 2026-03-30 23:59 (36 hours)
**Owner:** CTMO
**Goal:** Deploy n8n self-hosted with 4 fully-functional workflows + PostgreSQL integration + monitoring for autonomous operation post-March 31

---

## EXECUTIVE SUMMARY

**n8n Self-Hosted Path: Why This Works**
- ✓ Zero monthly costs (self-hosted on Railway/Heroku free tier initially, $7/month to scale)
- ✓ Full control over workflows — no Zapier API limits or restrictions
- ✓ PostgreSQL native integration — no need for webhooks or workarounds
- ✓ Customizable error handling, retries, logging — all under CTMO control
- ✓ Workflow JSON can be versioned in Git for disaster recovery
- ✓ Scales infinitely with containers — no task limits like Zapier

**Critical Differences from Zapier:**
- n8n = DIY (CTMO manages all infrastructure, updates, scaling)
- Zapier = managed (Zapier handles everything, we just configure)
- n8n is more powerful but requires ongoing CTMO management
- Zapier is simpler but has task limits and API limitations

**Risk Assessment:**
- **Infrastructure Risk:** Moderate (need to keep Docker running, monitor logs)
- **Build Risk:** Low (n8n UI is visual, not code-heavy)
- **Scaling Risk:** Low (Docker containers auto-scale)
- **Recovery Risk:** Low (workflows stored in PostgreSQL, can restore from backup)

---

## HOUR 0-2: DOCKER SETUP & N8N DEPLOYMENT

### Hour 0 (16:00-17:00): Verify Docker & Services Running

**Step 0.1: Check Docker Installation (5 min)**

```bash
# On Windows (in PowerShell or Git Bash):
docker --version
docker ps

# Expected output:
# Docker version 20.10+
# CONTAINER ID   IMAGE                    STATUS
# [list of running containers or empty]
```

**Step 0.2: Verify MakinMoves Docker Compose (10 min)**

```bash
cd /c/Users/jsmcl/Documents/MakinMoves/MakinMoves-portable

# Check docker-compose file exists
ls -la docker-compose.yml

# Verify all services configured
cat docker-compose.yml | grep "services:" -A 50

# Expected services:
# - postgres (database)
# - n8n (automation)
# - redis (caching)
# - selenium (scraping)
```

**Step 0.3: Start All Services (20 min)**

```bash
# From MakinMoves-portable directory
docker compose up -d

# Wait for services to boot (n8n takes ~60 seconds)
sleep 60

# Check all services running
docker ps

# Expected: All 5 containers show STATUS "Up X seconds"
```

**If services fail to start:**
```bash
# Check logs
docker compose logs

# If postgres fails: Check disk space, permissions
# If n8n fails: Check port 5678 not in use, DB connection
# If error: docker compose down && docker compose up -d (full restart)
```

**Step 0.4: Verify Database Connection (10 min)**

```bash
# Access PostgreSQL from command line
psql -h localhost -U makinmoves -d makinmoves -c "SELECT 1;"

# Expected output:
# ?column?
# --------
#        1

# If fails: Database not running, check Step 0.3
```

**Verify n8n is accessible:**
- Open browser: http://localhost:5678
- Expected: n8n login screen
- Default creds: admin / changeme123

---

### Hour 1 (17:00-18:00): n8n Initial Setup & Database Configuration

**Step 1.1: First n8n Login (5 min)**

1. Go to http://localhost:5678
2. Login:
   - Email: admin (or your email)
   - Password: changeme123
3. First time setup:
   - Create credentials owner account
   - Set password (change from changeme123 for security)
4. Dashboard appears with "New Workflow" button

---

**Step 1.2: Create PostgreSQL Connection in n8n (15 min)**

1. In n8n, click **Credentials** (top right)
2. Click **"+ Create"** → Select **PostgreSQL**
3. Fill in connection:
   - **Host:** localhost (if local) or [Railway/Cloud hostname]
   - **Port:** 5432
   - **Database:** makinmoves
   - **User:** makinmoves
   - **Password:** changeme123
   - **SSL:** No (if local), Yes (if cloud hosted)
4. Click **"Test Connection"**
   - Expected: "✓ Connection successful"
5. Save credential: Name it `postgres_main`

**If connection fails:**
- Verify PostgreSQL container running: `docker ps | grep postgres`
- Check logs: `docker logs mm-postgres`
- Verify credentials: `psql -h localhost -U makinmoves -d makinmoves`

---

**Step 1.3: Initialize Database Schema (20 min)**

Before building workflows, ensure all required tables exist.

```bash
# Run schema initialization script
psql -h localhost -U makinmoves -d makinmoves -f /c/Users/jsmcl/Documents/MakinMoves/MakinMoves-portable/docker/init-db.sql

# Or manually create core tables via n8n:
# Create a temporary workflow to initialize schema
```

**Create these tables in PostgreSQL (via psql or n8n SQL node):**

```sql
-- Revenue tracking
CREATE TABLE IF NOT EXISTS revenue_summary (
  id SERIAL PRIMARY KEY,
  capture_hour TIMESTAMP NOT NULL,
  gumroad_gross DECIMAL(10,2) DEFAULT 0,
  gumroad_net DECIMAL(10,2) DEFAULT 0,
  stripe_gross DECIMAL(10,2) DEFAULT 0,
  stripe_net DECIMAL(10,2) DEFAULT 0,
  total_gross DECIMAL(10,2) DEFAULT 0,
  total_net DECIMAL(10,2) DEFAULT 0,
  gumroad_fees DECIMAL(10,2) DEFAULT 0,
  stripe_fees DECIMAL(10,2) DEFAULT 0,
  timestamp TIMESTAMP DEFAULT NOW(),
  UNIQUE(capture_hour)
);

-- Content queue for publishing
CREATE TABLE IF NOT EXISTS content_queue (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(50),
  title VARCHAR(255),
  description TEXT,
  metadata JSONB,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  published_at TIMESTAMP,
  approved_by VARCHAR(255)
);

-- Publishing log
CREATE TABLE IF NOT EXISTS publishing_log (
  id SERIAL PRIMARY KEY,
  content_id INTEGER REFERENCES content_queue(id),
  platform VARCHAR(50),
  published_url VARCHAR(500),
  status VARCHAR(50),
  error_message TEXT,
  published_at TIMESTAMP DEFAULT NOW()
);

-- Error tracking
CREATE TABLE IF NOT EXISTS error_logs (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100),
  error_type VARCHAR(100),
  error_message TEXT,
  context JSONB,
  severity VARCHAR(50),
  logged_at TIMESTAMP DEFAULT NOW()
);

-- Rate limit tracking
CREATE TABLE IF NOT EXISTS api_rate_limits (
  api_name VARCHAR(50) PRIMARY KEY,
  calls_today INTEGER DEFAULT 0,
  limit_per_day INTEGER DEFAULT 1000,
  last_reset TIMESTAMP DEFAULT NOW()
);

-- Initialize rate limits
INSERT INTO api_rate_limits (api_name, limit_per_day) VALUES
  ('gumroad', 100),
  ('stripe', 1000),
  ('convertkit', 500)
ON CONFLICT DO NOTHING;
```

---

## HOUR 2-4: OAUTH SETUP & CREDENTIAL MANAGEMENT

### Hour 2 (18:00-19:00): Gumroad & Stripe OAuth

**Step 2.1: Create Gumroad API Token (10 min)**

1. Log into Gumroad (gumroad.com)
2. Settings → API access
3. Generate new token (no expiration)
4. Copy token: `[gumroad-token-here]`

In n8n:
1. Credentials → Create → Select **Gumroad**
   - Authentication method: **API Token**
   - API Token: `[paste token]`
2. Test: "Get Products"
   - Expected: List of your Gumroad products or "No products"
3. Save as `gumroad_main`

---

**Step 2.2: Create Stripe API Key (15 min)**

1. Log into Stripe (stripe.com)
2. Developers → API Keys
3. Copy **Secret Key** (starts with `sk_live_` or `sk_test_`)
4. Copy **Publishable Key** (starts with `pk_live_` or `pk_test_`)

In n8n:
1. Credentials → Create → Select **Stripe**
   - API Key (Secret): `[paste secret key]`
   - API Key (Publishable): `[paste publishable]`
2. Test: "Get Charges"
   - Expected: Recent charges or "No charges"
3. Save as `stripe_main`

---

### Hour 3 (19:00-20:00): ConvertKit & Email Setup

**Step 3.1: ConvertKit Integration (10 min)**

1. ConvertKit → Account Settings → API Keys
2. Copy **API Secret**

In n8n:
1. Credentials → Create → **ConvertKit**
   - API Secret: `[paste]`
2. Test: "Get Forms"
   - Expected: List of forms
3. Save as `convertkit_main`

---

**Step 3.2: Email (Gmail/Outlook) Setup (15 min)**

**Using Gmail:**

1. Google Account → Security → App Passwords (if 2FA enabled)
   - Or: Use OAuth (easier)
2. In n8n:
   - Credentials → Create → **Gmail**
   - Select **OAuth** or **Password**
   - Authorize (OAuth flow) or paste app password
3. Save as `email_alerts`

**Using Outlook:**
1. Similar process, select **Outlook** in n8n
2. OAuth authorization
3. Save as `email_alerts`

---

**Step 3.3: Wave Accounting (Optional, 5 min)**

1. Wave → Settings → API
2. Generate token
3. n8n → Credentials → **Wave**
   - API Token: `[paste]`
4. Save as `wave_accounting`

---

## HOUR 4-16: BUILD ALL 4 WORKFLOWS

### WORKFLOW 1: Revenue Capture (Hourly)

### Hour 4 (20:00-21:00): Setup Trigger & Gumroad Branch

**Step 4.1: Create New Workflow (5 min)**

1. n8n Dashboard → "New Workflow"
2. Name: `W1_Revenue_Capture_Hourly`
3. Description: "Hourly revenue capture from Gumroad, Stripe, Medium"

---

**Step 4.2: Add Cron Trigger (10 min)**

1. Click **Add Starting Node**
2. Search: **Cron**
3. Configure:
   - **Trigger:** Cron
   - **Cron Expression:** `0 * * * *` (every hour at :00)
   - **Timezone:** UTC
4. Test: Click "Start Workflow"
   - Expected: First execution at next hour mark

---

**Step 4.3: Add Gumroad API Node (15 min)**

1. Click **+** to add node after Cron
2. Search: **Gumroad**
3. Select: **Get Products**
4. Configure:
   - **Credentials:** gumroad_main
   - **Resource:** Products
5. Add **For Each** loop:
   - For each product, call **Get Sales**
6. Under loop, add **Gumroad → Get Sales**:
   - **Product ID:** [from loop, product.id]
7. Add **Transform** node to extract:
   - sale_id, amount, customer_email, timestamp

---

### Hour 5 (21:00-22:00): Add Stripe Branch & Aggregate

**Step 5.1: Add Stripe Node (Parallel)**

1. Go back to main flow (before For Each)
2. Click **+** on Cron node → Add branch
3. Add **Stripe → Get Charges**:
   - Credentials: stripe_main
   - Resource: Charges
   - Created: `>=` [1 hour ago]
4. Add **Transform** to extract:
   - charge_id, amount (convert cents to dollars), fee calculation, timestamp

---

**Step 5.2: Merge Branches (10 min)**

1. Add **Merge** node after both branches
2. Configure: Merge mode = "Combine"
3. Add **Aggregate** node:
   - Sum Gumroad revenue: SUM(gumroad_amounts)
   - Sum Stripe revenue: SUM(stripe_amounts)
   - Sum Gumroad fees: Total × 0.10
   - Sum Stripe fees: Total × 0.029 + 0.30

---

**Step 5.3: Insert into PostgreSQL (15 min)**

1. Add **PostgreSQL** node
2. Select: **Execute Query**
3. Query:
   ```sql
   INSERT INTO revenue_summary (
     capture_hour, gumroad_gross, gumroad_net,
     stripe_gross, stripe_net, total_gross, total_net,
     gumroad_fees, stripe_fees, timestamp
   ) VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, NOW()
   )
   ON CONFLICT (capture_hour) DO UPDATE SET
     gumroad_gross = $2, gumroad_net = $3,
     stripe_gross = $4, stripe_net = $5,
     total_gross = $6, total_net = $7,
     timestamp = NOW()
   ```
4. Parameters:
   - $1: [timestamp from trigger]
   - $2: [aggregate: gumroad_gross]
   - ... etc.

---

### Hour 6 (22:00-23:00): Error Handling & Testing

**Step 6.1: Add Error Handlers (15 min)**

1. Add **Error Handler** node after each API call:
   - Gumroad failure → Log to error_logs, retry once, alert CFO
   - Stripe failure → Log to error_logs, retry once, alert CFO
   - PostgreSQL failure → Log to error_logs, alert CFO immediately

2. Each error handler:
   - Insert into error_logs table
   - Send email to CFO with error details
   - Log to n8n execution

---

**Step 6.2: Test Workflow (15 min)**

1. Click **Execute Workflow**
2. Check execution result:
   - [ ] Gumroad data fetched
   - [ ] Stripe data fetched
   - [ ] Data merged correctly
   - [ ] PostgreSQL INSERT successful
   - [ ] No errors in logs
3. Query database to verify:
   ```sql
   SELECT * FROM revenue_summary ORDER BY timestamp DESC LIMIT 1;
   ```

---

**Step 6.3: Save & Activate (5 min)**

1. Click **Save**
2. Click **Activate** (toggle to ON)
3. Expected: "Workflow is now active"

---

### WORKFLOW 2: Content Generation (Daily)

### Hour 7 (23:00-00:00): Daily Content Generation via Claude API

**Step 7.1: Create Workflow (10 min)**

1. n8n → New Workflow
2. Name: `W2_Content_Generation_Daily`
3. Add **Cron** trigger:
   - Expression: `0 6 * * *` (6 AM daily)
   - Timezone: UTC

---

**Step 7.2: Generate Digital Product Content (15 min)**

1. Add **HTTP Request** node:
   - **Method:** POST
   - **URL:** https://api.anthropic.com/v1/messages
   - **Headers:**
     - Authorization: `Bearer [ANTHROPIC_API_KEY]`
     - Content-Type: application/json
   - **Body:**
     ```json
     {
       "model": "claude-3-5-sonnet-20241022",
       "max_tokens": 1024,
       "messages": [
         {
           "role": "user",
           "content": "Generate a digital product template name, description, and price ($19-$199) for a business tools niche. Return as JSON: {name, description, price}."
         }
       ]
     }
     ```
2. Add **Transform** to parse Claude response

---

**Step 7.3: Generate PoD Design (10 min)**

1. Add **HTTP Request** node:
   - Call Claude API with prompt:
     ```
     Generate a print-on-demand design brief.
     Return JSON: {design_name, niche, prompt, size, colors}
     ```
2. Parse response

---

**Step 7.4: Generate Affiliate Article (10 min)**

1. Add **HTTP Request** node:
   - Call Claude API with prompt:
     ```
     Generate an affiliate article outline (300 words).
     Topic: [random SaaS tool]
     Return JSON: {title, outline, seo_keywords, affiliate_link}
     ```

---

**Step 7.5: Insert into Content Queue (5 min)**

1. Add **PostgreSQL** node:
   ```sql
   INSERT INTO content_queue (
     content_type, title, description, metadata, status
   ) VALUES
     ('digital_product', $1, $2, $3::jsonb, 'pending'),
     ('pod_design', $4, $5, $6::jsonb, 'pending'),
     ('article', $7, $8, $9::jsonb, 'pending')
   ```

---

### Hour 8 (00:00-01:00): Workflow 3 - Publishing Pipeline

**Step 8.1: Create Publishing Workflow (10 min)**

1. New Workflow: `W3_Publishing_Pipeline_Daily`
2. Add **Cron** trigger:
   - Expression: `0 9 * * *` (9 AM daily)
   - Timezone: UTC

---

**Step 8.2: Fetch Approved Content (15 min)**

1. Add **PostgreSQL** node:
   ```sql
   SELECT * FROM content_queue
   WHERE status = 'approved' AND published_at IS NULL
   ORDER BY created_at ASC
   LIMIT 5
   ```
2. Add **For Each** loop to iterate through results

---

**Step 8.3: Publish to Gumroad (15 min)**

For digital products:

1. Add **Gumroad → Create Product**:
   - **Name:** [content.title]
   - **Description:** [content.description]
   - **Price:** [content.metadata.price]
   - **License URL:** (if applicable)
2. On success:
   - Update content_queue: status = 'published'
   - Log publishing_log entry

---

### Hour 9 (01:00-02:00): Publish to Other Platforms

**Step 9.1: Publish to WordPress (10 min)**

For articles:

1. Add **WordPress → Create Post**:
   - **Title:** [content.title]
   - **Content:** [content.description]
   - **Status:** draft (for review)
2. On success: Update content_queue

---

**Step 9.2: Publish to Medium (Optional, 10 min)**

1. Add **HTTP Request** node:
   - **Method:** POST
   - **URL:** https://api.medium.com/v1/users/[user_id]/posts
   - **Body:** [article content]
2. Handle 401 (Medium API deprecated) gracefully

---

### Hour 10-11 (02:00-04:00): Workflow 4 - Error Monitoring & Alerts

**Step 10.1: Create Error Monitor Workflow (20 min)**

1. New Workflow: `W4_Error_Monitor_Realtime`
2. Add **Cron** trigger:
   - Expression: `*/15 * * * *` (every 15 minutes)
3. Query error_logs:
   ```sql
   SELECT * FROM error_logs
   WHERE logged_at > NOW() - INTERVAL '15 minutes'
   AND severity IN ('critical', 'warning')
   ```
4. If errors found:
   - Send email alert to CFO
   - Log execution

---

**Step 10.2: Create Daily Summary Email (15 min)**

1. New Workflow: `W5_Daily_Report_CFO`
2. Trigger: `0 8 * * *` (8 AM daily)
3. Query:
   ```sql
   SELECT
     SUM(total_net) as daily_revenue,
     COUNT(DISTINCT platform) as platforms_active,
     (SELECT COUNT(*) FROM error_logs WHERE DATE(logged_at) = CURRENT_DATE) as errors_today
   FROM revenue_summary
   WHERE DATE(timestamp) = CURRENT_DATE
   ```
4. Send email with summary

---

## HOUR 12-16: TESTING & DOCUMENTATION

### Hour 12 (04:00-05:00): End-to-End Workflow Testing

**Test Sequence:**

1. **W1 Revenue Capture:**
   - [ ] Manually trigger (execute now)
   - [ ] Verify Gumroad data fetched
   - [ ] Verify Stripe data fetched
   - [ ] Verify PostgreSQL updated
   - [ ] Check error logs (should be empty)

2. **W2 Content Generation:**
   - [ ] Manually trigger
   - [ ] Verify Claude API called
   - [ ] Verify 3 content items inserted
   - [ ] Check content_queue table

3. **W3 Publishing:**
   - [ ] Manually set one content item to status='approved'
   - [ ] Trigger workflow
   - [ ] Verify Gumroad product created
   - [ ] Verify publishing_log updated

4. **W4 Error Monitor:**
   - [ ] Intentionally break API key (to trigger error)
   - [ ] Run workflow
   - [ ] Verify error logged
   - [ ] Verify email alert sent
   - [ ] Fix API key

---

### Hour 13 (05:00-06:00): Performance & Load Testing

1. **Simulate 10x Revenue:**
   - Insert 100 test rows into revenue_summary
   - Verify CFO query still fast

2. **Database Performance:**
   - Check query execution time (should be <1 second)
   - Add indexes if needed:
     ```sql
     CREATE INDEX idx_revenue_timestamp ON revenue_summary(timestamp);
     CREATE INDEX idx_content_status ON content_queue(status);
     ```

3. **n8n Performance:**
   - Check execution history (Executions tab)
   - Verify no workflows timing out
   - Verify logs clear (no memory leaks)

---

### Hour 14 (06:00-07:00): Documentation & Runbooks

**Create:** `/CTMO/outbox/n8n-deployment-runbook.md`

```markdown
# n8n Deployment Runbook

## Workflow Status
- W1 Revenue Capture: Hourly at :00 UTC ✓
- W2 Content Generation: Daily 6 AM UTC ✓
- W3 Publishing: Daily 9 AM UTC ✓
- W4 Error Monitor: Every 15 min ✓
- W5 CFO Report: Daily 8 AM UTC ✓

## Monitoring
- Dashboard: http://localhost:5678
- Logs: n8n Executions tab
- Database: `psql -h localhost -U makinmoves -d makinmoves`

## If Workflow Fails
1. Check n8n Executions tab for error
2. Check error_logs table for details
3. Check API credentials in Credentials tab
4. Restart workflow: click "Execute"

## If Database Fails
1. Check Docker: `docker ps | grep postgres`
2. Check logs: `docker logs mm-postgres`
3. Restart: `docker compose down && docker compose up -d`

## Rate Limiting
All APIs have built-in backoff in workflows.
If hitting limits, check `api_rate_limits` table.
```

---

### Hour 15 (07:00-08:00): Backup & Disaster Recovery

**Step 15.1: Export Workflows (10 min)**

1. For each workflow:
   - Click workflow → Download (top right)
   - Save as `.json` file
   - Store in `/CTMO/technical/workflows-backup/`

2. Example:
   ```bash
   cp W1_Revenue_Capture_Hourly.json /c/Users/jsmcl/Documents/MakinMoves/CTMO/technical/workflows-backup/
   ```

---

**Step 15.2: Setup PostgreSQL Backups (10 min)**

```bash
# Daily backup script (add to cron or task scheduler)
# Create backup directory
mkdir -p /c/Users/jsmcl/Documents/MakinMoves/backups

# Backup command
pg_dump -h localhost -U makinmoves -d makinmoves > /c/Users/jsmcl/Documents/MakinMoves/backups/makinmoves_$(date +%Y%m%d_%H%M%S).sql

# Restore if needed:
psql -h localhost -U makinmoves -d makinmoves < /c/Users/jsmcl/Documents/MakinMoves/backups/makinmoves_20260329_180000.sql
```

---

**Step 15.3: Docker Image Backup (5 min)**

```bash
# Save Docker compose state
docker compose config > /c/Users/jsmcl/Documents/MakinMoves/CTMO/technical/docker-compose-backup.yml

# If you customize Dockerfile, save it too
cp Dockerfile /c/Users/jsmcl/Documents/MakinMoves/CTMO/technical/Dockerfile-backup
```

---

### Hour 16 (08:00-09:00): Final Verification & Sign-Off

**Pre-Launch Checklist:**

- [ ] All 5 workflows created and active
- [ ] All credentials stored securely
- [ ] PostgreSQL tables initialized
- [ ] Revenue capture working (hourly test passed)
- [ ] Content generation working (daily test passed)
- [ ] Publishing pipeline working (manual test passed)
- [ ] Error monitoring active
- [ ] Daily report email configured
- [ ] Documentation complete
- [ ] Backups configured
- [ ] No manual intervention needed for March 31+

---

## HOUR 16-28: ADVANCED CONFIGURATION & SCALING

### Hour 16-18: Rate Limit Management

**Step 16.1: Implement Rate Limit Tracking in Workflows**

For Gumroad (100 calls/day limit):

1. In W1 Revenue Capture, before Gumroad API call:
   - Add **PostgreSQL** node:
     ```sql
     SELECT calls_today FROM api_rate_limits WHERE api_name = 'gumroad'
     ```
   - Check if `calls_today >= 95` (leaving buffer)
   - If yes: Skip this cycle, log warning
   - If no: Proceed with API call, increment counter

2. Add **PostgreSQL** node after successful call:
   ```sql
   UPDATE api_rate_limits SET calls_today = calls_today + 1
   WHERE api_name = 'gumroad'
   ```

3. Add **Rate Limit Reset** workflow:
   - Cron: `0 0 * * *` (midnight UTC)
   - Query: `UPDATE api_rate_limits SET calls_today = 0`

---

### Hour 18-20: Webhook Integration (Optional)

If platforms support webhooks (Gumroad does), replace polling with webhooks:

**Gumroad Webhook:**

1. Gumroad → Settings → Webhooks
2. Add webhook:
   - **URL:** http://[your-n8n-host]/webhook/gumroad_sale
   - **Events:** Sale completed
3. In n8n:
   - Create new workflow: `W1_Gumroad_Webhook_Trigger`
   - Trigger: **Webhook**
   - Path: `gumroad_sale`
   - This fires on every sale (real-time, not hourly)
   - Insert directly into PostgreSQL

**Advantage:** Real-time revenue capture instead of hourly

---

### Hour 20-24: Scaling Considerations

**Step 20.1: Database Optimization**

```sql
-- Add indexes for faster queries
CREATE INDEX idx_revenue_timestamp ON revenue_summary(timestamp);
CREATE INDEX idx_content_status ON content_queue(status);
CREATE INDEX idx_error_severity ON error_logs(severity, logged_at);
CREATE INDEX idx_publishing_platform ON publishing_log(platform, published_at);

-- Create materialized view for CFO quick access
CREATE MATERIALIZED VIEW revenue_by_day AS
SELECT
  DATE(timestamp) as report_date,
  SUM(total_net) as daily_net,
  SUM(total_gross) as daily_gross,
  COUNT(*) as capture_events
FROM revenue_summary
GROUP BY DATE(timestamp)
ORDER BY report_date DESC;
```

---

**Step 20.2: n8n Optimization**

1. **Node Execution Timeout:**
   - Go to Credentials → [API credential]
   - Set timeout: 30s (prevent hanging)

2. **Execution Retention:**
   - Settings → Workflow → Execution Data
   - Retention: Keep only last 30 days
   - This prevents database bloat

3. **Workflow Concurrency:**
   - Settings → Execution Behavior
   - Max concurrent executions: 5
   - Prevents overwhelming APIs

---

**Step 20.3: Infrastructure Scaling**

**Current: Local Docker**
- Cost: $0
- Capacity: ~1,000 workflow executions/day
- Suitable for: MVP phase

**Scaling to Cloud (If Needed):**

Deploy on **Railway.app** (paid tier):
```bash
# Save Docker compose config to Railway
# Cost: ~$7/month for PostgreSQL + n8n container
# Capacity: ~100,000 workflow executions/day

# Steps:
# 1. Create Railway account (railway.app)
# 2. Connect GitHub repo (or upload docker-compose.yml)
# 3. Deploy PostgreSQL plugin
# 4. Deploy n8n container
# 5. Point Gumroad/Stripe webhooks to Railway URL
```

---

## HOUR 24-28: FINAL TESTING & DEPLOYMENT

### Hour 24-25: Integration Testing

**All workflows together:**

1. Manually create test data:
   - Submit form (if W1 includes intake)
   - Upload test product file (if W2 includes file trigger)
   - Create test sale in Gumroad

2. Verify full pipeline:
   - [ ] Revenue captured within 1 hour
   - [ ] Content generated next morning
   - [ ] Publishing happens at 9 AM
   - [ ] Errors logged and emailed
   - [ ] CFO report arrives at 8 AM

---

### Hour 25-26: Load Testing

**Simulate 100x normal load:**

```sql
-- Insert 100 days of revenue data (for performance testing)
INSERT INTO revenue_summary (capture_hour, gumroad_gross, gumroad_net, stripe_gross, stripe_net, total_gross, total_net, timestamp)
SELECT
  NOW() - INTERVAL '1 hour' * ROW_NUMBER() OVER (),
  RANDOM() * 500,
  RANDOM() * 450,
  RANDOM() * 1000,
  RANDOM() * 970,
  RANDOM() * 1500,
  RANDOM() * 1420,
  NOW() - INTERVAL '1 hour' * ROW_NUMBER() OVER ()
FROM GENERATE_SERIES(1, 100);

-- Test CFO query performance:
SELECT SUM(total_net) FROM revenue_summary WHERE DATE(timestamp) = CURRENT_DATE;
-- Should return in <100ms
```

---

### Hour 26-28: Final Deployment

**Pre-Deployment Verification:**

- [ ] All workflows active
- [ ] All credentials valid
- [ ] Database backups working
- [ ] Error handling tested
- [ ] Documentation complete
- [ ] Disaster recovery procedure documented
- [ ] CFO training complete (can query DB, read emails)

**Go-Live Procedure:**

1. **CTMO Sign-Off:**
   ```
   "All n8n workflows deployed and tested.
   Zero manual intervention required post-March 31.
   Autonomous operation ready.
   Workflows backed up and disaster recovery documented."
   ```

2. **CFO Sign-Off:**
   ```
   "I can query revenue_summary table.
   I receive daily email reports.
   I understand error escalation procedure."
   ```

3. **CEO Sign-Off:**
   ```
   "We are ready for March 31 hands-off."
   ```

4. **Lock Configuration:**
   - Mark all workflows as "Production"
   - Disable editing (read-only mode)
   - Archive test workflows

---

## HOUR 28-36: BUFFER & CONTINGENCIES

### Hour 28-30: Contingency Planning

**"If X fails during operation, do Y":**

| Failure | Detection | Recovery | Time |
|---------|-----------|----------|------|
| **Gumroad API 401** | n8n execution fails | Re-authenticate in Credentials | 5 min |
| **Stripe rate limit** | n8n 429 error | Automatic exponential backoff | 1 hour |
| **PostgreSQL down** | Connection error in n8n | Restart Docker: `docker compose up -d postgres` | 30 sec |
| **n8n crash** | No executions for 1h | Restart: `docker compose up -d n8n` | 1 min |
| **Disk full** | Write errors | Check `/var/lib/postgresql/data`, clean old backups | 20 min |
| **Memory leak** | n8n slow/hanging | Restart n8n container | 1 min |
| **Claude API quota** | Generation workflow fails | Check usage in Anthropic dashboard, reduce frequency | 2 min |
| **Email not sending** | CFO doesn't get alert | Check email credentials, test manually | 10 min |

---

### Hour 30-32: Runbook Creation

**Create:** `/CTMO/technical/n8n-emergency-procedures.md`

```markdown
# n8n Emergency Procedures

## Workflow Down (No Executions for 2+ Hours)

1. Check n8n dashboard: http://localhost:5678
2. Click failing workflow → Execution history
3. Click latest execution → See error details
4. Fix:
   - API error? → Check credentials, re-authenticate
   - Database error? → Check database is running
   - Code error? → Edit workflow, fix code, save, execute

## Database Corruption

1. Check integrity: `psql -c "ANALYZE;"`
2. If corrupted, restore from backup:
   ```bash
   docker compose down
   psql < /c/Users/jsmcl/Documents/MakinMoves/backups/latest.sql
   docker compose up -d
   ```

## n8n Locked/Slow

1. Restart: `docker compose down n8n && docker compose up -d n8n`
2. Wait 60 seconds for startup
3. Try again: http://localhost:5678

## Revenue Not Captured

1. Check n8n execution: Did W1 run?
   - Yes: Check PostgreSQL (may be inserted)
   - No: Check Cron trigger configured correctly
2. Manual fallback: Query APIs directly in Python/curl
3. Insert manually: `INSERT INTO revenue_summary (...)`
```

---

### Hour 32-36: Final Verification & Buffer

**Hour 32-34: Final Testing**
- Full end-to-end test (all workflows together)
- Simulate each failure mode
- Verify recovery procedure
- Document lessons learned

**Hour 34-36: Buffer for Surprises**
- Handle unexpected issues
- Final documentation cleanup
- Final backups
- Final sign-off

---

## n8n SUMMARY

**What We Built:**
- 5 workflows (revenue capture, content generation, publishing, error monitoring, CFO reports)
- Full PostgreSQL integration
- All 4 platforms (Gumroad, Stripe, ConvertKit, Wave)
- Real-time error handling and alerting
- CFO dashboard queries
- Disaster recovery procedures

**Monthly Cost:** $0 (self-hosted) + $20-30 if hosting on Railway

**Post-March 31:**
- Zero manual intervention required
- Hourly revenue capture automatic
- Daily content generation automatic
- Daily publishing automatic
- Error alerts automatic
- CFO reports automatic

**CFO Workload:** 5 minutes/day (check email, query database)

**CTMO Workload:** 15 minutes/week (check logs, monitor for failures)

---

## APPENDIX A: Docker Commands Reference

```bash
# Check all services running
docker ps

# View logs for specific service
docker logs mm-n8n          # n8n logs
docker logs mm-postgres     # PostgreSQL logs

# Full restart (if something breaks)
docker compose down
docker compose up -d

# Access PostgreSQL CLI
psql -h localhost -U makinmoves -d makinmoves

# Backup PostgreSQL
pg_dump -h localhost -U makinmoves -d makinmoves > backup.sql

# Restore PostgreSQL
psql -h localhost -U makinmoves -d makinmoves < backup.sql
```

---

## APPENDIX B: Debugging Workflow Issues

| Issue | Check | Fix |
|-------|-------|-----|
| Workflow not executing | Cron expression | `0 * * * *` for hourly, `0 6 * * *` for daily |
| API returns 401 | Credentials expired | Re-authenticate in Credentials tab |
| PostgreSQL INSERT fails | Syntax error | Check column names match schema |
| Email not sending | Gmail 2FA/security | Use app password or OAuth |
| n8n slow/hanging | Memory usage | Restart container: `docker restart mm-n8n` |
| Rate limit errors | Too many API calls | Check `api_rate_limits` table, adjust frequency |

---

**Status:** COMPLETE PLAYBOOK READY FOR EXECUTION
**Next Step:** Execute Hour 0 at 2026-03-29 16:00

---

*Owner: CTMO*
*Last Updated: 2026-03-29*
*Ready for Deployment: YES*
