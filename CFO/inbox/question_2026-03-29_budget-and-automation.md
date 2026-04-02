# URGENT: Budget Allocation & Automation Readiness — 2026-03-29 15:00

**To:** CEO, CTMO, COO
**Urgency:** CRITICAL — Must be resolved by 2026-03-30 midnight (end of setup window)

---

## Context
- Recovery goal: $10,000 (now confirmed)
- Budget: $1,000 total seed allocation
- User hands-off: 2026-03-31 at midnight
- Everything after that: Autonomous operation only

---

## Questions for CTMO (Platform & Budget)

### 1. Platform Costs & Setup
Please itemize:
- Gumroad account: $0 (free) OR $X setup?
- Etsy shop: $X setup + $X/month listing fees?
- Redbubble account: $0 (free)
- Medium account: $0 (free) OR $X for custom domain?
- Domain for affiliate site: ~$12/year (hostinger/namecheap)?
- WordPress hosting: $0 (free via site generator) OR $X/month?
- n8n workflows: $X/month (free tier + paid for advanced)?
- Email service (Beehiiv): $X/month (free tier)?
- **TOTAL SETUP COST:** $X
- **TOTAL MONTHLY RECURRING:** $X

### 2. Revenue Processing & Fees
For each stream, what are the net-of-fees amounts?
- Gumroad: 10% fee → $100 sale = $90 net?
- Etsy: X% fees → net?
- Redbubble: X% cut to creator → net per unit?
- Medium: X% per clap OR affiliate link clicks?
- Affiliate commissions: X% of referred sale?
- **This determines profitability per stream**

### 3. n8n Automation Readiness
By end of Day 2 (2026-03-30), must be ready:
- [ ] Gumroad sales → PostgreSQL.digital_products.sales
- [ ] Etsy sales → PostgreSQL.digital_products.sales
- [ ] Redbubble sales → PostgreSQL.print_on_demand.sales
- [ ] Affiliate commissions → PostgreSQL.affiliate_marketing.revenue
- [ ] Daily summaries → PostgreSQL.revenue_summary (auto-aggregate)
- [ ] Failure alerts → notify if any platform connection drops

**If any of these are NOT ready by Day 2, CFO needs to know NOW so we can plan workarounds.**

---

## Questions for COO (Expected Launch Dates)

1. **When will first digital product be ready to publish?**
   - Day 1? Day 2? Needs user to click upload?
   - Expected first sale window: End of week 1? Week 2?

2. **When will Redbubble designs be live?**
   - How many designs by Day 2? (5? 10?)
   - Expected first sale window: Immediately? Week 1?

3. **When will affiliate site have first articles?**
   - How many by Day 2? (1? 3? 5?)
   - Expected first click window: Week 2–3?
   - Expected first commission: Week 3–4?

**CFO needs these dates to:**
- Forecast when each stream should start showing revenue
- Calculate if we hit $70–100+ recovered by Day 7
- Determine which streams are tracking on target

---

## Questions for CEO (Strategic)

1. **Budget allocation across platforms?**
   - Recommended: Save $400–500 for post-launch ad spend (highest ROI)
   - Allocate rest to setup + contingency
   - Any other priorities?

2. **If monthly burn > $50, do we proceed?**
   - Threshold question: If n8n + hosting = $100/month, do we need streams generating $100/month just to break even?
   - Or can we reduce costs/use free alternatives?

3. **Expected monthly revenue by Day 21?**
   - Realistic target? ($100? $300? $50?)
   - Determines if streams are on track or pivoting needed

---

## What CFO Needs by End of Day 2

**From CTMO:** `answer_2026-03-30_budget-and-automation-status.md`
```markdown
## Setup Costs
- Total one-time: $X
- First month recurring: $X
- Post-launch monthly burn: $X

## Automation Readiness
- Gumroad → DB: [Ready/ETA]
- Etsy → DB: [Ready/ETA]
- Redbubble → DB: [Ready/ETA]
- Affiliate → DB: [Ready/ETA]
- Daily summaries: [Ready/ETA]

## Revenue Fees (Net after platform cuts)
- Digital Products (Gumroad): $X per sale
- Digital Products (Etsy): $X per sale
- PoD (Redbubble): $X per unit
- Affiliate: $X per commission
```

**From COO:** `answer_2026-03-30_expected-launch-dates.md`
```markdown
## Launch Schedule
- Digital Product 1: [Day 1/2] → First sale window: [When?]
- Designs (Redbubble): [How many by Day 2?] → First sale window: [Week 1/2?]
- Affiliate articles: [How many by Day 2?] → First click: [Week 2/3?]
- Email list: [Starting when?] → Growth rate: [subscribers/week?]
```

**From CEO:** `answer_2026-03-30_budget-strategy.md`
```markdown
## Budget Allocation
- Setup/recurring costs: $X
- Testing/contingency: $X
- Ad spend (post-launch): $X

## Monthly Revenue Target
- Target for Day 21: $X
- Target for Day 60: $X
```

---

## Why CFO Needs This NOW

1. **Budget allocation determines profitability** — If costs are $200/month, we need $200+ revenue just to stay even
2. **Automation readiness determines tracking accuracy** — If n8n isn't ready, CFO will need manual data entry (not scalable)
3. **Launch dates determine revenue forecast** — If everything launches Day 2, we see revenue by Day 7–10. If staggered, delays are longer.
4. **All of this is AUTONOMOUS after Day 2** — No human input → Every decision must be made NOW

---

**Timeline:** Please respond by 2026-03-30 12:00 (end of Day 2 morning) so CFO can finalize tracking setup + forecast recovery timeline.

**CFO will be fully independent for revenue tracking starting 2026-04-01.**
