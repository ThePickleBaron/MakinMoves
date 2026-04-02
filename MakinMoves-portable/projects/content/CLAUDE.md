# Content / Affiliate Stream — Quick Reference

## Goal
Build niche content sites that rank in search, monetized via ads (AdSense) and affiliate links, with minimal ongoing content needs (evergreen content + automation).

## Database Schema
```sql
TABLE content.sites
  - id, name, domain, niche, platform (wordpress|ghost|astro)
  - status (planning|setup|live|dormant), created_at

TABLE content.articles
  - site_id, title, slug, status (draft|published|archived)
  - target_keywords, affiliate_links, published_at

TABLE content.revenue
  - site_id, source (adsense|affiliate|sponsor)
  - amount, period_start, period_end
```

## Quick Setup Checklist
- [ ] Choose a profitable niche (see `niche-ideas.md`)
- [ ] Validate with keyword research
- [ ] Set up cheap hosting (Vercel, Netlify free tier)
- [ ] Create initial content (10-15 SEO-optimized articles)
- [ ] Apply for AdSense + affiliate programs
- [ ] Build internal linking structure
- [ ] Submit to Google Search Console

## Platforms (by ease)
- **Ghost** (recommended) — Best balance of simplicity + SEO + speed
- **Astro/Static site** — Fastest, cheapest, but requires more setup
- **WordPress** — Most flexible, but more maintenance

## Content Strategy
- **Evergreen content** — Articles that stay relevant (how-tos, guides, reviews)
- **Target long-tail keywords** — Easier to rank, lower CPC but less competition
- **Affiliate links** — Link to products in reviews (10-30% commission typical)
- **Automate posting** — Use n8n to cross-post, email summaries, etc.

## Monetization Sources (by speed)
1. **Affiliate links** (immediate, $0 setup) — Recommend products in your niche
2. **AdSense** (1-2 weeks approval) — 60/40 split revenue
3. **Sponsorships** (3-6 months) — Brands pay to sponsor articles

## Time to Revenue
- Weeks 1-2: Niche research + keyword validation
- Week 3: Site setup (cheap/free hosting)
- Weeks 4-6: Write initial 10 articles
- Week 7: Apply for AdSense + affiliate programs
- Month 2+: First affiliate commissions (if readers click)
- Month 3+: AdSense payment ($100 minimum threshold)

## Maintenance
- Write 1-2 new articles per week (SEO-targeted)
- Monitor search rankings monthly (Google Search Console)
- Update old articles (refresh for new trends)
- Check affiliate link performance (remove low performers)
- Reply to comments (async, weekly)

## Low-Cost Tools
- **Hosting:** Vercel (free), Netlify (free), GitHub Pages (free)
- **Content:** Use n8n to auto-publish, schedule posts
- **SEO:** Ahrefs (free tier), Ubersuggest, semrush (free)
- **Analytics:** Google Analytics (free), Search Console (free)

## Files
- `niche-ideas.md` — Profitable niches + keyword lists
- `seo-checklist.md` — On-page + technical SEO
- `platforms.md` — Ghost, Astro, WordPress setup
- `affiliate-networks.md` — Best networks by niche
- `plan.md` — Your site strategy and content calendar
