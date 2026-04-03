# Metrics Dashboard Build Specification
**For:** Google Sheets template creation (for Jason to populate)

---

## OVERVIEW

Google Sheets dashboard with 6 tabs:
1. Daily metrics snapshot
2. Weekly roll-up
3. Conversion funnel
4. Channel breakdown
5. Churn tracking
6. Revenue projection

All formulas automated so Jason only enters raw data once per day.

---

## TAB 1: DAILY METRICS SNAPSHOT

**Purpose:** Track daily performance across all platforms

### Columns (A-G)

| Column | Header | Formula | Example |
|--------|--------|---------|---------|
| A | Date | Hardcoded | 4/4/2026 |
| B | Twitter Followers | Hardcoded | 145 |
| C | Email Subscribers (Free) | Hardcoded | 67 |
| D | Email Subscribers (Paid) | Hardcoded | 3 |
| E | Reddit Karma | Hardcoded | 124 |
| F | Affiliate Clicks | Hardcoded | 28 |
| G | Revenue ($) | =D*8 (paid × $8/mo price) | $24 |

### Data entry
- Jason enters: Date, Twitter, Email Free, Email Paid, Reddit, Affiliate
- Formulas auto-calculate: Revenue

### Rows
- Row 1: Headers
- Rows 2-100: Daily entries (90 days of data)

---

## TAB 2: WEEKLY ROLL-UP

**Purpose:** Aggregate daily data into weekly metrics

### Columns (A-M)

| Column | Header | Formula | Notes |
|--------|--------|---------|-------|
| A | Week | Hardcoded | Week 1 (Apr 4-11) |
| B | Start Date | Hardcoded | 4/4/2026 |
| C | End Date | Hardcoded | 4/11/2026 |
| D | Twitter (Start) | Lookup from Tab 1 | =INDEX(Tab1!B:B,1) |
| E | Twitter (End) | Lookup from Tab 1 | =INDEX(Tab1!B:B,7) |
| F | Twitter Growth | =E-D | 45 followers |
| G | Email Free (Start) | Lookup | =INDEX(Tab1!C:C,1) |
| H | Email Free (End) | Lookup | =INDEX(Tab1!C:C,7) |
| I | Email Free Growth | =H-G | 25 subs |
| J | Email Paid (End) | Lookup | =INDEX(Tab1!D:D,7) |
| K | Revenue (Weekly) | =SUM(Tab1!G2:G8) | $168 |
| L | Total Followers | =E+H+J | 215 |
| M | Growth % (WoW) | =F/D | 45% |

### Calculations
- Growth metrics: Absolute + percentage
- Revenue: Sum of daily (Tab 1)
- Followers total: Twitter + Email Free + Email Paid combined

### Rows
- Row 1: Headers
- Rows 2-14: Weekly data (13 weeks = 90 days)

---

## TAB 3: CONVERSION FUNNEL

**Purpose:** Track free → paid conversion rate + cohort behavior

### Structure

**Rows: Acquisition cohorts** (by week)  
**Columns: Metrics**

| Column | Header | Formula | Purpose |
|--------|--------|---------|---------|
| A | Cohort Week | Hardcoded | Week 1, Week 2, etc |
| B | Free Subs Acquired | Lookup | Free subs added that week |
| C | Paid Subs Week 1 | Lookup | Paid subs from this cohort by week 1 |
| D | Paid Subs Week 2 | Lookup | Paid subs from this cohort by week 2 |
| E | Paid Subs Week 3 | Lookup | Paid subs from this cohort by week 3 |
| F | Paid Subs Week 4 | Lookup | Paid subs from this cohort by week 4 |
| G | Conversion Rate (%) | =SUM(C:F)/B | % of cohort converting |

### Example data

```
Cohort | Free Acquired | Wk1 Paid | Wk2 Paid | Wk3 Paid | Wk4 Paid | Conv%
Week 1 |      67       |    3     |    5     |    8     |    12    | 17.9%
Week 2 |      89       |    2     |    6     |    11    |    14    | 15.7%
Week 3 |      112      |    1     |    7     |    15    |    19    | 17.0%
```

### Analysis
- Tracks if conversion rate is stable or improving
- Cohort effects: Do older cohorts convert better? (nurture working)
- Velocity: How fast to paid? (timing of nurture)

---

## TAB 4: CHANNEL BREAKDOWN

**Purpose:** Attribute growth/revenue to source platforms

### Structure

**Rows: Channels**  
**Columns: Metrics**

