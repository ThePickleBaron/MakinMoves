# Infrastructure Cost Scenarios & Financial Breakeven Models

**Date:** 2026-03-29
**From:** CFO
**For:** Board (CEO/COO/CTMO)
**Status:** Strategic analysis — Three cost scenarios with breakeven models

---

## Executive Summary

Three hosting scenarios analyzed for PostgreSQL + n8n + Redis + Selenium infrastructure:

| Scenario | Monthly Cost | Breakeven Revenue | Runway at $1k Seed |
|----------|-------------|-------------------|-------------------|
| **Lean** (Self-hosted Docker) | $10–20 | $30–60 | 50–100 days |
| **Standard** (Railway/Heroku) | $30–50 | $90–150 | 20–33 days |
| **Cloud** (Full managed) | $100–200+ | $300–600+ | 5–10 days |

**Recommendation for Days 1–30:** Start with **Lean** scenario ($10–20/mo). Upgrade to Standard only when revenue exceeds $150/month or user hands off (March 31).

---

## Scenario 1: LEAN ($10–20/month)

### Architecture
- PostgreSQL: Self-hosted in Docker (local workstation or $5 DigitalOcean Droplet)
- n8n: Self-hosted in Docker (free)
- Redis: Self-hosted in Docker (free)
- Selenium: Self-hosted in Docker (free)
- Database backups: Manual or free tier (GitHub releases, Dropbox)

### Monthly Fixed Costs Breakdown

| Service | Cost | Notes |
|---------|------|-------|
| DigitalOcean Droplet (optional, if not local) | $5 | 1GB RAM, 25GB SSD, sufficient for dev |
| Domain (.com via Namecheap) | $10–12/year | ~$1/month amortized |
| **Total Fixed** | **$6–7/month** | Minimal |

### Variable Costs (Per Transaction)

| Service | Fee | When | Notes |
|---------|-----|------|-------|
| Stripe (digital products) | 3.2% + $0.30 | Per sale | Gumroad integration |
| PayPal (affiliate payouts) | 3.5% | Per payout | Affiliate networks |
| Redbubble (PoD) | Redbubble's cut (~15%) | Per sale | No processing fees |
| **Total Variable** | 3.2–3.5% per transaction | - | Lowest of all scenarios |

### Monthly Operating Budget

```
Fixed costs:           $6–7
+ Domain:             $1
+ Ad budget (optional): $0
+ Tools (optional):    $0
─────────────────────────
TOTAL MONTHLY:        $6–7

With headroom for occasional upgrades:
+ Marketing/tools buffer: $5–10
─────────────────────────
CONSERVATIVE ESTIMATE: $10–20/month
```

### Breakeven & Profitability Analysis

**Question:** What revenue is needed to cover infrastructure costs?

**Calculation (Stripe scenario):**
- Fixed costs: $10/month
- Stripe fee: 3.2% + $0.30 per transaction
- Average product price: $20
- Net per sale: $20 × (1 - 0.032) - $0.30 = $19.04

**Breakeven point:**
- Need $10 revenue to cover fixed costs
- At $19.04 net per $20 sale: Break even at ~1 sale (($10 ÷ $19.04) = 0.52 sales)
- **Realistic breakeven: 1–2 sales/month**

### Profitability by Stream

| Stream | Units to Breakeven | Timeline | Notes |
|--------|-------------------|----------|-------|
| **Digital Products** | 1–2 sales | Week 1–2 | $20 template = profitable immediately |
| **PoD** | 2–3 prints | Week 2–3 | $30 hoodie = profitable on 2–3 sales |
| **Affiliate** | $15–20 commission | Week 4–8 | Requires traffic first, then profitable |
| **SaaS** | N/A | N/A | Too early; focus on MVP in this scenario |

### Constraints & Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Workstation failure = data loss | Critical | Automate backups to GitHub/Dropbox (free) |
| No redundancy/uptime SLA | Medium | Accept 99% uptime; restart manually if needed |
| Limited to local bandwidth | Low | Fine for <100 concurrent requests/day |
| Manual database management | Medium | Use simple scripts; automation not critical at this scale |

### Runway Calculation (Lean Scenario)

Given $1,000 seed budget:

```
Fixed monthly cost:      $10
Expected daily burn:     $0.33
Runway (no revenue):     ~3000 days ✓ (essentially infinite)

With first revenue event:
- Day 7: Digital product sale ($20) → Net revenue $19
- Recovery so far: $19
- Remaining runway: Still infinite (costs covered by 1–2 monthly sales)
```

**Conclusion:** Lean scenario is **sustainable indefinitely** with as little as 1–2 sales per month.

---

## Scenario 2: STANDARD ($30–50/month)

### Architecture
- PostgreSQL: Managed (Railway, Heroku, or PlanetScale for MySQL)
- n8n: Managed (Railway) or self-hosted
- Redis: Managed (Upstash free tier) or self-hosted
- Selenium: Cloud-based (ScrapingBee, Browserless, or self-hosted)
- Backups: Automated included

