# Memo: Notion MCP Connected — Cowork Building Template Directly

**From:** Cowork
**To:** Claude Code
**Date:** 2026-04-02
**Priority:** HIGH — Read before doing any Notion work

## What Happened

Jason connected the Notion MCP. I now have direct API access to his Notion workspace: create databases, pages, views, and add data.

## What I'm Building

I'm creating the entire Active Trader Portfolio Tracker template directly in Jason's Notion workspace:

- Parent page (DONE): "Active Trader Portfolio Tracker" — ID: `336007fb-edda-817c-a021-d474c3700e14`
- Positions database (in progress)
- Realized Trades database (queued)
- Watchlist database (queued)
- Dashboard page (queued)
- Trade Journal page (queued)
- How To Use page (queued)
- Sample data (queued)
- All views per the spec in portfolio-tracker-template.md

## Coordination

**DO NOT** create any Notion content — I'm handling the full template build via MCP. This avoids us stepping on each other's databases.

**YOUR LANE:** Keep working on:
- Final Gumroad listing copy (gumroad-listing-FINAL.md)
- Anything in the shared/ file system
- Sprint file responses

**MY LANE:** Notion workspace build + views + sample data

## Status: BUILD COMPLETE

All components built and populated:

### Pages Created
- **Parent page:** https://www.notion.so/336007fbedda817ca021d474c3700e14
- **Trade Journal:** https://www.notion.so/336007fbedda81808397f682baf77739
- **How To Use:** https://www.notion.so/336007fbedda8173ae14e922de854c18

### Databases Created
- **Positions** (DB: 741096d616804c1db19d8a826919fc74) — 8 sample positions loaded
  - Views: All Positions (default), By Sector (board), By Account (board), Active Positions (filtered table), Dividend Calendar
- **Realized Trades** (DB: a96f4ae536014a00aa891f77390bd406) — 3 sample trades loaded
  - Views: All Trades (default), Wash Sales (filtered)
- **Watchlist** (DB: bb4f429194ef4132aaa67c3b5c0dfdcf) — 4 sample watchlist items loaded
  - Views: By Priority (board)

### Known Limitations
- Formula columns (Market Value, Cost Basis, Gain/Loss $, Gain/Loss %) could not be created via MCP API due to formula parsing limitations. Jason will need to add these manually in Notion (takes ~5 min: create formula property, enter `prop("Quantity") * prop("Current Price")` etc.)
- Sample data uses FICTIONAL positions and prices — safe for screenshots

### What Jason Needs To Do
1. Open the template in Notion
2. Add the 4 formula columns manually (instructions in How To Use page)
3. Delete sample data, add his real positions
4. Take 2-3 screenshots for Gumroad listing
5. Publish

---

*Cowork | Sprint 007+ | Day 4 of 90 | BUILD COMPLETE*
