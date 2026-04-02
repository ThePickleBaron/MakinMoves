# Memo: Gumroad Store Audit — 4 Products, Storefront Empty, Zero Sales
**From:** Cowork
**To:** Claude Code + Jason
**Date:** 2026-04-02
**Priority:** HIGH — storefront display issue needs fixing

---

## Full Product Inventory (Verified via Gumroad Dashboard)

| # | Product | Price | Sales | Revenue | Status | URL |
|---|---------|-------|-------|---------|--------|-----|
| 1 | Active Trader Portfolio Tracker — Notion Template | $9 | 0 | $0 | Published | outdoorphunk.gumroad.com/l/active-trader-portfolio-tracker |
| 2 | Freelance Starter Kit (Bundle) | $49 | 0 | $0 | Published | outdoorphunk.gumroad.com/l/freelance-starter-kit |
| 3 | Freelancer Invoice + Client Tracker (Notion Template) | $39 | 0 | $0 | Published | outdoorphunk.gumroad.com/l/notion-freelancer-tracker |
| 4 | AI Prompts for Freelancers | $24 | 0 | $0 | Published | outdoorphunk.gumroad.com/l/ai-prompts-freelancers |

**Total revenue across all products: $0**
**Total sales across all products: 0**

## CRITICAL ISSUE: Storefront Is Empty

When visiting `outdoorphunk.gumroad.com`, the profile page shows Jason's name and a subscribe form — but **zero products are displayed**. All 4 products are marked "Published" in the dashboard, but none appear on the storefront.

This means anyone who visits the store URL sees an empty page. The individual product links work (e.g., /l/active-trader-portfolio-tracker), but discovery browsing is broken.

**Likely cause:** Products need to be added to a "section" on the profile page. Gumroad's new profile system requires you to explicitly add products to sections for them to appear on your storefront. I saw "Add section" buttons on the profile page.

**Fix:** Either:
1. I fix this via Chrome right now (add a section, add all 4 products to it) — **Jason, can I do this?**
2. Code does it via API if the Gumroad API supports profile sections
3. Jason does it manually (exact click-path instructions provided)

## Other Observations

- The Portfolio Tracker product title is very long: "Active Trader Portfolio Tracker — Notion Template | Multi-Account, Thesis Notes, Tax Tracking" — this may get truncated in search results. Consider shortening.
- No cover image/thumbnail visible in the product listing page — this was supposedly fixed but I couldn't confirm from the dashboard view.
- The 3 pre-existing products (Freelance Starter Kit, Invoice Tracker, AI Prompts) are live but have likely had zero promotion. They're sitting there earning nothing.
- Product #2 (Google Sheets tracker) is NOT yet on Gumroad — still only exists as an .xlsx in the repo.

## Immediate Opportunity

We have **4 published products and 0 visibility**. The storefront fix alone could start generating organic browse traffic from anyone who clicks Jason's Gumroad profile.

The 3 pre-existing products also represent an untapped opportunity — they target freelancers, which is a different audience than the trading niche. We should decide: do we promote those too, or focus exclusively on the trading/investing niche?

My recommendation: **focus on trading niche for now**, but fix the storefront so all 4 products are visible. No reason to hide $112 worth of product catalog.

---

SCOREBOARD:
- Ships today: 0 (gameplan + audit only so far)
- Total ships: 1 (Notion tracker on Gumroad)
- Revenue: $0
- Subscribers: 0

---

- [x] Written by Cowork
- [ ] Read by Claude Code
- [ ] Read by Jason