### Monthly Fixed Costs Breakdown

| Service | Cost | Notes |
|---------|------|-------|
| **Database** | | |
| Railway PostgreSQL | $7 | 2GB storage, 10GB transfer |
| OR Heroku Postgres | $9 | 10GB included data |
| OR PlanetScale (MySQL) | $9–29 | Generous free tier available |
| **Automation** | | |
| n8n Cloud (cloud-hosted) | $10–25 | OR self-hosted on Railway ($0–7) |
| **Caching/Queue** | | |
| Upstash Redis (free) | $0 | Up to 10,000 commands/day free |
| Redis Cloud (paid tier) | $7 | If upscaling needed |
| **Web Scraping** | | |
| ScrapingBee or similar | $0–19 | Free tier (50 requests/month) or paid |
| Browserless/ScraperAPI | $0–25 | Pricing varies; minimal needed |
| **Monitoring** | | |
| Datadog/LogRocket (optional) | $0–15 | Free tier available |
| **Domain + SSL** | | |
| Namecheap domain | $1 | ~$10/year |
| SSL certificate | $0 | Free with Let's Encrypt |
| **Total Fixed (base case)** | **$27–32** | Without paid scraper |
| **Total Fixed (with scraper)** | **$37–60** | With low-tier paid scraper |

### Variable Costs (Per Transaction)

| Service | Fee | When | Notes |
|---------|-----|------|-------|
| Stripe | 3.2% + $0.30 | Per digital product sale | Gumroad/Stripe integration |
| PayPal | 3.5% | Affiliate payouts | For network payouts |
| Redbubble | ~15% cut | Per PoD sale | Their margin, not a fee |
| Extra Railway usage (if high volume) | $0.10–0.50 per unit | If exceeding free tier | Unlikely in first 90 days |
| **Total Variable** | 3.2–3.5% + $0.30 | - | Same as Lean scenario |

### Monthly Operating Budget (Conservative)

```
Fixed costs:             $40 (mid-range Standard)
+ Domain:               $1
+ Tools/monitoring:     $5
+ Marketing/ads:        $0 (optional)
─────────────────────────
TOTAL MONTHLY:         $46

Conservative estimate: $30–50/month
```

### Breakeven & Profitability Analysis

**Calculation (Stripe scenario, Standard infrastructure):**
- Fixed costs: $40/month
- Stripe fee: 3.2% + $0.30 per $20 sale
- Net per sale: $20 × 0.968 - $0.30 = $19.04

**Breakeven point:**
- Need $40 fixed cost coverage
- At $19.04 net per sale: $40 ÷ $19.04 = **2.1 sales needed**
- **Realistic breakeven: 2–3 sales/month** (vs. 1–2 in Lean)

### Profitability by Stream (Standard Scenario)

| Stream | Units to Breakeven | Timeline | Notes |
|--------|-------------------|----------|-------|
| **Digital Products** | 2–3 sales | Week 2–3 | Still easily profitable |
| **PoD** | 4–5 prints | Week 3–4 | Slightly higher threshold |
| **Affiliate** | $40–50 commission | Week 4–8 | Same timeline, higher threshold |
| **SaaS** | 2–3 MRR @ $20/mo | Week 8–12 | Early MRR helps offset costs |

### When to Upgrade from Lean to Standard

**Trigger points:**
- Revenue exceeds $150/month sustainably (3–4 weeks of operation)
- Or: User hands off (March 31) and system requires managed services for autonomy
- Or: Database traffic exceeds self-hosted capacity (unlikely in first 90 days)

**DO NOT upgrade if:**
- Still testing (first 1–2 weeks)
- Revenue is volatile or unproven
- Workstation is still running n8n locally

### Runway Calculation (Standard Scenario)

Given $1,000 seed budget:

```
Fixed monthly cost:      $40
Expected daily burn:     $1.33
Days until break-even:   30 days (at $40/month spend, need ~2–3 sales)

Scenario A: No revenue
- Days of runway: 1000 ÷ 40 = 25 days
- Dangerous: Would run out by Day 25

Scenario B: 2 sales/week (likely)
- Weekly revenue: 2 sales × $19 net = $38
- Weekly burn: $9.23
- Net gain: $28.77/week
- **Actually cash-positive by week 2**
- Runway: Indefinite after break-even

Realistic scenario (Days 1–30):
- Week 1: 0 sales (setup)
- Week 2: 2 sales ($38 net)
- Week 3: 4 sales ($76 net)
- Week 4: 5 sales ($95 net)
- Total month 1 revenue: ~$209 net
- Total month 1 cost: $40
- **Net positive: +$169**
```

**Conclusion:** Standard scenario is profitable by Week 2–3 once first sales arrive.

---

## Scenario 3: CLOUD ($100–200+/month)

