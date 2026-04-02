# 2-Day Manual Setup Checklist

**Constraint:** After these 2 days, both Claude instances must operate independently. No human in the loop. $1,000 max seed budget spread across multiple initiatives.

---

## BUDGET ALLOCATION ($1,000 max)

| Item | Cost | Purpose |
|------|------|---------|
| Domain name (1 niche site) | $12/yr | Affiliate content hub |
| Cloudflare Pages hosting | $0 | Free static site hosting |
| Beehiiv newsletter (free tier) | $0 | Email list + newsletter monetization |
| Gumroad account | $0 | Digital product sales |
| Etsy seller account | ~$5 | Template marketplace |
| Brave Search API (free tier) | $0 | Research automation |
| Buffer (free tier) | $0 | Social media scheduling |
| Canva (free tier) | $0 | Template creation |
| Notion (free) | $0 | Template creation |
| Redbubble account | $0 | Print-on-demand |
| Medium account | $0 | Content + Partner Program |
| Substack (free) | $0 | Newsletter backup |
| OpenAI API credits | $50 | Content generation if needed |
| **Reserve for paid ads (later)** | $200 | Pinterest/Reddit ads for templates |
| **Reserve for tools as needed** | $200 | Unexpected needs |
| **Emergency buffer** | $533 | Don't spend unless confirmed ROI |
| **TOTAL COMMITTED** | ~$267 | Leaves $733 in reserve |

---

## DAY 1 — ACCOUNTS & PLATFORMS (Priority Order)

### Morning Block (2-3 hours)

- [ ] **1. Gumroad account** — gumroad.com
  - Sign up with email
  - Connect payment method (bank account or PayPal)
  - Set up profile with bio
  - *Why first:* Fastest path to selling digital products

- [ ] **2. Etsy seller account** — etsy.com
  - Sign up as seller
  - Complete shop setup (name, bio, policies)
  - Add payment method for receiving funds
  - *Why:* Second marketplace for templates, high organic traffic

- [ ] **3. Notion account** — notion.so
  - Sign up (free plan)
  - *Why:* Creating Notion templates to sell

- [ ] **4. Canva account** — canva.com
  - Sign up (free tier is fine)
  - *Why:* Creating visual templates and social media content

- [ ] **5. Medium account** — medium.com
  - Sign up
  - Apply for Medium Partner Program (requires 100 followers + 1 published story to start earning — Claude instances can draft content, you publish the first one today)
  - *Why:* Content monetization + affiliate link placement

### Afternoon Block (2-3 hours)

- [ ] **6. Beehiiv newsletter** — beehiiv.com
  - Sign up (free tier: up to 2,500 subscribers)
  - Set up newsletter name, branding
  - Connect domain if you bought one
  - Enable Beehiiv Ad Network (passive ad revenue once you hit 2,500 subs)
  - *Why:* Email list = owned audience, monetizable multiple ways

- [ ] **7. Redbubble account** — redbubble.com
  - Sign up as artist
  - Complete profile and payment setup
  - *Why:* Print-on-demand, zero inventory, passive after upload

- [ ] **8. Buy a domain** — Cloudflare Registrar (cheapest) or Namecheap
  - Pick a niche-relevant domain (e.g., aisolotools.com, smartfreelancestack.com)
  - Point to Cloudflare Pages (free hosting)
  - *Why:* Hub for affiliate content, SEO, newsletter signups

- [ ] **9. GitHub repo** — github.com
  - Create a repo for the affiliate/content site (static site)
  - Connect to Cloudflare Pages for auto-deploy
  - Give the C: drive Claude instance access via the GitHub MCP server
  - *Why:* Claude can push content directly, auto-deploys to live site

- [ ] **10. Cloudflare account** — cloudflare.com
  - Sign up (free)
  - Add your domain
  - Set up Cloudflare Pages project connected to GitHub repo
  - *Why:* Free hosting, CDN, SSL

### Evening Block (1-2 hours)

