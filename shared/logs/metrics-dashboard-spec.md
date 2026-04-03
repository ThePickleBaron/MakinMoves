# METRICS DASHBOARD SPECIFICATION

**Purpose:** Track revenue, growth, and product-market fit signals  
**Platform:** Google Sheets (template provided below)  
**Review cadence:** Weekly (Fridays) + monthly (Day 30 checkpoint)  
**Owner:** Claude (updates), Jason (reviews)

---

## WEEKLY METRICS (Jason Reviews Every Friday)

**Refresh:** Every Friday end-of-day (UTC)

### Subscriber Metrics

| Metric | Column Name | Data Source | Formula | Target Week 1 |
|--------|------------|-------------|---------|---------------|
| Total free subs | `free_subs_total` | Substack analytics | Manual input (Substack dashboard) | 500 |
| New free subs (week) | `free_subs_new_wk` | Substack analytics | =free_subs_total - previous week | +10–20 |
| Paid subs (briefing) | `paid_subs_brief` | Substack paid tier | Manual input (Substack dashboard) | 5–10 |
| Paid conversions (%) | `paid_conv_pct` | Calculated | =(paid_subs_brief / free_subs_total) × 100 | 1–2% |
| Churn (free) | `churn_free` | Substack analytics | =subs_unsubscribed_this_week / free_subs_prev_week | <0.5% |
| Churn (paid) | `churn_paid` | Substack analytics | =subs_cancelled_this_week / paid_subs_prev_week | <5% |

### Engagement Metrics

| Metric | Column Name | Data Source | Target |
|--------|------------|-------------|--------|
| Briefing open rate (%) | `brief_open_rate` | Substack email analytics | 25–40% (niche = higher) |
| Briefing click rate (%) | `brief_click_rate` | Substack email analytics | 5–15% |
| CTA clicks (paid upgrade) | `cta_clicks_upgrade` | Substack analytics | 2–5 per send |
| Article read time (avg min) | `article_read_time` | Google Analytics | 5–10 min |
| Email list click rate (%) | `email_click_rate` | Email platform (Substack) | 5–10% |

### Lead Magnet Metrics (When Launched, Week 2)

| Metric | Column Name | Data Source | Target |
|--------|------------|-------------|--------|
| Lead magnet downloads | `lm_downloads_wk` | Gumroad / landing page | +20–30/week |
| Lead magnet → email | `lm_email_conv` | Email platform | 80%+ (gated signup) |
| Unsubscribe from LM sequence | `lm_unsub_pct` | Email analytics | <2% |

### Sales Metrics

| Metric | Column Name | Data Source | Formula | Target |
|--------|------------|-------------|---------|--------|
| Briefing paid signups (wk) | `brief_paid_new` | Gumroad / Substack | Manual input | 1–3 per week |
| Template sales (wk) | `template_sales_wk` | Gumroad analytics | Manual input | 0 (week 1), then 2–5/week |
| Refund rate (%) | `refund_rate_pct` | Gumroad | =refunds_wk / sales_wk × 100 | <10% |
| Revenue briefing (wk) | `rev_brief_wk` | =brief_paid_new × $8 | $8–24 | |
| Revenue templates (wk) | `rev_templates_wk` | =template_sales_wk × $29 | $0–145 | |
| **Total weekly revenue** | `rev_total_wk` | =rev_brief_wk + rev_templates_wk | Target: $10–50 |

### Growth Metrics

| Metric | Column Name | Formula | Target (Week 1–4) |
|--------|------------|---------|-------------------|
| Free sub growth (%) | `growth_free_pct_wk` | =(new_subs / free_subs_prev_week) × 100 | 2–3% week 1, then 3–5% |
| Paid sub growth (%) | `growth_paid_pct_wk` | =(new_paid / paid_prev_week) × 100 | N/A week 1 (new stream) |

### Data Entry Template (Google Sheet Rows)

```
Week | Date | Free Total | Free New | Paid Brief | Conv% | Open Rate | Click Rate | Brief Rev | Template Rev | Total Rev | Growth%
W1   | 4/11 | 500 | 12 | 0 | 0% | — | — | $0 | $0 | $0 | 2.4%
W2   | 4/18 | 510 | 10 | 3 | 0.6% | 32% | 8% | $24 | $58 | $82 | 2%
W3   | 4/25 | 525 | 15 | 7 | 1.3% | 35% | 10% | $56 | $87 | $143 | 2.9%
W4   | 5/2 | 550 | 25 | 12 | 2.2% | 38% | 11% | $96 | $145 | $241 | 4.5%
```

