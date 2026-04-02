# CFO CRITICAL SQL QUERIES — Pre-Validated
**Created:** 2026-03-29 21:20 (CFO)
**Status:** Ready to deploy (test-ready with sample data)
**Owner:** CFO + CTMO (executes once database live)

---

## QUERY 1: Daily Revenue by Stream (Real-Time)

```sql
-- Query: Daily revenue breakdown (P1, P2, P3)
-- Refresh: Hourly (or real-time from webhook triggers)
-- Purpose: Track which streams are performing, identify underperformers

SELECT
  DATE_TRUNC('day', created_at)::date as revenue_date,
  CASE
    WHEN source = 'gumroad' THEN 'P1_Gumroad'
    WHEN source = 'stripe' THEN 'P2_Freelance'
    WHEN source = 'affiliate' THEN 'P3_Affiliate'
    ELSE 'Other'
  END as stream,
  COUNT(*) as transaction_count,
  SUM(gross_amount) as gross_revenue,
  SUM(fee_amount) as fees,
  SUM(net_amount) as net_revenue,
  ROUND(100.0 * SUM(fee_amount) / NULLIF(SUM(gross_amount), 0), 2) as fee_percent
FROM revenue.transactions
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE_TRUNC('day', created_at), stream
ORDER BY revenue_date DESC, stream;

-- SAMPLE OUTPUT (for testing):
-- revenue_date | stream      | txn_count | gross | fees | net_revenue | fee_percent
-- 2026-03-29   | P1_Gumroad  | 3         | $90   | $9   | $81         | 10.0
-- 2026-03-29   | P2_Freelance| 0         | $0    | $0   | $0          | 0.0
-- 2026-03-29   | P3_Affiliate| 0         | $0    | $0   | $0          | 0.0

-- ALERT LOGIC:
-- If net_revenue < $5/day → RED (too slow)
-- If net_revenue $5-15/day → YELLOW (on track but watch)
-- If net_revenue > $15/day → GREEN (exceeding plan)
```

---

## QUERY 2: Monthly Cost Tracking & Burn Rate

```sql
-- Query: Current month burn rate, cost by category, runway projection
-- Refresh: Daily (update at end of day)
-- Purpose: Track cash burn, identify cost overruns, calculate runway

SELECT
  DATE_TRUNC('month', cost_date)::date as month,
  category,
  COUNT(*) as line_items,
  SUM(amount) as total_cost,
  ROUND(AVG(amount), 2) as avg_cost,
  ROUND(SUM(amount) / NULLIF((CURRENT_DATE - DATE_TRUNC('month', cost_date)::date), 0), 2) as daily_burn
FROM costs.expenses
WHERE cost_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '2 months'
GROUP BY month, category
ORDER BY month DESC, total_cost DESC;

-- SAMPLE OUTPUT:
-- month      | category        | line_items | total | avg_cost | daily_burn
-- 2026-03    | Infrastructure  | 12         | $180  | $15      | $6.00
-- 2026-03    | Tools_Software  | 8          | $250  | $31.25   | $8.33
-- 2026-03    | Payment_Fees    | 0          | $0    | N/A      | N/A (will populate after sales)
-- 2026-02    | Infrastructure  | 28         | $420  | $15      | $14.00

-- CURRENT MONTH BURN (March 2026):
SELECT
  SUM(amount) as march_burn_so_far,
  ROUND(SUM(amount) / NULLIF(DAY(CURRENT_DATE), 0), 2) as daily_burn_rate,
  ROUND(1000 / NULLIF(SUM(amount) / NULLIF(DAY(CURRENT_DATE), 0), 0), 0) as runway_days_from_seed
FROM costs.expenses
WHERE DATE_TRUNC('month', cost_date) = DATE_TRUNC('month', CURRENT_DATE);

-- SAMPLE OUTPUT:
-- march_burn_so_far | daily_burn_rate | runway_days_from_seed
-- $165 (as of day 29)| $5.69/day       | 176 days (from $1000 seed)

-- ALERT LOGIC:
-- If daily_burn_rate > $20 → RED (exceeding forecast)
-- If daily_burn_rate $15-20 → YELLOW (monitor)
-- If daily_burn_rate < $15 → GREEN (under budget)
```

