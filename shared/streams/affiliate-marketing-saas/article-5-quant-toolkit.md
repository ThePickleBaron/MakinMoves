# The Quant Toolkit: What You Actually Need to Execute in Volatility

Most traders buy premium software and never use it.

$300/month for an all-in-one platform. $100/month for research. $50/month for alerts. $200/month for execution.

Then they close it all and trade on Robinhood.

The problem isn't the tools. It's that traders don't know what they actually need.

Here's what I use to run quantitative strategies. Nothing fancy. Nothing expensive. Just what works.

---

## The Core Stack (What You Actually Need)

### 1. TradingView — Volatility Data + Screeners

**What it does:** Real-time IV tracking, historical volatility comparisons, earnings calendar, Greeks.

**Why I use it:** It's the fastest way to spot mean-reversion setups.

**Concrete workflow:**
1. Open TradingView screener
2. Filter by IV Rank > 75th percentile (spike)
3. Find stocks where 1-month IV > 30-year avg + 1 std dev
4. That's my short-premium setup list
5. Takes 3 minutes. Done.

**Alternative:** Your broker's screener. But TradingView is faster.

**Price:** Free tier works. Paid adds data export ($15/mo) and I-want-it-all features ($60/mo). Don't need them.

**Real cost benefit:** Finding one profitable vol trade per month pays for the annual subscription. I find 3-4.

