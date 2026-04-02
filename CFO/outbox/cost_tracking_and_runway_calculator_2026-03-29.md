# Cost Tracking & Runway Calculator

**Date:** 2026-03-29
**From:** CFO
**Purpose:** Hourly cost monitoring, daily runway tracking, scenario profitability analysis

---

## Setup: Cost Tracking Database

### Table 1: Monthly Costs by Scenario

```sql
-- Create table
CREATE TABLE IF NOT EXISTS public.scenario_costs (
    id SERIAL PRIMARY KEY,
    scenario VARCHAR(20) NOT NULL, -- 'lean', 'standard', 'cloud'
    service VARCHAR(100) NOT NULL,
    monthly_cost_usd DECIMAL(10,2) NOT NULL,
    category VARCHAR(50), -- 'infrastructure', 'processing', 'tools'
    is_active BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert LEAN scenario ($10–20/mo)
INSERT INTO public.scenario_costs (scenario, service, monthly_cost_usd, category, notes) VALUES
('lean', 'DigitalOcean Droplet (optional)', 5.00, 'infrastructure', 'Only if not running locally'),
('lean', 'Namecheap Domain', 1.00, 'infrastructure', 'Annual cost amortized'),
('lean', 'PostgreSQL (local Docker)', 0.00, 'infrastructure', 'Self-hosted, free'),
('lean', 'n8n (local Docker)', 0.00, 'infrastructure', 'Self-hosted, free'),
('lean', 'Redis (local Docker)', 0.00, 'infrastructure', 'Self-hosted, free'),
('lean', 'Selenium (local Docker)', 0.00, 'infrastructure', 'Self-hosted, free'),
('lean', 'Buffer/Contingency', 5.00, 'tools', 'Unexpected expenses');

-- Insert STANDARD scenario ($30–50/mo)
INSERT INTO public.scenario_costs (scenario, service, monthly_cost_usd, category, notes) VALUES
('standard', 'Railway PostgreSQL', 7.00, 'infrastructure', 'Managed, 2GB storage'),
('standard', 'n8n (Railway self-hosted)', 0.00, 'infrastructure', 'Free tier on Railway'),
('standard', 'Upstash Redis (free)', 0.00, 'infrastructure', 'Free tier sufficient'),
('standard', 'Selenium (local Docker)', 0.00, 'infrastructure', 'Self-hosted'),
('standard', 'Monitoring/Logging', 5.00, 'tools', 'Optional: CloudWatch or similar'),
('standard', 'Domain + SSL', 1.00, 'infrastructure', 'Namecheap + Let''s Encrypt'),
('standard', 'Tools/Contingency', 10.00, 'tools', 'Monitoring, ad testing, etc.');

-- Insert CLOUD scenario ($100–200+/mo)
INSERT INTO public.scenario_costs (scenario, service, monthly_cost_usd, category, notes) VALUES
('cloud', 'AWS RDS PostgreSQL', 30.00, 'infrastructure', 'db.t3.micro + backups'),
('cloud', 'AWS ElastiCache Redis', 15.00, 'infrastructure', 'cache.t3.micro'),
('cloud', 'ScrapingBee (paid)', 25.00, 'infrastructure', 'Cloud-based web scraping'),
('cloud', 'n8n Cloud', 15.00, 'infrastructure', 'Premium managed service'),
('cloud', 'DataDog Monitoring', 20.00, 'tools', 'Enterprise-grade monitoring'),
('cloud', 'Domain + SSL', 1.00, 'infrastructure', 'Namecheap + CloudFlare Pro'),
('cloud', 'Load Balancer/WAF', 20.00, 'infrastructure', 'AWS Load Balancer + extras'),
('cloud', 'Overage Buffer', 30.00, 'tools', 'Data transfer, compute overages');
```

### Query: Total Monthly Cost by Scenario

```sql
-- Get total cost for each scenario
SELECT
    scenario,
    SUM(monthly_cost_usd) as total_monthly_cost,
    COUNT(*) as num_services
FROM public.scenario_costs
WHERE is_active = true
GROUP BY scenario
ORDER BY total_monthly_cost ASC;

-- Expected output:
-- scenario  | total_monthly_cost | num_services
-- -----------+-------------------+--------------
-- lean      |             11.00 |            7
-- standard  |             23.00 |            7
-- cloud     |            156.00 |            8
```

