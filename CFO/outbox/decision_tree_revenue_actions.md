# CFO Decision Tree: Revenue Milestone Actions (April 1–21, 2026)

**Purpose:** Quick-reference guide for CFO to trigger actions when revenue hits key thresholds during launch.

**Usage:** Check daily during 16:00 standup. If cumulative revenue crosses a threshold, execute the corresponding action immediately and alert CEO/COO.

---

## Revenue Milestone Triggers & Actions

### WEEK 1 MILESTONES (April 1–7)

#### Trigger 1.1: Day 1–3 Revenue = $0

**If we have ZERO revenue by end of Day 3:**

```
Threshold: $0 cumulative by April 3, 16:00
Probability: Low (5–10%) but possible if setup delayed

ACTIONS:
1. CFO: Verify platform access (Gumroad, Redbubble logins working?)
2. CFO: Check for payment processor errors (Stripe, PayPal API keys valid?)
3. COO: Confirm products live (templates indexed? designs visible?)
4. CTMO: Verify n8n monitoring is running (check database revenue_summary)

ESCALATION:
- If platform access OK but $0, escalate to CEO for emergency niche/product review
- If platform access NOT OK, CTMO fixes immediately

DECISION POINT:
- Continue as-is: If products live but no conversions yet (normal for Day 1–2)
- Pivot: If products not live due to setup failure, activate backup niche
```

---

#### Trigger 1.2: Day 4–7 Revenue = $35–80 (Conservative baseline)

**If we hit $35–80 by Day 7 (Conservative range):**

```
Threshold: $35–80 cumulative by April 7, 16:00
Probability: 60–70% (realistic for cold start)

ACTIONS:
1. CFO: Confirm we're in Conservative scenario range
2. CFO: Calculate daily run-rate ($5–11/day)
3. COO: Analyze which product/design is converting (highest sales source?)
4. CTMO: Tag top-performing SKU in database for dashboard tracking

DECISION:
- CONTINUE as planned (Week 1 is discovery phase; minimal optimization needed)
- Light optimization: 1 additional template, 1 additional design, 1 additional article

NO ESCALATION NEEDED (on track)

NEXT CHECKPOINT: Day 14 ($120–210 target)
```

---

#### Trigger 1.3: Day 4–7 Revenue = $80–200 (Realistic range or higher)

**If we exceed Conservative and hit $80+ by Day 7:**

```
Threshold: $80–200 cumulative by April 7, 16:00
Probability: 20–30% (above-average launch)

ACTIONS:
1. CFO: Confirm we're tracking Realistic or Optimistic scenario
2. CFO: Calculate runway (new cash position + burn rate = runway in months)
3. COO: Double effort on winning product/design (add 2–3 more variants)
4. CTMO: Prepare ad spend tracking (if we hit $150+, will likely test ads)

DECISION:
- PREPARE ad budget ($20–50/week) for Week 2 testing
- Increase content velocity (1–2 extra articles, 2–3 extra designs)
- Notify CEO: Potential to accelerate timeline

APPROVAL PENDING: Wait for Day 14 revenue to confirm trend before spending

NEXT CHECKPOINT: Day 14 (watch for $270–460+ cumulative)
```

---

### WEEK 2 MILESTONES (April 8–14)

#### Trigger 2.1: Cumulative revenue $120–210 by Day 14

**If Week 1 + Week 2 = $120–210 (Conservative track):**

```
Threshold: $120–210 cumulative by April 14, 16:00
Probability: 40–50% (realistic slow start)

STATUS: On Conservative track. Timeline to $10k goal: 23 months @ this pace.

ACTIONS:
1. CFO: Assess stream performance (which of 3 is leading?)
2. COO: Focus on highest-performing stream (increase output 50%)
3. COO: Light optimization on underperforming streams (adjust copy/design)
4. CEO: Confirm Conservative scenario is acceptable or request acceleration

DECISION:
- CONTINUE current execution; no major pivots needed
- Add 1–2 extra templates, 2–3 extra designs if not already done
- Keep ad spend OFF (organic only for now)

ESCALATION to CEO:
- "Week 2 cumulative $120–210. On Conservative track. Projected $10k recovery in 23 months. Acceptable?"
- If CEO says YES: Continue as planned
- If CEO says NO: Activate ad spend or pivot recommendation by Day 21

NEXT CHECKPOINT: Day 21 (target $250–410 cumulative)
```

---

#### Trigger 2.2: Cumulative revenue $210–460 by Day 14

**If Week 1 + Week 2 = $210–460 (Realistic track):**