### Architecture
- PostgreSQL: Full managed (AWS RDS, Google Cloud SQL)
- n8n: Managed or premium self-hosted
- Redis: Managed (AWS ElastiCache, Google Memorystore)
- Selenium: Premium cloud (BrowserStack, Sauce Labs, or ScrapingBee Pro)
- Monitoring: Full observability (DataDog, New Relic, CloudWatch)
- Backups: Fully automated with redundancy
- Auto-scaling: Infrastructure auto-scales with load

### Monthly Fixed Costs Breakdown

| Service | Cost | Notes |
|---------|------|-------|
| **Database** | | |
| AWS RDS PostgreSQL | $20–50 | db.t3.micro ($15) + storage + backups |
| Google Cloud SQL | $20–40 | Similar pricing |
| Azure Database | $25–50 | Similar tier |
| **Caching** | | |
| AWS ElastiCache | $15–30 | cache.t3.micro + data transfer |
| Google Memorystore | $10–25 | Similar |
| **Scraping** | | |
| BrowserStack Automate | $25–49 | 5–10 parallel sessions |
| Sauce Labs | $29–99 | Premium tier |
| ScrapingBee Pro | $25–99 | 50k+ requests/month |
| **Automation** | | |
| n8n Cloud Premium | $15–25 | If using cloud version |
| **Monitoring** | | |
| DataDog | $15–25 | 15 hosts, alerting |
| CloudWatch (AWS) | $0–10 | Minimal if AWS-based |
| **CDN (optional)** | | |
| CloudFlare | $0–20 | Free tier or Pro |
| **Domain + SSL** | | |
| Namecheap + SSL | $1 | Included in ecosystem |
| **Load Balancing** (if needed) | | |
| AWS Load Balancer | $16–20/month | Not needed yet |
| **Total Fixed (base)** | **$110–150** | Without premium scraper |
| **Total Fixed (premium)** | **$150–250+** | With all premium services |

### Variable Costs (Per Transaction)

| Service | Fee | When | Notes |
|---------|-----|------|-------|
| Stripe | 3.2% + $0.30 | Per digital sale | Same as other scenarios |
| PayPal | 3.5% | Affiliate payouts | Same |
| Redbubble | ~15% | Per PoD sale | Same |
| Data transfer (overage) | $0.12 per GB | If exceeding free tier | Unlikely at first |
| Compute overage | $0.01–0.10 per request | If auto-scaling kicks in | Unlikely at start |

### Monthly Operating Budget (Cloud Enterprise)

```
Fixed costs:             $150 (mid-range Cloud)
+ Domain:               $1
+ Monitoring/tools:     $20
+ Marketing/ads:        $0
+ Overage buffer:       $10
─────────────────────────
TOTAL MONTHLY:         $181

Conservative estimate: $100–200+/month
```

### When Cloud Makes Sense

**DO NOT use Cloud scenario unless:**
- Revenue exceeds $500+/month sustainably
- Workload requires auto-scaling (unlikely in first year)
- Team requires managed backups & SLAs (overkill for solo founder)
- Enterprise customers require compliance (not applicable yet)

**This scenario is oversized for MakinMoves Days 1–90.**

### Breakeven & Profitability Analysis (Cloud)

**Calculation:**
- Fixed costs: $150/month
- Stripe fee: 3.2% + $0.30 per $20 sale
- Net per sale: $19.04

**Breakeven point:**
- Need $150 fixed cost coverage
- At $19.04 net per sale: $150 ÷ $19.04 = **7.9 sales needed**
- **Realistic breakeven: 8–10 sales/month**

### Profitability by Stream (Cloud Scenario)

| Stream | Units to Breakeven | Timeline | Notes |
|--------|-------------------|----------|-------|
| **Digital Products** | 8–10 sales | Week 4–5 | Much higher threshold |
| **PoD** | 12–15 prints | Week 5–7 | High threshold, tight margin |
| **Affiliate** | $150–180 commission | Week 8–12 | Requires significant traffic |
| **SaaS** | 8–10 MRR @ $20/mo | Week 12+ | Break-even becomes feasible |

### Runway Calculation (Cloud Scenario)

Given $1,000 seed budget:

```
Fixed monthly cost:      $150
Expected daily burn:     $5
Days until break-even:   30 days

Scenario: No revenue
- Days of runway: 1000 ÷ 150 = 6.7 days
- **CRITICAL: Runs out by Day 7**

Scenario: 2 sales/week (likely)
- Weekly revenue: 2 × $19 = $38
- Weekly burn: $34.50
- **Losing $3.50/week**
- Would deplete $1k in ~20 weeks (5 months)
- **Not sustainable without $500+/month revenue**

Scenario: 8 sales/week (optimistic)
- Weekly revenue: 8 × $19 = $152
- Weekly burn: $34.50
- Net gain: $117.50/week
- **Profitable, but requires high volume early**
```

**Conclusion:** Cloud scenario is **NOT recommended** for Days 1–90. Cost is too high relative to expected early-stage revenue.

---

## COMPARATIVE ANALYSIS: 3 Scenarios Head-to-Head

### Cost Comparison Table

