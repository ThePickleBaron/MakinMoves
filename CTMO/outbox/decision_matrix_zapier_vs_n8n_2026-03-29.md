# Decision Matrix: Zapier Pro vs. n8n Self-Hosted
**For:** CEO, CFO
**Date:** 2026-03-29
**Critical Deadline:** March 31, 2026 (36 hours)
**Context:** Autonomous operation required post-March 31. Zero human input possible after user hands-off.

---

## TL;DR: Choose n8n Self-Hosted

**For this project:** n8n self-hosted is the clear winner due to:
1. **Zero monthly cost** — Save $29.99/mo × 12 = $359.88/year
2. **Already deployed** — n8n running in Docker, workflows in progress
3. **Unlimited scalability** — No per-workflow task limits
4. **Required for autonomy** — Zapier would need manual intervention post-March 31

**Caveat:** Zapier is better *only if* you decide you want someone managing workflows hands-on post-March 31.

---

## PART 1: Zapier Pro ($29.99/mo)

### 1.1 Setup Time (Month 1)
| Phase | Time | Notes |
|-------|------|-------|
| Account + sign-up | 30 min | Simple web signup, credit card required |
| API key gathering (5 platforms) | 2 hours | Gumroad, Etsy, Redbubble, Medium, Stripe |
| Zap #1: Revenue capture (Gumroad) | 45 min | Template-based, low complexity |
| Zap #2: Revenue capture (Etsy) | 45 min | Similar to Gumroad, slight differences |
| Zap #3: Revenue capture (Redbubble) | 1 hour | Slightly more complex API |
| Zap #4: Revenue capture (Medium) | 1 hour | RSS feed integration |
| Zap #5: Publishing (Gumroad → Digital Product) | 2 hours | Requires field mapping, JSON handling |
| Zap #6: Publishing (Etsy → PoD) | 2 hours | More complex fields |
| Zap #7: Publishing (Redbubble → PoD) | 2 hours | API nuances, rate limits |
| Zap #8: Content generation (Claude API trigger) | 1.5 hours | Claude API integration (not native) |
| Testing + debugging | 3 hours | Each Zap needs testing |
| **Total Month 1** | **~16 hours** | Spread over 2-3 days |

**Post-March 31 Maintenance:**
- Monitoring Zaps: 10 min/week (check if any are failing)
- API key rotation: 30 min/quarter
- Zap debugging when platform API changes: 1-2 hours/month average

---

### 1.2 Workflow Capacity
| Metric | Zapier Pro | Your Needs | Verdict |
|--------|-----------|-----------|---------|
| Tasks/month included | 750 | ??? (TBD) | ⚠️ Depends on frequency |
| Workflows (Zaps) | Unlimited | 8-10 | ✓ OK |
| Multi-step workflows | Yes | Yes | ✓ OK |
| Custom logic (JS) | No | Needed for error handling | ❌ Limitation |
| Concurrency | 1 (Pro plan) | Possible bottleneck | ⚠️ Potential issue |

**Capacity Deep Dive:**

Zapier Pro = 750 tasks/month.

**Estimated task usage (if autonomous):**
- Revenue capture: 2 platforms × 24 (daily checks) × 30 days = 1,440 tasks/month ← **Already over limit**
- Content generation: 1 workflow × 30 days = 30 tasks/month
- Publishing: ~20 items × 30 = 600 tasks/month

**Total: ~2,070 tasks/month**

**Solution:** Upgrade to Zapier Team ($99/mo) for 20,000 tasks/month, OR manually check revenue (not autonomous).

**Cost impact:** $99/mo vs. planned $29.99/mo = +$70/mo = **$840/year overrun**.

---

### 1.3 Integration Complexity

| Integration | Zapier Native | Your Use Case | Difficulty |
|-------------|---------------|---------------|------------|
| Gumroad | Yes (native) | Fetch sales → DB | Easy (1 hour) |
| Etsy | Yes (native) | Fetch sales → DB | Easy (1 hour) |
| Redbubble | No API, HTML scraping | Scrape revenue | Hard (3 hours) |
| Medium | RSS feed (native) | Fetch article stats | Medium (1.5 hours) |
| Stripe | Yes (native) | Track payments | Easy (1 hour) |
| PostgreSQL | Community app (not native) | Write revenue to DB | Medium (1.5 hours) |
| Claude API | No native support | Generate content | Hard (2 hours, requires custom webhook) |
| WordPress API | Yes (native) | Publish articles | Easy (1 hour) |

