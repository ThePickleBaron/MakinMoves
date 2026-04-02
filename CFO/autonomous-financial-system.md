# Autonomous Financial Tracking System — $10,000 Recovery Goal

**Setup Date:** 2026-03-29
**Target:** $10,000 total recovery (autonomous, hands-off after 2026-03-31)
**Database:** PostgreSQL (containerized in MakinMoves-portable)
**Automation:** n8n (hourly/daily/weekly cron jobs)

---

## PART 1: POSTGRESQL SCHEMA (OPTIMIZED FOR CFO)

### Core Tables

Existing schema is in `/MakinMoves-portable/docker/init-db.sql`. CFO additions below:

```sql
-- ════════════════════════════════════════════════════════════
-- RECOVERY TRACKING (CFO Dashboard Core)
-- ════════════════════════════════════════════════════════════

-- Recovery goal config (single row, updated by CEO)
CREATE TABLE public.recovery_goals (
    id SERIAL PRIMARY KEY,
    target_amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    goal_date DATE,                          -- Target completion date
    seed_budget DECIMAL(10,2),                -- One-time allocation
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Daily aggregated revenue (CFO queries this hourly)
CREATE TABLE public.daily_revenue (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    digital_products DECIMAL(10,2) DEFAULT 0,
    saas_mrr DECIMAL(10,2) DEFAULT 0,
    content DECIMAL(10,2) DEFAULT 0,
    trading_pnl DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    costs DECIMAL(10,2) DEFAULT 0,
    net DECIMAL(10,2) DEFAULT 0,
    cumulative_revenue DECIMAL(10,2) DEFAULT 0,
    recovery_pct DECIMAL(5,2) DEFAULT 0,    -- % of goal achieved
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Hourly revenue snapshot (for CFO dashboard)
CREATE TABLE public.hourly_revenue (
    id SERIAL PRIMARY KEY,
    hour TIMESTAMP NOT NULL UNIQUE,
    digital_products DECIMAL(10,2) DEFAULT 0,
    saas_mrr DECIMAL(10,2) DEFAULT 0,
    content DECIMAL(10,2) DEFAULT 0,
    trading_pnl DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    new_transactions INT DEFAULT 0,
    cumulative_revenue DECIMAL(10,2) DEFAULT 0,
    recovery_pct DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Cost tracking (split by category)
CREATE TABLE public.costs (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    category VARCHAR(50) NOT NULL,  -- hosting, tools, ads, processor_fee, etc.
    amount DECIMAL(10,2) NOT NULL,
    stream VARCHAR(50),               -- which revenue stream? (nullable)
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Payment processor fees (auto-tracked)
CREATE TABLE public.processor_fees (
    id SERIAL PRIMARY KEY,
    processor VARCHAR(50) NOT NULL,  -- stripe, paypal, etc.
    transaction_id VARCHAR(255),
    original_amount DECIMAL(10,2),
    fee_amount DECIMAL(10,2),
    fee_pct DECIMAL(5,2),            -- calculated fee %
    date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════
-- STREAM-SPECIFIC AGGREGATES (for hourly reporting)
-- ════════════════════════════════════════════════════════════

CREATE TABLE public.digital_products_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    total_sales DECIMAL(10,2) DEFAULT 0,
    total_fees DECIMAL(10,2) DEFAULT 0,
    net_revenue DECIMAL(10,2) DEFAULT 0,
    transaction_count INT DEFAULT 0,
    top_product VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE public.saas_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    active_subscribers INT DEFAULT 0,
    total_mrr DECIMAL(10,2) DEFAULT 0,
    new_subscribers INT DEFAULT 0,
    churn_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE public.content_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    affiliate_revenue DECIMAL(10,2) DEFAULT 0,
    adsense_revenue DECIMAL(10,2) DEFAULT 0,
    sponsor_revenue DECIMAL(10,2) DEFAULT 0,
    total_revenue DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE public.trading_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    pnl DECIMAL(18,8) DEFAULT 0,
    trade_count INT DEFAULT 0,
    win_count INT DEFAULT 0,
    loss_count INT DEFAULT 0,
    win_rate DECIMAL(5,2),
    avg_win DECIMAL(18,8),
    avg_loss DECIMAL(18,8),
    created_at TIMESTAMP DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════
-- ESCALATION & ALERTS (triggers for CFO attention)
-- ════════════════════════════════════════════════════════════

CREATE TABLE public.alerts (
    id SERIAL PRIMARY KEY,
    alert_type VARCHAR(50),             -- revenue_missed, cost_spike, error_count, etc.
    severity VARCHAR(20) DEFAULT 'info', -- info, warning, critical
    message TEXT NOT NULL,
    threshold_name VARCHAR(100),
    actual_value DECIMAL(18,8),
    expected_value DECIMAL(18,8),
    stream VARCHAR(50),
    acknowledged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Error tracking (n8n workflow failures, transaction issues)
CREATE TABLE public.errors (
    id SERIAL PRIMARY KEY,
    error_type VARCHAR(100),           -- workflow_failed, payment_failed, api_error, etc.
    source VARCHAR(100),               -- n8n workflow name, payment processor, etc.
    message TEXT,
    error_count INT DEFAULT 1,
    last_occurred TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════════
-- INDICES (for fast CFO queries)
-- ════════════════════════════════════════════════════════════

CREATE INDEX idx_daily_revenue_date ON public.daily_revenue(date DESC);
CREATE INDEX idx_hourly_revenue_hour ON public.hourly_revenue(hour DESC);
CREATE INDEX idx_costs_date ON public.costs(date DESC);
CREATE INDEX idx_alerts_created_at ON public.alerts(created_at DESC);
CREATE INDEX idx_alerts_severity ON public.alerts(severity);
CREATE INDEX idx_errors_resolved ON public.errors(resolved);
```

