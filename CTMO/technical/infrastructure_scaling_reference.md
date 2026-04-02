# Infrastructure Scaling Reference
**Purpose:** Quick lookup for when platforms actually break (not marketing claims)
**Last Updated:** 2026-03-29
**Owner:** CTMO

---

## Real Breaking Points (Not Published Limits)

### Bluehost Shared Hosting
| Metric | Safe Zone | Caution Zone | Break Point |
|--------|-----------|--------------|-------------|
| Monthly Visitors | 0-15k | 15k-25k | 25k+ |
| Concurrent Users | 0-30 | 30-50 | 50+ |
| Simultaneous Processes | 0-20 | 20-25 | 25+ (hard limit) |
| Response Time | <200ms | 200-500ms | 500ms+ (throttled) |
| CPU/RAM Available | Normal | Degraded | Suspended |

**Upgrade Trigger:** 40k combined visitors/month OR single site 20k/month
**VPS Cost:** +$30-50/mo
**Timeline:** Likely Month 4

---

### HubSpot Free CRM
| Metric | Safe Zone | Warning | Limit |
|--------|-----------|---------|-------|
| Contacts | 0-700 | 700-1,000 | 1,000 (hard, no workaround) |
| Marketing Automations | Unlimited | N/A | N/A |
| Deal Pipelines | Unlimited | N/A | N/A |
| Users | 2 | N/A | N/A |

