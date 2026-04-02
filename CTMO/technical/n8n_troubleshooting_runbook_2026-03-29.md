# n8n Troubleshooting & Monitoring Runbook

**Purpose:** Quick-reference guide for CTMO to monitor and troubleshoot autonomous workflows post-March 31
**Status:** Final reference document
**Scope:** All 4 workflows (W1, W2, W3, W4)
**Response Time SLA:** CRITICAL = 15 min, WARNING = 1 hour

---

## Part 1: Daily Monitoring Tasks

### 06:00 UTC: Overnight Error Check (5 min)

**What to check:**
1. Did any workflows fail overnight (22:00 to 06:00)?
2. Were there any CRITICAL alerts I missed?

**SQL Query:**
```sql
-- Check for critical errors in last 8 hours
SELECT
  workflow_name,
  error_type,
  COUNT(*) as count,
  MAX(logged_at) as most_recent
FROM error_logs
WHERE logged_at > NOW() - INTERVAL '8 hours'
  AND severity IN ('CRITICAL', 'WARNING')
GROUP BY workflow_name, error_type
ORDER BY most_recent DESC;
```

**If any rows returned:**
- [ ] Severity = CRITICAL? → Investigate immediately (15 min SLA)
- [ ] Severity = WARNING? → Note for daily digest
- [ ] Same error repeated > 5x? → Pattern exists, see troubleshooting section

**If no rows returned:**
- ✅ All clear overnight, continue to next check

---

### 12:00 UTC: Daytime Status Check (10 min)

**What to check:**
1. Has revenue capture been running hourly?
2. How many transactions captured in last 24h?
3. Are there any pending/failed publishes?

**SQL Query — Revenue Capture Status:**
```sql
-- Revenue captured in last 24 hours by hour
SELECT
  DATE_TRUNC('hour', created_at) as hour,
  COUNT(*) as transactions,
  SUM(amount) as revenue
FROM (
  SELECT created_at, amount FROM gumroad_sales
  WHERE created_at > NOW() - INTERVAL '24 hours'
  UNION ALL
  SELECT created_at, amount FROM etsy_sales
  WHERE created_at > NOW() - INTERVAL '24 hours'
) combined
GROUP BY DATE_TRUNC('hour', created_at)
ORDER BY hour DESC;
```

**If any hour shows 0 transactions:**
- [ ] Check error_logs for that hour
- [ ] Check if workflows ran (workflow_executions table)
- [ ] If workflow didn't run: n8n might have crashed, check n8n dashboard

**SQL Query — Content Status:**
```sql
-- How much content is waiting to be published?
SELECT
  status,
  content_type,
  COUNT(*) as count
FROM content_queue
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY status, content_type;
```

**If pending count > 3:**
- [ ] Has COO been approving content?
- [ ] Are there failures preventing publishing?
- [ ] Check publishing_log for failures

**SQL Query — Publishing Status:**
```sql
-- Any failed publishes in last 24h?
SELECT
  platform,
  status,
  COUNT(*) as count,
  MAX(published_at) as most_recent,
  error_message
FROM publishing_log
WHERE published_at > NOW() - INTERVAL '24 hours'
  AND status = 'failed'
GROUP BY platform, status, error_message;
```

**If any failed publishes:**
- [ ] Note platform (Gumroad, WordPress, etc)
- [ ] See troubleshooting section for that platform

---

### 18:00 UTC: Evening Summary (5 min)

**What to check:**
1. End-of-day revenue total
2. Summary of content generated today
3. Any alerts that need attention tomorrow

**SQL Query — Daily Revenue Summary:**
```sql
-- Total revenue today
SELECT
  'gumroad' as platform,
  COUNT(*) as sales,
  SUM(amount) as revenue,
  ROUND(AVG(amount), 2) as avg_transaction
FROM gumroad_sales
WHERE DATE(created_at) = CURRENT_DATE
UNION ALL
SELECT
  'etsy',
  COUNT(*),
  SUM(amount),
  ROUND(AVG(amount), 2)
FROM etsy_sales
WHERE DATE(created_at) = CURRENT_DATE;
```

**Action:**
- [ ] Log daily total to CFO dashboard or file
- [ ] Note if revenue is 0 (possible outage)

