# Passive Income Research Brief — 2026-03-29

## Executive Summary

Research across 5 key topics reveals a clear market leader: **niche-specific digital products + AI automation**. The fastest-growing segments are AI prompt packs (95%+ margins), specialized Notion templates (high-value organizational systems), and developer tools (averaging $60K+ revenue per product). Our tech stack (n8n, PostgreSQL, Node.js, Claude AI) is ideally positioned to serve these markets at scale.

**Key insight**: The market has shifted from "sell more volume" to "solve one problem extremely well" — micro-products with high margins beat broad templates.

---

## Top 10 Actionable Product Ideas for MakinMoves

### Rank 1: AI Prompt Library for Specific Professions

**What it is:** Pre-built, tested prompt packs tailored to a single profession (e.g., "45 ChatGPT Prompts for Airbnb Hosts" or "30 Claude Prompts for Freelance Writers"). Each pack includes use cases, expected output examples, and a quick-reference guide.

**Platform:** Gumroad (primary) + Etsy (secondary, though AI prompt bundles were banned; focus on Gumroad only for speed)

**Price:** $17–$29 per pack; bundle 3–5 related packs at $49–$79

**How automated:** Claude generates the core prompts → n8n validates quality against benchmarks → PostgreSQL stores inventory + sales data → Gumroad handles delivery via downloadable PDF

**Time to launch:** 24–36 hours (research professions, generate 40–50 prompts, format in Figma, upload)

**Why it wins:** 95%+ profit margins; zero production cost; low competition in niche-specific angles; Gumroad audience expects prompt products; can batch-produce 10 different packs in parallel

**Realistic revenue:** $500–$2,000/month per pack with minimal marketing if niche is right

---

### Rank 2: Specialized Notion Templates for Business Workflows

**What it is:** Pre-built Notion databases solving one clear business problem: a freelancer invoice tracker, a SaaS founder's customer cohort analyzer, a real estate agent's deal pipeline, or a content creator's editorial calendar with AI-powered tagging.

**Platform:** Gumroad (primary for speed) + notiontemplate.xyz (if time allows)

**Price:** $19–$49 per template (single use case); bundle 3 templates at $89–$129

**How automated:** n8n periodically updates template screenshots → PostgreSQL tracks template performance (page views per template, days since launch) → Automated cold outreach via email to communities (Reddit r/Notion, Facebook groups) pointing to Gumroad

**Time to launch:** 48 hours (design template, write documentation, create landing page copy)

**Why it wins:** High perceived value; customers pay for saved setup time; Notion users are already in a spending mindset (premium plans, third-party tools); low churn once delivered (one-time purchase)

**Realistic revenue:** $800–$3,000/month per template if marketed to the right community

---

### Rank 3: n8n Workflow Templates (Ready-to-Deploy Automations)

**What it is:** Export your own n8n workflows as downloadable templates. Example: "Automatically extract data from Google Forms → add to Airtable → send daily digest to Slack." Another: "Monitor 10 competitor websites daily → summarize changes → email report."

**Platform:** Gumroad + n8n Community marketplace (native, but requires approval; dual distribution)

**Price:** $29–$99 depending on complexity; offer a bundle of 3–5 workflows at $149–$249

**How automated:** n8n automatically exports workflows as JSON → include setup documentation → Gumroad hosts; customers import JSON directly into their n8n instance. Revenue tracking in PostgreSQL.

