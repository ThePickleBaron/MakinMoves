# Recovery Percentage Calculation — CFO Reference

**Purpose:** Understand exactly how recovery % is calculated and tracked

---

## THE MATH (Simple)

```
Recovery % = (Total Revenue To Date / $10,000 Goal) × 100
```

### Example

**Day 1:** $50 revenue
- Calculation: ($50 / $10,000) × 100 = **0.5%**

**Day 7:** $500 total revenue
- Calculation: ($500 / $10,000) × 100 = **5%**

**Day 30:** $2,500 total revenue
- Calculation: ($2,500 / $10,000) × 100 = **25%**

---

## HOW IT'S TRACKED IN DATABASE

### `daily_revenue` Table (CFO Core)

Each row represents one day. Columns:

```sql
CREATE TABLE public.daily_revenue (
    date DATE PRIMARY KEY,
    digital_products DECIMAL(10,2),      -- Revenue from digital products today
    saas_mrr DECIMAL(10,2),             -- Monthly recurring revenue today
    content DECIMAL(10,2),              -- Affiliate/AdSense today
    trading_pnl DECIMAL(10,2),          -- Trading profit/loss today
    total DECIMAL(10,2),                -- Sum of all 4 streams today
    costs DECIMAL(10,2),                -- Operating costs today
    net DECIMAL(10,2),                  -- Profit (total - costs)
    cumulative_revenue DECIMAL(10,2),   -- SUM(total) from start to today
    recovery_pct DECIMAL(5,2),          -- (cumulative / 10000) × 100
    updated_at TIMESTAMP
);
```

### Example Data

```
Date       | DP    | SaaS | Content | Trading | Total | Cumulative | Pct
-----------|-------|------|---------|---------|-------|------------|--------
2026-03-29 | $100  | $0   | $0      | $0      | $100  | $100       | 1.00%
2026-03-30 | $150  | $50  | $30     | $0      | $230  | $330       | 3.30%
2026-03-31 | $200  | $50  | $50     | $20     | $320  | $650       | 6.50%
2026-04-01 | $80   | $100 | $40     | $0      | $220  | $870       | 8.70%
```

---

## AUTOMATED UPDATES (n8n Workflows)

### Hourly (Workflow 1: Revenue Sync)

```
At :00 every hour:
  1. Query all 4 revenue sources
  2. Sum into hourly_revenue table
  3. Update daily_revenue for TODAY only:
     - Update digital_products = SUM(hourly revenue for today)
     - Update saas_mrr = SUM(hourly revenue for today)
     - Update content = SUM(hourly revenue for today)
     - Update trading_pnl = SUM(hourly revenue for today)
     - Calculate total = dp + saas + content + trading
```

### Daily (Workflow 3: Recovery Progress — 9am)

```
At 09:00 every day:
  1. Run all daily_revenue from start to today
  2. Calculate cumulative_revenue = SUM(total) for all days
  3. Calculate recovery_pct = (cumulative / 10000) * 100
  4. Update all daily_revenue rows:
     - cumulative_revenue = SUM(total) WHERE date <= that_date
     - recovery_pct = (cumulative / 10000) * 100
```

---

## CFO'S HOURLY CHECK (Query 1)

**Run every hour at standup:**

```sql
SELECT
    goal,                    -- $10,000
    total_recovered,         -- Sum of all revenue to date
    recovery_pct,            -- (total_recovered / goal) * 100
    remaining_to_goal        -- goal - total_recovered
FROM [hourly_dashboard_query]
```

**Output example (Hour 48 of operation):**

```
goal = 10000.00
total_recovered = 2500.00
recovery_pct = 25.00
remaining_to_goal = 7500.00
```

**CFO writes in standup:**
> "Recovery: 25% ($2,500 of $10,000) — On track for June 15"

---

## MILESTONES & THRESHOLDS

### Recovery % Milestones (Trigger Escalation)

When recovery_pct crosses these numbers, n8n alerts CEO:

```
 0% ─────────────────────────────────────────── 100%
 │        │         │         │         │         │
10%      25%       50%       75%       90%      100%
│        │         │         │         │         │
Day 12   Day 30    Day 60    Day 90    Day 108   Day 120
```

### Alert Thresholds (Severity)

When recovery_pct is **below expected**, create alert:

```
Expected velocity: $85/day
Expected at day 30: 30 days × $85 = $2,550 (25.5%)

If actual at day 30: $2,000 (20%)
  → Alert: "Recovery 20% (5.5% below target)" [WARNING]

If actual at day 30: $1,500 (15%)
  → Alert: "Recovery 15% (10.5% below target)" [CRITICAL]
```

---

## DETAILED CALCULATION WALKTHROUGH

### Scenario: First 10 Days of Operation

```
Day 1 (Mar 29):
  ├─ Digital Products: $100
  ├─ SaaS: $0
  ├─ Content: $0
  ├─ Trading: $0
  └─ Daily Total: $100
     → Cumulative: $100
     → Recovery %: (100 / 10000) × 100 = 1.00%

Day 2 (Mar 30):
  ├─ Digital Products: $80
  ├─ SaaS: $50
  ├─ Content: $20
  ├─ Trading: $0
  └─ Daily Total: $150
     → Cumulative: $100 + $150 = $250
     → Recovery %: (250 / 10000) × 100 = 2.50%

Day 3 (Mar 31):
  ├─ Digital Products: $120
  ├─ SaaS: $50
  ├─ Content: $30
  ├─ Trading: $10
  └─ Daily Total: $210
     → Cumulative: $250 + $210 = $460
     → Recovery %: (460 / 10000) × 100 = 4.60%

[... continue through Day 10 ...]

Day 10 Summary:
  Total Revenue (Days 1-10): $1,500
  Recovery %: (1500 / 10000) × 100 = 15.00%
  Days Elapsed: 10
  Daily Average: $150/day
  Days to Goal at this rate: (10000 - 1500) / 150 = 56.7 days
  Projected Completion: Apr 10 + 57 days = June 6
```

