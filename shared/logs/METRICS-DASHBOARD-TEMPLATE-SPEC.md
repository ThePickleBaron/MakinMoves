# METRICS DASHBOARD TEMPLATE SPEC
**Purpose:** Track 90-day revenue sprint performance  
**Owner:** Jason (updates weekly)  
**Review cadence:** Friday 3 PM ET (weekly snapshot)  
**Location:** Google Sheet (share link with Claude for updates)

---

## TAB 1: WEEKLY TRACKER (Most Important)

**Row 1: Headers**
```
Week | Start Date | Free Subs | Paid Subs (Briefing) | Briefing Revenue | Template Sales | Template Revenue | Report Sales | Report Revenue | Total Revenue | Growth Rate | Email Open Rate | Email Click Rate | Notes
```

**Format:**
- **Week:** Number (1, 2, 3, etc.)
- **Start Date:** Date format (4/7/2026)
- **Free Subs:** Total free subscribers (from Substack analytics)
- **Paid Subs (Briefing):** Active paid subscriptions to Premium tier (from Substack)
- **Briefing Revenue:** Paid Subs × $8 = $X
- **Template Sales:** Units sold (from Gumroad)
- **Template Revenue:** Sales × $29 = $X
- **Report Sales:** Units sold (from Gumroad)
- **Report Revenue:** Sales × $19 = $X
- **Total Revenue:** Briefing Revenue + Template Revenue + Report Revenue
- **Growth Rate:** (Free Subs this week - Free Subs last week) / Free Subs last week × 100 = X%
- **Email Open Rate:** % from email platform (Substack shows this)
- **Email Click Rate:** % clicking CTAs (track with UTM parameters)
- **Notes:** Any context (e.g., "briefing published Monday instead of Tuesday", "platform outage affected conversion")

**Sample Week 1 Row:**
```
1 | 4/7/2026 | 500 | 10 | $80 | 3 | $87 | 2 | $38 | $205 | 0% | 32% | 4.1% | "Briefing launched Tuesday"
```

**Formulas to auto-calculate:**
- Briefing Revenue: `=C2*8` (Paid Subs × $8)
- Template Revenue: `=E2*29` (Sales × $29)
- Report Revenue: `=G2*19` (Sales × $19)
- Total Revenue: `=D2+F2+H2` (sum all revenue)
- Growth Rate: `=(B2-B1)/B1*100` (week-over-week growth, show as %)

---

## TAB 2: MONTHLY SUMMARY

**For end-of-month review (Day 30, Day 60, Day 90)**

**Row 1: Headers**
```
Month | Free Subs Start | Free Subs End | Paid Subs Start | Paid Subs End | Total Revenue | CAC (Cost per Sub) | Churn Rate | Top Platform | Notes
```

**Definitions:**
- **Free Subs Start/End:** Free subscriber count at start and end of month
- **Paid Subs Start/End:** Active paid subscribers (briefing only) at start and end of month
- **Total Revenue:** Sum of all revenue streams that month
- **CAC (Cost per Sub):** Total ad spend / New subs acquired (should be $0 for organic launch)
- **Churn Rate:** (Lost paid subs / Starting paid subs) × 100 = X% (track to ensure retention)
- **Top Platform:** Which growth channel drove most new free subs (Medium, Seeking Alpha, Reddit, etc.)

**Sample Month 1:**
```
1 | 500 | 550 | 10 | 18 | $465 | $0 | 10% | "Organic growth" | "No paid ads; organic Substack traffic"
```

**Formulas:**
- Churn Rate: `=(D2-E2)/D2*100` (subs lost / starting subs)

---

## TAB 3: PRODUCT PERFORMANCE (Detailed)

**Track performance of each product independently**

### BRIEFING Sub-Tab

**Row 1: Headers**
```
Week | New Paid Subs | Total Paid Subs | Conversion Rate | Retention Rate | Trial to Paid | Revenue | Notes
```

**Definitions:**
- **New Paid Subs:** New paid signups that week
- **Total Paid Subs:** Cumulative active subscribers
- **Conversion Rate:** (Paid / Free Subs) × 100 = X%
- **Retention Rate:** (Paid Subs This Week / Paid Subs Last Week) × 100 = X% (should be 85%+)
- **Trial to Paid:** If you enable Substack free trials, track how many trial users convert to paid
- **Revenue:** New Paid × $8 + (price increase bonuses if any)

