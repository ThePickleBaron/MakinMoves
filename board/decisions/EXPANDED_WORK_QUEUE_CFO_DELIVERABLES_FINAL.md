# CFO — EXPANDED Work Queue with Profit-Optimizing Systems
**Time Block:** 8:45 PM – 10:00 PM (75 minutes)
**Standard:** Match COO's execution — operational systems that drive decisions (not analysis)
**Deliverables Location:** Deployed dashboards + documents in `../financial/`

---

## WHAT SUCCESS LOOKS LIKE

COO delivered:
- 5 products (live + ready)
- Landing page (ready to deploy)
- Articles (ready to paste)
- Dashboard (live tracking)

**You deliver:**
- Live profit dashboard (shows what to kill)
- Profitability model (which products are losing money)
- Alert system (fires when bad things happen)
- Monthly review (decisions documented)

**All 4 systems are operational by 10:00 PM. CFO uses them daily to optimize profit.**

---

## DELIVERABLE #1: Live Profit Dashboard (8:45–9:05 PM)
**Output Status:** ✅ CONNECTED & AUTO-ALERTING

Create Google Sheet that shows profit/loss per product in real-time:

```
SHEET 1: Daily Profit Summary (Updates from CTMO's database)

Date         | P1_Revenue | P1_Costs | P1_Profit | P2_Revenue | P2_Costs | P2_Profit | P3_Revenue | P3_Costs | P3_Profit | TOTAL_PROFIT | Status
2026-03-30   |   $37      |  $0      |  $37      |   $0       |  $0      |   $0      |    $0      |  $20     |   -$20    |    $17       | ⚠️ (P3 losing)
2026-03-31   |   $74      |  $0      |  $74      |   $0       |  $0      |   $0      |   $12      |  $20     |    -$8    |    $66       | ✅ Positive
2026-04-01   |   $111     |  $0      |  $111     |   $1200    | $400     |  $800     |   $45      |  $15     |    $30    |   $1941      | ✅ Strong

FORMULAS:
- P1_Revenue = IMPORTDATA from CTMO database (auto-updated)
- P1_Costs = $0 (no COGS)
- P1_Profit = P1_Revenue - P1_Costs
- P2_Revenue = Manual entry (from invoices) OR auto from Stripe
- P2_Costs = Manual entry (writer payments)
- P2_Profit = P2_Revenue - P2_Costs
- P3_Revenue = Manual entry (from affiliate dashboards)
- P3_Costs = $20/site/month = $60/month
- P3_Profit = P3_Revenue - P3_Costs
- TOTAL_PROFIT = All profits summed
- Status = Conditional formatting (red if negative, yellow if <$50, green if >$50)

---

SHEET 2: Profit by Product

Product_Name        | Revenue | Unit_Cost | Units_Sold | Gross_Profit | Margin_%  | Action
P1_Template_A       | $37     | $0        | 1          | $37          | 100%      | ✅ KEEP
P1_Template_B       | $0      | $0        | 0          | $0           | 0%        | 🔴 KILL (no sales)
P2_Client_ACME      | $1200   | $400      | 1          | $800         | 67%       | ✅ KEEP (ideal margin)
P2_Client_Startup   | $0      | $0        | 0 (in progress) | $0      | —         | ⏳ WATCH (30-day trial)
P3_Site_Niche_1     | $45     | $20       | —          | $25          | 56%       | ✅ HOLD (growing)
P3_Site_Niche_2     | $0      | $20       | —          | -$20         | -100%     | 🔴 PAUSE (unprofitable)
```

**Setup Steps:**
1. Create Google Sheet "MakinMoves Profit Dashboard"
2. Connect to CTMO's database (CTMO provides query, CFO plugs into sheet)
3. Manual entries: P2 revenue (from invoices), P3 revenue (from affiliate dashboards)
4. Set conditional formatting: <$0 = RED, $0–$50 = YELLOW, >$50 = GREEN

**Daily Routine (3 minutes):**
1. Open dashboard, check yesterday's profit
2. If any red cells: Decide what to do (kill, pause, fix)
3. Note action in "Decision Log" sheet

**Post to standup: 9:05 PM** with screenshot of dashboard + profit/loss summary

---

## DELIVERABLE #2: Unit Economics & Kill/Keep Decisions (9:05–9:27 PM)
**Output Status:** ✅ OPERATIONAL & DECISION-READY

Create model that tells you exactly which products to kill:

