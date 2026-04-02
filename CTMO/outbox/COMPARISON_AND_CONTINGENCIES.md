# Zapier Pro vs n8n Self-Hosted: Comparison & Contingency Procedures
## Decision Framework & Risk Analysis

**Status:** DECISION SUPPORT DOCUMENT
**Date:** 2026-03-29
**Purpose:** Help CEO/CTMO choose path and prepare for contingencies
**Timeline Context:** Both paths completed in 36 hours, March 31 deadline

---

## TABLE 1: HEAD-TO-HEAD COMPARISON

| Factor | Zapier Pro ($49/mo) | n8n Self-Hosted ($0-7/mo) |
|--------|-------------------|------------------------|
| **Deployment Time** | 36 hours | 36 hours |
| **Learning Curve** | 30 min (UI-based) | 2 hours (visual builder) |
| **Monthly Cost** | $49 | $0 (self-hosted) / $7 (Railway) |
| **Setup Infrastructure** | None (Zapier hosts) | Docker + PostgreSQL + Railway (optional) |
| **API Integrations** | 6,000+ pre-built connectors | Webhooks + custom HTTP calls |
| **Error Handling** | Built-in, managed by Zapier | CTMO must build, owns reliability |
| **Scaling** | Auto (unlimited tasks) | Manual (depends on server size) |
| **Task Budget** | 5,000/mo (Pro tier) | Unlimited |
| **Rate Limiting** | Zapier manages | CTMO must implement |
| **Monitoring Dashboard** | Zapier UI | n8n UI |
| **Credential Refresh** | Automatic OAuth refresh | CTMO must monitor |
| **Backup & Recovery** | Zapier handles | CTMO must manage |
| **3rd Party Dependency** | Zapier down = system down | Docker + PostgreSQL down = system down |
| **Customization** | Limited (pre-built actions) | Full (visual workflow builder) |
| **Support** | Zapier support team | Community + CTMO self-support |
| **Post-March 31 DevOps** | Zero | 30 min/week monitoring |
| **Risk of Silent Failure** | Low (Zapier alerts) | Medium (must check logs) |
| **Fastest to $10K Goal** | Same | Same |

---

## TABLE 2: WORKFLOW COMPLEXITY ASSESSMENT

### Workflow 1: Client Intake → Invoice

| Aspect | Zapier | n8n |
|--------|--------|-----|
| **Setup Complexity** | Easy (5 pre-built actions) | Medium (manual node setup) |
| **Error Handling** | 3 lines of config | 20 lines of error handlers |
| **Testing Time** | 15 min | 30 min |
| **Ongoing Maintenance** | Minimal | Minimal |

---

### Workflow 2: Digital Product Publishing

| Aspect | Zapier | n8n |
|--------|--------|-----|
| **Setup Complexity** | Easy (file trigger + API calls) | Medium (loop + transform) |
| **Multi-Platform Support** | Easy (add action per platform) | Medium (parallel nodes) |
| **Error Handling** | 2 actions (retry + alert) | 5 nodes (error handler) |
| **Testing Time** | 20 min | 45 min |

---

### Workflow 3: Revenue Capture (Hourly)

| Aspect | Zapier | n8n |
|--------|--------|-----|
| **Complexity** | Medium (parallel branches) | Medium (parallel branches) |
| **Rate Limit Handling** | Manual checking | Built-in counter logic |
| **Database Integration** | Via webhook to PostgreSQL | Direct PostgreSQL node |
| **Testing Time** | 30 min | 45 min |

---

## DECISION MATRIX: WHICH PATH TO CHOOSE?

**Choose ZAPIER PRO if:**
- [ ] You want zero DevOps/infrastructure management
- [ ] You prefer "set it and forget it" (Zapier handles failures)
- [ ] You don't want to monitor Docker/servers post-March 31
- [ ] You have $49/month available
- [ ] You prefer Zapier's managed error handling
- [ ] You want Zapier support team backing you