---

## PART 2: 5 CRITICAL QUERIES (CFO DASHBOARD)

### Query 1: HOURLY DASHBOARD (Run Every Hour)
**Use:** Immediate revenue snapshot + progress to goal
**Frequency:** Hourly (top of hour, for standup)

```sql
-- CFO Hourly Dashboard Query
WITH goal AS (
    SELECT target_amount FROM public.recovery_goals
    ORDER BY created_at DESC LIMIT 1
),
today_revenue AS (
    SELECT COALESCE(SUM(total), 0) as today_total
    FROM public.daily_revenue
    WHERE date = CURRENT_DATE
),
cumulative AS (
    SELECT COALESCE(SUM(total), 0) as all_time_revenue
    FROM public.daily_revenue
    WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)
),
current_hour AS (
    SELECT
        COALESCE(digital_products, 0) as dp,
        COALESCE(saas_mrr, 0) as saas,
        COALESCE(content, 0) as content,
        COALESCE(trading_pnl, 0) as trading,
        COALESCE(total, 0) as hour_total
    FROM public.hourly_revenue
    WHERE hour >= DATE_TRUNC('hour', NOW())
    LIMIT 1
)
SELECT
    (SELECT target_amount FROM goal) as goal,
    (SELECT all_time_revenue FROM cumulative) as total_recovered,
    ROUND(((SELECT all_time_revenue FROM cumulative) / (SELECT target_amount FROM goal)) * 100, 2) as recovery_pct,
    (SELECT today_total FROM today_revenue) as today_revenue,
    (SELECT hour_total FROM current_hour) as this_hour_revenue,
    (SELECT target_amount FROM goal) - (SELECT all_time_revenue FROM cumulative) as remaining_to_goal,
    ROUND(EXTRACT(DAY FROM NOW() - (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)), 1) as days_elapsed;
```

**Output columns:**
- `goal` — Target amount (e.g., 10000.00)
- `total_recovered` — All revenue to date (e.g., 2500.00)
- `recovery_pct` — Progress % (e.g., 25.00)
- `today_revenue` — Today's total so far (e.g., 150.00)
- `this_hour_revenue` — This hour's revenue (e.g., 45.00)
- `remaining_to_goal` — Gap to target (e.g., 7500.00)
- `days_elapsed` — Days since start

---

### Query 2: REVENUE BY STREAM (Run Every 4 Hours)
**Use:** Which stream is performing? Where is money coming from?
**Frequency:** Every 4 hours