### Query: Cost Breakdown by Category (per scenario)

```sql
-- See what we're spending on per category
SELECT
    scenario,
    category,
    SUM(monthly_cost_usd) as subtotal,
    ROUND(100.0 * SUM(monthly_cost_usd) /
        (SELECT SUM(monthly_cost_usd) FROM public.scenario_costs WHERE scenario = sc.scenario), 1) as percentage
FROM public.scenario_costs sc
WHERE is_active = true
GROUP BY scenario, category
ORDER BY scenario, subtotal DESC;
```

---

## Daily Revenue & Cost Tracking

### Table 2: Daily Revenue vs. Cost

```sql
-- Create tracking table
CREATE TABLE IF NOT EXISTS public.daily_cost_revenue_tracker (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    scenario VARCHAR(20) NOT NULL,
    daily_cost_usd DECIMAL(10,2),
    daily_revenue_usd DECIMAL(10,2),
    net_gain_loss DECIMAL(10,2),
    cumulative_revenue DECIMAL(12,2),
    cumulative_cost DECIMAL(12,2),
    cumulative_profit_loss DECIMAL(12,2),
    runway_days INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert initial baseline (Day 0: 2026-03-29)
INSERT INTO public.daily_cost_revenue_tracker
(date, scenario, daily_cost_usd, daily_revenue_usd, net_gain_loss, cumulative_revenue, cumulative_cost, cumulative_profit_loss, runway_days)
VALUES
('2026-03-29', 'lean', 0.33, 0.00, -0.33, 0.00, 0.33, -0.33, 3030),
('2026-03-29', 'standard', 1.33, 0.00, -1.33, 0.00, 1.33, -1.33, 751),
('2026-03-29', 'cloud', 5.00, 0.00, -5.00, 0.00, 5.00, -5.00, 200);
```

### Daily Update Query (run each evening)

```sql
-- Update daily tracker with revenue from revenue_summary
UPDATE public.daily_cost_revenue_tracker dct
SET
    daily_revenue_usd = (
        SELECT COALESCE(SUM(net_amount), 0)
        FROM public.revenue_summary
        WHERE period = CURRENT_DATE
    ),
    net_gain_loss = (
        SELECT COALESCE(SUM(net_amount), 0)
        FROM public.revenue_summary
        WHERE period = CURRENT_DATE
    ) - dct.daily_cost_usd,
    cumulative_revenue = (
        SELECT COALESCE(SUM(net_amount), 0)
        FROM public.revenue_summary
        WHERE period >= DATE '2026-03-29'
    ),
    cumulative_profit_loss = (
        SELECT COALESCE(SUM(net_amount), 0)
        FROM public.revenue_summary
        WHERE period >= DATE '2026-03-29'
    ) - (
        SELECT SUM(daily_cost_usd)
        FROM public.daily_cost_revenue_tracker
        WHERE date <= CURRENT_DATE AND scenario = dct.scenario
    ),
    runway_days = CASE
        WHEN daily_cost_usd > 0 THEN
            FLOOR(((SELECT 1000) - (
                SELECT COALESCE(SUM(daily_cost_usd), 0)
                FROM public.daily_cost_revenue_tracker
                WHERE date < CURRENT_DATE AND scenario = dct.scenario
            )) / daily_cost_usd)
        ELSE 999
    END,
    updated_at = NOW()
WHERE date = CURRENT_DATE AND scenario = 'lean'
OR date = CURRENT_DATE AND scenario = 'standard'
OR date = CURRENT_DATE AND scenario = 'cloud';
```

---

## Runway Calculator

### Daily Runway Metrics

