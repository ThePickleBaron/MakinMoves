# Active Trader Portfolio Tracker — Notion Template Structure

## READY TO BUILD IN NOTION
*Based on real portfolio data from an active trader managing $250K+ across multiple accounts*

---

## Database 1: POSITIONS

### Properties (columns)

| Property | Type | Description |
|----------|------|-------------|
| Symbol | Title | Ticker symbol (e.g., LITE, TFPM) |
| Description | Text | Company name |
| Account | Select | Individual, Rollover IRA, Roth, Other |
| Sector | Select | Energy, IT, Materials, Healthcare, Industrials, Financials, Consumer, Utilities, Comm Services |
| Asset Type | Select | Equity, ETF, Crypto, Options, Cash |
| Quantity | Number | Shares held |
| Avg Cost/Share | Number (USD) | Cost basis per share |
| Current Price | Number (USD) | Updated manually or via API |
| Market Value | Formula | Quantity × Current Price |
| Cost Basis | Formula | Quantity × Avg Cost/Share |
| Gain/Loss $ | Formula | Market Value - Cost Basis |
| Gain/Loss % | Formula | (Gain/Loss $) / Cost Basis × 100 |
| % of Account | Formula | Market Value / Total Account Value × 100 |
| Day Change $ | Number | Manual daily update |
| Day Change % | Number | Manual daily update |
| Dividend Yield | Number (%) | Annual div yield |
| Div Pay Date | Date | Next dividend date |
| Reinvest? | Checkbox | DRIP enabled |
| Status | Select | Active, Watching, Exited, Stopped Out |
| Thesis | Text (long) | Why you own it — entry rationale |
| Exit Target | Number (USD) | Target sell price |
| Stop Loss | Number (USD) | Stop loss level |
| Tags | Multi-select | Momentum, Value, Dividend, Hedge, Speculative, Scalp |

### Views

1. **All Positions** — Table view, sorted by % of Account descending
2. **By Sector** — Board view, grouped by Sector
3. **By Account** — Board view, grouped by Account
4. **Winners** — Filtered table: Gain/Loss % > 0, sorted descending
5. **Losers** — Filtered table: Gain/Loss % < 0, sorted ascending
6. **Dividend Calendar** — Calendar view by Div Pay Date
7. **Watchlist** — Filtered table: Status = Watching

---

## Database 2: REALIZED TRADES

### Properties

| Property | Type | Description |
|----------|------|-------------|
| Symbol | Title | Ticker |
| Description | Text | Company name |
| Account | Select | Individual, Rollover IRA |
| Open Date | Date | Position opened |
| Close Date | Date | Position closed |
| Quantity | Number | Shares traded |
| Proceeds/Share | Number (USD) | Sale price |
| Cost/Share | Number (USD) | Purchase price |
| Proceeds | Formula | Quantity × Proceeds/Share |
| Cost Basis | Formula | Quantity × Cost/Share |
| Gain/Loss $ | Formula | Proceeds - Cost Basis |
| Gain/Loss % | Formula | Gain/Loss $ / Cost Basis × 100 |
| Term | Select | Short Term, Long Term |
| Wash Sale? | Checkbox | Was this a wash sale |
| Disallowed Loss | Number (USD) | Wash sale disallowed amount |

### Views

1. **All Trades** — Table, sorted by Close Date descending
2. **By Symbol** — Board view, grouped by Symbol
3. **Winners Only** — Filter: Gain/Loss $ > 0
4. **Losers Only** — Filter: Gain/Loss $ < 0
5. **YTD Summary** — Table with rollup: total gains, total losses, net P&L
6. **Wash Sales** — Filter: Wash Sale = checked

---

## Database 3: WATCHLIST

### Properties

| Property | Type | Description |
|----------|------|-------------|
| Symbol | Title | Ticker |
| Description | Text | Company name |
| Sector | Select | Same as Positions |
| Current Price | Number (USD) | |
| Target Entry | Number (USD) | Price you'd buy at |
| Gap to Entry | Formula | (Current Price - Target Entry) / Current Price × 100 |
| Thesis | Text | Why you're watching |
| Catalyst | Text | What would trigger entry |
| Priority | Select | Hot, Warm, Cold |
| Added Date | Date | When added to watchlist |

### Views

1. **All Watchlist** — Table sorted by Priority
2. **Near Entry** — Filter: Gap to Entry < 5%
3. **By Sector** — Board view

---

## Page: DASHBOARD

### Layout

**Row 1: Account Summaries (3 columns)**

| Individual Account | Rollover IRA | Total Portfolio |
|---|---|---|
| Total Value: $XX,XXX | Total Value: $XXX,XXX | Combined: $XXX,XXX |
| Day Change: +/- $X,XXX | Day Change: +/- $X,XXX | Day Change: +/- $X,XXX |
| Realized YTD: $X,XXX | Realized YTD: $XX,XXX | Realized YTD: $XX,XXX |
| # Positions: XX | # Positions: XX | # Positions: XX |

**Row 2: Sector Allocation**
- Linked view of Positions grouped by Sector with market value totals
- Quick visual of concentration risk

**Row 3: Top Holdings**
- Linked view: Top 10 positions by % of Account

**Row 4: Recent Activity**
- Linked view: Last 10 realized trades

**Row 5: Macro Indicators (manual tracking)**

| Indicator | Value | Trend | Notes |
|-----------|-------|-------|-------|
| Brent Crude | $XXX | ↑/↓ | |
| Gold (oz) | $X,XXX | ↑/↓ | |
| DXY | XXX | ↑/↓ | |
| 10Y Treasury | X.XX% | ↑/↓ | |
| VIX | XX | ↑/↓ | |

---

## Page: THESIS JOURNAL

Simple text page with dated entries for macro thesis tracking.

Template:
```
## 2026-04-01

**Market view:** [Bullish/Bearish/Neutral]
**Key moves today:** [What you bought/sold and why]
**Thesis update:** [Any changes to core thesis]
**Watching:** [What you're stalking for entry]
```

---

## Page: HOW TO USE THIS TEMPLATE

1. **Duplicate this template** to your Notion workspace
2. **Add your positions** to the Positions database — start with current holdings
3. **Set up your views** — the pre-built views (By Sector, Winners, Losers) work immediately
4. **Update prices daily** — takes 2 minutes. Update Current Price column.
5. **Log trades** — when you close a position, add it to Realized Trades
6. **Track your thesis** — use the Thesis field on each position and the Thesis Journal for macro views
7. **Use the Watchlist** — add tickers you're stalking with target entry prices

**Pro tip:** Update your positions at market close each day. Takes 5 minutes. The Dashboard auto-calculates everything else.

---

## SAMPLE DATA (Pre-loaded)

The template comes pre-loaded with 5 example positions across different sectors so you can see how the views and formulas work. Delete the sample data and add your own positions.
