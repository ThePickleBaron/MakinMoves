# Infrastructure Cost Scenarios — Executive Summary

**Date:** 2026-03-29
**Audience:** Board (CEO, COO, CTMO, CFO)
**Format:** 1-page decision brief

---

## The Question
With $1,000 seed budget and user hands-off on March 31, which infrastructure cost scenario should we choose?

## Three Options

| | **LEAN** | **STANDARD** | **CLOUD** |
|---|----------|------------|---------|
| **Monthly Cost** | $10–20 | $30–50 | $100–200+ |
| **Sales to Break Even** | 1–2/month | 2–3/month | 8–10/month |
| **Runway (no revenue)** | ∞ | 25 days | 6.7 days |
| **Profitable by** | Week 1–2 | Week 2–3 | Week 4–5+ |
| **Break-even day** | Day 14 | Day 21 | Day 35 |

## CFO Recommendation

### Days 1–30: START WITH LEAN ✓

**Why Lean:**
1. Minimal fixed cost ($10–20/mo) ✓
2. Breaks even at 1–2 sales/month ✓
3. Infinite runway (even with $0 revenue) ✓
4. Already set up (Docker running locally) ✓
5. Easy to upgrade later without lock-in ✓

**What we're running:**
- PostgreSQL: Self-hosted Docker (~$0 local, $5 if on DigitalOcean)
- n8n: Self-hosted Docker ($0)
- Redis: Self-hosted Docker ($0)
- Selenium: Self-hosted Docker ($0)
- Domain: Namecheap ($1/mo)
- **Total:** ~$6–7/month (negligible)

### Day 21–30 Decision Point

**IF revenue ≥ $150/mo by Day 21:**
- Upgrade to Standard
- Add cost: $30–40/mo (easily covered by revenue)
- Benefit: Managed backups, automated uptime, less overhead

**IF revenue < $150/mo by Day 21:**
- Stay with Lean
- Continue optimizing products/content
- Reassess in 2 weeks

**IF user hands off March 31 (before Day 21):**
- Upgrade to Standard *before* March 31
- Reason: Managed services required for autonomous operation
- Cost: $30–50/mo (affordable, well-covered by target revenue)

## Why NOT Cloud

❌ Cloud ($100–200+/mo) is **oversized and dangerous**
- Burn rate = $150/day, we have ~25 days of runway
- Requires 8–10 sales in month 1 just to break even (unrealistic)
- Over-engineered for bootstrap solo founder
- Revisit only if hitting $500+/month revenue (unlikely in Days 1–90)

## Expected Revenue Impact (Days 1–90)

Assuming 2–3 sales/week by week 2 (realistic target):

| Timeline | Lean ($10) | Standard ($40) | Cloud ($150) |
|----------|-----------|----------------|--------------|
| Week 1 | -$10 | -$40 | -$150 |
| Week 2 | +$30 | -$10 | -$80 |
| Week 3 | +$60 | +$40 | -$30 |
| Week 4 | +$90 | +$70 | -$10 |
| **Month 1** | **+$100** | **+$70** | **-$40** |
| **Month 2** | **+$340** | **+$310** | **+$200** |
| **Month 3** | **+$490** | **+$460** | **+$350** |

**Lean reaches profitability by Day 14. Cloud doesn't break even until Day 35.**

## Payment Processing Fees (Applied to All Scenarios)

- **Digital Products (Gumroad):** 8.5% + Stripe 3.2% = **11.7% total**
  - $20 product → $17.36 net
- **PoD (Redbubble):** 50% Redbubble cut (no additional fees)
  - $30 hoodie → $15 net
- **Affiliate (Amazon):** 4–7% commission (no fees)
- **SaaS (Stripe direct):** 3.2% + $0.30 (lowest rate)
  - $20 subscription → $19.06 net

These fees apply equally across all scenarios; cost differences are *only* infrastructure.

## Per-Stream Breakeven (Lean Scenario)

| Stream | Units to Breakeven | Timeline |
|--------|-------------------|----------|
| Digital Products | 1 sale | Day 7 |
| Print-on-Demand | 1 sale | Day 7–14 |
| Affiliate Marketing | $15–20 commission | Week 4–8 (organic growth) |
| SaaS | 1 subscriber | Week 8–12 (validation phase) |

Even a single $20 sale covers the monthly infrastructure cost in Lean scenario.

## Implementation Timeline

**Today (Day 0):**
- Confirm LEAN scenario for Days 1–30
- Keep Docker running locally
- Set up automated backups (free: GitHub + Dropbox)

**Day 1–21 (Execution Phase):**
- Launch products (Digital, PoD, Affiliate)
- Track daily revenue (CFO queries database)
- Monitor cost vs. revenue

**Day 21–30 (Decision Point):**
- Assess revenue trajectory
- Decide: Upgrade to Standard or stay Lean
- If upgrading, execute migration (4 hours)

**Day 31+ (Autonomous Operation):**
- If upgraded to Standard: Managed services running
- If staying Lean: Monitor costs and runway, upgrade at $150+/mo trigger

## Risk Mitigation

**Lean scenario risks:**
- ✓ Workstation failure → Automate backups (free solution exists)
- ✓ No uptime SLA → Accept 99% uptime; manual restart if needed
- ✓ Limited capacity → Won't hit limits until $10k+/mo revenue

**Standard scenario risks:**
- ✓ Higher cost → Justified only if revenue is proven ($150+/mo)
- ✓ Lock-in → Can downgrade back to Lean if needed
- ✓ More complex → Worth it for autonomous operation (post-March 31)

**Cloud scenario risks:**
- ✗ Cash depletion → Day 25 without revenue (UNACCEPTABLE)
- ✗ Unnecessary complexity → Over-engineered for current needs
- ✗ Kill team morale → Watching $150/day burn with no revenue is demoralizing

## Financial Summary

**With $1,000 seed budget:**

| Scenario | Monthly Burn | Profitability | Survivability |
|----------|-------------|--------------|---------------|
| **Lean** | $10 | Day 14 | Infinite runway ✓ |
| **Standard** | $40 | Day 21 | 25 days (risky) ⏳ |
| **Cloud** | $150 | Day 35 | 6.7 days (failure) ✗ |

## Board Action Items

**CEO:**
1. ✓ Approve Lean scenario for Days 1–30 (or suggest alternative)
2. ✓ Confirm decision by 2026-03-29 16:00 standup

**COO:**
1. ✓ Proceed with product launches (any scenario works)
2. ✓ Track timeline toward $150+/mo revenue (upgrade trigger)

**CTMO:**
1. ✓ Confirm n8n revenue tracking workflows ready
2. ✓ Automate daily database backups (free GitHub releases)

**CFO:**
1. ✓ Execute cost tracking queries (dashboard)
2. ✓ Provide daily revenue updates in standup
3. ✓ Recommend upgrade to Standard on Day 21 if revenue ≥ $150/mo

---

## Bottom Line

**Start Lean. Upgrade when revenue proves it.**

Lean scenario breaks even at 1–2 sales/month. Most teams hit that by Week 2. Standard scenario is safety net if needed; Cloud scenario is never needed before Q2.

---

**CFO: Ready to implement Lean scenario immediately upon CEO approval.**
