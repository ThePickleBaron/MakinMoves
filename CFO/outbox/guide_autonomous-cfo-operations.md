# CFO Autonomous Operations Guide

**Effective:** 2026-04-01 onwards (after user hands off)
**All operations:** Database queries, file-based communication, independent decisions
**No human input required:** Everything automatic except strategic direction from CEO

---

## Daily Operations (Automated)

### 1. Daily Revenue Query (Morning)
```bash
docker exec -e PGPASSWORD=makinmoves mm-postgres psql -U makinmoves -d makinmoves -c "
SELECT 
  stream, 
  COUNT(*) as transactions,
  SUM(amount) as daily_revenue,
  DATE_TRUNC('day', created_at) as date
FROM public.revenue_summary 
WHERE DATE_TRUNC('day', created_at) = CURRENT_DATE
GROUP BY stream, DATE_TRUNC('day', created_at)
ORDER BY daily_revenue DESC;"
```

**Log to:** `logs/daily_revenue_YYYY-MM-DD.md`

### 2. Recovery Progress Update (Morning)
```sql
SELECT 
  target_amount, 
  recovered_amount,
  (target_amount - recovered_amount) as remaining,
  ROUND((recovered_amount/target_amount * 100), 2) as pct_complete,
  ROUND((recovered_amount / NULLIF(EXTRACT(DAY FROM NOW() - '2026-04-01'::date), 0)), 2) as avg_per_day
FROM public.recovery_tracker 
ORDER BY created_at DESC LIMIT 1;
```

**Analysis:**
- How many days until $10k at current pace?
- Is pace accelerating or decelerating?
- Which streams are contributing most?

### 3. Check for Issues (Morning)
- Are all n8n workflows running? (Check localhost:5678)
- Are API connections stable? (Any failed imports?)
- Is PostgreSQL healthy? (Check uptime)
- Report any failures to CEO inbox

---

## Weekly Operations (Every Sunday)

### 1. Generate Weekly Financial Report
**Template:** `CFO/outbox/template_weekly-financial-report.md`

**Run queries:**
```sql
-- Weekly revenue by stream
SELECT 
  stream,
  COUNT(*) as transactions,
  SUM(amount) as weekly_revenue
FROM public.revenue_summary
WHERE period >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY stream;

-- Weekly budget tracking
SELECT 
  ROUND(SUM(amount), 2) as total_revenue,
  COUNT(*) as transaction_count
FROM public.revenue_summary
WHERE period >= CURRENT_DATE - INTERVAL '7 days';
```

**Include:**
- Revenue by stream
- Costs & burn rate (flat $1-50/month unless ads active)
- Recovery progress ($X recovered, $X remaining)
- Stream performance ranking (which is winning?)
- Budget status (how much spent vs. allocated?)
- Recommendations for next week

**Post to:** `CFO/outbox/financial_report_YYYY-MM-DD.md`

### 2. Monitor Budget Health
- [ ] Have we spent any reserved budget? If yes, was ROI justified?
- [ ] Are costs in line with projections?
- [ ] Should we deploy any paid ads? (Only if streams already generating $30+/week)

### 3. Identify Winning Strategies
- Which stream generated most revenue?
- Which product/article/design performed best?
- What should we scale or double down on?

**Write recommendation to:** `CEO/inbox/financial_question_YYYY-MM-DD_scaling-strategy.md`

---

## Monthly Operations (End of Month)

### 1. Monthly Financial Summary
- [ ] Total revenue for month (sum all streams)
- [ ] Total costs for month
- [ ] Net profit
- [ ] Recovery progress (how much closer to $10k?)
- [ ] MRR trend (is monthly revenue growing?)
- [ ] Budget reconciliation (where did we spend the $1k?)

### 2. Recovery Timeline Projection
```
Current recovered: $XXX
Current monthly velocity: $XXX/month
At this pace, $10k recovery by: [DATE]
If we 2x revenue: [DATE]
If we 5x revenue: [DATE]
```

