# Infrastructure Scaling Limits Audit
**Date:** 2026-03-29
**CTMO Analysis:** Real breaking points vs. published limits
**Status:** FINDINGS CRITICAL — Recommend tier upgrades earlier than projected

---

## Executive Summary

We were overly optimistic about "unlimited" claims. Here's where we ACTUALLY break:

| Platform | Published Limit | Real Breaking Point | Our Need M1-6 | Status |
|----------|-----------------|---------------------|---------------|--------|
| **Bluehost** | Unlimited traffic | 25k-50k/mo before degradation | 5k-30k/mo | SAFE (M1-3) → UPGRADE (M4+) |
| **HubSpot CRM** | 2,500 contacts | 1,000 contacts (new accounts post-Sept 2024) | ~50 active P2 | SAFE (no workaround) |
| **ConvertKit** | 1,000 subscribers | 10,000 subscribers free tier | 50-200 M1-3 → 1,000+ M5-6 | SAFE (generous free tier) |
| **Zapier** | 100 tasks/month | Hits limit in 1-2 weeks of real usage | 10-15 workflows = 50-75 tasks/week | **BLOCKER M1** |
| **PostgreSQL** | None (custom limits) | 1M+ TPS capable (tuned) | Low transaction volume M1-3 | SAFE (not the constraint) |

**Bottom Line:** Zapier free tier is your first breaking point. Plan upgrade to $29.99/mo by Month 1 or use n8n/Make alternative instead.

---

## 1. BLUEHOST SHARED HOSTING — REAL LIMITS

### Published Claim
"Unlimited traffic"

### Reality Check
Bluehost shared hosting throttles based on **25 simultaneous processes** limit and **512MB RAM** per account.

### Performance Degradation Curve
- **0-5k visitors/month:** No issues. 50 concurrent users = minimal lag.
- **5k-25k visitors/month:** Performance degradation begins. Page load times increase noticeably.
- **25k-50k visitors/month:** Throttling kicks in. 50+ concurrent users = 297% response time degradation.
- **50k+ visitors/month:** Site becomes unusable without VPS upgrade. Concurrent user limits trigger resource suspension.

### Our Projection
- **Month 1-2:** 1-3 sites × 1-5k visitors each = 2-15k combined = SAFE on shared hosting
- **Month 3:** 3-5 sites × 3-8k visitors = 9-40k combined = MARGINAL (at 25k edge, degradation starting)
- **Month 4+:** Likely pushing 30k-50k+ combined = **VPS UPGRADE REQUIRED**

### Real Customer Data
- Site speed testing showed 312ms TTFB at baseline (fails Google Core Web Vitals)
- At 50 concurrent users: +297% degradation (1,240ms response)
- CPU throttling limits documented in ToS despite support denials
- Common complaint: Arbitrary suspensions when hitting undocumented resource caps

### Recommendation
- **M1-2:** Stay on Bluehost shared (saves ~$60/mo vs VPS)
- **M3:** Monitor traffic. If any single site exceeds 15k/mo or combined > 30k/mo, upgrade
- **M4 onwards:** Plan for VPS upgrade (~$30-50/mo extra)