---

## MONTHLY METRICS (Jason Reviews Day 30 + Day 60 + Day 90)

### Revenue Summary

| Metric | Calculation | Target Month 1 |
|--------|------------|-----------------|
| **Briefing revenue** | Sum(briefing weekly) | $80–200 |
| **Template revenue** | Sum(templates weekly) | $100–300 |
| **Report revenue** | (Month 1 = 0, month 2+ active) | $0 |
| **Affiliate revenue** | (Pending program activation) | $0–50 |
| **Total MRR** | Sum of above | **$180–550** |

### Growth Metrics

| Metric | Calculation | Target Month 1 |
|--------|------------|-----------------|
| **Free subscriber growth** | End-of-month vs. start | +50–100 (10–20% MoM) |
| **Paid subscriber growth** | End-of-month vs. start | +10–15 |
| **Free to paid conversion rate** | Avg(weekly paid_conv_%) | 1–2% |
| **Template sales (month)** | Sum(weekly sales) | 5–15 |
| **Email list growth rate** | (New subs + new emails) / total | +10–15% |

### Acquisition Metrics

| Metric | Calculation | Target |
|--------|------------|--------|
| **CAC (briefing)** | Total spend / new paid subs | $0 (organic) |
| **CAC (templates)** | Total spend / new template buyers | $0 (organic) |
| **Cost per new free sub** | Total spend / new free subs | $0 (organic only month 1) |
| **LTV (briefing)** | Avg(monthly revenue per sub) × lifetime months | $48–96 (assuming 6–12 month retention) |

### Product Performance

| Product | Units Sold | Revenue | Avg Rating | Refund Rate |
|---------|------------|---------|------------|-------------|
| **Briefing** | 10–15 | $80–120 | N/A (service) | <5% |
| **Templates** | 5–15 | $145–435 | (from Gumroad reviews) | <10% |
| **Reports** | 0 | $0 | N/A | N/A |

### Channel Performance (By Traffic Source)

| Channel | New Free Subs | % of Growth | Quality (retention) |
|---------|--------------|-------------|-------------------|
| **Organic (email / articles)** | +40 | 70% | High |
| **Medium (cross-post)** | +10 | 18% | Medium |
| **Reddit** | +3 | 5% | Medium |
| **Referral (Substack program)** | +2 | 4% | High |
| **Other** | +1 | 2% | — |
| **Total** | +56 | 100% | — |

---

## VISUALIZATION RECOMMENDATIONS

### Charts to Create (Google Sheets)

**1. Revenue Growth Chart (Line)**
- X-axis: Weeks (W1–W12)
- Y-axis: Weekly revenue ($)
- Lines: Total, Briefing, Templates
- Purpose: Visualize revenue trajectory

**2. Subscriber Growth (Area Chart)**
- X-axis: Weeks
- Y-axis: Total subs
- Areas: Free (bottom), Paid (stacked on top)
- Purpose: Show free vs. paid split over time

**3. Conversion Funnel (Bar)**
- Bars: Free subs → Briefing conversions → Template purchases → Retention
- Purpose: Identify where funnel leaks

**4. Channel Performance (Pie)**
- Slices: Organic, Medium, Reddit, Referral, Other
- Purpose: Identify best-performing growth channels

**5. Engagement Heatmap (Table)**
- Rows: Weekly metrics
- Columns: Open rate, click rate, conversion rate
- Color: Red (low), Yellow (moderate), Green (high)
- Purpose: Quick visual of engagement trends

---

## KILL THRESHOLDS (What Triggers Pivot/Shutdown)

### Briefing Kill Signal
- **Metric:** <5 paid subscribers after week 4
- **Action:** Hold (don't kill yet, but don't expand)
- **Pivot:** Lower price to $5, offer annual discount, improve landing page copy

- **Metric:** <10 paid subscribers after week 8
- **Action:** Reassess positioning. Is tone resonating? Is audience engaged?
- **Pivot:** Switch to free briefing + affiliate monetization. Or kill.

