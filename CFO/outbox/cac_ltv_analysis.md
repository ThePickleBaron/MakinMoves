# CAC/LTV Analysis Workbook (Customer Economics)

**Purpose:** Deep-dive into unit economics for each revenue stream. Use this to evaluate profitability, payback periods, and scaling viability.

**Update:** Weekly (Fridays) once you have 2+ weeks of data.

---

## Digital Products (Templates, Courses, Worksheets)

### Cost Structure

| Item | Cost per Unit |
|------|---------------|
| Gumroad platform fee | 10% of sale |
| Payment processing (Stripe) | 3% + $0.30 |
| Marketing/ads (allocated) | $[TBD] |
| Content creation (amortized) | $[TBD] |
| **Total CAC** | **$[TBD]** |

### Revenue Model

| Price Point | Total Revenue | Platform Fees | Processing Fees | Net Revenue |
|-----------|-----------|-----------|-----------|-----------|
| $17 template | $17.00 | -$1.70 | -$0.81 | **$14.49** |
| $27 template | $27.00 | -$2.70 | -$1.11 | **$23.19** |
| $47 template | $47.00 | -$4.70 | -$1.71 | **$40.59** |
| $97 course section | $97.00 | -$9.70 | -$3.21 | **$84.09** |

### Customer Lifetime Value

**Assumptions (update weekly):**
- Avg customer acquires template at: $[XX] (use Week 1–2 avg selling price)
- Repeat purchase rate: 20–30% (estimate from data)
- Avg repeat purchase value: 80% of initial (bundle discount)
- Avg customer lifetime: 2–3 purchases

**LTV Calculation (Conservative):**

```
Initial purchase LTV:        $25 (avg sale)
Repeat purchase (25% rate):  $25 × 0.25 × 0.80 = $5
2nd repeat (10% of repeat):  $5 × 0.10 × 0.80 = $0.40
3rd repeat (5% of repeat):   $0.40 × 0.05 × 0.80 = $0.02
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total LTV: $30.42

Alternative (optimistic):
Initial: $30, Repeat 1: $24 (80% of initial, 30% rate), Repeat 2: $6
Total LTV: $60
```

**Your Calculation:**
- Initial purchase: $[XX]
- Repeat 1 (probability [X]%): $[XX]
- Repeat 2 (probability [X]%): $[XX]
- **LTV: $[XX]**

### CAC Payback Analysis

**If using paid ads:**

| Ad Spend | Expected Sales (Week 2 data) | Revenue per Sale | CAC per Sale | Payback Period |
|----------|----------|----------|----------|----------|
| $10/week | 5–8 | $25 | $1.25–2.00 | Immediate |
| $20/week | 10–15 | $25 | $1.33–2.00 | Immediate |
| $50/week | 25–40 | $25 | $1.25–2.00 | Immediate |

**Payback period:** How long until ad spend is recouped?

- If CAC $2 and LTV $30: Payback in 1 week (very fast)
- If CAC $5 and LTV $30: Payback in 2 weeks (fast)
- If CAC $10 and LTV $30: Payback in 3 weeks (acceptable)

**Your payback calculation:**
- Expected CAC (ads): $[XX]
- Customer LTV: $[XX]
- Payback period: $[XX] ÷ $[XX] = **[X] weeks**

### Digital Products Economics Summary

**Recommended pricing:** $27–47 for templates, $97+ for course sections
**Repeat rate target:** 25%+ by Month 3
**LTV target:** $40–60 per customer
**CAC safe threshold:** $5–10 (keep ad ROAS 3:1+)

---

## Print-on-Demand (T-shirts, Hoodies, Posters)

### Cost Structure

| Platform | Commission | Net per Sale | Avg Order Value | Notes |
|----------|-----------|-----------|-----------|-----------|
| Redbubble | 40% | $6–12 | $15–28 | Highest royalty but higher prices |
| Merch by Amazon | 35% | $5–10 | $14–24 | Lower prices, higher volume potential |
| Etsy print (POD) | 6.5% + $0.20 | $10–20 | $20–35 | Best margins if you handle logistics |

