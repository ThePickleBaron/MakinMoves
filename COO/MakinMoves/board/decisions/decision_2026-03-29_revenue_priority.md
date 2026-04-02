# Board Decision — Revenue Stream Priority — 2026-03-29

> **Filed by:** COO (synthesizing CTMO + CFO + Research outputs)
> **Requires:** CEO approval / override
> **Status:** PENDING CEO SIGN-OFF

---

## ⚠️ Critical Infrastructure Note (CTMO Finding)

The Cowork sandbox environment does **not** have Docker running. The documented stack (n8n, PostgreSQL, Redis, Selenium) lives on **Jason's Windows machine** (localhost), not inside this AI session. This means:

- **We cannot directly control or verify** the local Docker services from here
- **We CAN** write scripts, plans, configs, and automation logic that Jason runs locally
- **Recommended pivot:** Lead with zero-infrastructure digital products (Gumroad) that require NO local server — then use the Docker stack for the SaaS build in Week 2

---

## Board-Agreed Recommendation (Pending CEO Confirmation)

### Phase 1: Gumroad Digital Products (Days 1–3)
**Goal:** First dollar in <48 hours. Zero infrastructure required.

| Product | Platform | Price | Est. Week 1 Revenue | Build Time |
|---------|----------|-------|---------------------|------------|
| AI Prompt Pack #1 (niche TBD by CEO) | Gumroad | $19–29 | $200–500 | 12 hrs |
| Notion Template #1 (freelancer or solopreneur) | Gumroad | $29–49 | $100–300 | 16 hrs |
| n8n Workflow Pack (3–5 automations, JSON export) | Gumroad | $39–99 | $150–400 | 8 hrs |
| **TOTAL** | | | **$450–$1,200** | **~36 hrs** |

### Phase 2: AI Meeting Transcription SaaS (Days 7–14)
**Goal:** First recurring revenue. Uses Jason's local Docker stack.
- Claude + n8n + PostgreSQL + Stripe
- $19–49/month subscription
- Target: legal, healthcare, startup niches
- Expected Month 3 MRR: $1,000–$3,000

### Phase 3: Data/API Feed Product (Days 14–21)
**Goal:** Fully automated revenue engine
- n8n workflow scrapes & enriches niche data
- Sell as subscription feed ($29–99/month)
- 9/10 automation score — truly passive

---

## Decisions Required from CEO

| # | Decision | COO Default (if no response in 30 min) |
|---|----------|----------------------------------------|
| 1 | Which niche for AI Prompt Pack? | "AI Prompts for Freelancers" |
| 2 | Which niche for Notion Template? | "Freelancer Invoice + Client Tracker" |
| 3 | Approve Phase 1 Gumroad launch? | COO proceeds with defaults |
| 4 | Approve ~$0 spend (Gumroad is free)? | Yes — proceed |
| 5 | Target recovery amount? | COO models to $3,000/month by Day 60 |
| 6 | Which local n8n workflows exist to package? | Jason to confirm |

---

## Financial Summary (CFO Model)

| Milestone | Conservative | Optimistic |
|-----------|-------------|------------|
| Week 1 revenue | $450 | $1,200 |
| Month 1 net revenue | $235–775 | $1,370–2,730 |
| Month 3 net revenue | $2,020–6,780 | $5,050–10,800 |
| Break-even | Week 1 (Phase 1) | Day 3 |

---

## Next 30-Minute Actions (COO Executing Now)

1. ✅ Board briefing compiled
2. ✅ This decision doc filed
3. → CEO to confirm niche picks above
4. → COO to begin Phase 1 product creation immediately upon CEO confirmation
5. → CFO to open Stripe account and daily revenue log
6. → CTMO to document which n8n workflows exist locally for Phase 1 packaging