**SQL Query — Content Generated Today:**
```sql
SELECT
  content_type,
  COUNT(*) as generated,
  COUNT(*) FILTER (WHERE status = 'approved') as approved,
  COUNT(*) FILTER (WHERE status = 'published') as published
FROM content_queue
WHERE DATE(created_at) = CURRENT_DATE
GROUP BY content_type;
```

**Action:**
- [ ] Notify CFO of daily summary
- [ ] If generated = 0, check error_logs (Claude might be down)

---

## Part 2: Troubleshooting by Symptom

### Symptom 1: "Revenue capture shows 0 transactions for hour 14:00"

**Diagnosis Steps:**

1. **Check: Did the workflow run?**
   ```sql
   SELECT * FROM workflow_executions
   WHERE workflow_id = 'revenue_capture'
     AND executed_at > '2026-03-30 14:00'
     AND executed_at < '2026-03-30 15:00';
   ```
   - If 0 rows: Workflow didn't run. Go to Step 2.
   - If 1+ rows: Workflow ran. Go to Step 3.

2. **Check: n8n Cron Trigger Working?**
   - [ ] Log into n8n dashboard
   - [ ] Go to `workflow_revenue_capture_hourly`
   - [ ] Check execution history (right side)
   - [ ] Do you see execution at 14:00?
   - [ ] If NO: Cron trigger might be disabled. Click the trigger node, verify "Active" is ON
   - [ ] If YES: Go to Step 3

3. **Check: Did the API calls succeed?**
   ```sql
   SELECT * FROM error_logs
   WHERE workflow_name = 'revenue_capture'
     AND logged_at > '2026-03-30 14:00'
     AND logged_at < '2026-03-30 15:00';
   ```
   - If rows with error_type = 'RATE_LIMIT': Go to Step 4
   - If rows with error_type = 'AUTH_FAILURE': Go to Step 5
   - If rows with error_type = 'SERVER_ERROR': Go to Step 6
   - If no rows: Workflow ran but captured 0 transactions. Might be normal (check Gumroad/Etsy for actual sales)

4. **Fix: Rate Limit Error (429)**
   - Gumroad or Etsy rejected the request due to rate limits
   - **Action:** Workflow automatically retries with backoff
   - **Wait:** Usually resolves within 30 minutes
   - **If persists >2 hours:** Check if API keys have been changed, or contact API support

5. **Fix: Auth Error (401/403)**
   - API token expired or invalid
   - **Action:** Immediate fix required
   - **Steps:**
     1. Go to platform dashboard (Gumroad or Etsy)
     2. Generate new API token
     3. Update in n8n Credentials Manager:
        - [ ] n8n dashboard → Credentials
        - [ ] Find `gumroad_api_token` or `etsy_oauth_token`
        - [ ] Edit with new token
        - [ ] Save and test connection
     4. Manually trigger revenue_capture workflow to verify
     5. Check error_logs for new errors

6. **Fix: Server Error (5xx)**
   - API server is having issues
   - **Action:** Workflow will retry automatically
   - **If persists >1 hour:** Contact API support or check their status page

---

### Symptom 2: "Content generation failed, no items in content_queue"

**Diagnosis Steps:**

1. **Check: Did the workflow run at 06:00?**
   ```sql
   SELECT * FROM workflow_executions
   WHERE workflow_id = 'content_generation'
     AND DATE(executed_at) = CURRENT_DATE;
   ```
   - If 0 rows: Workflow didn't run. Check Step 2.
   - If 1+ rows: Workflow ran. Check Step 3.

2. **Check: Cron Trigger Status**
   - [ ] Log into n8n
   - [ ] Go to `workflow_content_generation_daily`
   - [ ] Check if cron trigger is Active
   - [ ] If not: Click trigger, enable it
   - [ ] Manually trigger workflow (test button)
   - [ ] Does it succeed?

3. **Check: Claude API Error**
   ```sql
   SELECT * FROM error_logs
   WHERE workflow_name = 'content_generation'
     AND DATE(logged_at) = CURRENT_DATE;
   ```
   - If error_type = 'AUTH_FAILURE': Claude API key expired (go to Step 4)
   - If error_type = 'SERVER_ERROR': Claude API down (wait, retry later)
   - If error_type = 'RATE_LIMIT': Claude API quota exceeded (check account)