- [ ] **11. API Keys** — Get these and save to a secure `.env` file in the MakinMoves project:
  - [ ] Brave Search API key (free tier: 2,000 queries/month) — api.search.brave.com
  - [ ] GitHub personal access token (for MCP server)
  - [ ] Any other API keys the C: drive toolkit needs

- [ ] **12. Social media accounts** (pick 2 max to start):
  - [ ] Pinterest business account (best for templates/printables — high purchase intent traffic)
  - [ ] Twitter/X account (for niche content + affiliate links)
  - *Why:* Free traffic channels. Pinterest especially drives Etsy/Gumroad sales.

- [ ] **13. Affiliate program signups:**
  - [ ] ConvertKit affiliate (30% recurring) — convertkit.com/affiliates
  - [ ] Beehiiv affiliate (30% recurring) — beehiiv.com/affiliates
  - [ ] Notion affiliate (if available)
  - [ ] Make.com affiliate (20% recurring)
  - [ ] Any SaaS tools you personally use and can recommend authentically

---

## DAY 2 — CONTENT SEEDING & AUTOMATION WIRING

### Morning Block (2-3 hours)

- [ ] **14. Publish first Medium article**
  - Claude instance will have a draft ready — review and publish
  - This activates Partner Program eligibility
  - Include affiliate links naturally

- [ ] **15. Upload first 2-3 digital templates**
  - Claude instance will have created Notion/Canva templates
  - Upload to Gumroad with pricing ($9-$19)
  - Upload to Etsy with SEO-optimized titles/tags
  - *You just need to click upload and paste descriptions Claude prepared*

- [ ] **16. Upload first 5-10 Redbubble designs**
  - Claude will have generated design concepts/files
  - Upload and set markup percentages
  - Add tags and descriptions Claude prepared

### Afternoon Block (2-3 hours)

- [ ] **17. Verify n8n workflows are running**
  - Check localhost:5678
  - Claude should have set up workflows for:
    - Auto-posting content to social media
    - Monitoring affiliate dashboards
    - Email newsletter automation
  - Test each workflow manually once

- [ ] **18. Set up Buffer/social scheduling**
  - Connect your Pinterest + Twitter accounts
  - Claude will queue up initial posts
  - Verify auto-posting works

- [ ] **19. Send first newsletter**
  - Claude will draft it
  - Review and send via Beehiiv
  - Verify automation for future sends

### Evening Block (1-2 hours)

- [ ] **20. Final verification checklist:**
  - [ ] Gumroad: products listed, payment connected
  - [ ] Etsy: products listed, payment connected
  - [ ] Redbubble: designs uploaded, payment connected
  - [ ] Medium: first article published
  - [ ] Affiliate links: working and tracked
  - [ ] n8n: workflows active and tested
  - [ ] Newsletter: first send done, automation ready
  - [ ] GitHub → Cloudflare: auto-deploy working
  - [ ] Social media: scheduled posts queued
  - [ ] Claude instances: communication system working

- [ ] **21. Grant Claude instances autonomy:**
  - Confirm both instances can access all needed files
  - Verify monitoring script is running (MakinMoves-Monitor scheduled task)
  - Start both instances with "continue working autonomously"

---

## WHAT CLAUDE INSTANCES DO AFTER DAY 2

**C: Drive Instance (Builder):**
- Creates new templates weekly (Notion, Canva)
- Drafts blog/Medium articles with affiliate links
- Generates Redbubble designs
- Manages n8n automation workflows
- Pushes content to GitHub (auto-deploys to site)
- Drafts newsletter content
- Writes status updates to logs/

**D: Drive Instance (Coordinator):**
- Reviews C: instance work quality
- Provides strategic direction
- Answers questions from inbox
- Monitors progress against roadmap
- Adjusts priorities based on what's working

**Automated (no Claude needed):**
- n8n workflows post to social media on schedule
- Cloudflare Pages deploys on git push
- Beehiiv sends scheduled newsletters
- Gumroad/Etsy/Redbubble handle transactions
- Monitor script sends desktop notifications