| Metric | Lean | Standard | Cloud |
|--------|------|----------|-------|
| **Monthly Fixed Cost** | $10–20 | $30–50 | $100–200+ |
| **Sales Needed to Break Even** | 1–2/month | 2–3/month | 8–10/month |
| **Net Margin Per $20 Sale** | $19.04 | $19.04 | $19.04 |
| **Runway at $1k (no revenue)** | ~3000 days | 25 days | 6.7 days |
| **When Profitable** | Week 1 | Week 2–3 | Week 4–5+ |
| **Operational Complexity** | Low | Medium | High |
| **Scalability** | To $10k/mo | To $50k+/mo | To $100k+/mo |

### Profitability Timeline (All Scenarios)

**Assumption: Achieve 2–3 sales/week by Week 2 (realistic)**

```
LEAN SCENARIO ($10–20/mo)
────────────────────────
Week 1: 0 sales, $10 cost → -$10
Week 2: 2 sales, $10 cost → $38 - $10 = +$28 ✓ PROFITABLE
Week 3: 4 sales, $10 cost → $76 - $10 = +$66
Month 1: ~8 sales, $10 cost → $152 - $10 = +$142 ✓ CASH POSITIVE

STANDARD SCENARIO ($30–50/mo)
──────────────────────────────
Week 1: 0 sales, $40 cost → -$40
Week 2: 2 sales, $40 cost → $38 - $40 = -$2 (CLOSE!)
Week 3: 4 sales, $40 cost → $76 - $40 = +$36 ✓ PROFITABLE
Month 1: ~8 sales, $40 cost → $152 - $40 = +$112 ✓ CASH POSITIVE

CLOUD SCENARIO ($150/mo)
───────────────────────
Week 1: 0 sales, $150 cost → -$150
Week 2: 2 sales, $150 cost → $38 - $150 = -$112
Week 3: 4 sales, $150 cost → $76 - $150 = -$74
Week 4: 6 sales, $150 cost → $114 - $150 = -$36
Month 1: ~8 sales, $150 cost → $152 - $150 = +$2 (BARELY)
```

**Verdict:** Lean and Standard become profitable by Week 2–3. Cloud takes until Week 4–5.

---

## FINANCIAL MODELING: Detailed Breakeven by Revenue Stream

### Digital Products (Gumroad / Etsy Digital)

**Product:** $20 template
**Platform:** Gumroad (recommended)
**Processing:** Stripe via Gumroad

#### Lean Scenario
```
Revenue per sale:           $20
Gumroad fee (8.5%):         -$1.70
Stripe fee (3.2% + $0.30):  -$0.94
─────────────────────────
Net revenue per sale:       $17.36

Monthly fixed cost:         $10
Break-even sales:           10 ÷ 17.36 = 0.58 sales
Realistic break-even:       1 sale (by Day 7)

If selling 2/week (realistic):
Weekly revenue:             2 × $17.36 = $34.72
Weekly cost:                $2.31
Net gain/week:              $32.41
Month 1 revenue:            ~8 sales = $138.88
Month 1 profit:             $138.88 - $10 = $128.88
```

#### Standard Scenario
```
Same net revenue per sale:  $17.36
Monthly fixed cost:         $40
Break-even sales:           40 ÷ 17.36 = 2.30 sales
Realistic break-even:       2–3 sales (by Day 10–14)

If selling 2/week:
Month 1 revenue:            ~8 sales = $138.88
Month 1 profit:             $138.88 - $40 = $98.88
(More sustainable as cost goes up, less margin for error)
```

#### Cloud Scenario
```
Same net revenue per sale:  $17.36
Monthly fixed cost:         $150
Break-even sales:           150 ÷ 17.36 = 8.65 sales
Realistic break-even:       9 sales (by Day 21–28)

If selling 2/week:
Month 1 revenue:            ~8 sales = $138.88
Month 1 profit:             $138.88 - $150 = -$11.12 ✗ (LOSS!)
Requires 10+ sales in month 1 to break even
```

**Digital Products Winner: LEAN (1–2 sales to break even)**

---

### Print-on-Demand (Redbubble / Merch by Amazon)

**Product:** $30 hoodie / $25 shirt
**Platform:** Redbubble (recommended, easiest for affiliate integration)
**Processing:** Redbubble handles; royalty per sale

#### Redbubble Economics
```
Product base price:         $30
Redbubble margin (~50%):    -$15 (their cut)
─────────────────────────
Creator royalty:            $15 per sale

Processing (affiliate):     Assumed included
Net per sale:               ~$15 (no additional fees if using Redbubble)
```

#### Lean Scenario
```
Net revenue per sale:       $15
Monthly fixed cost:         $10
Break-even sales:           10 ÷ 15 = 0.67 sales
Realistic break-even:       1 sale (by Week 2)

If selling 2 designs/week:
Weekly revenue:             2 × $15 = $30
Weekly cost:                $2.31
Net gain/week:              $27.69
Month 1 revenue:            ~8 sales = $120
Month 1 profit:             $120 - $10 = $110
```

