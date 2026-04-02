# Zapier vs. n8n: Executive Summary (2 min read)

**Date:** 2026-03-29
**Status:** DECISION READY FOR CEO/CFO
**Deadline:** March 31, 2026 (36 hours)

---

## The Choice

**RECOMMENDATION: n8n Self-Hosted** ($0/mo)

**IF you want managed service instead: Zapier Team** ($99/mo)

---

## Why n8n Wins

| Factor | Score |
|--------|-------|
| **Cost Year 1** | n8n: $50-200 vs. Zapier: $390-1,225 | **HUGE WIN** |
| **Setup by March 31** | n8n: ✅ Ready | Zapier: ⚠️ Partial |
| **Autonomous (no human needed after March 31)** | n8n: ✅ YES | Zapier: ❌ NO |
| **Scaling cost as revenue grows** | n8n: Stays $0 | Zapier: Explodes to $650+/mo |
| **Already running** | n8n: ✅ Docker deployed | Zapier: Starting from zero |

---

## Quick Numbers

### n8n Self-Hosted
- **Setup time:** 16 hours (fits 36-hour sprint)
- **Monthly cost:** $0 (just Claude API: $0-20/mo)
- **Year 1 cost:** $50-200
- **Post-March 31 work:** ~1 hour/month monitoring
- **Task limits:** UNLIMITED
- **Failure recovery:** 5-15 minutes (self-hosted)
- **Ready by March 31:** ✅ YES

