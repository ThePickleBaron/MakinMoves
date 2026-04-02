# IMMEDIATE ACTION CHECKLIST — Next 2 Hours
**Time:** 2026-03-29 18:00–20:00 UTC
**Owner:** CTMO (lead), COO (parallel), CFO (parallel)
**Deadline:** 2026-03-29 20:00 UTC (Phase 0 complete)

---

## CTMO: ENVIRONMENT SETUP (2 hours)

### Task 1: Verify n8n Paid Tier (15 min)
- [ ] Access n8n dashboard
- [ ] Check current plan in Settings → Billing
- [ ] Confirm: NOT free tier (free has 5-min execution limit, insufficient)
- [ ] If free tier: STOP, escalate to CEO (need paid tier for content generation)
- [ ] If paid tier: PROCEED ✓

**If blocked:**
- Free tier would require substantial rework of content generation
- Contact CEO immediately — may delay autonomy to April

---

### Task 2: Gather API Credentials (45 min)

**2.1 Gumroad Token:**
- [ ] Open https://app.gumroad.com/settings
- [ ] Click "API Access" or "Developer" section
- [ ] Click "Generate access token" (if not already done)
- [ ] Copy token
- [ ] Store in SECURE location (not email, not Slack)
- [ ] Later: Add to n8n credentials (encrypted)

**2.2 Etsy OAuth (Client ID + Secret):**
- [ ] Open https://www.etsy.com/developers
- [ ] Click "Create an App" (if not already done)
- [ ] Fill in app name, description, etc.
- [ ] Agree to terms
- [ ] Copy Client ID
- [ ] Copy Client Secret
- [ ] Note OAuth redirect URI (will use in n8n): `https://<n8n-instance>/rest/oauth2/callback?service=etsy`
- [ ] Store both in SECURE location

**2.3 WordPress App Password:**
- [ ] Log into WordPress admin dashboard
- [ ] Go to Users → Your Profile
- [ ] Scroll to "Application Passwords" section
- [ ] Enter app name: "n8n-automation"
- [ ] Click "Create Application Password"
- [ ] Copy the generated 24-character password
- [ ] Store in SECURE location

**2.4 Bitly API Key:**
- [ ] Open https://bitly.com (log in or create account)
- [ ] Go to Settings → Developer Settings
- [ ] Click "API Access"
- [ ] Generate new API key (or use existing)
- [ ] Copy key
- [ ] Store in SECURE location

**2.5 Claude API Key:**
- [ ] Open https://console.anthropic.com (or use existing key)
- [ ] Go to API Keys section
- [ ] Create new key or use existing
- [ ] Copy key
- [ ] Store in SECURE location

**Secure storage recommendation:**
- Create file: `/ctmo/credentials_ENCRYPTED.txt` (in .gitignore)
- Or use Password Manager (1Password, Bitwarden)
- Or ask CEO for secure vault

---

### Task 3: n8n Credentials Manager Setup (30 min)

For each API credential, add to n8n:

**3.1 Gumroad Credentials:**
- [ ] n8n Dashboard → Credentials
- [ ] "New" → "Gumroad API"
- [ ] Paste token
- [ ] Save

**3.2 Etsy Credentials:**
- [ ] n8n Dashboard → Credentials
- [ ] "New" → "Etsy API" (if predefined) or "HTTP Request"
- [ ] Paste Client ID
- [ ] Paste Client Secret
- [ ] Configure OAuth callback (may be auto-managed by n8n)
- [ ] Save

**3.3 WordPress Credentials:**
- [ ] n8n Dashboard → Credentials
- [ ] "New" → "WordPress" or "HTTP Request"
- [ ] Enter: WordPress domain
- [ ] Enter: Username
- [ ] Enter: App password (the 24-char string)
- [ ] Save

**3.4 Bitly Credentials:**
- [ ] n8n Dashboard → Credentials
- [ ] "New" → "HTTP Request"
- [ ] Auth type: "Bearer Token"
- [ ] Paste Bitly API key
- [ ] Save

**3.5 Claude API Credentials:**
- [ ] n8n Dashboard → Credentials
- [ ] "New" → "HTTP Request"
- [ ] Auth type: "Bearer Token"
- [ ] Paste Claude API key
- [ ] Save

**Test each credential:**
- [ ] Gumroad: Make HTTP GET to `/v2/me`, should return {"id": ...}
- [ ] Etsy: Make HTTP GET to `/v3/me`, should return user info
- [ ] WordPress: Make HTTP GET to `/wp-json/wp/v2/posts`, should return posts array
- [ ] Bitly: Make HTTP GET to `/v4/user`, should return user info
- [ ] Claude: Make HTTP POST to `/v1/messages`, should return valid response