### Revenue Model Example (Redbubble T-shirt)

| Metric | Value |
|--------|-------|
| Customer sale price | $18.00 |
| Redbubble commission (40%) | -$7.20 |
| Base product cost | -$6.00 |
| Redbubble handling | Included |
| **Your net per sale** | **$4.80** |

**Redbubble is not profitable per unit — volume is key.**

### Merch by Amazon Example

| Metric | Value |
|--------|-------|
| Customer sale price | $16.00 |
| Amazon commission (35%) | -$5.60 |
| Base product cost (Amazon paid) | Included |
| Your royalty | **$10.40** |

**Merch by Amazon is better for profit per unit** (if approved).

### Customer LTV (PoD)

**Assumptions:**
- Avg customer buys 1–2 items (repeat rate: 5–10%)
- Avg order value: $15–20
- Lifetime: 6–12 months of potential purchases

**LTV Calculation:**
```
Initial purchase: $10 (net margin, conservative)
Repeat customer (7% rate): $10 × 0.07 × 1.5 purchases = $1.05
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total LTV: $11.05

Better case (Merch by Amazon):
Initial: $10, Repeat (10% rate): $10 × 0.10 × 2 = $2
Total LTV: $12
```

### CAC Analysis (PoD)

**Organic (no ad spend):**
- CAC: $0 (platform algorithm marketing)
- Break-even: Immediate
- Sustainability: Best long-term (no costs)

**Paid (ads on Redbubble designs):**
- CAC per sale: $3–8
- LTV: $11 (conservative, Redbubble)
- Payback: 1–2 months (slower than Digital)
- ROAS required: 1.5:1+ (lower margin means tighter ROAS)

**Recommendation:** Use organic growth (no ads). Only ads if LTV >$15.

### PoD Economics Summary

**Platform choice:** Merch by Amazon (if approved) > Redbubble > Etsy
**Net margin per unit:** $5–$12 (depending on platform)
**Repeat rate target:** 10%+ by Month 3
**LTV target:** $12–$20 per customer
**Ad spend caution:** Only spend if net margin >$10 and ROAS 2:1+
**Scaling strategy:** Design volume (50+ designs by Month 3) + organic growth

---

## Affiliate Marketing (Content + Email)

### Cost Structure

| Item | Cost | Notes |
|------|------|-------|
| Domain | $1–2/mo | Annual |
| WordPress hosting | $5–8/mo | Managed hosting |
| Email (Beehiiv, Substack) | $0/free tier | Free up to 5k subscribers |
| Design tools | $0–13/mo | Canva Pro optional |
| Content creation | Amortized | 2–3 hrs per article |
| **Total CAC** | **$0.50–1/subscriber** | Very low |

### Revenue Model

**Affiliate Commission Rates (sample):**

| Network | Product | Commission | Example Order Value | Your Commission |
|---------|---------|-----------|--------|-----------|
| Amazon Associates | Any product | 3–5% | $50 book | $1.50–2.50 |
| Amazon Associates | Tech (high margin) | 3–5% | $500 laptop | $15–25 |
| SaaS affiliate (e.g., Refersion) | Software | 20–30% | $100/mo = $1200/yr | $240–360/yr |
| CJ Affiliate (commissions) | Varies | 5–15% | Varies | Varies |
| Impact (brand affiliates) | Brand products | 5–10% | $100 | $5–10 |

### Customer LTV (Affiliate Subscribers)

**Assumptions:**
- Email subscriber lifetime value: $1–5/year (varying by engagement)
- SaaS referral LTV: $50–$500 (one-time or annual commission)
- Product affiliate LTV: $0.50–$3 per order (commission)

**Email Subscriber LTV Calculation (Conservative):**

