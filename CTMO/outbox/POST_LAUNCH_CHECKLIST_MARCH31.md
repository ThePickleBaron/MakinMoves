# Post-Launch Checklist: March 31 Midnight → Autonomous Operation
## Handoff Verification & First Week Monitoring

**Document Type:** Execution Checklist
**Timeline:** 2026-03-30 23:59 to 2026-04-07 (go-live verification + first week monitoring)
**Owner:** CTMO + CFO
**Deadline for "Ready":** 2026-03-30 23:59 (all items checked before user hands off)

---

## PRE-HANDOFF VERIFICATION (Hour 35-36, 2026-03-30 23:00-23:59)

These items must be completed BEFORE March 31 midnight. This is CTMO's final sign-off window.

### System Status Checks

- [ ] **All Services Running**
  - Command: `docker ps` (Zapier: N/A; n8n: postgres, n8n, redis, selenium all show "Up")
  - Expected: 5 containers, all status "Up X minutes"
  - If failed: Restart: `docker compose up -d`

- [ ] **n8n Accessible** (if n8n chosen)
  - Command: Open http://localhost:5678 in browser
  - Expected: n8n login screen loads
  - If failed: Check port 5678 not in use, restart n8n

- [ ] **PostgreSQL Accessible**
  - Command: `psql -h localhost -U makinmoves -d makinmoves -c "SELECT 1;"`
  - Expected: Output shows "?column? = 1"
  - If failed: Check database running, verify credentials

### Workflow Status Checks

**For Zapier:**
- [ ] All 5 Zaps marked "ON" in Zapier dashboard
- [ ] Task counter shows <200/5000 (headroom available)
- [ ] Execution history shows no recent errors
- [ ] Credentials valid: All colors "green" in My Apps

**For n8n:**
- [ ] All 5 workflows active (toggle = ON)
- [ ] Execution history: Last execution of each workflow successful
- [ ] Credentials valid: All show "Connected" status
- [ ] PostgreSQL connection tested and working

### Database Verification Checks

- [ ] **Schema Tables Created**
  ```bash
  psql -h localhost -U makinmoves -d makinmoves -c "\dt"
  ```
  Expected tables:
  - [ ] revenue_summary
  - [ ] content_queue
  - [ ] publishing_log
  - [ ] error_logs
  - [ ] api_rate_limits

- [ ] **Sample Data Exists**
  ```bash
  psql -h localhost -U makinmoves -d makinmoves -c "SELECT COUNT(*) FROM revenue_summary;"
  ```
  Expected: Count > 0 (from test data)

- [ ] **Indexes Created** (for n8n)
  ```bash
  psql -h localhost -U makinmoves -d makinmoves -c "\di"
  ```
  Expected: Indexes on timestamp, status columns

### End-to-End Workflow Tests (Final Verification)

**Test 1: Revenue Capture**
1. Manually trigger revenue workflow (Zapier: click play; n8n: click Execute)
2. Expected: Completes in <5 minutes
3. Verify: `SELECT COUNT(*) FROM revenue_summary WHERE DATE(timestamp) = CURRENT_DATE;`
4. Expected: Count >= 1
- [ ] PASS

**Test 2: Email Alert**
1. Create intentional error (disable API credential temporarily)
2. Trigger error workflow
3. Expected: Error email received within 5 minutes
4. Re-enable credential
- [ ] PASS

**Test 3: Database Query (CFO)**
1. CFO runs test query:
   ```sql
   SELECT SUM(total_net) FROM revenue_summary
   WHERE DATE(timestamp) = CURRENT_DATE;
   ```
2. Expected: Returns a number (even if $0)
3. Verify CFO can access PostgreSQL
- [ ] PASS

### Documentation Verification

- [ ] **CTMO Runbook Created** ✓
  Location: `/CTMO/outbox/zapier-handoff-checklist.md` OR `/CTMO/technical/n8n-emergency-procedures.md`
  Contains:
  - [ ] What to monitor hourly/daily/weekly
  - [ ] How to handle common failures
  - [ ] Emergency contact procedure
  - [ ] How to restart services

- [ ] **CFO Dashboard Guide Created** ✓
  Location: `/CFO/outbox/revenue-monitoring-guide.md`
  Contains:
  - [ ] How to query revenue_summary table
  - [ ] How to interpret email reports
  - [ ] What errors mean
  - [ ] Who to contact if issues

- [ ] **Backup & Restore Procedures Created** ✓
  Location: `/CTMO/technical/disaster-recovery.md`
  Contains:
  - [ ] PostgreSQL backup/restore commands
  - [ ] Workflow export/import (for n8n)
  - [ ] Docker restart procedures
  - [ ] Full recovery from scratch