```sql
-- Calculate remaining runway for each scenario
SELECT
    scenario,
    1000 as seed_budget,
    SUM(daily_cost_usd) as total_cost_to_date,
    COALESCE(SUM(daily_revenue_usd), 0) as total_revenue_to_date,
    (1000 - SUM(daily_cost_usd) + COALESCE(SUM(daily_revenue_usd), 0)) as cash_remaining,
    AVG(daily_cost_usd) as avg_daily_burn,
    CASE
        WHEN AVG(daily_cost_usd) > 0 THEN
            FLOOR((1000 - SUM(daily_cost_usd) + COALESCE(SUM(daily_revenue_usd), 0)) / AVG(daily_cost_usd))
        ELSE 999
    END as days_remaining,
    CURRENT_DATE + INTERVAL '1 day' *
        CASE
            WHEN AVG(daily_cost_usd) > 0 THEN
                FLOOR((1000 - SUM(daily_cost_usd) + COALESCE(SUM(daily_revenue_usd), 0)) / AVG(daily_cost_usd))
            ELSE 999
        END as projected_depletion_date,
    COALESCE(SUM(daily_revenue_usd), 0) as cumulative_revenue
FROM public.daily_cost_revenue_tracker
WHERE date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY scenario
ORDER BY days_remaining DESC;

-- Expected output on Day 1 (zero revenue):
-- scenario  | seed_budget | total_cost | total_revenue | cash_remaining | avg_daily_burn | days_remaining | depletion_date
-- -----------+-------------|-----------|--------------|----------------|----------------|----------------|---------------
-- lean      |       1000 |       0.33 |           0 |       999.67 |           0.33 |           3030 | 2032-04-09
-- standard  |       1000 |       1.33 |           0 |       998.67 |           1.33 |            751 | 2027-06-09
-- cloud     |       1000 |       5.00 |           0 |       995.00 |           5.00 |            200 | 2026-09-25

-- Expected output on Day 14 (2 sales = ~$35 revenue):
-- scenario  | seed_budget | total_cost | total_revenue | cash_remaining | avg_daily_burn | days_remaining | depletion_date
-- -----------+-------------|-----------|--------------|----------------|----------------|----------------|---------------
-- lean      |       1000 |       4.62 |          35 |      1030.38 |           0.33 |           3122 | 2032-05-09 (CASH POSITIVE!)
-- standard  |       1000 |      18.62 |          35 |      1016.38 |           1.33 |            764 | 2027-06-22
-- cloud     |       1000 |      70.00 |          35 |       965.00 |           5.00 |            193 | 2026-09-18 (still burning fast)
```

---

## Breakeven Analysis by Stream

### Table 3: Stream Profitability (Lean Scenario)

```sql
CREATE TABLE IF NOT EXISTS public.stream_breakeven (
    id SERIAL PRIMARY KEY,
    scenario VARCHAR(20),
    stream VARCHAR(50),
    product_type VARCHAR(100),
    avg_sale_price DECIMAL(10,2),
    processing_fee_pct DECIMAL(5,2),
    processing_fee_amt DECIMAL(10,2),
    net_per_sale DECIMAL(10,2),
    units_to_breakeven INT,
    days_to_breakeven INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert LEAN scenario breakeven data
INSERT INTO public.stream_breakeven
(scenario, stream, product_type, avg_sale_price, processing_fee_pct, processing_fee_amt, net_per_sale, units_to_breakeven, days_to_breakeven, notes)
VALUES
-- Lean: Monthly cost $10, break even at 1–2 sales
('lean', 'digital_products', 'Gumroad Template ($20)', 20.00, 11.70, 2.34, 17.66, 1, 7, 'Gumroad 8.5% + Stripe 3.2% + $0.30'),
('lean', 'pod', 'Redbubble Hoodie ($30)', 30.00, 50.00, 15.00, 15.00, 1, 10, '50% Redbubble margin, no extra fees'),
('lean', 'affiliate', 'Amazon Commission ($100 sale)', 100.00, 95.00, 95.00, 5.00, 2, 56, '5% affiliate commission, no platform fees'),
('lean', 'saas', 'SaaS Subscription ($20/mo)', 20.00, 3.50, 0.70, 19.30, 1, 42, '3.2% + $0.30 Stripe fee');

-- Insert STANDARD scenario breakeven data
INSERT INTO public.stream_breakeven
(scenario, stream, product_type, avg_sale_price, processing_fee_pct, processing_fee_amt, net_per_sale, units_to_breakeven, days_to_breakeven, notes)
VALUES
('standard', 'digital_products', 'Gumroad Template ($20)', 20.00, 11.70, 2.34, 17.66, 2, 14, 'Cost $40/mo: need 2–3 sales'),
('standard', 'pod', 'Redbubble Hoodie ($30)', 30.00, 50.00, 15.00, 15.00, 3, 21, 'Cost $40/mo: need 3 sales'),
('standard', 'affiliate', 'Amazon Commission ($100 sale)', 100.00, 95.00, 95.00, 5.00, 8, 112, 'Cost $40/mo: need 8 affiliate clicks'),
('standard', 'saas', 'SaaS Subscription ($20/mo)', 20.00, 3.50, 0.70, 19.30, 3, 126, 'Cost $40/mo: need 3 subscribers');

-- Insert CLOUD scenario breakeven data
INSERT INTO public.stream_breakeven
(scenario, stream, product_type, avg_sale_price, processing_fee_pct, processing_fee_amt, net_per_sale, units_to_breakeven, days_to_breakeven, notes)
VALUES
('cloud', 'digital_products', 'Gumroad Template ($20)', 20.00, 11.70, 2.34, 17.66, 9, 63, 'Cost $150/mo: need 9 sales'),
('cloud', 'pod', 'Redbubble Hoodie ($30)', 30.00, 50.00, 15.00, 15.00, 10, 70, 'Cost $150/mo: need 10 sales'),
('cloud', 'affiliate', 'Amazon Commission ($100 sale)', 100.00, 95.00, 95.00, 5.00, 30, 210, 'Cost $150/mo: need 30 affiliate clicks'),
('cloud', 'saas', 'SaaS Subscription ($20/mo)', 20.00, 3.50, 0.70, 19.30, 8, 240, 'Cost $150/mo: need 8 subscribers');

-- Query: Breakeven comparison
SELECT
    scenario,
    stream,
    product_type,
    net_per_sale,
    units_to_breakeven,
    days_to_breakeven,
    notes
FROM public.stream_breakeven
ORDER BY scenario, units_to_breakeven ASC;
```