**Missing Integrations:**
- Redbubble API (would need Zapier Code or custom app) = 3 extra hours
- Claude API = requires custom webhook setup

**Verdict:** 7/8 integrations available. 2 require workarounds. Time cost: +5 hours.

---

### 1.4 Monthly Cost Breakdown

| Item | Month 1 | Mo 2-12 | Year 1 Total |
|------|---------|---------|-------------|
| Zapier Pro ($29.99/mo) | $29.99 | $359.88 | $389.87 |
| Task overages (if revenue capture 2x/day) | $0 | Depends | +$840 if Team needed |
| API keys (free) | $0 | $0 | $0 |
| Claude API (for content gen) | $0-5 | $5-20 | $50-200 |
| PostgreSQL external (if not self-hosted) | $0 | Depends | $0-150 |
| **Total (best case)** | **$29.99** | **$384.99** | **$439.88** |
| **Total (realistic case: Team + Claude)** | **$104.99** | **$459.99** | **$1,224.87** |

---

### 1.5 Hands-Off Autonomy by March 31? **NO**

**Why not:**
1. Setup time is 16 hours spread across 2-3 days — doable before March 31, but tight.
2. **Testing is incomplete.** Each Zap needs at least 1 full test run with live data. Missing tests = silent failures.
3. **Task limit issue.** At autonomous frequency, you'd overflow 750 tasks/mo after 10 days. Requires upgrade decision.
4. **Redbubble/Claude integration incomplete.** Both require custom setup not finished in time.

**Verdict:** Could be ready for basic revenue capture by March 31, but publishing + content generation workflows would fail silently. Not autonomous-ready.

---

### 1.6 Scaling Cost (Year 1 → Year 3)

| Year | Estimated Revenue | Workflows Added | Task Estimate | Cost |
|------|-------------------|-----------------|---------------|------|
| Year 1 (2026) | $1-5K | 8-10 (basic) | 2K-5K/mo | $99/mo (Team) |
| Year 2 (2027) | $10-50K | +5 (SaaS, trading, API) | 10K-20K/mo | $265/mo (Advanced) |
| Year 3 (2028) | $50K+ | +10 (scale existing) | 50K+/mo | $650/mo (Premium) |

**When does Zapier exceed $50/mo burn?** By Month 2 (if you hit task limits).

---

### 1.7 Single Point of Failure Risk

| Failure Mode | Impact | Recovery Time | Likelihood |
|--------------|--------|---------------|----|
| Zapier service down | All workflows stop | 1-4 hours (Zapier repairs) | Low (99.9% uptime SLA) |
| Platform API breaks (Etsy/Gumroad/Redbubble) | Single Zap fails | 1-24 hours (platform fixes or Zapier updates) | Medium (quarterly API changes) |
| Redbubble scraping blocked | Revenue capture fails | 2-4 hours (manual workaround) | High (scraping detected/blocked) |
| Zapier task limit hit mid-month | New Zaps fail, queuing broken | Manual intervention (upgrade account) | Medium (if revenue capture active) |
| API key expires | Single integration fails | 30 min (rotate key) | Low (should rotate quarterly) |

**Critical Risk:** Redbubble revenue capture would fail without notice (scraping-based). Requires manual monitoring.

---

### 1.8 Post-March 31 Maintenance Burden

**Who manages this post-user-hands-off?**
- CEO? No — strategy work only
- COO? No — operations (publishing only)
- CTMO? **YES** — Must monitor Zaps, debug failures, manage upgrades
- CFO? No — reporting only

**Weekly tasks for CTMO:**
1. Check Zapier dashboard for failed Zaps (10 min)
2. Debug any failures (15-30 min if issues)
3. Monitor task usage vs. limit (5 min)
4. Manage API key rotations (1 hour/quarter)

**Quarterly tasks:**
1. Review Zapier costs (5 min)
2. API deprecation checks (Etsy/Gumroad/Medium updates) (1 hour)

**Estimated ongoing load:** 20 min/week + 1 hour/quarter = **~2 hours/month post-March 31**.

---

## PART 2: n8n Self-Hosted ($0/mo)

### 2.1 Setup Time (Month 1)