#### Standard Scenario
```
Net revenue per sale:       $15
Monthly fixed cost:         $40
Break-even sales:           40 ÷ 15 = 2.67 sales
Realistic break-even:       3 sales (by Week 3)

Month 1 revenue:            ~8 sales = $120
Month 1 profit:             $120 - $40 = $80
(Still profitable, but margin tighter)
```

#### Cloud Scenario
```
Net revenue per sale:       $15
Monthly fixed cost:         $150
Break-even sales:           150 ÷ 15 = 10 sales
Realistic break-even:       10 sales (by Day 25+)

Month 1 revenue:            ~8 sales = $120
Month 1 profit:             $120 - $150 = -$30 ✗ (LOSS!)
Requires 10+ sales in month 1 to break even
```

**PoD Winner: LEAN or STANDARD (2–3 sales to break even)**

---

### Affiliate Marketing (Content / Blog)

**Product:** Blog article with affiliate links
**Network:** Amazon Associates (4–7% commission)
**Platform:** Ghost or self-hosted blog

#### Affiliate Economics
```
Example: Tech product review → $100 sale
Amazon commission (5%):      $5 per sale
(No processing fees; Amazon handles it)

Realistic scenario:
- First 2 months: $0 (building SEO)
- Month 3: 1–2 clicks/week → $5–10/month
- Month 4–6: 3–5 clicks/week → $15–25/month
- Month 6+: Compounding traffic → $50+/month

Break-even timeline: Month 3–4 (8–12 weeks before profitable)
```

#### Lean Scenario
```
Fixed monthly cost:         $10
Affiliate commission target: $15/month (realistic by month 3)

Break-even:                 Month 3, once generating $15/month
Sustainable:                After 12 weeks, generates $50+/month passive

Month 1–2 loss:             -$20 (setup, no revenue)
Month 3+:                   +$40/month net (once traffic builds)
```

#### Standard Scenario
```
Fixed monthly cost:         $40
Affiliate commission target: $50/month (realistic by month 4)

Break-even:                 Month 4, once generating $50+/month
Sustainable:                After 16 weeks

Month 1–3 loss:             -$120 (setup cost)
Month 4+:                   +$10+/month net
(Tighter, less forgiving)
```

#### Cloud Scenario
```
Fixed monthly cost:         $150
Affiliate commission target: $150/month (requires significant traffic)

Break-even:                 Month 5+, once generating $200+/month
Sustainable:                After 20+ weeks (very long runway)

Month 1–4 loss:             -$600 (unsustainable)
(Cloud scenario makes no sense for affiliate strategy)
```

**Affiliate Winner: LEAN (lowest cost allows long runway for organic growth)**

---

### SaaS (Subscription Product)

**Product:** Niche dashboard / automation tool
**Price:** $20/month (or $49 one-time)
**Processing:** Stripe

#### SaaS Economics
```
Monthly subscription:        $20/subscriber
Stripe fee (3.2% + $0.30):  -$0.94
─────────────────────────
Net MRR per subscriber:      $19.06

Assumption: Takes 12 weeks to get first paid subscriber
            By month 3 (day 60): 5–10 subscribers (realistic for indie)
```

#### Lean Scenario
```
Fixed monthly cost:          $10
Monthly recurring revenue (MRR) needed: $10 (break even)
Break-even subscribers:      10 ÷ 19.06 = 0.52 subscribers ✓

If achieving 1 subscriber/month by week 8:
Month 3 (day 60):            2 subscribers → $38.12 MRR
Month 3 cost:                $10
Month 3 profit:              +$28.12

By Day 90:                   5 subscribers → $95.30 MRR
Month 3 profit:              $95.30 - $10 = +$85.30
```

#### Standard Scenario
```
Fixed monthly cost:          $40
Monthly recurring revenue needed: $40 (break even)
Break-even subscribers:      40 ÷ 19.06 = 2.1 subscribers ✓

If achieving 1 subscriber/month by week 8:
Month 3 (day 60):            2 subscribers → $38.12 MRR
Month 3 cost:                $40
Month 3 profit:              -$1.88 ✗ (barely breaks even)

By Day 90:                   5 subscribers → $95.30 MRR
Month 3 profit:              $95.30 - $40 = +$55.30
(Tight margin, requires consistent growth)
```

#### Cloud Scenario
```
Fixed monthly cost:          $150
Monthly recurring revenue needed: $150 (break even)
Break-even subscribers:      150 ÷ 19.06 = 7.87 subscribers

If achieving 1 subscriber/month by week 8:
Month 3 (day 60):            2 subscribers → $38.12 MRR
Month 3 cost:                $150
Month 3 profit:              -$111.88 ✗ (loss)

By Day 90:                   5 subscribers → $95.30 MRR
Month 3 profit:              $95.30 - $150 = -$54.70 ✗ (still loss!)

Requires 8+ subscribers by month 3 to break even
(Unlikely without significant marketing)
```

