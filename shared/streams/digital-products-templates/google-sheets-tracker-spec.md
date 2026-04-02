# Google Sheets Portfolio Tracker — Product #2 Spec
**Author:** Claude Code | Downtime Task DT-3
**Product:** Active Trader Portfolio Tracker (Google Sheets Edition)
**Price:** $7
**Platform:** Gumroad (primary), Etsy (secondary)
**Status:** SPEC COMPLETE — Ready to build in Google Sheets

---

## Why a Sheets Version?

1. **Different audience** — Many traders don't use Notion. Sheets is universal.
2. **GOOGLEFINANCE function** — Delayed price updates for FREE. Notion can't do this natively.
3. **Lower price point** — $7 vs $9 Notion. Impulse buy territory.
4. **Cross-sell** — "Want more customization? Check out the Notion version ($9)"
5. **Zero overlap with Product #1** — Different format, different buyers.

---

## Sheet Structure (7 Tabs)

### Tab 1: DASHBOARD
**Purpose:** One-glance portfolio overview

**Layout:**
- Row 1-2: Header — "Active Trader Portfolio Tracker"
- Row 4-8: Account Summaries (auto-calculated from Positions tab)
  | Account | Market Value | Cost Basis | Gain/Loss $ | Gain/Loss % | # Positions |
  |---------|-------------|-----------|-------------|-------------|-------------|
  | Individual | =SUMIFS(...) | =SUMIFS(...) | =formula | =formula | =COUNTIFS(...) |
  | Rollover IRA | =SUMIFS(...) | =SUMIFS(...) | =formula | =formula | =COUNTIFS(...) |
  | All Accounts | =SUM(...) | =SUM(...) | =formula | =formula | =COUNT(...) |

- Row 10-14: Sector Allocation (auto-calculated)
  | Sector | Market Value | % of Portfolio |
  |--------|-------------|---------------|
  | Energy | =SUMIFS | =formula |
  | IT | =SUMIFS | =formula |
  | etc. | ... | ... |

- Row 16-20: Top 5 Holdings by Weight
  - Uses INDEX/MATCH + LARGE to pull top 5 positions by market value

- Row 22-26: Macro Indicators (manual entry)
  | Indicator | Value | Notes |
  |-----------|-------|-------|
  | Brent Crude | manual | |
  | Gold | =GOOGLEFINANCE("GLD","price") | auto |
  | DXY | manual | |
  | 10Y Yield | manual | |
  | VIX | manual | |

---

### Tab 2: POSITIONS
**Purpose:** All current holdings

**Columns:**
| Col | Header | Type | Formula? |
|-----|--------|------|----------|
| A | Symbol | Text | No |
| B | Description | Text | No |
| C | Account | Dropdown: Individual, Rollover IRA, Roth IRA, Other | No |
| D | Sector | Dropdown: Energy, IT, Materials, Healthcare, Industrials, Financials, Consumer, Utilities, Comm Services, Real Estate | No |
| E | Asset Type | Dropdown: Equity, ETF, Option, Bond, Crypto, Cash | No |
| F | Quantity | Number | No |
| G | Avg Cost/Share | Currency | No |
| H | Current Price | Currency | `=GOOGLEFINANCE(A2,"price")` — AUTO-UPDATES |
| I | Market Value | Currency | `=F2*H2` |
| J | Cost Basis | Currency | `=F2*G2` |
| K | Gain/Loss $ | Currency | `=I2-J2` |
| L | Gain/Loss % | Percent | `=IF(J2<>0,K2/J2,0)` |
| M | % of Account | Percent | `=I2/SUM($I$2:$I$100)` |
| N | Div Yield | Percent | No |
| O | Div Pay Date | Date | No |
| P | Status | Dropdown: Active, Watching, Exited, Stopped Out | No |
| Q | Exit Target | Currency | No |
| R | Stop Loss | Currency | No |
| S | Tags | Text | No |
| T | Thesis | Text (long) | No |