[Get TradingView →](https://tradingview.com?aff_id=165244)

---

### 2. Your Brokerage (Fidelity, Schwab, Interactive Brokers)

**What you need:**
- Multi-account view (most brokers have this now)
- Options chains with Greeks (all brokers have this)
- Tax reporting (essential for wash sales)
- Trade API (if you want to automate)

**My preference:** Interactive Brokers for options, Fidelity for simplicity.

**Why:** IB has the cleanest Greeks display. Fidelity has the best tax tracking.

**Price:** Free. Commissions on options are $0.65-1.00 per contract (worth it for precision execution).

**Real cost benefit:** Better execution on a 10-contract trade saves you $50. Wash sale awareness saves you $500 in taxes. Both paid for by broker choice.

---

### 3. Portfolio Tracker (Mine, or Build Your Own)

This is the infrastructure most traders skip. Mistake.

**What it needs to do:**
- Track positions across all accounts
- Calculate Greeks on options (delta, theta, vega, gamma)
- Show tax lot information (cost basis + holding period)
- Flag wash sale risk (can I rebuy or not?)
- Journal every trade (entry logic + exit logic)

**The DIY approach:**
- Build in Excel/Sheets
- Takes 20-30 hours
- Updates daily
- Fragile (one formula breaks everything)
- You won't maintain it

**The template approach:**
- Pre-built Notion database
- Greeks calculated automatically
- Tax data from broker exports
- Already tested + debugged
- [Portfolio Tracker template →](https://outdoorphunk.gumroad.com)
- Takes 1 hour to set up
- Saves 5 hours/week of spreadsheet work

**Real cost benefit:** Catch one wash sale before it happens = $500 saved. Avoid one overleveraged position = $2K saved. Both happen from better tracking.

**Price:** Template is $34. DIY = 30 hours of your time. Do the math.

---

### 4. Sharesight — Tax Awareness Engine

Here's the problem: You make great trades. Then tax season hits and you owe $5K more because of wash sales you didn't track.

Sharesight prevents this with one feature: **Wash sale alerts**.

**How it works:**
1. You sell Tesla at loss ($500 loss)
2. You want to rebuy (market dipped more)
3. Sharesight alert: "Rebuy Jan 20 triggers wash sale (30 days from sale). Rebuy Jan 31 is safe."
4. You wait 10 days
5. You save the $150 tax on that loss deduction

That one alert pays for a year of Sharesight.

**Additional features:**
- Tax-gain harvesting (when to sell winners)
- Dividend tracking (reinvestment math)
- Multi-currency support (if you trade internationally)
- Broker integrations (auto-import trades)

**Price:** Free for basic portfolio tracking. $10-20/month for tax features (worth it).

[Get Sharesight →](https://sharesight.com/?ref=INSERT_CODE_HERE)

---

### 5. Yahoo Finance — Earnings Calendar + Fundamentals

Free. No paywall. No BS.

**What it does:**
- Earnings calendar (which companies report when)
- Historical earnings surprises (beat/miss patterns)
- Financial statements (balance sheet + cash flow)
- Insider trading (see what executives are buying)

**How I use it:**
- Check earnings calendar Friday (looking ahead 2-3 weeks)
- Find the ones with biggest historical moves
- Compare to implied moves (options market pricing)
- Find mispricings
- Set up earnings arbitrage trades

**Example:**
- AMD reports in 10 days
- Historical earnings move: 8% (volatile stock)
- Implied move: 5% (underpriced)
- Action: Buy straddle, sell at 6.5% move, profit
- Probability: 70% (history is clear on AMD volatility)

**Price:** Free.

---

### 6. Excel / Google Sheets — Greeks Calculator

For the trades that need manual Greeks tracking:

**Why you need this:**
- Multi-leg positions (short call + long put + long stock)
- Non-standard expirations
- Spreads that your tracker doesn't calculate

**What you need:**
- Black-Scholes formula (10 lines of formula)
- Stock price, strike, days to expiration, IV
- Calculate delta, gamma, theta, vega

**How long:** 30 minutes to build. Reusable forever.

**When to use:** Before entering a 5+ leg position. Just verify the Greeks make sense.

**Price:** Free.

---

## The Real Workflow (How It All Fits)

**Monday morning:**
1. Open TradingView screener
2. Find vol mean reversion setups (5 min)
3. Check Sharesight for tax restrictions (can I execute these? 2 min)
4. Open broker, check Greeks on candidates (5 min)
5. Enter signals into portfolio tracker (2 min)
6. Set alerts in TradingView (3 min)

Total: 17 minutes.

**Wednesday (position management):**
1. Check alerts (which positions hit targets?)
2. Review portfolio tracker (what's my net delta? Am I over-leveraged?)
3. Adjust if needed (exit winners, scale losers)
4. Update journal with execution logic

Total: 10 minutes.

**Friday (week review):**
1. Log P&L from the week
2. Review each trade (what worked? what didn't?)
3. Update systems (anything to improve?)

Total: 15 minutes.

**Monthly (tax + strategy review):**
1. Run Sharesight report (tax projection)
2. Check for wash sale risks
3. Verify journal (all trades logged)
4. Plan next month's strategies

Total: 30 minutes.

**Total time: ~3 hours per week to run multiple quantitative strategies.**

Most traders spend 20+ hours per week watching charts and losing money.

---

## The Honest Truth

This toolkit doesn't cost much ($34 template + $20 Sharesight + free TradingView = $54/month).

The real cost is discipline.

You need to:
- Log every trade (why did you enter?)
- Track every exit (was it the plan or emotion?)
- Follow signals even when you doubt them
- Scale up only after proving profitability
- Accept small losses without spiraling

Most traders can't do this. They'd rather trade on hunches.

If you can? You'll make money.

---

## What's Missing

What I deliberately don't use:

**Paid research services** ($100-500/month)
- You don't need opinions. You need data.
- Yahoo Finance data is free and sufficient.

**Algorithmic trading platforms** ($200-1000/month)
- You don't need algorithms. You need discipline.
- Most traders can't even execute simple rules. Algorithms make it worse.

**Premium brokers with personal advisors**
- Their job is to manage your money and take a cut.
- Your job is to manage your own money and keep 100% of profits.

**AI tools that "predict markets"**
- If they worked, they'd be worth billions and you'd never hear about them.
- They don't work. They're marketing.

Save your money. Focus on signal + execution.

---

## Getting Started

1. **Set up TradingView.** (15 min)
   - Create account
   - Learn screener basics
   - Find one vol spike (live data)

2. **Set up your broker's Greeks tool.** (10 min)
   - Log in
   - Find options chains
   - Understand Greeks columns

3. **Set up the portfolio tracker.** (1 hour)
   - Duplicate the template
   - Import one month of trades
   - Verify calculations match your broker

4. **Set up Sharesight.** (20 min)
   - Connect broker
   - Let it import trades
   - Check wash sale alerts

5. **Create your first strategy.** (1 hour)
   - Pick vol reversion (simplest)
   - Set rules (IV > X, short Y contracts, exit at Z)
   - Backtest on recent data (did this signal work historically?)

6. **Paper trade for 2 weeks.** (No money at risk)
   - Run signals
   - Track execution
   - Find friction points

7. **Go live small.** (1-2 positions per week)
   - $5K per position max (even if you have $250K)
   - Follow signals exactly
   - Log everything

---

## The Payoff

This stack costs $54/month and 3 hours/week.

In 3 months of disciplined execution, you'll make:
- Profitable vol trades: +2-3% per month = +6-9% per quarter
- Earnings arbs: +1-2% per month = +3-6% per quarter
- Correlation plays: +1-2% per month = +3-6% per quarter

Blended: +12-21% per quarter in volatility regime.

That's $30-50K in profits on a $250K account.

Minus Sharesight ($20), TradingView ($0), template ($34), and your 3 hours/week.

Still worth it?

Yeah.

---

**Get started today:**
- [TradingView (volatility screener)](https://tradingview.com?aff_id=165244)
- [Portfolio Tracker template](https://outdoorphunk.gumroad.com)
- [Sharesight (tax awareness)](https://sharesight.com/?ref=INSERT_CODE_HERE)

Everything else is noise.