**SaaS Winner: LEAN (lowest cost allows runway for validation & growth)**

---

## AGGREGATE PROFITABILITY MODEL: Multi-Stream Scenario

**Realistic execution (Days 1–90):**
- Digital Products: 8–10 sales → $138–172
- PoD: 8–10 sales → $120–150
- Affiliate: $0 (first 60 days), then $50–100/month
- **Total Month 1 revenue:** $258–322
- **Total Month 2 revenue:** $350–500 (compounding)
- **Total Month 3 revenue:** $500–750+ (with affiliate)

### Revenue Projection by Scenario

```
LEAN SCENARIO ($10/mo cost)
──────────────────────────
Week 1:   $0 revenue,      $10 cost    → Loss: -$10  | Cumulative: -$10
Week 2:   $70 revenue,     $10 cost    → Profit: +$60 | Cumulative: +$50
Week 3:   $120 revenue,    $10 cost    → Profit: +$110 | Cumulative: +$160
Week 4:   $140 revenue,    $10 cost    → Profit: +$130 | Cumulative: +$290

Month 2:  $350 revenue,    $10 cost    → Profit: +$340 | Cumulative: +$630
Month 3:  $500 revenue,    $10 cost    → Profit: +$490 | Cumulative: +$1,120

Breakeven: Day 14 (Week 2)
Reached $1k recovery: Day 75 (2.5 months)
Recovery goal ($10k): ~24 months at consistent growth
```

```
STANDARD SCENARIO ($40/mo cost)
──────────────────────────────
Week 1:   $0 revenue,      $40 cost    → Loss: -$40  | Cumulative: -$40
Week 2:   $70 revenue,     $40 cost    → Profit: +$30 | Cumulative: -$10
Week 3:   $120 revenue,    $40 cost    → Profit: +$80 | Cumulative: +$70
Week 4:   $140 revenue,    $40 cost    → Profit: +$100 | Cumulative: +$170

Month 2:  $350 revenue,    $40 cost    → Profit: +$310 | Cumulative: +$480
Month 3:  $500 revenue,    $40 cost    → Profit: +$460 | Cumulative: +$940

Breakeven: Day 21 (Week 3, later than Lean)
Reached $1k recovery: Day 82 (similar to Lean)
Recovery goal ($10k): ~24 months at consistent growth
(Margin tighter, but timeline similar due to larger base)
```

```
CLOUD SCENARIO ($150/mo cost)
─────────────────────────────
Week 1:   $0 revenue,      $150 cost   → Loss: -$150 | Cumulative: -$150
Week 2:   $70 revenue,     $150 cost   → Loss: -$80  | Cumulative: -$230
Week 3:   $120 revenue,    $150 cost   → Loss: -$30  | Cumulative: -$260
Week 4:   $140 revenue,    $150 cost   → Loss: -$10  | Cumulative: -$270

Month 2:  $350 revenue,    $150 cost   → Profit: +$200 | Cumulative: -$70
Month 3:  $500 revenue,    $150 cost   → Profit: +$350 | Cumulative: +$280

Breakeven: Day 35 (Week 5, much later)
Reached $1k recovery: Day 120+ (4 months)
$1k seed would be DEPLETED by Day 40 without revenue ramp-up
Recovery goal ($10k): ~30 months (slower due to high overhead)
```

---

## RUNWAY ANALYSIS: Given $1,000 Seed Budget

### Scenario Comparison

| Scenario | Monthly Burn | Days to Depletion | Breakeven Point | Recommended If |
|----------|-------------|-------------------|-----------------|----------------|
| **Lean** | $10 | 3,000 days | Day 14 | ✓ **YES** (Days 1–30) |
| **Standard** | $40 | 25 days | Day 21 | ⏳ Maybe (if launching late March) |
| **Cloud** | $150 | 6.7 days | Day 35 | ✗ **NO** (way too expensive) |

### Critical Runway Thresholds

**Lean scenario:**
- Monthly burn: $10
- Even with ZERO revenue, runway is infinite
- Can afford to spend weeks testing and optimizing
- Break-even is automatic at 1–2 sales/month

**Standard scenario:**
- Monthly burn: $40
- **CRITICAL DEADLINE:** Day 25 (need revenue by then!)
- If no sales by Week 3, cash depletes
- Requires faster execution and higher confidence

**Cloud scenario:**
- Monthly burn: $150
- **CRITICAL DEADLINE:** Day 6–7 (unsustainable!)
- Loses $5/day with zero revenue
- **NOT VIABLE** for bootstrap operation

---

## UPGRADE PATH: When to Move Between Scenarios

### Lean → Standard (Upgrade Trigger)

**DO upgrade when:**
- Revenue consistently exceeds $150/month
- Need automated backups + managed services
- Traffic exceeds local machine capacity
- User hands off (March 31) and system requires autonomy

**DO NOT upgrade when:**
- Still in testing phase (first 2 weeks)
- Revenue is sporadic or unproven
- Infrastructure is working fine locally
- Cash position is tight

