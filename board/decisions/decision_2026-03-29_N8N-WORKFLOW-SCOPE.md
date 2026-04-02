# Decision: n8n Workflow Product Scope — Hybrid Approach

**Date:** 2026-03-29 16:20
**From:** Jason (User)
**Decision:** HYBRID (Option C) — 3 Simple + 2 Medium Workflows

---

## APPROVED PRODUCT: "Complete Freelancer Automation Suite"

### Scope
5 workflows packaged as 1 coherent bundle for freelancers/solopreneurs

**Tier 1 (Simple — 1.5 hours build):**
1. **Auto-Generate Invoices from Notion**
   - Trigger: Client/project marked "billable" in Notion
   - Action: Create invoice in Gumroad + add to Invoices database
   - User configures: Notion API key, Gumroad API key
   - Difficulty: Moderate (relations, webhooks)

2. **Email Invoice + Payment Reminder**
   - Trigger: Invoice created (Gumroad) or due date approaching (Notion)
   - Action: Send email via Gmail + log to Notion
   - User configures: Gmail SMTP, email template, reminder schedule
   - Difficulty: Easy (API simple)

3. **Track Payments in Notion**
   - Trigger: Payment received (Gumroad/Stripe webhook)
   - Action: Create entry in Payments Tracker database, mark invoice as paid
   - User configures: Webhook URL, API keys
   - Difficulty: Moderate (webhook routing)

**Tier 2 (Medium — 2.5 hours build):**

4. **Recurring Invoice Scheduler**
   - Trigger: Cron schedule (monthly, weekly, custom)
   - Action: Auto-create new invoice from template, send to client
   - User configures: Invoice template, schedule, client
   - Difficulty: Medium (scheduling logic)

5. **Revenue Dashboard Auto-Update**
   - Trigger: Daily at 8:00 AM
   - Action: Refresh Notion dashboard with MTD revenue, outstanding balance, top clients
   - User configures: Notion formulas, refresh interval
   - Difficulty: Medium (rollup queries, Notion sync)

---

## Product Details

**Package Name:** "Complete Freelancer Automation Suite"

**Contents:**
- 5 n8n workflows (JSON export files)
- Setup guide (PDF + Notion template)
- Video walkthrough (screen recording, 5-7 min)
- FAQ + troubleshooting

**Price Point:** $79-99 (bundle discount vs. $19-29 individual)

**Target:** Freelancers, solopreneurs, small agencies

**Build Timeline:** 4 hours (fits in concurrent execution window)

---

## Delivery Requirements

**CTMO must deliver by March 30 23:59:**
1. ✅ 5 workflows fully functional (tested in n8n)
2. ✅ JSON exports (ready to import)
3. ✅ Setup guide (clear step-by-step)
4. ✅ Sample data (example Notion workspace)
5. ✅ Gumroad listing text + preview image

**Testing checklist:**
- [ ] Each workflow tested end-to-end
- [ ] Error handling documented
- [ ] API credential instructions clear
- [ ] Notion setup matches template spec

---

## Success Metric

**By March 30 23:59:**
- Product live on Gumroad
- n8n workflows accessible
- Automated publishing to platforms configured
- Ready for autonomous sales + support (0 human input)

---

## Approval

✅ **APPROVED** — Jason, 2026-03-29 16:20

CTMO: Scope locked. Build with confidence. No waiting.

COO: Expect CTMO delivery by tomorrow 23:59. Have Gumroad listing ready for this product.

---
