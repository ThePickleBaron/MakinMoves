# Trinity Database Integration with n8n

**Owner:** CTMO
**Date:** 2026-03-29
**Purpose:** Automate data sync from P1/P2/P3 to Trinity PostgreSQL schema
**Status:** Configuration template ready for n8n workflows

---

## Overview

Trinity schema requires data from three external sources. This guide shows how to configure n8n workflows to capture and sync data automatically.

```
┌─────────────────────────┐      ┌─────────────────────────┐      ┌─────────────────────────┐
│  Gumroad API            │      │  Freelance/Invoice      │      │  Affiliate Networks     │
│  (Webhook or Poll)      │      │  (Manual or Platform)   │      │  (Daily API Poll)       │
└──────────┬──────────────┘      └──────────┬──────────────┘      └──────────┬──────────────┘
           │                                │                                │
           ├────────────────────────────────┼────────────────────────────────┤
           │                                │                                │
           └────────────────┬────────────────┴────────────────────────────────┘
                            │
                    ┌───────▼───────┐
                    │   n8n (hub)   │
                    │  Orchestration│
                    └───────┬───────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
        ┌─────▼──────┐  ┌───▼────────┐  ┌▼──────────┐
        │ PostgreSQL │  │  Transform │  │ Daily     │
        │  Insert    │  │  & Dedupe  │  │ Aggregate │
        └────────────┘  └────────────┘  └───────────┘
              │
        ┌─────▼──────────────────┐
        │  Trinity Schema        │
        │  (gumroad_sales,       │
        │   freelance_invoices,  │
        │   affiliate_clicks)    │
        └────────────────────────┘
```

---

## P1: Gumroad Integration

### Setup: Gumroad API Token

1. Log into Gumroad
2. Settings → API token
3. Copy token, store in n8n as credential: `gumroad_api_token`

### Workflow: Sync Gumroad Sales

**Trigger:** Webhook (when sale occurs) OR Daily poll (2 AM UTC)

**Nodes:**

#### Node 1: Gumroad API Request
```json
{
  "node": "HTTP Request",
  "url": "https://api.gumroad.com/v2/products",
  "method": "GET",
  "authentication": "Bearer {{ $env.gumroad_api_token }}",
  "returns": [
    {
      "product_id": "product.id",
      "name": "product.name",
      "price": "product.price",
      "purchase_count": "product.sales_count"
    }
  ]
}
```

#### Node 2: Gumroad Sales Sync
```json
{
  "node": "HTTP Request",
  "url": "https://api.gumroad.com/v2/sales",
  "method": "GET",
  "authentication": "Bearer {{ $env.gumroad_api_token }}",
  "returns": [
    {
      "gumroad_transaction_id": "sale.id",
      "product_id": "sale.product_id",
      "customer_email": "sale.purchaser_email",
      "gross_amount": "sale.price",
      "gumroad_fee": "{{ item.price * 0.10 }}",
      "net_amount": "{{ item.price * 0.90 }}",
      "transaction_date": "sale.timestamp"
    }
  ]
}
```

#### Node 3: Upsert Gumroad Customers
```sql
INSERT INTO trinity.gumroad_customers (
    email, first_name, first_purchase_date, status
)
VALUES (
    $1, $2, $3, 'active'
)
ON CONFLICT (email) DO UPDATE SET
    purchase_count = purchase_count + 1,
    lifetime_value = lifetime_value + $4,
    last_purchase_date = NOW(),
    updated_at = NOW()
RETURNING customer_id;
```

**Parameters:**
- `$1`: customer_email (from Gumroad API)
- `$2`: purchaser_name (parse from API response)
- `$3`: NOW() (first purchase date)
- `$4`: net_amount (to add to lifetime_value)

#### Node 4: Insert Gumroad Sales
```sql
INSERT INTO trinity.gumroad_sales (
    gumroad_transaction_id,
    product_id,
    customer_id,
    gross_amount,
    gumroad_fee,
    net_amount,
    transaction_date
)
VALUES ($1, $2, $3, $4, $5, $6, $7)
ON CONFLICT (gumroad_transaction_id) DO NOTHING;
```

**Parameters:**
- `$1`: gumroad_transaction_id
- `$2`: product_id (lookup in gumroad_products table)
- `$3`: customer_id (from Node 3 result)
- `$4`: gross_amount
- `$5`: gumroad_fee
- `$6`: net_amount
- `$7`: transaction_date