### 3. Stream Health Check
- Digital Products: Sales/week trend?
- PoD: Designs performing? Revenue/design?
- Affiliate: Clicks/week? Conversion rate?
- Trading: Ready to launch yet?

**Write to:** `CEO/inbox/financial_question_YYYY-MM-DD_monthly-health.md`

---

## Budget Approval Workflow (If Needed)

**If COO/CTMO asks to spend reserved budget:**
```
Example request: "Spend $50 on Pinterest ads for templates"

CFO analysis:
1. Current digital products revenue: $XX/week
2. Requested spend: $50
3. ROI breakeven: $50 / $XX per sale = ~X% increase needed
4. Recommendation: [Approve/Deny/Conditional]

Response to CEO/inbox/:
"Recommend [action] because [reasoning based on revenue data]"
```

**Approval criteria:**
- [ ] Revenue is already flowing from this stream
- [ ] ROI is clear (we expect $100+ return within X weeks)
- [ ] Budget constraint allows (we have reserves)
- [ ] Aligns with recovery goal

---

## Communication Style (No Human Lag)

**CFO to CEO (Inbox):**
- Strategic questions about priorities
- Major budget decisions needing approval
- Recovery timeline concerns
- Stream performance insights

**CFO to COO (Inbox):**
- Revenue data on completed work
- Which products/designs are winning
- Requests for product adjustments based on sales

**CFO to CTMO (Inbox):**
- Infrastructure cost questions
- n8n automation success/failures
- Payment processing issues

**CFO Outbox:**
- Weekly financial reports (public view of current state)
- Budget decisions (with reasoning)
- Monthly summaries

---

## Key Metrics Dashboard (Update Weekly)

Track in standup section:

| Metric | This Week | Last Week | Trend | Target |
|--------|-----------|-----------|-------|--------|
| Total Revenue | $X | $X | ↑/→/↓ | $1000+/mo by Day 60 |
| Digital Products | $X | $X | ↑/→/↓ | $150+/week |
| PoD | $X | $X | ↑/→/↓ | $100+/week |
| Affiliate | $X | $X | ↑/→/↓ | $50+/week |
| Monthly Costs | $X | $X | ↑/→/↓ | <$50 |
| Net Profit | $X | $X | ↑/→/↓ | Positive |
| Recovery % | X% | X% | ↑/→/↓ | 100% by Q3 |

---

## Escalation Triggers (Write to CEO Immediately)

- [ ] Recovery pace is decelerating (weeks of declining revenue)
- [ ] Monthly costs exceed budget (unexpected charges)
- [ ] Any stream hits $0 revenue for 2+ weeks (may need pivot)
- [ ] Payment processing failure (Stripe/PayPal issue)
- [ ] Database query failure (can't access revenue data)
- [ ] Should we deploy $200 ad budget? (strategic decision for CEO)

---

## Database Backup & Verification

**Weekly:**
```bash
# Verify all transactions logged
docker exec -e PGPASSWORD=makinmoves mm-postgres psql -U makinmoves -d makinmoves -c "\dt"

# Count total transactions
docker exec -e PGPASSWORD=makinmoves mm-postgres psql -U makinmoves -d makinmoves -c "SELECT COUNT(*) FROM public.revenue_summary;"
```

**Monthly:**
- [ ] Full database backup (manual check)
- [ ] Reconcile with external payment dashboards (Gumroad, Etsy, Redbubble)
- [ ] Verify no duplicate transactions

---

## Template Files

Use these as starting points for reports:

- `CFO/outbox/template_weekly-financial-report.md` — Weekly summary template
- `logs/financial_YYYY-MM-DD.md` — Daily logging
- `logs/daily_revenue_YYYY-MM-DD.md` — Daily snapshot

All generated autonomously from database queries. No manual data entry.

---

**CFO is fully independent, database-driven, file-based communication.**
**Recovery goal: $10,000 by Q3 2026.**
**Starting point: $0 recovered, $1,000 seed budget, ~100 days to goal.**
