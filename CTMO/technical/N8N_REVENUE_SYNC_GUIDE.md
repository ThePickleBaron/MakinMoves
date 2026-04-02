# n8n Revenue Sync Workflows
**CTMO Guide: Automating Daily Revenue Capture**

---

## Overview

All revenue data flows automatically from platforms into PostgreSQL `revenue_daily` table via n8n workflows.

**CFO never enters raw transaction data.** n8n does it automatically.

**CFO only enters:**
- One-off payments (affiliate bonuses, refunds)
- Monthly costs

---

## Architecture

```
Gumroad API
    ↓
n8n Workflow (Daily 8 AM)
    ↓
PostgreSQL revenue_daily table
    ↓
CFO reports (get_daily_revenue(), etc.)
```

Each platform gets one daily workflow that runs at 8 AM UTC.

---

## Workflow 1: Gumroad Daily Sync

### Purpose
Pull yesterday's Gumroad sales, aggregate, insert into PostgreSQL.

### Setup

**Trigger:** Schedule (Daily 8:00 AM UTC)

**Node 1: Get Gumroad Sales (Yesterday)**
```javascript
// HTTP Request node
Method: GET
URL: https://api.gumroad.com/v2/sales

Headers:
  Authorization: Bearer YOUR_GUMROAD_API_KEY

Query Parameters:
  before: {{ yesterday_date }}
  after: {{ yesterday_date + 1 day }}
```

**Node 2: Extract & Aggregate**
```javascript
// Function node (JavaScript)
const sales = input[0].json.sales;

// Group by product, sum amounts
const aggregated = {
  platform: 'digital_products',
  source: 'Gumroad',
  date: new Date().toISOString().split('T')[0],
  gross_amount: sales.reduce((sum, s) => sum + (s.price * s.quantity), 0),
  transaction_count: sales.length,
  fees: 0  // Gumroad fee percentage (calculate if available)
};

// Calculate net
aggregated.net_amount = aggregated.gross_amount - aggregated.fees;

return [{ json: aggregated }];
```

**Node 3: Insert into PostgreSQL**
```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
(
  '{{ $node.json.date }}',
  '{{ $node.json.platform }}',
  '{{ $node.json.source }}',
  {{ $node.json.gross_amount }},
  {{ $node.json.fees }},
  {{ $node.json.net_amount }},
  {{ $node.json.transaction_count }},
  'Automated sync from Gumroad API'
)
```

**Error Handling:**
```javascript
// If workflow fails, log to error_logs table
INSERT INTO public.error_logs
(source, error_type, error_message, severity)
VALUES
(
  'n8n_workflow',
  'timeout',  // or 'auth_failure', etc.
  '{{ $node.error.message }}',
  'high'
)
```

---

## Workflow 2: Stripe Daily Sync (SaaS Revenue)

### Purpose
Pull Stripe charges from yesterday, insert as SaaS revenue.

### Setup

**Trigger:** Schedule (Daily 8:30 AM UTC) - *Offset 30 min after Gumroad*

**Node 1: Get Stripe Charges**
```javascript
// Stripe node
Account: YOUR_STRIPE_ACCOUNT
Method: List charges

Filters:
  created: {{ yesterday_start }} to {{ yesterday_end }}
  limit: 100
```

**Node 2: Process Stripe Charges**
```javascript
// Function node
const charges = input[0].json.data;

const aggregated = {
  platform: 'saas',
  source: 'Stripe',
  date: new Date().toISOString().split('T')[0],
  gross_amount: charges.reduce((sum, c) => sum + (c.amount / 100), 0),  // Stripe in cents
  fees: charges.reduce((sum, c) => sum + (c.amount * 0.029 / 100 + 0.30), 0),  // 2.9% + $0.30 per
  transaction_count: charges.length
};

aggregated.net_amount = aggregated.gross_amount - aggregated.fees;

return [{ json: aggregated }];
```

**Node 3: Insert into PostgreSQL**
```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
(
  '{{ $node.json.date }}',
  '{{ $node.json.platform }}',
  '{{ $node.json.source }}',
  {{ $node.json.gross_amount }},
  {{ $node.json.fees }},
  {{ $node.json.net_amount }},
  {{ $node.json.transaction_count }},
  'Automated sync from Stripe API'
)
```

---

## Workflow 3: Google AdSense Weekly Sync (Content Revenue)

### Purpose
Pull AdSense earnings (weekly - API limitation), insert as content revenue.

### Setup

**Trigger:** Schedule (Every Monday 9:00 AM UTC) - *AdSense API only supports weekly*

**Node 1: Get AdSense Earnings**
```javascript
// Google AdSense API node
Method: Get account summary

Period: LAST_7_DAYS
Currency: USD
```

