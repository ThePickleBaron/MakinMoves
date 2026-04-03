# Multi-Account Strategy Execution: How I Manage $250K Across Active Trades

Running quantitative strategies across multiple accounts is chaos without a system.

I trade in three accounts simultaneously:
- Individual account (taxable, most liquid)
- IRA (tax-deferred, limited withdrawals)
- Rollover 401k (tax-deferred, largest account)

At any given time I'm holding 40-60 positions across all three, with multiple strategies running in parallel:
- Volatility mean reversion (selling premium on spikes)
- Correlation arbitrage (long/short pairs)
- Earnings event trades (straddles, butterflies)
- Sector rotation (macro positioning)

Without a unified system, I'd lose track of what I actually own. And in a volatile market, that's how you blow up.

Here's how I manage it.

---

## The Problem: Three Brokers, One Portfolio

Your brokers don't talk to each other.

Log into Fidelity: You see 18 positions. Switch to Schwab: See 12 more. Check Interactive Brokers: Another 8 positions.

Now answer this: How much of your portfolio is in semiconductors? Add up all the tech holdings across three accounts, remember which strikes on the 30 options you own, account for the ones you've assigned...

It's impossible without a system.

**The consequences:**
- You think you're 30% in tech. You're actually 55% (your IRA is loaded).
- You sell a call in your individual account without realizing your IRA already has 200 shares. Now you're over-covered.
- You close a position and forget to log the realized loss. Tax season arrives. You can't find it.
- You run out of buying power in one account while cash sits idle in another.
- You execute the same "opportunity" twice across accounts (duplication, not diversification).

I lived this chaos for six months. It cost me money.

---

## What I Actually Needed

After trying every aggregator app and spreadsheet hack, I realized I needed:

1. **Unified position view** — All 40-60 positions in one place, organized by account
2. **Greeks tracking per position** — Not estimated. Actual: delta, theta, vega, gamma
3. **Strategy tracking** — Which position is part of which strategy? (Vol trade vs. correlation trade vs. earnings play)
4. **Leverage calculation** — How much buying power do I have left? Am I overleveraged?
5. **Tax data per position** — Cost basis, holding period, wash sale status
6. **Journal per trade** — Why did I enter? When do I exit? What was the outcome?
7. **Multi-leg tracking** — For spreads/straddles: all legs in one view, net Greeks calculated
8. **Realized P&L** — Closed positions with short-term/long-term classification ready for tax season

No broker does this. No free tool does this. Most traders use spreadsheets and suffer.

So I built a system in Notion.

---

## The System I Use

**The Architecture:**

Three interconnected databases:

1. **Positions Database**
   - Symbol, account, quantity, entry price, current price
   - Greeks (delta, theta, vega, gamma) — calculated or manual entry
   - Strategy type (vol reversion, correlation trade, earnings arb, buy-and-hold)
   - Entry thesis (why am I here?)
   - Target price (when do I take profits?)
   - Stop loss (when do I exit?)
   - Current P&L (auto-calculated)