**Sample Week 1:**
```
1 | 10 | 10 | 2.0% | 100% | 8/10 (80%) | $80 | "Baseline signal strong; 80% trial→paid conversion"
```

### TEMPLATES Sub-Tab

**Row 1: Headers**
```
Week | Units Sold | Total Units (YTD) | Conversion Rate | Avg Rating | Refund Rate | Revenue | Notes
```

**Definitions:**
- **Units Sold:** Total units (bundle + individual templates combined)
- **Total Units YTD:** Cumulative units sold since launch
- **Conversion Rate:** (Units Sold / Free Subs) × 100 = X%
- **Avg Rating:** Average star rating (from Gumroad reviews)
- **Refund Rate:** % of purchases refunded (should be <10%; >20% = product issue)
- **Revenue:** Units × $29 (or weighted if bundle vs. individual mixes)

**Sample Week 2:**
```
2 | 6 | 9 | 1.1% | 4.2/5 | 0% | $174 | "Positive feedback on usability; no refunds"
```

### REPORTS Sub-Tab

**Row 1: Headers**
```
Week | Units Sold | Total Units (YTD) | Avg Report Depth (pages) | Conversion Rate | Revenue | Notes
```

**Definitions:**
- **Units Sold:** Number of reports purchased that week
- **Total Units YTD:** Cumulative reports sold
- **Avg Report Depth:** Pages per report (track to ensure quality)
- **Conversion Rate:** (Reports Sold / (Free Subs + Briefing Subs)) × 100 = X%
- **Revenue:** Units × $19

**Sample Week 3:**
```
3 | 7 | 14 | 28 pages | 1.3% | $133 | "First report well-received; launching second report next week"
```

---

## TAB 4: AUDIENCE GROWTH BREAKDOWN

**Track which platforms drive growth (activate after week 2)**

**Row 1: Headers**
```
Week | Medium Posts | Medium Signups | Seeking Alpha Posts | SA Signups | Reddit Posts | Reddit Signups | Twitter Tweets | Twitter Signups | Lead Magnet Signups | Total New Subs | Best Performer
```

**Definitions:**
- **Medium Posts:** # of articles posted
- **Medium Signups:** New subs from Medium (use UTM tracking or Substack dashboard source)
- **Seeking Alpha Posts:** # of articles posted
- **SA Signups:** New subs from Seeking Alpha (via referral link)
- **Reddit Posts:** # of posts (across multiple subreddits)
- **Reddit Signups:** New subs from Reddit links
- **Twitter Tweets:** # of threads posted
- **Twitter Signups:** Clicks to Substack from Twitter (use UTM: `?utm_source=twitter`)
- **Lead Magnet Signups:** Downloads of free template sample
- **Total New Subs:** Sum of all platform signups
- **Best Performer:** Which platform drove most signups that week

**Sample Week 2:**
```
2 | 1 | 12 | 1 | 18 | 2 | 8 | 3 | 2 | 22 | 60 | "Seeking Alpha"
```

**Formula:**
- Total New Subs: `=C2+E2+G2+I2+K2` (sum all sources)

---

## TAB 5: DASHBOARD (Auto-Calculated Summary)

**High-level 90-day overview (auto-pulls from other tabs)**

```
WEEK 1–30 SUMMARY
=================
Free Subscribers: 500 → 600 (20% growth)
Paid Subscribers (Briefing): 10 → 18 (80% growth)
Total Revenue (Month 1): $465
Average Weekly Revenue: $116

WEEK 31–60 SUMMARY (Month 2)
=================
Free Subscribers: 600 → 800 (33% growth)
Paid Subscribers: 18 → 35 (94% growth)
Total Revenue (Month 2): $843
Average Weekly Revenue: $211

WEEK 61–90 SUMMARY (Month 3)
=================
Free Subscribers: 800 → 1,000 (25% growth)
Paid Subscribers: 35 → 55 (57% growth)
Total Revenue (Month 3): $1,376
Average Weekly Revenue: $344

TOTAL 90-DAY METRICS
====================
Starting Free Subs: 500
Ending Free Subs: 1,000 (100% growth, 20% MoM average)
Starting Paid Subs: 0
Ending Paid Subs: 55
Total 90-Day Revenue: $2,684
Projected Annual Revenue: $10,736

CHURN RATE: 12% (acceptable for SaaS)
CAC (Customer Acquisition Cost): $0 (organic)
LTV (Lifetime Value): $192 (assuming 24-month retention at $8/mo)
```