4. **Fix: Claude API Token Expired**
   - [ ] Check Anthropic account: https://console.anthropic.com/account
   - [ ] Copy new API key
   - [ ] Update n8n credentials: Settings → Credentials → anthropic_api_key
   - [ ] Save and test
   - [ ] Manually trigger content_generation to verify

5. **Check: PostgreSQL Connection Error**
   ```sql
   SELECT * FROM error_logs
   WHERE workflow_name = 'content_generation'
     AND error_type = 'DATABASE_ERROR';
   ```
   - If present: Database connection broken
   - [ ] Check AWS RDS dashboard: Is instance running?
   - [ ] Check n8n PostgreSQL credentials: Is connection string correct?
   - [ ] Test connection in n8n Credentials Manager
   - [ ] If still broken: Contact AWS support

---

### Symptom 3: "Article published to WordPress but not appearing"

**Diagnosis Steps:**

1. **Check: Did publishing_log show success?**
   ```sql
   SELECT * FROM publishing_log
   WHERE platform = 'wordpress'
     AND DATE(published_at) = CURRENT_DATE
   ORDER BY published_at DESC
   LIMIT 5;
   ```
   - If status = 'published': WordPress API said success. Go to Step 2.
   - If status = 'failed': WordPress API returned error. Go to Step 3.

2. **Check: Can you see the post in WordPress?**
   - [ ] Visit WordPress dashboard
   - [ ] Go to Posts
   - [ ] Search for article title
   - [ ] Does post exist?
   - [ ] Is it in "Published" status (not Draft)?
   - [ ] Can you access it on the live site?
   - If YES: All good, article is live
   - If NO: WordPress might have changed, post might be in spam/trash

3. **Check: WordPress API Error**
   - [ ] Look at error_message in publishing_log
   - [ ] Common errors:
     - 401: App password expired
     - 403: User lacks permission to publish
     - 422: Invalid post data (missing required fields)

4. **Fix: WordPress App Password Expired (401)**
   - [ ] Log into WordPress admin
   - [ ] Users → Your Profile
   - [ ] Find "Application Passwords" section
   - [ ] Generate new password
   - [ ] Copy password
   - [ ] Update n8n credentials:
     - Settings → Credentials → wordpress_api
     - [ ] Paste new password
     - [ ] Save and test
   - [ ] Manually trigger publishing_pipeline to retry

5. **Fix: Permission Error (403)**
   - [ ] Log into WordPress
   - [ ] Users → [User account used by n8n]
   - [ ] Check: Is this user set to "Editor" or "Administrator"?
   - [ ] If not: Change role to "Editor"
   - [ ] Retry workflow

6. **Fix: Invalid Post Data (422)**
   - [ ] Check the content_queue row for this article
   - [ ] Is metadata.article_structure a valid array?
   - [ ] Are all required fields present?
   - [ ] Check error_logs for details
   - [ ] May need to manually review article content
   - [ ] Contact CTMO for inspection

---

### Symptom 4: "Slack alerts stopped appearing, but errors are in error_logs"

**Diagnosis Steps:**

1. **Check: Slack Configuration**
   - [ ] n8n dashboard → Credentials → slack_webhook
   - [ ] Is webhook URL valid?
   - [ ] Test Slack connection in n8n Credentials Manager

2. **Check: Error Severity**
   ```sql
   SELECT DISTINCT severity FROM error_logs
   WHERE logged_at > NOW() - INTERVAL '24 hours'
   ORDER BY severity;
   ```
   - Only CRITICAL errors trigger Slack alerts
   - If you see only WARNING/INFO: That's expected (no alert)

3. **Fix: Update Slack Webhook**
   - [ ] If webhook is broken:
     - Go to Slack → Settings → API → Incoming Webhooks
     - [ ] Create new webhook for #makinmoves-alerts channel
     - [ ] Copy webhook URL
     - [ ] Update n8n credentials
     - [ ] Test send message

---

### Symptom 5: "PostgreSQL connection keeps timing out"

**Diagnosis Steps:**

