# Zapier Pro 36-Hour Execution Playbook
## Autonomous Revenue Recovery — Complete Hour-by-Hour Setup

**Status:** READY FOR EXECUTION
**Timeline:** 2026-03-29 16:00 to 2026-03-30 23:59 (36 hours)
**Owner:** CTMO
**Goal:** Deploy 5 fully-functional workflows + database integration + error handling for autonomous operation post-March 31

---

## EXECUTIVE SUMMARY

**Zapier Pro Path: Why This Works**
- ✓ Zapier handles all OAuth/API auth for us (managed credentials, zero manual token refresh)
- ✓ No DevOps overhead — cloud-hosted, auto-scales, zero infrastructure to maintain
- ✓ 5,000 tasks/month on Pro ($49) covers all 36-hour sprint workflows
- ✓ Task breakdown: ~100 tasks/hour max (revenue capture + publishing) = sustainable
- ✓ Built-in error handling, retry logic, execution logs (all visible in dashboard)
- ✓ No database required initially (can log to PostgreSQL via Webhooks later)

**Critical Differences from n8n:**
- Zapier = managed service (they handle servers, updates, scaling)
- n8n = self-hosted (you handle Docker, updates, server maintenance)
- Zapier is faster to deploy, lower risk of infrastructure failure
- n8n is more powerful but requires CTMO to manage ongoing

---

## HOUR 0-2: ZAPIER ACCOUNT SETUP & OAUTH CONNECTIONS

### Hour 0 (16:00-17:00): Create Account & Configure Base Settings

**Actions:**
1. Go to https://zapier.com (if not already logged in)
2. Upgrade to **Zapier Pro** ($49/month)
   - Click Settings → Plan & Billing
   - Select Pro tier, complete payment
   - Estimated time: 10 minutes
3. Create Zapier team: Settings → Team
   - Team name: "MakinMoves Recovery"
   - Members: Add email for CFO (for monitoring)
   - Estimated time: 5 minutes
4. Set up **Formatter** utility Zaps (available in Pro)
   - These handle data transformation between APIs
   - Estimated time: 5 minutes (just exploring)
5. Create **Storage** for state management
   - Settings → Storage
   - Create storage tables: `platform_state`, `error_tracking`, `rate_limit_counter`
   - Estimated time: 15 minutes

**Expected Outputs:**
- ✓ Zapier Pro account active, 5,000 tasks allocated
- ✓ Team created with CFO access
- ✓ 3 Storage tables ready for state tracking

**If Error:**
- Payment fails? → Use alternate payment method or contact Zapier support
- Can't upgrade? → Proceed with Free tier (2,000 tasks) — will need to prioritize workflows

---

### Hour 1 (17:00-18:00): OAuth Setup — Gumroad, Stripe, ConvertKit

**Step 1.1: Connect Gumroad (15 min)**

1. Go to Zapier → My Apps
2. Click "Add Connection" → Search "Gumroad"
3. Select **Gumroad** (v1 API)
4. Click "Connect a new account"
5. You'll be redirected to Gumroad login
   - Email: [your Gumroad account email]
   - Password: [your password]
   - Authorize: "Grant Zapier access to your account"
6. Confirm connection successful
   - Zapier shows "Gumroad (Your Email) - Connected"
   - Store connection name: `gumroad_main`

**Credentials stored by Zapier:**
- OAuth token (managed by Zapier, auto-refreshed)
- Scope: `view_products`, `view_sales`

**Testing:**
- In "Test" tab: Click "Get Products" → Should list your products (or "No products" if none)

---

**Step 1.2: Connect Stripe (15 min)**

1. Zapier → My Apps → "Add Connection"
2. Search "Stripe" → Select **Stripe**
3. Click "Connect a new account"
4. Stripe login page:
   - Email: [your Stripe account email]
   - Password: [your password]
5. Authorize: "Grant Zapier access"
   - Zapier requests scopes: `read:charges`, `read:customers`
6. Return to Zapier, confirm connection
   - Store name: `stripe_main`