### Zapier Pro ($29.99/mo)
- **Setup time:** 16 hours (spread over days, risky timeline)
- **Monthly cost:** $29.99 + task overages
- **Must upgrade to Team ($99/mo) by Month 2** due to volume
- **Year 1 cost:** $390-1,225 (not $30)
- **Post-March 31 work:** ~2 hours/month monitoring
- **Task limits:** 750/month (you'll hit this in 10 days)
- **Ready by March 31:** ⚠️ PARTIAL (Redbubble/Claude APIs incomplete)

---

## The Real Cost Comparison

**Don't trust "$29.99/mo" marketing.**

Your estimated usage (autonomous, 3 revenue platforms + content gen + publishing):

| Operation | Tasks/Month | Cost Impact |
|-----------|------------|------------|
| Revenue capture (Gumroad, Etsy, Medium): 2x/day | 1,800 tasks | **OVER Pro limit (750)** |
| Content generation: daily | 30 tasks | OK |
| Publishing: 20 items/month × 3 platforms | 600 tasks | OK |
| **TOTAL** | **~2,430 tasks/month** | **Requires Zapier Team** |

**Real Year 1 cost: $99/mo (Team) not $29.99/mo (Pro)** = $1,188/year

**n8n Year 1 cost: $0/mo** = $0/year

**n8n saves $1,188 Year 1. And scales for free.**

---

## Decision Tree (Pick Your Priority)

### Priority 1: Hit March 31 Deadline
**Choose:** n8n
- Only option with 36-hour sprint planned + proven
- Zapier timeline is risky (integrations incomplete)

### Priority 2: Minimize Cost
**Choose:** n8n
- n8n: $50-200/year
- Zapier: $1,188-1,500/year
- Savings: $1,000+/year

### Priority 3: Hands-Off Autonomy (After User Leaves)
**Choose:** n8n
- n8n: Fully autonomous, no monitoring needed (except health checks)
- Zapier: Requires someone checking Zapier dashboard weekly

### Priority 4: Managed Service (Don't Want to Touch Infrastructure)
**Choose:** Zapier Team
- Cost: Accept $1,200+/year for "set it and forget it"
- Trade-off: Higher cost, external dependency, need weekly monitoring

---

## What Each Option Actually Gives You

### n8n Self-Hosted
What you get:
- 4 automated workflows (revenue capture, content gen, publishing, error monitoring)
- Unlimited workflow executions (no task limits)
- Full control over data (PostgreSQL self-hosted)
- Autonomous operation post-March 31

What you give up:
- Vendor support (you debug if something breaks)
- Managed backups (you ensure PostgreSQL backups work)
- SLA guarantee (your internet = your uptime)

---

### Zapier Team
What you get:
- Managed service (Zapier supports Zaps)
- Simpler setup (no Docker to manage)
- SLA guarantee (99.9% uptime)

What you give up:
- Cost ($1,200+/year vs. $0)
- Autonomy (need weekly monitoring)
- Control (can't customize deeply)
- Scalability (costs explode at volume)

---

## The Unspoken Risks

### n8n Self-Hosted Risks
1. **Docker crash:** Takes 5 min to restart. Impact: ~5 min of lost data
2. **PostgreSQL corruption:** Restore from backup in 15 min
3. **API key expiration:** Rotate in 10 min
4. **Redbubble scraping blocked:** Manual workaround in 2-4 hours

### Zapier Pro Risks
1. **Task limit hit:** Silent workflow failures, no revenue logged
2. **Redbubble integration incomplete:** Scraping method not proven
3. **Content generation incomplete:** Claude API custom code needed
4. **No error logging:** Failures only visible in Zapier email alerts
5. **Dependent on Zapier uptime:** If Zapier down, all automation stops

---

## Post-March 31 Operations

### With n8n
**CTMO's weekly checklist:**
- [ ] `docker ps` — make sure containers running (2 min)
- [ ] Check error_logs table for critical errors (5 min)
- [ ] Monitor PostgreSQL disk usage (2 min)

**Total: ~10 min/week.** That's it. No active management needed.

### With Zapier
**CTMO's weekly checklist:**
- [ ] Check Zapier dashboard for failed Zaps (15 min)
- [ ] Debug any failures (30 min if issues)
- [ ] Monitor task usage vs. 20k limit (5 min)
- [ ] Update API keys as they rotate (1 hour/quarter)

**Total: ~20 min/week + 1 hour/quarter**

---

## Timeline to Go-Live

### n8n (Recommended)
- **March 29, 14:00-23:59:** Build workflows 1-2 (revenue + content gen)
- **March 30, 06:00-18:00:** Build workflows 3-4 (publishing + error monitoring) + full testing
- **March 30, 18:00-23:59:** Final validation + sign-off
- **March 31, 00:00:** GO LIVE ✅

### Zapier (Not Recommended)
- **March 29, 09:00-18:00:** API setup + basic Zaps
- **March 30, 09:00-18:00:** Finish remaining Zaps + testing
- **March 31:** Incomplete (Redbubble API, Claude content gen not ready)

---

## Risk Assessment

| Risk | n8n | Zapier |
|------|-----|--------|
| Can we be ready by March 31? | ✅ YES (90% confidence) | ⚠️ MAYBE (60% confidence) |
| Will it be truly autonomous? | ✅ YES | ❌ NO (needs monitoring) |
| Will cost kill us in Year 2? | ✅ NO ($0/mo) | ❌ YES ($1,200+/mo) |
| Can we pivot if needed? | ✅ YES (Docker portable) | ⚠️ MAYBE (Zapier lock-in) |
| Will CTMO be burned out? | ✅ NO (1 hr/week) | ⚠️ YES (2 hrs/week) |

---

## The Ask (What We Need to Proceed)

**If CEO/CFO choose n8n:**
1. Approve $0 initial investment (Docker is free)
2. Confirm CTMO builds alone March 29-30 (can't distract with other work)
3. Stage APIs by March 29 14:00 (Gumroad, Etsy, Medium, Stripe, Claude)
4. No changes to revenue streams during sprint (locked until March 31 00:00)

**If CEO/CFO choose Zapier:**
1. Approve $1,188 Year 1 budget (+$359.88 vs. planned)
2. Assign someone to monitor Zapier weekly post-March 31
3. Expect incomplete integrations (Redbubble/Claude ready in April, not March 31)
4. Plan migration to n8n in April as primary system

---

## Final Word

**n8n is the smart choice for this project.** You have:
- Infrastructure ready (Docker running)
- Timeline that fits (36-hour sprint)
- Cost pressure (no budget for $1k/year tools)
- Autonomy requirement (user gone after March 31)

**The only reason to choose Zapier is if CTMO disappears and you need managed service.**

Otherwise: **Build n8n. Save $1,000+/year. Sleep easier knowing it's fully autonomous.**

---

**Decision needed by:** 2026-03-29 14:00 (when CTMO starts building)
**Contact:** CTMO for technical questions, CEO for strategic approval