**Choose n8n SELF-HOSTED if:**
- [ ] You want zero ongoing subscription costs
- [ ] You're comfortable managing Docker containers
- [ ] You want full customization control
- [ ] You have Railway/cloud hosting budget available
- [ ] You want to own your data completely (PostgreSQL on your server)
- [ ] You prefer CTMO managing the system vs external dependency

---

## RISK ASSESSMENT BY PATH

### Zapier Pro: Risk Profile

**Infrastructure Risks: LOW**
- Zapier handles all servers, updates, scaling
- Your only risk: Internet connection down
- Recovery: Internet restored, Zapier catches up

**Operational Risks: LOW**
- Zapier UI is managed, pre-tested
- OAuth token refresh automatic
- Error retry logic built-in
- Worst case: Call Zapier support

**Credential Risks: LOW**
- Tokens stored securely in Zapier
- No plain text in your system
- Zapier encrypts at rest

**Cost Risk: MINIMAL**
- $49/month fixed
- Task budget: 5,000/month (sustainable)
- No surprise overages (hard limit at 5,000)

**Single Point of Failure: ZAPIER SERVICE**
- If Zapier service goes down: 0% uptime
- Probability: <1% monthly (industry standard 99.9%)
- Recovery: Automatic when Zapier back online

---

### n8n Self-Hosted: Risk Profile

**Infrastructure Risks: MEDIUM**
- Docker/PostgreSQL on your machine or Railway
- If Docker crashes: System stops
- If PostgreSQL crashes: Revenue data lost (if no backup)
- Recovery: Restart Docker or restore backup

**Operational Risks: MEDIUM**
- CTMO must monitor logs daily
- CTMO must handle OAuth refresh manually
- CTMO must manage error recovery
- If CTMO unavailable: System may fail silently

**Credential Risks: MEDIUM**
- Tokens stored in n8n environment variables
- Must secure `.env` file
- If `.env` leaked: All tokens compromised

**Cost Risk: LOW-MEDIUM**
- $0-7/month (depending on hosting)
- Unlimited tasks (no surprise caps)
- But: DevOps time has opportunity cost

**Single Point of Failure: DOCKER/POSTGRESQL**
- If Docker down: 0% uptime
- If PostgreSQL corrupt: Revenue data lost
- If n8n process hangs: Workflows stuck
- Recovery: Restart containers or restore backup

**CTMO Availability Risk: HIGH**
- If CTMO not available for maintenance: Issues not fixed
- Post-March 31, user hands-off, CTMO must operate fully autonomously
- If CTMO gets stuck: No human can recover

---

## TABLE 3: FAILURE SCENARIOS & RECOVERY PROCEDURES

### Scenario 1: API Token Expires (Gumroad, Stripe, etc.)

**Zapier:**
- Detection: Automatic
- Recovery: Zapier auto-refreshes OAuth tokens
- Failure mode: If can't refresh, Zap paused, email alert sent
- CFO action: Wait for email, contact CTMO if critical
- Recovery time: <1 minute (auto)

**n8n:**
- Detection: Workflow fails with 401 error
- Recovery: CTMO logs into n8n, re-authenticates credential
- Failure mode: Workflow paused until CTMO fixes
- CFO action: Monitors logs, contacts CTMO if 401 persists
- Recovery time: 5-15 minutes (manual)

---

### Scenario 2: API Rate Limit Hit (Too Many Calls)

**Zapier:**
- Detection: Zapier logs 429 error
- Recovery: Built-in exponential backoff (wait 1 min, retry)
- Failure mode: Delayed execution, no alert unless critical
- CFO action: None (Zapier handles)
- Recovery time: Automatic (1-5 minutes)

**n8n:**
- Detection: HTTP node returns 429
- Recovery: Implemented rate limit check before API call
- Failure mode: Skip cycle, log warning, continue next hour
- CFO action: None (workflow designed to handle)
- Recovery time: Automatic (next execution cycle)

---

### Scenario 3: Database Connection Fails (PostgreSQL Down)