### Templates Kill Signal
- **Metric:** <5 sales after 2 weeks of promotion
- **Action:** Hold (collect feedback before killing)
- **Pivot:** Lower price from $29 to $19, improve product copy, add 30-day guarantee

- **Metric:** <10 sales after 4 weeks + poor reviews (<3/5 stars)
- **Action:** Kill product. Reallocate effort to briefing + reports.

### Reports Kill Signal
- **Metric:** <10 sales after 2 weeks
- **Action:** Hold (early signal only)
- **Pivot:** Convert to free tier (lead magnet), monetize via briefing upsell

- **Metric:** <20 sales per report after 2 reports published
- **Action:** Kill subscription model. Make reports free, monetize via affiliate + briefing.

---

## DATA SOURCES + API KEYS

**Substack Analytics**
- URL: activetradertools.substack.com/manage/analytics
- Data: Free subs, paid subs, email open rates, click rates
- Update: Manual (Substack doesn't have API for subscriber counts)

**Google Analytics**
- Property ID: [To be set up by Claude]
- Data: Article traffic, read time, UTM parameters (for channel tracking)
- Update: Automatic (GA refreshes real-time)

**Gumroad**
- Creator account: [exsituinnovations@gumroad.com]
- Data: Sales, refunds, customer reviews
- API: Gumroad offers basic API (limited, mostly manual)

**Google Sheets**
- Template: [Link provided below]
- Sharing: Jason (read + comment)
- Auto-updates: Manual until we can set up automated reporting

---

## TEMPLATE GOOGLE SHEET

**Create this sheet with these tabs:**

### Tab 1: Weekly Metrics (Live tracker)
| Week | Date | Free Total | Free New | Paid Brief | Conv% | Open% | Click% | Brief $ | Template $ | Total $ | Notes |
|------|------|-----------|----------|-----------|-------|-------|--------|---------|-----------|--------|-------|
| W1 | 4/11 | 500 | — | — | — | — | — | — | — | — | Launch week |
| W2 | 4/18 | — | — | — | — | — | — | — | — | — | |

### Tab 2: Monthly Summary
- Month 1, 2, 3 rows
- Total revenue by stream
- Growth metrics
- Channel breakdown

### Tab 3: Product Performance
- Briefing: units, revenue, retention
- Templates: units, revenue, reviews, refunds
- Reports: units, revenue, reviews

### Tab 4: Retention Cohort (Track who stays subscribed)
| Cohort | Joined | Month 1 Retention | Month 2 Retention | Month 3 Retention |
|--------|--------|------------------|------------------|------------------|
| Apr-5 | 2026-04-05 | — | (will track in month 2) | |

### Tab 5: Channel Breakdown
- Week-by-week: Which channels drive most new subs?
- Month-by-month: Organic vs. paid vs. referral

### Tab 6: Formulas Reference
- All formulas documented (copy-paste to avoid errors)
- Descriptions of each metric

---

## WEEKLY CADENCE (Jason)

**Every Friday EOD:**
1. Claude updates metrics sheet (Fri 5 PM)
2. Jason reviews (Fri 6–7 PM)
3. Brief email: "This week: X new subs, Y revenue, Z churn. On track? Comments: [Jason feedback]"

**Key questions Jason answers weekly:**
- Are we on track to hit growth targets?
- Is any metric a red flag?
- Do we need to adjust messaging/positioning?

---

## MONTHLY CADENCE (Jason)

**Day 30, 60, 90 Checkpoint:**
1. Claude generates full monthly report
2. Jason reviews for 30 min
3. Go/hold/kill decisions per product:
   - Briefing: continue? pivot? kill?
   - Templates: continue? pivot? kill?
   - Reports: continue? launch? defer?

---

## SETUP CHECKLIST (Days 5–7)

- [ ] Create Google Sheet template (6 tabs)
- [ ] Share with Jason (view + comment access)
- [ ] Set up Google Analytics property
- [ ] Connect GA to sheet (manual input for week 1, then automate)
- [ ] Document all formulas in "Formulas Reference" tab
- [ ] Create visualization charts (5 charts: revenue, subs, funnel, channels, engagement)
- [ ] Jason reviews template (confirm metrics match his priorities)

---

**Status:** Specification complete. Ready for implementation (Day 5–7).
