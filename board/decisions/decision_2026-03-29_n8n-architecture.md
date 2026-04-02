# Decision: n8n Automation Architecture for Autonomous Revenue Operations

**Date:** 2026-03-29 09:00
**Proposed by:** CEO (based on CTMO research)
**Status:** DECISION PENDING CEO APPROVAL

---

## Executive Summary

n8n is viable as the automation backbone for autonomous revenue operations. Research identifies clear platform integration hierarchy, 4 critical workflows, PostgreSQL logging strategy, and realistic 10.5-hour implementation timeline.

---

## Strategic Recommendation

### Phase 1 Priority (This Month)
**Build:** Gumroad revenue capture + PostgreSQL logging + error monitoring
**Why:** Easiest APIs, immediate revenue visibility, foundation for all future workflows
**Timeline:** 3 hours dev, go-live by Week 1
**Risk:** LOW

### Phase 2 (Next Month)
**Build:** Claude content generation + WordPress publishing
**Why:** Automate daily content creation and publishing pipeline
**Timeline:** 3 hours dev
**Risk:** LOW

### Phase 3 (Month 3)
**Build:** Etsy integration for expanded revenue streams
**Why:** Well-documented API, sustainable rate limits
**Timeline:** 2.5 hours dev
**Risk:** MEDIUM (OAuth complexity, but manageable)

### Never Build
- **Medium Integration** — API deprecated (blocker)
- **Redbubble Integration** — No official API (use LazyMerch managed tool instead)

---

## Platform Integration Ranking

| Platform | Integration Difficulty | Setup Time | Recommendation |
|----------|----------------------|-----------|-----------------|
| **Gumroad** | EASIEST | 20-30m | ✅ Phase 1 |
| **WordPress** | TIER 1 | 30-45m | ✅ Phase 1 |
| **Etsy** | MODERATE | 45-60m | ✅ Phase 2 |
| **Medium** | N/A (DEPRECATED) | N/A | ❌ Skip |
| **Redbubble** | HARDEST (no API) | 120+m | ❌ Skip |

---

## The 4 Critical Workflows

1. **Revenue Capture (Hourly)**
   - Poll Gumroad, Etsy, etc. every 60 min
   - Log to PostgreSQL
   - Send errors to Slack
   - Runtime: 30-60 sec

2. **Content Generation (Daily)**
   - Claude API generates blog post, description, social caption
   - Stage in PostgreSQL for review
   - Notify via Slack
   - Runtime: 20-40 sec
   - Cost: ~$0.30-1.00 per piece

3. **Publishing (On-demand)**
   - Route staged content to WordPress, Gumroad
   - Update PostgreSQL status
   - Send live links to Slack
   - Runtime: 5-10 sec per publish

4. **Error Monitoring (Real-time)**
   - Catch workflow failures
   - Log to PostgreSQL + classify severity
   - Alert Slack (critical) or email (medium)
   - Auto-retry transient failures
   - Runtime: 2-5 sec per error

---

## PostgreSQL Integration

**Architecture:** Direct connection (not webhook)

**Schema:**
- `revenue_log` — Sales events from all platforms
- `content_staging` — Generated content waiting to publish
- `error_log` — All workflow failures for debugging
- `workflow_executions` — Metrics for monitoring

**Rate Limits:** None; PostgreSQL can handle 1000+ writes/sec

---

## API Rate Limits Summary

| Platform | Limit | Approach |
|----------|-------|----------|
| **Gumroad** | Undocumented | Exponential backoff on 429 |
| **Etsy** | 10k/day, 10/sec | Well-managed; batch requests |
| **WordPress** | None (hosting dependent) | Stagger publishes |
| **Claude** | 50k tokens/min | 1-5 pieces/day sustainable |

---

## Error Handling Strategy

- **Rate limits (429):** Auto-retry with exponential backoff (1s, 2s, 5s, 13s)
- **Server errors (5xx):** Auto-retry 3x, then alert
- **Auth errors (401/403):** Stop, alert, manual fix required
- **Data errors (422):** Log to dead letter queue, skip item, continue
- **Monitoring:** Error Trigger node → PostgreSQL log → Slack alert

---

## Implementation Timeline & Cost

### Development Effort
- **Phase 1 (MVP):** 3 hours → Gumroad + PostgreSQL + error monitoring
- **Phase 2 (Content):** 3 hours → Claude + WordPress
- **Phase 3 (Scaling):** 2.5 hours → Etsy + testing
- **Total:** 10.5 hours (1-2 weeks part-time)

### Annual Cost (Cloud)
- n8n cloud: $600
- PostgreSQL: $180
- Claude API: ~$60/year (1 post/day)
- WordPress hosting: $180
- **Total Year 1:** ~$1,020 (includes dev time value)
- **Year 2+:** ~$60/year (self-hosted setup)

---

## Key Gotchas to Avoid

1. **Medium API Deprecated** — Remove from roadmap entirely
2. **Redbubble No API** — Use LazyMerch instead; don't build custom integration
3. **Etsy OAuth Complexity** — Plan token refresh logic; test quarterly
4. **PostgreSQL Connection Timeouts** — Use cloud provider's connection pooling
5. **Error Trigger Limitations** — Add explicit validation nodes; test edge cases
6. **Duplicate Revenue Entries** — Add UNIQUE constraint on sale_id
7. **Timezone Mismatches** — Always use UTC; set n8n instance timezone
8. **n8n Cloud Cold Starts** — Use paid tier for always-on; or self-host

---

## Success Metrics

Track these KPIs post-launch:

- **Revenue Capture Latency:** < 1 minute from sale to DB
- **Content Cost:** < $1/blog post
- **Publishing Reliability:** 99%+ success rate
- **Error Response Time:** Alert within 5 minutes
- **Workflow Runtime:** Revenue capture < 60 sec/hour

---

## Trade-offs Considered

### Option A: n8n (Recommended)
**Pros:**
- Visual workflow builder; no coding required
- 1000+ integrations out-of-box
- Strong community + templates
- Easy to modify/debug
- Direct PostgreSQL node

**Cons:**
- Cloud tier required for reliability ($50/month)
- Learning curve (30+ min to understand trigger/node patterns)
- Limited error handling (must add dead letter queue manually)

### Option B: Zapier
**Pros:**
- Easier UI; less technical
- Better error handling

**Cons:**
- Cost prohibitive (~$100+/month for this many integrations)
- Limited PostgreSQL support
- Less flexible API access

### Option C: Build Custom (Code)
**Pros:**
- Full control; optimize for specific platforms

**Cons:**
- 40+ hours dev work
- High maintenance burden
- Overkill for current revenue scale

**Chosen:** Option A (n8n) — best balance of power, cost, and ease of use.

---

## Decision

**CEO Decision:** APPROVED for Phase 1 (Gumroad + PostgreSQL + error monitoring)

### Action Items

1. **CTMO:** Build 4 workflow templates; estimate detailed dev time by EOD tomorrow
2. **COO:** Provision n8n cloud instance + PostgreSQL server; get test credentials
3. **CEO:** Finalize Etsy API application once Phase 1 is running (Week 2)
4. **Board:** Sync daily during Phase 1 build; weekly after launch

### Unblocking Dependencies

- Need Gumroad API token (user provides)
- Need PostgreSQL host (AWS RDS or self-hosted)
- Need Claude API key (Anthropic account)
- Need WordPress credentials (staging site)

**Target Go-Live:** Week 1 (Gumroad revenue capture live by April 4)

---

**Owner:** CTMO (implementation), CEO (oversight)
**Review Date:** Weekly standups; full decision review April 5