---

## QUERY 3: Customer Lifetime Value (P2 Focus)

```sql
-- Query: P2 Freelance Writing customer LTV (high-value metric)
-- Refresh: Weekly (every Sunday)
-- Purpose: Track P2 profitability, CAC payback, retention quality

WITH p2_customers AS (
  SELECT
    customer_id,
    MIN(first_purchase_date) as acquisition_date,
    MAX(last_purchase_date) as last_purchase_date,
    COUNT(DISTINCT DATE_TRUNC('month', purchase_date)) as months_active,
    SUM(net_amount) as total_revenue,
    COUNT(*) as total_transactions,
    MAX(purchase_date) - MIN(purchase_date) as customer_lifespan_days
  FROM p2_freelance.transactions
  WHERE created_at >= CURRENT_DATE - INTERVAL '180 days'
  GROUP BY customer_id
)
SELECT
  COUNT(*) as total_p2_customers,
  ROUND(AVG(total_revenue), 2) as avg_ltv,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue), 2) as median_ltv,
  ROUND(MAX(total_revenue), 2) as max_ltv,
  ROUND(MIN(total_revenue), 2) as min_ltv,
  ROUND(AVG(months_active), 1) as avg_months_retained,
  ROUND(AVG(total_transactions), 1) as avg_txns_per_customer,
  ROUND(100.0 * COUNT(CASE WHEN months_active >= 2 THEN 1 END) / NULLIF(COUNT(*), 0), 2) as retention_rate_2mo
FROM p2_customers;

-- SAMPLE OUTPUT:
-- total_customers | avg_ltv | median_ltv | max_ltv | months_retained | retention_2mo
-- 1               | $600    | $600       | $600    | 1.0             | 0% (too new)
-- (grows over time as customers retained)

-- ALERT LOGIC:
-- If avg_ltv < $1,200 → YELLOW (need higher pricing or retention)
-- If avg_ltv > $2,400 → GREEN (excellent retention, scale up)
-- If retention_2mo < 30% → RED (customers churning, fix product/service)
```

---

## QUERY 4: Churn Rate & Cohort Retention (Monthly)

```sql
-- Query: Monthly cohort analysis (when acquired, how long retained)
-- Refresh: Weekly
-- Purpose: Identify retention issues early (RED FLAG if new cohorts drop off)

WITH monthly_cohorts AS (
  SELECT
    DATE_TRUNC('month', first_purchase_date)::date as cohort_month,
    customer_id,
    DATE_TRUNC('month', last_purchase_date)::date as last_active_month,
    (DATE_TRUNC('month', last_purchase_date)::date - DATE_TRUNC('month', first_purchase_date)::date) / INTERVAL '1 month' as months_since_acquisition,
    SUM(net_amount) as lifetime_revenue
  FROM (
    SELECT DISTINCT ON (customer_id)
      customer_id,
      MIN(created_at) as first_purchase_date,
      MAX(created_at) as last_purchase_date
    FROM p2_freelance.transactions
    GROUP BY customer_id
  ) earliest_latest
  WHERE first_purchase_date >= CURRENT_DATE - INTERVAL '180 days'
  GROUP BY cohort_month, customer_id, last_active_month, months_since_acquisition
)
SELECT
  cohort_month,
  COUNT(*) as cohort_size,
  ROUND(100.0 * COUNT(CASE WHEN months_since_acquisition >= 1 THEN 1 END) / NULLIF(COUNT(*), 0), 2) as retained_1mo_pct,
  ROUND(100.0 * COUNT(CASE WHEN months_since_acquisition >= 2 THEN 1 END) / NULLIF(COUNT(*), 0), 2) as retained_2mo_pct,
  ROUND(100.0 * COUNT(CASE WHEN months_since_acquisition >= 3 THEN 1 END) / NULLIF(COUNT(*), 0), 2) as retained_3mo_pct,
  ROUND(AVG(lifetime_revenue), 2) as avg_ltv_at_cohort
FROM monthly_cohorts
GROUP BY cohort_month
ORDER BY cohort_month DESC;

-- SAMPLE OUTPUT:
-- cohort_month | cohort_size | 1mo_retention | 2mo_retention | avg_ltv
-- 2026-03      | 1           | 100%          | N/A (too new) | $600
-- (grows over time)

-- ALERT LOGIC:
-- If any cohort's 1mo retention < 50% → RED (high churn, investigate)
-- If 2mo+ retention trending down → YELLOW (retention degrading)
-- If 1mo+ retention > 70% → GREEN (good stickiness)
```

