# DELIVERABLE 1: LIVE PROFIT DASHBOARD

**Created:** 2026-03-30 00:50 AM
**Status:** READY TO DEPLOY
**Connection:** Awaiting CTMO PostgreSQL queries
**Update Frequency:** Daily 6:00 AM (automated)

---

## DASHBOARD SHEET 1: Daily Profit Summary

**Purpose:** CFO opens daily 6:00 AM, sees profit/loss by stream in 10 seconds

**Template (Copy to Google Sheets or Excel):**

```
DATE         | P1_REVENUE | P1_COSTS | P1_PROFIT | P2_REVENUE | P2_COSTS | P2_PROFIT | P3_REVENUE | P3_COSTS | P3_PROFIT | TOTAL_PROFIT | STATUS
-------------|------------|----------|-----------|------------|----------|-----------|------------|----------|-----------|---|---
2026-03-31   | $0         | $0       | $0        | $0         | $0       | $0        | $0         | $25      | -$25      | -$25         | 🔴 P3 losing
2026-04-01   | $50        | $0       | $50       | $0         | $0       | $0        | $30        | $25      | $5        | $55          | ✅ Positive
2026-04-02   | $75        | $0       | $75       | $0         | $0       | $0        | $0         | $25      | -$25      | $50          | 🟡 Watch
2026-04-03   | $100       | $0       | $100      | $1,200     | $400     | $800      | $15        | $25      | -$10      | $890         | ✅ Strong
```

**SQL Queries to Populate (CTMO provides these):**

```sql
-- P1 Daily Revenue
SELECT SUM(net_amount) as P1_REVENUE
FROM digital_products.sales
WHERE DATE(sale_date) = CURRENT_DATE;

-- P2 Daily Revenue (manual entry from invoices)
SELECT SUM(amount) as P2_REVENUE
FROM p2_invoices
WHERE DATE(invoice_date) = CURRENT_DATE
AND status = 'paid';

-- P3 Daily Revenue (manual from affiliate dashboards)
-- [Manual entry from Gumroad Affiliate, Impact.com, etc.]

-- Daily Costs (fixed daily cost allocation)
-- P1 costs: $0 (digital product, no COGS)
-- P2 costs: Manual entry (contractor labor, if used)
-- P3 costs: $25/day allocated ($750/month ÷ 30 days for hosting)
```

**Formulas:**

```
P1_PROFIT = P1_REVENUE - P1_COSTS
P2_PROFIT = P2_REVENUE - P2_COSTS
P3_PROFIT = P3_REVENUE - P3_COSTS
TOTAL_PROFIT = P1_PROFIT + P2_PROFIT + P3_PROFIT

STATUS = IF(TOTAL_PROFIT < 0, "🔴 NEGATIVE", IF(TOTAL_PROFIT < 50, "🟡 YELLOW", "✅ POSITIVE"))
```

**Conditional Formatting:**
- Red if TOTAL_PROFIT < $0
- Yellow if TOTAL_PROFIT $0-$50
- Green if TOTAL_PROFIT > $50

---

## DASHBOARD SHEET 2: Profit by Product (Detailed Breakdown)

**Purpose:** Identify which individual products are losing money

**Template:**

```
PRODUCT_NAME       | REVENUE | UNIT_COST | UNITS | GROSS_PROFIT | MARGIN_% | ACTION
-------------------|---------|-----------|-------|------|------|----
P1_Bundle_$39      | $117    | $0        | 3     | $117 | 100% | ✅ KEEP
P1_ColdEmail_$19   | $76     | $0        | 4     | $76  | 100% | ✅ KEEP
P1_Magnet_Free     | $0      | $50 labor | —     | -$50 | -∞   | ⚠️ WATCH (funnel product, count email value)
P2_Client_ACME     | $1,200  | $400      | 1mo   | $800 | 67%  | ✅ KEEP
P2_Client_Beta     | $0      | $0        | trial | $0   | —    | ⏳ WATCH (30-day trial ongoing)
P3_Article_1       | $15     | $150      | —     | -$135| -900%| 🔴 PAUSE (content eating costs)
P3_Article_2       | $30     | $150      | —     | -$120| -400%| 🔴 PAUSE (waiting for organic growth)
P3_Backlink_Live   | $0      | $0        | —     | $0   | —    | ⏳ WATCH (partnership pending)
```