```
SHEET 1: Product Profitability (Fill daily from Profit Dashboard)

Product             | Revenue | COGS     | Margin% | Units | LTV    | CAC    | LTV:CAC | Decision
P1_Template_A       | $37     | $0       | 100%    | 1     | $37    | $0     | ∞       | ✅ SELL MORE
P1_Template_B       | $0      | $0       | 0%      | 0     | $0     | $0     | —       | 🔴 KILL (no demand)
P1_Template_C       | $111    | $0       | 100%    | 3     | $37    | $0     | ∞       | ✅ SELL MORE
—
P2_Client_ACME      | $1200   | $400     | 67%     | 1mo   | $2400  | $400   | 6:1     | ✅ KEEP (ideal)
P2_Client_Startup   | $800    | $400     | 50%     | 1mo   | $2400  | $800   | 3:1     | ⚠️ RENEGOTIATE (below 60%)
—
P3_Site_Niche_1     | $45     | $20      | 56%     | —     | TBD    | $0     | —       | ✅ HOLD (growing)
P3_Site_Niche_2     | $0      | $20      | -100%   | —     | -$20   | $0     | —       | 🔴 PAUSE (unprofitable)
```

**Decision Rules (Use These Every Day):**

```
RULE 1: Gross Profit Margin
IF margin < 40%: 🔴 KILL or RAISE PRICE
IF margin 40–60%: ⚠️ RENEGOTIATE or CUT COSTS
IF margin >60%: ✅ KEEP & EXPAND

→ Application: P2_Client_Startup at 50% margin → Tell CEO to renegotiate to $1,200 or higher, or drop

---

RULE 2: Customer LTV vs CAC
IF LTV < CAC: 🔴 KILL IMMEDIATELY (losing money per customer)
IF LTV 1–2x CAC: ⚠️ TOO EXPENSIVE TO ACQUIRE (raise price or cut CAC)
IF LTV 3x+ CAC: ✅ HEALTHY (expand marketing)

→ Application: P2_Client_ACME has LTV $2,400, CAC $400 (6:1 ratio) → HEALTHY, scale this customer type

---

RULE 3: Time to Profitability
P1: Breakeven at 0 units (pure profit) → SCALE
P2: Breakeven at 1 client × $800+/mo → Sustainable if CAC <$500
P3: Breakeven at 400 clicks/month per site → Needs 6–12 months of traffic growth

→ If any stream hasn't hit breakeven by Day 30: Reassess niche viability

---

RULE 4: Runway Protection
Cumulative Revenue - Cumulative Costs = Cash Position
Burn Rate = Monthly costs - Monthly revenue

IF runway < 4 months: 🔴 ESCALATE TO CEO (pivot or cut costs)
IF runway 4–6 months: ⚠️ MONITOR (increase revenue or trim costs)
IF runway >6 months: ✅ HEALTHY (focus on growth)

→ If at Day 30 runway has dropped: Identify which stream is unprofitable, kill it or improve pricing

---

RULE 5: Kill Decision
KILL a product IF:
- Gross margin <30% AND can't raise price
- Negative profit for 2+ weeks in a row
- LTV <1x CAC AND can't improve
- Runway at risk (not contributing to revenue goals)

→ When you KILL: Document the reason, keep the learnings for next pivot
```

**Monthly Reconciliation (Due by Day 30/60/90):**

```
SHEET 2: Monthly P&L (Filled on last day of month)

              | Expected | Actual | Variance | Why?
P1_Revenue    | $200     | $185   | -$15     | Slow first week
P2_Revenue    | $2,000   | $2,400 | +$400    | 2 clients closes (beat target)
P3_Revenue    | $200     | $45    | -$155    | SEO slower than expected
Total Revenue | $2,400   | $2,630 | +$230    |
—
Total Costs   | $200     | $150   | -$50     | (savings)
—
PROFIT        | $2,200   | $2,480 | +$280    | BEAT TARGET ✅
CUMULATIVE    | $2,630   | $2,630 | —        | (on pace for $10k by Day 90)
```

**Post to standup: 9:27 PM** with unit economics + kill/keep decisions + next action

---

## DELIVERABLE #3: Alert System (Auto-Fires When Bad) (9:27–9:42 PM)
**Output Status:** ✅ CONFIGURED & MONITORING

Create automated alerts that tell CFO when to escalate:

```
SHEET 1: Alert Configuration (Auto-checks daily against thresholds)

Alert_Name              | Trigger                    | Alert Level | Action | Owner
P1_Low_Conversion       | <2% after 100 visitors     | 🔴 CRITICAL | Stop ads, revise messaging | CEO
P1_No_Sales             | $0 for 2 days in a row     | 🟡 WARNING  | Check Gumroad, test lower price | COO
—
P2_High_CAC             | CAC >$700                  | 🔴 CRITICAL | STOP paid ads immediately | CEO + CFO
P2_No_Leads             | 0 leads for 3 days         | 🟡 WARNING  | Increase outreach volume | COO
P2_Low_Close_Rate       | <20% conversion on leads   | 🔴 CRITICAL | Revise pitch, add case study | CEO
—
P3_No_Traffic           | <50 visitors/day at Day 7  | 🟡 WARNING  | Increase content frequency | COO
P3_Not_Indexing         | <50% pages indexed by Week 3 | 🔴 CRITICAL | Technical SEO audit | CTMO
—
ALL_Negative_Profit     | Daily profit <$0           | 🟡 WARNING  | Identify which stream(s) | CFO
ALL_Runway_Risk         | Runway <4 months           | 🔴 CRITICAL | ESCALATE to CEO for decision | CFO → CEO
ALL_Missing_Goal        | On pace to miss $10k by Day 90 | 🔴 CRITICAL | Strategic review + pivot plan | CEO

---

SHEET 2: Alert Trigger Formula (Auto-calculates)

Formula: IF(actual_value < threshold, "🔴 ALERT", "✅ OK")

P1_Conversion_Alert = IF(P1_Conversion < 0.02, "🔴 CRITICAL: Conversion <2%", "✅ OK")
P2_CAC_Alert = IF(P2_CAC > 700, "🔴 CRITICAL: CAC >$700, STOP ADS", "✅ OK")
Runway_Alert = IF(Monthly_Burn > (Cash_Position / 4), "🔴 CRITICAL: <4 months runway", "✅ OK")

---

SHEET 3: Alert Log (Record when alerts fire)

Date      | Alert_Name          | Value | Threshold | Severity | Action_Taken | Outcome
2026-04-01| P1_No_Sales         | $0    | >$50      | 🟡 WARN  | Tested lower price ($27) | Sales picked up
2026-04-02| P2_CAC              | $850  | <$700     | 🔴 CRIT  | Paused Google Ads         | CAC dropped to $600
2026-04-05| P3_Traffic          | 120   | >500      | 🟡 WARN  | Increased article frequency | On track for target
```

**Daily Alert Check (1 minute):**
1. Open dashboard
2. Look for red/yellow cells
3. If red: Execute action immediately, document outcome
4. If yellow: Monitor trend, escalate if worsens

**Post to standup: 9:42 PM** with alerts fired today + actions taken

---

## DELIVERABLE #4: Monthly Financial Review Template (9:42–10:00 PM)
**Output Status:** ✅ DOCUMENTED & REPEATING

Create review template CFO fills out at Day 30/60/90:

```markdown
# Monthly Financial Review — Day 30 (April 30, 2026)

## Revenue & Profitability
- **Total Revenue (Month):** $[X]
- **Cumulative Revenue (start → today):** $[Y]
- **Total Profit (Month):** $[Z]
- **Gross Margin (overall):** [%]
- **On pace for $10k recovery goal?** YES / NO

---

## Stream Performance (Month 1 – April)

### P1: Digital Products
- **Revenue:** $500
- **Units sold:** 7
- **Conversion rate:** 2.1%
- **Avg price:** $71.43
- **Action:** ✅ On target, test $47 tier next month

### P2: Freelance Writing
- **Revenue:** $2,400
- **Active clients:** 2
- **New closes this month:** 2
- **CAC:** $400
- **Margin:** 67%
- **Action:** ✅ Exceeding target, scale outreach in May

### P3: Affiliate Marketing
- **Revenue:** $45
- **Traffic:** 890 visitors
- **Affiliate commission rate:** 5%
- **Articles published:** 15
- **Action:** ⚠️ Behind target on traffic, increase content velocity in May

---

## Cost Analysis (Month 1)

| Category | Budget | Actual | Variance |
|----------|--------|--------|----------|
| Hosting | $20 | $15 | -$5 (savings) |
| Tools | $50 | $45 | -$5 (savings) |
| Ads | $0 | $0 | — |
| **TOTAL** | **$70** | **$60** | **-$10** |

**Monthly Burn Rate:** $60 (under forecast of $150)
**Runway:** 15+ months at current burn ✅

---

## Customer Economics

### P1 (Digital Products)
- **LTV per customer:** $37–$111
- **Repeat purchase rate:** 0% (not applicable for one-time products)
- **Action:** Upsell P1 buyers to P2 (cross-sell campaign in May)

### P2 (Freelance Writing)
- **LTV (3-month contract):** $3,600–$4,800
- **CAC:** $400
- **LTV:CAC ratio:** 9:1 ✅ EXCELLENT
- **Churn risk:** Low (both clients renewing)
- **Action:** Scale customer acquisition, test $1,500 premium tier

### P3 (Affiliate Marketing)
- **Visitor acquisition cost:** <$1 (organic + backlinks)
- **Revenue per visitor:** $0.05 (target: $0.10 by Month 3)
- **Action:** Increase content, backlinks, focus on high-commission programs

---

## Decision Points (What Changed This Month?)

**Decision 1: Kill P1_Template_B?**
- Status: No sales, 0% conversion
- Recommendation: KILL or pivot to new niche
- Approved by: CEO
- Action: Removing from Gumroad by May 1

**Decision 2: Scale P2 outreach?**
- Status: 2 closes in Month 1, CAC $400, LTV $3,600
- Recommendation: DOUBLE outreach budget
- Approved by: CEO + CFO
- Action: Increase cold email volume by 2x in May

**Decision 3: Pause P3_Site_Niche_2?**
- Status: $0 revenue, $20/mo hosting cost
- Recommendation: PAUSE (not killing, just pause content)
- Approved by: CEO
- Action: Stop publishing new articles, maintain 1x/month minimum

---

## Go/No-Go Decision (Continue or Pivot?)

**Question:** Are we on track for $10k recovery goal by Day 90?

**Current Status:**
- Cumulative revenue: $2,945
- Pace: $9,816 by Day 90 (conservative estimate)
- Confidence: HIGH ✅

**Recommendation:** CONTINUE ALL STREAMS
- P1 is healthy, test premium tier
- P2 is exceeding, scale it
- P3 is slow but early, give it more time

---

## Next Month's Priorities (May 1–31)

1. **P1:** Launch $47 "pro" tier, discontinue underperforming template
2. **P2:** Double outreach, test $1,500 premium, get 1 more client close
3. **P3:** Publish 20+ articles total, launch backlink campaign, target 2k visitors
4. **Revenue target:** $7,000 cumulative (on pace for $11.5k by Day 90)
5. **Profit target:** $6,500 (after costs)

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| P1 conversion drops | 20% | Medium | Pivot niche, test pricing, run ads |
| P2 customer churn | 15% | Medium | Increase touchpoints, case studies |
| P3 SEO stalls | 30% | Low | Increase content, backlinks, affiliate programs |
| Cash burn exceeds forecast | 10% | High | Cut costs, focus on P2 (highest ROI) |

---

## Next Review Date: May 30 (Day 60)

Target metrics by Day 60:
- P1: $1,500 cumulative
- P2: $5,000 cumulative (5+ clients)
- P3: $500 cumulative (5k+ visitors)
- Total: $7,000 cumulative ✅

---

**Prepared by:** CFO
**Reviewed by:** CEO
**Date:** April 30, 2026
**Next review:** May 30, 2026
```

**Post to standup: 10:00 PM** with completed review + next month targets

---

## SUMMARY

| Deliverable | Type | Status | Ready to Use? |
|-------------|------|--------|---------------|
| 1. Profit Dashboard | Google Sheets (Live) | ✅ CONNECTED | Daily view of profit/loss |
| 2. Unit Economics | Model (Decision-Ready) | ✅ OPERATIONAL | Kill/keep decisions daily |
| 3. Alert System | Auto-Triggers | ✅ MONITORING | Alerts fire when thresholds crossed |
| 4. Monthly Review | Template (Recurring) | ✅ DOCUMENTED | Decision log at Day 30/60/90 |

**All 4 systems are operational by 10:00 PM. CFO has everything needed to optimize profit and catch problems early.**

---

## SUCCESS CRITERIA

✅ Dashboard is **live and showing profit/loss by product** (CFO opens, sees red/green alerts)
✅ Unit economics are **decision-ready** (CFO knows which products to kill)
✅ Alerts are **auto-firing when thresholds crossed** (no manual checks, just react to alerts)
✅ Monthly review is **repeatable** (same questions at Day 30/60/90, tracks decisions made)

**CFO owns financial controls that prevent bad decisions, optimize profit, and keep recovery goal on track.**
