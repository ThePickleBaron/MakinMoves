# Active Trader Portfolio Tracker — Quick Reference Card

**Print this or keep handy while using the template**

---

## DATABASES AT A GLANCE

### 📊 POSITIONS (Main Portfolio)
| Field | What to Enter | Example |
|-------|---------------|---------|
| Ticker | Stock symbol | AAPL |
| Company | Full name (optional) | Apple Inc. |
| Shares | How many you own | 50 |
| Entry Price | Cost per share | $125.00 |
| Current Price | Today's price | $180.00 |
| Sector | Industry category | Technology |
| Account | Where you hold it | Fidelity |
| Thesis | Why you bought it | "Dividend growth story, AI exposure" |
| Dividend/Share | Annual $ per share | $0.96 |

**Views to use:**
- **All Positions** → Full portfolio snapshot
- **By Sector** → Check if concentrated in one area
- **By Account** → See how money is allocated
- **Dividend Calendar** → Plan income

---

### 📈 REALIZED TRADES
| Field | What to Enter | Example |
|-------|---------------|---------|
| Ticker | Stock symbol | TSLA |
| Buy Date | When purchased | 2025-01-15 |
| Sell Date | When sold | 2026-03-10 |
| Shares | Quantity | 10 |
| Buy Price | Entry price | $220 |
| Sell Price | Exit price | $240 |
| Gain/Loss | System calculates | +$200 |
| Tax Status | Win/Loss for tax | Long-term win |

**Key for taxes:**
- Filter by "Wash Sales" flag → Check 30-day rule compliance
- Review before April 15 for tax prep

---

### 👀 WATCHLIST
| Field | What to Enter | Example |
|-------|---------------|---------|
| Ticker | Symbol | MSFT |
| Company | Full name | Microsoft |
| Target Price | What you'd buy at | $300 |
| Catalyst | Why it matters now | "AI announcement next month" |
| Thesis | Long-term reasoning | "Cloud dominance, recurring revenue" |
| Status | Watching or Ready to Buy | Watching |

---

## MONTHLY CHECKLIST

- [ ] **First Monday:** Update all "Current Price" fields
- [ ] **Mid-month:** Add new positions to Realized Trades if sold
- [ ] **Week before earnings:** Check "By Sector" for concentration
- [ ] **Month-end:** Review Thesis notes, any changes to investment thesis?

---

## FORMULAS INCLUDED

✅ **Gain/Loss %** = (Current Price - Entry Price) / Entry Price  
✅ **Total Portfolio Value** = SUM of all (Shares × Current Price)  
✅ **Dividend Yield** = Annual Dividend / Entry Price  
✅ **Annual Dividend Income** = SUM of all (Shares × Dividend/Share)  

---

## KEYBOARD SHORTCUTS

| Action | Shortcut |
|--------|----------|
| Add new row | Click "+" at bottom of table, or press Space |
| Edit cell | Start typing |
| Link related record | Type @ to link trades to positions |
| Filter view | Click funnel icon at top |
| Sort view | Click column header |
| Duplicate row | Right-click → Duplicate |

---

## COMMON QUESTIONS

**Q: How do I update prices automatically?**  
A: Use Zapier (zapier.com) to connect TradingView → Notion. Or update manually weekly.

**Q: Can I import my current holdings from my broker?**  
A: Yes! Export CSV from your broker, paste into Positions table. Notion auto-maps columns.

**Q: How do I track dividends paid?**  
A: Add to "Dividend/Share" field. The Dividend Calendar view will auto-calculate annual income.

**Q: Can I share this with my spouse/advisor?**  
A: Yes! Click Share at top-right → Invite people. They can view and edit.

**Q: I sold a stock — how do I track it?**  
A: Move it to Realized Trades database (use Duplicate + Delete from Positions). This keeps your history clean.

---

## NEED MORE POWER?

Consider these upgrades:
- **TradingView API** — Real-time prices (paid plan)
- **Yahoo Finance API** — Free price data (via Zapier)
- **Custom formulas** — Add alerts, performance tracking, rebalancing logic

---

**Made for active traders. Updated monthly with new features.**

---

Last updated: 2026-04-02  
Version: 1.0