---

### Task 4: PostgreSQL Database Setup (30 min)

**4.1 Verify PostgreSQL is running:**
```bash
docker ps | grep postgres
```
- Should show: `makinmoves-portable_postgres` running
- If not running: `docker-compose up -d postgres`

**4.2 Connect to PostgreSQL:**
```bash
docker exec -it makinmoves-portable_postgres psql -U postgres
```

**4.3 Create tables (copy-paste SQL below):**

```sql
-- Revenue tracking tables
CREATE TABLE IF NOT EXISTS gumroad_sales (
  id SERIAL PRIMARY KEY,
  sale_id TEXT UNIQUE NOT NULL,
  product_id TEXT NOT NULL,
  amount DECIMAL(10, 2),
  currency TEXT DEFAULT 'usd',
  customer_email_hash TEXT,
  created_at TIMESTAMP,
  fetched_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS etsy_sales (
  id SERIAL PRIMARY KEY,
  transaction_id TEXT UNIQUE NOT NULL,
  listing_id TEXT NOT NULL,
  amount DECIMAL(10, 2),
  currency TEXT DEFAULT 'usd',
  buyer_id TEXT,
  created_at TIMESTAMP,
  fetched_at TIMESTAMP DEFAULT NOW()
);

-- Content management
CREATE TABLE IF NOT EXISTS content_queue (
  id SERIAL PRIMARY KEY,
  content_type TEXT NOT NULL, -- 'digital_product', 'pod_design', 'article'
  title TEXT NOT NULL,
  description TEXT,
  metadata JSONB,
  status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'published', 'failed'
  created_at TIMESTAMP DEFAULT NOW(),
  published_at TIMESTAMP,
  published_url TEXT
);

-- Publishing audit trail
CREATE TABLE IF NOT EXISTS publishing_log (
  id SERIAL PRIMARY KEY,
  content_id INTEGER REFERENCES content_queue(id),
  platform TEXT NOT NULL, -- 'gumroad', 'etsy', 'wordpress', 'bitly'
  published_url TEXT,
  status TEXT DEFAULT 'published',
  published_at TIMESTAMP DEFAULT NOW()
);

-- Affiliate link tracking
CREATE TABLE IF NOT EXISTS affiliate_clicks (
  id SERIAL PRIMARY KEY,
  bitly_link TEXT NOT NULL,
  article_id INTEGER,
  click_count INTEGER DEFAULT 0,
  tracked_at TIMESTAMP DEFAULT NOW()
);

-- Workflow execution tracking
CREATE TABLE IF NOT EXISTS workflow_executions (
  id SERIAL PRIMARY KEY,
  workflow_id TEXT NOT NULL, -- 'revenue_capture', 'content_generation', 'publishing'
  status TEXT NOT NULL, -- 'success', 'partial_failure', 'failure'
  items_generated INTEGER DEFAULT 0,
  items_published INTEGER DEFAULT 0,
  errors_count INTEGER DEFAULT 0,
  execution_time_ms INTEGER,
  executed_at TIMESTAMP DEFAULT NOW()
);

-- Error logging
CREATE TABLE IF NOT EXISTS error_logs (
  id SERIAL PRIMARY KEY,
  workflow_id TEXT,
  error_type TEXT, -- 'AUTH_FAILURE', 'RATE_LIMIT', 'VALIDATION', 'SERVER_ERROR'
  error_message TEXT,
  severity TEXT, -- 'CRITICAL', 'WARNING', 'INFO'
  context JSONB,
  logged_at TIMESTAMP DEFAULT NOW()
);

-- Rate limit tracking (Etsy)
CREATE TABLE IF NOT EXISTS etsy_rate_limit_tracking (
  id SERIAL PRIMARY KEY,
  requests_today INTEGER DEFAULT 0,
  daily_reset_at TIMESTAMP DEFAULT NOW() + INTERVAL '1 day',
  last_request_at TIMESTAMP
);

-- Rate limit tracking (Gumroad)
CREATE TABLE IF NOT EXISTS gumroad_rate_limit_tracking (
  id SERIAL PRIMARY KEY,
  requests_today INTEGER DEFAULT 0,
  daily_reset_at TIMESTAMP DEFAULT NOW() + INTERVAL '1 day',
  last_request_at TIMESTAMP
);
```