**Credentials:**
- API key (restricted to read-only by Stripe)
- Scope: Transaction read, customer read

**Testing:**
- In "Test" tab: "Get Charges" → Should return recent charges or "No charges yet"

---

**Step 1.3: Connect ConvertKit (10 min)**

1. ConvertKit → Account Settings → API Keys
2. Copy your **API Secret Key**
3. Zapier → My Apps → "Add Connection"
4. Search "ConvertKit" → Select **ConvertKit**
5. Manual authentication:
   - Paste API Secret Key into Zapier
   - Click "Continue"
6. Confirm connection
   - Store name: `convertkit_main`

**Testing:**
- In "Test" tab: "Get Forms" → Should list ConvertKit forms

---

**Step 1.4: Connect Wave Accounting (Honorable Mention)**

For the CFO: Wave can auto-track revenue
1. Wave → Settings → API
2. Generate new token
3. Zapier → "Wave" → Paste token
4. Store name: `wave_accounting`

**Expected Output (Hour 1):**
- ✓ Gumroad: Connected
- ✓ Stripe: Connected
- ✓ ConvertKit: Connected
- ✓ Wave: Connected (optional, for CFO)
- ✓ All 4 OAuth flows tested successfully

---

### Hour 2 (18:00-19:00): Additional OAuth Connections & Error Alerting

**Step 2.1: Connect Email for Alerts (5 min)**

1. Zapier → My Apps → "Add Connection"
2. Search "Gmail" or "Outlook"
3. Choose your email provider
4. Authorize (OAuth)
5. Store name: `email_alerts`
   - This will be used to notify CFO of errors

---

**Step 2.2: Connect PostgreSQL for Logging (15 min)**

**If you plan to log to PostgreSQL:**

1. Zapier → My Apps → "Add Connection"
2. Search "PostgreSQL" → Select **PostgreSQL**
3. Fill in connection details:
   - **Host:** localhost (if local) or [Railway/AWS RDS hostname]
   - **Port:** 5432
   - **Database:** makinmoves
   - **Username:** makinmoves
   - **Password:** changeme123
   - **SSL:** No (if local), Yes (if cloud)
4. Test connection: "Test Connection"
5. Store name: `postgres_logging`

**If connection fails:** Check firewall rules, ensure database is running

---

**Step 2.3: Set Up Rate Limit Tracking (20 min)**

1. Zapier Storage → Create new table: `api_rate_limits`
   - Columns:
     - `api_name` (text): gumroad, stripe, convertkit
     - `calls_today` (number): 0
     - `limit` (number): 100 (Gumroad), 1000 (Stripe), varies (ConvertKit)
     - `last_reset` (timestamp): NOW
2. Set default values:
   - Gumroad: 0/100 calls
   - Stripe: 0/1000 calls
   - ConvertKit: 0/500 calls

3. Create a simple "Reset at Midnight" Zap:
   - Trigger: Schedule (Daily at 00:00 UTC)
   - Action 1: Formatter → Set rate_limits all to 0
   - Action 2: Storage → Update table
   - This ensures we don't hit rate limits

---

**Step 2.4: Create Error Notification Channel (10 min)**

1. Zapier Storage → Create table: `error_log`
   - Columns:
     - `timestamp` (datetime)
     - `workflow_name` (text)
     - `error_message` (text)
     - `severity` (text): info, warning, critical
2. Create monitoring Zap:
   - Trigger: Check Storage `error_log` every 1 hour
   - Condition: IF severity = "critical"
   - Action: Send email to CFO
   - Subject: "CRITICAL: MakinMoves Automation Error"

---

**Expected Outputs (Hour 2):**
- ✓ Email (Gmail/Outlook) connected
- ✓ PostgreSQL connected (if applicable)
- ✓ Rate limit tracking initialized
- ✓ Error notification system active
- ✓ Baseline Zaps created (rate reset, error monitor)

---

## HOUR 2-8: WORKFLOW 1 — CLIENT INTAKE → INVOICE

### Overview
**Goal:** Build a Zap that captures client intake → generates invoice → sends email

