# P3 — Affiliate Niche Sites: Operations Manual + Content Publishing System + Monetization Roadmap

**Filed by:** COO
**Date:** 2026-03-29
**Status:** ACTIVE — Operational framework ready for launch

---

## 1. Overview

P3 builds a portfolio of 3 niche affiliate content sites. Each site targets a specific vertical where freelancers/solopreneurs spend money, publishes SEO-optimized content, and earns affiliate commissions on recommended products and services.

**Revenue model:** Affiliate commissions (Amazon Associates, ShareASale, Impact, direct brand programs) + display ads (once traffic thresholds met).

**Target:** $500–$1,000/mo combined affiliate revenue by Month 6.

---

## 2. Niche Site Portfolio

| Site | Niche | Target Audience | Primary Affiliate Programs |
|------|-------|----------------|---------------------------|
| Site A | Freelancer Tools & Software | Solo freelancers | AppSumo, SaaS affiliate programs, Amazon |
| Site B | Home Office & Productivity | Remote workers / WFH crowd | Amazon Associates, desk/chair brands |
| Site C | AI Tools for Business | Solopreneurs, small biz owners | AI tool referral programs, SaaS affiliates |

### Accountability
- **Site Owner (all 3):** COO manages operations, CTMO manages technical infrastructure
- **Content:** COO drives editorial calendar; writers execute (Jason initially, contractors later)
- **Monetization:** CFO tracks revenue; COO manages affiliate relationships

---

## 3. Site Management SOP

