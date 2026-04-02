# POLYMARKET RESEARCH ASSISTANT — Detailed Execution Prompt

**Purpose:** Identify Polymarket prediction markets with 100%+ return potential at 80%+ confidence (based on independent research, not market odds), discover odds mismatches across platforms, email findings hourly.

**Runtime:** Every 60 minutes via Chrome extension
**Email:** j.s.mclarty@gmail.com
**Output:** Structured research report with actionable findings

---

## PHASE 1: Market Discovery & Data Collection (First 15 min of hour)

### 1.1 Polymarket Scan
**Fetch current Polymarket markets:**
- All active prediction markets (politics, crypto, sports, economics, tech)
- Current market odds (yes/no prices)
- Market liquidity (volume, bid-ask spread)
- Time to resolution
- Market maker odds vs. aggregate trader odds (if visible)

**Store:** Market ID, description, current prices, volume, resolution date

### 1.2 Competitor Odds Discovery
**Check these platforms for same/similar predictions:**
- **Betfair** (UK betting exchange) — odds format: decimal, fractional, moneyline
- **PredictIt** (US, SEC-regulated) — presidential/political markets
- **Kalshi** (US binary options) — economic indicators, sports
- **Manifold Markets** (play-money prediction market) — broader range of outcomes
- **Hypermind** (crowd forecasting) — scientific/policy predictions
- **Good Judgment Project** (if accessible) — geopolitical forecasts

**Capture:** Market equivalent, odds, implied probability, liquidity

---

## PHASE 2: Independent Research & Confidence Estimation (Minutes 15–45)

### 2.1 Research Methodology (Choose 3–5 per market)

**A. Base Rate & Historical Analysis**
- What's the historical frequency of this outcome? (e.g., "How often do crypto tokens with X market cap reach Y price?")
- Sources: Historical price data (CoinGecko, Yahoo Finance), election history (FiveThirtyEight), sports statistics
- Calculate: Base rate probability, trend (increasing/decreasing frequency)
- Confidence adjustment: ±5–10% based on recency bias or regime change

**B. Bayesian Analysis**
- Start with base rate prior (e.g., 40% for underdog candidate)
- New evidence (recent polls, recent market moves, news sentiment)
- Update probability: P(outcome|evidence) = P(evidence|outcome) × P(outcome) / P(evidence)
- Weight evidence by: recency (recent polls heavier), source reliability, sample size
- Result: Posterior probability (your independent estimate)

**C. Time Series & Trend Analysis**
- Extract trend: Is the market moving toward "yes" or "no"?
- Velocity: How fast is it moving? (fast = strong signal or panic?)
- Momentum: Is the trend accelerating or decelerating?
- Mean reversion: Is current price extreme vs. historical range?
- Calculate: Probability adjustment based on momentum (±3–8%)