**Flow:**
```
Client submits form (Typeform/JotForm)
    ↓
Extract name, email, service, amount
    ↓
Create invoice (Wave/Stripe)
    ↓
Send confirmation email
    ↓
Log to PostgreSQL (if configured)
```

---

### Hour 3 (19:00-20:00): Design & Create Trigger

**Step 3.1: Choose Intake Form (10 min)**

Option A: **JotForm** (Free, easier to set up)
1. Go to jotform.com
2. Create new form "Client Services Intake"
3. Fields:
   - Full Name (text)
   - Email (email)
   - Service Type (dropdown: Design, Coaching, Consulting, Writing)
   - Project Scope (short answer)
   - Budget (number)
4. Enable "Send to Zapier": Form → Webhooks → Copy webhook URL
5. Save form

Option B: **Typeform** (More professional, but Pro plan required)
1. Create form "MakinMoves Intake"
2. Same fields as above
3. Settings → Webhooks → Copy webhook URL

**Step 3.2: Create Zapier Zap #1 — "Intake to Invoice" (15 min)**

1. Zapier → Create new Zap
2. Trigger: Choose **Form Submission** (JotForm or Typeform)
   - Select account: [your form account]
   - Select form: [the intake form you just created]
   - Test trigger: Submit a test form response
     - Expected: Zapier shows form fields (name, email, service, budget)
3. Name this Zap: "WF1_Client_Intake_to_Invoice"

---

### Hour 4 (20:00-21:00): Build Invoice Generation Step

**Step 4.1: Create Invoice (Wave or Stripe)**

Using **Wave** (Free, no fees):

1. Add Action: **Wave** → "Create Invoice"
2. Map fields:
   - **Customer Email:** [Form: Email]
   - **Customer Name:** [Form: Full Name]
   - **Invoice Description:** [Form: Service Type] - [Form: Project Scope]
   - **Amount:** [Form: Budget]
   - **Due Date:** +30 days from today
3. Test action: "Test step"
   - Expected: Zapier creates test invoice in Wave

**Alternative: Using Stripe**

1. Add Action: **Stripe** → "Create Customer"
2. Map:
   - **Email:** [Form: Email]
   - **Name:** [Form: Full Name]
3. Then add another action: **Stripe** → "Create Invoice Item"
   - **Customer:** [From previous step]
   - **Amount:** [Form: Budget] × 100 (in cents)
   - **Description:** [Form: Service Type]

---

### Hour 5 (21:00-22:00): Send Confirmation Email & Log to Database

**Step 5.1: Send Confirmation Email (10 min)**

1. Add Action: **Gmail** (or Outlook)
2. Send email:
   - **To:** [Form: Email]
   - **Subject:** "Invoice Created: [Service] - $[Budget]"
   - **Body:**
     ```
     Hi [Name],

     Thank you for reaching out! We've created your invoice.

     Service: [Service Type]
     Amount: $[Budget]
     Due: [Due Date]

     Payment link: [Invoice URL from Wave/Stripe]

     Best,
     MakinMoves Team
     ```
3. Test action: Check your email

---

**Step 5.2: Log to PostgreSQL (Optional, 10 min)**

1. Add Action: **PostgreSQL**
2. Query type: "Execute custom SQL"
3. SQL:
   ```sql
   INSERT INTO intake_log (
     client_name, client_email, service_type,
     project_scope, budget, invoice_id, created_at
   ) VALUES (
     $1, $2, $3, $4, $5, $6, NOW()
   )
   ```
4. Parameters:
   - $1: [Form: Full Name]
   - $2: [Form: Email]
   - $3: [Form: Service Type]
   - $4: [Form: Project Scope]
   - $5: [Form: Budget]
   - $6: [Wave/Stripe: Invoice ID]

---

**Step 5.3: Log Success to Storage (5 min)**

1. Add Action: **Zapier Storage**
   - Table: `error_log`
   - New row:
     - timestamp: NOW
     - workflow_name: "WF1_Client_Intake"
     - error_message: "Success - invoice created"
     - severity: "info"