**KEY FEATURE: Column H auto-populates current prices via GOOGLEFINANCE.** This is the #1 advantage over the Notion version. Delayed ~20 min but free and automatic.

**Conditional Formatting:**
- K column (Gain/Loss $): Green if positive, red if negative
- L column (Gain/Loss %): Green if positive, red if negative
- P column (Status): Green = Active, Yellow = Watching, Gray = Exited, Red = Stopped Out

**Data Validation (Dropdowns):**
- Column C: Account types
- Column D: Sectors
- Column E: Asset types
- Column P: Status options

---

### Tab 3: REALIZED TRADES
**Purpose:** Closed position log with tax classification

**Columns:**
| Col | Header | Type | Formula? |
|-----|--------|------|----------|
| A | Symbol | Text | No |
| B | Description | Text | No |
| C | Account | Dropdown | No |
| D | Open Date | Date | No |
| E | Close Date | Date | No |
| F | Quantity | Number | No |
| G | Proceeds/Share | Currency | No |
| H | Cost/Share | Currency | No |
| I | Proceeds | Currency | `=F2*G2` |
| J | Cost Basis | Currency | `=F2*H2` |
| K | Gain/Loss $ | Currency | `=I2-J2` |
| L | Gain/Loss % | Percent | `=IF(J2<>0,K2/J2,0)` |
| M | Term | Dropdown: Short Term, Long Term | Auto: `=IF(E2-D2>365,"Long Term","Short Term")` |
| N | Wash Sale? | Checkbox | No |
| O | Disallowed Loss | Currency | No |

**Summary Row at Top:**
- Total Realized G/L
- Total Short-Term G/L
- Total Long-Term G/L
- Count of Wash Sales

---

### Tab 4: WATCHLIST
**Purpose:** Tickers being stalked

**Columns:**
| Col | Header | Formula? |
|-----|--------|----------|
| A | Symbol | No |
| B | Description | No |
| C | Sector | No |
| D | Current Price | `=GOOGLEFINANCE(A2,"price")` — AUTO |
| E | Target Entry | No |
| F | Gap to Entry | `=(D2-E2)/D2` |
| G | Thesis | No |
| H | Catalyst | No |
| I | Priority | Dropdown: Hot, Warm, Cold |
| J | Added Date | No |

**Conditional Formatting:**
- F column: Green when Gap < 5% (near entry), Red when Gap > 20% (far from entry)

---

### Tab 5: TRADE JOURNAL
**Purpose:** Decision log

**Columns:**
| Col | Header |
|-----|--------|
| A | Date |
| B | Market View (Dropdown: Bullish, Bearish, Neutral, Cautious) |
| C | Symbols Involved |
| D | Decision |
| E | Outcome |
| F | Lesson |

---

### Tab 6: DIVIDEND TRACKER
**Purpose:** Income tracking

**Columns:**
| Col | Header | Formula? |
|-----|--------|----------|
| A | Symbol | No |
| B | Pay Date | No |
| C | Amount/Share | No |
| D | Shares Held | No |
| E | Total Payment | `=C2*D2` |
| F | Account | Dropdown |
| G | Reinvested? | Checkbox |

**Summary:**
- YTD Dividend Income (total)
- By Account
- By Month (pivot-style)

---

### Tab 7: HOW TO USE
**Purpose:** Instructions page

**Content:**
1. How to add your positions
2. How GOOGLEFINANCE auto-updates work (and limitations — 20 min delay, no extended hours)
3. How to log realized trades
4. How to use the watchlist
5. How to customize dropdowns
6. Tips: updating at market close, using the trade journal

---

## Gumroad Listing Copy (Sheets Version)

### Title
**Active Trader Portfolio Tracker — Google Sheets | Auto-Price Updates, Multi-Account, Tax Tracking**

### Price
$7

