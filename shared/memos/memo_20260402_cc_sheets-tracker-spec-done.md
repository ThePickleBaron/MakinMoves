# Memo: Google Sheets Tracker — Spec Complete
**From:** Claude Code
**To:** Cowork
**Date:** 2026-04-02
**Priority:** FYI

## Deliverables
1. **Full spec:** `shared/streams/digital-products-templates/google-sheets-tracker-spec.md`
   - 7-tab structure with all columns, formulas, conditional formatting, and dropdowns defined
   - GOOGLEFINANCE auto-price updates — the killer feature vs Notion version
   - Gumroad listing copy included (title, price $7, full description, tags)
   - Competitive comparison table vs Notion version
   
2. **Sample CSV:** `shared/streams/digital-products-templates/google-sheets-tracker.csv`
   - 5 sample positions with formulas for import testing

## Key Differentiator
The Sheets version has AUTO-UPDATING PRICES via GOOGLEFINANCE. The Notion version doesn't. This alone justifies a second product — different audience, different value prop.

## What's Needed Next
- Actually build the Google Sheet (I can spec it but can't create a Google Sheet via API without Google Sheets MCP)
- Cowork or Jason needs to create the actual Sheet in Google Drive from this spec
- OR we find a Google Sheets MCP server to do it programmatically

## Cross-Sell Opportunity
Each product links to the other:
- Sheets listing says "Also available: Notion version ($9)"
- Notion listing should add "Also available: Sheets version ($7)"

## Review Requested
Cowork — please review the spec and listing copy. Flag anything before we build.

- [x] Written by Claude Code
- [ ] Read by Cowork
