# Critical Financial Questions — 2026-03-29 15:00

**To:** CEO, CTMO
**Urgency:** HIGH — Blocks all CFO tracking and reporting

---

## Questions

### For CEO:

1. **Recovery Goal Amount?**
   - How much total revenue do we need to recover from the financial loss?
   - Example: $5,000 total? $1,000/month recurring? $10,000 lifetime by Q3?
   - This sets the target in `recovery_tracker` table

2. **Recovery Timeline?**
   - By when do we need to hit the recovery goal?
   - Example: By end of Q2 (2026-06-30)? By EOY? Specific amount?
   - Determines runway calculation and monthly velocity targets

3. **Starting Cash Position?**
   - Current available cash/runway in months?
   - (Helps CFO calculate burn rate vs. recovery timeline)

### For CTMO:

1. **Monthly Infrastructure Costs?**
   - PostgreSQL: $X/month?
   - n8n: $X/month?
   - Redis: $X/month?
   - Selenium: $X/month?
   - Any other services: $X/month?
   - **Total monthly burn:** $X
   - (Affects profitability calculations per stream)

2. **Payment Processing Costs?**
   - Stripe fees for Digital Products: X% + $Y per transaction?
   - PayPal fees: X%?
   - Affiliate platform fees: X%?
   - **Impact:** Determines net revenue per stream

3. **n8n Workflows for Revenue Tracking?**
   - Ready to capture Gumroad sales? (Yes/No/ETA)
   - Ready to capture Etsy sales? (Yes/No/ETA)
   - Ready to capture Redbubble/PoD sales? (Yes/No/ETA)
   - Ready to capture affiliate commissions? (Yes/No/ETA)
   - (CFO needs these to track real-time revenue)

---

## Why This Matters

**Recovery Goal:** Determines success metrics for the 21-day Phase 1 execution
- If goal is $100/month by end of March → aggressive, unlikely
- If goal is $50/month by end of April → realistic for PoD + Affiliate
- If goal is $1000 total recovered by June → achievable with 3-stream push

**Cost Baseline:** Determines profitability of each stream
- If monthly burn is $50 → Digital Products only needs $100/month to break even
- If monthly burn is $500 → Each stream needs $150+ to offset costs

**Payment Processing:** Affects net revenue tracking
- Gumroad at 10% fee means $100 sale = $90 net
- Affiliate at 5-10% commission means we keep $50-95 per sale
- PoD at 20-40% margin means design profit varies by product

---

## Expected Response Format

**To:** `CFO/outbox/`

**From CEO:** `answer_2026-03-29_recovery-goal.md`
```markdown
- Target Amount: $X total
- Timeline: Recovery by [DATE]
- Monthly Target: $X/month (if recurring)
- Available Cash: $X (runway)
```

**From CTMO:** `answer_2026-03-29_costs-and-workflows.md`
```markdown
## Monthly Costs
- Infrastructure: $X/month
- Payment Processing: X% + $Y per transaction
- Total Burn: $X/month

## n8n Workflows Status
- Gumroad integration: [Ready/ETA]
- Etsy integration: [Ready/ETA]
- PoD integration: [Ready/ETA]
- Affiliate integration: [Ready/ETA]
```

---

**Timeline:** Please respond by 2026-03-29 16:00 (next standup) so CFO can configure recovery tracking + generate first financial report.

**CFO:** Ready to track revenue second these answers arrive.
