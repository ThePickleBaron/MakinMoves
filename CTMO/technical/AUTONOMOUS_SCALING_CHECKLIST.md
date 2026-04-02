# Autonomous Scaling Checklist — Weekly Operations (Post-March 31)

**Owner:** CTMO (with CFO oversight)
**Frequency:** Every Monday 08:00 AM
**Autonomy Level:** Full (CTMO decides; CFO approves budget impact)
**Duration:** 30 minutes

---

## What This Is

After March 31, CTMO runs this checklist **every Monday** to decide if Trinity needs to scale up/down. No human decision-making required — just follow the thresholds and execute.

**Philosophy:** Trigger-based scaling means we scale when systems tell us to, not based on guesses or timelines.

---

## Weekly Scaling Checklist

### 1. Collect Metrics (5 minutes)

Run these queries every Monday morning:

```sql
-- Query 1: n8n execution count (last 7 days)
SELECT COUNT(*) as executions_last_7_days
FROM error_logs
WHERE logged_at >= CURRENT_DATE - INTERVAL '7 days';

-- Query 2: PostgreSQL health
SELECT
  current_setting('max_connections')::int as max_connections,
  (SELECT COUNT(*) FROM pg_stat_activity) as current_connections,
  pg_database.datname,
  pg_size_pretty(pg_database_size(pg_database.datname)) as size
FROM pg_database
WHERE datistemplate = false AND datname = 'makinmoves';

-- Query 3: API rate limit errors (last 7 days)
SELECT error_type, COUNT(*) as count
FROM error_logs
WHERE error_type = 'rate_limit'
  AND logged_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY error_type;

-- Query 4: Revenue (last 7 days)
SELECT SUM(revenue_amount) as weekly_revenue
FROM revenue_summary
WHERE captured_at >= CURRENT_DATE - INTERVAL '7 days';

-- Query 5: Workflow success rate
SELECT
  COUNT(CASE WHEN severity = 'info' THEN 1 END) as success_count,
  COUNT(CASE WHEN severity IN ('warning', 'critical') THEN 1 END) as error_count
FROM error_logs
WHERE logged_at >= CURRENT_DATE - INTERVAL '7 days';
```

**Output:** Fill in the table below

| Metric | Last Week | Threshold | Status | Action |
|--------|-----------|-----------|--------|--------|
| n8n executions/day (avg) | ___ | >500 = UPGRADE | [ ] PASS / [ ] FAIL | — |
| PostgreSQL connections used | ___ | >80% max = UPGRADE | [ ] PASS / [ ] FAIL | — |
| PostgreSQL storage used | ___ | >80% capacity = UPGRADE | [ ] PASS / [ ] FAIL | — |
| API 429 errors/day (avg) | ___ | >10 = FIX APIs | [ ] PASS / [ ] FAIL | — |
| Weekly revenue | $__ | >$500/week = PROFESSIONAL? | [ ] PASS / [ ] FAIL | — |
| Workflow success rate | __% | <95% = DEBUG | [ ] PASS / [ ] FAIL | — |

---

### 2. Check n8n Execution Threshold

**Trigger:** Daily average executions > 500/day (using Cloud Starter 200k/month limit)

**Math:** 200k/month ÷ 30 days = 6.7k/day max. 75% = 5k/day. Currently: ~500/day target.

```
IF executions_last_7_days / 7 > 500:
  → Action: Upgrade n8n tier
  → Decision: Cloud Starter ($200/mo) → Cloud Professional ($600/mo)
  → Cost: +$400/month
  → Notification: CFO (budget impact)
  → Timeline: Complete upgrade within 1 business day
ELSE:
  → Status: PASS (no action)
```

**Implementation if triggered:**
1. Log decision: `architecture_decision_2026-04-XX_n8n_upgrade.md`
2. Email CFO: "Upgrading n8n to Professional tier due to execution volume"
3. Access n8n dashboard → Settings → Upgrade to Professional
4. Test 2–3 workflows to verify upgrade
5. Update BOARD.md costs section

---

### 3. Check PostgreSQL Health

**Trigger 1:** CPU utilization >80% sustained (2+ hours)
**Trigger 2:** Storage >80% of capacity

```
IF database_cpu > 80% OR storage_used > 80%:
  → Action: Upgrade PostgreSQL tier
  → Decision: 512MB → 2GB OR 2GB → 5GB
  → Cost: +$20–35/month
  → Notification: CFO (budget impact)
  → Timeline: Complete upgrade within 1 business day
ELSE:
  → Status: PASS (no action)
```

**Implementation if triggered:**
1. Log decision: `architecture_decision_2026-04-XX_postgresql_upgrade.md`
2. Email CFO: "Upgrading PostgreSQL due to [CPU / storage]"
3. Access RDS/managed DB console → Modify instance → Increase tier
4. Wait for downtime window (usually <5 minutes)
5. Test 5–10 queries on upgraded instance
6. Update BOARD.md costs section

---

### 4. Check API Rate Limit Health

**Trigger:** >10 API 429 errors per day (rolling 7-day average)

