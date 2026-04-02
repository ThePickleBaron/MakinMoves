# P3 Launch Strategy B: 3-Site Simultaneous Launch
**Date:** 2026-03-29
**From:** CTMO (Technology & Mission Operations)
**For:** CEO, COO, CFO
**Status:** Ready for Decision (High Execution Risk, High Reward)
**Timeline:** Days 1-7 launch all 3 sites, Month 1-3 build content and traffic

---

## Executive Summary

**Strategy B: Launch all 3 niches simultaneously, diversify revenue from Day 1**

- **Day 1-4:** Parallel setup (3 sites, all domains/hosting live)
- **Day 5-7:** Content launch across all 3 (60 total articles)
- **Month 1:** 1,500 combined visitors, $0 revenue (SEO ramp)
- **Month 2:** 3,000 visitors, $500-1,000 revenue
- **Month 3:** 6,000+ visitors, $3,000+ potential
- **Advantage:** Diversified revenue, faster path to $10k recovery
- **Disadvantage:** Higher complexity, Rank Math Pro cost ($27/mo), tighter 36-hour window
- **Path to recovery:** Month 6-7 (optimistic)

---

## Rationale: When Strategy B Wins

**Use Strategy B if:**
1. ✓ Speed > Quality (need $10k recovery by June-July)
2. ✓ COO has 20+ hours/week available for setup sprint
3. ✓ Budget constraint is NOT critical ($27/mo Rank Math Pro is acceptable)
4. ✓ Risk tolerance is moderate (more complexity = more things can break)
5. ✓ Diversification is priority (don't want all eggs in one niche)

**Do NOT use Strategy B if:**
- ✗ COO capacity <15 hours/week for first week
- ✗ Budget is extremely tight (<$100 for 3 months)
- ✗ Quality must be perfect (simultaneous = faster, less polish)
- ✗ Prefer simplicity (1 site is easier to manage than 3)

---

## The 3 Niches (CEO Pre-Approved)

| Niche | Topic | Audience | Affiliate Programs | Revenue Potential |
|-------|-------|----------|-------------------|------------------|
| **Niche 1** | Email Marketing Stack | Creators, solopreneurs | ConvertKit (30%), Beehiiv (30%) | High: $1-3K/mo |
| **Niche 2** | Freelance Tools | Freelancers, agencies | Zapier (20%), Make (20%), ClickUp (30%) | Medium: $500-1.5K/mo |
| **Niche 3** | AI Writing Tools | Content creators, marketers | Jasper (30%), Copy.ai (25%), Writesonic (30%) | High: $1-3K/mo |

---

## Part 1: Parallel Setup (Days 1-4)

### Day 1 (March 29) — Domains, Hosting, Validation (4-5 hours)

**Hour 1-2: Niche Lock-In (All 3)**
- Owner: CEO + COO joint session

**Action Items:**
```
[ ] Confirm all 3 niches approved by CEO (saved to _niche_lock.txt)
    - Niche 1: Email Marketing for Creators ✓
    - Niche 2: Freelance Tools & Automation ✓
    - Niche 3: AI Writing Tools for Content Creators ✓
[ ] Create niche positioning sheet:
    - Niche 1: Solopreneurs + course creators + newsletter writers
    - Niche 2: Freelance designers + developers + agencies
    - Niche 3: Blog writers + YouTubers + content agencies
[ ] Validate affiliate programs (all 3 niches):
    - Niche 1: ConvertKit (30% recurring), Beehiiv (30%), Substack Pro
    - Niche 2: Zapier (tiered), Make (20-30%), ClickUp (30%), Monday (20%)
    - Niche 3: Jasper (30%), Copy.ai (25%), Writesonic (30%), Rytr (30%)
[ ] Create affiliate programs tracker (Google Sheets):
    - Sheet 1: Niche 1 programs + links
    - Sheet 2: Niche 2 programs + links
    - Sheet 3: Niche 3 programs + links
[ ] Apply to all 9+ affiliate programs (takes 15 min per program)
```

**Hour 2-3: Domain Registration (Parallel for all 3)**
- Owner: COO
- Registrar: Namecheap ($12 each)
- Time: 30 min (bulk purchase)

**Action Items:**
```
[ ] Go to Namecheap
[ ] Purchase 3 domains (batch discount available):
    Site 1: "email-stack-guide.com" ($12)
    Site 2: "freelance-tools-guide.com" ($12)
    Site 3: "ai-writing-tools-guide.com" ($12)
    Total: $36
[ ] Create _domains.txt with all 3 URLs + admin links
[ ] Log in to each domain account (save passwords to 1Password)
```

**Hour 3-4: Hosting Setup (Multi-Site)**
- Owner: CTMO + COO
- Hosting: Bluehost can host multiple sites (upgrade to 3-site plan)
- Time: 1 hour

**Action Items:**
```
[ ] Go to Bluehost
[ ] Purchase multi-site plan (supports 3+ WordPress installations):
    - Plan: "Pro" or "Business" ($4.95-9.95/mo first year, $13.95+ renewal)
    - Storage: 200GB+ (covers 3 sites easily)
    - Cost: ~$60/year first year, $170+ renewal
[ ] Point all 3 domains to Bluehost nameservers (Namecheap > Nameservers setting)
    - Bluehost nameservers: ns1.bluehost.com, ns2.bluehost.com, etc.
[ ] Wait for DNS propagation (usually 1-4 hours, continues in background)
[ ] Document: _hosting_setup.txt (all 3 sites' login credentials)
```

**Day 1 Total Cost:**
```
Domains: $36
Hosting (3-site multi, 1 year): $60
Subtotal: $96 (first year), $170+ renewal
Monthly (Year 2+): $13.95/mo Bluehost
```

---

### Day 2 (March 30) — WordPress + Rank Math Setup (6-8 hours)

**Hour 1-2: WordPress One-Click Installs (All 3 parallel)**
- Owner: COO
- Time: 15 min per site (45 min total)

**Action Items:**
```
[ ] Log into Bluehost control panel
[ ] Install WordPress for Site 1 (Email Stack Guide):
    - Run one-click installer
    - Admin user: [COO email]
    - Admin password: [strong, saved to 1Password]
    - Admin URL: email-stack-guide.com/wp-admin
[ ] Install WordPress for Site 2 (Freelance Tools Guide):
    - Same process
    - Admin URL: freelance-tools-guide.com/wp-admin
[ ] Install WordPress for Site 3 (AI Writing Tools):
    - Same process
    - Admin URL: ai-writing-tools-guide.com/wp-admin
[ ] Verify all 3 sites load: [domain].com (show WordPress homepage)
```

**Hour 2-4: Theme Setup (All 3 parallel, 30 min each)**
- Theme: GeneratePress (free, lightweight, SEO-friendly)
- Owner: COO + CTMO split

**Action Items (Per Site, repeat 3x):**
```
[ ] Log into Site 1 WordPress > Appearance > Themes
[ ] Install GeneratePress free (Add New > Search "GeneratePress" > Install)
[ ] Activate
[ ] Customize (10 min per site):
    - Site title: "[Niche] Guide 2025: Best Tools & Reviews"
    - Tagline: "[Audience]-focused tool comparisons & guides"
    - Logo: Create via Canva ($0) — simple text/icon
    - Colors: Brand color (teal #008080 consistent across all 3)
    - Footer: "© 2026 [Site Name] | Affiliate disclosure" (FTC compliance)
[ ] Test mobile responsiveness
```

**Hour 4-5: Rank Math Setup (Critical Path)**
- Owner: CTMO
- Plugin: Rank Math **PRO** ($27/mo, NOT free tier)
- Why PRO: Free tier limited to 1 site; Pro covers unlimited sites

**Action Items:**
```
[ ] Purchase Rank Math Pro subscription ($27/month or $216/year):
    - Go to rankmath.com/pricing
    - Choose Annual ($216, saves vs monthly)
    - Create account with CTMO email
    - Add billing (charged immediately)
    - Download Rank Math Pro plugin
[ ] Install Rank Math plugin on All 3 sites:
    - Log into Site 1 > Plugins > Add New > Upload Rank Math Pro plugin
    - Activate
    - Run Setup Wizard:
        - Business type: "Other"
        - Logo: Upload Canva logo
        - Verify Google Search Console (will do later)
    - Settings > General > Keyword suggestions: Enable
    - Repeat for Sites 2 & 3
[ ] Verify Rank Math Pro license active on all 3 sites
[ ] Create Rank Math API key (for dashboard tracking)
```

**Hour 5-6: Email List Setup (All 3 parallel)**
- Platform: Beehiiv (free tier, supports multiple newsletters)
- Owner: COO
- Time: 30 min

**Action Items:**
```
[ ] Log into Beehiiv account (single account, multiple publications)
[ ] Create Publication 1: "Email Stack Guide Newsletter"
    - Landing page: "10 Email Tools I Actually Use (Checklist)"
    - Form: Simple email signup
    - URL: beehiiv.com/[name]/email-stack-checklist
[ ] Create Publication 2: "Freelance Tools Guide Newsletter"
    - Landing page: "The Freelancer's Essential Tools (2025)"
    - URL: beehiiv.com/[name]/freelance-tools-guide
[ ] Create Publication 3: "AI Writing Tools Newsletter"
    - Landing page: "AI Tools for Content Creators (Exclusive)"
    - URL: beehiiv.com/[name]/ai-writing-tools
[ ] Install Beehiiv plugin on All 3 WordPress sites:
    - Plugins > Add New > "Beehiiv" > Install
    - Configure to embed correct newsletter form per site
[ ] Goal: 50 subscribers per site by end Month 1 (150 total)
```

**Day 2 Total Cost:**
```
Rank Math Pro (1 year): $216
Total cumulative: $96 + $216 = $312 (first year)
Monthly going forward: $27/mo Rank Math + $14/mo Bluehost = $41/mo
```

---

### Days 3-4 (March 31-April 1) — Content Creation (All 3 parallel, 20-25 hours)

**Goal:** Create 60 total articles (20 per site) before publication

**Content Planning (4-5 hours, split across team)**
- Owner: CEO (outlines) + COO (drafting coordination)

**Process:**
```
[ ] Create master content calendar (Google Sheets):
    - Sheet 1: Site 1 articles (20 planned)
    - Sheet 2: Site 2 articles (20 planned)
    - Sheet 3: Site 3 articles (20 planned)

Site 1 (Email Marketing) — 20 Articles:
    1. Pillar: "Email Marketing Stack for Creators 2025" (2,500w)
    2. Comparison: "ConvertKit vs Beehiiv vs Substack" (1,500w)
    3. How-To: "Email Automation with ConvertKit" (1,200w)
    4. Review: "Beehiiv Review 2025" (1,200w)
    5-20: [15 more cluster articles, see template]

Site 2 (Freelance Tools) — 20 Articles:
    1. Pillar: "Best Freelance Tools 2025: Reviewed & Compared" (2,500w)
    2. Comparison: "Zapier vs Make: Automation Showdown" (1,500w)
    3. How-To: "Zapier for Freelancers: Step-by-Step Setup" (1,200w)
    4. Review: "ClickUp for Freelance Teams: Deep Dive" (1,200w)
    5-20: [15 more]

Site 3 (AI Writing) — 20 Articles:
    1. Pillar: "AI Writing Tools for Content Creators 2025" (2,500w)
    2. Comparison: "Jasper vs Copy.ai vs Writesonic" (1,500w)
    3. How-To: "How to Use Jasper for Blog Writing (Guide)" (1,200w)
    4. Review: "Copy.ai Review 2025: Worth It?" (1,200w)
    5-20: [15 more]
```

**Article Writing (15-20 hours, Days 3-4)**
- Owner: COO (primary writer) + CEO (outline + QA)
- Method: Batch writing (all articles for one site, then next site)

**Workflow:**
```
Day 3 Morning (5-6 hours):
    - Write 5 articles for Site 1 (Email Marketing)
    - Use template: 1 pillar (3-4 hours) + 4 clusters (1-1.5 hours each)
    - Save to Google Drive: /Email-Stack-Guide/Articles/

Day 3 Afternoon (5-6 hours):
    - Write 5 articles for Site 2 (Freelance Tools)
    - Same process
    - Save to Google Drive: /Freelance-Tools-Guide/Articles/

Day 4 Morning (5-6 hours):
    - Write 5 articles for Site 3 (AI Writing Tools)
    - Same process
    - Save to Google Drive: /AI-Writing-Tools-Guide/Articles/

Day 4 Afternoon (5-6 hours):
    - Write remaining 5 articles per site (15 total)
    - Prioritize: Complete at least 15 by Day 4 EOD
    - Remaining 5 can draft on Day 5 during publishing sprint
```

**Article Template (Copy-Paste for Speed):**
```markdown
# [Topic] [Year]: [Hook]

## Intro (200 words)
[Problem + why this matters + what you'll learn]

## [Section 1: Main Point] (400 words)
[Details + affiliate context if relevant]
[Example or use case]
[Link to affiliate (if applicable)]

## [Section 2: Secondary Point] (400 words)

## [Section 3: Comparison/Deep Dive] (400 words)

## Conclusion (200 words)
[Summary + CTA to newsletter]

## Disclosure
"I earn commissions if you sign up via my affiliate links (no extra cost to you)"
```

**Quality Control (2-3 hours, Day 4 afternoon)**
- Owner: CEO (quick review of 1-2 articles per site)
- Gate: Must be 800+ words, cover main topic, have affiliate angle

**Day 3-4 Output:**
```
Site 1: 5-8 articles drafted (20,000-32,000 words)
Site 2: 5-8 articles drafted (20,000-32,000 words)
Site 3: 5-8 articles drafted (20,000-32,000 words)
Total: 15-24 articles ready for publication (60,000-96,000 words)
Status: 80% complete (remaining 5-10 articles drafted by Day 5)
```

**Days 3-4 Total Time:**
- COO: 18-22 hours (primary writing)
- CEO: 3-4 hours (outlines + QA)
- CTMO: 1-2 hours (setup monitoring)

---

## Part 2: Publication Sprint (Days 5-7)

### Day 5 (April 2) — Publish Site 1 + Site 2 (4-5 hours)

**Site 1 Publishing (2-3 hours)**
- Owner: COO (with CTMO support for SEO optimization)
- Goal: Publish 4-5 articles on Site 1

**Process (Per Article):**
```
[ ] Create new post in WordPress
[ ] Paste article content
[ ] Optimize with Rank Math:
    - Focus keyword (1 primary keyword per article)
    - Title: Include keyword naturally
    - Meta description: 160 char, include keyword
    - URL slug: Keyword-based
    - Internal links: Link to other site articles
    - Check Rank Math score (aim 80+)
[ ] Add featured image (Canva)
[ ] Publish
[ ] Verify: Page loads, formatting correct, links work
```

**Site 1 Publishing Order (Content Sequence):**
```
Publish first:
1. Pillar article (Email Marketing Stack for Creators)
   - This is your anchor; all other articles link to it
2. Comparison article (ConvertKit vs Beehiiv)
   - Quick win, targets high-intent keywords
3. Beginner article (Email 101 for Creators)
   - SEO-friendly, broader keyword
4. How-to (ConvertKit Setup Guide)
5. Review (Beehiiv Deep Dive)

Reason: Publish pillar first, then link others to it (SEO boost)
```

**Site 2 Publishing (2-3 hours, parallel)**
- Owner: CTMO or COO #2 (if available, otherwise sequential after Site 1)
- Same process as Site 1
- Goal: Publish 4-5 articles on Site 2

**Site 2 Publishing Order:**
```
1. Pillar: Freelance Tools 2025 Reviewed
2. Comparison: Zapier vs Make
3. Beginner: Automation 101 for Freelancers
4. How-to: Zapier Setup for Freelancers
5. Review: ClickUp for Teams
```

**Day 5 Outcome:**
```
Site 1: 4-5 articles live, interlinked
Site 2: 4-5 articles live, interlinked
Site 3: Ready for Day 6
Total live: 8-10 articles, 15K-20K words
```

---

### Day 6 (April 3) — Publish Site 3 + Internal Linking (3-4 hours)

**Site 3 Publishing (2 hours)**
- Owner: COO
- Goal: Publish 4-5 articles

**Process:** Same as Sites 1 & 2

**Internal Linking Across All 3 Sites (1-2 hours)**
- Owner: CTMO
- Goal: Create topical authority with strategic cross-links

**Strategic Linking:**
```
Do NOT cross-link between different niche sites
(Email Stack doesn't link to Freelance Tools)

Within each site, link heavily:
- Site 1: Link every article to pillar article
        - Email automation article → links back to Email Stack Guide
        - ConvertKit review → links to Comparison article
        - Links: 2-3 per article (internal only)

- Site 2: Same strategy with Freelance Tools pillar
- Site 3: Same strategy with AI Writing pillar
```

**Day 6 Outcome:**
```
All 3 sites: 4-5 articles each live (12-15 articles total)
All internal links: Created and verified
Total content live: 15-20 articles, 25-30K words
All sitemaps: Submitted to Google Search Console (via Rank Math)
```

---

### Day 7 (April 4) — Promotion Sprint (3-5 hours)

**Promotion Strategy (Distributed across team)**
- Owner: COO (primary), CTMO support

**Hour 1-2: Reddit Outreach (Per Site, 30 min each)**
- Owner: COO
- Goal: Post 3 sites to relevant communities (without spamming)

**Site 1 Promotion:**
```
[ ] r/solopreneurs: "I tested 10 email platforms for creators (detailed comparison)"
    - Link to Site 1 pillar article
    - Provide value first, no hard sell
    - Offer: "Happy to answer specific questions"
[ ] r/entrepreneurs: "Email platform comparison for online business owners"
[ ] r/contentcreators: "Best email platforms for newsletter writers"
[ ] r/EmailMarketing: "Comprehensive email tool comparison"
```

**Site 2 Promotion:**
```
[ ] r/freelance: "I tested 10 freelance tools (full comparison + setup guides)"
    - Link to Site 2 pillar article
[ ] r/solopreneur: "Automation tools that save freelancers 10 hours/week"
[ ] r/entrepreneurs: "Tools every freelancer should use in 2025"
[ ] r/ServiceBusiness: "Workflow automation for service businesses"
```

**Site 3 Promotion:**
```
[ ] r/contentcreators: "I tested 10 AI writing tools for bloggers/youtubers"
    - Link to Site 3 pillar article
[ ] r/Entrepreneurs: "AI tools that help you write 10x faster"
[ ] r/MarketingAutomation: "AI writing assistants compared (with pricing)"
[ ] r/copywriting: "How I use AI to improve my copy (tools + workflow)"
```

**Hour 2-3: Email Warmup (Per Site, 30 min total)**
- Owner: COO
- Goal: Send launch emails to personal network

**Action Items:**
```
[ ] Draft launch email (Google Docs):
    Subject: "I just published a guide comparing [tools]"
    Content: "After testing 10+ [tools], I published a comprehensive guide..."
    CTA: "Check it out + sign up for updates"

[ ] Send via Beehiiv to each site's newsletter:
    - Site 1 email list: Email Stack Guide subscribers (50+ if available)
    - Site 2 email list: Freelance Tools subscribers
    - Site 3 email list: AI Writing Tools subscribers

[ ] Also share personally:
    - Forward to LinkedIn network (if applicable)
    - Share on personal Twitter (if applicable)
```

**Hour 3-4: Social Media Threads (1-2 hours, async)**
- Owner: CEO or COO
- Goal: Create Twitter/X threads promoting key insights

**Threads to Create (5 total, 1 per site type):**
```
Thread 1 (Site 1): "Top 3 email platforms for creators in 2025"
Thread 2 (Site 1): "Email platform pricing breakdown (what you actually pay)"
Thread 3 (Site 2): "Automation tools that freelancers need"
Thread 4 (Site 3): "AI writing tools for content creators (ranked)"
Thread 5 (General): "Why tool comparisons matter for indie creators"

Publication: Stagger 1 thread/day (Days 7-11)
```

**Hour 4-5: Analytics Setup (30 min, async)**
- Owner: CTMO
- Goal: Verify all sites ready for monitoring

**Action Items:**
```
[ ] Google Search Console: Verify all 3 sites
    - Go to search.google.com/search-console
    - Add property (via Rank Math > integrations)
    - Submit sitemap for each site (auto-generated by Rank Math)
[ ] Google Analytics: Set up tracking
    - Go to analytics.google.com
    - Create GA4 property for each site
    - Add tracking code (via Rank Math plugin)
[ ] Rank Math Dashboard: Verify all 3 sites tracked
    - Log in to rankmath.com dashboard
    - Check: All 3 sites connected
    - Monitor: Keyword rankings, traffic, revenue (once data comes in)
```

**Day 7 Outcome:**
```
All 3 sites: Live + promoted + indexed in Google
Reddit posts: 12 total (4 per site across communities)
Email campaign: Sent to 150+ subscribers
Social media: 5 threads scheduled/posted
Analytics: Tracking ready
Status: LAUNCH COMPLETE
```

---

## Part 3: Content Ramp (Month 1, Weeks 2-4)

### Weekly Publishing Schedule

**Goal:** Publish 3-4 articles per week across all 3 sites (12-16 total/week)

**Content Calendar — Month 1 (April)**

| Week | Site 1 | Site 2 | Site 3 | Total | Total Words |
|------|--------|--------|--------|-------|-------------|
| 1 (Apr 4) | 5 | 5 | 5 | 15 | 18,000 |
| 2 (Apr 11) | 2 | 2 | 2 | 6 | 7,200 |
| 3 (Apr 18) | 2 | 2 | 2 | 6 | 7,200 |
| 4 (Apr 25) | 2 | 2 | 2 | 6 | 7,200 |
| **Month 1 Total** | **11** | **11** | **11** | **33** | **39,600** |

**Weekly Publishing (30-45 min/week planning + 3-4 hours/week writing)**
- Owner: COO (primary), can delegate 1-2 articles/week to freelancer (optional)

**Week 2 Process (April 8-14):**
```
Monday: Write 2 articles (1 each for 2 sites, 3-4 hours total)
Tuesday: Optimize + publish 2 articles in WordPress (1.5 hours)
Wednesday: Promote on Reddit + email (1 hour)
Thursday-Friday: Respond to comments, plan next week
Weekend: Batch-write 3-4 articles for Week 3
```

---

## Part 4: Month 2-3 Growth & Scaling

### Month 2 (May) Goals

**Publishing:**
- Target: 12-16 articles (total 45-50 live)
- Focus: Expand coverage, link-building through content

**Traffic:**
- Goal: 3,000 combined visitors across 3 sites
- Site breakdown: 1,000 + 900 + 1,100 (distributed)

**Revenue:**
- Site 1: $100-200 (affiliate clicks starting)
- Site 2: $75-150 (slower niche)
- Site 3: $150-250 (hot niche)
- Total: $325-600

**Email:**
- Goal: 300-400 total subscribers (100+ per site)

### Month 3 (June) Goals

**Publishing:**
- Target: 12-16 articles (total 57-66 live)
- Refresh top articles with updated data

**Traffic:**
- Goal: 6,000+ combined visitors
- Site breakdown: 2,000 + 1,500 + 2,500

**Revenue:**
- Site 1: $400-700 (affiliate conversions accelerating)
- Site 2: $200-400
- Site 3: $600-1,000 (high-intent traffic)
- Total: $1,200-2,100

**Email:**
- Goal: 500-700 total subscribers

---

## Financial Projections: Strategy B

### Conservative Scenario (Slower SEO + lower conversion)

| Metric | Month 1 | Month 2 | Month 3 | Month 4 | Month 5 | Month 6 |
|--------|---------|---------|---------|---------|---------|---------|
| **Articles (total)** | 15 | 27 | 39 | 51 | 63 | 75 |
| **Traffic/month** | 500 | 1,500 | 3,000 | 4,500 | 6,000 | 8,000 |
| **Email subs** | 75 | 200 | 350 | 500 | 650 | 800 |
| **Site 1 revenue** | $0 | $50 | $200 | $400 | $700 | $1,000 |
| **Site 2 revenue** | $0 | $25 | $75 | $200 | $350 | $500 |
| **Site 3 revenue** | $0 | $75 | $200 | $500 | $800 | $1,200 |
| **Total revenue** | $0 | $150 | $475 | $1,100 | $1,850 | $2,700 |
| **Fixed costs** | $41 | $41 | $41 | $41 | $41 | $41 |
| **Net profit** | -$41 | $109 | $434 | $1,059 | $1,809 | $2,659 |
| **Cumulative** | -$41 | $68 | $502 | $1,561 | $3,370 | $6,029 |

**Recovery Timeline (Conservative):** $10K by Month 10-11

---

### Realistic Scenario (Aligned with stress test baseline)

| Metric | Month 1 | Month 2 | Month 3 | Month 4 | Month 5 | Month 6 |
|--------|---------|---------|---------|---------|---------|---------|
| **Articles (total)** | 15 | 27 | 40 | 52 | 64 | 76 |
| **Traffic/month** | 1,000 | 2,500 | 4,500 | 6,500 | 8,500 | 10,500 |
| **Email subs** | 150 | 300 | 450 | 650 | 850 | 1,050 |
| **Site 1 revenue** | $0 | $150 | $400 | $850 | $1,400 | $1,800 |
| **Site 2 revenue** | $0 | $75 | $200 | $500 | $900 | $1,200 |
| **Site 3 revenue** | $0 | $225 | $500 | $1,200 | $2,000 | $2,800 |
| **Total revenue** | $0 | $450 | $1,100 | $2,550 | $4,300 | $5,800 |
| **Fixed costs** | $41 | $41 | $41 | $41 | $41 | $41 |
| **Net profit** | -$41 | $409 | $1,059 | $2,509 | $4,259 | $5,759 |
| **Cumulative** | -$41 | $368 | $1,427 | $3,936 | $8,195 | $13,954 |

**Recovery Timeline (Realistic):** $10K by Month 6 (HIT TARGET!)

---

### Optimistic Scenario (Strong execution + quality content)

| Metric | Month 1 | Month 2 | Month 3 | Month 4 | Month 5 | Month 6 |
|--------|---------|---------|---------|---------|---------|---------|
| **Articles (total)** | 15 | 28 | 42 | 54 | 66 | 78 |
| **Traffic/month** | 1,500 | 4,000 | 7,000 | 10,000 | 13,000 | 16,000 |
| **Email subs** | 200 | 400 | 600 | 900 | 1,200 | 1,500 |
| **Site 1 revenue** | $50 | $300 | $700 | $1,500 | $2,200 | $3,000 |
| **Site 2 revenue** | $25 | $150 | $400 | $900 | $1,500 | $2,000 |
| **Site 3 revenue** | $50 | $400 | $1,000 | $2,200 | $3,500 | $4,500 |
| **Total revenue** | $125 | $850 | $2,100 | $4,600 | $7,200 | $9,500 |
| **Fixed costs** | $41 | $41 | $41 | $41 | $41 | $41 |
| **Net profit** | $84 | $809 | $2,059 | $4,559 | $7,159 | $9,459 |
| **Cumulative** | $84 | $893 | $2,952 | $7,511 | $14,670 | $24,129 |

**Recovery Timeline (Optimistic):** $10K by Month 5 (AHEAD OF TARGET!)

---

## Risk Factors: Strategy B

### What Could Go Wrong

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| **36-hour setup window too tight** | 40% | Stress, missed deadline | Pre-write articles before sprint, split team |
| **Content quality suffers (rushed)** | 30% | Lower rankings, slower SEO | CEO QA gate: reject <800w articles |
| **Rank Math Pro $27/mo added cost** | 0% | Budget impact | Budget already allocated in Board decision |
| **Google penalizes thin content** | 10% | Traffic loss Month 4+ | Ensure 1,200+ words per article minimum |
| **Affiliate program cuts commission** | 15% | -20% revenue | Diversified programs (4-5 per niche) |
| **Email list doesn't grow** | 20% | Weak early revenue | Promote signup form in every article |
| **All 3 sites simultaneously underperform** | 15% | Miss recovery target | Unlikely; at least 1-2 will perform (diversification hedge) |

### How to Course-Correct

**Month 2 Check-in:**
- If traffic <1,000 combined: Keyword pivot on 1-2 sites, keep 3rd
- If traffic 1,000-3,000: On track → Continue plan
- If traffic >3,000: Ahead of plan → Scale content faster

**Month 3 Decision Point:**
- If cumulative revenue <$300 and traffic <3,000: Consider **consolidating to Strategy A** (focus on 1-2 best sites)
- If on track: Continue 3-site expansion

---

## Execution Readiness: Strategy B

### Time Commitment (Total 50-60 hours over Days 1-7, then 5-8 hours/week ongoing)

**COO Responsibility (35-40 hours):**
- Day 1: Planning + domains/hosting (4 hours)
- Day 2: WordPress setup (2 hours)
- Days 3-4: Content creation (20-22 hours)
- Days 5-7: Publishing + promotion (3-5 hours)
- Week 2+: 2-3 articles/week (4-6 hours)

**CTMO Responsibility (10-12 hours):**
- Day 2: Rank Math Pro setup + configuration (4 hours)
- Days 5-7: Internal linking + analytics (2-3 hours)
- Ongoing: Monitor performance, technical support (2-3 hours/week)

**CFO Responsibility (2-3 hours):**
- Financial setup (1 hour)
- Track monthly metrics (2-3 hours/month)

**CEO Responsibility (4-5 hours):**
- Content QA (2 hours Day 3-4)
- Strategic decisions (2-3 hours)

### Tools Required (Total First-Year Cost: $312 + $27/mo)

| Tool | Cost | When | Owner |
|------|------|------|-------|
| Domains (3x Namecheap) | $36 | Day 1 | COO |
| Hosting (Bluehost, 1 year, 3-site) | $60 | Day 1 | COO |
| Rank Math Pro (annual) | $216 | Day 2 | CTMO |
| Beehiiv free | Free | Day 2 | COO |
| Canva free | Free | Day 2 | COO |
| WordPress | Free | Day 2 | COO |
| **Total Year 1** | **$312** | — | — |
| **Monthly (Year 2+)** | **$41** | — | — |

---

## Success Metrics (Monthly Tracking)

**Tier 1 (Critical):**
- [ ] 3-4 articles published per week (across all sites)
- [ ] 1,000+ combined visitors by Month 2
- [ ] All 3 sites live + indexed by Google (Day 7)

**Tier 2 (Important):**
- [ ] 50+ email subscribers per site by Month 1
- [ ] $300+ cumulative revenue by Month 3
- [ ] 3,000+ combined visitors by Month 3

**Tier 3 (Bonus):**
- [ ] $1,000+ revenue by Month 4
- [ ] 500+ combined email subscribers by Month 3
- [ ] 2-3 articles ranking on page 1-2 per site by Month 3

---

## Strategy Comparison: A vs B

| Factor | Strategy A | Strategy B |
|--------|-----------|-----------|
| **Setup Time** | 30-40 hours | 50-60 hours |
| **Complexity** | Low (1 site) | High (3 sites) |
| **Month 1 Revenue** | $0 | $0 |
| **Month 3 Revenue** | $200-500 | $1,100-2,100 |
| **Month 6 Revenue** | $950-2,300 | $5,800-9,500 |
| **$10K Recovery Timeline** | 9-10 months | 6 months (optimistic) |
| **Risk Level** | Medium | High (more to coordinate) |
| **Budget** | $47/year | $312/year + $27/mo |
| **Best For** | Quality, simplicity | Speed, diversification |
| **Recommendation** | Conservative teams | Aggressive recovery goal |

---

## Summary: Strategy B

**Best for:**
- Speed to $10k recovery (realistic: Month 6-7)
- Diversified revenue (not dependent on 1 niche)
- Higher execution risk tolerance
- COO with 20+ hours/week capacity

**Timeline to $10K recovery:**
- Conservative: 10-11 months
- Realistic: 6 months (HIT TARGET)
- Optimistic: 5 months (EXCEED TARGET)

**Month 1-3 milestones:**
- Month 1: 15 articles (5 per site), 0 revenue, 150 email subs
- Month 2: 27 articles (9 per site), $450 revenue, 300 subs
- Month 3: 40 articles (13 per site), $1,100 revenue, 450 subs

**Go/No-Go Decision:** If Month 2 traffic <1,000 combined, consolidate to Strategy A

---

**Status:** READY TO EXECUTE
**Owner:** COO (primary), CTMO (technical), CEO (strategy/QA), CFO (tracking)
**Approval Required:** CEO + COO joint sign-off before Day 1
**First Gate:** Day 1 close of business (all 3 domains registered + hosting live)