#### Node 5: Update Daily Revenue
```sql
INSERT INTO trinity.daily_revenue (
    report_date, gumroad_gross, gumroad_net, total_gross, total_net
)
SELECT
    CURRENT_DATE,
    SUM(gross_amount),
    SUM(net_amount),
    SUM(gross_amount),
    SUM(net_amount)
FROM trinity.gumroad_sales
WHERE DATE(transaction_date) = CURRENT_DATE
ON CONFLICT (report_date) DO UPDATE SET
    gumroad_gross = EXCLUDED.gumroad_gross,
    gumroad_net = EXCLUDED.gumroad_net,
    updated_at = NOW();
```

#### Node 6: Error Handling
```json
{
  "node": "Log to File",
  "output": "{{ $error }}",
  "file": "/logs/gumroad-sync-{{ $today }}.log"
}
```

### n8n Workflow Code

Save as: `workflows/p1-gumroad-sync.json`

```yaml
{
  "name": "P1: Gumroad Sales Sync",
  "trigger": {
    "type": "webhook",
    "url": "https://n8n.local:5678/webhook/gumroad-sales",
    "description": "Webhook from Gumroad on new purchase"
  },
  "or": {
    "type": "schedule",
    "cron": "0 2 * * *",
    "description": "Daily at 2 AM UTC"
  },
  "nodes": [
    {
      "id": "gumroad_api",
      "type": "HTTP Request",
      "method": "GET",
      "url": "https://api.gumroad.com/v2/sales",
      "auth": "Bearer {{ credentials.gumroad_token }}"
    },
    {
      "id": "transform_sales",
      "type": "Function",
      "code": "
        return items.map(item => ({
          gumroad_transaction_id: item.id,
          customer_email: item.purchaser_email,
          gross_amount: item.price,
          gumroad_fee: item.price * 0.10,
          net_amount: item.price * 0.90,
          transaction_date: item.timestamp
        }));
      "
    },
    {
      "id": "upsert_customer",
      "type": "PostgreSQL",
      "query": "INSERT INTO trinity.gumroad_customers ... ON CONFLICT ...",
      "params": ["{{ item.customer_email }}", "{{ item.name }}", "NOW()", "{{ item.net_amount }}"]
    },
    {
      "id": "insert_sales",
      "type": "PostgreSQL",
      "query": "INSERT INTO trinity.gumroad_sales ... ON CONFLICT ...",
      "params": ["{{ item.gumroad_transaction_id }}", "...", "...", "..."]
    },
    {
      "id": "update_daily_revenue",
      "type": "PostgreSQL",
      "query": "INSERT INTO trinity.daily_revenue ... ON CONFLICT ..."
    },
    {
      "id": "error_handler",
      "type": "Log File",
      "file": "/logs/gumroad-sync.log"
    }
  ]
}
```

---

## P2: Freelance/Invoicing Integration

### Setup: Choose Integration Point

**Option A: Manual Entry (Simplest)**
- You create invoices in your invoice tool
- n8n monitors invoice folder/API
- Syncs to trinity.freelance_invoices

**Option B: n8n Form (Low-Tech)**
- Create n8n form for entering invoices
- n8n stores directly in database

**Option C: API Integration**
- Integrate with Stripe Billing, Wave, or Freshbooks
- Auto-sync invoices

**Recommended for Day 1:** Option B (manual form) + Option A (monitor folder)

### Workflow: Sync Freelance Invoices

**Trigger:** New file in /invoices/ folder OR Form submission

#### Node 1: Read Invoice File (if folder-based)
```json
{
  "node": "File Trigger",
  "path": "/path/to/invoices/",
  "pattern": "*.json"
}
```

#### Node 2: Parse Invoice Data
```javascript
{
  "prospect_name": "invoice.client.name",
  "prospect_email": "invoice.client.email",
  "invoice_number": "invoice.invoice_number",
  "amount": "invoice.amount",
  "invoice_date": "invoice.date_issued",
  "due_date": "invoice.due_date",
  "description": "invoice.description"
}
```

#### Node 3: Upsert Prospect
```sql
INSERT INTO trinity.freelance_prospects (
    name, email, inquiry_date, status
)
VALUES ($1, $2, NOW(), 'qualified')
ON CONFLICT (email) DO NOTHING
RETURNING prospect_id;
```

