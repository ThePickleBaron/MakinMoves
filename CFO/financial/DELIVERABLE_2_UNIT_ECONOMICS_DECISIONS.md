# DELIVERABLE 2: UNIT ECONOMICS & KILL/KEEP DECISIONS

**Created:** 2026-03-30 01:00 AM
**Status:** READY TO DEPLOY
**Update Frequency:** Daily (monitor), Monthly (decision review)
**Authority:** CFO can KILL products unilaterally (funds preserved)

---

## OPERATIONAL DECISION RULES

**Use these rules EVERY TIME you see a product**

### RULE 1: Gross Profit Margin

```
IF Margin > 60%:  ✅ KEEP & SCALE (increase budget, double down)
IF Margin 40-60%: ⚠️ RENEGOTIATE (raise price or cut costs by 20%)
IF Margin < 40%:  🔴 KILL or RESTRUCTURE (not sustainable)
```

**Example Applications:**
- P1 at 100% margin → SCALE (digital has no COGS)
- P2 at 67% margin ($1,200 revenue, $400 labor) → KEEP (healthy)
- P2 at 50% margin → RENEGOTIATE (needs to hit 60%+ or reduce labor)
- P3 at -100% margin (content costing more than revenue) → PAUSE (will fix M4-6 when organic grows)

---

### RULE 2: Customer LTV vs CAC (Unit Economics Ratio)

```
IF LTV < 1x CAC:    🔴 KILL IMMEDIATELY (losing money per customer, mathematically doomed)
IF LTV 1-2x CAC:    ⚠️ TOO EXPENSIVE (break-even only, no profit margin)
IF LTV 3-5x CAC:    ✅ HEALTHY (sustainable, profitable)
IF LTV > 5x CAC:    ✅✅ EXCELLENT (scale aggressively)
```

**Example Applications:**
- P1: LTV $39, CAC $0 (organic) = ∞ ratio → SELL MORE
- P2 warm: LTV $1,200, CAC $280 = 4.3:1 → SCALE
- P2 cold: LTV $1,200, CAC $5,500 = 0.22:1 → KILL (mathematically broken)
- P3 organic: LTV $50 (year 1 affiliate), CAC $1,800 (upfront content) = 0.03:1 early, 15:1 year 2+ → HOLD (negative early, positive later)

---

### RULE 3: Payback Period (How Long to Recover CAC?)

```
Payback = CAC / (Revenue - COGS per customer)

IF Payback < 30 days:    ✅ EXCELLENT (get money back quick, can reinvest)
IF Payback 30-90 days:   ⚠️ ACCEPTABLE (takes 1-3 months, needs patience)
IF Payback > 90 days:    🔴 RED (takes 3+ months, cash flow risk)
IF Payback impossible:   🔴 KILL (LTV < CAC, will never recover)
```

**Example:**
- P1: Revenue $39, COGS $0 → Payback = $0 / $39 = 0 days (instant) ✅
- P2: Revenue $1,200, COGS $400 → Payback = $280 / ($1,200 - $400) = $280 / $800 = 0.35 months = 10 days ✅
- P3 content: Revenue $50, COGS $0 → Payback = $1,800 / $50 = 36 months (3 YEARS) → HOLD only because it's a long-tail asset

---

## PRODUCT SCORECARD (Use Monthly)

**Template (Fill in actual numbers from Dashboard):**

```
PRODUCT        | REVENUE | COGS | MARGIN% | UNITS | CAC   | LTV    | LTV:CAC | PAYBACK | DECISION
---------------|---------|------|---------|-------|-------|--------|---------|---------|---
P1_Bundle_$39  | $180    | $0   | 100%    | 5     | $0    | $36    | ∞       | 0 days  | ✅ SELL MORE
P1_ColdEmail   | $95     | $0   | 100%    | 5     | $0    | $19    | ∞       | 0 days  | ✅ SELL MORE
P1_Magnet      | $0      | $50  | -∞      | —     | $50   | $0     | 0:1     | —       | ⚠️ FUNNEL (not revenue product)
—
P2_Client_A    | $1,200  | $400 | 67%     | 1mo   | $280  | $1,200 | 4.3:1   | 10 days | ✅ SCALE (warm email working)
P2_Client_B    | $800    | $400 | 50%     | 1mo   | $800  | $800   | 1:1     | ∞       | 🔴 BREAK-EVEN (renegotiate to $1,200 or drop)
—
P3_Article_1   | $12     | $150 | -1150%  | —     | —     | TBD    | —       | 300 mo  | 🔴 PAUSE (kill this article)
P3_Article_2   | $24     | $150 | -525%   | —     | —     | TBD    | —       | 225 mo  | 🔴 PAUSE (kill this article)
P3_Backlinks   | $0      | $0   | —       | —     | —     | TBD    | —       | —       | ⏳ WATCH (in progress)
```

---

## MONTHLY CHANNEL DECISION REVIEW (Use at End of Month)

**Which channels to fund next month? Which to kill?**

