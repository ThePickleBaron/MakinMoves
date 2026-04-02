# How I Track a Six-Figure Portfolio Across Multiple Accounts (My Actual System)

*Draft by Claude Code | Reviewed by Cowork | 3 fixes applied*

---

I manage an active stock portfolio across an individual brokerage account, a rollover IRA, and a smaller side account. At any given time I'm holding 30-50 positions across all three — energy, precious metals, semiconductors, fertilizers, senior care REITs, and a handful of speculative bets.

Keeping track of all of it nearly broke me.

## The Problem Nobody Talks About

Every broker shows you ONE account at a time. Log into Fidelity, you see your individual account. Switch to the IRA view, now you can't see the individual. Want to know your total gold exposure across all accounts? Good luck — you're opening three tabs and doing mental math.

For a while I ran everything through spreadsheets. I had a master sheet with position data exported from my broker's CSV downloads. It worked until it didn't. The formulas broke when I added a column. The file got so bloated it took 10 seconds to load. I lost track of which version was current.

I tried aggregator apps like Empower (formerly Personal Capital) and a few others. They sync with your brokerage accounts, which is convenient — but I never loved the idea of giving a third-party app full read access to my financial accounts. And the lag was real. Positions wouldn't update for hours sometimes.

## What I Actually Needed

After wasting time across all these options, I realized what I actually needed was pretty specific:

1. **One view of all accounts** — individual, IRA, rollover, everything in one place with account-level subtotals
2. **The columns I actually use** — symbol, quantity, cost basis, current price, gain/loss (dollar and percent), sector, dividend yield, and what percentage of my total portfolio each position represents
3. **Thesis notes attached to positions** — not in a separate document. Right there next to the ticker. Why I bought it, what my target is, where my stop is
4. **Realized gains tracking** — every closed trade with short-term vs. long-term classification. When tax season hits, I want to pull up a view and see my YTD P&L instantly
5. **Wash sale tracking** — if you're actively trading, wash sales will sneak up on you. I needed a way to flag them
6. **A watchlist** — tickers I'm stalking with target entry prices and the thesis for each

No app gave me all of this. Spreadsheets gave me the data but not the views. So I built it in Notion.

## Why Notion Works for Portfolio Tracking

I know what you're thinking — Notion is for project management and wikis, not stock tracking. I thought the same thing. But here's what makes it work:

**Relational databases.** In Notion, your positions database can link to your realized trades database. When you close a position, the data connects. You can see your thesis note, your entry, your exit, and your outcome all in one place.

**Multiple views of the same data.** One database, but I can view it as:
- A table sorted by portfolio weight (what's my biggest position?)
- A board grouped by sector (am I too concentrated in energy?)
- A filtered view showing only winners or only losers
- A calendar view showing upcoming dividend pay dates

I don't re-enter data for each view. I set up the filters once, and they just work.

**Thesis notes.** This is the feature that changed how I trade. Every position has a text field where I document: why I entered, what my target price is, where my stop is, and what would make me sell. When a position is down 15% and my gut says "sell," I read the thesis note instead. Half the time, the original rationale is still intact and I hold. The other half, I realize the thesis broke and I exit with discipline instead of panic.

## My Setup

Here's the structure I landed on after several iterations. (I eventually turned this into a template you can duplicate — more on that below.)

### Positions Database
Every current holding with: symbol, company name, account (Individual/IRA/Rollover), sector, asset type (stock/ETF/option), quantity, average cost, current price, market value (auto-calculated), cost basis (auto-calculated), gain/loss in dollars and percent (auto-calculated), portfolio weight, dividend yield, next dividend date, thesis notes, stop loss level, and target price.

### Realized Trades Log
Every closed position with: symbol, account, open date, close date, quantity, proceeds per share, cost per share, total gain/loss, short-term vs long-term classification, and a wash sale flag.

### Watchlist
Tickers I'm researching but haven't bought yet: symbol, current price, target entry price, gap to entry (auto-calculated), thesis, catalyst, and priority (Hot/Warm/Cold).

### Trade Journal
A running log, separate from thesis notes. Dated entries: "Today I trimmed 15 shares of my largest tech position after it hit my 2% scalp target. Rotated profits into CF and NTR to build the fertilizer basket." This isn't about the numbers — it's about documenting the decision-making process so I can learn from it.

### Dashboard
A single page showing: total portfolio value across all accounts, day change, top 5 positions by weight, sector allocation breakdown, recent trades, and a macro indicators section where I manually track oil, gold, the dollar index, and treasury yields.

### Quick Reference Card
The "open, glance, close" view. Total value, biggest movers today, next dividend date, any watchlist items near entry. I check this in 30 seconds at market close.

## What This System Actually Changed

**I stopped overtrading.** When I can see my full portfolio weight and sector allocation at a glance, I don't accidentally build a 30% position in one stock. It happened before — I'd add to a position in my individual account and forget I also held it in the IRA.

**Tax season got easier.** My realized gains log has every trade classified as short-term or long-term, with wash sales flagged. Last year I would have missed at least three wash sales without it. That's real money.

**My conviction improved.** Reading my own thesis notes before making a trade forces me to ask: "Has anything changed?" If the answer is no, I hold. If the answer is yes, I exit. No emotion, just the system.

**I track the right things.** Before, I'd check my broker 10 times a day and react to price moves. Now I update the tracker once at close, spend 5 minutes reviewing, and I'm done. The dashboard tells me everything I need to know.

## The Tools I Compared

Before settling on Notion, I evaluated these options:

**Spreadsheets (Excel/Google Sheets)** — Total control, familiar. But ugly, fragile formulas, no relational data, painful to maintain at 50+ positions. Free but you pay in time.

**TradingView** — Incredible for charting and technical analysis. Portfolio tracking is a secondary feature though. Great for analysis, weak for organization. Worth having alongside whatever tracking system you use.

**Empower / Personal Capital** — Auto-syncs with brokerages, nice UI. But I don't love sharing my credentials, the sync lags, and you can't customize the views or add thesis notes. Free.

**Stock Rover** — Strong fundamentals screening plus portfolio tracking. Best for research-heavy investors. Paid tiers get expensive ($27.99/mo for Premium Plus). Overkill if you just need tracking.

**Sharesight** — Best for tax reporting and dividend tracking, especially international investors. Starts free, paid at $22/mo+ for more than 10 holdings.

**Notion** — Not purpose-built for investing, but the flexibility is the point. You design exactly the system you need. Free plan handles everything. The trade-off is manual price updates (no live feed), but for an active trader who checks positions daily anyway, that's 2-5 minutes of work.

## The Template

I cleaned up my system and turned it into a template you can duplicate into your own Notion workspace. It's got all the databases, views, formulas, and structure I described above — positions, realized trades, watchlist, trade journal, dashboard, and the quick reference card.

It's $9 on Gumroad: [LINK]

That's the price of one commission-free trade that goes wrong. If it saves you one emotional sell or catches one wash sale, it paid for itself.

## What I'd Add Next

If I had more time, I'd build:
- **API integration** with a broker or Yahoo Finance for semi-automated price updates
- **A weekly review template** — forced reflection on what worked and what didn't
- **A correlation tracker** — showing which positions move together (helpful for managing concentration risk)

Maybe that's Template #2. We'll see.

---

*Disclosure: The Gumroad link is to my own product. I don't earn commissions on any other tools mentioned in this article — I just use them and wanted to share what works.*