```
Threshold: $210–460 cumulative by April 14, 16:00
Probability: 40–50% (most likely scenario)

STATUS: On Realistic track. Timeline to $10k goal: 6–8 months @ this pace.

ACTIONS:
1. CFO: Identify revenue leader (Digital? PoD? Affiliate?)
2. CFO: Calculate ad spend ROI (if we spend $50/week, what's payback?)
3. COO: Begin scaling leader stream (3x content velocity)
4. COO: Maintain other streams (don't let them stall)
5. CTMO: Prepare ad campaign (copy, targeting, landing pages)

DECISION:
- APPROVE ad spend: $50–100/week starting immediately (Week 2)
- Test on highest-ROI stream first (likely Digital Products)
- Set KPI: 2:1 ROAS (Revenue on Ad Spend) minimum
- Budget: Draw from $300 ad allocation in seed budget

ESCALATION to CEO:
- "Week 2 cumulative $210–460. On Realistic track. Approving $50–100/week ad spend. ROAS target 2:1. Projected $10k recovery in 6–8 months. Proceed?"

NEXT CHECKPOINT: Day 21 (target $580–950 cumulative)
```

---

#### Trigger 2.3: Cumulative revenue >$460 by Day 14

**If Week 1 + Week 2 = >$460 (Optimistic track or better):**

```
Threshold: >$460 cumulative by April 14, 16:00
Probability: 10–15% (strong launch, above-average)

STATUS: On Optimistic track or better. Timeline to $10k goal: 2–3 months @ this pace.

ACTIONS:
1. CFO: Analyze which stream(s) are driving (likely Digital or PoD)
2. CFO: Project to Day 21, Month 1, and $10k goal
3. COO: Aggressive scaling (3–5x content velocity on leaders)
4. CTMO: Prepare large ad budget (up to $300–500/week if ROI holds)
5. CEO: Plan for Phase 2 acceleration (consider freelancer hire for design/content)

DECISION:
- APPROVE aggressive ad spend: $100–300/week
- Target: Maintain or exceed current ROAS (2:1+ minimum)
- Scale winning stream with 70% of budget; test secondary streams 30%
- Be prepared to hire freelancer (10–20 hrs/week) if demand outpaces capacity

ESCALATION to CEO:
- "Week 2 cumulative >$460. On Optimistic track. Approving $100–300/week ad spend. Projected $10k recovery in 2–3 months. URGENT: Consider hiring support for execution capacity?"

NEXT CHECKPOINT: Day 21 (target >$1,500–2,000 cumulative)
```

---

#### Trigger 2.4: One stream $0 for entire Week 2

**If any single stream generates $0 all week:**

```
Threshold: Digital = $0 OR PoD = $0 OR Affiliate = $0 (all of Week 2)
Probability: 5–15% (indicates setup or positioning issue)

EXAMPLE: Digital Products $0, but PoD + Affiliate = $400 total

ACTIONS:
1. CFO: Flag to COO immediately (do not wait for standup)
2. COO: Root cause analysis:
   - Digital: Is template live? Is it indexed? Is pricing right?
   - PoD: Are designs visible on platform? SEO tags correct?
   - Affiliate: Are articles indexed by Google? Is email CTA visible?
3. CTMO: Verify API/database is tracking correctly (is revenue being captured?)

DECISION OPTIONS:
- A) Fix the stream (if setup issue): Relaunch with corrections, aim for sales by Day 21
- B) Pause the stream (if fundamentally stuck): Reallocate effort to 2 winners, revisit in Phase 2
- C) Pivot the niche: If positioning is wrong, shift to adjacent niche

ESCALATION to CEO:
- "Week 2: [Stream] showing $0. Root cause: [setup/positioning/niche]. Recommendation: [fix/pivot/pause]"
- If CEO approves FIX: COO executes Day 15–21, target $50+ by Day 21
- If CEO approves PAUSE: Acknowledge, maintain other 2 streams, revisit Week 4

NEXT CHECKPOINT: Day 21 (assess if stream recovered or needs permanent pivot)
```

---

### WEEK 3 MILESTONES (April 15–21)

#### Trigger 3.1: Cumulative revenue <$1,500 by Day 21

**If total 21-day revenue = <$1,500 (below Conservative range):**