1. **Check: RDS Instance Status**
   - [ ] AWS Console → RDS → Databases → makinmoves
   - [ ] Is instance in "Available" state?
   - [ ] Check CPU/connections metrics (if high, might need scaling)

2. **Check: Connection Pool**
   - [ ] n8n PostgreSQL node: "Max connections" setting
   - [ ] If too many workflows compete for connections: Increase pool size
   - [ ] Recommended: 10-20 connections for 4 workflows

3. **Fix: Restart RDS Instance**
   - [ ] AWS Console → RDS → Databases → makinmoves
   - [ ] Click "Reboot database"
   - [ ] Wait 2-5 minutes for restart
   - [ ] Test connection from n8n

4. **Check: Network/Security Groups**
   - [ ] RDS security group allows inbound from n8n IP
   - [ ] Check: VPC → Security Groups → makinmoves-db
   - [ ] Inbound rule: PostgreSQL (port 5432) from n8n source

---

## Part 3: Emergency Procedures

### Emergency 1: Workflow Stuck in Loop (Infinite Retries)

**Symptoms:**
- Workflow executes over and over
- n8n UI shows 100+ executions in history
- Errors keep piling up in error_logs

**Immediate Fix (30 seconds):**
1. [ ] n8n dashboard → click the running workflow
2. [ ] Click "Deactivate Trigger" button (red X next to cron trigger)
3. [ ] Workflow stops immediately
4. [ ] Check error_logs to understand the issue

**Root Cause & Recovery:**
- Usually: A condition node is always true, causing infinite retries
- Fix: Edit the workflow, check condition logic
- Once fixed: Re-activate trigger

---

### Emergency 2: PostgreSQL Data Corruption

**Symptoms:**
- Duplicate sales entries (violates UNIQUE constraint)
- NULL values in required fields
- Data seems randomly corrupted

**Immediate Fix (2 minutes):**
1. [ ] Disable all workflows (deactivate triggers)
2. [ ] Stop any running executions
3. [ ] Backup database: `pg_dump makinmoves > backup_$(date +%s).sql`

**Diagnosis (5 minutes):**
```sql
-- Check for duplicates
SELECT sale_id, COUNT(*) FROM gumroad_sales GROUP BY sale_id HAVING COUNT(*) > 1;

-- Check for NULLs in key fields
SELECT * FROM gumroad_sales WHERE amount IS NULL OR created_at IS NULL;

-- Check for orphaned rows
SELECT * FROM publishing_log WHERE content_id NOT IN (SELECT id FROM content_queue);
```

**Recovery Steps:**
- If duplicates: Manual deduplication (DELETE oldest, KEEP newest)
- If NULLs: DELETE corrupted rows, accept data loss
- If orphans: DELETE orphaned rows
- Run full VACUUM and ANALYZE: `VACUUM ANALYZE;`
- Re-enable workflows once clean

---

### Emergency 3: All Workflows Down, No Errors

**Symptoms:**
- No workflows running
- No errors in error_logs
- Last successful execution was > 4 hours ago

**Diagnosis (5 minutes):**

1. **Is n8n running?**
   - [ ] Can you access n8n dashboard?
   - [ ] If NO: n8n instance crashed. Restart it.

2. **Are cron triggers enabled?**
   ```javascript
   // n8n dashboard, each workflow:
   Check: Is the trigger node showing as "Active" (green)?
   If NO: Click trigger, enable it
   ```

3. **Is PostgreSQL reachable?**
   - [ ] n8n Credentials → postgres_makinmoves
   - [ ] Click "Test connection"
   - [ ] If fails: Database offline. See Emergency 2.

4. **Manual Recovery:**
   - [ ] If n8n down: Restart the instance
   - [ ] If triggers disabled: Enable manually
   - [ ] If DB down: Restart RDS instance
   - [ ] Once recovered: Run each workflow manually to catch up on missed hours

---

### Emergency 4: User Needs to Access System

**Important:** User is not supposed to interact post-March 31. But if emergency contact needed:

**Information to Provide to User:**

1. **n8n Dashboard Access:**
   - URL: `https://n8n-instance.eu.n8n.cloud/`
   - User: (CTMO)
   - Password: (in secure vault)