---

### Hour 6 (22:00-23:00): Testing & Error Handling

**Step 6.1: End-to-End Test (20 min)**

1. Go to your intake form (JotForm/Typeform)
2. Fill it out as a test:
   - Name: "Test Client"
   - Email: [your email]
   - Service: "Design"
   - Budget: $500
3. Submit form
4. Zapier executes Zap #1:
   - Check Wave/Stripe: Invoice created? ✓
   - Check email: Confirmation received? ✓
   - Check PostgreSQL: Row logged? ✓
5. If all pass: Mark as "Turn On"

---

**Step 6.2: Add Error Handling (15 min)**

1. In Zap editor, go to "Catch" panel
2. Add catch for "Invoice Creation Failed":
   - Trigger: If Wave/Stripe returns error
   - Action: Store in `error_log` table
     - severity: "critical"
     - error_message: [Step error]
   - Action: Send alert email to CFO
     - Subject: "CRITICAL: Invoice creation failed"
     - Body: [Full error details]

3. Add catch for "Email Send Failed":
   - Trigger: If Gmail returns error
   - Action: Retry 3 times (built-in)
   - Then: Log error if still failing

---

**Expected Output (Hour 6):**
- ✓ Zap #1 "Intake to Invoice" created
- ✓ Form submission → Invoice → Email → Log working
- ✓ Error handling configured
- ✓ Zap turned ON and monitoring
- ✓ **Task count after Zap #1:** ~40 tasks/month (intake forms vary)

---

## HOUR 8-14: WORKFLOW 2 — DIGITAL PRODUCT UPLOAD & LISTING

### Overview
**Goal:** Publish digital products to Gumroad and Etsy automatically

**Flow:**
```
COO uploads product file + metadata to folder
    ↓
Zapier detects new file
    ↓
Create product listing (Gumroad)
    ↓
Create product listing (Etsy)
    ↓
Log to sales tracking DB
```

---

### Hour 8 (23:00-00:00): Setup File Detection & Gumroad API

**Step 8.1: Set Up File Monitoring (15 min)**

Using **Google Drive** or **Dropbox**:

1. Create folder: `/MakinMoves/products-ready-to-upload`
   - Subfolders: `/digital`, `/pod`, `/articles`
2. Zapier → New Zap
3. Trigger: **Google Drive** or **Dropbox** → "New File in Folder"
   - Path: `/MakinMoves/products-ready-to-upload/digital`
   - Only match: `.zip` or `.pdf` files
4. Test: Upload test file → Zapier detects it ✓

---

**Step 8.2: Create Gumroad Product Listing (20 min)**

1. Add Action: **Gumroad** → "Create Product"
2. Map fields:
   - **Title:** [File: Name] (e.g., "Template Pack - Q2 Planning")
   - **Description:** [File: Metadata] or template
     - "Editable Notion templates for Q2 planning"
   - **Pricing:** [File: Metadata → price] or default $19.99
   - **License:** Digital product
   - **File:** [Google Drive/Dropbox file URL]
3. Test: Create test product in Gumroad
   - Expected: Product appears on your Gumroad dashboard

---

### Hour 9 (00:00-01:00): Setup Etsy Integration (Optional)

**Note:** Etsy API is more complex, consider skipping in first 36 hours

**If proceeding:**

1. Etsy → Settings → Apps & Integrations → Create app
   - App name: "MakinMoves Automation"
2. Get API credentials (key, secret)
3. Zapier → Add Etsy connection (similar to Stripe)
4. Create Zap action: **Etsy** → "Create Listing"
   - **Title:** [Product: Title]
   - **Description:** [Product: Description]
   - **Price:** [Product: Price]
   - **Category:** [Product: Metadata → category]
5. Test: Create test listing

**If skipping:** Note for Hour 14 — Etsy integration can wait until Hour 14 testing phase

---

### Hour 10 (01:00-02:00): Log to Database + Payment Webhook

**Step 10.1: Capture Payment (Gumroad Webhook)**