**Decision Logic:**

```
IF margin < 40% AND revenue > $100 → Consider raising price or cutting costs
IF margin > 60% → Scale (increase marketing spend)
IF revenue = $0 AND costs > $0 → Kill or restructure within 2 weeks
IF revenue ramping but not profitable yet (P3) → Hold, review at Day 30
```

---

## DASHBOARD SHEET 3: Running Cumulative (For Recovery Goal Tracking)

**Purpose:** Track progress toward $10,000 recovery goal

```
DATE       | DAY | P1_CUM | P2_CUM | P3_CUM | TOTAL_CUM | DAILY_AVG | PACE_TO_$10K | STATUS
-----------|-----|--------|--------|--------|-----------|-----------|---|---
2026-03-31 | 1   | $50    | $0     | $0     | $50       | $50       | 200 days      | 🔴 RED (need $50/day minimum)
2026-04-01 | 2   | $125   | $1,200 | $30    | $1,355    | $677.50   | 15 days       | ✅ ON PACE
2026-04-02 | 3   | $200   | $1,200 | $30    | $1,430    | $477      | 21 days       | ✅ ON PACE
2026-04-03 | 4   | $300   | $2,400 | $60    | $2,760    | $690      | 14 days       | ✅ AHEAD
```

**Formula:**
```
TOTAL_CUM = P1_CUM + P2_CUM + P3_CUM (running sum)
DAILY_AVG = TOTAL_CUM / DAY (average per day)
PACE_TO_$10K = $10,000 / DAILY_AVG (days to goal at current pace)

Alert: IF PACE_TO_$10K > 90, escalate to CEO ("We're behind pace, need acceleration")
Alert: IF DAILY_AVG < $50, escalate to CEO ("We're below minimum velocity for survival")
```

---

## CFO DAILY ROUTINE (3 minutes)

**Every morning 6:00 AM:**

1. Open Dashboard Sheet 1
2. Look for red cells (negative profit)
   - If red today: Check which product is losing (Sheet 2)
   - Take immediate action: Kill, pause, or reposition
3. Look at cumulative pace (Sheet 3)
   - If PACE > 90 days: Escalate to CEO
   - If on track: Continue execution
4. Note decisions in Decision Log (Sheet 4)

**Example morning (2026-04-02):**
```
6:00 AM: Open dashboard
- P1 profit: $75 ✅
- P2 profit: $0 (no closes yet, expected)
- P3 profit: -$25 (content costs)
- Total: $50 ✅ POSITIVE

Sheet 2: P3_Article_1 is losing $135. Check: content is only 2 days old.
→ Decision: HOLD (too early to kill, check at Day 14)

Sheet 3: Pace is 21 days to $10k, on track ✅

Decision Log: "P3 content negative M1, expected. Hold until Day 30 review."
```

---

## DECISION LOG (Sheet 4: Keep for History)

**Purpose:** Document every financial decision made for review at Day 30/60/90

```
DATE       | DECISION          | REASONING                          | APPROVED_BY | OUTCOME
-----------|-------------------|-----------------------------------|-------------|---
2026-04-02 | HOLD P3 content   | Only 2 days old, content is sunk cost; check again at Day 30 | CFO | WATCH
2026-04-05 | KILL P1_Magnet    | Funnel failing, email opt-in <5%, CAC too high | CEO | REVENUE -$0 (was breakeven), freed 5 hrs labor
2026-04-10 | SCALE P2 outreach | 2 closes in 10 days, CAC $400, LTV $3,600 = 9:1 ROI | CEO | ADDED 10 hrs outreach
```

---

## SUCCESS CRITERIA

✅ Dashboard auto-updates daily 6:00 AM (CTMO connection live)
✅ CFO reads it in 1 minute, sees profit/loss by stream
✅ Red alerts trigger immediate escalation
✅ Decision log tracks every financial call for review at Day 30

**[DELIVERABLE 1 COMPLETE — READY TO DEPLOY]**
