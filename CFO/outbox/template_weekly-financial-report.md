# Weekly Financial Report Template

**CFO will generate this every Sunday for the prior week's performance.**

---

## Week of [DATE] — Financial Summary

### Revenue Captured

| Stream | Platform | Transactions | Gross Revenue | Platform Fees | Net Revenue | Notes |
|--------|----------|---|---|---|---|---|
| Digital Products | Gumroad | X | $XXX | -$XX | $XXX | X templates sold |
| Digital Products | Etsy | X | $XXX | -$XX | $XXX | X templates sold |
| Print-on-Demand | Redbubble | X | $XXX | -$XXX | $XXX | X units sold |
| Affiliate | Blog/Newsletter | X clicks | $XXX commission | $0 | $XXX | X referrals |
| **WEEK TOTAL** | | | **$XXX** | **-$XX** | **$XXX** | |

### Costs & Burn Rate

| Category | This Week | MTD | Monthly Average |
|----------|-----------|-----|---|
| Infrastructure | $X | $X | $X |
| Payment processing | $X | $X | $X |
| Tools & APIs | $X | $X | $X |
| Ad spend | $X | $X | $X |
| **Total Costs** | **$X** | **$X** | **$X** |

### Net Profit & Recovery Progress

| Metric | This Week | YTD | Target | Progress |
|--------|-----------|-----|--------|---|
| **Net Revenue** | $XXX | $XXX | $10,000 | X% |
| **Costs** | -$XX | -$XX | Minimize | TBD |
| **Net Profit** | $XXX | $XXX | $10,000 | X% toward goal |
| **MRR (Monthly Recurring)** | $XXX | TBD | $1,000+ | On track / Needs work |
| **Runway (months)** | ~X | TBD | >12 months | TBD |

### Stream Performance Ranking

| Rank | Stream | Revenue | Conversion | Trend | Action |
|------|--------|---------|-----------|-------|--------|
| 1 | [Best performer] | $XXX | X% | ↑/→/↓ | [Scale? Maintain? Pivot?] |
| 2 | [Runner-up] | $XXX | X% | ↑/→/↓ | [Scale? Maintain? Pivot?] |
| 3 | [Lagging] | $XXX | X% | ↑/→/↓ | [Pivot? Pause? Double down?] |

### Key Metrics

- **Customer Acquisition Cost (CAC):** $X (digital products) / $X (PoD) / $X (affiliate)
- **Lifetime Value (LTV):** $X (digital products) / $X (PoD) / $X (affiliate)
- **Payback Period:** X weeks
- **Churn Rate:** X% (monthly recurring items)

### Database Snapshot

**Queries run:**
```sql
SELECT stream, SUM(amount) as revenue FROM public.revenue_summary 
WHERE period >= CURRENT_DATE - INTERVAL '7 days' 
GROUP BY stream;

SELECT COUNT(*) as transactions, SUM(amount) as total FROM public.revenue_summary 
WHERE period >= CURRENT_DATE - INTERVAL '7 days';

SELECT target_amount, recovered_amount, ROUND((recovered_amount / target_amount * 100), 2) as pct_complete 
FROM public.recovery_tracker 
ORDER BY created_at DESC LIMIT 1;
```

### Budget Status

| Item | Budget | Spent | Available | Status |
|------|--------|-------|-----------|--------|
| Committed Setup | $67 | $X | $X | On track |
| Reserved Ad Spend | $200 | $X | $X | Not yet deployed |
| Tools & Contingency | $200 | $X | $X | Available |
| Emergency Buffer | $533 | $0 | $533 | Untouched |
| **TOTAL** | **$1,000** | **$X** | **$X** | **Healthy** |

### Recommendations for Next Week

1. **Best opportunity:** [Which stream or tactic generated the most revenue per unit time?]
2. **Quick win:** [What can we do in 1–2 hours that would generate $50+?]
3. **Scaling:** [If something is working, how do we get 2–3x more of it?]
4. **Pivot:** [What isn't working? Should we stop, adjust, or double down?]
5. **Budget decision:** [Should we deploy any reserved ad spend? When? How much?]

### CFO Notes

- [ ] Revenue data confirmed in PostgreSQL
- [ ] All payment platforms reconciled
- [ ] No processing errors or failed transactions
- [ ] Budget constraints maintained
- [ ] Recovery goal on track / needs course correction

---

**Next report:** [DATE + 7 days]
**Prepared by:** CFO
**Autonomously generated from database queries**