**Zapier:**
- Detection: PostgreSQL webhook returns error
- Recovery: Option A: Wait for DB recovery, Option B: Use Zapier Storage as fallback
- Failure mode: Revenue not logged to PostgreSQL until recovery
- CFO action: Can't query historical data (but can see Zapier logs)
- Recovery time: DB restart (30 sec - 5 min)

**n8n:**
- Detection: PostgreSQL node returns "cannot connect"
- Recovery: Workflow fails, error logged, CFO alerted
- Failure mode: All workflows using PostgreSQL stop
- CFO action: Contacts CTMO, who restarts Docker
- Recovery time: Docker restart (30 sec) + CTMO action (5 min)

---

### Scenario 4: External Service Down (Stripe, Gumroad)

**Zapier:**
- Detection: HTTP returns 5xx error
- Recovery: Zapier retries 3 times, logs error
- Failure mode: Revenue not captured for 1-2 hours until service recovers
- CFO action: Waiting on external service (not CTMO's problem)
- Recovery time: Depends on external service (minutes to hours)

**n8n:**
- Detection: HTTP node returns 5xx error
- Recovery: n8n retries with exponential backoff
- Failure mode: Same as Zapier (revenue not captured)
- CFO action: Same as Zapier
- Recovery time: Same as Zapier

---

### Scenario 5: System Out of Memory / n8n Hangs

**Zapier:**
- Not applicable (Zapier infrastructure)

**n8n:**
- Detection: Workflow not executing for 2+ hours
- Recovery: CTMO restarts n8n container
- Failure mode: No workflows execute until restart
- CFO action: Notices no revenue captured, contacts CTMO
- Recovery time: 1-2 minutes (restart) + CTMO awareness (5-30 min)

---

### Scenario 6: Email Service Down (Gmail / Outlook)

**Zapier:**
- Detection: Email send fails
- Recovery: Zapier logs error, shows in dashboard
- Failure mode: CFO doesn't get daily report email
- CFO action: Logs into Zapier dashboard to see data manually
- Recovery time: Email service recovers (minutes) or CTMO switches to alternative email

**n8n:**
- Detection: Email node returns error
- Recovery: Email handler logs error, triggers alert (to another email)
- Failure mode: Email alert itself fails (cascading failure possible)
- CFO action: Monitors n8n dashboard, queries DB directly
- Recovery time: Email service recovers or CTMO uses alternative

---

### Scenario 7: Ransomware / Data Corruption

**Zapier:**
- Risk: Low (Zapier encrypts data, backups managed by Zapier)
- Recovery: Zapier restores from backup
- CFO action: Contact Zapier support
- Recovery time: Hours to days

**n8n:**
- Risk: Medium (if `.env` leaked, tokens compromised; if DB corrupted, data lost)
- Recovery: Restore from PostgreSQL backup
- CFO action: Contact CTMO, who restores from backup
- Recovery time: 5-30 minutes (if backup available)

---

## CONTINGENCY PROCEDURES: EXECUTION PLAYBOOK

### IF ZAPIER DEPLOYMENT FAILS (During 36-hour sprint)

**Hour 10: Zapier account not upgrading to Pro**
1. Verify payment method accepted
2. Use alternative payment method
3. If upgrade fails: Use Free tier (2,000 tasks)
   - Consequence: Can only run 2-3 workflows
   - Mitigation: Prioritize Revenue Capture + CFO Report only

**Hour 14: Gumroad OAuth won't connect**
1. Verify Gumroad account has API access
2. Regenerate Gumroad API token
3. Try alternative: Use API token instead of OAuth
4. If fails: Manual API request workaround (curl in separate automation)

**Hour 20: PostgreSQL won't connect from Zapier**
1. Verify database credentials correct
2. Verify database running (docker ps)
3. Verify firewall allows localhost:5432
4. Fallback: Use Zapier Storage tables instead of PostgreSQL (less scalable but works)

**Hour 28: Not enough time to finish all 5 workflows**
1. Prioritize: W1 (revenue) > W3 (reporting) > W2 (publishing) > W4 (monitoring)
2. Deploy what's ready at Hour 36
3. Add remaining workflows in post-launch window (April 1-5)

---

### IF N8N DEPLOYMENT FAILS (During 36-hour sprint)

**Hour 2: Docker services won't start**
1. Check Docker running: `docker --version`
2. If not: Install/start Docker Desktop
3. If error: `docker compose down && docker compose up -d`
4. If still fails: Check logs: `docker compose logs`
5. Last resort: Deploy n8n on Railway (cloud) instead of local Docker
   - Timeline: 1 hour additional (Railway setup)

**Hour 3: PostgreSQL won't initialize**
1. Verify postgresql.conf correct
2. Verify volume mounted: `docker ps | grep postgres`
3. Restart: `docker compose down postgres && docker compose up -d postgres`
4. Wait 30 sec, check health: `docker logs mm-postgres`
5. Fallback: Use managed PostgreSQL (Railway, AWS RDS)
   - Timeline: 30 min additional (account setup + migration)

**Hour 6: n8n UI not loading**
1. Check n8n container running: `docker ps | grep n8n`
2. Check port 5678 available: `netstat -an | grep 5678`
3. If port in use: `docker compose down n8n && docker compose up -d n8n`
4. If still fails: Try different port (5679)
   - Edit docker-compose.yml: `5679:5678`

**Hour 12: Workflow execution timing out (Claude API slow)**
1. Reduce content generation batch size
2. Increase timeout: Set HTTP node timeout to 60 sec (instead of 30)
3. Fallback: Pre-generate content manually, n8n just publishes
   - Timeline: Same, just less automation

**Hour 20: PostgreSQL queries too slow**
1. Add indexes:
   ```sql
   CREATE INDEX idx_revenue_timestamp ON revenue_summary(timestamp);
   CREATE INDEX idx_content_status ON content_queue(status);
   ```
2. If still slow: Archive old data
   ```sql
   CREATE TABLE revenue_summary_archive AS
   SELECT * FROM revenue_summary WHERE timestamp < NOW() - INTERVAL '30 days';
   DELETE FROM revenue_summary WHERE timestamp < NOW() - INTERVAL '30 days';
   ```

**Hour 28: Not enough time to finish all 5 workflows**
1. Prioritize: W1 (revenue) > W3 (publishing) > W2 (generation) > W4 (monitoring)
2. Deploy core workflows at Hour 36
3. Add remaining in post-launch (April 1-5)

---

### IF DECISION IS IMPOSSIBLE (Can't Choose by Hour 0)

**Hybrid Approach: Parallel Deployment (72 hours instead of 36)**

1. **Hours 0-36:** Deploy Zapier Pro (lower risk path)
2. **Hours 36-72 (April 1-2):** Deploy n8n as backup
3. **April 3 onwards:** Run both in parallel, test, then choose one

**Advantage:** Can prove both work before committing
**Disadvantage:** Takes 72 hours instead of 36 (but user still hands off March 31)
**Mitigation:** Automate parallel operation, CFO verifies both generate same revenue numbers

---

## DECISION FLOW CHART

```
START: Choose Zapier or n8n?
│
├─ QUESTION 1: Do you want zero DevOps/infrastructure management?
│  ├─ YES: ZAPIER PRO
│  └─ NO: Continue to Q2
│
├─ QUESTION 2: Do you have $49/month available?
│  ├─ NO: n8n (ZERO cost option)
│  ├─ YES: Continue to Q3
│
├─ QUESTION 3: Do you trust CTMO to manage Docker/PostgreSQL post-March 31?
│  ├─ NO: ZAPIER PRO (let Zapier manage)
│  ├─ YES: Continue to Q4
│
├─ QUESTION 4: Do you want 100% data ownership (PostgreSQL on your server)?
│  ├─ YES: n8n SELF-HOSTED
│  ├─ NO: ZAPIER PRO
│
└─ DECISION MADE
```

---

## QUICK REFERENCE: CHOOSE IF...

**ZAPIER PRO** if you value:
- Simplicity + managed service
- Zero infrastructure maintenance
- Zapier support + error handling
- Don't mind $49/month cost
- Want Zapier to handle failures

**n8n SELF-HOSTED** if you value:
- Zero subscription cost
- Full control over workflows
- Data ownership (PostgreSQL on your server)
- Willing to manage Docker/logs
- Want unlimited workflow capacity

---

## POST-LAUNCH MONITORING CHECKLIST

### Daily (CFO 5 min)
- [ ] Revenue email received (8 AM)
- [ ] Data looks reasonable (not $0, not $999,999)
- [ ] No critical errors in error_log

### Weekly (CTMO 15 min) — For n8n only
- [ ] Check n8n execution logs (Executions tab)
- [ ] Verify all workflows executed successfully
- [ ] Check PostgreSQL disk space
- [ ] Verify backups completed

### Monthly (CTMO 30 min) — For n8n only
- [ ] Database maintenance (ANALYZE, VACUUM)
- [ ] Review infrastructure costs
- [ ] Archive old execution logs
- [ ] Update documentation

---

## ESCALATION PROCEDURES

### Revenue Not Captured (0 dollars for 2+ hours)

**Immediate Actions (CTMO):**
1. Check if Gumroad/Stripe has actual sales
   - If no sales: This is correct (revenue is 0)
   - If sales exist: Continue debugging
2. Check if workflow executed (Zapier/n8n dashboard)
   - If not executed: Check trigger time, schedule
   - If executed with error: Check error message

**If using Zapier:**
1. Log into Zapier → Task History
2. Look for revenue capture Zap
3. Check if it ran, if it succeeded, if API returned data
4. If error: Click error for details, fix, re-run

**If using n8n:**
1. Log into n8n → Executions
2. Click W1_Revenue_Capture_Hourly
3. Click latest execution
4. Check nodes: which one failed?
5. Click node → see error details
6. Fix error (usually API auth or DB connection)
7. Execute workflow manually to test

---

### Email Alert Not Received

**Check:**
1. Is email address correct in config?
2. Is email service (Gmail/Outlook) working?
3. Check spam folder (might be there)
4. Check if email workflow even ran

**Reset Email:**
- Zapier: Re-authenticate email credential
- n8n: Re-authenticate email credential

---

### Database Query Failing

**Check:**
1. Is PostgreSQL running? `docker ps | grep postgres`
2. Can you connect? `psql -h localhost -U makinmoves -d makinmoves -c "SELECT 1;"`
3. Do tables exist? `\dt` (in psql)

**If tables missing:**
- Re-run initialization: `psql -h localhost -U makinmoves -d makinmoves -f init-db.sql`

---

## FINAL RECOMMENDATION

**For March 31 Hands-Off Scenario:**

**RECOMMEND: Zapier Pro**

**Rationale:**
- User hands-off March 31 → need zero human intervention
- Zapier handles all infrastructure → lower failure risk
- OAuth auto-refresh → no token management needed
- Zapier alerts on failure → visible to CFO
- $49/month << risk of system failure in autonomous mode
- CTMO burden post-March 31 is minimal (just monitor Zapier dashboard)

**Alternative: n8n + Railway Hosting**
- If cost is critical constraint ($49/month too much)
- But requires CTMO to monitor and maintain
- Higher risk of silent failure
- Only choose if CTMO commits to 30 min/week monitoring

**Not Recommended: n8n on local Docker**
- Too risky if user's machine crashes
- User won't be there to restart it (hands-off March 31)
- Only viable if deployed to cloud (Railway, Heroku)

---

**Status:** DECISION FRAMEWORK COMPLETE
**Next Step:** CEO chooses path, notify CTMO to execute chosen playbook

---

*Prepared by: CTMO*
*For: CEO/CFO Decision Review*
*Date: 2026-03-29*