```sql
-- Revenue by Stream (This Week)
SELECT
    'Digital Products' as stream,
    COALESCE(SUM(digital_products), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN digital_products END), 0) as last_week,
    ROUND(((COALESCE(SUM(digital_products), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN digital_products END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'SaaS (MRR)',
    COALESCE(SUM(saas_mrr), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN saas_mrr END), 0) as last_week,
    ROUND(((COALESCE(SUM(saas_mrr), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN saas_mrr END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'Content/Affiliate',
    COALESCE(SUM(content), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN content END), 0) as last_week,
    ROUND(((COALESCE(SUM(content), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN content END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'Trading P&L',
    COALESCE(SUM(trading_pnl), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN trading_pnl END), 0) as last_week,
    ROUND(((COALESCE(SUM(trading_pnl), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN trading_pnl END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

ORDER BY this_week DESC;
```

**Output:** Stream name, this week total, last week total, trend % change

---

### Query 3: COSTS & PROFIT (Run Daily at 8am)
**Use:** Ensure costs don't exceed revenue. Track burn rate.
**Frequency:** Daily

```sql
-- Daily Cost & Profit Summary
SELECT
    CURRENT_DATE as report_date,
    COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE), 0) as daily_revenue,
    COALESCE((SELECT SUM(amount) FROM public.costs WHERE date = CURRENT_DATE), 0) as daily_costs,
    COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE), 0)
        - COALESCE((SELECT SUM(amount) FROM public.costs WHERE date = CURRENT_DATE), 0) as daily_profit,
    ROUND(COALESCE((SELECT SUM(amount) FROM public.costs WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) / 7, 2) as avg_daily_cost_week,
    ROUND(COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) / 7, 2) as avg_daily_revenue_week,
    COALESCE((SELECT SUM(amount) FROM public.processor_fees WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) as processor_fees_week,
    COALESCE((SELECT SUM(amount) FROM public.costs WHERE date >= CURRENT_DATE - INTERVAL '7 days' AND category != 'processor_fee'), 0) as other_costs_week
FROM public.daily_revenue
WHERE date = CURRENT_DATE
LIMIT 1;
```

**Output columns:**
- `daily_revenue` — Revenue today
- `daily_costs` — Costs today
- `daily_profit` — Net today
- `avg_daily_cost_week` — Weekly burn rate (daily average)
- `avg_daily_revenue_week` — Weekly revenue (daily average)
- `processor_fees_week` — Payment processor fees (last 7 days)
- `other_costs_week` — Other operational costs

---

### Query 4: ESCALATION ALERTS (Run Every Hour)
**Use:** Flag problems immediately (revenue miss, cost spike, errors)
**Frequency:** Hourly

```sql
-- Active Alerts & Errors (Last 24 Hours)
SELECT
    'ALERT' as type,
    alert_type as issue,
    severity,
    message,
    actual_value,
    expected_value,
    ROUND(((actual_value / NULLIF(expected_value, 0)) - 1) * 100, 1) as variance_pct,
    created_at as detected_at,
    EXTRACT(HOUR FROM NOW() - created_at)::INT as hours_active
FROM public.alerts
WHERE created_at >= NOW() - INTERVAL '24 hours'
AND acknowledged = FALSE

UNION ALL

SELECT
    'ERROR' as type,
    error_type as issue,
    CASE WHEN resolved THEN 'RESOLVED' ELSE 'CRITICAL' END as severity,
    source || ': ' || message as message,
    error_count::DECIMAL,
    NULL as expected_value,
    NULL as variance_pct,
    last_occurred,
    EXTRACT(HOUR FROM NOW() - last_occurred)::INT as hours_active
FROM public.errors
WHERE last_occurred >= NOW() - INTERVAL '24 hours'
AND resolved = FALSE

ORDER BY severity DESC, created_at DESC;
```

**Output:** Issues requiring CFO attention (revenue targets missed, payment failures, automation errors)

---

### Query 5: RECOVERY PROGRESS & ETA (Run Daily)
**Use:** Forecast when $10K goal will be achieved
**Frequency:** Daily at 9am