### Short Description
Track your entire portfolio with automatic price updates via Google Finance. Positions, realized gains, watchlist, trade journal, and dividend tracker — all in Google Sheets. Built by an active trader.

### Full Description

**Your broker's dashboard isn't enough. Spreadsheets break at scale. This one doesn't.**

Built by an active trader managing a six-figure portfolio across multiple accounts, this Google Sheets tracker gives you everything in one workbook — with automatic price updates.

**THE GOOGLE FINANCE ADVANTAGE:**
Unlike Notion or other template tools, this spreadsheet auto-updates current prices using Google's GOOGLEFINANCE function. No manual entry, no API setup, no paid subscriptions. Just open the sheet and your portfolio is current (delayed ~20 min).

**7 TABS INCLUDED:**

1. **Dashboard** — Total portfolio value, account summaries, sector allocation, top holdings, macro indicators
2. **Positions** — Every holding with auto-calculated market value, gain/loss, and portfolio weight
3. **Realized Trades** — Closed positions with auto-classified short-term/long-term and wash sale tracking
4. **Watchlist** — Target entry prices with auto-calculated gap to current price
5. **Trade Journal** — Decision log with market view, outcome, and lessons
6. **Dividend Tracker** — Income tracking by symbol, date, and account
7. **How To Use** — Full setup guide

**SMART FEATURES:**
- Auto price updates via GOOGLEFINANCE (free, no setup)
- Conditional formatting (green = winning, red = losing)
- Dropdown menus for sectors, accounts, status
- Auto-calculated: market value, cost basis, gain/loss, portfolio weight, tax term
- Dashboard auto-populates from your positions data

**WHO THIS IS FOR:**
- Active traders who prefer spreadsheets over apps
- Investors managing multiple brokerage accounts
- Anyone who wants auto-updating prices without paying for software
- Traders who need tax tracking (wash sales, ST/LT classification)

**HOW IT WORKS:**
1. Purchase and open the Google Sheets link
2. File → Make a Copy (saves to your Google Drive)
3. Delete sample data, add your positions
4. Prices auto-update. Formulas handle the rest.

**WHY $7?**
Same trader who built the Notion version. This is the Sheets alternative for people who live in spreadsheets. Early buyers get the lowest price.

**Also available:** [Notion Template version ($9)](https://outdoorphunk.gumroad.com/l/active-trader-portfolio-tracker) — if you prefer Notion's database views and thesis notes.

### Tags
google sheets template, portfolio tracker, stock tracker, investment spreadsheet, trading spreadsheet, google finance, portfolio management, stock portfolio tracker, dividend tracker, investment tracker, trading journal, google sheets finance

---

## Competitive Advantage vs Notion Version

| Feature | Sheets ($7) | Notion ($9) |
|---------|:-----------:|:-----------:|
| Auto price updates | YES (GOOGLEFINANCE) | No (manual) |
| Thesis notes per position | Basic (text column) | Rich (linked pages) |
| Multiple views (board, calendar) | No | Yes |
| Trade journal | Yes | Yes |
| Wash sale tracking | Yes | Yes |
| Dividend tracker | Dedicated tab | Calendar view |
| Mobile experience | Decent | Better |
| Offline access | Yes (downloaded) | No |
| Familiarity | Everyone knows Sheets | Notion learning curve |

**They complement each other.** Sheets for daily price checking, Notion for thesis documentation and portfolio management. Offer both.

---

## Build Instructions (For Claude Code)

1. Create Google Sheet with 7 tabs per spec above
2. Build all formulas, dropdowns, conditional formatting
3. Add sample data (same fictional positions as Notion version)
4. Add header styling (dark theme option if possible)
5. Create "How To Use" tab with instructions
6. Test all GOOGLEFINANCE formulas
7. Set sharing to "Anyone with link can view" (buyers make a copy)
8. Create Gumroad product with listing copy above

---

*Generated by Claude Code | Downtime Task DT-3 | Day 4 of 90*
