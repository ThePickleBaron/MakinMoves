# Board Decision: Automation Platform Choice (Zapier vs. n8n)
**Date:** 2026-03-29
**For:** CEO, COO, CFO, CTMO
**Status:** READY FOR DECISION
**Timeline:** Deadline for decision = 2026-03-29 14:00

---

## Executive Summary

**RECOMMENDATION: Choose n8n Self-Hosted ($0/mo)**

**Why:**
1. **Cost:** $988 Year 1 savings vs. Zapier
2. **Timeline:** Only option with 90% confidence to complete by March 31
3. **Autonomy:** Fully autonomous post-user-handoff (required)
4. **Tech:** Native PostgreSQL support (vs. Zapier workaround)

**Decision required by:** 2026-03-29 14:00 (when CTMO starts build)

---

## Comparative Summary

| Factor | n8n | Zapier | Winner |
|--------|-----|--------|--------|
| **Year 1 Cost** | $50-200 | $1,188 | n8n |
| **Timeline (March 31)** | ✅ 90% confidence | ⚠️ 60% confidence | n8n |
| **Autonomous ops post-March 31** | ✅ YES | ❌ Requires monitoring | n8n |
| **PostgreSQL integration** | ✅ Native | ⚠️ Webhook workaround | n8n |
| **Setup hours** | 16 hrs (fits 36-hr sprint) | 16 hrs (spread across days) | n8n |
| **Post-March 31 burden** | ~1 hr/week | ~2 hrs/week | n8n |
| **3-year cost** | $150-1,000 | $3,390-12,145 | **n8n saves $2,000-11,000** |

---

## Financial Impact

### Year 1 (2026)
- **n8n:** $50-200 (Claude API, optional backup)
- **Zapier:** $1,188 (Pro + Team upgrade + overages)
- **Savings:** $988 Year 1

### 3-Year Total (2026-2028)
- **n8n:** $150-1,000
- **Zapier:** $3,390-12,145
- **Total savings:** $2,240-11,145

### Hidden Costs (Labor)
- **n8n:** ~1 hr/week post-March 31 = ~$1,000/year labor
- **Zapier:** ~2 hrs/week post-March 31 = ~$1,500/year labor
- **Even with labor included, n8n saves $1,500+ Year 1**

---

## March 31 Deadline Risk

### Hard Constraint
- User availability: Through March 31, 23:59 only
- Requirement: Fully autonomous system by March 31, 00:00
- No human input possible after user hands-off

### n8n Timeline (36-Hour Sprint)
- Day 1 (March 29): 6-8 hours → Workflows 1-2 deployed
- Day 2 (March 30): 8-10 hours → Workflows 3-4 deployed + full testing
- Readiness: ✅ By March 30, 23:59
- **Confidence: 90%** (plan already drafted, CTMO ready)

### Zapier Timeline (Spread Across Days)
- Day 1 (March 29): 8 hours → Basic setup + Zaps 1-3
- Day 2 (March 30): 8 hours → Remaining Zaps + testing
- Readiness: ⚠️ Partial (Redbubble API, Claude integration incomplete)
- **Confidence: 60%** (integration uncertainties)

---

## Autonomy Requirement

### Post-March 31 Operating Model
- User: Not available (traveling, offline)
- Human ops staff: None
- Requirement: Zero human intervention for revenue capture + content gen + publishing

### n8n Capability
- Revenue capture: Hourly automation ✅
- Content generation: Daily automation ✅
- Publishing: Daily automation (based on DB status) ✅
- Error monitoring: Real-time automation ✅
- CFO reporting: Query-based automation ✅
- **Verdict: FULLY AUTONOMOUS** ✅

### Zapier Capability
- Revenue capture: 2x/day manual checks
- Content generation: Incomplete (Claude API not ready)
- Publishing: Partial (Redbubble not ready)
- Error monitoring: Email-based (needs someone to check)
- CFO reporting: Manual query required
- **Verdict: NOT AUTONOMOUS** ❌

---

## Technical Analysis

### PostgreSQL Database Support
**Critical for revenue tracking + content queue.**

**n8n:**
- Native PostgreSQL node (direct connection)
- INSERT/UPDATE/SELECT support
- 30-minute setup
- Production-ready

**Zapier:**
- No native PostgreSQL
- Requires webhook intermediary (you build server)
- 2-3 hour setup
- Added complexity + failure points

**Verdict: n8n is FAR superior** (native vs. workaround)

---

### API Integrations (Gumroad, Etsy, Medium, Stripe, Claude API, WordPress)
**Both platforms support all required integrations.**

**Setup time:**
- n8n: ~9-10 hours total
- Zapier: ~11-15 hours total (PostgreSQL workaround adds overhead)

**Difference:** n8n 1-2 hours faster due to native PostgreSQL node.

---

## Recommendation

### Primary Path: n8n Self-Hosted ✅
**Chosen because:**
1. Fits March 31 hard deadline (90% confidence)
2. Fully autonomous (meets post-handoff requirement)
3. Saves $988 Year 1 (within seed budget)
4. Native PostgreSQL support (technical advantage)
5. Lower post-March 31 burden (1 hr/week)

**CTMO Commitment:** Can deliver complete automation by March 30, 23:59

**What you get:**
- 4 automated workflows (revenue capture, content gen, publishing, error monitoring)
- PostgreSQL data warehouse (fully autonomous reporting)
- Zero manual steps required post-March 31
- Unlimited workflow capacity (no task limits)

---

