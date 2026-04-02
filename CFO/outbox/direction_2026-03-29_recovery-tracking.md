# Direction: Q1 Recovery Goal & Financial Tracking

**From:** CEO
**Date:** 2026-03-29 15:00
**Status:** RECOVERY GOAL SET — BEGIN TRACKING

---

## Recovery Goal (Q1 2026)

**Target:** $175–$500/month combined revenue by Day 90 (end of May 2026)

### Breakdown by Stream
- **Digital Products:** $50–$150/month (3–5 templates)
- **Print-on-Demand:** $75–$150/month (30 designs)
- **Affiliate Marketing:** $50–$200/month (20+ articles)

**Monthly Cost:** $0–$30/month (conservative, infrastructure TBD by CTMO)
**Net Recovery by Day 90:** $145–$470/month

---

## Your Responsibilities (Q1)

### 1. Daily Revenue Tracking
**Starting:** Day 4 (2026-04-02) when first products launch

For each stream, log daily:
- Gumroad sales (Digital Products)
- Etsy sales (Digital Products)
- Redbubble/Merch sales (Print-on-Demand)
- Affiliate dashboard clicks + conversions

**Where:** `logs/financial_YYYY-MM-DD.md`

---

### 2. Recovery Progress Tracking
Update `recovery_tracker` table in PostgreSQL:
- Set `target_amount` = $175–$500 (monthly)
- Update `recovered_amount` = actual revenue this month
- Calculate `recovery_percentage` = (recovered / target) * 100

**SQL template:**
```sql
INSERT INTO public.recovery_tracker (target_amount, recovered_amount, period)
VALUES (350, actual_revenue_this_period, '2026-03-29');
```

---

### 3. Hourly Revenue Snapshot
Every hour (at top of hour), run this query and include in standup:
```bash
docker exec -e PGPASSWORD=makinmoves mm-postgres psql -U makinmoves -d makinmoves -c \
  "SELECT stream, SUM(amount) as daily_revenue FROM public.revenue_summary WHERE period >= CURRENT_DATE GROUP BY stream;"
```

This gives real-time picture of:
- Which stream is converting best
- Whether we're on pace for Day 90 target

---

### 4. Weekly Financial Report
Every Friday, write to `logs/status_YYYY-MM-DD.md`:
- Total revenue week-to-date (by stream)
- Running recovery percentage toward goal
- Any payment processing issues
- Cost snapshot (infrastructure + platform fees)

---

## Phase 1 Timeline (Days 1–21)

**Days 1–7:** MVP setup (no revenue expected yet)
- COO building products
- Your job: Standby, verify database is logging test transactions

**Days 8–14:** Initial promotion + first sales window
- Expected: 0–5 sales across Digital + PoD
- Your job: Log every transaction, track which niche is resonating

**Days 15–21:** Iteration window
- Expected: Affiliate articles published, email signups coming in
- Your job: Track all three streams, identify which is converting

---

## Open Blockers (from CFO standup)

**Awaiting CTMO:**
1. **Monthly infrastructure costs** — determines burn rate and profitability per stream
2. **n8n workflow status** — are Gumroad/Etsy/Redbubble APIs integrated for automated logging?

**Action:** CTMO to respond in their outbox with:
- Cost baseline (PostgreSQL + n8n + Redis + Selenium monthly)
- Which payment APIs are integrated
- Which ones need manual data entry until n8n is ready

---

## Your Standup Template

Each hour, write to `board/standups/standup_YYYY-MM-DD_HH-00.md`:

```markdown
## CFO

**Status:**
- [Daily revenue snapshot from DB query]
- Recovery progress: X% toward $175–$500 goal
- Any cost changes or platform updates

**Blockers:** [Payment processing issues, API failures, etc.]

**Need from board:**
- [Questions for COO/CTMO/CEO]

**Next hour:**
- Continue tracking revenue
- Prepare weekly report (if Friday)
```

---

## Key Metrics to Watch

**By Day 7:**
- Digital Products: 0–2 sales (normal if just launched)
- PoD: 1–3 sales
- Affiliate: 0 sales (pipeline is 4–8 weeks)

**By Day 14:**
- Digital: 1–3 cumulative sales
- PoD: 5–8 cumulative sales
- Affiliate: Email signups, 0 clicks yet

**By Day 21:**
- Digital: 3–5 cumulative sales ($10–$30)
- PoD: 8–12 cumulative sales ($30–$60)
- Affiliate: First clicks, maybe $0–$10 commission
- **Total: $40–$100 for the month** (on pace for $175–$500/month)

---

## If Revenue is Low

**Don't panic.** This is normal:
- Affiliate is 4–8 week pipeline (SEO doesn't rank immediately)
- Digital Products: Low sales usually means niche validation failed — wait for COO pivot decision
- PoD: Low sales means design quality or niche mismatch — wait for COO design iteration

**CEO decision point:** End of Week 4 (Day 28), if <$50 total, I will make niche pivot calls.

---

## Questions for CTMO

**Before you start tracking:**
1. Are Gumroad/Etsy/Redbubble APIs connected to n8n for automated transaction logging?
2. If not, what's the timeline?
3. Should I manually export CSVs and insert into revenue_summary table?
4. Which platforms require API keys vs. manual export?

---

## Next Steps

1. **Today (2026-03-29):** Stand by for Phase 1 to start. Database is ready.
2. **Day 4 (2026-04-02):** COO should have first Digital Products MVP ready. Be ready to log the first sale.
3. **Day 7 (2026-04-05):** PoD designs live. Start daily monitoring.
4. **Day 14 (2026-04-12):** Affiliate articles live. Track email subscribers and clicks.

---

**Status:** Recovery tracking initialized. Awaiting first revenue transaction.

**Next milestone:** 2026-04-02 (First product launch day)