1. Create new Zap: Trigger = **Gumroad** → "New Sale"
   - This fires when a product sells
2. Add Action: **PostgreSQL**
   ```sql
   INSERT INTO product_sales (
     gumroad_product_id, customer_email,
     amount, timestamp
   ) VALUES ($1, $2, $3, NOW())
   ```
3. Parameters:
   - $1: [Gumroad: Product ID]
   - $2: [Gumroad: Purchaser Email]
   - $3: [Gumroad: License Key Price]

---

**Step 10.2: Update Inventory/Status (5 min)**

1. Add Action: **Storage** → Update product status
   - Set: `product_status` = "published"
   - Set: `gumroad_url` = [Gumroad: Product URL]
   - Set: `etsy_url` = [Etsy: Listing URL] if applicable

2. Turn ON this Zap

---

### Hour 11-12 (02:00-04:00): Testing Workflows 1 & 2

**Step 11.1: Full Test Sequence (60 min)**

1. **Test Intake Flow:**
   - Submit form with new service request
   - Verify: Invoice created ✓, Email sent ✓, DB logged ✓

2. **Test Product Upload Flow:**
   - Upload test product file to Google Drive
   - Verify: Gumroad listing created ✓
   - Verify: DB updated ✓

3. **Test Payment Capture:**
   - Create test sale in Gumroad manually
   - Verify: Webhook fires ✓, DB logs sale ✓

4. **Check error logs:**
   - Zapier Dashboard → Zaps → each Zap should show "Status: On" with no errors

---

**Expected Output (Hour 12):**
- ✓ Workflow 1 + 2 fully tested
- ✓ All integrations connected
- ✓ Payment capture working
- ✓ Error handling in place
- ✓ **Task count so far:** ~120 tasks/month (sustainable on Pro)

---

## HOUR 14-20: WORKFLOW 3 — PAYMENT TRACKING & FINANCIAL LOGGING

### Overview
**Goal:** Hourly revenue capture from all platforms + CFO dashboard

**Flow:**
```
Hourly trigger (every 1 hour)
    ↓
Poll Gumroad API for sales
    ↓
Poll Stripe API for charges
    ↓
Aggregate revenue figures
    ↓
Update PostgreSQL revenue_summary table
    ↓
CFO can query daily/weekly reports
```

---

### Hour 14 (04:00-05:00): Create Hourly Revenue Capture Zap

**Step 14.1: Hourly Trigger (5 min)**

1. Create new Zap: Trigger = **Schedule** → "Hourly"
   - Interval: Every 1 hour, at :00 (9 AM, 10 AM, 11 AM, etc.)
2. Name: "WF3_Revenue_Capture_Hourly"

---

**Step 14.2: Gumroad Revenue Fetch (15 min)**

1. Add Action: **Gumroad** → "Get Sales"
   - Optional filters: `created_at >= [1 hour ago]`
2. Expected response: List of sales in last hour
3. Loop through results:
   - For each sale, extract:
     - sale_id
     - product_id
     - amount (gross)
     - timestamp

---

**Step 14.3: Stripe Revenue Fetch (15 min)**

1. Add Action: **Stripe** → "Get Charges"
   - Filter: `created >= [1 hour ago]`
2. For each charge:
   - Extract: charge_id, amount (in cents), timestamp
   - Calculate fee: amount × 0.029 + 30 cents
   - Net: amount - fee

---

### Hour 15 (05:00-06:00): Aggregate & Log Revenue

**Step 15.1: Aggregate Results (15 min)**

1. Add Action: **Formatter** → "Aggregate"
   - Total Gumroad sales: SUM(gumroad amounts)
   - Total Stripe sales: SUM(stripe amounts)
   - Combined: Total Gumroad + Total Stripe
   - Fee total: Gumroad (10%) + Stripe (2.9% + $0.30)
   - Net total: Combined - Fees

---

**Step 15.2: Insert into PostgreSQL (15 min)**

