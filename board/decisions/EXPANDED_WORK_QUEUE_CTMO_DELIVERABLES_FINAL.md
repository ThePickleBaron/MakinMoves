# CTMO — EXPANDED Work Queue with Deployed Infrastructure
**Time Block:** 8:15 PM – 9:00 PM (45 minutes)
**Standard:** Match COO's execution — deploy actual working systems (not diagrams/specifications)
**Deliverables Location:** Deployed systems + documentation in `./technical/`

---

## WHAT SUCCESS LOOKS LIKE

COO delivered:
- 5 products (some live, some ready to upload)
- HTML landing page (ready to deploy)
- Articles written (ready to paste)
- Live dashboard tracking revenue

**You deliver:**
- Live database (data flowing in automatically)
- Working webhooks (logging sales without manual entry)
- Connected CFO dashboard (auto-populated, no data entry)
- Runbook (someone else can troubleshoot without you)

---

## DELIVERABLE #1: Live PostgreSQL Database (8:15–8:25 PM)
**Output Status:** ✅ DEPLOYED & ACCESSIBLE

Create and deploy actual working database:

```bash
# Step 1: Deploy PostgreSQL (use Railway, Render, or local Docker)
# Connection string: postgres://user:pass@host:port/makinmoves

# Step 2: Run these CREATE statements immediately
CREATE TABLE p1_gumroad_sales (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(255),
  buyer_email VARCHAR(255),
  amount DECIMAL(10,2),
  sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  gumroad_id VARCHAR(255) UNIQUE
);

CREATE TABLE p2_client_revenue (
  id SERIAL PRIMARY KEY,
  client_name VARCHAR(255),
  monthly_retainer DECIMAL(10,2),
  status VARCHAR(50),
  start_date DATE
);

CREATE TABLE p3_affiliate_revenue (
  id SERIAL PRIMARY KEY,
  site_name VARCHAR(255),
  commission_amount DECIMAL(10,2),
  revenue_date DATE
);

CREATE TABLE daily_revenue_summary (
  date DATE PRIMARY KEY,
  p1_revenue DECIMAL(10,2) DEFAULT 0,
  p2_revenue DECIMAL(10,2) DEFAULT 0,
  p3_revenue DECIMAL(10,2) DEFAULT 0,
  total_revenue DECIMAL(10,2) DEFAULT 0
);

# Step 3: Test with sample data
INSERT INTO p1_gumroad_sales (product_name, buyer_email, amount, sale_date)
VALUES ('Test Product', 'test@example.com', 37.00, NOW());

INSERT INTO daily_revenue_summary (date, p1_revenue, total_revenue)
VALUES (CURRENT_DATE, 37.00, 37.00);

# Step 4: Verify it works
SELECT * FROM daily_revenue_summary;
# Expected: Shows today's date with $37 revenue
```

**Deliverable:** PostgreSQL connection string ready for CFO + webhook receiver

**Test:** Run this query daily to verify data is flowing
```sql
SELECT date, p1_revenue, p2_revenue, p3_revenue, total_revenue
FROM daily_revenue_summary
ORDER BY date DESC LIMIT 7;
```

**Post to standup: 8:25 PM** with connection string + test query result

---

## DELIVERABLE #2: Gumroad Webhook Receiver (8:25–8:35 PM)
**Output Status:** ✅ DEPLOYED & LOGGING SALES

Deploy working webhook that auto-logs sales without manual entry:

```javascript
// gumroad-webhook.js — Deploy to Railway, Heroku, or Vercel
// This webhook auto-logs every Gumroad sale to PostgreSQL

const express = require('express');
const { Pool } = require('pg');
const app = express();

app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Gumroad sends POST to this endpoint when someone buys
app.post('/webhooks/gumroad', async (req, res) => {
  try {
    const { id, email, product_name, price } = req.body;

    // Log to sales table
    await pool.query(
      `INSERT INTO p1_gumroad_sales (product_name, buyer_email, amount, gumroad_id)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (gumroad_id) DO NOTHING`,
      [product_name, email, parseFloat(price), id]
    );

    // Update daily summary
    const today = new Date().toISOString().split('T')[0];
    await pool.query(
      `INSERT INTO daily_revenue_summary (date, p1_revenue, total_revenue)
       VALUES ($1, $2, $2)
       ON CONFLICT (date) DO UPDATE
       SET p1_revenue = p1_revenue + $2, total_revenue = total_revenue + $2`,
      [today, parseFloat(price)]
    );

    console.log(`✅ Sale logged: ${product_name} - $${price}`);
    res.status(200).json({ success: true });
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Test endpoint (verify webhook is running)
app.get('/health', (req, res) => {
  res.json({ status: 'webhook receiver running' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Gumroad webhook receiver running on port ${PORT}`);
});
```

**Deployment Steps:**
1. Deploy to Railway/Heroku (copy code, set DATABASE_URL env var, deploy)
2. Get webhook URL (e.g., https://makinmoves-webhook.railway.app)
3. Add webhook in Gumroad: Settings → Webhooks → Add → https://makinmoves-webhook.railway.app/webhooks/gumroad
4. Test: Make a test purchase on Gumroad, verify sale appears in database

**Test Webhook:**
```bash
curl -X POST https://makinmoves-webhook.railway.app/health
# Expected: {"status":"webhook receiver running"}
```

**Post to standup: 8:35 PM** with webhook URL + confirmation that Gumroad webhook added

---

## DELIVERABLE #3: CFO Dashboard (Connected & Live) (8:35–8:50 PM)
**Output Status:** ✅ CONNECTED & AUTO-UPDATING

Create Google Sheets dashboard connected to PostgreSQL database:

```
# Create new Google Sheet called "MakinMoves Financial Dashboard"

SHEET 1: Daily Revenue (Auto-updates every 30 min)

Cell A1: =QUERY(IMPORTDATA("https://makinmoves-webhook.railway.app/api/daily-revenue"), "SELECT * ORDER BY date DESC LIMIT 30")

Expected output:
Date      | P1_Revenue | P2_Revenue | P3_Revenue | Total_Revenue
2026-03-30|    $37     |    $0      |    $0      |    $37
2026-03-31|    $74     |    $0      |    $0      |    $74
...

SHEET 2: Daily Profit Summary

Today's Revenue:  =FILTER(Daily Revenue, date=TODAY())
Today's Costs:    $5 (manual entry or auto-calculated)
Today's Profit:   =TODAY_REVENUE - TODAY_COSTS
Cumulative Rev:   =SUMIF(Daily Revenue, date<=TODAY())
Burn Rate:        $150/month (from forecast)
Runway:           =(Cumulative Rev / Burn Rate) months

SHEET 3: KPI Status

Metric              | Target | Actual | Status
P1 Conversion       | >2%    | [auto] | 🔴
P1 Daily Revenue    | >$50   | [auto] | 🔴
P2 New Leads        | >2     | [manual] | 🔴
P2 CAC             | <$500  | [calc] | TBD
P3 Traffic         | >500   | [manual] | 🔴
```

**Setup Steps:**
1. Create Google Sheet "MakinMoves Financial Dashboard"
2. Share with CFO (edit access)
3. Connect to database (either IMPORTDATA formula above, or CFO manually updates daily)
4. Set up conditional formatting (red when off target, green when on)

**Fallback (if IMPORTDATA doesn't work):**
CFO manually copies daily revenue from database query each morning (30 sec task)

**Post to standup: 8:50 PM** with Google Sheets link + screenshot of connected data

---

## DELIVERABLE #4: Infrastructure Runbook (8:50–9:00 PM)
**Output Status:** ✅ DOCUMENTED & REFERENCEABLE

Create troubleshooting guide so CFO (or anyone) can operate without CTMO:

```markdown
# MakinMoves Infrastructure Runbook
## What You're Running & How to Fix It When It Breaks

### Systems Overview
- **Database:** PostgreSQL on Railway
  Connection: [connection-string-here]

- **Webhook Receiver:** Node.js on Railway
  URL: https://makinmoves-webhook.railway.app
  Logs: Railway dashboard → Logs

- **CFO Dashboard:** Google Sheets
  URL: [sheets-link-here]
  Updates: Every 30 minutes (or manual refresh)