| Row | Channel | Free Subs | Paid Subs | Affiliate Clicks | Revenue | CAC ($) |
|-----|---------|-----------|-----------|-----------------|---------|---------|
| 1 | Twitter | 12 | 2 | 45 | $16 | $8 |
| 2 | Reddit | 15 | 1 | 28 | $8 | $8 |
| 3 | Medium | 18 | 3 | 32 | $24 | $6 |
| 4 | Seeking Alpha | 8 | 1 | 15 | $8 | $8 |
| 5 | Email | 6 | 3 | 12 | $24 | $2 |
| 6 | Organic/Direct | 8 | 2 | 18 | $16 | $4 |
| **Total** | **67** | **12** | **150** | **$96** | **$5.60** |

### Formulas
- CAC: Revenue per channel ÷ Free subs from channel (customer acquisition cost)
- Revenue attribution: Paid subs from channel × $8
- Conversion rate: Paid subs ÷ Free subs

### Analysis
- Which channels convert best? (prioritize those)
- Which channels acquire cheapest? (scale those)
- Which channels drive affiliate? (secondary revenue)

---

## TAB 5: CHURN TRACKING

**Purpose:** Monitor paid subscriber retention

### Structure

**Rows: Monthly cohorts**  
**Columns: Retention tracking**

| Cohort | Starting Paid | Month 1 | Month 2 | Month 3 | Avg Retention |
|--------|---------------|---------|---------|---------|---|
| Month 1 | 12 | 11 (92%) | 10 (83%) | 9 (75%) | 83% |
| Month 2 | 18 | 16 (89%) | 14 (78%) | — | 84% |
| Month 3 | 24 | 21 (88%) | — | — | 88% |

### Formulas
- Retention rate: Current month subs ÷ Starting month subs
- Average: Mean across all months tracked

### Kill threshold
- **Target:** 85%+ monthly retention
- **Alert:** If month drops below 80% (customer satisfaction issue)
- **Action:** Pause growth, improve content if below 75%

### Interpretation
- Healthy SaaS: 90%+ retention
- Target first-year: 80-85%
- Growth phase acceptable: 75-80% (new audience)

---

## TAB 6: REVENUE PROJECTION

**Purpose:** Forecast 90-day revenue trajectory

### Monthly projections

| Month | Free Subs (Target) | Conversion % | Paid Subs | MRR ($) | Running Total |
|-------|----------|---|---|---|---|
| Month 1 | 200 | 2.5% | 5 | $40 | $40 |
| Month 2 | 500 | 3.5% | 17 | $136 | $176 |
| Month 3 | 1000 | 4.5% | 45 | $360 | $536 |

### Formulas
- Conversion %: Based on historical tracking
- Paid subs: Free subs × Conversion %
- MRR: Paid subs × $8/month
- Running total: Cumulative MRR

### Scenarios (3-case model)

**Case 1: Baseline (conservative)**
- Month 1: 5 paid subs ($40/mo)
- Month 2: 15 paid subs ($120/mo)
- Month 3: 30 paid subs ($240/mo)
- 90-day revenue: $400

**Case 2: Optimistic (20% MoM growth)**
- Month 1: 5 paid subs ($40/mo)
- Month 2: 18 paid subs ($144/mo)
- Month 3: 50 paid subs ($400/mo)
- 90-day revenue: $584

**Case 3: Aggressive (30% MoM growth)**
- Month 1: 5 paid subs ($40/mo)
- Month 2: 22 paid subs ($176/mo)
- Month 3: 65 paid subs ($520/mo)
- 90-day revenue: $736

### Kill threshold
- **Must-hit by Week 4:** 5+ paid subs ($40/mo baseline)
- **Signal at Week 8:** 10+ paid subs ($80/mo, on conservative track)
- **Kill threshold Week 12:** <5 paid subs (stop briefing, pivot)

---

## VISUALIZATION CHARTS (Google Sheets)

### Chart 1: Revenue Growth Projection
**Type:** Line chart  
**Data:** Tab 6, revenue projection  
**X-axis:** Days (0-90)  
**Y-axis:** MRR ($)  
**Series:** Baseline, optimistic, aggressive  
**Update:** Daily (formulas auto-update)

### Chart 2: Subscriber Growth Funnel
**Type:** Stacked bar  
**Data:** Tab 2, weekly data  
**X-axis:** Week  
**Y-axis:** Subscriber count  
**Series:** Free, Paid, Twitter followers  
**Metric:** Weekly growth bars + running total line