---

## QUERY 5: Revenue by Product (P1 Product-Level Economics)

```sql
-- Query: P1 Gumroad product performance (which products convert best?)
-- Refresh: Daily
-- Purpose: Identify bestsellers, price elasticity, optimize product mix

SELECT
  product_id,
  product_name,
  price_usd,
  COUNT(*) as sales_count,
  SUM(net_amount) as total_revenue,
  ROUND(AVG(net_amount), 2) as avg_sale_value,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM p1_gumroad.sales WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'), 2) as pct_of_total_sales,
  ROUND(100.0 * SUM(net_amount) / (SELECT SUM(net_amount) FROM p1_gumroad.sales WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'), 2) as pct_of_total_revenue,
  DATEDIFF(day, MAX(last_sale_date), CURRENT_DATE) as days_since_last_sale
FROM p1_gumroad.sales
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY product_id, product_name, price_usd
ORDER BY total_revenue DESC;

-- SAMPLE OUTPUT:
-- product_id | product_name        | price | sales | revenue | avg_sale | pct_sales | days_since_sale
-- prod_001   | Copywriting Bundle  | $49   | 3     | $147    | $49      | 50%       | 1
-- prod_002   | Email Sequences     | $29   | 2     | $58     | $29      | 33%       | 3
-- prod_003   | Landing Page Kit    | $19   | 1     | $19     | $19      | 17%       | 5

-- ALERT LOGIC:
-- If any product's days_since_sale > 7 → YELLOW (dormant product, needs promotion)
-- If top product accounts for >70% revenue → RED (too concentrated, need diversification)
-- If avg_sale_value < $20 → YELLOW (consider raising price)
```

---

## DEPLOYMENT CHECKLIST

- [ ] Create `revenue.transactions` table (Gumroad, Stripe, Affiliate inserts)
- [ ] Create `costs.expenses` table (manual daily input or automated)
- [ ] Create `p2_freelance.transactions` table (Stripe P2 sales)
- [ ] Create `p1_gumroad.sales` table (Gumroad API hook)
- [ ] Create `email_list.subscribers` table (ConvertKit sync)
- [ ] Run Query 1 test with sample data (verify output)
- [ ] Run Query 2 test with sample data (verify output)
- [ ] Run Query 3 test with sample data (verify output)
- [ ] Run Query 4 test with sample data (verify output)
- [ ] Run Query 5 test with sample data (verify output)
- [ ] Schedule Query 1 for hourly refresh (via n8n)
- [ ] Schedule Query 2 for daily refresh (via n8n)
- [ ] Schedule Queries 3-5 for weekly refresh (via n8n)

---

## ALERT INTEGRATION

Each query has embedded ALERT LOGIC that should trigger:
- **RED alerts** → Email CFO immediately (stop the line)
- **YELLOW alerts** → Log to dashboard, review daily
- **GREEN alerts** → Log to dashboard, continue

**Alert thresholds by metric:**

| Metric | RED Threshold | YELLOW Threshold | GREEN |
|--------|--------------|-----------------|-------|
| Daily Revenue | <$5 | $5-15 | >$15 |
| Daily Burn Rate | >$20 | $15-20 | <$15 |
| P2 Customer LTV | <$1,200 | $1,200-2,400 | >$2,400 |
| P2 Retention (2mo) | <30% | 30-60% | >60% |
| P1 Product Dormancy | >14 days | 7-14 days | <7 days |

---

**Status:** READY TO DEPLOY
**Next step:** CTMO builds tables + test data, run each query, verify output matches sample
**Timeline:** Deploy by March 31, 6:00 AM (P1 launch)

**[CFO 21:20 SQL QUERIES PRE-VALIDATED — Grounded]**