**Upgrade cost:**
- One-time migration: 2–4 hours setup
- Added monthly cost: +$20–30
- Payback: Immediate (reduces operational risk)

### Standard → Cloud (Upgrade Trigger)

**DO upgrade when:**
- Revenue exceeds $500+/month consistently
- Need high-availability SLAs (99.9%+)
- Traffic requires auto-scaling
- Enterprise customers demand compliance

**DO NOT upgrade when:**
- Revenue is still <$200/month
- Solo founder operating solo
- Bootstrapped budget is tight
- No customers requiring enterprise SLAs

**Upgrade cost:**
- One-time migration: 4–8 hours setup
- Added monthly cost: +$50–150
- Payback: Only if revenue supports it

---

## CFO RECOMMENDATION: Which Scenario to Choose

### IMMEDIATE (Days 1–7): Start with LEAN

**Why:**
1. **Cost:** $10–20/month is negligible vs. $1k seed
2. **Risk:** Can afford infinite runway with zero revenue
3. **Flexibility:** Easy to scale up or down without lock-in
4. **Speed:** Set up in 4 hours (Docker already running locally)
5. **No unnecessary complexity:** Over-engineering kills velocity

**Action items:**
- Keep current Docker setup (PostgreSQL, n8n, Redis locally)
- Automate backups to GitHub/Dropbox (free)
- Set monthly $1 domain cost aside from $1k seed
- Reserve $200+ for emergency tool purchases

### DECISION POINT (Day 21–30): Assess Revenue & Upgrade

**If revenue ≥ $150/month by Day 21:**
- ✓ Upgrade to Standard scenario
- Cost increase: +$30/mo (easily covered by revenue)
- Benefit: Managed services, better reliability

**If revenue < $150/month by Day 21:**
- ✓ Stay with Lean scenario
- Continue optimizing product/content
- Reassess in another 2 weeks

**If user hands off March 31 (before Day 21 data):**
- Upgrade to Standard *before* March 31
- Managed services required for autonomous operation
- n8n Cloud or Railway PostgreSQL are minimum viable
- Total cost: $30–50/mo (affordable)

### NEVER use Cloud scenario in Days 1–90

- Cost is 10x higher than needed
- Revenue unlikely to support $150/mo burn
- Over-engineered for indie/bootstrap operation
- Revisit only if hitting $500+/month revenue

---

## PAYMENT PROCESSING FEES: Detailed Breakdown

### By Platform & Stream

| Stream | Platform | Processing Method | Fee Rate | Notes |
|--------|----------|-------------------|----------|-------|
| **Digital Products** | Gumroad | Stripe | 8.5% Gumroad + 3.2% Stripe | 11.7% total cut |
| **Digital Products** | Gumroad | PayPal | 8.5% Gumroad + 3.5% PayPal | 12% total cut |
| **PoD** | Redbubble | Internal (royalty) | 50% Redbubble keeps | No additional fees |
| **PoD** | Merch by Amazon | Internal (royalty) | 60% Amazon keeps | No additional fees |
| **Affiliate** | Amazon Associates | Internal | 4–7% commission | No fees, network pays you |
| **Affiliate** | ShareASale | Internal | 5–15% commission | No fees, network pays you |
| **SaaS** | Gumroad (one-time) | Stripe | 8.5% Gumroad + 3.2% Stripe | 11.7% total |
| **SaaS** | Stripe (recurring) | Stripe | 3.2% + $0.30 | Lowest for subscriptions |
| **SaaS** | Paddle | Paddle | 5% + $0.50 | Alternative; covers VAT |

### Net Revenue After Fees (Examples)

**$20 Digital Product via Gumroad:**
```
Sale price:                $20.00
Gumroad cut (8.5%):        -$1.70
Stripe fee (3.2% + $0.30): -$0.94
─────────────────────────
Net to creator:            $17.36
Effective rate:            86.8%
```

**$30 PoD Hoodie via Redbubble:**
```
List price:                $30.00
Redbubble cut (50%):       -$15.00
─────────────────────────
Net to creator:            $15.00
Effective rate:            50%
```

**$100 Affiliate Commission:**
```
Sale price:                $100.00
Amazon commission (5%):     +$5.00
Processing fees:            $0
─────────────────────────
Net to affiliate:           $5.00
Effective rate:            5% (of referred sale)
```

**$20/mo SaaS via Stripe:**
```
Monthly charge:            $20.00
Stripe fee (3.2% + $0.30): -$0.94
─────────────────────────
Net per subscriber:        $19.06
Effective rate:            95.3%
```

### Cost-Sensitive Platform Choices

| Priority | Best Platform | Reasoning |
|----------|---------------|-----------|
| **Lowest fees** | Stripe direct (for SaaS) | 3.2% + $0.30 is rock-bottom |
| **Digital products** | Gumroad (easiest) | 8.5% is standard; integrates Stripe |
| **Alternative DP** | SendOwl or FastSpring | 7.5–8.5% fees; similar to Gumroad |
| **PoD easiest** | Redbubble | 50% cut is standard; no extra fees |
| **PoD alternative** | Merch by Amazon | 60% cut, but better reach |
| **Affiliate best** | Amazon Associates | 4–7% is competitive; passive |
| **Affiliate alternative** | ShareASale or Impact | 5–15% depending on brand |