### Chart 3: Conversion Funnel (Cohort)
**Type:** Waterfall chart  
**Data:** Tab 3, conversion rates  
**Shows:** Free → Paid progression by cohort  
**Metric:** Identifies best/worst-converting weeks

### Chart 4: Channel Performance
**Type:** Horizontal bar  
**Data:** Tab 4, revenue by channel  
**X-axis:** Revenue ($)  
**Y-axis:** Channel names  
**Metric:** Identifies highest-ROI channels

### Chart 5: Engagement Heatmap
**Type:** Heatmap/scatter  
**Data:** Tab 1, daily metrics  
**Shows:** Opens, clicks, conversions by day  
**Metric:** Identifies best sending times/topics

---

## DATA ENTRY WORKFLOW (Jason)

**Daily (5 minutes):**
1. Open Google Sheets
2. Go to Tab 1 (Daily Snapshot)
3. Add new row with today's date
4. Enter: Twitter followers, Email free, Email paid, Reddit karma, Affiliate clicks
5. Save
6. All other tabs auto-update from formulas

**Weekly (10 minutes):**
1. Review Tab 2 (Weekly roll-up)
2. Verify calculations (growth %, revenue total)
3. Note weekly winner (which channel grew most)

**Monthly (15 minutes):**
1. Review all tabs
2. Check against targets (5+ paid by week 4, etc)
3. Identify issues (low conversion, high churn, weak channels)
4. Note for strategy pivot if needed

---

## BUILD CHECKLIST (For Claude or Jason)

### Sheet setup
- [ ] Create Google Sheets document
- [ ] Rename to "E&D Metrics Dashboard"
- [ ] Create 6 tabs with names above
- [ ] Add headers to each tab

### Tab 1 formulas
- [ ] Column B: Twitter followers (manual entry)
- [ ] Column C: Email free (manual entry)
- [ ] Column D: Email paid (manual entry)
- [ ] Column E: Reddit karma (manual entry)
- [ ] Column F: Affiliate clicks (manual entry)
- [ ] Column G: Revenue formula (=D*8)

### Tab 2 formulas
- [ ] Row formulas linking to Tab 1
- [ ] Growth calculations (=E-D format)
- [ ] Weekly revenue sum formula
- [ ] Total follower calculation

### Tab 3 formulas
- [ ] Cohort tracking setup
- [ ] Conversion rate formulas
- [ ] Retention tracking logic

### Tab 4 formulas
- [ ] Channel attribution by source
- [ ] CAC calculations
- [ ] Revenue attribution by channel

### Tab 5 formulas
- [ ] Monthly retention tracking
- [ ] Churn rate calculations
- [ ] Alert highlights (red if <80%)

### Tab 6 formulas
- [ ] Projection models (3 scenarios)
- [ ] MRR calculations
- [ ] Running total formulas

### Visualizations
- [ ] Chart 1: Revenue projection line chart
- [ ] Chart 2: Subscriber growth stacked bar
- [ ] Chart 3: Conversion funnel waterfall
- [ ] Chart 4: Channel performance bar
- [ ] Chart 5: Engagement heatmap

### Sharing
- [ ] Dashboard shared with Jason (edit access)
- [ ] Dashboard shared with me (view access)
- [ ] Automation: Slack notification when data entered (optional)

---

## KEY METRICS TO MONITOR

**Daily:**
- Twitter followers (growth signal)
- Email subscribers free (growth signal)
- Email subscribers paid (revenue signal)
- Affiliate clicks (secondary revenue)

**Weekly:**
- Free sub growth rate (platform performance)
- Paid sub total (primary metric)
- Weekly revenue (MRR trend)
- Conversion rate (content quality)

**Monthly:**
- Paid sub retention (sustainability)
- CAC by channel (efficiency)
- Revenue by channel (ROI allocation)
- Projection vs. actual (forecast accuracy)

---

## SUCCESS CRITERIA (Week 1 checkpoint - Apr 11)

**Must-hit targets:**
- [ ] 50+ free subscribers
- [ ] 5+ paid subscribers ($40 MRR)
- [ ] 150+ Twitter followers
- [ ] $200+ affiliate revenue

**Nice-to-have targets:**
- [ ] 100+ email subscribers
- [ ] 10+ paid subscribers ($80 MRR)
- [ ] 300+ Twitter followers
- [ ] $400+ affiliate revenue

**Dashboard shows:** All data tracked, no blind spots, decisions made weekly based on data

---

**Status:** Build spec ready for implementation Friday (Jason or Claude)
