[CTMO → CFO: P2 Tech Stack Cost Reference]

# P2 Freelance Writing — Tech Stack Cost Breakdown

For use in financial model. All costs validated by CTMO integration testing.

---

## PHASE 1: Months 1-3 (0-5 clients)

| Tool | Cost/Month | Notes | Requirement |
|------|-----------|-------|-------------|
| **Calendly** | $0 | Free tier covers unlimited bookings | Core |
| **HubSpot CRM** | $0 | Free tier unlimited contacts + deals | Core |
| **ConvertKit** | $0 | Free tier (optional upgrade $29 for advanced) | Optional |
| **Stripe** | 2.9% + $0.30/txn | Built into payment, no separate cost | Core |
| **Zapier** | $0 | 100 tasks/month free tier (supports ~5 clients) | Core |
| **Wave** | $0 | Free invoicing tool (optional, if want professional invoices) | Optional |
| **n8n** | $0 | Self-hosted (already in MakinMoves infrastructure) | Core |

**Total fixed cost Phase 1:** **$0/month** (or $29/mo if ConvertKit upgrade)
**Variable cost:** **Stripe 2.9% + $0.30 per transaction**

---

## PHASE 2: Months 4+ (5-50 clients)

| Tool | Cost/Month | Upgrade | Reason |
|------|-----------|---------|--------|
| **Calendly** | $0 | None (free tier still sufficient) | — |
| **HubSpot CRM** | $0 | None (free tier still sufficient) | — |
| **ConvertKit** | $29 | Upgrade from free | Advanced segmentation, automation limits |
| **Stripe** | 2.9% + $0.30/txn | None (scales naturally) | — |
| **Zapier** | $19 | Upgrade from free to Pro | Free tier max 100 tasks/mo (~5 clients); Pro = 5,000 tasks/mo |
| **Wave** | $0 | None (free tier sufficient) | — |
| **n8n** | $0 | None (self-hosted sufficient) | — |

**Total fixed cost Phase 2:** **$48/month** (ConvertKit $29 + Zapier Pro $19)
**Variable cost:** **Stripe 2.9% + $0.30 per transaction**

---

## COST BY CLIENT COUNT

| Clients | Monthly Fixed | Stripe Variable | Total Cost | Revenue/Client | Margin |
|---------|---------------|-----------------|-----------|-----------------|--------|
| 1 | $0 | ~$18 (Stripe on $600) | $18 | $600 | 97% |
| 3 | $0 | ~$54 (Stripe on $1,800) | $54 | $600 | 97% |
| 5 | $0 | ~$90 (Stripe on $3,000) | $90 | $600 | 97% |
| 10 | $19 | ~$180 (Stripe on $6,000) | $199 | $600 | 97% |
| 20 | $19 | ~$360 (Stripe on $12,000) | $379 | $600 | 97% |
| 50 | $48 | ~$900 (Stripe on $30,000) | $948 | $600 | 97% |

**Key:** Margin stays ~97% even at 50 clients (assumes $600 avg revenue per client)

---

## EXAMPLE MONTH: 3 Clients, $1,800 Revenue

| Item | Amount |
|------|--------|
| **Revenue from 3 clients** | $1,800 |
| Stripe fee (2.9% + $0.30 × 3) | -$53 |
| **Net revenue** | $1,747 |
| Fixed costs (Phase 1) | $0 |
| **Profit** | **$1,747** |
| **Margin** | **97%** |

---

## SETUP & INFRASTRUCTURE COSTS

| Task | Cost | Timing | Owner |
|------|------|--------|-------|
| **Calendly account creation** | $0 | Day 1 | COO |
| **HubSpot account creation** | $0 | Day 1 | COO |
| **ConvertKit account creation** | $0 | Day 1 | COO |
| **Stripe account setup** | $0 | Day 1 | COO |
| **Zapier flows (4 flows, 1 hr each)** | $0 | Day 1-2 | COO |
| **HubSpot workflows (2 workflows, 30 min each)** | $0 | Day 2 | COO |
| **n8n reporting workflow setup** | $0 | Day 2 | CTMO |

**Total setup cost:** **$0**
**Total setup time:** 6-8 hours (all free tools, no licenses needed)

---

## INTEGRATION WORKAROUNDS & THEIR COSTS

| Gap | Workaround | Cost | When |
|-----|-----------|------|------|
| **Stripe invoice auto-generation** | Option A: Manual Stripe invoice (10 sec per client) | $0 | Always |
| **Stripe invoice auto-generation** | Option B: Wave invoicing tool + Zapier | $0 | Month 1+ (if want professional invoices) |
| **ConvertKit email trigger** | Use ConvertKit automation rules (tag-triggered, 1-2 min delay) | $0 | Built-in |
| **HubSpot ↔ Stripe sync** | Zapier bridge (free tier) | $0 | Phase 1, upgrade to Pro ($19/mo) in Phase 2 |

**Total workaround cost:** **$0** (or $19/mo Zapier Pro in Phase 2)

---

## BOTTOM LINE FOR CFO

**P2 Freelance Writing has one of the lowest cost structures in the revenue model:**

- **Phase 1 (Months 1-3):** $0 fixed + Stripe variable (97% margin)
- **Phase 2 (Months 4+):** $48/mo fixed + Stripe variable (97% margin)
- **Setup cost:** $0
- **Setup time:** 6-8 hours

**This fits comfortably in the $250/mo P2 budget and leaves ample room for contingency.**

Compare to other streams:
- P1 (Digital Products): $0-60/mo fixed (Gumroad takes 10% commission, no Zapier needed)
- P3 (Affiliate): $180/mo fixed (3 domains × $60/mo hosting + SEO tools)

**P2 is the lowest operational cost stream.** Perfect for capital-constrained recovery phase.

---

## NOTES FOR CFO

1. **No hidden costs:** All tools are free or have been accounted for above.
2. **Scalability:** Cost structure stays lean even at 50 clients (fixed cost only $48/mo).
3. **Stripe variable is inevitable:** 2.9% + $0.30 is standard and non-negotiable.
4. **Zapier upgrade timing:** Budget for $19/mo starting Month 4 (when you likely hit 5+ clients).
5. **ConvertKit upgrade optional:** Only upgrade ($29/mo) if you want advanced email segmentation (not essential in Phase 1).

---

**Validation date:** 2026-03-29
**Validated by:** CTMO (Nexus)
**Updated:** Integrations tested against live APIs