#### Node 4: Create Project (if new)
```sql
INSERT INTO trinity.freelance_projects (
    prospect_id, title, contract_value, start_date, status
)
VALUES ($1, $2, $3, NOW(), 'active')
ON CONFLICT DO NOTHING
RETURNING project_id;
```

#### Node 5: Insert Invoice
```sql
INSERT INTO trinity.freelance_invoices (
    project_id, invoice_number, amount, invoice_date, due_date, status
)
VALUES ($1, $2, $3, $4, $5, 'pending')
ON CONFLICT (invoice_number) DO NOTHING;
```

#### Node 6: Update Daily Revenue
```sql
INSERT INTO trinity.daily_revenue (
    report_date, freelance_gross, freelance_pending
)
SELECT
    CURRENT_DATE,
    SUM(CASE WHEN DATE(invoice_date) = CURRENT_DATE THEN amount ELSE 0 END),
    SUM(CASE WHEN paid_date IS NULL THEN amount ELSE 0 END)
FROM trinity.freelance_invoices
ON CONFLICT (report_date) DO UPDATE SET
    freelance_gross = EXCLUDED.freelance_gross,
    freelance_pending = EXCLUDED.freelance_pending;
```

### Manual Payment Recording

**Trigger:** You mark invoice as paid

```sql
UPDATE trinity.freelance_invoices
SET
    paid_date = NOW(),
    status = 'paid'
WHERE invoice_id = $1;

-- Update daily revenue
UPDATE trinity.daily_revenue
SET freelance_paid = freelance_paid + (
    SELECT amount FROM trinity.freelance_invoices WHERE invoice_id = $1
)
WHERE report_date = CURRENT_DATE;
```

---

## P3: Affiliate Integration

### Setup: Affiliate Network APIs

**Supported Networks:**
- Amazon Associates: API with daily earnings
- CJ Affiliate: Publisher API
- Shareasale: API access
- Rakuten: API
- Impact: API

### Workflow: Daily Affiliate Commission Sync

**Trigger:** Daily at 3 AM UTC (when networks update)

#### Node 1: Amazon Associates API
```json
{
  "node": "HTTP Request",
  "url": "https://api.amazon-oa.com/earnings",
  "method": "GET",
  "auth": "AWS4-HMAC-SHA256",
  "headers": {
    "Authorization": "AWS4-HMAC-SHA256 Credential={{ $env.aws_access_key }}/{{ $today }}/us-east-1/ProductAdvertisingAPI/aws4_request"
  },
  "returns": [
    {
      "date": "earnings_date",
      "commission": "amount",
      "advertiser": "product_name",
      "clicks": "clicks"
    }
  ]
}
```

#### Node 2: Transform Clicks to Commissions
```javascript
{
  return items.map(item => ({
    program_name: item.advertiser,
    click_timestamp: new Date(item.date),
    commission_earned: item.commission,
    conversion_status: item.commission > 0 ? 'commission_earned' : 'click'
  }));
}
```

#### Node 3: Lookup Program
```sql
SELECT program_id
FROM trinity.affiliate_programs
WHERE program_name ILIKE $1
  AND network_name = 'Amazon Associates'
LIMIT 1;
```

#### Node 4: Insert/Update Clicks
```sql
WITH click_data AS (
    SELECT $1::INT as program_id, $2::INT as site_id,
           $3::TIMESTAMP as click_timestamp, $4::DECIMAL as commission
)
INSERT INTO trinity.affiliate_clicks (
    program_id, site_id, click_timestamp, commission_earned,
    conversion_status, link_id, article_id
)
-- For affiliate networks, we track by program, not individual links
-- Create a synthetic link_id for aggregated commissions
VALUES ($1, $2, $3, $4, 'commission_earned', 0, 0)
ON CONFLICT DO NOTHING;
```

#### Node 5: Update Affiliate Summary
```sql
INSERT INTO trinity.daily_revenue (
    report_date, affiliate_commissions, affiliate_clicks
)
SELECT
    CURRENT_DATE,
    SUM(commission_earned),
    COUNT(*)
FROM trinity.affiliate_clicks
WHERE DATE(click_timestamp) = CURRENT_DATE
  AND conversion_status IN ('converted', 'commission_earned')
ON CONFLICT (report_date) DO UPDATE SET
    affiliate_commissions = EXCLUDED.affiliate_commissions,
    affiliate_clicks = EXCLUDED.affiliate_clicks;
```

### Multi-Network Loop