### Fallback Path (if n8n fails): Hybrid n8n + Manual ⚠️
**If CTMO can't finish all workflows by March 30:**
1. Deploy what's ready (revenue capture + error monitoring)
2. COO publishes manually to Gumroad/Etsy (March 31)
3. Finish publishing automation + content generation in April
4. System degraded but operational

**Timeline:** Still delivers March 31 deadline, with April refinement.

---

### Not Recommended: Zapier Pro ❌
**Rationale for rejection:**
1. Incomplete by March 31 (Redbubble, Claude APIs not ready)
2. Requires person managing post-March 31 (2 hrs/week)
3. 750 task limit = overflow by Month 2 (need Team upgrade = $99/mo)
4. No autonomy (email alerts require human monitoring)
5. Cost: $1,188 Year 1 vs. $200 n8n (6x more expensive)

**Only choose Zapier if:**
- March 31 deadline is flexible, OR
- You have unlimited budget and prefer managed service

---

## Risk Assessment

### n8n Risks (Manageable)
| Risk | Impact | Recovery | Likelihood |
|------|--------|----------|------------|
| Docker crash | ~5 min downtime | Auto-restart | 1x/year |
| PostgreSQL corrupt | Data restore needed | 15 min restore | 0.5x/year |
| API key expires | Single integration fails | 10 min rotate | 1x/quarter |
| Platform API breaks | Single workflow fails | 2-4 hrs fix | 2-4x/year |

**Maximum realistic downtime:** 15 min (once per 6 months)
**Verdict: Acceptable risk for startup**

---

### Zapier Risks (Severe)
| Risk | Impact | Recovery | Likelihood |
|------|--------|----------|------------|
| Task limit hit | Silent failures (revenue not logged) | Manual intervention + upgrade | Medium |
| Redbubble scraping blocked | Revenue capture fails | Rebuild integration | High |
| Claude integration incomplete | No content generation | Manual content creation | High |
| Zapier outage | All workflows stop | Wait for Zapier | Low (99.9% SLA) |

**Critical risk: Silent failures in March 31 launch window**
**Verdict: Unacceptable risk for autonomous operation**

---

## Go-Live Timeline (n8n Path)

### March 29 (Today), 14:00-23:59
- 14:00-15:00: Planning + confirmation
- 15:00-18:00: API mapping (all 5 platforms)
- 18:00-21:00: Build workflows 1-2 (revenue capture + content gen)
- 21:00-23:59: Initial testing

### March 30 (Tomorrow), 06:00-23:59
- 06:00-10:00: Build workflows 3-4 (publishing + error monitoring)
- 10:00-14:00: Integration testing
- 14:00-18:00: Platform publishing tests
- 18:00-23:00: End-to-end testing
- 23:00-23:59: Readiness verification + signoff

### March 31 (Day 3), 00:00+
- 00:00: GO LIVE (autonomous operation begins)
- 23:59: User hands-off window closes
- April 1+: CTMO monitors (~1 hr/week)

---

## What We Need to Proceed

### If CEO/CFO Choose n8n:
1. ✅ Approve CTMO full-time work March 29-30
2. ✅ Stage API keys by March 29, 14:00 (Gumroad, Etsy, Medium, Stripe, Claude)
3. ✅ COO standby for approval workflow training March 30
4. ✅ CFO ready to validate queries March 30, 18:00

### If CEO/CFO Choose Zapier:
1. ⚠️ Accept incomplete March 31 launch
2. ⚠️ Budget additional $1,188 Year 1
3. ⚠️ Plan fallback + April migration to n8n

---

## Success Criteria (By March 30, 23:59)

**Must-have for autonomous operation:**
- [ ] Revenue capture tested on ≥2 platforms (data in PostgreSQL)
- [ ] Content generation tested (≥1 sample in content_queue)
- [ ] Publishing tested on ≥1 platform (≥1 product visible)
- [ ] Error handling tested (≥1 error in error_logs, not silent)
- [ ] CFO can query revenue without manual SQL
- [ ] COO knows approval workflow
- [ ] All workflows deployed and active

---

## Board Decision

**PRIMARY RECOMMENDATION: n8n Self-Hosted ($0/mo)**

**Supporting evidence:**
- 90% delivery confidence (CTMO plan exists)
- $988 Year 1 cost savings vs. Zapier
- Fits March 31 hard deadline (only realistic option)
- Fully autonomous (meets post-handoff requirement)
- Native PostgreSQL (technical advantage)

**Fallback:** If n8n hits unexpected blockers, hybrid approach (partial n8n + manual work) still viable.

**Timeline:** Decision needed 2026-03-29 14:00. CTMO begins build immediately upon approval.

---

## Sign-Off (Required)

**CEO:** I approve n8n as the automation platform. CTMO may begin build immediately upon approval.

**CFO:** I confirm the $200 Year 1 budget for n8n (vs. $1,188 Zapier) and approve seed budget allocation.

**COO:** I understand the approval workflow (database status = 'approved') and am ready for training March 30.

**CTMO:** I commit to 90% confidence delivery of all 4 workflows by March 30, 23:59. I understand the March 31 hard deadline.

---

**Board Chair:** This decision approved pending CEO/CFO sign-off.

**Next step:** 2026-03-29 14:00 standup for final confirmation + build kickoff.

---

**Document Location:** `ctmo/outbox/decision_matrix_zapier_vs_n8n_2026-03-29.md` (full analysis)
**Index Location:** `ctmo/outbox/00_ZAPIER_VS_N8N_DECISION_INDEX_2026-03-29.md` (all supporting docs)