### Credentials & Security

- [ ] **All API Credentials Secured**
  - [ ] Gumroad token: Stored in Zapier/n8n (not in plain text anywhere)
  - [ ] Stripe token: Stored in Zapier/n8n (not in plain text anywhere)
  - [ ] ConvertKit token: Stored in Zapier/n8n (not in plain text anywhere)
  - [ ] Email password: Stored in Zapier/n8n (not in plain text anywhere)
  - [ ] PostgreSQL password: In `.env` file (secured, not in version control)

- [ ] **No Sensitive Data in Logs**
  - [ ] Check Zapier task history: No API keys exposed
  - [ ] Check n8n execution logs: No passwords logged
  - [ ] Check PostgreSQL logs: No sensitive queries exposed

- [ ] **Backup of Credentials Created**
  - [ ] Zapier: Screenshot of all connections (for manual re-auth if needed)
  - [ ] n8n: Export credentials as JSON (store securely)

### Sign-Off

**CTMO Final Sign-Off:**

```
Date: 2026-03-30 23:59
Time: [exact time]

I, [CTMO], have verified:
- All workflows deployed and tested ✓
- All integrations connected and working ✓
- Database initialized and accessible ✓
- Error handling operational ✓
- CFO can monitor system ✓
- Backups configured ✓
- Documentation complete ✓
- Zero manual intervention required post-March 31 ✓

SIGNATURE: ________________________
STATUS: READY FOR AUTONOMOUS OPERATION
```

**CFO Final Sign-Off:**

```
Date: 2026-03-30 23:59
Time: [exact time]

I, [CFO], have verified:
- I can access PostgreSQL ✓
- I can query revenue data ✓
- I understand email reports ✓
- I know how to escalate if issues arise ✓
- I have CTMO contact info ✓

SIGNATURE: ________________________
STATUS: READY TO MONITOR
```

**CEO Final Sign-Off:**

```
Date: 2026-03-30 23:59
Time: [exact time]

All systems verified. Ready for March 31 hands-off.
Going dark at 2026-03-31 00:00.
All future operation autonomous.

SIGNATURE: ________________________
STATUS: USER HANDS OFF
```

---

## WEEK 1 MONITORING PLAN (April 1-7)

After user hands off, CTMO and CFO run these checks. All should be automated — these are just verification that automation is working.

### Daily Monitoring (CFO, 5 minutes)

**Morning (8 AM):**
- [ ] Check email for daily revenue report
  - Expected: Email titled "Daily Revenue Report - [Date]"
  - Check: Total revenue > $0 (or exactly $0 if no sales)
  - Action: If no email received, check spam, contact CTMO

**Evening (6 PM):**
- [ ] Spot-check revenue_summary table
  ```sql
  SELECT * FROM revenue_summary ORDER BY timestamp DESC LIMIT 1;
  ```
  - Expected: Last row timestamp from today
  - Action: If timestamp is yesterday, workflow may not have executed

**Anytime:**
- [ ] Check for critical errors:
  ```sql
  SELECT * FROM error_logs WHERE severity = 'critical' ORDER BY logged_at DESC LIMIT 5;
  ```
  - Expected: Should be empty or contain only info-level logs
  - Action: If critical errors, forward to CTMO immediately

### Weekly Monitoring (CTMO, 15 minutes) — For n8n only

**Friday 10 AM:**

- [ ] **Check Execution History**
  - n8n → Executions tab
  - Expected: W1, W2, W3, W4, W5 all executed successfully in last 7 days
  - Action: If any failed, investigate error, fix

- [ ] **Check Database Disk Space**
  ```bash
  docker exec mm-postgres df -h | grep /var/lib/postgresql
  ```
  - Expected: <90% disk usage
  - Action: If >90%, archive old data or increase disk

- [ ] **Check PostgreSQL Logs**
  ```bash
  docker logs mm-postgres | tail -50
  ```
  - Expected: No error messages
  - Action: If errors, restart PostgreSQL: `docker compose down postgres && docker compose up -d postgres`

- [ ] **Verify Backups**
  - Expected: Latest backup timestamp within 24 hours
  - Action: If no recent backup, run manual: `pg_dump -h localhost -U makinmoves -d makinmoves > backup_$(date +%Y%m%d).sql`

### First Week Revenue Targets

**April 1 (Day 1):**
- [ ] At least 1 transaction logged (test transaction is fine)
- Expected: revenue_summary has at least 1 row
- Action: If empty, check if real sales exist on platforms