2. **Realized Trades Database**
   - Symbol, entry date, entry price, exit date, exit price
   - Duration (days held)
   - P&L (dollar and percent)
   - Tax classification (short-term or long-term)
   - Notes (what worked? what didn't?)
   - Linked back to original position (full story of the trade)

3. **Strategy Log**
   - Strategy name (Vol Reversion on Semiconductors, Correlation Arbitrage Tech/Energy, etc.)
   - Entry date and thesis
   - All positions that are part of this strategy
   - Net Greeks for the whole strategy (critical)
   - Exit plan
   - P&L tracking
   - Post-mortems (what did we learn?)

**The Views:**

From these three databases, I create different views depending on what I need to know:

**Portfolio Overview:**
- All positions sorted by account
- Column for Greeks so I see my net delta across all accounts at a glance
- Current P&L per position and account-total P&L

**Strategy Dashboard:**
- Current active strategies
- Positions in each strategy
- Net Greeks per strategy (am I truly neutral delta? Or have I drifted?)
- Strategy P&L (how is each approach actually performing?)

**Tax Planning View:**
- All closed positions with holding period (short-term vs. long-term)
- YTD realized gains/losses
- Candidates for loss harvesting (losers I could sell to offset gains)
- Wash sale status (can I rebuy this or does it reset my holding period?)

**Risk Dashboard:**
- Total leverage ratio (buying power used ÷ total account size)
- Sector concentration (am I overweight anything?)
- Account-by-account buying power remaining
- Days to earnings events (upcoming catalysts)

**Execution Log:**
- Every entry logged with thesis
- Every exit logged with actual reason (hit target? Stop loss? Thesis broke?)
- Every loss reviewed for learning
- Historical win rate per strategy

---

## How I Actually Use This During the Chaos

**Monday Morning (15 min):**
1. Open portfolio overview
2. Check Greeks: Is my net delta still aligned with my thesis?
3. Check sector concentration: Is anything overweight from weekend news?
4. Check buying power: Do I have capacity to add to winners?
5. If adjustments needed, execute them

**Mid-week (10 min):**
1. Check strategy dashboard: Are active strategies performing?
2. Identify positions hitting targets
3. Identify positions hitting stop-loss
4. Execute exits
5. Log why in journal

**Friday (20 min):**
1. Check realized trades this week
2. Log outcomes
3. Calculate strategy P&L
4. Review: Did I follow the plan, or did emotions override?

**Monthly (30 min):**
1. Run tax planning view
2. Identify loss harvesting opportunities
3. Check wash sale calendar (what can I rebuy?)
4. Verify realized P&L aligns with brokers
5. Plan next month's strategy focus

**Total: 3 hours per week to manage a $250K active trading portfolio across 3 brokers.**

---

## Real Example: The Vol Spike Trade

Here's how this system prevented a disaster:

**Wednesday, 11 AM:**
- Semiconductor volatility spikes (IV rank 78, historical avg 25)
- Signal: Short call premium
- I want to sell 5 NVDA calls at $150 strike (1-month expiry)
- Collect $400 premium per call = $2,000 total

**Before executing, I check my system:**

Position database: "How much NVDA do I own?"
- Individual account: 100 shares (entry $120, current $147)
- IRA: 50 shares (entry $125, current $147)
- Total: 150 shares

Greeks check: "If I sell 5 calls (500 shares of obligation), what's my net delta?"
- Long 150 shares = +150 delta
- Short 5 calls = -150 delta (approximately)
- Net = 0 delta (neutral, which is my thesis)

Without this check: I sell 5 calls thinking I'm covered by the 100 shares in my individual account. I'm actually naked 350 shares. If NVDA gaps up 10% overnight, I lose $35K.

With the system: I confirm I'm covered. I execute the trade knowing my actual risk.

**Exit:**
5 days later, IV drops (from 40 to 28). I buy back the calls for $250 per contract.
Profit: $750 per call × 5 = $3,750 (on $2,000 premium collected)

I log this in:
- Realized Trades database (closed trade, +$750 profit)
- Strategy Log (Vol Reversion on Semis: +$750)
- Journal (entry logic: vol spike, exit logic: IV normalized)

Now I have data: "Vol reversion trades on semiconductors have a 75% win rate, avg profit $600."

This informs future decisions.

---

## The Hidden Problem Most Traders Face

**Tax disaster:**

You trade actively. At year-end you have:
- 50 closed positions
- 18 of them are short-term gains
- 8 of them are short-term losses
- You need to know the exact dates, costs, proceeds

Without a system: You spend 20 hours in March trying to reconstruct this from broker statements. You miss $3K in losses because you can't find the trade.

With a system: One click. "Realized Trades" view, filtered by "2026." All short-term gains/losses right there.

**Wash sale disaster:**

You sell XYZ for a $500 loss in December.
In January, you see a dip and rebuy.
Without a system: You don't know you triggered a wash sale until April when your CPA tells you the loss doesn't count. You owe $150 more in taxes.

With a system: Wash sale flag tells you "You can rebuy this on Jan 31 without triggering wash sale. Rebuy before then = $150 tax loss."

That's worth the price of the template right there.

---

## Why I Built This Into a Template

After using this for six months, I realized most traders face the same problems:
- Multiple brokers
- No unified view
- Poor tax tracking
- No discipline in the journal
- Decisions made in chaos, not based on data

I turned my system into a template. [You can duplicate it here →](https://outdoorphunk.gumroad.com)

Setup takes 1 hour. Maintenance takes 30 min per week. It saves 5+ hours per week of spreadsheet work and prevents thousands in tax mistakes.

---

## What's Actually Happening Under the Hood

This system does four things:

1. **Prevents over-leverage**
   - You can see total Greeks across all accounts
   - You know when you're drifting from neutral
   - You adjust before you're overleveraged

2. **Forces discipline**
   - You can't exit a position without logging why
   - You can't ignore a stop loss
   - You can see which strategies actually work (data, not emotion)

3. **Eliminates tax disasters**
   - Every closed trade is logged with holding period
   - Wash sale calendar prevents mistakes
   - Loss harvesting opportunities are flagged

4. **Creates accountability**
   - Every trade is journaled
   - Every exit reason is logged
   - You can measure: Are you actually profitable? Which strategies? What's your real win rate?

Most traders don't know their actual win rate. They remember the 3 big wins and forget the 15 small losses. The journal fixes that.

---

## The Real Payoff

I've been using this system for 8 months.

In that time:
- Zero tax surprises (I do accurate quarterly estimates)
- Zero wash sale mistakes (the calendar prevents them)
- Zero over-leverage events (I check Greeks daily)
- 65% win rate on vol reversion trades (up from "I think it's 50%?")
- 72% win rate on earnings arbs (lower risk, slow growth)
- 45% win rate on correlation trades (higher risk, bigger swings)

Because I know these win rates, I size positions accordingly:
- Vol reversion: 2-3% per position (high confidence)
- Earnings arbs: 1-2% per position (medium confidence)
- Correlation trades: 0.5-1% per position (low confidence, higher upside)

This single piece of data (knowing my actual win rate) makes more difference than any trading signal.

---

## Starting Now

1. **Audit your current positions** (30 min)
   - Write down every position across all accounts
   - Document entry price, current price, thesis
   - Mark which ones are part of which strategy (if any)

2. **Set up a tracker** (1 hour)
   - [Use my template →](https://outdoorphunk.gumroad.com)
   - OR build your own spreadsheet
   - Just start tracking the basics

3. **Start journaling** (immediate)
   - Next trade you make: Log why
   - When you exit: Log the actual reason (was it your plan or emotion?)
   - Track outcome: Win or loss?

4. **Review monthly** (30 min)
   - Calculate win rate per strategy
   - Identify biggest mistakes
   - Adjust position sizing

5. **Tax time gets easier** (April/March)
   - Pull your "Realized Trades" report
   - Every closed position is there with cost basis + holding period
   - Hand to CPA (or file yourself confidently)

---

## Why This Matters Right Now

In the next 24 months, volatility will be high. Opportunities will be real. But so will the losses.

Traders with systems will scalp 2-3% per month on vol spikes.
Traders without will panic-sell at the bottom.

The difference isn't intelligence or luck.

It's infrastructure + discipline.

Build yours now.

---

**Get started:**
- [Portfolio Tracker template (multi-account, Greeks, tax-aware)](https://outdoorphunk.gumroad.com)
- [TradingView (volatility data to identify spikes)](https://tradingview.com?aff_id=165244)
- [Sharesight (tax loss harvesting alerts)](https://sharesight.com/?ref=INSERT_CODE_HERE)

This is your edge. Not luck. Not research. Execution infrastructure.