| Phase | Time | Notes |
|-------|------|-------|
| Docker deployment | 15 min | Already running (docker-compose.yml exists) |
| n8n UI access + config | 15 min | Already running at http://localhost:5678 |
| PostgreSQL schema prep | 30 min | Add `content_queue`, `revenue_summary`, `error_logs` tables |
| Workflow #1: Revenue Capture | 3 hours | Gumroad, Etsy, Redbubble, Medium APIs |
| Workflow #2: Content Generation | 2 hours | Claude API integration, template rendering |
| Workflow #3: Automated Publishing | 3 hours | Platform APIs, error handling, logging |
| Workflow #4: Error Monitoring | 1 hour | Alert system, logging |
| Integration testing (platform APIs) | 2 hours | Test each platform before full automation |
| End-to-end testing | 2 hours | Revenue → DB → CFO query → Publishing |
| Documentation | 2 hours | Workflow diagrams, troubleshooting guide |
| **Total Month 1** | **~16 hours** | But compressed into 36 hours (March 29-30) |

**Why compressed is possible:**
- n8n UI is fast (drag-drop, no code needed for basic flows)
- Workflows are deterministic (same setup as Zapier, but faster in UI)
- PostgreSQL already initialized
- Docker already running

**Timeline for March 31 deadline:**
- Day 1 (March 29): 6-8 hours (workflows 1-2 + testing)
- Day 2 (March 30): 8-10 hours (workflows 3-4 + full testing)
- Achievable: **YES**

**Post-March 31 Maintenance:**
- Check n8n dashboard: 5 min/week (health check)
- Monitor error logs: 10 min/week (errors table in PostgreSQL)
- API key rotation: 30 min/quarter
- Infrastructure: Docker health checks, PostgreSQL backups (automated)

---

### 2.2 Workflow Capacity

| Metric | n8n Self-Hosted | Your Needs | Verdict |
|--------|---|---|---|
| Workflows | Unlimited | 8-10 | ✓ OK |
| Execution frequency | Unlimited | Hourly revenue capture + daily publishing | ✓ OK |
| Data storage | Limited by PostgreSQL size | ~1GB/year (estimated) | ✓ OK |
| Concurrent executions | Limited by CPU | 3-5 (Docker container) | ✓ OK for startup |
| Custom logic (JS) | Yes (n8n code node) | Needed for error handling | ✓ Full support |
| Database triggers | Yes (PostgreSQL native) | Backup automation | ✓ Full support |

**Capacity advantage over Zapier:**
- n8n has NO task limits
- Revenue capture every hour = 24 × 30 = 720 executions/month ← **n8n handles this for free**
- Zapier Pro 750 tasks/month = immediate overage ← **n8n unlimited**

**Bottleneck:** Docker CPU (if you exceed 3-5 concurrent workflows). Solution: Upgrade Docker memory or defer non-critical workflows.

---

### 2.3 Integration Complexity

| Integration | n8n Native | Your Use Case | Difficulty |
|-------------|------------|---------------|------------|
| Gumroad | Yes (node available) | Fetch sales → DB | Easy (1 hour) |
| Etsy | Yes (node available) | Fetch sales → DB | Easy (1 hour) |
| Redbubble | No native node | Scrape or HTTP request | Medium (1.5 hours) |
| Medium | Yes (HTTP node + RSS) | Fetch article stats | Easy (1 hour) |
| Stripe | Yes (node available) | Track payments | Easy (1 hour) |
| PostgreSQL | Yes (node available) | Write revenue to DB | Easy (30 min) |
| Claude API | Yes (HTTP node) | Generate content | Easy (1 hour) |
| WordPress API | Yes (HTTP node) | Publish articles | Easy (1 hour) |

**Key difference from Zapier:** n8n has HTTP node (flexible) + native nodes (faster). All integrations possible, most are built-in.

**Verdict:** 8/8 integrations available. 0 require workarounds. Time cost: equal to or better than Zapier.

---

### 2.4 Monthly Cost Breakdown

| Item | Month 1 | Mo 2-12 | Year 1 Total |
|------|---------|---------|-------------|
| n8n (self-hosted) | $0 | $0 | $0 |
| Docker/Container (existing) | $0 | $0 | $0 |
| PostgreSQL (existing in Docker) | $0 | $0 | $0 |
| Claude API (for content gen) | $0-5 | $5-20 | $50-200 |
| Backup service (optional, Wasabi) | $0 | $5-10 | $50-100 |
| **Total (self-hosted)** | **$0-5** | **$5-30** | **$50-200** |
| **vs. Zapier Pro** | **-$30** | **-$385** | **-$440** |

**Cost advantage:** n8n saves **$440-1,200/year** vs. Zapier Pro (depending on task overflow).

---

### 2.5 Hands-Off Autonomy by March 31? **YES**