```
Threshold: <$1,500 cumulative by April 21, 23:59
Probability: 5–10% (significant underperformance)

STATUS: Below all scenarios. Timeline: 20+ months to $10k goal.

ROOT CAUSE ANALYSIS NEEDED:
1. Were all 3 products/content actually live and visible?
2. Did we have conversion-blocking issues (pricing too high, copy poor, SEO tags missing)?
3. Did platforms have visibility/algorithm issues?
4. Was niche selection misaligned with market demand?

ACTIONS:
1. CFO: Compile detailed revenue + conversion data by stream
2. COO: Conduct niche/product post-mortem with CEO
3. CTMO: Verify analytics are tracking correctly (no data loss)
4. CEO: Make pivot decision

DECISION OPTIONS:
- A) Aggressive pivot: Switch to completely different niches (higher-demand categories)
- B) Double-down optimization: Keep niches, fix positioning/copy/pricing, extend runway 3–4 weeks
- C) Pause for external learning: Research market + competitors more; restart Week of May 1

ESCALATION to CEO (CRITICAL):
- "Day 21: $1,500 cumulative. Significantly below expectations. Recommend pivot by April 28. Seed budget runway 4–6 weeks."

NEXT CHECKPOINT: Day 28 (Decision confirmation; execution restarts)
```

---

#### Trigger 3.2: Cumulative revenue $1,500–$5,000 by Day 21

**If total 21-day revenue = $1,500–$5,000 (Conservative to mid-Realistic range):**

```
Threshold: $1,500–$5,000 cumulative by April 21, 23:59
Probability: 60–70% (expected range)

STATUS: On track. Timeline to $10k goal: 6–14 months depending on pace.

ACTIONS:
1. CFO: Identify best-performing stream (Digital? PoD? Affiliate?)
2. CFO: Project Day 21 revenue into monthly run-rate
3. COO: Plan Phase 2 (double-down on winners)
4. CTMO: Analyze performance data for optimization opportunities
5. CEO: Approve scaled execution for May

PERFORMANCE BY STREAM (example):
- If Digital: $800–$1,500 (44–50% of total), then Digital is star; scale to 50%+ effort
- If PoD: $600–$1,500 (40–50% of total), then PoD is star; scale design library to 50+
- If Affiliate: $300–$1,000 (20–30% of total), then Affiliate is building foundation; maintain content velocity

DECISION:
- CONTINUE Phase 1 strategy into Phase 2 (Week 4–8)
- INCREASE velocity on best performer (3x content, 2x designs, etc.)
- APPROVE ad spend up to $500/month if ROAS 2:1+
- PREPARE Q2 roadmap: Email list growth, content depth, potential freelancer support

ESCALATION to CEO:
- "Day 21: $1,500–$5,000 cumulative. On track for $10k recovery in 6–14 months. [Stream X] leading at [%]. Scaling execution for May. Approving $500/month ad spend if ROAS holds."

NEXT CHECKPOINT: Day 30 (Week 4 revenue trend; confirm scaling is working)
```

---

#### Trigger 3.3: Cumulative revenue >$5,000 by Day 21

**If total 21-day revenue = >$5,000 (Realistic-to-Optimistic range):**

```
Threshold: >$5,000 cumulative by April 21, 23:59
Probability: 10–15% (strong launch, above-average execution)

STATUS: Strong execution. Timeline to $10k goal: 2–4 months @ this pace.

ACTIONS:
1. CFO: Congratulations. Run detailed financial analysis by stream.
2. CFO: Project to $10k goal date (estimate: late May to early June)
3. COO: Begin scaling aggressively (5–10x effort on leaders)
4. CTMO: Evaluate hiring capacity (can we handle 10x more orders/content?)
5. CEO: Plan Phase 2+ strategy (Q2 expansion, potential new streams, team hire)

PERFORMANCE IMPLICATIONS:
- $5,000+ in 21 days = $7,500/month run-rate
- To $10,000 goal = 1–2 months remaining (accelerated timeline)
- Seed budget $1,000 is SUFFICIENT if spending controlled
- Revenue is covering operational costs (positive cash flow)

DECISION:
- GREENLIGHT aggressive scaling: $1,000–$2,000/month ad spend if ROI proven
- CONSIDER hiring: If $5,000+ in 21 days, hiring freelancer (15–20 hrs/week) is justified ROI
- PREPARE fundraising: If trend continues, consider small angel investment for scaling ($5–10k)

ESCALATION to CEO (STRATEGIC):
- "Day 21: >$5,000 cumulative. Exceeding targets. Projected $10k recovery by [date]. RECOMMEND: Aggressive scaling + potential hiring + Q2 fundraising plan. Discuss today."

NEXT CHECKPOINT: Day 30 (First full-month close; verify trend sustainability)
```

---

## Stream-Level Decision Triggers (Watch Daily)

### Digital Products Stream Alerts

