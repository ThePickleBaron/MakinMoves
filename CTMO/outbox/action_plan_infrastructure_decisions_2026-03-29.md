# CTMO Action Plan: Infrastructure Decisions
**To:** CEO, COO, CFO
**From:** CTMO (Technology)
**Date:** 2026-03-29
**Priority:** HIGH — Blocks Month 1 execution if not decided

---

## Summary

Infrastructure audit reveals **ONE blocking issue** and **TWO upgrade decisions** needed before Month 1 execution:

1. **BLOCKER: Zapier 100-task limit exhausts in 1-2 weeks** → Must decide n8n vs paid Zapier TODAY
2. **Bluehost traffic degradation at 25k-50k/mo** → Upgrade trigger decision needed (affects Month 3-4)
3. **HubSpot, ConvertKit, PostgreSQL:** No issues through Month 6

---

## DECISION 1: ZAPIER VS N8N (URGENT — Decide Today)

### The Problem
Zapier free tier: 100 tasks/month. Real usage: 50-180 tasks/week. **Exhausted in 1-2 weeks.**

### Option A: Upgrade to Zapier Professional
- **Cost:** $29.99/mo ($360/year)
- **Capacity:** 750 tasks/month (might still be tight)
- **Upside:** Proven integrations, good UX, support
- **Downside:** Cost, ongoing dependency, feature lock-in

### Option B: Switch to n8n (Self-Hosted in Docker)
- **Cost:** $0 (free, already in our Docker stack)
- **Capacity:** Unlimited workflows
- **Upside:** Free, unlimited, full control, no vendor lock-in
- **Downside:** Setup time, less polished UX than Zapier, more DIY

### Recommendation
**Switch to n8n.** Saves $360/year, aligns with our containerized infrastructure, and eliminates workflow limits. We're not Zapier-dependent; we can build equivalent automations in n8n.

**Timeline:**
- **Today:** Decide this (CEO approval needed)
- **Tomorrow:** Build n8n workflows for critical P2 client automations (4-6 hours CTMO)
- **By Month 1:** n8n fully operational, Zapier removed from budget

**CFO Action:** Remove $29.99/mo Zapier from cost projections; add 4 hours CTMO time to Month 1 roadmap.

---

## DECISION 2: BLUEHOST VPS UPGRADE TRIGGER (Plan Now, Execute Later)

### The Problem
Bluehost shared hosting throttles at 25k-50k combined monthly visitors. Our projection: 15-30k by Month 3. Decision: When do we upgrade?

### Options

**Option A: Conservative (Upgrade at 25k traffic)**
- Trigger: Any stream exceeds 12k/mo OR combined > 25k/mo
- Timeline: Likely Month 3
- Cost impact: +$30-50/mo (earlier)
- Upside: Headroom, no degradation
- Downside: Premature upgrade cost

**Option B: Moderate (Upgrade at 40k traffic)**
- Trigger: Combined traffic reaches 40k/mo
- Timeline: Likely Month 4
- Cost impact: +$30-50/mo (slightly later)
- Upside: Longer on shared hosting (cheaper), avoid premature upgrade
- Downside: Risk of degradation Month 3-4 if traffic spikes

**Option C: Aggressive (Upgrade at 50k+ traffic)**
- Trigger: Combined traffic exceeds 50k/mo OR single site > 20k/mo
- Timeline: Month 4-5
- Cost impact: +$30-50/mo (latest possible)
- Upside: Maximum cost savings
- Downside: Risk of user complaints if shared hosting throttles

### Recommendation
**Option B (Moderate): Upgrade trigger at 40k combined/mo.**

- Balances cost savings ($30-50/mo saved for 1-2 months) against performance risk
- Aligns with realistic Month 4 traffic projections
- Allows M1-3 growth without premature cost
- Build monitoring now to track when trigger is hit

**CTMO Immediate Actions:**
1. Set up traffic monitoring alerts for each Bluehost site
2. Create escalation checklist: "Traffic Hit 30k? Prepare VPS quote. Hit 40k? Execute upgrade."
3. Get Bluehost VPS quote by Month 2 (lead time for setup)

**CFO Action:** Budget $30-50/mo VPS upgrade starting Month 4 (not Month 1).