```sql
-- Recovery Progress & ETA
WITH revenue_stats AS (
    SELECT
        COUNT(*) as days_tracked,
        SUM(total) as total_revenue,
        AVG(total) as avg_daily_revenue,
        MAX(total) as peak_day,
        MIN(total) as min_day
    FROM public.daily_revenue
    WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)
),
goal_data AS (
    SELECT target_amount, start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1
)
SELECT
    goal_data.target_amount as goal_amount,
    revenue_stats.total_revenue as recovered_to_date,
    ROUND((revenue_stats.total_revenue / goal_data.target_amount) * 100, 2) as recovery_pct,
    (goal_data.target_amount - revenue_stats.total_revenue) as remaining,
    revenue_stats.avg_daily_revenue as daily_avg,
    ROUND((goal_data.target_amount - revenue_stats.total_revenue) / NULLIF(revenue_stats.avg_daily_revenue, 0), 0)::INT as days_to_goal,
    goal_data.start_date + INTERVAL '1 day' * ROUND((goal_data.target_amount - revenue_stats.total_revenue) / NULLIF(revenue_stats.avg_daily_revenue, 0), 0) as projected_completion,
    revenue_stats.peak_day as best_day_revenue,
    revenue_stats.min_day as worst_day_revenue,
    revenue_stats.days_tracked as tracking_days
FROM revenue_stats, goal_data;
```

**Output:**
- `recovery_pct` — % to goal (0–100)
- `remaining` — Dollars to go
- `daily_avg` — Average daily revenue
- `days_to_goal` — Projected days to completion
- `projected_completion` — Target date (calendar)

---

## PART 3: CRON AUTOMATION SETUP

### n8n Workflows (Autonomous Execution)

Setup in `/MakinMoves-portable/n8n/`:

#### Workflow 1: Hourly Revenue Sync (Every Hour)
```
CRON: 0 * * * *  (every hour, top of hour)

Steps:
1. Query all revenue sources (digital_products.sales, saas.subscribers, content.revenue, trading.trades)
2. Aggregate into hourly_revenue table
3. Recalculate daily_revenue (update today's row)
4. Check escalation thresholds
5. Create/update alerts if needed
6. Log to errors table if any API/DB failures
```

**n8n Trigger:**
```json
{
  "type": "schedule",
  "schedule": {
    "rule": "0 * * * *"
  }
}
```

#### Workflow 2: Daily Cost & Profit Report (8am)
```
CRON: 0 8 * * *  (every day at 8am UTC)

Steps:
1. Run Query 3 (Costs & Profit)
2. Update daily_revenue with cost totals
3. Recalculate net profit
4. Flag if costs > revenue (warning alert)
5. Email/log summary to CFO
```

#### Workflow 3: Recovery Progress Check (9am)
```
CRON: 0 9 * * *  (every day at 9am UTC)

Steps:
1. Run Query 5 (ETA calculation)
2. Update BOARD.md with recovery %
3. If recovery % crosses threshold (10%, 25%, 50%, 75%, 90%), escalate to CEO
4. Log to CFO outbox for standup
```

#### Workflow 4: Active Alerts Digest (Every 4 hours)
```
CRON: 0 */4 * * *  (every 4 hours)

Steps:
1. Run Query 4 (Active alerts)
2. Count unresolved issues
3. If critical escalations > 2, alert CEO
4. Log to CFO outbox
```

#### Workflow 5: Weekly Financial Report (Monday 6am)
```
CRON: 0 6 * * 1  (Monday 6am UTC)

Steps:
1. Compile all queries from week
2. Generate summary markdown
3. Write to ./CFO/outbox/report_YYYY-MM-DD.md
4. Calculate weekly metrics for standup
5. Identify top-performing stream
```

---

## PART 4: CFO DASHBOARD METRICS (3–5 KEY NUMBERS)

### The 5 Numbers CFO Watches Hourly

| Metric | Query | Threshold | Alert |
|--------|-------|-----------|-------|
| **Recovery %** | Query 1 | 0–100% | If < velocity, flag |
| **Daily Revenue** | Query 3 | Trending up | If down 20% vs avg, alert |
| **Total Costs** | Query 3 | < Revenue | If costs > 40% revenue, warn |
| **Processing Errors** | Query 4 | 0 active | Any error > 2 hours, escalate |
| **Days to Goal** | Query 5 | Decreasing | If increasing > 2 days, review |