### Daily Health Check (takes 2 minutes)

Every morning, CFO runs:
```sql
SELECT
  date,
  p1_revenue,
  p2_revenue,
  p3_revenue,
  total_revenue
FROM daily_revenue_summary
ORDER BY date DESC LIMIT 1;
```

If no data for today: Webhook might be down. Go to step 2.

### Weekly Health Check (takes 5 minutes)

Monday morning, CTMO or CFO runs:

1. **Database is responding:**
   ```
   psql [connection-string] -c "SELECT 1;"
   ```
   Expected: `1` (if error: database is down, contact Railway)

2. **Webhook receiver is running:**
   ```
   curl https://makinmoves-webhook.railway.app/health
   ```
   Expected: `{"status":"webhook receiver running"}`
   If error: Deploy failed, redeploy to Railway

3. **Sales are being logged:**
   ```
   SELECT COUNT(*) FROM p1_gumroad_sales;
   ```
   Expected: >0 after first sale
   If 0: Gumroad webhook not configured (see Gumroad settings)

4. **Dashboard is updating:**
   Open Google Sheet, check if today's date has revenue
   If blank: Manual entry needed (CFO does this, or webhook down)

### Troubleshooting

**Problem:** Dashboard shows no revenue for today, but Gumroad shows sales
**Solution:**
1. Check webhook logs: Railway → Logs → search "error"
2. Check database: Run query above, does data exist?
3. If data exists but sheet is blank: Refresh sheet (Cmd+Shift+F9)

**Problem:** Webhook error when I test it
**Solution:**
1. Check DATABASE_URL is set in Railway environment
2. Restart webhook: Railway → Webhook Receiver → Restart
3. Check Gumroad webhook is pointing to correct URL

**Problem:** Database connection timeout
**Solution:**
1. Check Railway status: railway.app/status
2. Check firewall isn't blocking (unlikely, but possible)
3. Restart database: Railway → Database → Restart

**Problem:** "Permission denied" when accessing database
**Solution:**
1. Check DATABASE_URL is correct (copy from Railway)
2. Check password doesn't have special characters (need to URL-encode)
3. Create new connection string in Railway and try again

### Backup Procedure

**Daily:** Google Sheets auto-backs up in Drive

**Weekly:** Export database backup from Railway
```bash
pg_dump [connection-string] > backup-$(date +%Y-%m-%d).sql
```
Store in Drive folder

**To restore:** Contact Railway support or run:
```bash
psql [connection-string] < backup-YYYY-MM-DD.sql
```

### Escalation

If you can't fix it in 10 minutes:
1. Screenshot the error
2. Note what you tried
3. Message CTMO with screenshot + what you tried
4. Don't delete anything, don't restart manually — wait for CTMO response

### Cost Status

Current spend: $15/month (Railway PostgreSQL + Node.js)
Scaling trigger: If >100k records or >1000 API calls/day, upgrade to $30/month
Contact: [CTMO email]
```

**Deliverable:** Markdown file CFO references when something breaks

**Post to standup: 9:00 PM** with link to runbook

---

## SUMMARY

| Deliverable | Type | Status | Ready to Use? |
|-------------|------|--------|---------------|
| 1. PostgreSQL Database | Live System | ✅ DEPLOYED | Query-ready |
| 2. Gumroad Webhook | Node.js API | ✅ DEPLOYED | Auto-logging sales |
| 3. CFO Dashboard | Google Sheets | ✅ CONNECTED | Live data flowing |
| 4. Runbook | Documentation | ✅ WRITTEN | Troubleshoot independently |

**All 4 systems are operational by 9:00 PM.** CFO can open dashboard, see live revenue numbers. No manual data entry. No bottleneck on CTMO.

---

## SUCCESS CRITERIA

✅ Database is **live and queries work** (CFO tests with sample query)
✅ Webhook is **deployed and logging sales** (test purchase appears in database)
✅ Dashboard is **connected and auto-updating** (CFO opens, sees numbers)
✅ Runbook is **detailed enough for CFO to troubleshoot alone**

**CTMO owns working infrastructure that eliminates manual data entry and enables real-time optimization.**