For multiple affiliate networks, use n8n's **Loop** node:

```yaml
networks:
  - name: "Amazon Associates"
    api_url: "https://api.amazon-oa.com/earnings"
    credential: "amazon_api_key"
  - name: "CJ Affiliate"
    api_url: "https://api.cj.com/commissions"
    credential: "cj_api_key"
  - name: "Shareasale"
    api_url: "https://api.shareasale.com/publisher"
    credential: "shareasale_key"

workflow:
  - trigger: "Schedule (daily 3 AM)"
  - node: "Loop: networks"
    - subnode: "HTTP Request to network"
    - subnode: "Transform response"
    - subnode: "Upsert affiliate_clicks"
  - node: "Update daily_revenue"
```

---

## Data Sync Schedule

| Stream | Source | Trigger | Frequency | Notes |
|--------|--------|---------|-----------|-------|
| **P1: Gumroad** | Gumroad API | Webhook + Daily Poll | Real-time + 2 AM UTC | Backfill last 24h daily |
| **P2: Freelance** | Invoice folder / Form | File trigger + Manual | As created | Mark paid manually |
| **P3: Affiliate** | Network APIs | Schedule | Daily 3 AM UTC | Some networks update daily |

---

## Error Handling & Retry Logic

All workflows include:

```json
{
  "error_handler": {
    "retry_count": 3,
    "retry_delay": 60,
    "on_error": {
      "log_to_file": "/logs/{{ $workflow }}-{{ $today }}.log",
      "notify": "email to ctmo@makinmoves.local",
      "table": "trinity.audit_log with error details"
    }
  }
}
```

### Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Duplicate sales | Network resends webhook | Use `ON CONFLICT ... DO NOTHING` |
| Missing customer data | Incomplete API response | Pre-populate with "Unknown" + manual update |
| Stale affiliate data | Network delays | Set S3 sync 24h after commission period |
| Rate limiting | Too many API calls | Use exponential backoff + cache |

---

## Testing Checklist

Before launch, test each workflow:

- [ ] **P1 Gumroad**
  - [ ] Webhook receives test sale
  - [ ] Customer inserted/updated correctly
  - [ ] Sales transaction recorded
  - [ ] Daily revenue updated

- [ ] **P2 Freelance**
  - [ ] Invoice file triggers sync
  - [ ] Prospect created
  - [ ] Project created
  - [ ] Invoice recorded with pending status
  - [ ] Mark as paid updates daily_revenue

- [ ] **P3 Affiliate**
  - [ ] API returns commission data
  - [ ] Clicks inserted
  - [ ] Commission aggregated correctly
  - [ ] Daily revenue updated

- [ ] **Error Handling**
  - [ ] Duplicate prevention works
  - [ ] Errors logged correctly
  - [ ] Retry logic engages
  - [ ] Email alerts sent

---

## Production Deployment

1. **Day 1 (March 31):**
   - [ ] Deploy P1 Gumroad workflow
   - [ ] Deploy P2 Freelance form
   - [ ] Deploy P3 Affiliate (with test API)
   - [ ] Run data integrity check

2. **Week 1:**
   - [ ] Monitor all workflows in n8n dashboard
   - [ ] Verify daily_revenue populated
   - [ ] Check for sync errors
   - [ ] Backfill historical data if available

3. **Week 2+:**
   - [ ] Enable production affiliate APIs
   - [ ] Monitor data quality
   - [ ] Optimize query performance
   - [ ] Brief CFO on autonomous reporting

---

## Dashboard Access

Once deployed, CFO accesses data via:

**Option A: Direct SQL** (via n8n PostgreSQL node)
```sql
SELECT * FROM trinity.daily_revenue ORDER BY report_date DESC LIMIT 30;
```

**Option B: REST API** (expose via n8n HTTP Response)
```javascript
GET /api/trinity/daily-revenue?days=30
GET /api/trinity/recovery-tracker
GET /api/trinity/monthly-summary?month=2026-03
```

**Option C: Dashboard** (Metabase, Superset, or custom UI)
- Pre-built queries for 5 critical metrics
- Auto-refresh every 1 hour
- Export to CSV/PDF

---

## Notes

- All workflows are idempotent (safe to run multiple times)
- Use `ON CONFLICT` clauses to prevent duplicate inserts
- Store all credentials in n8n's secure credential store
- Test with small data sets before enabling production APIs
- Monitor PostgreSQL connection pool (max 20 connections)