**Sources:**
- [Bluehost Review 2026: 10 Pros & 3 Cons](https://hostdean.com/provider/bluehost/)
- [Can Bluehost Handle High Traffic?](https://www.linkedin.com/pulse/can-bluehost-handle-high-traffic-limit-dolly-singh)
- [How Much Traffic Can Bluehost Handle?](https://hostingrevelations.com/how-much-traffic-can-bluehost-handle/)

---

## 2. HUBSPOT FREE CRM — CONTACT LIMITS

### Published Claim (Outdated)
"2,500 contacts on free tier"

### Reality Check (2024 Update)
HubSpot reduced free tier to **1,000 contacts** for all new accounts created after September 2024.

**Critical Finding:** There is NO workaround. Permanent deletion of contacts frees space, but archiving does not.

### Contact Limit Breakdown
- **What counts:** ALL contact records (prospects, customers, leads, unqualified)
- **What doesn't:** Permanently deleted contacts (but deleted contacts in recycle bin still count until purged)
- **No grandfathering:** Old accounts pre-Sept 2024 have 1M contacts. New accounts cap at 1,000.

### Our Projection
- **P2 Client Model:** ~50 active contacts per stream, 2-3 streams = 100-150 total contacts
- **Status:** SAFE through Month 6+. We're nowhere near 1,000.

### Cost to Upgrade
When forced to upgrade (1,000+ contacts), entry tier is **$50/mo** for Starter plan (3,000 contacts).

### Recommendation
- **No action needed M1-6.** We won't hit 1,000 contacts.
- **Strategy:** Use HubSpot for P2 client management (50-150 contacts fits easily).
- **Fallback:** If we exceed 1,000 (unlikely in 6 months), switch to Pipedrive free tier (no contact limit) or upgrade to HubSpot Starter.

**Sources:**
- [HubSpot Free CRM Limitations & How to Overcome Them](https://www.close.com/blog/hubspot-crm-limitations)
- [Think HubSpot CRM Is Really Free?](https://claritysoft.com/hubspot-free-plan-limitations/)

---

## 3. CONVERTKIT (KIT) — SUBSCRIBER LIMITS

### Published Claim
"Free tier: 1,000 subscribers"

### Reality Check
Kit's free tier actually allows **10,000 subscribers** — not 1,000.

### Pricing Tiers
- **Free:** 10,000 subscribers, unlimited emails/forms, 1 automation
- **Creator ($25-39/mo):** 1,000-3,000 subscribers
- **Creator Plus ($59/mo):** 3,000+ subscribers (auto-upgrade at tier limits)

### Our Projection
- **Month 1-3:** 50-200 subscribers = deeply SAFE
- **Month 5-6:** 500-1,000 subscribers = still SAFE on free tier (plenty of room)
- **Month 12+:** Only upgrade if hitting 10k subscribers (unlikely first year)

### Upgrade Timeline
- Auto-upgrade triggered at tier limit with pro-rated billing
- If we exceed 10k subscribers (very unlikely in 6 months), upgrade to Creator plan at $39/mo

### Recommendation
- **Stay free M1-6.** No upgrade needed until 10k subscribers.
- **Monitor:** Track subscriber growth. Upgrade to Creator only if approaching 8k+ subscribers.

**Sources:**
- [Kit Pricing: How Much Will It Cost You in 2026?](https://www.emailtooltester.com/en/reviews/convertkit/pricing/)
- [ConvertKit Pricing 2025: Navigating the Free Plan](https://www.oreateai.com/blog/convertkit-pricing-2025-navigating-the-free-plan-for-1000-subscribers-f33981ebe908ddb1012dde3da269b2ee)

---

## 4. ZAPIER — WORKFLOW LIMITS (BLOCKING ISSUE)

### Published Claim
"Free tier: 100 tasks per month"

### Reality Check
**This is a blocker.** 100 tasks disappears in 1-2 weeks of real usage.

### How Tasks Count
- 1 automation with 3 steps = 3 tasks per run
- Example: New lead → HubSpot → Email → Slack = 3 tasks
- Running 10-15 times per day = 30-45 tasks/day = **entire month's budget in 2-3 days**

### Our Projection
- **Month 1:** Zapier free tier will exhaust in first 1-2 weeks
- **Workflow needs:** 10-15 workflows × avg 2-3 steps = 20-45 tasks/week = 80-180 tasks/week
- **Status:** FREE TIER INSUFFICIENT

### Paid Plan Pricing
- **Professional:** $19.99/mo (annual) or $29.99/mo (monthly) = 750 tasks/mo (still might be tight)
- **Team:** $150/mo = 2,000 tasks/mo (safer, but expensive)
- **Enterprise:** Custom pricing

### Real Customer Feedback
- "100 tasks disappear in a flash"
- Common complaint: Free tier useful for testing only, not production
- Most users hit limits within first week if running real automations

### Recommendation
- **Plan Zapier upgrade to $29.99/mo (Professional) for Month 1**
- **Or evaluate alternatives:** n8n (self-hosted, free) or Make.com (similar pricing)
- **Budget impact:** $29.99/mo × 12 = ~$360/year for Zapier

**Critical Decision:** Switch to n8n now (already in Docker stack) vs. pay Zapier. N8N is free, self-hosted, and flexible. Recommend switching before Month 1 to avoid surprise blocker.

**Sources:**
- [Zapier Plans & Pricing](https://zapier.com/pricing)
- [Zapier Pricing Breakdown: Is It Still Worth It In 2026?](https://www.activepieces.com/blog/zapier-pricing)
- [A 2025 guide to your Zapier subscription](https://www.eesel.ai/blog/zapier-subscription)

---

## 5. POSTGRESQL — DATABASE SCALING

### Published Claim
"Unlimited" (custom limits)

### Reality Check
PostgreSQL has NO hard transaction-per-month limit. Performance depends on hardware, tuning, and query design.

### Performance Benchmarks (Tuned Single-Node)
- **Read-heavy workloads:** 25-32k TPS per CPU core
- **Write-heavy workloads:** 45k TPS on 6-core workstation with NVMe
- **Real-world example:** 1.2 billion records/month (demonstrated scaling)

### Our Projected Load (M1-6)
- **Transactions per month:** Low (product sales, email logs, affiliate tracking)
- **Estimated peak:** 10k-50k transactions/month (extremely modest)
- **Storage:** < 1GB (products, sales, user data minimal)

### Cost Scaling

| Provider | Entry Cost | Scaling Cost | Our Fit M1-6 |
|----------|-----------|--------------|-------------|
| Self-hosted Docker | $0 | Included in hosting | YES |
| Railway PostgreSQL | $5-15/mo | $18/mo typical | YES |
| AWS RDS | $10-20/mo | $50-100+/mo at scale | YES |
| Supabase | $0 | $25/mo (Pro, unlimited) | NO UPGRADE NEEDED |

### Recommendation
- **Self-hosted PostgreSQL in Docker is sufficient** for our projected load (M1-6)
- **Cost:** Included in $0-5/mo Docker hosting budget
- **Upgrade path:** If hitting 100k+ transactions/month (unlikely), consider Railway ($18/mo) or Supabase ($25/mo)
- **No concern:** PostgreSQL is NOT our limiting factor

**Sources:**
- [Lessons learned scaling PostgreSQL to 1.2bn records/month](https://gajus.medium.com/lessons-learned-scaling-postgresql-database-to-1-2bn-records-month-edc5449b3067)
- [Best PostgreSQL Hosting in 2026: RDS vs Supabase vs Neon vs Self-Hosted](https://dev.to/philip_mcclarence_2ef9475/best-postgresql-hosting-in-2026-rds-vs-supabase-vs-neon-vs-self-hosted-5fkp)
- [Railway Pricing 2025](https://www.saaspricepulse.com/tools/railway)

---

## REVISED UPGRADE TIMELINE

### Month 1
- [ ] Evaluate Zapier vs n8n: If staying with Zapier, upgrade to Professional ($29.99/mo)
- [ ] Monitor Bluehost: Ensure no single site exceeds 15k visitors/mo
- [ ] HubSpot: No action (50-150 contacts is fine)
- [ ] ConvertKit: No action (10k subscriber free tier has room)
- [ ] PostgreSQL: No action (self-hosted sufficient)

### Month 2-3
- [ ] If combined site traffic > 25k/mo: Plan Bluehost VPS upgrade ($30-50/mo)
- [ ] Monitor Zapier task usage: If Professional tier is tight, consider n8n switch
- [ ] All other platforms: No action needed

### Month 4+
- [ ] Execute Bluehost VPS upgrade if needed
- [ ] Evaluate cost vs. growth: Should we migrate to faster hosting? (not yet)
- [ ] If ConvertKit approaching 5k+ subscribers: Consider upgrade to Creator tier ($39/mo)

### Month 5-6
- [ ] Review all infrastructure costs and performance
- [ ] Plan for Month 7-12 growth assumptions (10x subscriber/traffic growth)

---

## INFRASTRUCTURE COST SUMMARY (M1-6)

| Component | Current | M1 (If Upgraded) | M4+ (If Scaled) |
|-----------|---------|------------------|-----------------|
| **Bluehost Hosting** | ~$2-5/mo | ~$2-5/mo | ~$35-55/mo (VPS) |
| **Zapier** | $0 (free, blocker) | $29.99/mo | $29.99/mo |
| **PostgreSQL** | $0 (self-hosted) | $0 | $0-15/mo (if Railway) |
| **HubSpot CRM** | $0 | $0 | $0 (no upgrade needed M1-6) |
| **ConvertKit** | $0 | $0 | $0-39/mo (if 8k+ subs) |
| **TOTAL** | **~$2-5/mo** | **~$35-40/mo** | **~$65-110/mo** |

**Key Finding:** Only Zapier and Bluehost represent real cost jumps. Everything else is gravy until serious scale.

---

## CRITICAL DECISIONS REQUIRED

### Decision 1: Zapier vs n8n
- **Problem:** Zapier free tier (100 tasks/mo) is insufficient. Professional tier ($29.99/mo) needed by Month 1.
- **Alternative:** n8n (self-hosted in Docker) is free and unlimited.
- **Recommendation:** Unless we have specific Zapier integrations not in n8n, switch to n8n to avoid $360/year Zapier cost. This frees budget for Bluehost VPS upgrade later.

### Decision 2: Bluehost Traffic Threshold
- **Question:** At what traffic level do we trigger VPS upgrade?
- **Options:**
  - Conservative (25k combined/mo): Upgrade in Month 3
  - Moderate (50k combined/mo): Upgrade in Month 4
  - Aggressive (75k combined/mo): Upgrade in Month 5
- **Recommendation:** Set trigger at 40k combined visitors/month. Upgrade when any stream hits 20k/mo independently.

### Decision 3: PostgreSQL Scaling
- **Question:** Should we monitor transaction volume and upgrade to Railway if needed?
- **Current:** Self-hosted Docker (free)
- **Recommendation:** No upgrade needed until hitting 500k transactions/month. Current Docker setup is overkill for our load.

---

## NEXT STEPS (CTMO)

1. **[URGENT] Make Zapier decision:** Audit current Zapier usage (if any) and decide n8n vs paid Zapier by EOD
2. **Monitor traffic:** Set up alerts when Bluehost accounts exceed 12k visitors/month
3. **Test n8n flows:** If switching from Zapier, build replacement workflows in n8n (already in Docker)
4. **Update CFO budget:** Revise cost projections based on these findings
5. **Document scaling triggers:** Create escalation checklist for when to upgrade each platform

---

## References & Sources

1. [Bluehost Review 2026: 10 Pros & 3 Cons](https://hostdean.com/provider/bluehost/)
2. [Can Bluehost Handle High Traffic?](https://www.linkedin.com/pulse/can-bluehost-handle-high-traffic-limit-dolly-singh)
3. [How Much Traffic Can Bluehost Handle?](https://hostingrevelations.com/how-much-traffic-can-bluehost-handle/)
4. [HubSpot Free CRM Limitations](https://www.close.com/blog/hubspot-crm-limitations)
5. [Kit Pricing: How Much Will It Cost You in 2026?](https://www.emailtooltester.com/en/reviews/convertkit/pricing/)
6. [Zapier Plans & Pricing](https://zapier.com/pricing)
7. [Zapier Pricing Breakdown: Is It Still Worth It In 2026?](https://www.activepieces.com/blog/zapier-pricing)
8. [Lessons learned scaling PostgreSQL to 1.2bn records/month](https://gajus.medium.com/lessons-learned-scaling-postgresql-database-to-1-2bn-records-month-edc5449b3067)
9. [Railway Pricing 2025](https://www.saaspricepulse.com/tools/railway)

