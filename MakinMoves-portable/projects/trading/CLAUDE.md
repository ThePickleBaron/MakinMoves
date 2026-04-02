# Trading / Bot Stream — Quick Reference

## Goal
Build automated trading bots for crypto or stocks with strict risk management. Focus on testing strategies before live trading.

## Database Schema
```sql
TABLE trading.strategies
  - id, name, type (crypto|stocks|forex)
  - description, status (backtesting|live|paused|archived)
  - risk_level (low|medium|high), created_at

TABLE trading.trades
  - strategy_id, symbol, side (buy|sell), quantity, price
  - fee, pnl, executed_at
```

## ⚠️ WARNING: Risk & Compliance
- **Only use capital you can afford to lose.**
- **Start with paper trading / backtesting for 3+ months.**
- **Never risk >2% of capital per trade.**
- **Keep detailed records for taxes.**
- **This is not financial advice** — consult a financial advisor.

## Quick Setup Checklist
- [ ] Define a trading hypothesis (edge)
- [ ] Research the market (3-4 weeks minimum)
- [ ] Backtest strategy on historical data
- [ ] Paper trade for 4-8 weeks (no real money)
- [ ] Track results in database
- [ ] Only live trade if backtest + paper trade are profitable
- [ ] Risk <2% per trade, use stop losses always

## Supported Markets (by complexity)
1. **Crypto** (easiest for bots) — 24/7, APIs available, high volatility
2. **Stocks** (moderate) — Market hours, good data, regulated
3. **Forex** (advanced) — High leverage, risk-intensive

## Bot Template
Use `bot-template.js` to:
- Connect to exchange API (Binance, Coinbase, etc.)
- Define buy/sell signals
- Execute trades with stops
- Log all trades to database
- Monitor P&L

## Strategy Ideas (Low Risk)
- **Mean reversion** — Buy dips, sell pumps (statistical edge)
- **Trend following** — Buy uptrends, sell downtrends
- **Momentum** — Trade breakouts with volume
- **Dollar-cost averaging** — Buy same amount at regular intervals

## Time to Revenue
- Weeks 1-4: Research + backtest hypothesis
- Weeks 5-8: Paper trading (live market, no money)
- Weeks 9-12: Analyze results, refine rules
- Week 13+: Only live trade if consistent profitability

## Maintenance
- Monitor bot daily (20 min to 1 hour)
- Review trades log weekly
- Adjust parameters based on market conditions
- Strict stop losses — never disable them

## Free Tools
- **Backtest:** Backtrader, TradingView, QuantConnect
- **Paper trading:** IB Paper Trading, Simulator accounts
- **Data:** Yahoo Finance API (free), Binance API (free)
- **Monitoring:** TradingView alerts, email notifications

## Files
- `bot-template.js` — Ready-to-customize template
- `strategies.md` — Detailed strategy descriptions
- `risk-management.md` — Position sizing, stop losses
- `backtest-results.md` — Track all backtests
- `plan.md` — Your strategy & timeline

---
**Remember:** Slow, steady, low-risk beats fast and risky.