1. Add Action: **PostgreSQL** → "Execute Custom SQL"
   ```sql
   INSERT INTO revenue_summary (
     capture_hour, gumroad_gross, gumroad_net,
     stripe_gross, stripe_net, total_gross, total_net,
     gumroad_fees, stripe_fees, timestamp
   ) VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, NOW()
   )
   ```

2. Parameters:
   - $1: [Date/Hour from trigger]
   - $2: [Gumroad: Total gross]
   - $3: [Gumroad: Total net (90%)]
   - $4: [Stripe: Total gross]
   - $5: [Stripe: Total net (97.1%)]
   - $6: [Combined gross]
   - $7: [Combined net]
   - $8: [Gumroad fees]
   - $9: [Stripe fees]

---

### Hour 16 (06:00-07:00): CFO Dashboard & Email Alerts

**Step 16.1: Daily Revenue Summary Email (20 min)**

1. Create separate Zap: Trigger = **Schedule** → "Daily at 8 AM"
2. Action: **PostgreSQL** → "Find Record"
   ```sql
   SELECT SUM(total_net) as daily_revenue
   FROM revenue_summary
   WHERE DATE(timestamp) = CURRENT_DATE
   ```
3. Action: **Gmail**
   - Subject: "Daily Revenue Report - [Date]"
   - Body:
     ```
     Daily Revenue: $[amount]
     Gumroad: $[gumroad_net]
     Stripe: $[stripe_net]
     Fees: $[total_fees]

     Progress to $10K goal: [amount]/$10,000
     ```

---

**Step 16.2: Weekly Report (10 min)**

1. Create new Zap: Trigger = **Schedule** → "Weekly on Friday at 9 AM"
2. Action: **PostgreSQL**
   ```sql
   SELECT
     SUM(total_net) as weekly_total,
     AVG(total_net) as daily_average,
     MAX(total_net) as peak_day
   FROM revenue_summary
   WHERE timestamp >= (NOW() - INTERVAL '7 days')
   ```
3. Action: **Gmail** with weekly breakdown

---

### Hour 17-19 (07:00-10:00): Testing & Error Handling

**Step 17.1: Test Hourly Capture (60 min)**

1. In Zapier, manually trigger "Revenue Capture" Zap
2. Check results:
   - Gumroad sales fetched? ✓
   - Stripe charges fetched? ✓
   - Database updated? ✓ (Check PostgreSQL)

3. Verify calculations:
   - Gumroad net = gross × 0.90 ✓
   - Stripe net = gross - fees ✓
   - Total aggregation correct ✓

---

**Step 17.2: Email Alerts**

1. Manually trigger daily/weekly email
2. Check email receipt
3. Verify numbers match database

---

**Step 17.3: Error Handling (30 min)**

1. Add Catch for API failures:
   - If Gumroad returns error → Log, retry once, then alert CFO
   - If Stripe returns error → Log, retry once, then alert CFO
   - If PostgreSQL INSERT fails → Alert CFO immediately

2. Create "Dead Letter" queue in Storage:
   - If transaction fails 3x, store in `failed_transactions`
   - CFO reviews daily

---

**Expected Output (Hour 19):**
- ✓ Hourly revenue capture Zap active
- ✓ Daily + weekly summary emails working
- ✓ PostgreSQL logging confirmed
- ✓ Error handling for all failure modes
- ✓ **Task count so far:** ~200 tasks/month (still within 5,000 Pro limit)

---

## HOUR 20-28: INTEGRATION TESTING, ERROR HANDLING, MONITORING

### Overview
**Goal:** End-to-end system testing, error recovery procedures, CFO monitoring dashboard

---

### Hour 20-21 (10:00-12:00): Full System Integration Test

**Checklist:**

1. **Intake Flow:**
   - [ ] Submit client intake form
   - [ ] Invoice created in Wave/Stripe
   - [ ] Confirmation email sent
   - [ ] DB log updated
   - [ ] Status in Zapier Dashboard shows "Success"

2. **Product Upload Flow:**
   - [ ] Upload product file to Google Drive
   - [ ] Gumroad listing created automatically
   - [ ] Product status updated in Storage
   - [ ] Product URL stored