**Node 2: Process & Aggregate**
```javascript
// Function node
const earnings = input[0].json;

const aggregated = {
  platform: 'content',
  source: 'Google AdSense',
  date: new Date().toISOString().split('T')[0],
  gross_amount: earnings.earnings_usd || 0,
  fees: 0,  // AdSense takes cut server-side
  transaction_count: earnings.page_views || 0
};

aggregated.net_amount = aggregated.gross_amount;  // AdSense is already net

return [{ json: aggregated }];
```

**Node 3: Insert into PostgreSQL**
```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
(
  '{{ $node.json.date }}',
  '{{ $node.json.platform }}',
  '{{ $node.json.source }}',
  {{ $node.json.gross_amount }},
  {{ $node.json.fees }},
  {{ $node.json.net_amount }},
  {{ $node.json.transaction_count }},
  'Weekly sync from Google AdSense API'
)
```

---

## Workflow 4: Content Publishing Tracker

### Purpose
Log every article published (product, article, tweet) with initial performance.

### Setup

**Trigger:** Manual (or API webhook from publishing platform)

**Node 1: Accept Publishing Event**
```json
{
  "platform": "Gumroad",
  "content_type": "product",
  "title": "Email Templates Bundle",
  "timestamp": "2026-03-29T10:00:00Z",
  "status": "success"
}
```

**Node 2: Insert into Publishing Log**
```sql
INSERT INTO public.publishing_log
(platform, content_type, title, status, timestamp)
VALUES
(
  '{{ $node.json.platform }}',
  '{{ $node.json.content_type }}',
  '{{ $node.json.title }}',
  '{{ $node.json.status }}',
  '{{ $node.json.timestamp }}'
)
```

**Node 3: Set Reminder (Check Performance in 24h)**
```javascript
// Schedule node
Check back tomorrow to log views and revenue
```

---

## Workflow 5: Error Handling & Alerts

### Purpose
If any revenue sync fails, log it and alert CFO.

### Setup (Catch block in all workflows)

**Error Node:**
```sql
INSERT INTO public.error_logs
(source, error_type, error_message, severity, timestamp)
VALUES
(
  '{{ $node.source }}',
  '{{ $node.error.type }}',
  '{{ $node.error.message }}',
  CASE
    WHEN '{{ $node.error.message }}' LIKE '%auth%' THEN 'critical'
    WHEN '{{ $node.error.message }}' LIKE '%timeout%' THEN 'high'
    ELSE 'medium'
  END,
  NOW()
)
```

**Alert CFO (Slack/Email):**
```javascript
// Send message node
Channel: #financial-alerts
Message: ⚠️ Revenue sync failed: {{ $node.error.message }}
         Source: {{ $node.source }}
         Check database for details
```

---

## Workflow 6: Weekly Aggregation Refresh

### Purpose
Refresh weekly/monthly rollup tables (after all daily syncs complete).

### Setup

**Trigger:** Schedule (Daily 10:00 AM UTC) - *After all syncs done*

**Node 1: Refresh Weekly Aggregates**
```sql
SELECT refresh_weekly_aggregates();
```

**Node 2: Refresh Monthly Aggregates**
```sql
SELECT refresh_monthly_aggregates();
```

**Node 3: Log Success**
```sql
INSERT INTO public.report_runs
(report_type, run_timestamp, status, message)
VALUES
('aggregation', NOW(), 'success', 'Weekly and monthly aggregates refreshed')
```

---

## Workflow 7: Daily Health Check

### Purpose
Run daily at 9:30 AM to verify all syncs completed.

### Setup

**Trigger:** Schedule (Daily 9:30 AM UTC)

**Node 1: Check Today's Revenue**
```sql
SELECT COUNT(*) as record_count, SUM(net_amount) as total_revenue
FROM public.revenue_daily
WHERE date = CURRENT_DATE
```

