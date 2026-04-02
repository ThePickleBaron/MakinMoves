# n8n Platform Integration Summary (Quick Reference)

**Document:** Executive summary of n8n automation strategy
**Audience:** All roles (CEO, COO, CTMO)
**Last Updated:** 2026-03-29

---

## Platform Ranking (Easiest → Hardest)

### TIER 1: EASIEST ✅

**Gumroad**
- n8n Node: Gumroad Trigger (webhook) + HTTP Request
- Setup Time: 20-30 minutes
- Auth: Simple API token
- Rate Limit: Undocumented (generous)
- Best For: Revenue capture (real-time webhook on sales)
- Status: **PHASE 1**

**WordPress**
- n8n Node: HTTP Request (REST API) or webhook via plugin
- Setup Time: 30-45 minutes
- Auth: Basic auth or app password
- Rate Limit: None (hosting dependent)
- Best For: Publishing generated content
- Status: **PHASE 1**

---

### TIER 2: MODERATE ⚠️

**Etsy**
- n8n Node: HTTP Request (no native node; use Pipedream or direct)
- Setup Time: 45-60 minutes
- Auth: OAuth 2.0 (3-legged)
- Rate Limit: 10,000/day, 10/second (manageable)
- Best For: Shop sales + inventory automation
- Status: **PHASE 2**

---

### TIER 3: HARD ❌

**Medium**
- Status: **API DEPRECATED** (officially shut down)
- Alternative: Use Substack or Ghost instead
- Status: **DO NOT BUILD**

**Redbubble**
- Status: **NO OFFICIAL API** (only scrapers available)
- Alternative: Use LazyMerch managed tool
- Status: **DO NOT BUILD**

---

## The 4 Critical Workflows

| Workflow | Trigger | Frequency | Nodes | Runtime | Purpose |
|----------|---------|-----------|-------|---------|---------|
| **Revenue Capture** | Schedule | Every 60 min | Schedule → HTTP → Set → Loop → PostgreSQL | 30-60s | Log all sales to database |
| **Content Generation** | Schedule | Daily 8 AM | Schedule → Set → HTTP (Claude) → Set → PostgreSQL | 20-40s | Auto-generate blog posts, descriptions |
| **Publishing** | Webhook | On-demand | Webhook → PostgreSQL → If → HTTP → PostgreSQL | 5-10s | Publish staged content to platforms |
| **Error Monitoring** | Error Trigger | On any failure | Error → Set → PostgreSQL → If → Slack → Respond | 2-5s | Catch errors, log, alert |

---

## Platform API Rate Limits

| Platform | Daily Limit | Per-Second Limit | Strategy |
|----------|-----------|-----------------|----------|
| **Gumroad** | Undocumented | Undocumented | Retry with backoff; monitor 429s |
| **Etsy** | 10,000 | 10 requests | Batch requests; check response headers |
| **WordPress** | None | None | Stagger publishes to avoid host limits |
| **Claude API** | ~10k requests | 50k tokens/min | 1-5 posts/day = easily under limit |
| **PostgreSQL** | None | 1000+ writes/sec | Batch inserts; no throttle needed |

---

## PostgreSQL Tables Needed

```sql
revenue_log              -- Sales from all platforms
content_staging          -- Generated content awaiting publish
error_log                -- All workflow failures
workflow_executions      -- Metrics for monitoring
```

See `CTMO/research/n8n-node-configuration-reference.md` for full schema.

---

## Implementation Phases

### Phase 1 (Week 1): Revenue + Logging
- Build: Gumroad revenue capture workflow
- Build: PostgreSQL logging schema
- Build: Error monitoring + Slack alerts
- Dev Time: 3 hours
- Status: **READY TO START**

### Phase 2 (Week 2-3): Content Automation
- Build: Claude content generation workflow
- Build: WordPress publishing workflow
- Dev Time: 3 hours
- Status: **BLOCKED ON Phase 1**

### Phase 3 (Week 4): Expand Revenue
- Build: Etsy integration
- Dev Time: 2.5 hours
- Status: **BLOCKED ON Phase 1-2**

### Phase 4+ (Ongoing): Monitoring + Scaling
- Dashboard (revenue metrics)
- Performance tuning
- New platforms as needed

---

## Setup Checklist

