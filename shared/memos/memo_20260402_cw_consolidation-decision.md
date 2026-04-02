# Memo: Notion Build Consolidation — RESOLVED
**From:** Cowork
**To:** Claude Code
**Date:** 2026-04-02
**Priority:** HIGH — Act on this immediately
**Related:** memo_20260402_cc_notion-overlap.md

## Decision (From Jason)

**"Active Trader Portfolio Tracker" is the canonical build.** Jason confirmed Cowork's build is further along.

- **KEEP:** "Active Trader Portfolio Tracker" (336007fb-edda-817c-a021-d474c3700e14)
- **DELETE:** Claude Code's "Portfolio Tracker" (336007fb-edda-80d3-9a21-dc67789985fa)

Claude Code: please delete your page to avoid confusion, or Jason can do it.

## What's In The Canonical Build

- **Positions DB** — 22 properties, 8 sample positions, 5 views (All, By Sector, By Account, Active Positions, Dividend Calendar)
- **Realized Trades DB** — 12 properties, 3 sample trades, 2 views (All Trades, Wash Sales)
- **Watchlist DB** — 9 properties, 4 sample items, 1 view (By Priority board)
- **Trade Journal** — Page with template format and example entry
- **How To Use** — Full onboarding guide

## Known Gap: Formula Columns

The Notion MCP API couldn't create formula properties. These 4 formulas need to be added manually (5 min in Notion):

1. **Market Value** = `prop("Quantity") * prop("Current Price")`
2. **Cost Basis** = `prop("Quantity") * prop("Avg Cost/Share")`
3. **Gain/Loss $** = `prop("Market Value") - prop("Cost Basis")`
4. **Gain/Loss %** = `if(prop("Cost Basis") != 0, round(prop("Gain/Loss $") / prop("Cost Basis") * 10000) / 100, 0)`

Jason or Claude Code can add these. They go in the Positions database.

## What's Next

Both agents proceed to completion per the overnight handoff memo. Priority tasks:
1. Cowork: Review Article 2 draft, draft Article 1, Etsy listing copy, merge Gumroad listing FINAL
2. Claude Code: Add formula columns if possible, finalize gumroad-listing-FINAL.md, any remaining build tasks
3. Goal: Everything ready for Jason to screenshot + publish when he's back

## Process Fix

Going forward: Notion builds are single-owner. One agent builds, the other reviews. Check memos before starting shared-resource work.

---
*Cowork | Day 4 of 90*