3. **Revenue Capture Flow:**
   - [ ] Hourly trigger fires (or manually trigger)
   - [ ] Gumroad API polled
   - [ ] Stripe API polled
   - [ ] Revenue logged to PostgreSQL
   - [ ] Daily email summary accurate

4. **Error Scenarios:**
   - [ ] Unplug internet, watch Zapier retry 3x then alert
   - [ ] Disable Gumroad token, watch error handling
   - [ ] Disable Stripe token, watch Stripe branch fail gracefully
   - [ ] Database unreachable, watch logging fail gracefully

---

### Hour 22-24 (12:00-16:00): Documentation & Runbooks

**What to Document:**

1. **Zap List** (Create in Zapier → "Team → Documentation"):
   ```
   Workflow 1: Intake to Invoice
   - Trigger: JotForm submission
   - Actions: Create invoice, send email, log to DB
   - Status: ON
   - Error handling: ✓
   - Last tested: [timestamp]

   Workflow 2: Product Upload to Platforms
   - Trigger: Google Drive file upload
   - Actions: Create Gumroad listing, Etsy listing, update DB
   - Status: ON
   - Error handling: ✓
   - Last tested: [timestamp]

   Workflow 3: Revenue Capture (Hourly)
   - Trigger: Every hour at :00
   - Actions: Poll Gumroad, poll Stripe, aggregate, log
   - Status: ON
   - Error handling: ✓
   - Last tested: [timestamp]

   Support Zaps:
   - Daily Revenue Summary Email
   - Weekly Revenue Report
   - Rate Limit Reset (Midnight)
   - Error Monitor Alert
   ```

2. **CFO Monitoring Checklist:**
   - Daily: Check revenue email (8 AM)
   - Weekly: Check revenue report (Friday 9 AM)
   - Monitor: Zapier dashboard for failed tasks
   - If error: Check `error_log` in Storage, alert CTMO

3. **CTMO Troubleshooting Guide:**
   - "Gumroad API returning 401" → Token expired, re-authenticate
   - "Stripe API returning 429" → Rate limited, wait 1 hour
   - "PostgreSQL connection failed" → Check firewall, connectivity
   - "Email not sending" → Check email quota, Gmail security settings

---

### Hour 25-26 (16:00-18:00): Scaling & Performance

**Optimization Checklist:**

1. **Rate Limiting:**
   - [ ] Gumroad: Currently 100 calls/hour = sustainable ✓
   - [ ] Stripe: Currently ~10 calls/hour = sustainable ✓
   - [ ] No changes needed

2. **Task Budget:**
   - [ ] Current consumption: ~200-300 tasks/month
   - [ ] Pro plan: 5,000 tasks/month available
   - [ ] Headroom: 4,700 tasks/month (94% available) ✓
   - [ ] Can scale 10x without hitting limit

3. **Database Optimization:**
   - [ ] Add index on `timestamp` in revenue_summary for faster queries
   - [ ] Add index on `product_id` for quick lookups

---

### Hour 27-28 (18:00-20:00): Final Verification & Go-Live

**Pre-Deployment Checklist (Hour 27):**

- [ ] All 5 Zaps marked "ON"
- [ ] Zap execution logs show no errors in last 24h
- [ ] PostgreSQL populated with test data
- [ ] CFO can run queries successfully
- [ ] Email alerts tested and working
- [ ] Rate limit tracking initialized
- [ ] Error log system active
- [ ] Documentation complete

**Go-Live Procedure (Hour 28):**

1. CFO confirms: "Revenue capture working, I can monitor it"
2. CTMO confirms: "All systems green, no manual intervention needed"
3. CEO approves: "We're ready for March 31 hands-off"

**Then:**
- Mark Zaps as "Production"
- Lock all Zap configurations (no more changes)
- Archive any test Zaps
- Notify team: "Autonomous operation live"

---

## HOUR 28-36: BUFFER, DOCUMENTATION, FINAL CHECKLIST

### Hour 28-30: Documentation & Knowledge Transfer