**4.4 Verify tables created:**
```sql
\dt
```
Should list all 8 tables

**4.5 Exit PostgreSQL:**
```bash
\q
```

---

### Task 5: Test n8n → PostgreSQL Connection (15 min)

**In n8n:**
- [ ] Create new workflow (temporary)
- [ ] Add node: "PostgreSQL"
- [ ] Auth: Add credentials (PostgreSQL connection)
  - [ ] Host: `postgres` (Docker hostname)
  - [ ] Port: `5432`
  - [ ] User: `postgres`
  - [ ] Password: (from docker-compose)
  - [ ] Database: `postgres`
- [ ] Query: `SELECT COUNT(*) FROM gumroad_sales;`
- [ ] Execute
- [ ] Verify: Returns `{"count": "0"}` (or similar)
- [ ] Connection works ✓

If fails:
- [ ] Check PostgreSQL is running: `docker ps`
- [ ] Check password in docker-compose.yml
- [ ] Check Docker network: both services in same network?

---

## COO: ACCOUNT SETUP (Parallel, 2 hours)

### Task 1: Gumroad Pre-Created Templates (45 min)

**Goal:** Create 5 placeholder digital products that n8n will update

**Steps:**
- [ ] Log into Gumroad: https://app.gumroad.com
- [ ] Click "Products" → "Create Product"
- [ ] Create 5 products with these names:
  1. "Product Template 1"
  2. "Product Template 2"
  3. "Product Template 3"
  4. "Product Template 4"
  5. "Product Template 5"
- [ ] For each product:
  - [ ] Add description: "AI-generated digital product"
  - [ ] Set price: $19.99 (placeholder)
  - [ ] Add a placeholder file or link
  - [ ] Set to "Draft" or "Published" (your preference)
  - [ ] Save
- [ ] Note each product ID (visible in URL or product page)
- [ ] Store product IDs in spreadsheet for CTMO

**Later:** n8n will update these products' names, descriptions, and prices based on content_queue

---

### Task 2: Etsy Seller Account Setup (45 min)

If already have Etsy seller account:
- [ ] Log in: https://www.etsy.com/shop
- [ ] Skip to "Get API credentials" below

If need to create:
- [ ] Go https://www.etsy.com/shops/create
- [ ] Follow Etsy seller onboarding
- [ ] Verify email
- [ ] Set up shop name, banner, etc.

**Get API Credentials:**
- [ ] Go https://www.etsy.com/developers
- [ ] Register app (if not done)
- [ ] Get Client ID + Client Secret
- [ ] Share with CTMO (via secure method)

---

### Task 3: WordPress App Password (20 min)

Already done above by CTMO, but verify:
- [ ] Log into WordPress: https://yoursite.com/wp-admin
- [ ] Users → Your Profile
- [ ] "Application Passwords" section
- [ ] Check: Do you see "n8n-automation"?
- [ ] If not: Create new app password for n8n
- [ ] Share 24-char password with CTMO (via secure method)

---

### Task 4: Affiliate Keywords List (10 min)

**Create list of 10 evergreen affiliate article topics:**

Examples (replace with your niches):
1. "Best project management tools for remote teams"
2. "How to start a blog in 2026"
3. "Email marketing tools comparison"
4. "Best time tracking software for freelancers"
5. "Website builder comparison: Wix vs Squarespace"
6. "Best Shopify apps for e-commerce"
7. "Password manager comparison"
8. "Best VPN services 2026"
9. "Cloud storage solutions comparison"
10. "Best notetaking apps for productivity"

**Store in:** `/coo/affiliate_topics.txt` or spreadsheet

**Later:** Claude API will randomly select from this list daily for article generation

---

## CFO: DATABASE SETUP (Parallel, 1 hour)

### Task 1: Verify PostgreSQL Tables (10 min)
- [ ] Coordinate with CTMO on table creation
- [ ] Verify: `docker exec -it makinmoves-portable_postgres psql -U postgres`
- [ ] List tables: `\dt`
- [ ] All 8 tables present? ✓

### Task 2: Create Revenue Summary View (30 min)

**In PostgreSQL:**