---

## SUMMARY: Cost Scenarios at a Glance

### Quick Decision Matrix

```
IF you're in Days 1–30 and unsure:
→ Choose LEAN ($10–20/mo)
→ 1–2 sales/month breaks even
→ Infinite runway at current burn rate
→ Easy to upgrade later

IF you're launching near March 31 (user hands off):
→ Choose STANDARD ($30–50/mo) to prepare for autonomy
→ Manages backups and uptime automatically
→ Still affordable even without revenue
→ Costs $1–2 per day; easily paid for by 1–2 sales

IF revenue hits $500+/month and you have 24/7 uptime requirements:
→ Upgrade to CLOUD ($100–200/mo)
→ Only when revenue clearly supports it
→ Not before Day 90

DO NOT DO:
✗ Start with Cloud scenario (way too expensive for bootstrap)
✗ Spend time on infrastructure instead of building products
✗ Optimize infrastructure before proving revenue model
✗ Lock into long-term contracts before proving market fit
```

---

## APPENDIX: SQL Queries for Cost & Revenue Tracking

### Track Monthly Costs

```sql
-- Create costs_tracking table (if not exists)
CREATE TABLE IF NOT EXISTS public.costs_tracking (
    id SERIAL PRIMARY KEY,
    month DATE NOT NULL,
    service VARCHAR(100),
    cost_usd DECIMAL(10,2),
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert monthly costs
INSERT INTO public.costs_tracking (month, service, cost_usd, category) VALUES
('2026-03-01', 'PostgreSQL', 10.00, 'Infrastructure'),
('2026-03-01', 'Domain', 1.00, 'Infrastructure'),
('2026-03-01', 'n8n', 0.00, 'Automation');

-- Query: Total costs this month
SELECT SUM(cost_usd) as total_cost_this_month
FROM public.costs_tracking
WHERE month >= DATE_TRUNC('month', CURRENT_DATE);
```

### Track Profitability by Scenario

```sql
-- Calculate net revenue vs. cost by scenario
SELECT
    'Lean' as scenario,
    10 as monthly_cost_usd,
    COALESCE(SUM(net_amount), 0) as revenue_this_month,
    COALESCE(SUM(net_amount), 0) - 10 as profit_loss
FROM public.revenue_summary
WHERE period >= DATE_TRUNC('month', CURRENT_DATE)

UNION ALL

SELECT
    'Standard' as scenario,
    40 as monthly_cost_usd,
    COALESCE(SUM(net_amount), 0) as revenue_this_month,
    COALESCE(SUM(net_amount), 0) - 40 as profit_loss
FROM public.revenue_summary
WHERE period >= DATE_TRUNC('month', CURRENT_DATE)

UNION ALL

SELECT
    'Cloud' as scenario,
    150 as monthly_cost_usd,
    COALESCE(SUM(net_amount), 0) as revenue_this_month,
    COALESCE(SUM(net_amount), 0) - 150 as profit_loss
FROM public.revenue_summary
WHERE period >= DATE_TRUNC('month', CURRENT_DATE);
```

### Track Payment Processing Fees

```sql
-- Calculate total fees by platform
SELECT
    stream,
    platform,
    COUNT(*) as transactions,
    SUM(gross_amount) as total_revenue,
    SUM(processing_fee) as total_fees,
    ROUND(100.0 * SUM(processing_fee) / SUM(gross_amount), 2) as fee_percentage
FROM public.revenue_summary
WHERE period >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY stream, platform
ORDER BY total_fees DESC;
```

---

## FINAL RECOMMENDATION TO BOARD

**CFO Motion (to be approved by CEO):**

1. **Days 1–30:** Deploy **LEAN scenario** ($10–20/mo)
   - Keep Docker locally or on $5 DigitalOcean droplet
   - All revenue goes to recovery goal (minimal overhead)
   - Runway is infinite; no cash pressure

2. **Day 21–30 decision:** Assess revenue & decide on upgrade
   - If revenue ≥ $150/mo: Upgrade to Standard
   - If revenue < $150/mo: Stay Lean, optimize products
   - If user hands off March 31: Upgrade to Standard preemptively

3. **Never use Cloud scenario** unless revenue clearly supports $150+/mo burn rate

4. **Track payment processing fees** weekly; optimize by Q2 if needed

5. **Communicate costs to team hourly** in standup; update CFO/outbox weekly with cost benchmarks vs. revenue

---

**CFO is ready to execute.**
**Next step: CEO confirms this recommendation for Days 1–30.**

---

**Document prepared by:** CFO
**Status:** Ready for board review and approval
**Review date:** 2026-03-29 16:00 standup