2. **PostgreSQL Access (Read-Only for CFO):**
   - Host: `makinmoves-db.xxxxx.rds.amazonaws.com`
   - Database: `makinmoves`
   - User: `cfo_readonly` (restricted permissions)
   - Password: (in secure vault)

3. **Slack Alerts:**
   - Channel: `#makinmoves-alerts`
   - All CRITICAL errors sent here

---

## Part 4: Quick Command Reference

### Query: Last Execution Time of Each Workflow
```sql
SELECT
  workflow_id,
  MAX(executed_at) as last_execution,
  status,
  EXTRACT(EPOCH FROM (NOW() - MAX(executed_at))) / 60 as minutes_ago
FROM workflow_executions
GROUP BY workflow_id, status
ORDER BY last_execution DESC;
```

### Query: Error Rate (Last 24 Hours)
```sql
SELECT
  workflow_name,
  ROUND(100.0 * COUNT(*) FILTER (WHERE severity IN ('CRITICAL', 'WARNING'))
        / COUNT(*), 2) as error_rate_percent,
  COUNT(*) FILTER (WHERE severity = 'CRITICAL') as critical_count,
  COUNT(*) FILTER (WHERE severity = 'WARNING') as warning_count
FROM error_logs
WHERE logged_at > NOW() - INTERVAL '24 hours'
GROUP BY workflow_name;
```

### Query: Which Content Items Are Awaiting Approval?
```sql
SELECT
  id,
  content_type,
  title,
  created_at,
  metadata
FROM content_queue
WHERE status = 'pending'
ORDER BY created_at DESC;
```

### Query: Dead Letter Queue - Items That Failed
```sql
SELECT
  workflow_name,
  reason_code,
  COUNT(*) as count,
  MAX(queued_at) as most_recent
FROM dead_letter_queue
WHERE resolved = false
GROUP BY workflow_name, reason_code
ORDER BY most_recent DESC;
```

### Action: Manually Trigger a Workflow
1. n8n dashboard
2. Click the workflow
3. Click "Execute Workflow" button (play icon)
4. Watch execution history for results
5. If failed: Check error_logs

### Action: Check Workflow Execution History
1. n8n dashboard
2. Click the workflow
3. Right side shows execution history
4. Click any execution to see details, error messages, node outputs

### Action: Disable a Workflow Temporarily
1. n8n dashboard
2. Click workflow
3. Click trigger node (e.g., Cron Trigger)
4. Toggle "Active" to OFF
5. Workflow will not execute on schedule

---

## Part 5: When to Escalate

### Escalate to CEO/COO if:

- [ ] **Revenue capture down > 2 hours:** System not capturing any sales
- [ ] **Multiple platforms failing:** Affects > 1 revenue stream
- [ ] **Data loss occurred:** Rows deleted, corrupted, or missing
- [ ] **Security incident:** Credentials compromised, unauthorized access

### Escalate to User if:

- [ ] **System offline >6 hours and CTMO can't fix:** Need external help
- [ ] **API provider deprecated key service:** Need to find alternative
- [ ] **Unknown error pattern:** Can't diagnose after 30 minutes

---

## Support Resources

### Documentation

- Full Architecture: `CTMO/technical/n8n_workflow_architecture_2026-03-29.md`
- Implementation Details: `CTMO/technical/n8n_implementation_checklist_2026-03-29.md`
- Platform APIs: `CTMO/technical/PLATFORM_API_MAPPING_2026.md`

### External APIs

- n8n Docs: https://docs.n8n.io/
- Gumroad API: https://api.gumroad.com/v2/docs
- Etsy API: https://www.etsy.com/developers
- Claude API: https://docs.anthropic.com/
- PostgreSQL: https://www.postgresql.org/docs/

### Contacts (If Needed)

- n8n Support: support@n8n.io
- AWS RDS Support: AWS Support Portal
- Anthropic Claude: support@anthropic.com

---

**This runbook is your go-to guide for monitoring and troubleshooting autonomous operations post-March 31.**

**Print or bookmark this document. Refer to it daily.**

**Owner:** CTMO
**Status:** Final Reference
**Last Updated:** 2026-03-29 16:00 UTC