**Why yes:**
1. Setup time is 16 hours, achievable in 36-hour sprint (March 29-30).
2. All workflows testable before midnight March 31.
3. Error handling built into each workflow (automatic retry, logging).
4. PostgreSQL queries automated (CFO can run ad-hoc reports).
5. No manual intervention needed after March 31 (unless API key expires).

**Readiness checklist:**
- [ ] All 4 workflows deployed by March 30, 23:00
- [ ] Revenue capture tested on ≥2 platforms
- [ ] Content generation tested (sample batch)
- [ ] Publishing tested on ≥1 platform (manual trigger first)
- [ ] Error monitoring active
- [ ] PostgreSQL tables created + verified
- [ ] Documentation written
- [ ] Docker health checks verified
- [ ] CFO can query revenue_summary without assistance

**Verdict:** Achievable. CTMO plan already exists (see `plan_2026-03-29_36hour-automation.md`).

---

### 2.6 Scaling Cost (Year 1 → Year 3)

| Year | Revenue | Workflows | Frequency | Cost Impact |
|------|---------|-----------|-----------|-------------|
| Year 1 (2026) | $1-5K | 8-10 | Hourly capture + daily publishing | $0/mo (Docker) |
| Year 2 (2027) | $10-50K | +5 (SaaS, trading) | More frequent, more complex | $0-10/mo (if Docker upgrade needed) |
| Year 3 (2028) | $50K+ | +10 | High volume, real-time | $20-50/mo (Cloud n8n if self-hosted outgrows) |

**When might you migrate to Cloud n8n?** At 10,000+ workflow executions/day (unlikely in Year 1-2).

**Cost comparison Year 3:**
- n8n self-hosted: ~$50/mo
- Zapier Pro (at scale): ~$650/mo

---

### 2.7 Failure Recovery (Self-Hosted Risk)

| Failure Mode | Impact | Recovery Time | Likelihood |
|--------------|--------|---------------|----|
| Docker container crashes | All n8n workflows stop | 5 min (Docker auto-restart) | Low (~1x/year) |
| PostgreSQL DB corruption | Data loss, queries fail | 15 min (restore from backup) | Very low (0.5x/year) |
| Disk full (PostgreSQL logs) | No new revenue logged | 30 min (cleanup logs, restart) | Low (if not monitored) |
| API key expires (Gumroad/Etsy) | Single integration fails | 10 min (rotate key, restart workflow) | Medium (quarterly rotation) |
| Platform API breaks (Etsy deprecates endpoint) | Single workflow fails | 2-4 hours (update n8n HTTP request) | Medium (quarterly updates) |
| Network failure (WiFi down) | Scheduled workflows pause | Auto-resumes on reconnect | Low (depends on home internet) |

**Key advantage:** Self-hosted is *more* resilient in some ways:
- Docker auto-restart means minimal downtime
- You control backups (not dependent on 3rd party)
- No external rate limits (PostgreSQL limits are huge)

**Key risk:** Home internet / power stability. Solution: Move to Railway/Heroku if needed (costs $20-50/mo then).

---

### 2.8 Post-March 31 Maintenance Burden

**Who manages this?**
- CTMO (infrastructure monitoring, API key rotations, Docker health)
- CFO (financial reporting from PostgreSQL)
- COO (content approval workflow in database)

**Weekly tasks for CTMO:**
1. Check Docker health (`docker ps`) — 2 min
2. Review error_logs table for critical errors — 5 min
3. Monitor PostgreSQL disk usage — 2 min
4. Check n8n workflow success rates — 5 min

**Total: ~14 min/week = ~1 hour/month post-March 31**.

**Quarterly tasks:**
1. API key rotation — 30 min
2. PostgreSQL backup verification — 15 min
3. Docker image updates — 30 min

**Total: ~75 min/quarter = ~20 min/month**.