---

## KEY FORMULAS (For Reference)

### Daily Aggregate
```
Daily Total = Digital_Products + SaaS_MRR + Content + Trading_PnL
```

### Cumulative (Running Total)
```
Cumulative_Revenue[Day_N] = SUM(Daily_Total) from Day 1 to Day N
```

### Recovery Percentage
```
Recovery_Pct[Day_N] = (Cumulative_Revenue[Day_N] / 10000) × 100
```

### Daily Average (7-day)
```
Daily_Avg_7day = SUM(Daily_Total) for last 7 days / 7
```

### Days to Goal
```
Days_to_Goal = (10000 - Cumulative_Revenue) / Daily_Avg_7day
```

### Projected Completion Date
```
Projected_Date = Today + Days_to_Goal
```

### Revenue Velocity
```
Velocity = Daily_Avg_7day (how much per day, on average)
```

### Cost Ratio
```
Cost_Ratio = (Total_Costs / Total_Revenue) × 100
```

### Profit Margin
```
Profit_Margin = ((Revenue - Costs) / Revenue) × 100
```

---

## WHAT AFFECTS RECOVERY %

### Increases Recovery %
- Any revenue from any stream
- Digital product sales
- New SaaS subscribers
- Affiliate commissions
- Trading profits

### Decreases Recovery % (Relative)
- Does NOT decrease (only increases)
- Note: Costs reduce PROFIT, not recovery %
- Recovery % = cumulative revenue only (not net profit)

### Important Distinction
- **Recovery %** = Revenue / Goal (always increases)
- **Profit %** = (Revenue - Costs) / Revenue (can vary)
- Goal is recovery % (revenue target), not profit %

---

## CFO DAILY WORKFLOW

```
1. At standup time (hourly):
   → Run Query 1 (2 seconds)
   → Extract: recovery_pct, total_recovered, remaining_to_goal
   → Write to standup

2. Daily at 9am:
   → n8n Workflow 3 runs automatically
   → Recalculates cumulative and pct for all days
   → CFO reads updated numbers

3. If recovery % below expected:
   → n8n alerts CFO
   → CFO investigates: which stream underperformed?
   → Report to CEO with recommendations
```

---

## EXAMPLE: 30-DAY PROGRESS REPORT

**Date:** April 28, 2026 (Day 30)

```
RECOVERY GOAL PROGRESS REPORT
═════════════════════════════════════════

TARGET: $10,000
ELAPSED: 30 days
RECOVERED: $2,500

RECOVERY %: 25%
█████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

DAILY AVERAGE: $83.33
DAILY BEST: $250
DAILY WORST: $40

VELOCITY: $83.33/day
DAYS TO GOAL: ~90 days (at current pace)
PROJECTED COMPLETION: June 27, 2026

REVENUE BY STREAM (30 days):
├─ Digital Products: 48% ($1,200)
├─ SaaS (MRR): 32% ($800)
├─ Content/Affiliate: 16% ($400)
└─ Trading: 4% ($100)

COST TRACKING:
├─ Total Costs (30 days): $500
├─ Cost Ratio: 20% (healthy, target < 30%)
├─ Profit Margin: 80%
└─ Net Revenue: $2,000

TREND ANALYSIS:
├─ Week 1 (Days 1-7): $600 (8.6% of goal)
├─ Week 2 (Days 8-14): $700 (10% of goal)
├─ Week 3 (Days 15-21): $600 (8.6% of goal)
├─ Week 4 (Days 22-28): $400 (5.7% of goal) ⚠ Declining
└─ Partial (Days 29-30): $200 (trending lower)

RECOMMENDATIONS:
1. Digital Products declining (stream check needed)
2. SaaS MRR stable (good baseline)
3. Consider doubling marketing spend on top stream
4. Costs well under control (opportunity to invest)

NEXT MILESTONE:
├─ 50% recovery: ~30 days away (May 28)
├─ 75% recovery: ~60 days away (June 27)
└─ 100% recovery (goal): ~90 days away (June 27)
```

---

## VERIFYING CALCULATIONS

**If CFO suspects wrong number:**

1. Run this query:
```sql
SELECT
  SUM(total) as cumulative,
  ROUND((SUM(total) / 10000.0) * 100, 2) as calculated_pct,
  (SELECT recovery_pct FROM public.daily_revenue WHERE date = CURRENT_DATE) as stored_pct
FROM public.daily_revenue
WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1);
```

2. Compare `calculated_pct` with `stored_pct`
   - Should match exactly
   - If not, run Update cumulative query (see autonomous-financial-system.md)

---

## SUMMARY

**Recovery % is:**
- Cumulative revenue divided by $10,000 goal
- Updated hourly as revenue comes in
- Always increases (never decreases)
- CFO's primary success metric
- Automatically calculated by n8n

**CFO's job:**
- Read recovery % hourly (Query 1)
- Watch for deviations from expected velocity
- Escalate if % drops below target
- Celebrate milestones (10%, 25%, 50%, 75%, 90%)

