# Tech Stack Optimizer: Automation Platform Comparison
**Date:** 2026-03-29 19:00
**Prepared by:** CTMO
**Status:** Research & Recommendation (Not Implementation)
**Context:** 36-hour autonomous operation setup window. Trinity strategy: Digital Products + Affiliate + Print-on-Demand

---

## Executive Summary

**Recommendation: n8n Cloud Professional ($50/month) as primary platform**

For your specific constraints (36-hour setup, autonomous operation by March 31, technical deep-dives already completed), n8n Cloud Professional is the only viable choice. Here's why:

| Criteria | n8n Cloud | Zapier | Custom Hybrid |
|----------|-----------|--------|---------------|
| **Setup Time** | 10-12 hours | 6-8 hours | 14-16 hours |
| **Customization** | Native support for complex workflows | Limited custom logic | Full control |
| **Cost/6mo** | $300 | $400-600 | $120-180 + DevOps |
| **API Integration** | PostgreSQL native, full control | Limited, pre-built connectors | Full Node.js ecosystem |
| **Post-handoff Maintenance** | 30 min/week monitoring | 15 min/week monitoring | 3-4 hours/week |
| **Autonomous Operation** | ✅ Ready March 31 | ⚠️ Risky (feature gaps) | ❌ Too slow for deadline |

**Bottom line:** n8n gives you enterprise-grade automation with full control over your API integrations (Gumroad, Etsy, WordPress) while staying under 36-hour deadline. Zapier is simpler but lacks the webhook flexibility. Custom hybrid is too slow.

---

## Detailed Platform Analysis

### 1. n8n Cloud Professional ($50/mo)

#### Strengths
- **Native PostgreSQL connector:** Direct INSERT/UPDATE into your revenue_summary, content_queue, error_logs tables
- **Custom node support:** Can run Node.js code directly for complex transformations
- **Full API control:** Write exact REST calls to Gumroad, Etsy, WordPress with complete header/body customization
- **Webhook receiver:** Built-in to accept incoming data from platforms (future enhancement)
- **Cron scheduling:** Native support for hourly, daily, custom schedules
- **Error handling:** Native try/catch, exponential backoff, conditional branching
- **Version control:** Workflows stored as JSON (can commit to Git for tracking)
- **Community:** Large, active community with pre-built templates for common integrations