**Estimated ongoing load:** ~1.3 hours/month post-March 31 (vs. Zapier's 2 hours/month).

---

## PART 3: Head-to-Head Comparison Table

### 3.1 Cost Comparison (Years 1, 2, 3)

| Metric | Zapier Pro | n8n Self-Hosted | Winner |
|--------|----------|---|---|
| **Year 1 cost** | $390-1,225* | $50-200 | n8n |
| **Year 2 cost** | $1,200-3,120* | $50-200 | n8n |
| **Year 3 cost** | $1,800-7,800* | $50-600** | n8n |
| **3-year total** | $3,390-12,145 | $150-1,000 | **n8n saves $2,240-11,145** |

*Zapier includes task overages and Team plan upgrade
**n8n if migrated to cloud at Year 3 due to scale

---

### 3.2 Setup Time Comparison

| Metric | Zapier Pro | n8n Self-Hosted | Winner |
|--------|----------|---|---|
| Time to basic workflows (3-4 Zaps) | 4-5 hours | 4-5 hours | Tie |
| Time to full automation (8 workflows) | 16 hours (spread over days) | 16 hours (compressed to 36-hour sprint) | **n8n** (fits deadline) |
| Testing rigor needed | High (each Zap separate) | High (each workflow separate) | Tie |
| Documentation burden | Light (Zapier's UI is self-documenting) | Medium (need to document n8n nodes/logic) | Zapier |
| **Ready for March 31 deadline?** | Tight (possible but risky) | **YES** (planned and feasible) | **n8n** |

---

### 3.3 Failure Modes & Recovery

| Failure Mode | Zapier | n8n | Winner |
|---|---|---|---|
| Service downtime | 1-4 hrs (external dependency) | 5 min (self-restart) | **n8n** |
| API integration breaks | 1-24 hrs (Zapier's support) | 2-4 hrs (you update n8n node) | **n8n** (faster fix) |
| Task limit hit | Requires payment + upgrade decision | N/A (unlimited) | **n8n** |
| Database corruption | N/A (external) | 15 min (restore backup) | **n8n** (you control backup) |
| Redbubble scraping detected | Zap fails (complex workaround) | HTTP request fails (try proxy) | Tie (both risky) |
| Hands-off operation | Manual monitoring required post-March 31 | Fully autonomous | **n8n** |

---

### 3.4 Switching Cost (If You Change Minds Later)

| Scenario | Cost | Effort |
|----------|------|--------|
| Zapier Pro → n8n (Month 3) | Lose $90 (3 months Zapier paid) + 20 hours | Medium (rebuild 8 workflows) |
| n8n → Zapier Pro (Month 3) | $0 sunk cost + 16 hours | Medium (rebuild 8 Zaps) |
| Zapier Pro → Cloud n8n (Year 2) | Lose $1,200 (12 months Zapier) + 20 hours | Medium |
| n8n → Railway/Heroku (Year 2) | $0 sunk cost + 5 hours | Light (Docker already built) |

**Switching is cheaper from n8n because zero upfront cost.**

---

### 3.5 CEO/CFO Decision Matrix

**Use THIS to decide:**

```
Question 1: Is March 31 hand-off deadline HARD?
  → YES: Choose n8n (Zapier too risky)
  → NO: Can revisit at Month 2

Question 2: Will you have someone managing workflows post-March 31?
  → YES (COO or CTMO available): Either option works, choose by cost
  → NO (fully autonomous required): Choose n8n (only fully autonomous option)

Question 3: What's your risk tolerance for setup?
  → Low (want proven, simple): Zapier Pro (but timeline tight)
  → Medium-High (willing to manage Docker): n8n self-hosted

Question 4: Do you anticipate >10 workflows by Year 2?
  → YES: n8n (Zapier costs explode)
  → NO: Either works

Question 5: Can you monitor/debug infrastructure?
  → YES (CTMO available): n8n self-hosted
  → NO (need managed service): Zapier Pro
```

---

## PART 4: Recommendation with Caveats

### 4.1 Recommendation: **n8n Self-Hosted (Primary Path)**

**Why:**
1. **Already deployed.** Docker running, CTMO plan exists. Zapier = starting from zero.
2. **March 31 deadline.** n8n fits 36-hour sprint. Zapier setup spreads across days (risky).
3. **Cost.** $0/mo vs. $29.99+/mo. Saves $440+ Year 1.
4. **Autonomy.** n8n fully autonomous post-March 31. Zapier requires monitoring.
5. **Scaling.** Unlimited workflows, no task limits. Zapier overflows at Month 2 (if revenue capture daily).

**When to choose n8n:**
- Goal: Full autonomy post-March 31 ✓
- Goal: Zero ongoing CTMO cost ✓
- Goal: Flexible, unlimited scalability ✓
- Goal: Custom error handling + logging ✓

---

### 4.2 Caveat: Backup Option (Zapier Pro)

**When to choose Zapier instead:**
- **Scenario:** CTMO unavailable post-March 31, and you need someone to manage workflows
- **Scenario:** You're uncomfortable with self-hosted Docker infrastructure
- **Scenario:** You prioritize "set it and forget it" simplicity

**If you choose Zapier:**
- Must upgrade to Team plan ($99/mo) by Month 2 to avoid task overages
- Budget: $1,200-1,500/year (not $30/mo)
- Requires weekly monitoring (who does this?)
- Redbubble integration incomplete (scraping risk)

---

### 4.3 Hybrid Option: Start Zapier Pro, Migrate to n8n in April (Not Recommended)

| Phase | Timeline | Action | Cost | Risk |
|-------|----------|--------|------|------|
| Phase 1 | March 29-31 | Launch on Zapier Pro (simple revenue capture) | $30 | Medium (Zapier only ready for 1-2 workflows) |
| Phase 2 | April 1-14 | CTMO builds n8n in parallel (full automation) | $0 | Low (gives CTMO 2 weeks) |
| Phase 3 | April 15 | Switch: Zapier → n8n (cut over) | Lose $X of Zapier subscription | Low (after 2 weeks, n8n proven) |

**Why not recommended:**
- Doubles setup work (16 hours Zapier + 16 hours n8n = 32 hours)
- Adds complexity (two systems running in parallel)
- Wastes money (Zapier paid for March, then abandoned)

**Better approach:** Do n8n in 36-hour sprint (March 29-30), skip Zapier entirely.

---

## PART 5: Go-Live Checklist for Each Path

### 5.1 n8n Self-Hosted Go-Live (March 29-31)

**Day 1 (March 29, 14:00-23:59)**

**14:00-15:00: Planning**
- [ ] Review CTMO plan: `plan_2026-03-29_36hour-automation.md`
- [ ] Confirm API keys available (Gumroad, Etsy, Medium, Stripe, Claude)
- [ ] List PostgreSQL schema changes needed

**15:00-18:00: API Mapping**
- [ ] Verify Gumroad API access + test endpoint
- [ ] Verify Etsy API access + test endpoint
- [ ] Verify Redbubble API or scraping method + test
- [ ] Verify Medium API/RSS + test
- [ ] Verify Claude API access + test
- [ ] Document all API URLs, auth methods, rate limits

**18:00-21:00: Build Workflows 1-2**
- [ ] Workflow #1: Revenue Capture (Gumroad + Etsy)
  - [ ] n8n trigger: Hourly cron
  - [ ] API request nodes (Gumroad, Etsy)
  - [ ] PostgreSQL INSERT node
  - [ ] Error handler node
  - [ ] Deploy workflow
- [ ] Workflow #2: Content Generation (Claude API)
  - [ ] n8n trigger: Daily 06:00
  - [ ] Claude API request node
  - [ ] Template rendering
  - [ ] PostgreSQL INSERT to content_queue
  - [ ] Deploy workflow

**21:00-23:59: Testing**
- [ ] Test revenue capture on Gumroad (manual trigger)
- [ ] Verify data in PostgreSQL (SELECT * FROM revenue_summary LIMIT 5)
- [ ] Test content generation (manual trigger)
- [ ] Check error logs (SELECT * FROM error_logs)
- [ ] Document any failures

---

**Day 2 (March 30, 06:00-23:59)**

**06:00-10:00: Build Workflows 3-4**
- [ ] Workflow #3: Automated Publishing
  - [ ] n8n trigger: Daily 09:00
  - [ ] Query content_queue (status='approved')
  - [ ] API POST to Gumroad (test first)
  - [ ] API POST to Etsy (test first)
  - [ ] PostgreSQL UPDATE (mark published)
  - [ ] Deploy workflow
- [ ] Workflow #4: Error Monitoring
  - [ ] n8n trigger: Hourly
  - [ ] Query error_logs for critical errors
  - [ ] Log summary to PostgreSQL
  - [ ] Deploy workflow

**10:00-14:00: Integration Testing**
- [ ] Revenue capture: Check data flows end-to-end
  - [ ] API → n8n → PostgreSQL → CFO query
- [ ] Content generation: Verify sample batch
  - [ ] n8n → PostgreSQL content_queue visible
  - [ ] Approve one item manually in DB
- [ ] Publishing: Dry run on test account
  - [ ] Mark content as 'approved' in DB
  - [ ] Trigger publishing workflow
  - [ ] Verify platform (e.g., Gumroad shows test product)

**14:00-18:00: Platform Publishing Tests**
- [ ] Manual test: Can COO approve content in database?
  - [ ] UPDATE content_queue SET status='approved' WHERE id=1
- [ ] Test publishing on Gumroad (1 test product)
- [ ] Test publishing on Etsy (1 test listing)
- [ ] Verify no errors in error_logs

**18:00-23:00: End-to-End Testing**
- [ ] Full cycle: Generate → Approve → Publish → Revenue logged
  - [ ] Trigger content generation
  - [ ] Manually approve content
  - [ ] Trigger publishing
  - [ ] Check platforms (content should appear)
  - [ ] Check revenue_summary (if any sales data available)
- [ ] Error handling: Simulate API failure
  - [ ] Kill Gumroad API access temporarily
  - [ ] Trigger revenue capture
  - [ ] Verify error logged (not silent failure)
- [ ] Documentation complete:
  - [ ] Workflow diagram in markdown
  - [ ] API key locations documented
  - [ ] PostgreSQL schema printed
  - [ ] Troubleshooting guide written

**23:00-23:59: Readiness Verification**
- [ ] All 4 workflows deployed and active
- [ ] No errors in error_logs (or all errors understood)
- [ ] PostgreSQL tables have sample data
- [ ] CFO can run: `SELECT COUNT(*) FROM revenue_summary`
- [ ] COO understands approval workflow
- [ ] CTMO has health check procedure documented
- [ ] Signoff: All roles ready for autonomous operation

---

**Success Criteria (Must-Haves):**
- [ ] Revenue capture tested on ≥2 platforms (data in PostgreSQL)
- [ ] Content generation tested (≥1 sample in content_queue)
- [ ] Publishing tested on ≥1 platform (≥1 product visible on platform)
- [ ] Error handling tested (≥1 error in error_logs, not silent failure)
- [ ] CFO can query revenue without manual SQL
- [ ] COO knows how to approve content
- [ ] CTMO has monitoring procedure documented

---

### 5.2 Zapier Pro Go-Live (March 29-31)

**Day 1 (March 29, 09:00-18:00)**

**09:00-09:30: Account Setup**
- [ ] Create Zapier account (zapier.com signup)
- [ ] Verify email
- [ ] Billing info (credit card)
- [ ] Upgrade to Pro ($29.99/mo)

**09:30-11:30: API Key Setup**
- [ ] Gumroad: Generate API key + test in Postman
- [ ] Etsy: Generate API key + test
- [ ] Redbubble: Check API availability (may need scraping)
- [ ] Medium: Generate API token or RSS URL
- [ ] Stripe: Verify API keys
- [ ] PostgreSQL: Decide on external connection or skip (Zapier can't easily write to self-hosted DB)

**11:30-13:30: Build Zaps 1-3 (Revenue Capture)**
- [ ] Zap #1: Gumroad → PostgreSQL/Webhook
  - [ ] Trigger: On new sale
  - [ ] Action: POST to webhook or write to external DB
  - [ ] Test: Create test sale in Gumroad
  - [ ] Deploy
- [ ] Zap #2: Etsy → PostgreSQL/Webhook (similar)
- [ ] Zap #3: Medium RSS → Webhook (slightly different)

**13:30-15:30: Build Zaps 4-5 (Publishing)**
- [ ] Zap #4: Gumroad product creation
  - [ ] Trigger: Manual or webhook
  - [ ] Action: POST to Gumroad API
  - [ ] Test: Create sample product
  - [ ] Deploy
- [ ] Zap #5: Etsy listing creation (similar)

**15:30-18:00: Testing**
- [ ] Test Zap #1 (Gumroad): Does data arrive?
- [ ] Test Zap #4 (Publishing): Can you create product from Zapier?
- [ ] Review webhook payloads
- [ ] Check Zapier task count (should be ~50-100 so far)

---

**Day 2 (March 30, 09:00-18:00)**

**09:00-11:00: Build Zaps 6-8 (Redbubble, Content Gen)**
- [ ] Zap #6: Redbubble revenue (requires scraping or custom code)
  - [ ] Trigger: Scheduled (daily)
  - [ ] Action: Scrape Redbubble dashboard (risky)
  - [ ] Status: May not be ready in time
- [ ] Zap #7: Content generation (Claude API)
  - [ ] Trigger: Scheduled (daily)
  - [ ] Action: Webhook to Claude API
  - [ ] Status: Needs custom code (not native)
- [ ] Zap #8: Error notifications (email to CTMO)
  - [ ] Trigger: Zap error
  - [ ] Action: Send email

**11:00-13:00: Integration Testing**
- [ ] Test all 8 Zaps for errors
- [ ] Monitor Zapier dashboard for task count
- [ ] Estimate task usage: (revenue checks 2x/day × 30 = 60) + (publishing 20 items × 30 = 600) + (content gen 30) = ~690 tasks ← **Within 750 limit, but tight**

**13:00-15:00: Platform Publishing Tests**
- [ ] Test Gumroad product creation end-to-end
- [ ] Test Etsy listing creation
- [ ] Verify products appear on platforms

**15:00-18:00: Completeness Check**
- [ ] Redbubble integration: **Incomplete** (scraping not proven)
- [ ] Content generation: **Partial** (Claude API needs custom code)
- [ ] Error handling: **Incomplete** (only email, no logging)
- [ ] Database: **Not integrated** (Zapier can't write to self-hosted PostgreSQL easily)

**Day 3 (March 31, Evening)**
- [ ] Last-minute testing of critical paths
- [ ] Zaps ready, but not fully tested
- [ ] Risk: Silent failures in Redbubble capture or content generation

---

**Success Criteria (Must-Haves) — PARTIAL:**
- [ ] ✓ Revenue capture tested on Gumroad + Etsy
- [ ] ✗ Revenue capture NOT tested on Redbubble (incomplete)
- [ ] ✗ Content generation incomplete (needs custom code)
- [ ] ✓ Publishing tested on Gumroad + Etsy
- [ ] ✗ Full error handling incomplete
- [ ] ✗ Database integration incomplete
- [ ] ❌ **NOT ready for hands-off autonomy**

---

### 5.3 Rollback Plan (If Approach Fails)

**For n8n (if workflows crash before March 31):**
1. Identify broken workflow (check error_logs)
2. Revert to previous version (n8n has version history)
3. Fallback: Run revenue capture manually once/day (CSV export from platforms)
4. Fallback: Delay publishing until workflow fixed (April 2)

**For Zapier (if integrations incomplete before March 31):**
1. Keep whatever Zaps are working (Gumroad + Etsy revenue capture)
2. Fallback: Manual publishing for March 31 (COO posts directly)
3. Fallback: Check Redbubble revenue manually (web scraping)
4. Plan: Migrate to n8n in April (don't rely on incomplete Zapier setup)

---

## PART 6: Financial Impact Summary

### 6.1 Year 1 Cost Comparison

| Path | One-Time | Monthly | Year 1 Total | March 31 Ready? |
|------|----------|---------|--------|---|
| **n8n Self-Hosted** | $0 | $0-30* | $50-200 | ✅ YES |
| **Zapier Pro** | $0 | $30-99** | $390-1,225 | ⚠️ PARTIAL |
| **Savings (n8n)** | — | — | **$290-1,025** | — |

*Claude API for content generation
**Zapier Pro ($30) + Team upgrade if task limit hit ($99)

### 6.2 Break-Even Analysis

**If you choose Zapier Pro, when does it cost more than n8n?**

- Month 1: Zapier $30 vs. n8n $0 (Zapier +$30)
- Month 2-12: Zapier $30 × 11 = $330 vs. n8n $0 (Zapier +$330 cumulative)

**If you choose Zapier Team (due to task overages):**
- Month 1-12: Zapier $99 × 12 = $1,188 vs. n8n $0 (Zapier +$1,188)

**n8n becomes cheaper than Zapier by Month 1.** The only reason to choose Zapier is if you don't trust the self-hosted setup or need managed service SLA.

---

## FINAL RECOMMENDATION

### Choose: **n8n Self-Hosted**

**Decision Rationale:**
1. **Timeline:** 36-hour sprint is achievable. Already planned. Zapier timeline is risky.
2. **Cost:** $0/mo vs. $30+/mo. Saves $290-1,025 Year 1.
3. **Autonomy:** Fully autonomous post-March 31. No external monitoring needed.
4. **Scalability:** Unlimited workflows, no task limits. Zapier overflows at Month 2.
5. **Infrastructure:** Docker already running. n8n already deployed.

### If CTMO Unavailable Post-March 31:
Choose **Zapier Team** ($99/mo). Accept $1,200+/year cost for simplicity.

### If You Want Flexibility:
**Hybrid approach (not recommended):**
- Build n8n in 36-hour sprint (March 29-30) as primary plan
- If it fails, fallback to manual revenue capture + Zapier in April
- This gives n8n a shot without betting everything on it

---

**Decision Owner:** CEO
**Financial Owner:** CFO
**Technical Owner:** CTMO
**Execution Owner:** COO

**Next Step:** CEO approves this matrix, CTMO begins n8n deployment (March 29, 14:00).