**April 4 (Day 4):**
- [ ] Revenue capture working hourly
- [ ] At least 24 hourly captures (one per hour)
- Expected: Query returns 24+ rows with timestamps 1 hour apart
- Action: If fewer, check if workflows executing on schedule

**April 7 (Day 7):**
- [ ] Daily report email received all 7 days
- [ ] Weekly revenue total > $0
- Expected: Sum of revenue_summary for week > $0 (even $5 is success)
- Action: If still $0 after 7 days, check if platforms have sales

---

## CONTINGENCY RESPONSE PLAYBOOK (Week 1)

If something breaks during Week 1, here's what to do.

### Scenario: No Revenue Captured (0 for 2+ hours)

**CFO Detects:** "I haven't received email in 2 hours, revenue is $0"

**Immediate Actions (within 30 minutes):**
1. Check platform: Do we actually have sales on Gumroad/Stripe today?
   - Go to Gumroad dashboard → Sales
   - Go to Stripe dashboard → Payments
   - If zero sales: This is correct, revenue should be $0
   - If sales exist but not captured: Proceed to next step

2. Check workflow execution:
   - Zapier: Dashboard → Task History → Revenue capture Zap
   - n8n: Executions → W1_Revenue_Capture
   - Did it run? Did it succeed or fail?
   - If failed: Click error to see details

3. Check API auth:
   - Zapier: My Apps → Check if API credentials green
   - n8n: Credentials → Check if "Connected" status
   - If red/disconnected: Re-authenticate

4. Contact CTMO: "Revenue capture not working, I checked X and Y, need your help"

**CTMO Recovery Actions (within 1 hour total):**
1. Log into system (Zapier/n8n)
2. Manually execute revenue workflow
3. Check if it succeeds now
4. If yes: Was a transient error, monitor for recurrence
5. If no: Check error logs, fix underlying issue
6. Once fixed: Execute workflow again, verify revenue captured
7. Notify CFO: "Fixed, monitoring for issues"

---

### Scenario: Email Alert Not Received

**CFO Detects:** "I didn't get the 8 AM email today"

**Immediate Actions (within 30 minutes):**
1. Check spam folder (most common)
2. Check if email account spelled correctly in config
3. Query database directly to see if revenue exists:
   ```sql
   SELECT SUM(total_net) FROM revenue_summary WHERE DATE(timestamp) = CURRENT_DATE;
   ```
   - If revenue exists: Email workflow issue, not revenue capture
   - If $0: Revenue also not captured (different issue)

4. Contact CTMO: "Didn't receive email, but [revenue/no revenue] in database"

**CTMO Recovery Actions:**
1. Check email workflow execution (Zapier/n8n)
2. Test email manually: Send test email to CFO
3. Check email credentials: Re-authenticate if needed
4. Set CFO to receive alerts via alternative method (Slack, text, etc.)

---

### Scenario: Database Query Failing

**CFO Detects:** "I tried to query revenue_summary and got error: 'relation does not exist'"

**Immediate Actions:**
1. Verify tables exist:
   ```bash
   psql -h localhost -U makinmoves -d makinmoves -c "\dt revenue_summary"
   ```
   - If not listed: Table doesn't exist

2. Contact CTMO: "revenue_summary table missing, need to recreate schema"

**CTMO Recovery Actions:**
1. Re-run initialization script:
   ```bash
   psql -h localhost -U makinmoves -d makinmoves -f /c/Users/jsmcl/Documents/MakinMoves/MakinMoves-portable/docker/init-db.sql
   ```
2. Verify table recreated:
   ```bash
   psql -h localhost -U makinmoves -d makinmoves -c "SELECT COUNT(*) FROM revenue_summary;"
   ```
3. If recovery successful: Notify CFO, resume monitoring

---

### Scenario: Disk Full Error

**CTMO Detects:** "Error: No space left on device" in n8n logs

**Immediate Actions (within 15 minutes):**
1. Check disk space:
   ```bash
   docker exec mm-postgres df -h
   ```
2. If /var/lib/postgresql is >95%: Emergency action required

3. Archive old data:
   ```sql
   -- Move old revenue to archive
   CREATE TABLE revenue_summary_archive AS
   SELECT * FROM revenue_summary WHERE timestamp < NOW() - INTERVAL '30 days';

   DELETE FROM revenue_summary WHERE timestamp < NOW() - INTERVAL '30 days';
   ```

4. Clear old execution logs (n8n):
   - Settings → Execution Data → Delete executions older than 7 days