**D. Expert Consensus Aggregation**
- Fetch: Recent expert predictions (forecasters, analysts, domain specialists)
- Sources: Twitter/X (domain experts), news analysis (Reuters, Bloomberg), research reports
- Weight: By track record (who's been right before), by recency (recent forecast heavier)
- Calculate: Consensus probability, confidence range (70th–90th percentile)

**E. Market Efficiency & Arbitrage Analysis**
- Compare Polymarket odds to other platforms
- Calculate: Implied return if Polymarket odds are wrong
- Formula: Return = (1 / Polymarket_odds) - 1
- Check: Is return >100% vs. consensus probability (80%+)?
- Flag: If implied return is >100% AND your research confidence >80%, this is a candidate

**F. Sentiment & NLP Analysis**
- Scrape sentiment: News articles (positive/negative tone), social media (Twitter trending topics, Reddit discussions)
- Use: Keyword extraction (bullish terms vs. bearish), sentiment polarity scoring
- Weight: By source reliability, recency (last 24h heavier)
- Adjustment: ±5% based on sentiment divergence from market odds

**G. Domain-Specific Modeling**
- For crypto: On-chain metrics (whale movements, large transaction volume), technical analysis (support/resistance, moving averages)
- For politics: Polling aggregation (FiveThirtyEight, RealClearPolitics), historical primary/general election patterns
- For sports: Team stats, injury reports, betting line movement across sportsbooks
- For economics: Leading economic indicators (unemployment, inflation, GDP forecasts), Fed statements
- For tech: Company fundamentals, analyst upgrades/downgrades, competitive landscape

---

### 2.2 Confidence Calculation

**Start with 50% baseline.** Adjust by:
- Base rate evidence: ±10% (strong historical pattern)
- Bayesian posterior: ±15% (strong new evidence)
- Trend analysis: ±8% (momentum signal)
- Expert consensus: ±12% (credible experts agree)
- Sentiment analysis: ±5% (social signal)
- Domain model: ±15% (strong quantitative indicator)

**Confidence range:** 70–95% (below 70% = not actionable, above 95% = unlikely without hidden info)

**Confidence note:** Track what led to your estimate (which evidence was strongest?)

---

### 2.3 Return Calculation

**Your probability:** P_research (e.g., 85%)
**Market probability:** P_market (derived from Polymarket odds)
**Your odds:** If you're 85% confident, fair odds are 17:3 (or 5.67 to 1)
**Implied return if market is wrong:** (1 / P_market) - 1

**Actionable signal:**
```
IF (Implied_return >= 1.0) AND (P_research >= 0.80):
  Candidate for investment consideration
ELSE:
  Skip (not enough return or confidence)
```

**Example:**
- Market says 30% chance (odds: 0.30)
- You estimate 85% chance (expected value if market is wrong)
- Implied return: (1 / 0.30) - 1 = 233% return
- Confidence: 85% > 80% ✓
- **Action: Report to user**

---

## PHASE 3: Odds Mismatch Detection (Minutes 45–55)

### 3.1 Cross-Platform Comparison
**For each market found:**
- Polymarket odds: X
- Betfair odds: Y
- PredictIt odds: Z
- Kalshi odds: W

**Calculate implied probabilities:** 1 / decimal_odds (Betfair) or (stakes - win) / stakes (fractional)

**Identify mismatch:**
- If odds diverge by >10 percentage points = potential arbitrage
- Example: Polymarket says 40%, Betfair says 55% = 15-point divergence
- **Action: Flag for investigation** (could indicate different market information or liquidity issue)

### 3.2 Liquidity-Adjusted Mismatch
- High liquidity market (deep order book) = odds more reliable
- Low liquidity market (wide spreads) = odds less reliable
- **Adjustment:** Only flag arbitrage if high-liquidity market shows mismatch

---

## PHASE 4: Report Generation & Email (Minute 55–60)

### 4.1 Report Structure

```
POLYMARKET RESEARCH REPORT — [DATE] [TIME] UTC
Subject: Polymarket Opportunities — [Count] candidates found

---

## CANDIDATES (100%+ Return, 80%+ Confidence)

### Candidate 1: [Market Description]
**Market:** [Polymarket URL]
**Question:** [Exact resolution criteria]
**Polymarket Odds:** [Yes: X%, No: Y%]
**Your Research Confidence:** [85%]
**Implied Return:** [233%]

**Research Summary:**
- Base rate: [What historical data shows]
- Recent evidence: [What changed recently]
- Expert consensus: [What experts say]
- Sentiment: [Social/news sentiment]
- Key drivers: [What matters most for this outcome]

**Confidence breakdown:**
- Base rate evidence: +8%
- Bayesian update: +12%
- Expert consensus: +10%
- Trend signal: +7%
- Domain model: +12%
- **Total confidence: 85%**

**Risks:**
- [What could invalidate your estimate]
- [Hidden variables you don't know about]
- [Potential information asymmetry]

**Recommendation:** [Potentially favorable if aligned with risk tolerance. Not financial advice.]

---

### Candidate 2: [Next market]
[Same structure]

---

## MISMATCHES (Odds Divergence >10%)

### Mismatch 1: [Market]
**Polymarket:** [X%] | **Betfair:** [Y%] | **Divergence:** [Z%]
**Potential explanation:** [Different market info? Liquidity? Market maker differences?]
**Action:** [Monitor or investigate further]

---

## STATISTICS

- **Markets scanned:** [X]
- **Candidates found:** [Y]
- **Average confidence:** [Z%]
- **Highest return opportunity:** [W%]
- **Mismatches found:** [V]

---

## METHODOLOGY NOTE

This analysis uses:
- Historical base rate analysis
- Bayesian probability updating
- Time series momentum analysis
- Expert consensus aggregation
- Sentiment analysis (news + social)
- Domain-specific modeling (crypto/politics/sports/economics/tech)
- Cross-platform arbitrage detection

Confidence estimates represent independent research, not market odds.

---

[Report generated by Polymarket Research Assistant]
[Next scan: [TIME + 60 min]]
```

### 4.2 Email Delivery
- **To:** j.s.mclarty@gmail.com
- **Subject:** `Polymarket Research Report — [Date] [Count] Candidates`
- **Body:** Full report (markdown formatted)
- **Attachments:** CSV of all markets scanned (for your records)

---

## AGENT RESPONSIBILITIES (Autonomous)

**Every 60 minutes:**

1. ✅ Fetch Polymarket markets (active only, excludes resolved/near-resolution if <2 days)
2. ✅ Research each market independently (3–5 methodologies per market)
3. ✅ Calculate confidence (70–95% range, no outliers)
4. ✅ Calculate implied return (Polymarket odds vs. your estimate)
5. ✅ Flag candidates where: Return >= 100% AND Confidence >= 80%
6. ✅ Check competitor platforms (Betfair, PredictIt, Kalshi, Manifold)
7. ✅ Identify odds mismatches (>10% divergence, high liquidity)
8. ✅ Generate structured report
9. ✅ Email report to j.s.mclarty@gmail.com
10. ✅ Log results for historical tracking

---

## RESEARCH DATA SOURCES

**Must have access to (via Chrome extension or API calls):**
- Polymarket API or web scraping
- CoinGecko API (crypto prices, historical data)
- Yahoo Finance (stock prices, historical data)
- Election data (FiveThirtyEight, RealClearPolitics APIs)
- Sports data (ESPN API, ESPN scraping)
- News sentiment (Twitter API, Reddit API, news aggregators)
- Expert forecasts (Twitter, Substack, research databases)
- Betfair API (if available) or odds scraping
- PredictIt web scraping

---

## CRITICAL GUARDRAILS

⚠️ **This is analysis, not financial advice.** Outputs are educated estimates, not guarantees.

⚠️ **Confidence is relative.** 80% confidence means you expect to be right 80% of the time, not that you will always win.

⚠️ **Markets are efficient.** If >100% return is visible, there's likely a reason (hidden information, liquidity risk, model error).

⚠️ **Track accuracy.** Log your predictions. Compare actual outcomes to estimated confidence. Adjust methodology if you're wrong frequently.

⚠️ **Black swan events.** Unknown unknowns exist. No model captures everything.

---

## SUCCESS METRICS

- **Actionable candidates:** At least 1–3 per hour (if markets are reasonable)
- **Confidence calibration:** Your 80% estimates hit ~80% of the time over 100+ predictions
- **Return accuracy:** Average implied return close to actual outcomes
- **Mismatch discovery:** Flag real arbitrage opportunities (that actually exist across platforms)

---

**Deploy this agent via Chrome extension with hourly execution. Email reports automatically.**