```sql
CREATE OR REPLACE VIEW revenue_summary_hourly AS
SELECT
  DATE_TRUNC('hour', COALESCE(g.created_at, e.created_at)) AS hour,
  COALESCE(COUNT(DISTINCT g.sale_id), 0) AS gumroad_sales_count,
  COALESCE(SUM(g.amount), 0) AS gumroad_amount,
  COALESCE(COUNT(DISTINCT e.transaction_id), 0) AS etsy_sales_count,
  COALESCE(SUM(e.amount), 0) AS etsy_amount,
  COALESCE(COUNT(DISTINCT g.sale_id), 0) + COALESCE(COUNT(DISTINCT e.transaction_id), 0) AS total_transactions,
  COALESCE(SUM(g.amount), 0) + COALESCE(SUM(e.amount), 0) AS total_revenue
FROM gumroad_sales g
FULL OUTER JOIN etsy_sales e
  ON DATE_TRUNC('hour', g.created_at) = DATE_TRUNC('hour', e.created_at)
GROUP BY hour
ORDER BY hour DESC;

CREATE OR REPLACE VIEW revenue_summary_daily AS
SELECT
  DATE(COALESCE(g.created_at, e.created_at)) AS day,
  COALESCE(COUNT(DISTINCT g.sale_id), 0) AS gumroad_sales_count,
  COALESCE(SUM(g.amount), 0) AS gumroad_amount,
  COALESCE(COUNT(DISTINCT e.transaction_id), 0) AS etsy_sales_count,
  COALESCE(SUM(e.amount), 0) AS etsy_amount,
  COALESCE(COUNT(DISTINCT g.sale_id), 0) + COALESCE(COUNT(DISTINCT e.transaction_id), 0) AS total_transactions,
  COALESCE(SUM(g.amount), 0) + COALESCE(SUM(e.amount), 0) AS total_revenue
FROM gumroad_sales g
FULL OUTER JOIN etsy_sales e
  ON DATE(g.created_at) = DATE(e.created_at)
GROUP BY day
ORDER BY day DESC;
```

**Test views:**
```sql
SELECT * FROM revenue_summary_hourly LIMIT 1;
SELECT * FROM revenue_summary_daily LIMIT 1;
```

Both should return 0 revenue (no sales yet), but schema should be correct.

### Task 3: Test Basic Queries (20 min)

**Query 1: Total revenue (all time)**
```sql
SELECT SUM(amount) AS total_revenue FROM gumroad_sales
UNION ALL
SELECT SUM(amount) FROM etsy_sales;
```

**Query 2: Revenue last 24 hours**
```sql
SELECT
  (SELECT COALESCE(SUM(amount), 0) FROM gumroad_sales WHERE created_at > NOW() - INTERVAL '24 hours') AS gumroad_24h,
  (SELECT COALESCE(SUM(amount), 0) FROM etsy_sales WHERE created_at > NOW() - INTERVAL '24 hours') AS etsy_24h;
```

**Query 3: Workflow execution status**
```sql
SELECT workflow_id, status, COUNT(*) as executions FROM workflow_executions GROUP BY workflow_id, status;
```

All queries should return valid results (even if empty).

---

## COMPLETION CHECKLIST

### By 20:00 UTC (2 hours from start):

✓ **CTMO (2 hours):**
- [ ] n8n paid tier verified
- [ ] All 5 API credentials gathered
- [ ] All 5 n8n credentials configured + tested
- [ ] PostgreSQL tables created + verified
- [ ] n8n → PostgreSQL connection tested

✓ **COO (Parallel, 2 hours):**
- [ ] 5 Gumroad template products created + IDs noted
- [ ] Etsy seller account verified + API credentials obtained
- [ ] WordPress app password verified
- [ ] 10 affiliate keywords list created

✓ **CFO (Parallel, 1 hour):**
- [ ] PostgreSQL tables verified
- [ ] Revenue summary views created + tested
- [ ] Basic queries verified

---

## GO/NO-GO: Phase 0 Complete?

### GO (All green, proceed to Phase 1)
- ✓ n8n paid tier confirmed
- ✓ All credentials working
- ✓ PostgreSQL ready
- ✓ Account setup complete
- ✓ Keyword list ready

### NO-GO (Blocker found, escalate)
- ❌ Free n8n tier found (need paid)
- ❌ API credential missing
- ❌ PostgreSQL connection fails
- ❌ Account creation delayed

If NO-GO: Contact CEO immediately with blocker, adjust timeline

---

## NEXT PHASE

**By 23:00 UTC (Phase 1: Gumroad Revenue Capture):**
- CTMO builds n8n Workflow 1
- Expected: First revenue captured from Gumroad

---

**Owner:** CTMO + COO + CFO
**Deadline:** 2026-03-29 20:00 UTC
**Status:** READY TO EXECUTE

