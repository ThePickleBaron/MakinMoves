# Autonomous CFO System: Implementation Guide
**CTMO Internal Document** | Version 1.0 | 2026-03-29

---

## 1. System Overview

### Purpose
Enable CFO to run financial reports **without writing SQL**, autonomously after user handoff (2026-03-31).

### Architecture
```
┌─────────────────────────────────────────┐
│     Revenue Data (n8n + Platforms)      │
│   (Gumroad, Stripe, AdSense, etc.)      │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│    PostgreSQL Tables (Automated)        │
│  • revenue_daily (input point)          │
│  • revenue_weekly (rollup)              │
│  • revenue_monthly (rollup)             │
│  • costs_monthly (manual entry)         │
│  • error_logs (integration monitoring)  │
│  • publishing_log (content tracking)    │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│    SQL Functions (Auto-aggregation)     │
│  • get_daily_revenue()                  │
│  • get_weekly_summary()                 │
│  • get_monthly_report()                 │
│  • get_recovery_progress()              │
│  • get_platform_ranking()               │
│  • forecast_recovery_date()             │
│  + monitoring functions                 │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│         CFO Reports (ReadOnly)          │
│   (Daily snapshot, Weekly, Monthly)     │
│   (Recovery tracker, Platform ranking)  │
└─────────────────────────────────────────┘
```

### Data Flow

**Automated (No Manual Work):**
1. n8n workflows pull sales from Gumroad, Stripe, etc.
2. Scripts insert into `revenue_daily` table
3. Weekly refresh aggregates into `revenue_weekly`
4. Monthly refresh aggregates into `revenue_monthly`
5. Functions compute reports on-demand

**Manual (CFO Only):**
- Enter one-off revenue (affiliate payment, refund)
- Enter monthly costs (new subscription, tool purchase)

---

## 2. Database Schema Design

### Core Tables