### Standup Format (CFO Hourly Report)

```markdown
## CFO
- **Status:**
  - Recovery: 25% ($2,500 of $10,000)
  - This week: $600 revenue
  - Costs: $120 (20% of revenue)
  - No alerts
- **Blockers:** None
- **Need from board:** CEO — approval for $50/mo analytics tool (ROI: 1.5x)
- **Next hour:** Process Stripe payouts, update daily summary
```

---

## PART 5: ESCALATION TRIGGERS & ALERT STRATEGY

### Severity Levels

| Severity | Trigger | CFO Action | CEO Alert |
|----------|---------|-----------|-----------|
| **INFO** | Daily log entry | Log only | No |
| **WARNING** | Cost spike (+30%), revenue drop (-20%), API lag | Add to standup | No |
| **CRITICAL** | Payment failure, 3+ errors, negative day, processing fee > 5% | Immediate investigation | YES |
| **ESCALATION** | Revenue < 50% of daily avg for 2 days, goal date slips > 1 week | Write to CEO inbox | YES |

### Auto-Generated Alerts

```sql
-- Example: Create alert if daily revenue < 50% of 7-day average
INSERT INTO public.alerts (alert_type, severity, message, threshold_name, actual_value, expected_value, stream, created_at)
SELECT
    'revenue_below_target' as alert_type,
    'CRITICAL' as severity,
    'Daily revenue below 50% of weekly average' as message,
    'daily_revenue_threshold' as threshold_name,
    (SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE) as actual_value,
    (SELECT SUM(total) / 7 FROM public.daily_revenue WHERE date >= CURRENT_DATE - INTERVAL '7 days' AND date < CURRENT_DATE) as expected_value,
    'all' as stream,
    NOW() as created_at
WHERE (SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE) <
      ((SELECT SUM(total) / 7 FROM public.daily_revenue WHERE date >= CURRENT_DATE - INTERVAL '7 days' AND date < CURRENT_DATE) * 0.5);
```

### Escalation Thresholds

**Critical Triggers (Auto-escalate to CEO):**

1. **Recovery goal slips** — If projected completion date > original target + 2 weeks
   - Action: CEO reviews stream priorities

2. **Payment processor failures** — 3+ failed transactions in 1 hour
   - Action: CTMO checks integrations immediately

3. **Revenue collapse** — Day total < 25% of 7-day average
   - Action: CEO/COO reviews what broke

4. **Cost overrun** — Daily costs > 50% of daily revenue
   - Action: CEO approval needed for spend

5. **Automation failures** — 2+ n8n workflows failed in 6 hours
   - Action: CTMO fixes; CFO manual sync required

---

## PART 6: SETUP TIME & IMPLEMENTATION

### Phase 1: Database Setup (30 minutes)
```bash
# 1. Add CFO tables to PostgreSQL (copy schema above into init-db.sql)
# 2. Test connectivity from n8n
# 3. Create indexes (for fast queries)
psql -h localhost -U postgres -d makinmoves << 'EOF'
  [Paste schema above]
EOF

# 4. Verify tables exist
psql -h localhost -U postgres -d makinmoves -c "\dt public.*"
```

### Phase 2: n8n Workflow Setup (60 minutes)

**In n8n UI:**

1. Create 5 workflows (named as above)
2. Each workflow:
   - PostgreSQL node (SELECT queries from Part 2)
   - Conditional logic (escalation checks)
   - Log/Email node (output)
3. Test each workflow manually
4. Enable CRON schedule
5. Verify workflows run on schedule

### Phase 3: CFO Standup Integration (15 minutes)

1. Add CFO queries to hourly standup template
2. Update `./CFO/CLAUDE.md` with new Query 1–5
3. CFO runs Query 1 at start of each hour (copy/paste into psql)
4. Log output to standup

### **Total Setup Time: 105 minutes (1.75 hours)**

---

## PART 7: TRACKING RECOVERY % TOWARD $10,000 GOAL

### Initial Setup (CEO + CFO)

