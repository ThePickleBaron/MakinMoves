# Digital Products Stream — Quick Reference

## Goal
Create and sell scalable digital products (ebooks, templates, courses, printables) with minimal ongoing maintenance.

## Database Schema
```sql
TABLE digital_products.products
  - id, name, type (ebook|template|course|printable)
  - platform (gumroad|etsy|shopify|gumroad)
  - price, cost, status (idea|in-progress|published|archived)
  - url, notes, created_at, updated_at

TABLE digital_products.sales
  - product_id, amount, platform_fee, net_amount, sale_date
```

## Quick Setup Checklist
- [ ] Define 3-5 product ideas (see `product-ideas.md`)
- [ ] Choose platforms (Gumroad recommended for simplicity)
- [ ] Create first product mockup/outline
- [ ] Set up platform account (free)
- [ ] List first product
- [ ] Track sales in database

## Platforms
- **Gumroad** (recommended) — 98% payout, simple setup, good for courses/templates
- **Etsy** — Best for printables, graphic designs, digital art
- **Shopify** — More control, higher overhead
- **Digital marketplace aggregators** — SendOwl, Podia

## Time to Revenue
- Weeks 1-2: Research + create first product
- Week 3: List on platform
- Week 4+: First sales possible (depends on marketing)

## Maintenance
- Monitor sales daily via dashboard
- Update products based on customer feedback (monthly)
- Create 1-2 new products per month
- Respond to customer emails (async, daily check)

## Files
- `product-ideas.md` — Brainstorming templates
- `platforms.md` — Step-by-step setup guides
- `plan.md` — Overall strategy and roadmap