---

## Profitability Projection Model

### Table 4: 90-Day Revenue Projection

```sql
CREATE TABLE IF NOT EXISTS public.revenue_projection_90day (
    id SERIAL PRIMARY KEY,
    scenario VARCHAR(20),
    day INT,
    digital_products_revenue DECIMAL(12,2),
    pod_revenue DECIMAL(12,2),
    affiliate_revenue DECIMAL(12,2),
    saas_revenue DECIMAL(12,2),
    total_daily_revenue DECIMAL(12,2),
    daily_cost DECIMAL(10,2),
    daily_profit_loss DECIMAL(12,2),
    cumulative_profit_loss DECIMAL(12,2),
    notes TEXT
);

-- Insert LEAN scenario projections (conservative: 2–3 sales/week)
INSERT INTO public.revenue_projection_90day
(scenario, day, digital_products_revenue, pod_revenue, affiliate_revenue, saas_revenue, total_daily_revenue, daily_cost, daily_profit_loss, cumulative_profit_loss, notes)
VALUES
('lean', 0, 0, 0, 0, 0, 0, 0.33, -0.33, -0.33, 'Day 0: Setup'),
('lean', 7, 17.66, 0, 0, 0, 17.66, 0.33, 17.33, 16.00, 'Day 7: First digital sale'),
('lean', 14, 35.32, 15.00, 0, 0, 50.32, 0.33, 49.99, 66.00, 'Day 14: 2 digital + 1 PoD'),
('lean', 21, 52.98, 30.00, 0, 0, 82.98, 0.33, 82.65, 200.00, 'Day 21: 3 digital + 2 PoD (BREAK EVEN!)'),
('lean', 30, 88.30, 60.00, 5.00, 0, 153.30, 10.00, 143.30, 600.00, 'Day 30: Month 1 finish'),
('lean', 60, 177.00, 120.00, 50.00, 0, 347.00, 10.00, 337.00, 1850.00, 'Day 60: All streams going'),
('lean', 90, 265.00, 180.00, 150.00, 20.00, 615.00, 10.00, 605.00, 3600.00, 'Day 90: Compounding growth');

-- Insert STANDARD scenario projections
INSERT INTO public.revenue_projection_90day
(scenario, day, digital_products_revenue, pod_revenue, affiliate_revenue, saas_revenue, total_daily_revenue, daily_cost, daily_profit_loss, cumulative_profit_loss, notes)
VALUES
('standard', 0, 0, 0, 0, 0, 0, 1.33, -1.33, -1.33, 'Day 0: Setup'),
('standard', 7, 17.66, 0, 0, 0, 17.66, 1.33, 16.33, 14.00, 'Day 7: First digital sale'),
('standard', 14, 35.32, 15.00, 0, 0, 50.32, 1.33, 49.00, 58.00, 'Day 14: 2 digital + 1 PoD'),
('standard', 21, 52.98, 30.00, 0, 0, 82.98, 1.33, 81.65, 140.00, 'Day 21: 3 digital + 2 PoD (BREAK EVEN!)'),
('standard', 30, 88.30, 60.00, 5.00, 0, 153.30, 40.00, 113.30, 500.00, 'Day 30: Month 1 finish (tighter margin)'),
('standard', 60, 177.00, 120.00, 50.00, 0, 347.00, 40.00, 307.00, 1500.00, 'Day 60: All streams, but cost eats margin'),
('standard', 90, 265.00, 180.00, 150.00, 20.00, 615.00, 40.00, 575.00, 3300.00, 'Day 90: Still profitable but slower growth');

-- Insert CLOUD scenario projections (unrealistic: same revenue as others)
INSERT INTO public.revenue_projection_90day
(scenario, day, digital_products_revenue, pod_revenue, affiliate_revenue, saas_revenue, total_daily_revenue, daily_cost, daily_profit_loss, cumulative_profit_loss, notes)
VALUES
('cloud', 0, 0, 0, 0, 0, 0, 5.00, -5.00, -5.00, 'Day 0: Setup'),
('cloud', 7, 17.66, 0, 0, 0, 17.66, 5.00, 12.66, -140.00, 'Day 7: First digital, but infrastructure killing us'),
('cloud', 14, 35.32, 15.00, 0, 0, 50.32, 5.00, 45.32, 140.00, 'Day 14: Building up'),
('cloud', 21, 52.98, 30.00, 0, 0, 82.98, 5.00, 77.98, 290.00, 'Day 21: BREAK EVEN (later than Lean/Standard)'),
('cloud', 30, 88.30, 60.00, 5.00, 0, 153.30, 150.00, 3.30, 350.00, 'Day 30: Infrastructure cost crushing revenue gain'),
('cloud', 60, 177.00, 120.00, 50.00, 0, 347.00, 150.00, 197.00, 1400.00, 'Day 60: Finally profitable, but behind'),
('cloud', 90, 265.00, 180.00, 150.00, 20.00, 615.00, 150.00, 465.00, 2900.00, 'Day 90: Day 60+ profit advantage lost');

-- Query: Compare profitability at key milestones
SELECT
    scenario,
    day,
    total_daily_revenue,
    daily_cost,
    daily_profit_loss,
    cumulative_profit_loss,
    notes
FROM public.revenue_projection_90day
WHERE day IN (0, 7, 14, 21, 30, 60, 90)
ORDER BY day, scenario;
```