```sql
-- Day 1: Initialize goal
INSERT INTO public.recovery_goals (target_amount, start_date, goal_date, seed_budget, notes)
VALUES (10000.00, '2026-03-29', '2026-06-30', 1000.00, 'Primary recovery goal from scam loss');

-- Day 1: First daily revenue entry
INSERT INTO public.daily_revenue (date, digital_products, saas_mrr, content, trading_pnl, total, costs, net, cumulative_revenue, recovery_pct)
VALUES (CURRENT_DATE, 0, 0, 0, 0, 0, 0, 0, 0, 0);
```

### Hourly Update (Automated via n8n)

```sql
-- Update cumulative and recovery %
UPDATE public.daily_revenue
SET
    cumulative_revenue = (
        SELECT SUM(total) FROM public.daily_revenue
        WHERE date <= CURRENT_DATE
    ),
    recovery_pct = ROUND(
        ((SELECT SUM(total) FROM public.daily_revenue
        WHERE date <= CURRENT_DATE) / 10000.00) * 100, 2
    ),
    updated_at = NOW()
WHERE date = CURRENT_DATE;
```

### What CFO Sees (Visual Dashboard)

```
╔════════════════════════════════════════════════════════╗
║         RECOVERY PROGRESS TO $10,000 GOAL              ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  Total Recovered:  $2,500 (████████░░░░░░░░░░) 25%   ║
║                                                        ║
║  This Week:        $600  (↑ 15% vs last week)         ║
║  Daily Average:    $85.70                              ║
║  Days Elapsed:     29 days                             ║
║                                                        ║
║  Projected Goal:   June 15, 2026 (78 days from start) ║
║  Remaining:        $7,500                              ║
║                                                        ║
║  Top Stream:       Digital Products ($1,200)          ║
║  Cost Ratio:       18% (healthy)                       ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

---

## PART 8: SQL TEMPLATES (READY TO COPY/PASTE)

### Daily CFO Quick Check (3 queries in sequence)

```sql
-- 1. Hourly Dashboard
WITH goal AS (SELECT target_amount FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1),
cumulative AS (SELECT COALESCE(SUM(total), 0) as all_time FROM public.daily_revenue WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1))
SELECT
    (SELECT target_amount FROM goal) as goal,
    (SELECT all_time FROM cumulative) as recovered,
    ROUND(((SELECT all_time FROM cumulative) / (SELECT target_amount FROM goal)) * 100, 2) as pct
FROM goal LIMIT 1;

-- 2. Today's Metrics
SELECT
    COALESCE(SUM(total), 0) as today_revenue,
    COALESCE(SUM(costs), 0) as today_costs,
    COALESCE(SUM(net), 0) as today_profit
FROM public.daily_revenue WHERE date = CURRENT_DATE;

-- 3. Active Problems
SELECT alert_type, severity, message, created_at
FROM public.alerts
WHERE acknowledged = FALSE
AND created_at >= NOW() - INTERVAL '24 hours'
ORDER BY severity DESC;
```

---

## PART 9: FAILURE MODES & RECOVERY

### If n8n Workflow Fails

1. CFO checks `public.errors` table
2. Manual fallback: CFO runs Query 1 + Query 3 manually
3. CTMO fixes workflow
4. CFO resumes automated syncs

### If PostgreSQL Connection Lost

1. n8n creates critical alert
2. CFO retries database connection
3. If 15+ min down, escalate to CTMO + CEO
4. Logs are stored in n8n (not lost)

### If Daily Revenue Not Updated by 11am

1. CFO manually runs Query 3
2. Inserts missing `daily_revenue` row
3. Escalates to COO to investigate why streams didn't report

---

## SUMMARY: CFO AUTONOMOUS OPERATION

**What CFO Does Hourly:**
- Read Query 1 (recovery dashboard)
- Check for alerts (Query 4)
- Write standup (2 min)

**What n8n Does Hourly/Daily:**
- Sync all revenue sources
- Aggregate daily/hourly tables
- Check escalation thresholds
- Log alerts + errors
- Email reports

**What CEO Sees Weekly:**
- Recovery % in standup
- Revenue by stream trends
- Cost ratio health
- ETA updates
- Top blockers

**Setup:** 105 minutes
**Maintenance:** 5 min/hour (CFO reads 1 query)
**Automation:** 95% (n8n handles the rest)