```
Email subscriber base: 100 subs
Avg engagement: 5% open rate, 1% click rate, 2% conversion to purchase
Annual revenue per sub: 5 × 0.01 × 0.02 × $50 = $0.50
100 subs × $0.50 = $50/year

Better case (engaged list):
Base: 500 subs
Open rate: 15%, Click: 5%, Conversion: 5%
Annual revenue per sub: 15 × 0.05 × 0.05 × $100 = $3.75
500 subs × $3.75 = $1,875/year
```

**Your calculation (after Week 2 data):**
- Email subscribers: [X]
- Avg email opens: [X]%
- Avg click-through: [X]%
- Avg conversion: [X]%
- Revenue per sub per year: $[X]

### CAC Analysis (Affiliate)

**Organic (SEO + social):**
- CAC per subscriber: $0 (content marketing)
- CAC payback: 4–12 weeks (slow)
- Long-term value: Exceptional (passive, compounding)

**Paid (ads to newsletter signup):**
- CAC per subscriber: $0.50–$2 (paid ads)
- Payback period: 1–6 months (depends on LTV)
- ROAS: 2:1+ required for profitability

**Email list is the asset.** Focus on growth first (organic), monetization later.

### Affiliate Economics Summary

**CAC:** $0 organic, $0.50–$2 if paid ads
**LTV per subscriber:** $1–$5/year (email + affiliate commissions)
**Payback period:** 4–12 weeks (organic), 2–4 months (paid)
**Subscriber target:** 500+ by Month 3 (for meaningful revenue)
**Revenue model:** Email list (owned asset) + affiliate commissions (recurring)
**Scaling strategy:** Content velocity (4–5 articles/week) + email growth (gating, lead magnets)

---

## Comparative Analysis: CAC vs. LTV by Stream

| Stream | Organic CAC | Ad CAC | LTV | Payback | Sustainability |
|--------|----------|--------|-----|---------|-----------------|
| **Digital** | $0 | $2–5 | $30–60 | 1–3 weeks | Excellent |
| **PoD** | $0 | $5–8 | $11–20 | 8–12 weeks | Good (high CAC) |
| **Affiliate** | $0 | $0.50–2 | $1–5/yr | 4–12 weeks | Excellent (compounding) |

**Key insights:**
1. **Digital Products** has best CAC/LTV ratio — highest short-term profitability
2. **PoD** has lowest LTV — only sustainable at scale (high volume)
3. **Affiliate** has lowest CAC — best long-term asset building

---

## Blended Profitability Analysis

**If all three streams running:**

| Stream | Week 2 Revenue | Week 2 CAC (ads) | Week 2 Net | CAC Payback |
|--------|----------|----------|----------|----------|
| Digital | $500 | $30 (if ads) | $470 | 2–3 days |
| PoD | $200 | $0 (organic) | $200 | N/A |
| Affiliate | $100 | $0 (organic) | $100 | N/A |
| **Blended** | **$800** | **$30** | **$770** | **1–2 weeks** |

**Blended ROAS (if ads active):** $770 ÷ $30 = **25.7:1** (exceptional)

**Recommendation:** Test $50–100/week ad spend on Digital Products, expect 20+:1 ROAS.

---

## Decision: Which Stream to Scale First?

### Based on Economics

| Metric | Winner | Reason |
|--------|--------|--------|
| Fastest payback | Digital | CAC paid back in days |
| Highest LTV | Digital | $30–60 vs. others |
| Lowest CAC (organic) | Affiliate | $0 organic CAC, high long-term LTV |
| Best unit economics | Digital | Net margin highest |
| Most sustainable | Affiliate | Recurring, compounding |

**Scaling priority (if limited capacity):**
1. **First:** Digital Products (fastest money)
2. **Second:** PoD (proven demand, passive)
3. **Third:** Affiliate (long-term asset)

**Blended approach:** 50% effort on Digital, 30% on PoD, 20% on Affiliate.

---