### Domain & Hosting Setup (CTMO responsibility)
1. Register domains (Namecheap or Cloudflare — ~$10/domain/year)
2. Hosting: shared hosting initially (Hostinger or similar — ~$3/mo for 3 sites)
3. CMS: WordPress + lightweight theme (GeneratePress or Astra — free tier)
4. Essential plugins: Yoast SEO (free), ThirstyAffiliates (free), WP Rocket (if budget allows), Google Site Kit
5. SSL certificates (free via Let's Encrypt / hosting provider)
6. Google Search Console + Analytics connected on Day 1

### Update Schedule
- **Minimum viable:** 1 new article per site per week (3 total/week)
- **Growth target (Month 2+):** 2 articles per site per week (6 total/week)
- **Mature (Month 4+):** 3 articles per site per week (9 total/week) — requires contractors

### Content Calendar Ownership
- COO maintains rolling 12-week content calendar per site
- Calendar lives in shared Notion database or Google Sheet
- Each entry: target keyword, article type, assigned writer, due date, publish date, status

---

## 4. Content Publishing Pipeline

### Stage 1: Keyword Research → Topic Selection (1–2 days)
- **Tools:** Ubersuggest (free tier), Google Keyword Planner (free), AnswerThePublic (free), Ahrefs free webmaster tools
- **Process:**
  1. Generate 50+ keyword ideas per niche per month
  2. Filter by: search volume (>100/mo), keyword difficulty (<30 for new sites), commercial intent
  3. Prioritize: buyer-intent keywords first ("best [product] for freelancers"), informational second
  4. Map keywords to article types (see Section 7 for templates)
  5. Add to content calendar with target publish date

### Stage 2: Outline Approval → Writer Assignment (1 day)
- COO creates article outline from keyword brief
- Outline includes: target keyword, secondary keywords, H2/H3 structure, word count target, affiliate products to feature, competitor articles to beat
- Assign to writer (Jason or contractor) with deadline

### Stage 3: Draft Completion → Editorial Review (2–3 days)
- Writer submits draft in Google Docs
- Editorial review checklist (see Section 8):
  - Keyword placement (title, H1, first 100 words, naturally throughout)
  - Affiliate links correctly placed and tagged
  - Readability score (target: Flesch-Kincaid Grade 7–8)
  - Images/screenshots included where needed (royalty-free: Unsplash, Pexels)
  - Internal links to other site articles (minimum 2–3 per article)
  - External links to authoritative sources (minimum 1–2 per article)

### Stage 4: Affiliate Link Integration → Final SEO Check (1 day)
- Insert affiliate links using ThirstyAffiliates (cloaked, trackable)
- Add FTC disclosure at top of article (required for all affiliate content)
- Final SEO pass: meta title (60 chars), meta description (155 chars), alt tags on images, schema markup if applicable
- Check for broken links

### Stage 5: Publishing → Internal Linking → Social Amplification (1 day)
- Publish to WordPress
- Add to XML sitemap (auto via Yoast)
- Submit URL to Google Search Console for indexing
- Update internal links on older articles to point to new content
- Share on social channels (Reddit if relevant subreddit exists, Twitter, Pinterest)
- Pin to relevant Pinterest boards (especially for Site B — home office content)

---

## 5. Affiliate Monetization Strategy

### Program Selection by Niche

**Site A — Freelancer Tools:**
| Program | Commission | Cookie Duration | Priority |
|---------|-----------|----------------|----------|
| AppSumo | 5–30% varies | 60 days | HIGH |
| Notion Affiliate | 50% first payment | 90 days | HIGH |
| Canva Affiliate | 15–80% varies | 30 days | MEDIUM |
| FreshBooks | $5 per free trial, $55 per paid | 120 days | HIGH |
| ConvertKit | 30% recurring | 90 days | MEDIUM |
| Amazon Associates | 1–10% varies | 24 hours | LOW (volume play) |

**Site B — Home Office:**
| Program | Commission | Cookie Duration | Priority |
|---------|-----------|----------------|----------|
| Amazon Associates | 1–4% on furniture/electronics | 24 hours | HIGH (volume) |
| Autonomous (desks) | 5–8% | 30 days | MEDIUM |
| Fully (Herman Miller) | 5–10% | 30 days | MEDIUM |
| Ergodox | 5% | 30 days | LOW |
| ShareASale (aggregator) | Varies by merchant | Varies | HIGH (access to hundreds) |

**Site C — AI Tools:**
| Program | Commission | Cookie Duration | Priority |
|---------|-----------|----------------|----------|
| Jasper AI | 30% recurring | 45 days | HIGH |
| Copy.ai | 30% recurring | 90 days | HIGH |
| Surfer SEO | 25% recurring | 60 days | MEDIUM |
| Midjourney (indirect) | N/A — no program yet | N/A | WATCH |
| OpenAI API referral | Varies | Varies | MEDIUM |
| Writesonic | 30% lifetime | 90 days | HIGH |

### Commission Tracking
- **Primary:** Each affiliate program dashboard (manual check weekly)
- **Consolidated:** Google Sheet tracking all programs — updated every Monday
- **Columns:** Program, Site, Clicks, Conversions, Revenue, Commission Rate, Payout Date
- **Monthly:** CFO generates revenue report by site, by program, by article

### Relationship Management
- At 10+ conversions/month per program → email affiliate manager to negotiate higher rates
- At 50+ conversions/month → request exclusive landing pages or custom coupon codes
- Quarterly: review program performance, drop underperformers, add new programs

---

## 6. Performance Tracking Dashboard

### Weekly Metrics (per site)

| Metric | Target (Month 1) | Target (Month 3) | Target (Month 6) |
|--------|------------------|-------------------|-------------------|
| Articles published | 4/month | 8/month | 12/month |
| Organic traffic | 50/day | 300/day | 1,000/day |
| Affiliate clicks | 5/day | 30/day | 100/day |
| Affiliate revenue | $25/month | $150/month | $500/month |
| Email subscribers | 25 | 200 | 1,000 |
| Domain authority | 5 | 15 | 25 |
| Indexed pages | 10 | 30 | 60 |

### Tracking Tools
- Google Analytics 4 — traffic, user behavior, referral sources
- Google Search Console — keyword rankings, indexation, crawl health
- ThirstyAffiliates — click tracking per link
- Individual affiliate dashboards — conversions and revenue
- Ahrefs Webmaster Tools (free) — backlink monitoring, keyword tracking

---

## 7. Article Type Templates

### Template A: Buyer's Guide ("Best [X] for [Audience]")
- **Word count:** 2,000–3,000
- **Structure:** Intro → Quick picks table → Detailed reviews (5–10 products) → Comparison chart → FAQ → Final recommendation
- **Affiliate links:** 3–5 per product mentioned (in-text + CTA buttons)
- **Revenue potential:** HIGH — direct purchase intent

### Template B: Comparison ("X vs Y")
- **Word count:** 1,500–2,000
- **Structure:** Intro → Quick verdict → Feature-by-feature comparison → Pricing → Who should choose what → FAQ
- **Affiliate links:** 2 per product (one in comparison, one in verdict)
- **Revenue potential:** HIGH — buyer at decision stage

### Template C: How-To Guide
- **Word count:** 1,500–2,500
- **Structure:** Intro → What you'll need → Step-by-step → Pro tips → Common mistakes → Related articles
- **Affiliate links:** 1–3 (tools mentioned in the how-to)
- **Revenue potential:** MEDIUM — builds trust, drives return visits

### Template D: Best-Of Listicle ("Top 10 [X]")
- **Word count:** 2,000–3,000
- **Structure:** Intro → Ranked list with mini-reviews → Comparison table → How we chose → FAQ
- **Affiliate links:** 1–2 per item (10–20 total)
- **Revenue potential:** HIGH — high click volume, multiple products

### Template E: News/Roundup
- **Word count:** 800–1,200
- **Structure:** What happened → Why it matters → What to do about it → Related products
- **Affiliate links:** 1–2 contextual
- **Revenue potential:** LOW — drives traffic, not direct revenue

---

## 8. Editorial Quality Checklist

Before publishing ANY article:

- [ ] Target keyword in title, H1, first 100 words, and 2–3 H2s
- [ ] Meta title ≤ 60 characters, includes primary keyword
- [ ] Meta description ≤ 155 characters, includes CTA
- [ ] FTC affiliate disclosure present at top of article
- [ ] All affiliate links working and correctly tagged
- [ ] ThirstyAffiliates cloaking applied to all affiliate URLs
- [ ] Internal links: minimum 2–3 to other site articles
- [ ] External links: minimum 1–2 to authoritative sources
- [ ] Images: minimum 3 per article, all with descriptive alt tags
- [ ] Readability: Flesch-Kincaid Grade 7–8 (check via Yoast or Hemingway)
- [ ] No grammar/spelling errors (Grammarly pass)
- [ ] No plagiarism (Copyscape or similar)
- [ ] Mobile-friendly formatting (short paragraphs, subheadings every 200–300 words)
- [ ] Schema markup added if applicable (product review, FAQ, how-to)
- [ ] Social sharing image set (Open Graph)

---

## 9. Edge Cases & Decision Trees

### Article Gets Zero Traffic After 30 Days
```
Check Google Search Console — is it indexed?
├── NOT indexed → Resubmit, check for crawl errors, fix technical SEO
└── Indexed but no traffic
    ├── Check keyword ranking
    │   ├── Not ranking at all → Keyword too competitive, consider retargeting to long-tail variant
    │   ├── Ranking page 2–3 → Content refresh: add 500+ words, update date, improve internal links
    │   └── Ranking page 1 but low clicks → Rewrite meta title/description for better CTR
    └── After refresh, wait 30 more days
        ├── Improvement → Continue optimizing
        └── No improvement → Deprioritize, redirect traffic to higher-performing articles
```

### Affiliate Program Shuts Down
```
Program announces closure
├── Immediate: find replacement program for same products
├── Within 48 hours: update all affected articles with new affiliate links
├── Use ThirstyAffiliates bulk-replace feature (change destination URL once, updates everywhere)
├── If no direct replacement → switch to Amazon Associates as fallback
└── Update affiliate tracking sheet — mark old program as INACTIVE
```

### Competitor Publishes Better Article on Same Topic
```
Competitor outranks us on target keyword
├── Analyze their article: what do they cover that we don't?
├── Content refresh within 1 week:
│   ├── Add missing sections
│   ├── Update data/stats to more recent
│   ├── Add more/better images
│   ├── Improve internal linking
│   └── Add FAQ section with schema markup
├── Build 2–3 internal links from other articles to this one
└── Monitor ranking for 30 days after refresh
```

### Algorithm Update Tanks Traffic
```
Traffic drops >30% week-over-week
├── Don't panic — wait 7 days (fluctuations are normal)
├── After 7 days, still down:
│   ├── Check Google Search Console for manual actions → fix if present
│   ├── Check which pages lost traffic → pattern? (all pages? Just one type?)
│   ├── Review Google's quality guidelines against affected content
│   ├── Content audit: are thin/low-quality pages dragging the site down?
│   │   ├── YES → noindex or improve thin pages
│   │   └── NO → focus on building topical authority, more content in cluster
│   └── Escalate to CEO if traffic doesn't recover within 30 days
```

---

## 10. Escalation Procedures

| Situation | Escalate To | Timeline |
|-----------|------------|----------|
| Site goes down (hosting issue) | CTMO immediately | Within 1 hour |
| Affiliate program TOS violation notice | Jason immediately | Within 4 hours |
| Legal threat (copyright, defamation) | Jason immediately | Within 1 hour |
| Revenue drops >50% month-over-month | CEO + CFO | Within 24 hours |
| Google manual action / penalty | CTMO + CEO | Within 4 hours |
| Writer produces plagiarized content | Remove immediately, notify Jason | Within 4 hours |
| Domain expires or DNS issue | CTMO immediately | Within 1 hour |

**Everything else:** COO handles autonomously.

---

## 11. Contingency Workflows

### If Google Deindexes a Site
1. Check Search Console for manual actions
2. Fix violations immediately
3. Submit reconsideration request
4. Redirect traffic to other sites in portfolio
5. If unrecoverable within 30 days: migrate content to new domain

### If Amazon Associates Account Gets Suspended
1. Review suspension reason
2. Fix compliance issues
3. Apply for reinstatement
4. Meanwhile: switch all Amazon links to direct product pages (no commission, but maintains UX)
5. Diversify: accelerate sign-ups to non-Amazon programs

### If All 3 Sites Underperform at Month 3
1. CEO strategic review: pivot niches? Double down on best performer? Abandon weakest?
2. Analysis: is it traffic problem or conversion problem?
3. If traffic: SEO audit, consider paid promotion for top articles
4. If conversion: review affiliate product selection, CTA placement, page design
5. Nuclear option: consolidate to 1 site, focus all energy there

---

*Filed by COO — 2026-03-29 | Block 2 Complete*