```
IF api_rate_limit_errors_per_day > 10:
  → Action: Deploy API optimization
  → Solution: Batch requests + exponential backoff
  → Cost: +$0 (code change only)
  → Notification: None (code change)
  → Timeline: Deploy within 2 days
ELSE:
  → Status: PASS (no action)
```

**Implementation if triggered:**
1. Log decision: `architecture_decision_2026-04-XX_api_optimization.md`
2. Analyze which platform is hitting limits (Gumroad, Etsy, Medium, etc.)
3. Implement batching:
   - Etsy: Combine multiple requests into single call (HTTP 1.1 keep-alive)
   - Gumroad: Space out polling (don't poll every hour, instead every 2 hours)
   - Medium: Use RSS feed instead of API (no rate limits)
4. Add exponential backoff to n8n workflows:
   - 1st retry: 1 second
   - 2nd retry: 2 seconds
   - 3rd retry: 5 seconds
5. Deploy to n8n → Test 3 cycles
6. Monitor error_logs for 3 days → Should see 429 drop to <5/day

---

### 5. Check Revenue Sustainability

**Trigger:** Weekly revenue >$500 (indicating $2k/month pace)

```
IF weekly_revenue > $500:
  → Decision: Is Cloud Professional ROI-positive?
  → Analysis: $600/month Professional vs. $200/month Starter
  → Cost: +$400/month (but revenue supports it)
  → Action: EVALUATE, don't auto-upgrade
  → Timeline: Report to CEO/CFO, seek approval
ELSE:
  → Status: PASS (stay on current tier)
```

**Evaluation if triggered:**
1. Calculate: Weekly revenue × 4 = estimated monthly revenue
2. If monthly revenue >$800: Professional tier is ROI-positive (save time debugging)
3. If monthly revenue $500–800: Borderline (Starter is sufficient, but upgrade if execution growth continues)
4. If monthly revenue <$500: Stay on Starter (cost-saving matters more)
5. Report to board: "Revenue pace suggests upgrading to Professional by Week X"

---

### 6. Check Workflow Success Rate

**Trigger:** Success rate <95% (meaning >5% of workflows fail)

```
IF success_rate < 95%:
  → Action: DEBUG critical workflows
  → First check: error_logs table (group by workflow_name, error_type)
  → Timeline: Investigate within 1 business day
  → Resolution: Fix error OR escalate to board
ELSE:
  → Status: PASS (healthy operations)
```

**Implementation if triggered:**
1. Query error logs by workflow:
   ```sql
   SELECT workflow_name, error_type, COUNT(*) as count
   FROM error_logs
   WHERE logged_at >= CURRENT_DATE - INTERVAL '7 days'
   GROUP BY workflow_name, error_type
   ORDER BY count DESC;
   ```
2. Top 3 errors: Likely causes:
   - **API auth (401/403):** API key expired → Refresh in .env + redeploy
   - **Rate limit (429):** Hit platform limit → Deploy API optimization (see step 4)
   - **Timeout (504):** Platform slow → Add longer retry timeout
   - **Data validation (422):** Content format wrong → Review content generation logic
3. Fix 1–2 highest-impact errors
4. Rerun workflow test → Verify error rate drops below 5%
5. Document fix in: `technical_incident_2026-04-XX_workflow_recovery.md`

---

### 7. Escalation: Unsustainable Burn

**Trigger:** Cost >50% of weekly revenue sustained 2+ weeks

```
IF monthly_cost > 0.5 * monthly_revenue:
  → Status: UNSUSTAINABLE (emergency)
  → Notification: CEO + CFO immediately
  → Action: Strategy review (not autonomous)
  → Possible solutions:
    - Reduce infrastructure costs (migrate to self-hosted)
    - Increase revenue (CEO strategy)
    - Pause new features (focus on profitability)
```

**This is NOT autonomous — escalate to CEO.**

---

## Decision Log Template

Create a new file every time you make a scaling decision:

```markdown
# Architecture Decision: [Topic]
**Date:** 2026-04-XX
**Owner:** CTMO
**Trigger:** [Which threshold was hit]

## Metrics Before
- n8n executions/day: X
- PostgreSQL CPU: X%
- API 429 errors/day: X
- Weekly revenue: $X

## Decision
[Upgrade / Downgrade / Optimize] [Service]

## Cost Impact
- Before: $X/month
- After: $Y/month
- Delta: +/-$Z/month

## Implementation
- Step 1: [completed at HH:MM]
- Step 2: [completed at HH:MM]
- Step 3: [completed at HH:MM]

## Verification
- ✓ Service upgraded successfully
- ✓ 2–3 test operations completed
- ✓ No degradation in performance
- ✓ Error logs clean (no new errors)

## CFO Notification
Sent to CFO at HH:MM with cost impact.

**Status:** COMPLETE
```

---

## Monthly Review (For CEO)

Every month (last day), CTMO writes a summary for CEO:

```markdown
# Monthly Scaling Review — April 2026

## Scaling Decisions Made This Month
1. Week 1: n8n upgraded from Pro to Starter (Trigger T1 hit on Apr 7)
2. Week 2: PostgreSQL upgraded to 2GB (Trigger T2 hit on Apr 14)
3. Week 4: API optimization deployed (429 errors reduced from 12→3/day)

## Current Infrastructure
- n8n: Cloud Starter ($200/month)
- PostgreSQL: 2GB managed ($35/month)
- Redis: Self-hosted ($0/month)
- **Total: $235/month**

## Key Metrics
- n8n executions: 600/day average (75% of Starter limit)
- PostgreSQL CPU: 65% average (healthy)
- API 429 errors: 3/day average (target: <5)
- Weekly revenue: $400 average
- Success rate: 96% (healthy)

## Forecast
- At current growth: Professional tier upgrade likely by Week 8
- Revenue pace: On track for $1,000+ by Month 6
- Cost trend: Trending +$150–200/month (aligned with growth)

## Next Triggers to Watch
1. n8n executions approaching 5k/day (requires Professional upgrade)
2. PostgreSQL storage approaching 90% (requires 5GB upgrade)
3. Revenue pace >$500/week (Professional tier becomes ROI-positive)

**Status:** Healthy. No escalations. On track for autonomous operation.
```

---

## Automation: Can This Checklist Be Fully Automated?

**Current Answer:** Partially.

**What CAN be automated:**
- [ ] Query data collection (schedule PostgreSQL queries every Monday 08:00)
- [ ] Metric calculation (automated alerts if thresholds hit)
- [ ] Logging (auto-log to error_logs when triggers hit)
- [ ] Notifications (email CFO when cost decision needed)

**What CANNOT be automated (requires human decision):**
- [ ] Upgrade execution (requires account access, approval)
- [ ] Code deployment (API optimization changes)
- [ ] Escalation decisions (CPU spike → is it permanent or temporary?)
- [ ] Strategic choices (Professional vs. self-hosted?)

**Future improvement:** Create a PostgreSQL trigger that auto-logs threshold violations, then have n8n send alerts to CTMO:

```sql
CREATE FUNCTION check_scaling_triggers()
RETURNS void AS $$
BEGIN
  -- Check each trigger, log to decision_log table
  IF (SELECT COUNT(*) FROM error_logs WHERE logged_at >= NOW() - INTERVAL '7 days') / 7 > 500 THEN
    INSERT INTO scaling_alerts (triggered_at, alert_type, threshold, current_value)
    VALUES (NOW(), 'n8n_execution_surge', 500, (SELECT COUNT(*) FROM error_logs WHERE logged_at >= NOW() - INTERVAL '7 days') / 7);
  END IF;
  -- ... repeat for other triggers
END;
$$ LANGUAGE plpgsql;

-- Schedule to run every Monday 08:00
-- (Requires pg_cron extension)
SELECT cron.schedule('check_scaling_triggers', '0 8 * * 1', 'SELECT check_scaling_triggers()');
```

**For now (Month 1–2):** Manual checklist runs weekly by CTMO (30 min/week).
**Post-Month 2:** Automate metric collection + alerting, keep decision execution manual.

---

## Quick Reference Card (Paste in CTMO Terminal)

```
AUTONOMOUS SCALING CHECKLIST — Weekly (Mondays 08:00)

1. RUN QUERIES (5 min):
   [ ] n8n executions last 7 days
   [ ] PostgreSQL health check
   [ ] API 429 error count
   [ ] Weekly revenue
   [ ] Workflow success rate

2. CHECK THRESHOLDS:
   [ ] n8n executions >500/day? → Upgrade Cloud Starter
   [ ] PostgreSQL CPU >80%? → Upgrade tier
   [ ] API 429 errors >10/day? → Deploy optimization
   [ ] Revenue >$500/week? → Evaluate Professional

3. EXECUTE IF TRIGGERED:
   [ ] Log decision (timestamp + rationale)
   [ ] Notify CFO if cost change
   [ ] Complete upgrade/optimization
   [ ] Test 2–3 workflows
   [ ] Verify no degradation

4. DOCUMENT:
   [ ] Update architecture_decision_YYYY-MM-DD_topic.md
   [ ] Update BOARD.md costs section
   [ ] Notify CFO (if applicable)

Done? Mark as complete and sign off.
```

---

## Escalation Contacts

**If something breaks or you're unsure:**

| Issue | Contact | Action |
|-------|---------|--------|
| Cost decision >$100/month | CFO | Approve before executing |
| Revenue drops >30% week-over-week | CEO | Strategic review |
| Workflow failure rate >10% | CTMO (debug) | 1-hour SLA to fix |
| Database critical error | CTMO + CFO | Immediate escalation |
| API key expired / auth failure | User contact (not possible post-March 31) | Flag in error_logs, manual escalation |

---

**Document Owner:** CTMO
**Last Updated:** 2026-03-29 19:30
**Status:** READY FOR AUTONOMOUS OPERATION (Post-March 31)
**Weekly Reviews Start:** 2026-04-06 (First Monday after launch)