**Our Use Case:** P2 client management (50-150 contacts)
**Status:** Safe indefinitely
**Upgrade Cost:** $50/mo (if ever needed, unlikely M1-6)
**Workaround:** Permanent delete old contacts to free space (archive doesn't work)

---

### ConvertKit (Kit) Email
| Metric | Free Tier | Creator Plan | Creator Plus |
|--------|-----------|--------------|--------------|
| Subscribers | 10,000 | 1,000-3,000 | 3,000+ |
| Cost | $0 | $25-39/mo | $59/mo |
| Automations | 1 | Unlimited | Unlimited |
| Email Sends | Unlimited | Unlimited | Unlimited |

**Our Projection:** 50-200 subs M1-3, 500-1,000 by M6
**Status:** Safe through free tier (10k room)
**Upgrade Trigger:** Only if exceeding 8,000 subscribers (unlikely M1-6)

---

### Zapier Workflows (DO NOT USE FREE)
| Metric | Free | Professional | Team |
|--------|------|--------------|------|
| Tasks/Month | 100 | 750 | 2,000 |
| Workflows | Unlimited | Unlimited | Unlimited |
| Cost | $0 | $19.99-29.99/mo | $150/mo |
| Real Usage Time to Exhaust | 1-2 weeks | 2-3 weeks (tight) | 2 months |

**Our Workflow Estimate:** 10-15 workflows × 2-3 steps = 20-45 tasks/week
**Status:** Free tier insufficient; BLOCKER if relied upon
**Recommendation:** Switch to n8n (free, unlimited, self-hosted)
**Cost Impact:** $0/mo (vs $29.99/mo if keeping Zapier)

---

### PostgreSQL (Self-Hosted)
| Metric | Single Core | 6-Core Workstation | High-End Server |
|--------|------------|-------------------|-----------------|
| Read TPS | 25-32k | 150-192k | 500k+ |
| Write TPS | 8-12k | 45k+ | 250k+ |
| Concurrent Connections | 200-500 | 1,000+ | 5,000+ |
| Storage Limit | None | None | None |

**Our Load:** 10k-50k transactions/month (trivial)
**Status:** Self-hosted Docker sufficient
**Upgrade Trigger:** Only if hitting 500k+ transactions/month (unlikely)
**Cost:** $0/mo (self-hosted) → $15-20/mo (Railway) if needing managed option

---

## When Upgrading Becomes Critical

### Bluehost (Month 3-4)
**Monitor:** Set alerts for 30k-40k combined visitors/month
**Upgrade to:** Bluehost VPS (~$30-50/mo) or migrate to faster host
**Lead time:** 1-2 weeks for setup
**Cost impact:** +$30-50/mo

### Zapier (ALREADY)
**Status:** If using Zapier, already need Professional tier or switch to n8n
**Decision:** n8n (free) vs Zapier Professional ($29.99/mo)
**Recommended:** n8n (saves $360/year)

### HubSpot (Month 12+)
**Trigger:** Only if accumulating 800+ active contacts
**Unlikely for P2 model** (50-150 contacts typical)

### ConvertKit (Month 6+)
**Trigger:** Only if growing beyond 8,000 subscribers
**Upgrade path:** Free (10k) → Creator ($39/mo) → Creator Plus ($59/mo)

---

## Cost Tracking Checklist

### Monthly Monitoring
- [ ] Bluehost traffic: Check monthly visitor totals vs 40k threshold
- [ ] HubSpot contacts: Verify below 800 (still have 200 buffer to 1k limit)
- [ ] ConvertKit subs: Check subscriber growth rate vs 10k threshold
- [ ] PostgreSQL: Monitor transaction volume (if tracking)
- [ ] n8n workflows: Confirm all automations working (no Zapier dependency)

### Quarterly Review
- [ ] Bluehost performance: Any throttling? Any complaints?
- [ ] Traffic growth rate: Extrapolate to Month 6 and 12
- [ ] Cost projections: Update CFO with actual vs. budgeted spending
- [ ] Scaling risks: Any new constraints discovered?

---

## Decision Tree: When to Upgrade

```
BLUEHOST TRAFFIC?
├─ Under 15k/mo → Stay on shared (M1-2)
├─ 15k-30k/mo → Monitor closely (M2-3)
├─ 30k-40k/mo → Prepare VPS quote (M3)
└─ 40k+/mo → UPGRADE to VPS (M4+)

ZAPIER USAGE?
├─ Not using → No upgrade needed
├─ Free tier → SWITCH to n8n immediately (blocker)
└─ Professional tier → Continue (if budget allows)

HUBSPOT CONTACTS?
├─ Under 700 → No action (safe)
├─ 700-900 → Monitor (approaching limit)
└─ 900-1000 → Prepare budget for upgrade or delete old contacts

CONVERTKIT SUBSCRIBERS?
├─ Under 5k → No action (safe)
├─ 5k-8k → Monitor growth rate
├─ 8k-10k → Plan upgrade to Creator ($39/mo)
└─ 10k+ → UPGRADE to Creator

POSTGRESQL LOAD?
├─ Under 100k transactions/mo → Self-hosted fine
├─ 100k-500k/mo → Consider Railway if performance issues
└─ 500k+/mo → Evaluate managed database (Railway, AWS RDS)
```

---

## Key Insights

1. **Bluehost "unlimited" is marketing BS.** Real limit: 25k-50k/mo. Plan VPS upgrade by Month 4.

2. **Zapier free tier is a trap.** 100 tasks/month = useless. Either pay $29.99/mo or switch to n8n (free).

3. **HubSpot, ConvertKit, PostgreSQL are NOT constraints.** We can operate safely for 6+ months without upgrades.

4. **n8n saves $360/year.** Worth the migration effort from Zapier.

5. **Our real constraint is Bluehost shared hosting.** Plan VPS upgrade as revenue grows.

---

## Technical Debt / Future Optimizations

- [ ] Auto-scale Bluehost sites to VPS when hitting traffic thresholds
- [ ] Implement CDN (Cloudflare) to reduce Bluehost load (bonus: improves Core Web Vitals)
- [ ] Cache layer (Redis) if PostgreSQL transactions spike
- [ ] Database replication if moving beyond single-node PostgreSQL

Not urgent for M1-6, but document for later scaling.

---

**CTMO:** Update this reference as we discover real limits through actual usage.

