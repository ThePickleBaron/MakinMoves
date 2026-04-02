# Memo: Google Sheets Tracker — XLSX Patched and Ready
**From:** Cowork
**To:** Claude Code, Jason
**Date:** 2026-04-02
**Priority:** ACTION REQUIRED — Jason
**Related:** memo_20260402_cc_sheets-tracker-spec-done.md, memo_20260402_cw_sheets-spec-review.md

---

## What Happened

Claude Code built `Active_Trader_Portfolio_Tracker.xlsx` with all 7 tabs and Jason's real portfolio data. Solid work. But it was missing the **key differentiator**: GOOGLEFINANCE auto-pricing formulas. Without those, it's just another spreadsheet — not the product the listing copy sells.

Cowork patched the file in-place. Here's what was added:

### Changes Made to CC's File

| Change | Details |
|--------|---------|
| **GOOGLEFINANCE in Positions col H** | All 8 sample rows + rows 10-200 pre-loaded with `=GOOGLEFINANCE(A,"price")` |
| **GOOGLEFINANCE in Watchlist col D** | All 3 sample rows + rows 5-100 pre-loaded |
| **GOOGLEFINANCE on Dashboard** | Gold (GLD) macro indicator auto-updates |
| **Term auto-calc in Realized Trades** | Column M now auto-classifies Short Term/Long Term based on hold period |
| **Freeze panes** | All 6 data tabs now freeze header rows |
| **Auto-filter on Positions** | Sort/filter by any column |
| **Column M header fix** | Was "% of Account" — formula actually calculates % of Portfolio. Fixed label. |
| **Column widths** | Set across all tabs for readability |
| **Number formatting** | Currency, percentages, dates properly formatted |
| **How To Use updated** | Step 2 now says GOOGLEFINANCE is built-in (not "replace column H manually") |
| **Dividend note added** | Explicit warning that dividend data is manual entry |
| **Formulas for empty rows** | Positions (10-200), Realized Trades (5-500), Watchlist (5-100), Dividends (4-500) all pre-loaded so buyers just type data and formulas fire |
| **Removed tip text** | Row 11 had "TIP: In Google Sheets, replace col H..." — removed since it's now built-in |

### What Was Kept (CC's Work)

- All 8 sample positions from Jason's real portfolio (AAPL, XOM, GLD, INTC, NTR, NAT, CF, GNK)
- All 3 realized trades (AAOI, LITE, RIG)
- All watchlist entries (ARM, DE, PG)
- Trade journal entries
- Dividend records
- All existing formulas, data validations, conditional formatting

### Verification

Ran LibreOffice recalculation: 4,423 formulas total. 70 `#NAME?` errors — all from GOOGLEFINANCE (which only resolves in Google Sheets). Zero `#REF!`, `#VALUE!`, or `#DIV/0!` errors. All non-GOOGLEFINANCE formulas calculate correctly.

---

## Jason — Upload Instructions (5 minutes)

1. Open Google Drive (drive.google.com)
2. Drag `Active_Trader_Portfolio_Tracker.xlsx` from your Downloads/claudehub folder into Drive
3. Double-click to open → it converts to Google Sheets automatically
4. Wait ~30 seconds for GOOGLEFINANCE prices to populate (column H in Positions, column D in Watchlist)
5. Verify prices look right, then: **File > Save as Google Sheets**
6. Set sharing: **Share > Anyone with the link > Viewer**
7. Copy the share link — this is your product delivery URL for Gumroad

### Then on Gumroad:
8. Create new product (or I can do this via API if you prefer)
9. Paste the listing copy from `google-sheets-tracker-spec.md`
10. Set price: $7 (launch price — consider $9 after first 10 sales)
11. Add the Google Sheets share link as the product content
12. Publish

---

## Also Built (But Probably Not Needed)

Cowork independently built `Active-Trader-Portfolio-Tracker-Sheets.xlsx` before discovering CC's version existed. It has a hidden Config tab for dropdowns and slightly different sample data. CC's version with the patch is better since it uses Jason's real portfolio. The Cowork-built version can be deleted.

---

- [x] Written by Cowork
- [ ] Read by Claude Code
- [ ] Read by Jason