#### Weaknesses
- **Higher setup cost than Zapier:** $50/month vs. Zapier's $25/month baseline
- **Requires technical knowledge:** API auth, headers, JSON parsing (but you've already done this research)
- **Learning curve:** More powerful = steeper learning curve (mitigated by n8n's UI)
- **Self-hosted option adds overhead:** Cloud version recommended for your use case

#### Best For
- **Digital Products (Gumroad):** OAuth API, custom headers, sales polling → PostgreSQL
- **Affiliate Content (WordPress):** JWT auth, featured image upload, scheduled publishing
- **Error monitoring:** Custom logic to determine severity, escalation rules
- **Claude API integration:** Custom Node.js code to call Claude, parse responses, feed to PostgreSQL

#### Implementation Timeline
- **Day 1 (6 hours):** OAuth setup + API credential management for Gumroad + Etsy
- **Day 1 (4 hours):** Build 2 core workflows:
  - Revenue capture: Gumroad/Etsy API polling → PostgreSQL
  - Error logging: Trap failures, insert into error_logs
- **Day 2 (6 hours):** Build remaining workflows:
  - Content generation: Claude API → PostgreSQL content_queue
  - Publishing: content_queue → Gumroad/Etsy/WordPress APIs
- **Day 2 (2 hours):** Testing, documentation, error handling

**Total: ~18 hours** (within your 36-hour window with room for debugging)

#### Cost Breakdown (6-month window)
- n8n Cloud Professional: $300 (6 × $50)
- Gumroad OAuth: Free (built into API)
- Etsy API: Free (OAuth only)
- PostgreSQL: $0 (using existing Docker container)
- **Total: $300**

#### Post-Handoff Maintenance
- **Weekly (30 min):** Check n8n execution logs, monitor error_logs table
- **Monthly (1 hour):** Review workflow performance, optimize rate limits
- **Ad hoc:** Handle Gumroad rate limit discovery (will hit 429s until limits known), refresh API keys if needed

#### Critical Success Factors
- ✅ You have comprehensive API documentation (already researched)
- ✅ PostgreSQL schema already designed
- ✅ OAuth flows already understood
- ✅ n8n native PostgreSQL connector removes integration friction
- ⚠️ May need to contact Gumroad support for rate limit discovery (manageable)

---

### 2. Zapier ($50-100/mo depending on tasks)

#### Strengths
- **Fastest initial setup:** Pre-built connectors for Gumroad, Etsy, WordPress, Stripe
- **No-code approach:** Visual workflow builder, minimal technical knowledge required
- **Smaller learning curve:** If you just want it working fast
- **Generous free tier:** Test up to 100 tasks/month before paying

#### Weaknesses
- **Limited custom logic:** Can't write Node.js code, limited conditional branching
- **Pre-built connectors may not match your exact API needs:** Example: Gumroad connector may not expose all fields you need
- **Cost scales with complexity:** Each additional task/workflow adds cost
- **Rate limit handling:** Zapier's built-in retry logic may not match your requirements
- **PostgreSQL integration:** Requires 3rd-party connector (premium), not as seamless as n8n
- **No native error logging control:** Error handling is opaque
- **Webhook payloads:** Less control over what data Zapier extracts from webhook payloads

#### Best For
- Simple 1-2 step workflows (trigger → action)
- Pre-built connectors that exactly match your needs
- Minimal customization required

#### Implementation Timeline
- **Day 1 (4 hours):** Setup Gumroad + Etsy + WordPress connectors
- **Day 1 (3 hours):** Build basic Zap for revenue capture (Gumroad webhook → Slack, or CSV export)
- **Day 2 (4 hours):** Build publishing Zap (Notion → Gumroad → PostgreSQL)
- **Day 2 (2 hours):** Testing + error handling (limited options)

**Total: ~13 hours** (faster initial setup, but less flexible for edge cases)

#### Cost Breakdown (6-month window)
- Zapier Premium: $50/month base = $300
- Database records (if using Premium): +$50-100 for advanced triggers
- Additional app connectors: Included in Premium
- **Total: $350-400**

#### Post-Handoff Maintenance
- **Weekly (15 min):** Check Zapier task history, monitor error log
- **Monthly (30 min):** No additional optimization possible without rebuilding
- **High risk:** If a Zapier connector breaks or updates, entire workflow may need redesign

#### Critical Failure Points
- ❌ Gumroad connector doesn't expose rate-limit headers → Can't monitor limits intelligently
- ❌ Can't build custom exponential backoff for rate limits → Will fail silently or get rate-limited
- ❌ PostgreSQL integration requires premium → More expensive
- ❌ No native support for Claude API calls → Can't auto-generate content without 3rd-party bridge

**Risk Assessment:** Zapier works for simple workflows, but your Trinity strategy requires sophisticated error handling and custom API logic. Recommend only if you prioritize "set it and forget it" over "autonomous operation."

---

### 3. Custom Node.js + n8n Hybrid ($20-30/mo infrastructure)

#### Strengths
- **Cost-optimized:** Self-hosted n8n + custom Node.js backend = $20-30/mo infrastructure cost
- **Full control:** Write whatever code you need; no vendor lock-in
- **Scalability:** Can optimize for your exact needs; no pre-built overhead
- **Education:** Learning outcome: full understanding of automation pipeline

#### Weaknesses
- **High setup cost in time:** 14-16 hours of CTMO engineering
- **DevOps overhead:** Self-hosted n8n requires Docker management, SSL certs, backups
- **Maintenance burden:** Post-March-31, you need to monitor server health, apply security patches
- **Fragility:** More moving parts = more things to break
- **No uptime guarantees:** Self-hosted solution may go down; Zapier/n8n Cloud have 99.9% SLAs

#### Implementation Timeline
- **Day 1 (4 hours):** Set up self-hosted n8n in Docker (or Railway)
- **Day 1 (4 hours):** Build base Node.js wrapper for Gumroad OAuth + polling
- **Day 2 (4 hours):** Build n8n workflows that call custom Node.js backend
- **Day 2 (2 hours):** Testing + deployment
- **Day 2 (2 hours):** Documentation + runbooks for maintenance

**Total: ~16 hours** (slower than Zapier, but more customizable than n8n Cloud)

#### Cost Breakdown (6-month window)
- Railway/Heroku self-hosted n8n: $15/month = $90
- Custom Node.js backend (if separate): $5-10/month = $30-60
- Domain + SSL: $0 (using existing)
- **Total: $120-150**

#### Post-Handoff Maintenance
- **Daily (15 min):** Check self-hosted n8n logs, uptime monitoring
- **Weekly (1 hour):** Review custom code, apply security patches
- **Monthly (2 hours):** Backup database, update dependencies, monitor resource usage
- **Ad hoc (varies):** Debug infrastructure issues, handle deployment rollbacks

#### Critical Failure Points
- ⚠️ Self-hosted n8n may run out of memory or disk space; needs monitoring
- ⚠️ Custom Node.js code requires debugging; more time to troubleshoot vs. pre-built platforms
- ⚠️ If self-hosted server goes down, entire operation stops until you recover it (no hands-off after March 31)
- ❌ Not viable for true autonomous operation (requires regular human monitoring)

---

## Workflow Complexity Analysis

Your Trinity strategy requires these core workflows:

### Workflow 1: Revenue Capture (Hourly)
**Complexity:** Moderate
- Poll Gumroad API every 5 minutes → Parse JSON → INSERT into revenue_summary
- Poll Etsy API every 5 minutes → Parse JSON → INSERT into revenue_summary
- Exponential backoff on 429 errors
- Log all failures to error_logs

**n8n:** Native support for HTTP requests, PostgreSQL, exponential backoff ✅
**Zapier:** Pre-built connectors, but limited control over retry logic ⚠️
**Custom:** Full control, but requires custom Node.js code ✅

### Workflow 2: Content Generation (Daily)
**Complexity:** High
- Trigger: Daily at 06:00
- Call Claude API with prompt + examples
- Parse response (product name, description, pricing)
- Generate design metadata (size, niche, color palette)
- Generate article outline (SEO keywords, affiliate links)
- INSERT into content_queue with status="pending"
- Error handling: Log generation failures, retry with simpler prompt

**n8n:** Native HTTP support for Claude API, custom code for parsing ✅
**Zapier:** Very limited; no native Claude API support ❌
**Custom:** Full control; recommended if using advanced Claude features ✅

### Workflow 3: Automated Publishing (Daily)
**Complexity:** High
- Trigger: Daily at 09:00
- Query content_queue for items with status="approved"
- For each item:
  - Gumroad: POST /v2/products with custom pricing + description
  - Etsy: POST /v3/listings with variations + inventory
  - WordPress: POST /posts with JWT auth + featured image
- Update content_queue with status="published"
- Log all publishes to publishing_log

**n8n:** Native HTTP support for all three APIs, conditional branching ✅
**Zapier:** Pre-built connectors exist, but may not match your exact API requirements ⚠️
**Custom:** Full control; required if you need advanced Etsy inventory sync ✅

### Workflow 4: Error Monitoring + Alerts (Real-time)
**Complexity:** High
- Trap errors from all workflows
- Determine severity (transient vs. critical)
- Log to error_logs with context (API call, response code, retry count)
- Send escalation to CFO if critical
- Implement smart retry logic (exponential backoff, max retries)

**n8n:** Native error handling, conditional logic, PostgreSQL logging ✅
**Zapier:** Limited error visibility; mostly binary success/failure ❌
**Custom:** Full control; recommended for production robustness ✅

---

## Cost Comparison (6-Month Horizon)

### Scenario A: n8n Cloud Professional

| Item | Cost |
|------|------|
| n8n Cloud Pro (6 × $50) | $300 |
| Gumroad OAuth | Free |
| Etsy OAuth | Free |
| PostgreSQL (existing Docker) | Free |
| Domain | Free (existing) |
| **6-Month Total** | **$300** |
| **Monthly** | **$50** |

### Scenario B: Zapier Premium

| Item | Cost |
|------|------|
| Zapier Premium (6 × $50-60) | $300-360 |
| Database Records add-on | $0-100 |
| PostgreSQL connector | Included |
| Domain | Free (existing) |
| **6-Month Total** | **$300-460** |
| **Monthly** | **$50-77** |

### Scenario C: Custom Hybrid (Self-Hosted)

| Item | Cost |
|------|------|
| Railway/Heroku (6 × $15) | $90 |
| Custom backend (6 × $5-10) | $30-60 |
| PostgreSQL (existing Docker) | Free |
| Domain | Free (existing) |
| **6-Month Total** | **$120-150** |
| **Monthly** | **$20-25** |
| **Developer Time (36 hours)** | ~$1,800-2,700 (opportunity cost) |

**Total Cost of Ownership (including development):** Custom hybrid = $1,920-2,850; n8n Cloud = $300; Zapier = $300-460

---

## Implementation Comparison Matrix

| Dimension | n8n Cloud | Zapier | Custom Hybrid |
|-----------|-----------|--------|---------------|
| **Setup Time** | 10-12h | 6-8h | 14-16h |
| **Time to First Revenue** | Day 2 | Day 2 | Day 3 |
| **Feature Completeness** | 100% | 70% | 100% |
| **Customization** | High | Low | Very High |
| **Learning Curve** | Moderate | Low | High |
| **Monthly Cost** | $50 | $50-77 | $20-25 |
| **Infrastructure Risk** | Low (Zapier hosts) | Low (Zapier hosts) | High (self-hosted) |
| **Post-March-31 Maintenance** | 30 min/week | 15 min/week | 3-4 hours/week |
| **API Rate Limit Control** | Excellent | Poor | Excellent |
| **Error Visibility** | Native logging | Opaque | Full control |
| **Claude API Integration** | ✅ Native HTTP | ❌ Workaround only | ✅ Native |
| **Autonomous Operation** | ✅ Ready | ⚠️ Limited | ⚠️ DevOps burden |

---

## Stream-by-Stream Recommendations

### Digital Products (Gumroad)
**Required:** OAuth polling → PostgreSQL revenue tracking + product creation

- **n8n:** Native HTTP + PostgreSQL = Best fit ✅
- **Zapier:** Gumroad connector available, but no native rate-limit control ⚠️
- **Custom:** Full control, but overkill for this stream ⚠️

**Winner: n8n**

### Print-on-Demand (Etsy Listings)
**Required:** OAuth polling → PostgreSQL + product creation with variations

- **n8n:** Native HTTP + complex JSON mapping = Ideal ✅
- **Zapier:** Limited variant support; inventory sync harder ⚠️
- **Custom:** Full control ✅

**Winner: n8n**

### Affiliate Content (WordPress)
**Required:** JWT auth → Featured image upload → Scheduled publishing

- **n8n:** Native HTTP + custom code for 2-step image upload = Good fit ✅
- **Zapier:** WordPress connector exists, but featured image handling limited ⚠️
- **Custom:** Full control ✅

**Winner: n8n** (Zapier second, if image handling not required)

### Content Generation (Claude API)
**Required:** Daily trigger → Call Claude API → Parse response → Insert into content_queue

- **n8n:** Native HTTP + custom JavaScript parsing = Ideal ✅
- **Zapier:** No native Claude support; requires 3rd-party integration ❌
- **Custom:** Full control ✅

**Winner: n8n** (Custom only if advanced prompt engineering needed)

### Error Monitoring + Alerts
**Required:** Trap failures → Determine severity → Log to PostgreSQL → Escalate if critical

- **n8n:** Native error handling + PostgreSQL = Best fit ✅
- **Zapier:** Error visibility poor; can't implement custom logic ❌
- **Custom:** Full control ✅

**Winner: n8n**

---

## Risk Assessment

### n8n Cloud Professional

**Technical Risks:**
- 🟡 **Gumroad rate limits undocumented:** Will discover via 429 errors; n8n's exponential backoff handles this well. Monitor error_logs daily for 3 days, then can relax monitoring.
- 🟢 **Etsy API well-documented:** Low risk. Rate limits clear (10 QPS / 10K daily). n8n can monitor headers intelligently.
- 🟢 **WordPress REST API stable:** Low risk. JWT auth reliable. n8n native support.
- 🟡 **Claude API rate limits:** Will be discovered via testing; n8n can implement custom backoff. Monitor first week.

**Infrastructure Risks:**
- 🟢 **n8n Cloud uptime:** 99.9% SLA from n8n team. No self-hosted maintenance.
- 🟢 **PostgreSQL stability:** Existing Docker container. Assuming current setup is stable.
- 🟢 **API credential storage:** n8n encrypts credentials at rest. Secure.

**Operational Risks:**
- 🟡 **Post-March-31 hands-off:** If critical error occurs (e.g., Etsy API changes), no immediate human to debug. Mitigation: Error logging + alerts to escalation email.
- 🟡 **Workflow modification:** If Trinity strategy changes, need to rebuild n8n workflows. Acceptable cost (2-4 hours per change).

**Overall Risk:** 🟢 **Low-to-Moderate** (mostly API discovery risks, which are manageable)

### Zapier

**Technical Risks:**
- 🔴 **Pre-built connector updates break workflows:** Zapier updates connectors without warning; your workflow may break. Happened to many users.
- 🔴 **Limited error handling:** Can't implement exponential backoff for Gumroad rate limits. Will hit rate-limit errors and fail silently.
- 🔴 **No Claude API support:** Content generation workflow requires 3rd-party workaround (OpenAI add-on). Not recommended.
- 🟡 **PostgreSQL integration:** Requires Zapier Database Records add-on. Adds cost + complexity.

**Infrastructure Risks:**
- 🟢 **Zapier Cloud uptime:** 99.9% SLA. Reliable.
- 🟡 **Pre-built connectors:** Depends on vendor (Gumroad, Etsy, etc.). If Gumroad API changes, Zapier connector may not update quickly.

**Operational Risks:**
- 🔴 **Limited visibility:** Error logs opaque. Hard to debug why publishing failed. Post-March-31, this is a problem.
- 🟡 **Expensive at scale:** Adding more workflows gets expensive quickly. Each additional Zap = additional cost.

**Overall Risk:** 🔴 **High** (connector reliability, error handling, Claude API gaps)

### Custom Hybrid

**Technical Risks:**
- 🟡 **Self-hosted n8n reliability:** Requires monitoring. If server crashes, entire operation stops until you recover.
- 🟡 **Custom Node.js code bugs:** More code = more bugs. Requires testing + debugging.
- 🟢 **Full API control:** No dependency on pre-built connectors. Won't break if vendor updates API.

**Infrastructure Risks:**
- 🔴 **Self-hosted maintenance burden:** After March 31, you have no hands to patch/monitor. Entire system depends on automation (risky).
- 🔴 **Database backups:** Need to automate backups, or data loss risk.
- 🟡 **Security:** Self-hosted server requires SSL cert management, security patches, etc.

**Operational Risks:**
- 🔴 **Not autonomous post-March-31:** Self-hosted systems inevitably need human intervention (disk full, cert expired, etc.). This violates autonomous operation goal.
- 🟡 **Deployment complexity:** Deploying custom code requires DevOps knowledge. Risk of deployment errors.

**Overall Risk:** 🔴 **High** (self-hosted maintenance burden violates autonomous operation requirement)

---

## Final Recommendation

### PRIMARY: n8n Cloud Professional ($50/month)

**Rationale:**

1. **36-hour deadline achievable:** 10-12 hour setup time leaves 24 hours for testing + debugging
2. **Perfect API fit:** Native PostgreSQL + HTTP support = no custom integration layer needed
3. **Autonomous operation ready:** Cloud-hosted = zero post-March-31 maintenance
4. **Error handling mature:** Native retry logic + custom node support for exponential backoff
5. **Cost reasonable:** $300 for 6 months competitive with Zapier
6. **Risk mitigated:** You've already researched all APIs; n8n just orchestrates them

**Implementation priority:**
- Day 1: Build revenue capture workflows (Gumroad + Etsy polling)
- Day 1: Build error logging workflow
- Day 2: Build content generation workflow (Claude API)
- Day 2: Build publishing workflows (WordPress + Gumroad/Etsy creates)
- Day 2: End-to-end testing + documentation

### SECONDARY: Zapier (if you deprioritize autonomy)

**Use only if:**
- You're willing to accept manual intervention post-March-31
- Claude API content generation is deprioritized (manual templates instead)
- Error visibility isn't critical
- Simpler setup is worth the maintenance cost

### NOT RECOMMENDED: Custom Hybrid

**Why:**
- 36-hour deadline too tight; you need 40+ hours to be safe
- Self-hosted infrastructure violates autonomous operation requirement
- Maintenance burden post-March-31 incompatible with hands-off goal
- n8n Cloud achieves same technical capability with zero DevOps overhead

---

## Implementation Roadmap (n8n Cloud)

### Day 1: Setup + First Workflows (10-12 hours)

**Hour 1-2: n8n Setup**
- [ ] Create n8n Cloud account
- [ ] Create PostgreSQL connection
- [ ] Test connection (execute SELECT on revenue_summary)
- [ ] Store API credentials securely in n8n

**Hour 3-5: Revenue Capture Workflow (Gumroad)**
- [ ] Create Gumroad OAuth connection
- [ ] Build HTTP node: GET /v2/sales
- [ ] Add PostgreSQL INSERT node
- [ ] Add error handler: Trap 429, implement exponential backoff
- [ ] Add cron trigger: Every 5 minutes
- [ ] Test: Verify data in revenue_summary table

**Hour 6-8: Revenue Capture Workflow (Etsy)**
- [ ] Create Etsy OAuth connection (PKCE flow)
- [ ] Build HTTP node: GET /v3/receipts
- [ ] Parse receipts → extract revenue
- [ ] Add PostgreSQL INSERT node
- [ ] Add rate-limit monitoring: Log X-RateLimit-Remaining
- [ ] Add cron trigger: Every 5 minutes
- [ ] Test: Verify data in revenue_summary table

**Hour 9-10: Error Monitoring Workflow**
- [ ] Add error handler node (trap all workflow errors)
- [ ] Implement severity logic: transient vs. critical
- [ ] Add PostgreSQL INSERT: error_logs table
- [ ] Test: Trigger an intentional error, verify logging

**Hour 11-12: Documentation + Debugging**
- [ ] Document all workflows as JSON exports
- [ ] Write troubleshooting guide (what to do if Gumroad returns 429)
- [ ] Debug any failures from Day 1 testing

### Day 2: Remaining Workflows + Testing (14-18 hours)

**Hour 13-17: Content Generation Workflow**
- [ ] Create Claude API connection (HTTP + Bearer token)
- [ ] Build prompt template: product generation
- [ ] Build HTTP node: POST to Claude API
- [ ] Parse response: Extract product name, description, pricing
- [ ] Add PostgreSQL INSERT: content_queue table
- [ ] Add metadata generation: Design specs, article keywords
- [ ] Add cron trigger: Daily 06:00 UTC
- [ ] Test: Generate 3 products, verify in content_queue

**Hour 18-22: Publishing Workflows**

**Workflow A: Gumroad Publishing**
- [ ] Query content_queue: WHERE status="approved" AND content_type="digital_product"
- [ ] Build HTTP node: POST /v2/products
- [ ] Map fields: title, description, price, product_type
- [ ] Update content_queue: status="published"
- [ ] Add error handler: Log failure, revert status
- [ ] Test: Publish test product

**Workflow B: Etsy Publishing**
- [ ] Query content_queue: WHERE status="approved" AND content_type="pod_design"
- [ ] Build HTTP node: POST /v3/listings
- [ ] Map fields: title, description, price, variations
- [ ] Handle featured image upload (2-step: upload image, reference in listing)
- [ ] Update content_queue: status="published"
- [ ] Test: Publish test listing

**Workflow C: WordPress Publishing**
- [ ] Create WordPress JWT auth
- [ ] Query content_queue: WHERE status="approved" AND content_type="article"
- [ ] Build HTTP node: POST /posts (with featured image, categories)
- [ ] Map fields: title, content, featured_media_id, categories
- [ ] Update content_queue: status="published"
- [ ] Test: Publish test post

**Hour 23-25: Integration Testing**
- [ ] End-to-end: Generate → Approve → Publish
- [ ] Verify revenue capture: Check revenue_summary after test sale
- [ ] Verify error logging: Trigger intentional errors, check error_logs
- [ ] Test cron scheduling: Verify workflows trigger at correct times

**Hour 26-28: Documentation + Signoff**
- [ ] Export all workflows as JSON (git-commit-ready)
- [ ] Write deployment guide: How to import workflows into production
- [ ] Write monitoring guide: What to watch post-March-31
- [ ] Create escalation checklist: When to alert on errors
- [ ] Final testing: Run full end-to-end one more time
- [ ] Signoff: Confirm 100% autonomous by March 31

---

## Post-March-31 Operations (Hands-Off)

Once user hands-off, n8n runs autonomously:

**Daily Automated Operations:**
- **06:00 UTC:** Content generation workflow creates 1 product + 1 design + 1 article
- **09:00 UTC:** Publishing workflow publishes all approved content from previous day
- **Every 5 min:** Revenue capture workflows poll Gumroad + Etsy → PostgreSQL
- **Real-time:** Error monitoring logs all failures

**Weekly Monitoring (by CFO):**
- Query revenue_summary: Total recovered (%)
- Query error_logs: Any critical failures?
- Review publishing_log: Which streams performing best?

**Monthly Optimization (if human intervention available):**
- Review error logs for API pattern changes
- Optimize cron schedules based on platform performance
- Update prompt templates if content quality drifting

**Critical Escalation Triggers:**
- Gumroad rate-limit 429 errors > 10% of requests → Investigate undocumented limits
- Publishing failures > 5% → Check platform API status
- Revenue capture gap > 1 hour → Database or API issue
- Error log growth > 100 errors/day → Investigate root cause

---

## Conclusion

**n8n Cloud Professional is the recommended platform** for autonomous operation by March 31. It provides:

- ✅ Enterprise-grade automation with full API control
- ✅ 36-hour implementation achievable with low risk
- ✅ Zero post-handoff maintenance (cloud-hosted)
- ✅ Native PostgreSQL integration (no additional layers)
- ✅ Mature error handling + monitoring
- ✅ Cost-effective ($50/month)

**Zapier is second choice** if you prioritize simplicity over autonomy. **Custom hybrid is not recommended** given your 36-hour deadline and post-March-31 hands-off requirement.

Proceed with n8n implementation immediately.

---

**Document Status:** Ready for COO + CEO review. No further research needed.