---

## SETUP INSTRUCTIONS (5 Minutes)

1. **Create new Google Sheet** — Name it "MakinMoves Revenue Dashboard"
2. **Create tabs:** Weekly Tracker, Monthly Summary, Product Performance (with 3 sub-sections), Audience Growth, Dashboard
3. **Copy headers exactly** from sections above
4. **Add formulas** where indicated
5. **Share with Claude** (view access, so Claude can update weekly)

---

## UPDATE CADENCE (Jason or Claude)

**WEEKLY (Every Friday 3 PM ET):**
- [ ] Update Weekly Tracker with latest metrics
- [ ] Plug in Substack analytics (free subs, paid subs)
- [ ] Plug in Gumroad sales (templates, reports)
- [ ] Plug in email metrics (open rate, click rate)
- [ ] Calculate growth rate
- [ ] Add notes on anything unusual

**MONTHLY (End of each month):**
- [ ] Complete Monthly Summary tab
- [ ] Calculate churn rate
- [ ] Identify top platform
- [ ] Review and adjust strategy if churn >15%

**DAILY (Optional, 2 minutes):**
- [ ] Track revenue in a notes section (real-time revenue is motivating)

---

## COLOR CODING (Optional, Makes Dashboard Readable)

**Column colors by performance:**
- 🟢 **Green:** On target or exceeding goal
- 🟡 **Yellow:** Below target but acceptable
- 🔴 **Red:** Below threshold, requires action

**Examples:**
- Growth Rate 15%+ = green, <10% = yellow, <5% = red
- Conversion Rate 2%+ = green, 1–2% = yellow, <1% = red
- Churn Rate <10% = green, 10–15% = yellow, >15% = red

---

## DECISION THRESHOLDS (Use Dashboard to Decide)

**By Day 7 (First briefing results):**
- Signal: 5+ paid subs OR >30% conversion on first email
- No signal: <3 subs + poor engagement
- Decision: Proceed to templates (signal) or optimize briefing (no signal)

**By Day 14 (Templates live):**
- Signal: 5+ sales + positive feedback
- No signal: <3 sales + negative feedback
- Decision: Proceed to reports (signal) or redesign templates (no signal)

**By Day 30 (Monthly review):**
- Revenue: $300–$500 (realistic)
- Churn: <15% (acceptable)
- Growth: 10%+ week-over-week
- If missing: Adjust messaging, pricing, or growth tactics

---

## DATA SOURCES (Where to Get Numbers)

**Substack Analytics:**
- Free subs: Dashboard → Analytics → Subscribers
- Paid subs: Dashboard → Subscriptions → Active
- Email metrics: Dashboard → Analytics → Email

**Gumroad Sales:**
- Units sold: Dashboard → Sales
- Revenue: Automatically calculated
- Refund rate: Dashboard → Transactions filter

**Growth Platforms:**
- Medium: Dashboard → Stats (views, reads, followers)
- Seeking Alpha: Track clicks via referral link
- Reddit: Track via UTM parameters or manual count
- Twitter: Analytics dashboard or manual count
- Substack: "Referrer" column shows platform source

---

## EXAMPLE COMPLETE WEEK 1

```
Week: 1
Start Date: 4/7/2026
Free Subs: 500
Paid Subs (Briefing): 10
Briefing Revenue: $80
Template Sales: 3
Template Revenue: $87
Report Sales: 2
Report Revenue: $38
Total Revenue: $205
Growth Rate: 0% (first week baseline)
Email Open Rate: 32%
Email Click Rate: 4.1%
Notes: "Briefing published Tuesday. Email open rate solid. 80% of email readers clicked CTA to product. Positive signal."
```

---

**Dashboard ready to build. Share the Google Sheet link with Claude once created so weekly updates can be automated.**