5. Restart PostgreSQL to reclaim space:
   ```bash
   docker compose down postgres && docker compose up -d postgres
   ```

---

### Scenario: n8n / Docker Crash

**CFO Detects:** "n8n is down, I can't access http://localhost:5678"

**CTMO Recovery (within 5 minutes):**
1. Check if container running:
   ```bash
   docker ps | grep n8n
   ```
   - Not listed: Container crashed

2. Restart:
   ```bash
   docker compose up -d n8n
   ```
   - Wait 30 seconds

3. Verify back online:
   - Open http://localhost:5678
   - Expected: Login screen

4. Check execution history:
   - Workflows may have missed executions during downtime
   - Run each workflow manually to catch up

5. Notify CFO: "n8n restarted, all systems nominal"

---

## METRICS TO TRACK (First Month)

### Revenue Metrics

| Metric | Target | Action if Below |
|--------|--------|-----------------|
| Days with $1+ revenue | >5/7 per week | Review platforms for issues |
| Average daily revenue | $10-50 | Check if all platforms publishing |
| Peak day | >$100 | Replicate success |
| Worst day | >$0 | Check if platforms down |

### System Metrics

| Metric | Target | Action if Below |
|--------|--------|-----------------|
| Workflow success rate | >98% | Fix failing workflows |
| Email report delivery | 100% | Re-auth email, switch providers |
| Database query time | <1 second | Add indexes, archive data |
| API response time | <5 sec | Check platform status |
| Error rate | <2% of executions | Investigate and fix |

### Operational Metrics

| Metric | Target | Action if Above |
|--------|--------|-----------------|
| CTMO intervention time | <1 hour when issue detected | Improve monitoring |
| CFO escalation frequency | <2x per week | Improve documentation |
| Manual data entry | 0 hours/week | Ensure automation working |
| System downtime | <1 hour/month | Improve reliability |

---

## SUCCESS CRITERIA (April 7)

For Week 1 to be considered "successful", all of these must be true:

- [ ] **Automation Working:** No manual human intervention needed for operation
- [ ] **Revenue Captured:** At least $5 captured from actual sales (or $0 if no real sales)
- [ ] **Email Alerts:** CFO received all 7 daily emails
- [ ] **Database Healthy:** All queries execute successfully
- [ ] **Error Handling:** All failures logged and visible
- [ ] **Zero Surprises:** No unexpected errors or missing data
- [ ] **CFO Confident:** "I understand the system, I can monitor it"
- [ ] **CTMO Confident:** "System is stable, I can scale it"

---

## FAILURE CRITERIA (Escalate to CEO)

If ANY of these happen during Week 1, it's a critical issue:

- [ ] **Zero Revenue Captured:** Database is empty for 24+ hours despite real sales existing
- [ ] **Database Lost:** Data corruption or backup failure prevents recovery
- [ ] **System Down:** All workflows stopped, can't restart
- [ ] **Security Breach:** API credentials compromised or leaked
- [ ] **Uncontrolled Costs:** Unexpected charges from services (e.g., Zapier task overages)
- [ ] **CFO Can't Monitor:** Unable to access system or query data for >2 hours

**If any of above occur:** Escalate to CEO with "CRITICAL" status

---

## END-OF-WEEK REPORT (April 7)

**CTMO Report to Board:**

```markdown
# Week 1 Autonomous Operation Report
**Date:** 2026-04-07
**Status:** OPERATIONAL / NEEDS IMPROVEMENT

## System Health
- Uptime: X% (target: >99%)
- Workflows executed: X (target: all on schedule)
- Average execution time: X sec
- Errors: X (target: <1% of executions)

## Revenue Captured
- Total for week: $X
- Highest day: $X
- Lowest day: $X
- Daily average: $X
- Progress to $10K goal: X%

## Issues Encountered
1. [Issue] - Fixed on [date], cause was [reason], prevention: [action]
2. [Issue] - Ongoing, workaround: [action], permanent fix: [timeline]

## Confidence Level
- System stability: 9/10
- Scalability: 8/10
- Maintainability: 8/10

## Recommendations for Week 2
- [ ] Increase publishing frequency
- [ ] Add new platforms
- [ ] Optimize database queries
- [ ] [Other]

Signed,
CTMO
```

---

**Status:** CHECKLIST COMPLETE
**Next Step:** Execute pre-handoff verification at Hour 35 (2026-03-30 23:00)
**Then:** Week 1 monitoring begins when user hands off (2026-03-31 00:00)

---

*Owner: CTMO + CFO*
*Date: 2026-03-29*
*Critical Deadline: 2026-03-30 23:59*