**Time to launch:** 48–72 hours (select 3–5 high-demand workflows you've already built, document, test with new users, package)

**Why it wins:** Proven market: one creator generates $3,200/month from 5 templates; developers already use n8n and trust workflow-based solutions; exportable JSON means zero technical support (self-service deployment)

**Realistic revenue:** $1,500–$4,000/month per 5-workflow bundle

---

### Rank 4: AI-Generated Design Asset Packs

**What it is:** Curated Figma/Photoshop template packs or stock photo preset bundles generated with AI (video LUTs, photography presets, icon sets, color palettes, UI kits). Example: "50 Mobile App UI Components for AI SaaS" or "100 Hand-Drawn Icons for Tech Startups."

**Platform:** Gumroad (primary) + Etsy (secondary; allow 1–2 weeks for AI disclosure review)

**Price:** $19–$39 per pack; bundle 3 packs at $79–$99

**How automated:** Claude (or Midjourney API) generates base designs → n8n quality-checks (metadata, file organization) → PostgreSQL tracks inventory → Gumroad delivers ZIP files

**Time to launch:** 48 hours (generate 100+ assets, organize into cohesive packs, compress ZIP, upload)

**Why it wins:** Stock photo/preset market is massive ($5B+); AI-generated assets are cheaper to produce than curated collections; global demand (YouTubers, podcasters, designers)

**Realistic revenue:** $600–$2,000/month per pack

---

### Rank 5: Micro-SaaS: AI Meeting Transcription & Summary Tool

**What it is:** A lightweight SaaS that connects to Zoom/Google Meet, automatically transcribes calls, and generates AI-powered summaries (action items, key decisions, follow-ups). Store transcripts in PostgreSQL, charge per meeting or monthly subscription.

**Platform:** Own domain (SaaS); Stripe for payment processing

**Price:** $19/month (5 meetings) → $49/month (unlimited); yearly discount: $180/year

**How automated:** n8n integrates with Zoom API → captures call recordings → Claude transcribes + summarizes → PostgreSQL stores data → user dashboard (Node.js + React) shows transcripts and summaries; recurring billing via Stripe

**Time to launch:** 72–96 hours (Zoom API integration, Claude prompt engineering, basic dashboard UI, Stripe setup)

**Why it wins:** AI meeting assistant market is growing 9%+ annually ($3.24B to $7.33B by 2035); subscription model provides recurring revenue (unlike one-time products); low competition in niche; can target startups, legal teams, healthcare clinics

**Realistic revenue:** $1,000–$5,000/month within 3 months if marketed to 1–2 tight niches (legal, healthcare)

---

### Rank 6: Vertical-Specific SaaS: Real Estate Lead Manager

**What it is:** A lightweight CRM + lead tracking tool built specifically for real estate agents and brokers. Includes deal pipeline, client notes, automatic followup reminders, and integration with popular MLS systems.

**Platform:** Own domain (SaaS); Stripe

**Price:** $29/month (solo agent) → $79/month (team); annual: $280/year

**How automated:** n8n syncs with MLS data APIs → PostgreSQL stores leads and deals → Claude generates smart follow-up prompts → Node.js dashboard lets agents track pipeline → Stripe handles recurring billing

**Time to launch:** 120 hours (MVP: lead capture, pipeline view, MLS sync, dashboard); can be phased—launch with lead capture only in week 1, add MLS sync in week 2

**Why it wins:** Real estate is vertical-specific; agents pay $50–$200/month per tool; low competition in SaaS space (most tools are old or overpriced); can acquire customers via real estate FB groups and email lists; recurring revenue scales predictably

**Realistic revenue:** $2,000–$8,000/month if you acquire 50–100 agents

---

### Rank 7: Bulk Data Enrichment & Automation Arbitrage

**What it is:** Build an n8n workflow that scrapes or collects publicly available data (job postings, company data, email lists, website metadata), enriches it with AI (adds summaries, categories, quality scores), and sells the enriched datasets or insights.

**Example:** Monitor 500 competitor websites daily → extract product updates, pricing changes, new hires → package as a "Weekly Competitive Intelligence Report" and sell for $99/month.

**Platform:** Gumroad (one-time data sales) or own SaaS (recurring access to live data feeds)

**Price:** $49–$199 for one-time datasets; $29–$99/month for recurring feeds

**How automated:** n8n fully automated: scrape → enrich → upload → email alert to subscribers. PostgreSQL stores data history. Zero manual work after setup.

**Time to launch:** 96 hours (find data source, build scraper, engineer enrichment prompt, test quality, package first report)

**Why it wins:** "Automation arbitrage" is proven to work; one creator claims $2,700/month from stock image metadata enrichment; zero inventory risk; data never becomes "old"—always fresh

**Realistic revenue:** $1,200–$5,000/month if you nail a specific niche (e.g., "HR decision-makers in fast-growing startups")

---

### Rank 8: Coding Templates & Boilerplates Repository

**What it is:** Pre-built, well-documented code templates for common tasks: "Express.js + PostgreSQL API boilerplate with JWT auth," "React dashboard starter with charts," "Node.js n8n integration example," or "Next.js landing page with Stripe checkout."

**Platform:** Gumroad + GitHub (free repo with link to paid "Pro Version" on Gumroad)

**Price:** $9–$29 per template; bundle 5–10 at $49–$89

**How automated:** GitHub hosts free versions → Gumroad sells enhanced versions (more detailed comments, video walkthroughs, deployment guides) → Claude assists with documentation → n8n tracks which templates sell best (informs next releases)

**Time to launch:** 48 hours (select 3–5 boilerplates you've already built, clean up code, add documentation, upload)

**Why it wins:** Software developers have highest average revenue per product ($60K+) on Gumroad; low time to market; can repackage existing code you've already written; zero production cost; great SEO (GitHub repos rank high)

**Realistic revenue:** $400–$1,500/month if you release 3+ templates and promote on dev communities

---

### Rank 9: Email Marketing Micro-SaaS for Solopreneurs

**What it is:** Lightweight email automation tool (like a simpler Beehiiv or Substack alternative) for solopreneurs and small teams. Features: template builder, automation workflows, segmentation, basic analytics. Integrate with Stripe for subscriptions.

**Platform:** Own domain (SaaS); Stripe

**Price:** $15/month (up to 1,000 subscribers) → $49/month (up to 10K subscribers); annual: $144/year

**How automated:** n8n manages subscriber workflows and sends emails → PostgreSQL stores subscriber data and campaign history → Node.js dashboard for campaign management → Stripe handles recurring billing

**Time to launch:** 120–144 hours (email template builder, subscriber management, basic automation, Stripe integration, landing page)

**Why it wins:** Email marketing tools are sticky (switching costs are high); solopreneurs pay for simplicity over features; Micro-SaaS email tools are trending (low competition from monolithic tools like Mailchimp); recurring revenue

**Realistic revenue:** $1,500–$5,000/month if you acquire 50–150 users

---

### Rank 10: AI-Powered Social Media Content Calendar & Scheduler

**What it is:** A SaaS that lets creators input content ideas → Claude generates 30 days of social posts (LinkedIn, Twitter, Instagram) with hooks, hashtags, and captions → n8n automatically schedules across platforms via Buffer/Later API. Users pay monthly for the automation.

**Platform:** Own domain (SaaS); Stripe + Buffer/Later API

**Price:** $19/month (up to 3 social profiles, 30 posts/month) → $49/month (unlimited profiles, daily generation)

**How automated:** User inputs theme + brand voice → Claude generates posts → n8n schedules via Buffer → PostgreSQL tracks engagement metrics (optional: pull analytics and email weekly report)

**Time to launch:** 96 hours (Claude prompt engineering, Buffer API integration, basic dashboard, Stripe setup, landing page copy)

**Why it wins:** Content creators pay $15–$50/month for schedulers; AI-generated content saves them hours weekly; recurring revenue; can acquire users via creator communities (Twitter, YouTube, Reddit r/ContentCreators)

**Realistic revenue:** $1,000–$4,000/month with 50–200 active users

---

## Top 3 Recommendations for Jason's Situation

### Priority 1: Rank 1 + Rank 2 (Quick Revenue, Low Effort)

**Launch AI Prompt Packs + Notion Templates simultaneously this week.**

- **Why**: Both can launch in 24–48 hours; require zero recurring infrastructure; 95%+ profit margins; Gumroad handles all distribution and payment processing.
- **Effort**: ~40 hours total (20 hours prompt generation + testing, 20 hours template design + documentation).
- **Expected revenue**: $800–$2,500/month combined if you pick 2–3 high-demand niches (e.g., "Prompts for Etsy Sellers" + "Notion Template for Freelancers").
- **Why it matters for Jason**: Gets money flowing immediately while relocating. No servers to manage, no customer support, no scaling headaches.

### Priority 2: Rank 3 (Fast, Leverages Existing n8n Workflows)

**Package 5 of your best n8n workflows as Gumroad templates within 72 hours.**

- **Why**: You've already built these workflows; just document and export them. Proven market ($3,200/month example).
- **Effort**: ~30 hours (selecting workflows, writing documentation, testing with new users).
- **Expected revenue**: $1,500–$4,000/month.
- **Why it matters**: Immediate, no new technology to learn. Targets your exact audience (people who want n8n automation).

### Priority 3: Rank 5 (Medium-term recurring revenue, weeks 2–3)

**Build the AI Meeting Transcription SaaS as a 72-hour MVP, launch by week 2.**

- **Why**: Subscription model = predictable recurring revenue (unlike one-time products). Meeting transcription is a growing market. Your Claude + n8n + PostgreSQL stack is perfect for this.
- **Effort**: ~80 hours for MVP (Zoom API, Claude integration, basic dashboard, Stripe setup).
- **Expected revenue**: $1,000–$3,000/month within 6–8 weeks of launch (conservative, targeting legal/healthcare niches).
- **Why it matters**: Recurring revenue scales; can reinvest earnings into marketing to accelerate growth.

---

## Platforms Comparison

| Platform | Best For | Pros | Cons | Setup Time |
|----------|----------|------|------|-----------|
| **Gumroad** | One-time digital products (prompts, templates, code) | No fees except 10% + payment processing; built-in audience; zero moderation; email distribution | No search engine; audience-driven only; no recurring products (payment limits) | <30 min |
| **Etsy** | Design assets, printables, templates | Massive search traffic (500M+ monthly); built-in buyer base; good for design assets | High competition; 6% + payment fees; AI disclosure required; slower onboarding (1–2 weeks) | 1–2 weeks |
| **Own SaaS** | Recurring revenue products (tools, software, subscriptions) | Full control; recurring revenue; higher margins; scalable | Requires hosting, maintenance, payment processor setup; customer support; longer time to revenue | 72–144 hours |
| **n8n Marketplace** | Workflow templates | Native audience of n8n users; credibility boost; built-in distribution | Approval process (2–4 weeks); smaller audience than Gumroad; lower transaction volume | 2–4 weeks |
| **Shopify** | Physical + digital products | Sophisticated storefront; built for e-commerce; good for bundled offerings | $29–$299/month in fees; slower checkout; better for brands, not solopreneurs | 1–2 weeks |

**Recommendation for MakinMoves**: Launch on **Gumroad** for weeks 1–2 (no fees, instant monetization), then build your own SaaS (Rank 5, 9, 10) by week 3+ for recurring revenue.

---

## Quick Wins (Launch in <48 Hours)

These are realistic because they use existing code/workflows or require minimal design:

1. **AI Prompt Pack #1**: "50 ChatGPT Prompts for Etsy Sellers" — $19 on Gumroad
   - Time: 12 hours (generate, format, upload)
   - Expected first-week sales: $200–$500 (with 1–2 hours of Twitter/Reddit promotion)

2. **Notion Template #1**: "Freelancer Invoice Tracker" — $29 on Gumroad
   - Time: 16 hours (design, document, create guide)
   - Expected first-week sales: $100–$300

3. **n8n Workflow Export**: "Google Forms to Airtable + Slack" — $39 on Gumroad
   - Time: 8 hours (document existing workflow, test, upload)
   - Expected first-week sales: $150–$400

**Combined week 1 potential**: $450–$1,200 in revenue with ~36 hours of work.

---

## Action Items for CEO

1. **Approve product selection** from Rank 1–3 above (recommend all three for parallel launch)
2. **Define Jason's niche focus** for prompts/templates (e.g., "e-commerce sellers" vs. "freelance writers" — matters for marketing)
3. **Allocate hours**: Suggest 40 hours in days 1–2 for prompts/templates, then 80 hours days 3–5 for n8n workflow packaging
4. **Marketing budget**: Minimal spend needed initially (free Twitter, Reddit, communities); allocate $100–$200 for Reddit ads + Twitter ads if conversion is strong by day 3

---

## Sources

Research synthesis based on:
- [Best Selling Products on Gumroad 2025](https://www.accio.com/business/best-selling-products-on-gumroad-2025)
- [10 Digital Products You Can Sell on Gumroad in 2025](https://medium.com/activated-thinker/10-digital-products-you-can-sell-on-gumroad-in-2025-a7e4d6f492ee)
- [Best Digital Products to Sell on Etsy, Gumroad & Shopify (2026 Guide)](https://resellready.co/blogs/news/best-digital-products-to-sell-on-etsy-gumroad-shopify)
- [AI Generated Products That Sell Well on Etsy and Gumroad](https://makemoneywithgpt.com/best-free-ai-prompts-to-sell-on-etsy-or-gumroad/)
- [How to Make Money with n8n Workflow Automation 2026](https://www.browseract.com/blog/how-to-make-money-with-n8n-workflow-automation)
- [I Built 5 n8n Automations That Generate $3,200/Month Passively](https://medium.com/write-a-catalyst/i-built-5-n8n-automations-that-generate-3-200-month-passively-72e2a3050e17)
- [n8n Monetization: 5 Proven Strategies to Earn $5k+/m in 2026](https://ritz7.com/blog/monetize-n8n-automation-skills)
- [Top Passive Income Ideas for Developers in 2025](https://devtechinsights.com/passive-income-developers-2025/)
- [8 Passive Income Ideas for Software Developers](https://blog.payproglobal.com/passive-income-ideas-for-software-developers)
- [20 Best, Profitable Micro-SaaS Startup Ideas for 2025](https://www.microns.io/blog/best-micro-saas-ideas)
- [Micro SaaS Ideas for Solopreneurs 2025](https://www.rapidevelopers.com/blog/micro-saas-ideas-for-solopreneurs-2025)