**Node 2: Evaluate Health**
```javascript
// Function node
const records = input[0].json;

if (records.record_count === 0) {
  return {
    status: 'ALERT',
    message: 'No revenue recorded today. Check syncs.',
    action: 'Review error logs'
  };
} else if (records.total_revenue < 5) {
  return {
    status: 'WARNING',
    message: 'Below expected revenue.',
    action: 'Check error logs'
  };
} else {
  return {
    status: 'HEALTHY',
    message: `Today's revenue: $${records.total_revenue}`,
    action: 'None'
  };
}
```

**Node 3: Notify CFO (if alert)**
```javascript
if (input[0].json.status === 'ALERT') {
  // Send message to CFO
  // Post to Slack, send email, etc.
}
```

---

## Testing n8n Workflows

### Before Going Live

1. **Test Gumroad sync:**
   - Manually create test sale on Gumroad
   - Run workflow
   - Verify row inserted in PostgreSQL
   ```sql
   SELECT * FROM public.revenue_daily WHERE source = 'Gumroad' ORDER BY created_at DESC LIMIT 1;
   ```

2. **Test Stripe sync:**
   - Use Stripe test mode
   - Create test charge
   - Run workflow
   - Verify insert

3. **Test error handling:**
   - Deliberately break API key
   - Run workflow
   - Verify error logged in `error_logs`
   ```sql
   SELECT * FROM public.error_logs WHERE resolved = false ORDER BY timestamp DESC;
   ```

4. **Test full pipeline:**
   - Insert test data manually
   - Run aggregation workflow
   - Verify CFO can see data in reports
   ```sql
   SELECT * FROM get_daily_revenue();
   SELECT * FROM get_weekly_summary();
   ```

---

## Maintenance Checklist

| Task | Frequency | Who | Time |
|------|-----------|-----|------|
| Verify daily syncs ran | Daily morning | CFO | 2 min |
| Check error logs | Daily morning | CFO | 3 min |
| Test API keys (rotation) | Monthly | CTMO | 15 min |
| Review workflow logs | Weekly | CTMO | 10 min |
| Update fee percentages | Quarterly | CTMO | 5 min |

---

## Troubleshooting n8n Issues

### "Gumroad sync didn't run"
1. Check n8n execution history
2. Look for timeout or auth error
3. If auth error: Refresh Gumroad API key
4. Re-run workflow manually

### "Revenue showing $0 today"
1. Verify sync actually ran (check n8n logs)
2. If sync ran: Check if platform had sales
3. Query raw API manually
   ```bash
   curl -H "Authorization: Bearer API_KEY" https://api.gumroad.com/v2/sales
   ```

### "Double-counting revenue"
1. Check for duplicate dates in table
   ```sql
   SELECT date, platform, COUNT(*) as cnt FROM public.revenue_daily
   GROUP BY date, platform HAVING COUNT(*) > 1;
   ```
2. Delete duplicates (keep most recent)
   ```sql
   DELETE FROM public.revenue_daily
   WHERE id NOT IN (
     SELECT MAX(id) FROM public.revenue_daily
     GROUP BY date, platform
   );
   ```

### "API key expired"
1. Check error logs
2. Go to platform (Gumroad, Stripe, etc.)
3. Regenerate API key
4. Update n8n with new key
5. Test workflow

---

## API Key Management

### Gumroad
- Location: Gumroad → Dashboard → Settings → API Tokens
- Frequency: Annually (or if compromised)
- Scope: Read-only recommended

### Stripe
- Location: Stripe → Developers → API Keys
- Frequency: Every 6 months
- Scope: Read charges only

### Google AdSense
- Location: Google Cloud Console → APIs
- Frequency: Keep indefinitely (OAuth)
- Scope: AdSense Management API

---

## Scaling Considerations

### Current Setup (3 daily workflows)
- Gumroad: 1 request/day
- Stripe: 1 request/day
- AdSense: 1 request/week
- Total: **10 requests/week**

### Future Platforms
If adding new platform:
1. Create new n8n workflow
2. Schedule offset from others (avoid thundering herd)
3. Add error handling
4. Update CFO reporting functions
5. Test thoroughly before going live

---

## n8n Best Practices

1. **Always have error handling**
   - Catch block logs to `error_logs` table
   - Send alert notification

2. **Use ISO date formatting**
   - YYYY-MM-DD for date fields
   - ISO 8601 for timestamps

3. **Aggregate before inserting**
   - Don't insert transaction-level data
   - Aggregate to 1 row per day per platform

4. **Document data sources**
   - "notes" field includes workflow name
   - Makes debugging easier

5. **Test with yesterday's data**
   - Never assume current data available
   - Always query previous day
   - Avoids race conditions

---

## Monitoring & Alerts

**CFO checks each morning:**
1. Run: `SELECT * FROM check_daily_revenue_alert();`
2. If alert, check: `SELECT * FROM get_recent_errors(24);`
3. If critical error, escalate to CTMO

**CTMO weekly review:**
1. Check n8n workflow execution logs
2. Verify all 3 daily workflows completed
3. Check for any timeout/rate limit issues
4. Update API keys if approaching rotation date

---

## Summary

**n8n automates:**
- Daily sales pull from Gumroad (8 AM)
- Daily charge pull from Stripe (8:30 AM)
- Weekly earnings pull from AdSense (Mon 9 AM)
- Aggregates into `revenue_daily` table
- Logs errors to `error_logs` table
- Refreshes weekly/monthly rollups (10 AM)
- Health check (9:30 AM)

**CFO checks:**
- Daily revenue with: `SELECT * FROM get_daily_revenue();`
- Alerts with: `SELECT * FROM check_daily_revenue_alert();`
- Errors with: `SELECT * FROM get_recent_errors(24);`

**No manual data entry for transaction-level revenue.** All automated via n8n.

---

**Build once, run forever.** 🚀