## Weekly CAC/LTV Tracking Sheet

**Use this template to update weekly (Fridays):**

```markdown
# CAC/LTV Update — Week of April [DD]–[DD]

## Digital Products
- Customers acquired (organic): [X]
- CAC (if ads): $[X]
- Revenue: $[XXX]
- LTV (estimated): $[XX]
- Payback period: [X] weeks
- Status: [On track / Needs improvement]

## Print-on-Demand
- Orders (organic): [X]
- CAC (if ads): $[X]
- Revenue: $[XXX]
- LTV (estimated): $[XX]
- Payback period: [X] weeks
- Status: [On track / Needs improvement]

## Affiliate
- New subscribers: [X]
- CAC (if ads): $[X]
- Revenue: $[XXX]
- LTV (estimated): $[XX]/year
- Payback period: [X] weeks
- Status: [On track / Needs improvement]

## Recommendation for Next Week
- [Stream to scale / stream to pause / stream to optimize]
- Ad spend: [YES/NO] on which stream?
- Target metrics: [What to aim for]
```

---

## Red Flags: When Economics Break Down

| Red Flag | Symptom | Action |
|----------|---------|--------|
| CAC > LTV | You're losing money per customer | Stop ads; improve conversion or LTV |
| Payback >6 months (organic) | Unsustainable organic growth | Review positioning; consider niche pivot |
| LTV declining week-to-week | Quality issue or market saturation | Check product/design quality; adjust pricing |
| Repeat rate <5% | Customers not coming back | Improve product quality; add upsells |
| ROAS <1.5:1 (paid) | Ads aren't profitable | Pause ads; optimize conversion first |

---

## Financial Projections (Using CAC/LTV)

**If you acquire 100 customers at these economics:**

### Digital Products (100 customers)

```
Initial revenue: 100 × $25 (avg) = $2,500
Repeat customers (25%): 25 × $20 = $500
2nd repeat (10%): 10 × $16 = $160
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total LTV: $3,160 (100 customers over 6 months)
CAC (organic): $0
Net: $3,160
```

### PoD (100 customers)

```
Initial revenue: 100 × $10 (net) = $1,000
Repeat customers (7%): 7 × $15 = $105
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total LTV: $1,105 (100 customers over 6 months)
CAC (organic): $0
Net: $1,105
```

### Affiliate (100 subscribers)

```
Annual revenue: 100 × $3 (avg engagement) = $300/year
Churn rate: 10%/month, but new subscribers added
Year 2 base: 70 × $3 = $210 (declining)
New subscribers brought in: 50 × $3 = $150 (growing)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Year 1: $300 + (Year 2 contribution)
Year 2 base + new: $210 + $150 = $360
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3-year cumulative: $300 + $360 + $400 = $1,060
CAC (organic): $0
Net: $1,060 (plus compounding growth if growth rate >10%)
```

**Blended 100-customer LTV: $3,160 + $1,105 + $1,060 = $5,325**

---

## Summary: Unit Economics at a Glance

**Print this and keep handy:**

```
DIGITAL PRODUCTS:
- CAC: $0 (organic), $2–5 (paid ads)
- LTV: $30–60
- Payback: 1–3 weeks
- Action: Scale with confidence; ads ROI is strong

PRINT-ON-DEMAND:
- CAC: $0 (organic), $5–8 (paid ads)
- LTV: $11–20
- Payback: Immediate (organic), 8–12 weeks (paid)
- Action: Focus on volume (50+ designs); avoid ads

AFFILIATE:
- CAC: $0 (organic), $0.50–2 (paid ads)
- LTV: $1–5/year per subscriber
- Payback: 4–12 weeks (organic)
- Action: Build email list first; monetize later

PRIORITY: Digital (quickest money) → PoD (passive scale) → Affiliate (long-tail asset)
```

---

**Last Updated:** [Start tracking Week 2]
**Next Review:** Every Friday with actual data
**Owner:** CFO