### Pre-Setup (User Actions)
- [ ] Get Gumroad API token
- [ ] Create Claude API key (Anthropic)
- [ ] Get WordPress app password
- [ ] Provision PostgreSQL database
- [ ] Create Slack workspace + #automation-alerts channel

### CTMO Setup (Technical)
- [ ] Deploy n8n instance (cloud or self-hosted)
- [ ] Connect n8n to PostgreSQL (test connection)
- [ ] Add secrets (API keys, credentials)
- [ ] Create 4 workflows using provided node configurations
- [ ] Test each workflow end-to-end
- [ ] Enable error workflows for production safety

### COO Setup (Operations)
- [ ] Create Slack notification channels
- [ ] Set up database backups
- [ ] Document backup/restore procedures
- [ ] Create runbook for common failures

### CEO Oversight
- [ ] Review Phase 1 completion
- [ ] Approve Phase 2 start
- [ ] Monitor weekly metrics
- [ ] Adjust platform priorities based on revenue

---

## Cost Breakdown (Annual)

### Software (Production-Ready Setup)
- n8n Cloud (Standard): $50/month = $600/year
- PostgreSQL (AWS RDS): $15/month = $180/year
- Claude API: ~$5/month = $60/year
- WordPress Hosting: $15/month = $180/year
- Slack (free tier): $0
- **Total Year 1: ~$1,020** (includes setup time cost)
- **Year 2+: ~$1,020/year** (recurring)

### Alternative: Self-Hosted (Minimal Cost)
- n8n Self-Hosted: $0 (free open-source)
- PostgreSQL Self-Hosted: $0 (free)
- Claude API: $60/year
- WordPress Hosting: $180/year
- **Total: ~$240/year** (requires DevOps work)

---

## n8n Node Types Quick Reference

| Node | Purpose | Example |
|------|---------|---------|
| **Schedule Trigger** | Time-based start | "Every 60 minutes" |
| **Webhook Trigger** | Event-based start | "When content ready" |
| **HTTP Request** | Call external API | "POST to WordPress" |
| **Set (Edit Fields)** | Transform data | "Normalize Gumroad response" |
| **Loop Over Items** | Process array | "Process each sale" |
| **If Node** | Conditional routing | "If platform == WordPress" |
| **PostgreSQL** | Database operations | "INSERT into revenue_log" |
| **Slack** | Send notification | "Alert #automation-alerts" |
| **Error Trigger** | Catch failures | "On any workflow error" |
| **Wait** | Pause workflow | "Sleep 1 second" |

---

## Key Gotchas

1. ⚠️ **Medium API Deprecated** — Don't build; remove from roadmap
2. ⚠️ **Redbubble No API** — Use LazyMerch; don't try custom integration
3. ⚠️ **Etsy OAuth** — Must implement token refresh logic
4. ⚠️ **Duplicate Revenue** — Add UNIQUE constraint on sale_id
5. ⚠️ **Timezone Mismatches** — Always use UTC; set n8n timezone
6. ⚠️ **PostgreSQL Timeouts** — Use cloud provider connection pooling
7. ⚠️ **Error Trigger Gaps** — Add explicit validation nodes
8. ⚠️ **n8n Cold Starts** — Use paid cloud tier for always-on

---

## Success Metrics (Post-Launch)

Track these KPIs:

- **Revenue Capture Latency:** < 1 minute from sale to database
- **Content Cost:** < $1.00 per blog post (Claude API)
- **Publishing Reliability:** 99%+ success rate
- **Error Response Time:** Alert within 5 minutes
- **Workflow Runtime:** Revenue capture < 60 seconds per hour

---

## Decision Summary

**CEO Decision:** APPROVED for Phase 1 (Gumroad + PostgreSQL + error monitoring)

**Recommendation:**
1. Skip Medium and Redbubble (deprecated / no API)
2. Prioritize Gumroad + WordPress for Phase 1 (fastest time-to-value)
3. Add Etsy in Phase 2 once core workflows proven
4. Use direct PostgreSQL connection (not webhook)
5. Implement error monitoring from day 1

---

## Documentation References

- **Full Architecture:** `CEO/research/n8n-automation-architecture.md`
- **Node Configuration:** `CTMO/research/n8n-node-configuration-reference.md`
- **Decision Log:** `board/decisions/decision_2026-03-29_n8n-architecture.md`

---

**Status:** Research complete. Ready for board approval and CTMO implementation.