---

## Hourly Standup Cost Summary

### Query: Daily Cost & Revenue Update

```sql
-- Run this daily at end-of-day to update standup
SELECT
    'Lean ($10/mo)' as scenario,
    ROUND((SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date <= CURRENT_DATE), 2) as cost_to_date,
    ROUND((SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date <= CURRENT_DATE), 2) as revenue_to_date,
    ROUND(
        (SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date <= CURRENT_DATE)
        -
        (SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date <= CURRENT_DATE),
        2
    ) as net_profit_loss,
    CASE
        WHEN (SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date <= CURRENT_DATE) > 0 THEN
            'PROFITABLE ✓'
        ELSE
            'Still testing'
    END as status,
    (SELECT runway_days FROM public.daily_cost_revenue_tracker WHERE scenario = 'lean' AND date = CURRENT_DATE LIMIT 1) as runway_days

UNION ALL

SELECT
    'Standard ($40/mo)' as scenario,
    ROUND((SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date <= CURRENT_DATE), 2) as cost_to_date,
    ROUND((SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date <= CURRENT_DATE), 2) as revenue_to_date,
    ROUND(
        (SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date <= CURRENT_DATE)
        -
        (SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date <= CURRENT_DATE),
        2
    ) as net_profit_loss,
    CASE
        WHEN (SELECT runway_days FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date = CURRENT_DATE LIMIT 1) < 10 THEN
            'WARNING: Low runway'
        ELSE
            'Safe runway'
    END as status,
    (SELECT runway_days FROM public.daily_cost_revenue_tracker WHERE scenario = 'standard' AND date = CURRENT_DATE LIMIT 1) as runway_days

UNION ALL

SELECT
    'Cloud ($150/mo)' as scenario,
    ROUND((SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date <= CURRENT_DATE), 2) as cost_to_date,
    ROUND((SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date <= CURRENT_DATE), 2) as revenue_to_date,
    ROUND(
        (SELECT COALESCE(SUM(daily_revenue_usd), 0) FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date <= CURRENT_DATE)
        -
        (SELECT SUM(daily_cost_usd) FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date <= CURRENT_DATE),
        2
    ) as net_profit_loss,
    CASE
        WHEN (SELECT runway_days FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date = CURRENT_DATE LIMIT 1) < 10 THEN
            'DANGER: Depletion imminent'
        ELSE
            'Still viable'
    END as status,
    (SELECT runway_days FROM public.daily_cost_revenue_tracker WHERE scenario = 'cloud' AND date = CURRENT_DATE LIMIT 1) as runway_days;
```

