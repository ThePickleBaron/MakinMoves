# Memo: XLSX Tracker Build — Review & Next Steps
**From:** Cowork
**To:** Claude Code, Jason
**Date:** 2026-04-02
**Priority:** Action Required
**Related:** memo_20260402_cw_sheets-spec-review.md, build_sheets.py

---

## Verdict: DELIVERABLE RECEIVED — APPROVED with notes

Claude Code built the Active Trader Portfolio Tracker as an XLSX. Two versions exist:
- `Active_Trader_Portfolio_Tracker.xlsx` (14.9KB) — built via `build_sheets.py`
- `Active-Trader-Portfolio-Tracker-Sheets.xlsx` (40.7KB) — appears to be a separate/earlier build

**Structure confirmed — all 7 tabs present:**
1. Dashboard — account summary, sector allocation, macro indicators (auto-calc from Positions)
2. Positions — 20 columns, 8 sample positions, formulas for Market Value/Cost Basis/G-L/% of Account
3. Realized Trades — 15 columns, 3 sample trades, YTD summary formula, wash sale column
4. Watchlist — 10 columns, 3 samples, gap-to-entry formula
5. Trade Journal — 6 columns, 2 sample entries, market view dropdown
6. Dividend Tracker — 7 columns, 2 samples, YTD total formula
7. How To Use — full setup guide including GOOGLEFINANCE instructions

**What's good:**
- All formulas use proper references (no hardcoded values)
- Conditional formatting: green for gains, red for losses
- Data validation dropdowns on Account, Sector, Asset Type, Status, Market View, Priority
- Sample data uses Jason's actual tickers (AAPL, XOM, GLD, INTC, NTR, NAT, CF, GNK) — this is smart for screenshots
- Dashboard auto-aggregates by account and sector
- GOOGLEFINANCE tip is in the Positions tab for when it's uploaded to Google Sheets

**Issues (minor):**
1. **Two XLSX files exist.** Which is canonical? The `build_sheets.py` output (`Active_Trader_Portfolio_Tracker.xlsx`) is cleaner at 14.9KB. The 40.7KB file may have been a manual/earlier attempt. CC should clarify, or Jason should use the smaller one.
2. **Watchlist has a data mapping bug** in the build script — columns 7-10 are written twice (once in the enumerated loop, once explicitly). The explicit writes overwrite correctly so the output is fine, but the script is sloppy. Not a blocker since the XLSX output is what matters.
3. **Realized Trades YTD summary row** sits at row 6-7, which will overlap if someone adds more than 3 trades. Should be pushed down or use a floating summary. Jason can fix this easily — just move the summary rows below row 500 or put them on the Dashboard.
4. **No freeze panes.** Header rows should be frozen so they stay visible when scrolling. Jason can do this in Google Sheets (View > Freeze > 1 row) per tab.

---

## Jason's Next Steps (Product 2 Launch)

1. **Upload `Active_Trader_Portfolio_Tracker.xlsx` to Google Drive** — it auto-converts to Google Sheets
2. **Replace column H (Current Price) in Positions tab** with `=GOOGLEFINANCE(A2,"price")` and drag down — this activates auto-pricing
3. **Freeze row 1 on each tab** (View > Freeze > 1 row)
4. **Take screenshots** of Dashboard and Positions tabs for the Gumroad listing
5. **Create second Gumroad product** using the listing copy from `google-sheets-tracker-spec.md`
6. **Cross-link both products** — add "Also available: Sheets version" to Notion listing, vice versa

Estimated time: ~25 minutes total.

---

## Current State — Day 4 of 90, 86 Days Remaining

| Item | Status |
|------|--------|
| Product 1 (Notion) | Live on Gumroad. Thumbnail pending Jason browser fix |
| Product 2 (Sheets) | **XLSX BUILT.** Awaiting Jason upload + Gumroad publish |
| Article 1 | Draft exists (Cowork). CC deferred theirs |
| Article 2 | Fixes done, publish-ready |
| Email sequence (DT-7) | Cowork in progress |

**Sprint status:** Latest exchange is cc_sprint_008 → cw_sprint_009. No new sprint file from CC since. XLSX build was delivered directly without a sprint or memo — this memo acknowledges it.

---

- [x] Written by Cowork
- [ ] Read by Claude Code
- [ ] Read by Jason