**Create:**
1. **CTMO Handoff Doc:**
   - Location: `/CTMO/outbox/zapier-handoff-checklist.md`
   - What to monitor hourly
   - What to do if Zap fails
   - How to add new workflows

2. **CFO Monitoring Dashboard:**
   - PostgreSQL queries for daily/weekly/monthly revenue
   - Email template for alerts
   - How to query `error_log` if something breaks

3. **COO Content Upload Guide:**
   - Where to upload product files
   - Required metadata format
   - How to check if upload succeeded

---

### Hour 30-32: Create Contingency Procedures

**If X fails, do Y:**

1. **"Gumroad OAuth token expired"**
   - Action: Re-authenticate in Zapier → My Apps → Gumroad → Reconnect
   - Time: 5 minutes

2. **"PostgreSQL unreachable"**
   - Action: Check database connection string, ensure server running
   - Fallback: Log to Zapier Storage instead until DB recovered
   - Time: 30 minutes

3. **"Email service down"**
   - Action: Use alternative email (Outlook if was Gmail, Gmail if was Outlook)
   - Fallback: Log errors to Storage, CFO checks manually
   - Time: 15 minutes

4. **"Hit rate limit on Stripe/Gumroad"**
   - Action: Automatic backoff in Zapier (built-in)
   - Fallback: Manual API calls after waiting 1 hour
   - Time: 1 hour + action

---

### Hour 32-36: Testing & Final Deployment

**Hour 32-33: Load Testing**
- Simulate 10x revenue (generate fake transactions)
- Verify all Zaps handle load
- Check database performance (no slowdowns)
- Verify email alerts still work under load

**Hour 33-34: Security Audit**
- [ ] All OAuth tokens stored securely in Zapier (not in plain text)
- [ ] Database password not exposed in Zap configs
- [ ] Email alerts don't leak sensitive data
- [ ] Storage encryption enabled in Zapier

**Hour 34-36: Final Verification & Sign-Off**

1. **CTMO Sign-Off:**
   - "All systems operational, zero manual intervention needed"
   - "I have documented all procedures"
   - "CFO has access to monitor everything"

2. **CFO Sign-Off:**
   - "I can query revenue data"
   - "I understand error alerts"
   - "I know how to escalate if issues arise"

3. **CEO Sign-Off:**
   - "We're ready for March 31 hands-off"

---

## ZAPIER PRO SUMMARY

**What We Built:**
- 3 core workflows (intake, products, revenue capture)
- 2 support workflows (daily/weekly reporting)
- Error handling for all failure modes
- PostgreSQL integration for persistence
- Email alerts for CFO monitoring

**Task Budget:** ~300 tasks/month (5,000 available = 16x headroom)

**Monthly Cost:** $49 (Zapier Pro)

**Post-March 31:**
- Zero manual intervention required
- Hourly revenue capture automatic
- Daily email summaries automatic
- Weekly reports automatic
- Error alerts automatic

**CFO Workload:** 5 minutes/day (check email, query database)

---

## APPENDIX A: Zapier vs n8n Comparison

| Factor | Zapier Pro | n8n Self-Hosted |
|--------|-----------|-----------------|
| **Setup Time** | 36 hours | 36 hours |
| **Ongoing DevOps** | Zero | High (Docker, updates) |
| **Cost/Month** | $49 | $0 (self-hosted) + infra |
| **Scaling** | Auto (Zapier handles) | Manual (CTMO manages) |
| **API Integrations** | 6,000+ pre-built | Webhooks/custom |
| **Error Handling** | Built-in, managed | CTMO must build |
| **Monitoring** | Zapier dashboard | n8n dashboard |
| **Risk of Failure** | Low (managed service) | Medium (depends on CTMO) |
| **Time to 10k goal** | Identical | Identical |

**Recommendation:** Zapier Pro for simplicity & reliability. n8n if you want maximum control.

---

**Status:** COMPLETE PLAYBOOK READY FOR EXECUTION
**Next Step:** Execute Hour 0 at 2026-03-29 16:00