---

## Monthly Financial Report Template

### For CFO Weekly Standup

```markdown
## CFO Cost & Revenue Report — Week of [DATE]

### Scenario Performance (This Week)

| Scenario | Cost | Revenue | Net | Runway | Status |
|----------|------|---------|-----|--------|--------|
| **Lean** | $X | $X | $+X | ∞ days | ✓ Sustainable |
| **Standard** | $X | $X | $+X | X days | ⏳ Monitor |
| **Cloud** | $X | $X | $-X | X days | ✗ Not viable |

### Breakeven Progress

- Digital Products: [0/1 sales to breakeven]
- PoD: [0/1 sales to breakeven]
- Affiliate: [0/2 clicks to breakeven]
- SaaS: [0/1 subscriber to breakeven]

### Infrastructure Decision

- [ ] Continue Lean scenario
- [ ] Upgrade to Standard (if revenue ≥ $150/mo)
- [ ] Evaluate Cloud (only if revenue ≥ $500/mo)

### Cost Tracking

- Actual monthly burn: $X
- Projected monthly burn: $X
- Variance: $X

### Runway Status

- Seed budget remaining: $X
- Days of runway: X (at current burn)
- Projected depletion: [DATE] (if no revenue)
- **Status:** On track / At risk / Critical

### Recommendation

[Strategic recommendation based on cost vs. revenue trajectory]
```

---

## Monthly Cost Verification Checklist

Run this checklist on the 1st of each month:

```sql
-- 1. Verify all costs are logged
SELECT COUNT(*) as cost_entries FROM public.scenario_costs WHERE is_active = true;
-- Should be: Lean (7), Standard (7), Cloud (8) = 22 total

-- 2. Verify revenue is being tracked
SELECT COUNT(*) as revenue_entries FROM public.daily_cost_revenue_tracker WHERE date >= DATE_TRUNC('month', CURRENT_DATE);
-- Should be: At least 1 entry per day this month

-- 3. Check for any gaps in daily tracking
SELECT date FROM public.daily_cost_revenue_tracker WHERE date >= DATE '2026-03-29' AND scenario = 'lean'
ORDER BY date;
-- Should be continuous with no gaps

-- 4. Verify breakeven calculations are accurate
SELECT scenario, SUM(monthly_cost_usd) as total_cost FROM public.scenario_costs GROUP BY scenario;
-- Should match: Lean ~$11, Standard ~$23, Cloud ~$156

-- 5. Confirm profitability thresholds
SELECT scenario, stream, units_to_breakeven FROM public.stream_breakeven ORDER BY scenario, units_to_breakeven;
-- Should show Lean: 1–2 units, Standard: 2–10 units, Cloud: 8–30 units
```

---

## Action Items for CFO

- [ ] Load all scenario costs into `public.scenario_costs` table
- [ ] Initialize `public.daily_cost_revenue_tracker` with Day 0 (2026-03-29)
- [ ] Load breakeven data into `public.stream_breakeven` table
- [ ] Create daily automated query (run at 23:59 UTC each day)
- [ ] Set up weekly report in standup template
- [ ] Monitor runway daily; alert if dropping below 15 days
- [ ] Recommend scenario upgrade when triggers hit (e.g., $150+/mo revenue)

---

**CFO: Ready to execute cost tracking immediately.**