```
CHANNEL          | M1_REVENUE | M1_CAC | M1_ROI | M2_RECOMMENDATION | ACTION | BUDGET_CHANGE
-----------------|------------|--------|--------|---|---|---
P1 Email (warm)  | $180       | $0     | ∞      | SCALE             | ✅ Double marketing spend | +$50
P1 Organic       | $95        | $20    | 4.75x  | SCALE             | ✅ Publish 2x articles/wk | +$100
P1 Referral      | $40        | $5     | 8x     | SCALE             | ✅ Increase commission? | +$10
—
P2 Warm Email    | $1,200     | $280   | 4.3x   | SCALE             | ✅ More outreach | +$0 (organic)
P2 Cold Email    | $0         | N/A    | N/A    | KILL               | 🔴 Stop pursuing | -$0
P2 LinkedIn      | $0         | N/A    | N/A    | TEST (secondary)  | ⏳ Only if warm stalls | $0 contingency
—
P3 Organic       | $36        | $300   | 0.12x  | HOLD (long-term)  | ✅ Continue content | +$150
P3 Paid Ads      | $0         | $100   | 0x     | KILL               | 🔴 No conversions | -$100
P3 Backlinks     | $0         | $0     | N/A    | DEVELOP (in progress) | ⏳ 5 partnerships pending | $0

TOTAL_BUDGET_CHANGE: +$260/month (increase investment in best channels)
```

---

## KILL DECISION (When to Shut Down a Product)

**Kill a product ONLY if it meets 2+ of these criteria:**

1. ❌ Gross margin < 30% AND can't raise price
2. ❌ Negative profit for 3+ weeks in a row
3. ❌ LTV < 1x CAC AND no improvement path
4. ❌ Runway at risk (not contributing to recovery goal)
5. ❌ Opportunity cost (resources could be used for 10x better channel)

**Kill Decision Document (File When Killing):**

```markdown
## KILL DECISION — [Product Name]

**Date:** 2026-04-05
**Product:** P3_Article_1
**Reason:**
- Revenue: $12 (too low)
- Costs: $150 (content labor)
- Margin: -1150% (unsustainable)
- Payback: 300 months (impossible)
- Alternative: Delete article, repurpose labor to high-performing articles

**Approved By:** CFO
**Funds Preserved:** $150 content labor redirected to P3_Article_5 (higher potential)
**Timeline:** Remove from site by 2026-04-06
**Learnings:** Avoid low-traffic niches; focus on keywords with >100 monthly searches
```

---

## SCALE DECISION (When to Increase Investment)

**Scale a product when:**

1. ✅ LTV ≥ 3x CAC (healthy unit economics)
2. ✅ Payback ≤ 30 days (quick money recovery)
3. ✅ Margin ≥ 60% (sustainable profitability)
4. ✅ Trend is up (velocity improving week-over-week)
5. ✅ Runway is positive (not risking cash flow)

**Scale Decision Document:**

```markdown
## SCALE DECISION — P2 Warm Email

**Date:** 2026-04-10
**Metric:** 2 closes in 10 days
**Unit Economics:**
- CAC: $280
- LTV: $1,200
- ROI: 4.3x
- Payback: 10 days ✅

**Recommendation:** Double outreach
- Current: 50 cold emails/week
- New: 100 cold emails/week
- Expected closes: 4/week → 2 closes → +$2,400/month

**Approved By:** CEO
**Budget Change:** +$200/month (additional labor)
**Timeline:** Ramp by 2026-04-15

**Success Criteria:**
- Maintain CAC ≤ $500 (don't degrade with scale)
- Maintain close rate ≥ 25% (same quality)
- Hit 8-10 closes by end of M2
```

---

## MONTHLY KILL/KEEP/SCALE DECISION (To File at Day 30/60/90)

**Use this template every month on the last day:**

```markdown
# Unit Economics Review — April 30, 2026 (Day 30)

## Kill Decisions (Effective May 1)
- [ ] P3_Article_1: -1150% margin → Kill (save $150/mo)
- [ ] P3_Article_2: -525% margin → Kill (save $150/mo)
- [ ] P1_Magnet: Funnel failing (0% email opt-in) → Kill funnel, replace with giveaway

## Keep Decisions
- [✅] P1_Bundle: 100% margin, infinite ROI → Continue
- [✅] P2_Warm: 4.3x ROI → Continue
- [✅] P3_Organic: Negative M1 (expected), project +$50/article by M4 → Hold

## Scale Decisions
- [✅] P2_Warm: 2 closes/10 days, 4.3x ROI → Double outreach by May 1
- [✅] P1_Email: Warm list at 150, natural growth → Increase email frequency 2x/week

## Budget Reallocation
- Freed from kills: $300/mo (articles + magnet)
- Allocate to scales:
  - P2 outreach: +$200/mo
  - P1 content: +$100/mo
  - Reserve: $0 (none available)

## Confidence Level
- P1: HIGH ✅ (revenue proven, margin excellent)
- P2: HIGH ✅ (closes proven, CAC low, LTV high)
- P3: MEDIUM ⚠️ (early stage, betting on organic growth M4+)
```

---

## SUCCESS CRITERIA

✅ Unit economics scorecard updated monthly (Day 30/60/90)
✅ Kill decisions documented (products removed, labor freed)
✅ Scale decisions documented (budget increases justified)
✅ CFO can kill a product in 30 minutes (decision → approval → execution)
✅ Every financial decision is traced back to unit economics

**[DELIVERABLE 2 COMPLETE — READY TO DEPLOY]**