---

## DECISION 3: POSTGRES & DATABASE SCALING

### Finding
PostgreSQL is NOT a constraint. Self-hosted Docker handles our projected load trivially (10k-50k transactions/month vs. millions capable).

### Recommendation
**No action needed through Month 6.**

- Keep self-hosted PostgreSQL in Docker ($0/mo cost)
- Monitor transaction volume; upgrade only if hitting 500k+/month (unlikely)
- Don't buy Railway/RDS/Supabase unless hitting real performance issues

**CFO Action:** No database cost until Month 7+.

---

## DECISION 4: HUBSPOT, CONVERTKIT — NO ACTION NEEDED

### HubSpot CRM
- Limit: 1,000 contacts (new accounts post-Sept 2024)
- Our need: 50-150 P2 contacts
- Status: **SAFE through Month 12+**
- Action: None

### ConvertKit (Kit)
- Limit: 10,000 subscribers free tier
- Our need: 50-200 by Month 3, up to 1,000+ by Month 6
- Status: **SAFE through Month 6+**
- Action: Monitor. Upgrade to Creator ($39/mo) only if approaching 8k+ subscribers (unlikely)

---

## REVISED INFRASTRUCTURE BUDGET

**Month 1 (With Decisions Applied):**
- Bluehost: $2-5/mo
- Zapier: $0 (switching to n8n)
- PostgreSQL: $0 (self-hosted)
- HubSpot: $0
- ConvertKit: $0
- **Total: $2-5/mo**

**Month 4+ (If Traffic Threshold Hit):**
- Bluehost VPS: +$30-50/mo
- **New Total: $32-55/mo**

**Savings vs. Original Plan:** $29.99/mo Zapier removed = $360/year saved.

---

## IMMEDIATE CTMO TASKS (This Week)

### TODAY
- [ ] Confirm n8n decision with CEO (Zapier vs n8n)
- [ ] Audit current Zapier usage (if any workflows exist)
- [ ] Identify critical automations to rebuild in n8n

### TOMORROW (Month 1 Kickoff)
- [ ] Build n8n replacement workflows (4-6 hours)
- [ ] Test n8n integrations (HubSpot, email, Slack, etc.)
- [ ] Document n8n setup in technical docs

### WEEK 2
- [ ] Set up Bluehost traffic monitoring (alerts at 12k, 25k, 30k, 40k/mo)
- [ ] Create VPS upgrade playbook (steps to execute when trigger hit)
- [ ] Brief COO on traffic thresholds and monitoring

### ONGOING (M1-6)
- [ ] Monitor all platform usage vs. limits
- [ ] Alert CFO when upgrade triggers are approaching
- [ ] Document any unexpected scaling issues

---

## OPEN QUESTIONS FOR BOARD

1. **Zapier Decision:** Confirmed to switch to n8n? (CEO sign-off needed)
2. **Bluehost Trigger:** Confirm 40k/mo is acceptable upgrade threshold? (Risk tolerance check)
3. **PostgreSQL:** Any special transaction volume expected that we haven't projected? (COO input)
4. **Timeline:** Does this delay Month 1 execution, or can n8n be built in parallel? (COO coordination)

---

## Risk Summary

| Risk | Probability | Impact | Mitigation |
|------|-----------|--------|-----------|
| Zapier free tier exhausted Week 1 | **HIGH** | Automation blocks | Switch to n8n immediately |
| Bluehost shared hosting throttles at 30k/mo | Medium | Performance degradation | Monitor and upgrade at 40k trigger |
| PostgreSQL transaction overload | LOW | Database slowdown | Self-hosted fine; monitor only |
| HubSpot contact limit | LOW | No action; limit too high | No mitigation needed |
| ConvertKit subscriber limit | LOW | No action; free tier generous | No mitigation needed |

---

## Approval & Sign-Off

- [ ] CEO: Approve Zapier → n8n decision
- [ ] CEO: Approve Bluehost 40k/mo upgrade trigger
- [ ] CFO: Confirm revised budget ($0 Zapier vs $360/year saved)
- [ ] COO: Confirm n8n timeline doesn't block Month 1 execution

---

**CTMO Ready to proceed upon approval.**

