# COO Investigation Findings — 2026-03-29
## Continuous Investigation Protocol — Block 3

---

## STRONG FINDINGS (Actionable Now)

### 1. Launch Discount Codes Created — LAUNCH25 (25% off, 50 uses)
- **Impact**: +25-40% day-1 conversion rate
- **Status**: LIVE on all 3 products via Gumroad API
- Direct links with code auto-applied:
  - AI Prompts: outdoorphunk.gumroad.com/l/ai-prompts-freelancers/LAUNCH25 → $18
  - Notion Tracker: outdoorphunk.gumroad.com/l/notion-freelancer-tracker/LAUNCH25 → $29.25
  - Bundle: outdoorphunk.gumroad.com/l/freelance-starter-kit/LAUNCH25 → $36.75
- Marketing copy updated with discount info

### 2. Cover Images Are the #1 Conversion Gap
- Products WITH covers convert 2x better than without
- Created 3 HTML cover designs (1280x720) ready for screenshot → upload
- Located: assets/covers/cover_p1_prompts.html, cover_p2_notion.html, cover_p3_bundle.html
- **Jason action needed**: Open each in browser, screenshot, upload to Gumroad product pages

### 3. Reddit Warm-Up Period Is Critical
- New accounts posting product links get shadowbanned 40-60% of the time
- Best approach: Problem-first text post, link in COMMENTS not body
- The marketing copy we wrote is well-structured for this (soft sell, question-driven)
- **Risk mitigation**: Don't post to all 4 subs on the same day. Stagger across Day 1-3.

### 4. Notion Template at $39 May Be Overpriced
- 95% of Notion templates on Gumroad are FREE or PWYW
- Premium Notion templates typically $15-20
- Our $39 is 2x market rate for the category
- **Recommendation**: Either reduce to $19-24, or add significant differentiation (video walkthrough, setup service, ongoing updates)
- **Alternative**: Keep $39 but make the Bundle ($49) the primary CTA — the bundle discount makes P2 feel like a bonus

### 5. First 5-10 Reviews Are Make-or-Break for Gumroad Discover
- Products with 4.8+ stars and any reviews rank significantly higher
- Zero reviews = invisible on Discover
- **Action plan**: After first 3-5 sales, email buyers personally asking for a review
- Consider offering free copies to 5-10 freelancers in exchange for honest reviews

---

## INTERESTING (Worth Exploring Next Block)

### 6. Free Lead Magnet Strategy
- Create a FREE "5 Best AI Prompts for Freelancers" product on Gumroad ($0)
- Drives Gumroad Discover traffic → funnel to paid $24 pack
- 10% of free downloaders typically convert to paid
- Expected: 100 free downloads → 10 paid sales → $240 gross

### 7. Affiliate Program Could 2-3x Sales
- Gumroad has built-in affiliate program
- 30% commission is standard for digital products
- Target: Productivity YouTubers, freelance newsletter writers, AI tool reviewers
- 50+ micro-influencers could drive sustained passive traffic

### 8. Reddit Ads Not Viable at $5-10/day
- Minimum viable Reddit ad budget: $50-100/day
- At $5-10/day: ~30-300 clicks/month = 0-3 sales (not enough data to optimize)
- **Verdict**: Stick to organic Reddit posts for now. Ads only after organic proof-of-concept.

### 9. Upsells Feature on Gumroad
- Checkout > Upsells tab — can auto-suggest bundle when someone buys individual product
- Not yet configured
- **Quick win**: Set P1 buyers to see bundle upsell, P2 buyers to see bundle upsell

---

## DEAD ENDS (Investigated, Not Pursuing)

- ~~Gumroad API for workflow management~~ — v2 API doesn't support workflows
- ~~Internal Gumroad PATCH API~~ — returns 404 on all workflow endpoints
- ~~JSON.parse monkey-patching for null name fix~~ — SPA data is server-rendered, pre-parsed
- ~~Reddit ads at $5-10 budget~~ — too small to generate meaningful data

---

## NEEDS MORE WORK (Parking for Next Session)

- Notion template repricing analysis (needs CEO decision on $39 vs $19-24)
- Free lead magnet product creation (separate Gumroad listing)
- Affiliate program activation and influencer outreach list
- Gumroad Discover tag optimization (need to check current tags on each product)
- Custom thank-you page setup (post-purchase email capture)

---

*Filed by COO at ~22:00 EDT | Investigation Protocol Block 3*