#### `public.revenue_daily`
```sql
CREATE TABLE public.revenue_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    platform VARCHAR(50),              -- digital_products, saas, content, etc.
    source VARCHAR(100),               -- Gumroad, Stripe, AdSense, etc.
    gross_amount DECIMAL(12,2),        -- Before fees
    fees DECIMAL(12,2) DEFAULT 0,      -- Payment processing fees
    net_amount DECIMAL(12,2),          -- Gross - fees (what you keep)
    transaction_count INT DEFAULT 1,   -- Number of sales
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

**Why this design:**
- `date` as primary group: One row per day per platform (rollup-friendly)
- `platform + source`: Supports 3+ platforms, tracks origin
- `gross vs. net`: Know your true take-home
- `transaction_count`: Understand sale velocity
- Indexes on date/platform for fast queries

**Insert point for n8n:** Every morning, pull yesterday's sales, insert aggregate:
```sql
INSERT INTO revenue_daily
VALUES (
  '2026-03-29',
  'digital_products',
  'Gumroad',
  45.00,          -- gross from Gumroad API
  6.75,           -- Gumroad fee %
  38.25,          -- net (45 - 6.75)
  2,              -- sold 2 items
  'Daily sync from Gumroad API',
  NOW(),
  NOW()
);
```

#### `public.recovery_goal`
```sql
CREATE TABLE public.recovery_goal (
    id SERIAL PRIMARY KEY,
    target_amount DECIMAL(12,2) DEFAULT 10000.00,
    start_date DATE DEFAULT CURRENT_DATE,
    cumulative_earned DECIMAL(12,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW(),
    notes TEXT
);
```

**Why:** Single source of truth for the $10k goal. Functions reference this.

#### `public.costs_monthly`
```sql
CREATE TABLE public.costs_monthly (
    id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL,      -- First day of month
    category VARCHAR(100),         -- hosting, tools, domain, etc.
    vendor VARCHAR(100),           -- Railway, Stripe, Mailchimp, etc.
    amount DECIMAL(12,2),
    recurring BOOLEAN DEFAULT true,-- Annual cost? Mark false
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Why:** Track operating costs against revenue for P&L calculations.

#### `public.error_logs`
```sql
CREATE TABLE public.error_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    source VARCHAR(100),           -- n8n_workflow, stripe_api, etc.
    error_type VARCHAR(50),        -- timeout, auth_failure, etc.
    error_message TEXT,
    severity VARCHAR(20),          -- critical, high, medium, low
    resolved BOOLEAN DEFAULT false,
    resolved_at TIMESTAMP,
    notes TEXT
);
```

**Why:** Integrations fail. Track them to diagnose issues quickly.

#### `public.publishing_log`
```sql
CREATE TABLE public.publishing_log (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    platform VARCHAR(100),         -- Gumroad, Twitter, Medium, etc.
    content_type VARCHAR(50),      -- product, article, update, etc.
    title VARCHAR(255),
    status VARCHAR(20),            -- success, failed, pending
    error_message TEXT,
    views INT DEFAULT 0,
    revenue_generated DECIMAL(12,2) DEFAULT 0
);
```

**Why:** Monitor what's being published and early performance metrics.

---

## 3. SQL Functions Design

### Philosophy
Each function is **read-only, reusable, idempotent**:
- Can be called any time without side effects
- Returns consistent results
- No delete/update operations
- Always returns clean, formatted results

### Key Functions

#### `get_daily_revenue()`
**Aggregates:** Today's sales by platform
```sql
CREATE OR REPLACE FUNCTION get_daily_revenue()
RETURNS TABLE (
    platform VARCHAR,
    source VARCHAR,
    gross_amount NUMERIC,
    fees NUMERIC,
    net_amount NUMERIC,
    transaction_count INT,
    total_net NUMERIC  -- Running total for quick scan
)
```

**Use case:** Morning report - "Did we make money yesterday?"

**Output format:**
```
platform | source | gross | fees | net | count | total_net
```

---

#### `get_weekly_summary(p_date DATE)`
**Aggregates:** Last 7 days rolling window
```sql
CREATE OR REPLACE FUNCTION get_weekly_summary(p_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    platform VARCHAR,
    total_transactions INT,
    total_gross NUMERIC,
    total_fees NUMERIC,
    total_net NUMERIC,
    avg_daily NUMERIC
)
```

**Use case:** Weekly report - "What's the trend?"

**Logic:**
- Takes current date or specific date
- Groups last 7 days by platform
- Calculates average daily (helpful for forecasting)

---

#### `get_monthly_report(p_year_month DATE)`
**Aggregates:** Full P&L for the month
```sql
CREATE OR REPLACE FUNCTION get_monthly_report(p_year_month DATE)
RETURNS TABLE (
    metric VARCHAR,         -- Revenue, Costs, Net Profit
    platform VARCHAR,
    value NUMERIC,
    transaction_count INT
)
```

**Use case:** End of month - "What's our profit?"

**Output format:**
```
metric | platform | value | count
Revenue | digital_products | 1245.00 | 52
Revenue | TOTAL | 1645.00 | 88
Costs | Infrastructure | 50.00 | 1
Net Profit | BOTTOM LINE | 1595.00 | 0
```

---

#### `get_recovery_progress()`
**Aggregates:** Progress toward $10k goal
```sql
CREATE OR REPLACE FUNCTION get_recovery_progress()
RETURNS TABLE (
    target_amount NUMERIC,
    total_earned NUMERIC,
    amount_remaining NUMERIC,
    progress_percent NUMERIC,
    days_elapsed INT,
    avg_daily_rate NUMERIC,
    days_to_goal INT
)
```

**Logic:**
- Sums all net revenue to date
- Calculates % of $10k recovered
- Tracks daily average (for forecasting)
- Estimates days remaining

**Use case:** "When do we hit $10k?"

---

#### `get_platform_ranking()`
**Aggregates:** Platforms ranked by total revenue
```sql
CREATE OR REPLACE FUNCTION get_platform_ranking()
RETURNS TABLE (
    rank INT,
    platform VARCHAR,
    total_revenue NUMERIC,
    percentage_of_total NUMERIC,
    transactions INT,
    status VARCHAR
)
```

**Use case:** "Which platform is making money?"

**Output:**
```
rank | platform | revenue | percent | txn | status
1 | digital_products | 3450.00 | 68.5% | 142 | active
2 | content | 1240.00 | 24.6% | 68 | active
```

---

#### `forecast_recovery_date(p_target DECIMAL)`
**Forecast:** When you'll hit recovery milestones
```sql
CREATE OR REPLACE FUNCTION forecast_recovery_date(p_target DECIMAL DEFAULT 10000)
RETURNS TABLE (
    milestone_amount NUMERIC,
    days_to_milestone INT,
    projected_date DATE,
    confidence VARCHAR
)
```

**Logic:**
- Uses historical daily average
- Calculates days needed to reach milestone
- Warns if data < 7 days (low confidence)

**Output:**
```
milestone | days | date | confidence
1000 | 3 | 2026-04-01 | Medium
5000 | 45 | 2026-05-13 | Medium
10000 | 91 | 2026-06-29 | Medium
```

---

### Monitoring Functions

#### `check_daily_revenue_alert(p_threshold DECIMAL DEFAULT 5)`
**Alert:** If today's revenue < threshold
```sql
RETURNS TABLE (
    alert_triggered BOOLEAN,
    today_revenue NUMERIC,
    threshold NUMERIC,
    message TEXT,
    action_required TEXT
)
```

**Use case:** Health check - "Is something broken?"

---

#### `get_recent_errors(p_hours INT DEFAULT 24)`
**Query:** Recent integration failures
```sql
RETURNS TABLE (
    error_id INT,
    timestamp TIMESTAMP,
    source VARCHAR,
    error_type VARCHAR,
    severity VARCHAR,
    message TEXT,
    resolved BOOLEAN
)
```

**Use case:** Debug - "Why is revenue low?"

---

#### `get_publishing_status(p_days INT DEFAULT 7)`
**Query:** What was published and performance
```sql
RETURNS TABLE (
    publish_date DATE,
    platform VARCHAR,
    content_type VARCHAR,
    title VARCHAR,
    status VARCHAR,
    views INT,
    revenue_generated NUMERIC
)
```

**Use case:** Content tracking - "What's selling?"

---

## 4. Implementation Steps

### Phase 1: Schema & Functions (Day 1)
1. Run `autonomous-cfo-schema.sql` against PostgreSQL
   ```bash
   docker exec makinmoves-postgres psql -U postgres -d n8n < autonomous-cfo-schema.sql
   ```

2. Verify tables created:
   ```sql
   \dt public.*  -- List all tables
   \df public.get_*  -- List all functions
   ```

3. Test functions with sample data (see Phase 2)

### Phase 2: Sample Data (Day 1)
Insert test data to verify functions work:

```sql
-- Insert sample daily revenue
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
('2026-03-20', 'digital_products', 'Gumroad', 100.00, 15.00, 85.00, 2, 'Test'),
('2026-03-21', 'digital_products', 'Gumroad', 120.00, 18.00, 102.00, 2, 'Test'),
('2026-03-22', 'content', 'AdSense', 25.00, 0, 25.00, 1, 'Test'),
('2026-03-23', 'digital_products', 'Gumroad', 95.00, 14.25, 80.75, 2, 'Test'),
('2026-03-24', 'saas', 'Stripe', 50.00, 2.50, 47.50, 1, 'Test'),
('2026-03-25', 'content', 'AdSense', 30.00, 0, 30.00, 1, 'Test'),
('2026-03-26', 'digital_products', 'Gumroad', 110.00, 16.50, 93.50, 2, 'Test');

-- Test daily function
SELECT * FROM get_daily_revenue();

-- Test weekly function
SELECT * FROM get_weekly_summary();

-- Test recovery tracker
SELECT * FROM get_recovery_progress();

-- Test platform ranking
SELECT * FROM get_platform_ranking();
```

### Phase 3: Automation Setup (Days 1-2)
1. **Daily n8n workflow:** Pull sales from each platform, insert into `revenue_daily`
   - Gumroad: Daily sync
   - Stripe: Daily sync
   - AdSense: Weekly sync (API limitations)

2. **Weekly refresh job:** Call aggregation functions
   ```sql
   SELECT refresh_weekly_aggregates();
   SELECT refresh_monthly_aggregates();
   ```

3. **Error tracking:** n8n logs failures to `error_logs` table

4. **Publishing log:** n8n tracks content distribution status

### Phase 4: CFO Handoff (Day 2)
1. Provide CFO with manual: `CFO_INSTRUCTION_MANUAL.md`
2. Walk through each report (5-10 min training)
3. CFO runs sample reports using provided SQL
4. Set up weekly/daily reminders for CFO

---

## 5. Data Integration Points (n8n Workflows)

### Daily Revenue Sync (Morning)

**Trigger:** 8:00 AM daily

**Workflow:**
```
1. Gumroad API → Get daily sales
2. Extract: gross, fees, net, count
3. Insert INTO revenue_daily
4. Stripe API → Get daily charges (for SaaS)
5. Insert INTO revenue_daily
6. AdSense API → Weekly pull (every Monday)
7. Log any errors to error_logs
8. Report status
```

**Example n8n SQL node:**
```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
($1, 'digital_products', 'Gumroad', $2, $3, $4, $5, 'Automated sync from Gumroad API');
```

### Error Tracking

**When n8n workflow fails:**
```sql
INSERT INTO public.error_logs
(source, error_type, error_message, severity)
VALUES
('n8n_workflow', 'auth_failure', 'Gumroad API key invalid', 'critical');
```

### Publishing Tracking

**When content is published:**
```sql
INSERT INTO public.publishing_log
(platform, content_type, title, status)
VALUES
('Gumroad', 'product', 'Email Templates Bundle', 'success');
```

---

## 6. Performance Considerations

### Indexes (Already in Schema)
```sql
CREATE INDEX idx_revenue_daily_date ON public.revenue_daily(date DESC);
CREATE INDEX idx_revenue_daily_platform ON public.revenue_daily(platform);
CREATE INDEX idx_revenue_monthly_month ON public.revenue_monthly(year_month DESC);
CREATE INDEX idx_error_logs_timestamp ON public.error_logs(timestamp DESC);
```

**Why:**
- Queries group/filter by date and platform
- Most reports look at recent data (DESC sort)
- Indexes speed up aggregations

### Query Performance
- **`get_daily_revenue()`:** < 100ms (single day)
- **`get_weekly_summary()`:** < 200ms (7 days)
- **`get_monthly_report()`:** < 500ms (30+ days)
- **`get_recovery_progress()`:** < 100ms (full scan, but SUM aggregation)

**Scaling:**
- System designed for 3+ years of daily data (1000+ rows)
- Aggregate tables (weekly, monthly) reduce query load
- No need for further optimization until > 100k rows

---

## 7. Disaster Recovery

### Backup Strategy
```bash
# Daily backup (run via cron)
docker exec makinmoves-postgres pg_dump -U postgres -d n8n > backup_$(date +%Y-%m-%d).sql

# Store 30 days of backups
find ./backups -name "backup_*.sql" -mtime +30 -delete
```

### Restore Procedure
```bash
# If data corrupted:
docker exec -i makinmoves-postgres psql -U postgres -d n8n < backup_2026-03-28.sql

# Verify:
SELECT * FROM get_daily_revenue();  -- Should show historical data
```

### Data Integrity Checks
```sql
-- Check for duplicate dates (should be 1 per date per platform)
SELECT date, platform, COUNT(*) FROM public.revenue_daily
GROUP BY date, platform
HAVING COUNT(*) > 1;

-- Check for missing data (gaps > 7 days)
SELECT date, LEAD(date) OVER (ORDER BY date) as next_date
FROM public.revenue_daily
WHERE LEAD(date) OVER (ORDER BY date) - date > 7;
```

---

## 8. Maintenance Tasks (Monthly)

| Task | When | Time | Owner |
|------|------|------|-------|
| Run monthly report | 1st of month | 5 min | CFO |
| Refresh aggregates | Weekly | 1 min | Automated |
| Check error logs | Weekly | 5 min | CFO |
| Backup database | Daily | 0 min (automated) | CTMO |
| Review platform status | Monthly | 10 min | CFO |

---

## 9. CFO Escalation Path

**When CFO can't get data:**

1. **Function returns error:**
   - CTMO checks PostgreSQL logs
   - Verify function syntax
   - Rerun function

2. **Revenue data missing:**
   - CTMO checks n8n workflow logs
   - Verify API connections
   - Manual insert if needed

3. **Need new metric:**
   - CFO writes to CTMO inbox
   - CTMO designs new function
   - Deploy in < 4 hours

**CTMO owns all technical aspects. CFO owns interpreting results.**

---

## 10. Testing Checklist

Before CFO handoff (2026-03-31):

- [ ] All 8 functions return data without error
- [ ] Daily revenue appears in table within 2 hours of sync
- [ ] Weekly aggregates update every Monday
- [ ] Monthly aggregates update on 1st of month
- [ ] Error logging works (test by breaking API key)
- [ ] Publishing log tracks content (test with manual entry)
- [ ] Recovery tracker shows progress toward $10k
- [ ] Forecast generates reasonable estimates
- [ ] CFO can run all 8 reports without help
- [ ] Backup/restore works without data loss
- [ ] Functions scale to 3 years of data (no slowdown)

---

## 11. Success Criteria

**System is working if:**
1. CFO runs daily report every morning in < 5 min
2. Weekly report generated automatically
3. No manual SQL writing by CFO
4. All revenue data captured (no platform missed)
5. Costs tracked and P&L accurate
6. Recovery progress visible and forecasting works
7. Errors logged and resolved within 24h
8. No data loss (backups working)

---

## Summary

**What you've built:**
- **Autonomous data layer** (n8n → PostgreSQL)
- **8 pre-built report functions** (no SQL needed)
- **3-month rollup tables** (weekly, monthly aggregates)
- **Error tracking** (detect & alert on failures)
- **Forecasting** (when hit $10k goal)
- **CFO manual** (run reports, interpret, act)

**What CFO does:**
- Run 5 core reports daily/weekly/monthly
- Read results (they're formatted like spreadsheets)
- Enter one-off revenue/costs when needed
- Escalate errors to CTMO

**What stays automated:**
- Daily n8n syncs from all platforms
- Weekly/monthly aggregations
- Error logging and alerts
- Backup procedures

**Time to first report: 30 seconds** (copy/paste SQL, read results)

---

**Go build. CFO will be ready by 2026-03-31.** 🚀