| Threshold | Action | Escalation |
|-----------|--------|-----------|
| $0 by Day 7 | Check platform + pricing | CEO if still $0 by Day 10 |
| $50+ by Day 7 | Add 2–3 new templates | None (on track) |
| $50+ cumulative, <2 units sold | Review conversion (pricing? copy?) | COO if not improved by Day 14 |
| $200+ by Day 14 | Scale to 10+ template library | None (accelerate) |
| >50% of total revenue | Make Digital 60%+ of focus | CEO (revenue leader identified) |

### Print-on-Demand Stream Alerts

| Threshold | Action | Escalation |
|-----------|--------|-----------|
| 0 orders by Day 10 | Check design visibility + tags | COO for tag/niche optimization |
| 5+ orders by Day 7 | Add 2–3 new designs immediately | None (momentum) |
| <$50 cumulative by Day 14 | Evaluate platform (Redbubble vs. Merch vs. Etsy) | CEO for potential platform pivot |
| 15+ orders by Day 14 | Scale design library to 30+ by Day 21 | None (accelerate) |
| >40% of total revenue | Consider hiring designer (3–5 hrs/week) | CEO (ROI justification) |

### Affiliate Marketing Stream Alerts

| Threshold | Action | Escalation |
|-----------|--------|-----------|
| 0 clicks by Day 14 | Check article SEO + email visibility | COO for article audit |
| 1+ click by Day 7 | On track; continue publishing | None |
| <50 email subscribers by Day 21 | Increase email CTA prominence; test gating | COO for strategy review |
| $100+ revenue by Day 21 | Begin weekly newsletter (monetization) | None (scale) |
| 0 revenue but >100 subscribers | Email list is asset; prepare monetization Week 4 | None (deferred monetization okay) |

---

## Cash Flow Alerts (Daily CFO Check)

### Burn Rate Warnings

```
Daily check: Is burn rate > revenue?

SAFE ZONE:
- Revenue > Costs (positive daily cash flow)
- Cumulative still positive even if one day negative

WARNING ZONE:
- 3 consecutive days of negative daily cash flow
- Cumulative dropping below runway threshold (e.g., <$500 left)

CRITICAL ZONE:
- Cumulative <$300 remaining (immediate spend freeze)
- Revenue trending to $0 while costs continue

ACTION:
- WARNING: Alert CEO + CTMO; hold non-essential spend
- CRITICAL: Freeze all non-critical spend immediately; activate emergency pivot decision
```

### Payment Processing Alerts

```
Daily check: Did all expected payouts process?

ALERT TRIGGERS:
- Stripe/PayPal payout failed or delayed >24 hours
- Payment processor rejected transaction (fraud flag, etc.)
- Revenue appears in orders but not in bank deposits (reconciliation issue)

ACTION:
- Check payment processor dashboard for errors
- If payment method issue: Update billing info immediately
- If processor issue: Switch to backup payment method (PayPal if Stripe down, etc.)
- Log incident in financial_YYYY-MM-DD.md
- Notify CEO if payout delayed >2 days
```

---

## Weekly Decision Checklist (Every Friday 17:00)

**Print this and check off daily:**

- [ ] Total cumulative revenue matches scenario baseline (Conservative/Realistic/Optimistic)?
- [ ] All platform payments received (reconciled)?
- [ ] Email subscriber count trending up (affiliate foundation)?
- [ ] Any stream showing $0 for entire week?
- [ ] Cash position still positive?
- [ ] Ad spend (if active) showing 2:1+ ROAS?
- [ ] No escalation-level blockers?
- [ ] Ready to approve next week's actions?

**If any "No" answer:** Escalate to CEO by Friday 18:00.

---

## Summary Table: Scenario Thresholds & Cumulative Targets

| Checkpoint | Conservative | Realistic | Optimistic | Action if Hit |
|-----------|-------------|-----------|-----------|-------------|
| Day 7 | $35–80 | $80–180 | $300–600 | Continue / Scale / Accelerate |
| Day 14 | $120–210 | $210–460 | $900–1,600 | Monitor / Approve ads / Scale aggressively |
| Day 21 | $250–410 | $580–950 | $1,900–3,100 | On track / Reaccelerate / Hiring/pivot decision |

**Note:** If actual revenue is 50%+ below scenario by any checkpoint, escalate immediately for pivot decision.

---

**CFO Implementation:** Print this document. Check daily during standup prep (15:00–15:30). Alert CEO immediately if any trigger threshold is crossed. Use scenario-tracking spreadsheet to monitor against projections.

**Next update:** Post-Day 7 (April 7) with actual data; refine triggers based on real performance.

