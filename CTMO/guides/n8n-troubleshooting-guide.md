# n8n Troubleshooting Guide for Autonomous Revenue Operations

**For:** CTMO (during implementation and production)
**Keep:** Nearby during Phase 1-4 rollout
**Last Updated:** 2026-03-29

---

## Revenue Capture Workflow Issues

### Issue 1: "HTTP Request returns 401 Unauthorized from Gumroad"

**Symptoms:**
- Workflow runs, but Gumroad request fails
- Error message: "invalid authentication"

**Root Causes:**
1. API token expired or revoked
2. Token not set in n8n secrets
3. Header format wrong

**Fix:**
```
1. Login to Gumroad → Settings → API → Copy token
2. In n8n: Settings → Secrets Manager → GUMROAD_API_TOKEN = "your-token"
3. In HTTP Request node: Change header to:
   Authorization: Bearer {{ $secrets.GUMROAD_API_TOKEN }}
4. Test request; preview response
```

**Verification:**
- n8n Execute → Check response status = 200
- Response body contains sales array

---

### Issue 2: "PostgreSQL: column count mismatch"

**Symptoms:**
- Workflow runs; HTTP request succeeds; PostgreSQL INSERT fails
- Error: "supplied 7 values but table has 8 columns"

**Root Cause:**
- Query parameters array doesn't match INSERT columns

**Fix:**
Count columns in INSERT statement:
```sql
INSERT INTO revenue_log
(col1, col2, col3, col4, col5, col6, col7, col8)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
```

Count parameters in Query Parameters array:
```
["val1", "val2", "val3", "val4", "val5", "val6", "val7", "val8"]
```

**Verification:**
- Count both; they must match exactly
- Test with dummy values first

---

### Issue 3: "Duplicate sale captured (UNIQUE constraint violation)"

**Symptoms:**
- First run succeeds; second run fails
- Error: "duplicate key value violates unique constraint"

**Root Cause:**
- Same sale_id inserted twice (workflow ran twice on same sale)

**Fix:**
```sql
-- Check what was inserted:
SELECT * FROM revenue_log WHERE sale_id = 'duplicate_id';

-- Delete the duplicate (if needed):
DELETE FROM revenue_log WHERE sale_id = 'duplicate_id' AND timestamp < '2026-03-29';

-- Verify uniqueness:
SELECT COUNT(*) FROM revenue_log;
```

**Prevention:**
- Use Gumroad timestamp to filter: `from_date > last_run_time`
- Add idempotency check: "Have I seen this sale_id before?"

**Fix in Workflow:**
```
Add node BEFORE PostgreSQL:
  [HTTP Request to Gumroad]
    ↓
  [Set: Add field "check_duplicate" = select from DB if this sale_id exists]
    ↓
  [If: "check_duplicate is empty" → continue; else skip]
    ↓
  [PostgreSQL INSERT]
```

---

### Issue 4: "Gumroad returns 429 Too Many Requests"

**Symptoms:**
- Workflow fails intermittently
- Error: "HTTP Status 429"

**Root Cause:**
- Exceeding undocumented rate limit (too many requests in short time)

**Fix:**
Gumroad already has retry logic in HTTP Request node; if it still fails:

1. Increase batch interval:
   ```
   HTTP Request Node → Batching:
     Items per Batch: 1 (process one at a time)
     Batch Interval (ms): 1000 (wait 1 second between)
   ```

2. Add explicit wait before request:
   ```
   [Schedule Trigger]
     ↓
   [Wait Node: 1000 ms]
     ↓
   [HTTP Request: Gumroad]
   ```

3. Implement exponential backoff:
   ```
   [HTTP Request]
     ↓
   [If: status code = 429?]
     ├─ YES: [Wait 5 sec] → [Retry HTTP]
     └─ NO: Continue
   ```

**Verification:**
- Reduce workflow frequency: change from every 60 min to every 90 min
- Monitor response headers for X-Rate-Limit-Remaining

---

### Issue 5: "PostgreSQL: Connection timeout"

**Symptoms:**
- PostgreSQL node hangs; workflow times out
- Error: "ECONNREFUSED" or "connection timeout"

**Root Cause:**
- Network unreachable (security group/firewall block)
- PostgreSQL host down
- Wrong credentials

**Fix:**
```
1. Test connection in n8n:
   Settings → Credentials → PostgreSQL → Test Connection

2. If test fails:
   - Check host is correct (ping from command line)
   - Check port 5432 is open (telnet host 5432)
   - Check security group allows n8n IP
   - Verify credentials (user/password correct)

3. If n8n is cloud-hosted:
   - Add n8n IP to PostgreSQL security group
   - Contact PostgreSQL host provider if issue persists
```

**Verification:**
- Test connection shows "✓ Success"
- Run simple SELECT query: `SELECT 1`

---

## Content Generation Workflow Issues

### Issue 6: "Claude API returns 401 Unauthorized"

**Symptoms:**
- HTTP Request to Claude fails
- Error: "invalid authentication credentials"

**Root Cause:**
- API key invalid or expired
- Wrong API key format

**Fix:**
```
1. Login to Anthropic Console → API Keys
2. Copy your key (should start with sk-ant-v3-)
3. In n8n Secrets: CLAUDE_API_KEY = "sk-ant-v3-your-key-here"
4. In HTTP Request header:
   x-api-key: {{ $secrets.CLAUDE_API_KEY }}
5. Test request
```

**Verification:**
- Response status = 200
- Response contains "content" array with generated text

---

### Issue 7: "Claude API returns truncated response (incomplete text)"

**Symptoms:**
- Generated content cuts off mid-sentence
- Word count less than expected

**Root Cause:**
- `max_tokens` set too low in API request

**Fix:**
```
In HTTP Request node body:
{
  "max_tokens": 2000  ← INCREASE THIS
}

Recommended values:
- Blog post (1500 words): max_tokens = 2000
- Description (200 words): max_tokens = 500
- Social caption (50 words): max_tokens = 150
```

**Calculation:**
```
Tokens ≈ words × 1.3
1500 words × 1.3 = 1950 tokens
Set max_tokens = 2000 (buffer)
```

**Verification:**
- Response has full content; doesn't end with "..."

---

### Issue 8: "PostgreSQL: INSERT fails with 'NULL value in column'"

**Symptoms:**
- Claude generates content; PostgreSQL INSERT fails
- Error: "NULL value in NOT NULL column"

**Root Cause:**
- Set node didn't extract data correctly from Claude response

**Fix:**
Check the data transformation in Set node:

```javascript
// Claude response structure:
{
  "content": [
    { "type": "text", "text": "actual content here" }
  ]
}

// Correct extraction:
content_body: $json.content[0].text  ✓

// Wrong extraction:
content_body: $json.content  ✗ (returns array, not string)
content_body: $json.text  ✗ (wrong path)
```

**Fix:**
1. In Set node, verify mapping:
   ```
   content_body: {{ $json.content[0].text }}
   ```
2. Click preview to see extracted value
3. Should show full text content, not null

---

### Issue 9: "Claude API rate limited (429 or quota exceeded)"

**Symptoms:**
- Error: "429 Rate Limit Exceeded" or "billing quota exceeded"

**Root Cause:**
- Exceeded token limit (free trial) or API billing quota

**Fix:**
```
Option 1 (Free Trial):
- Free trial has limited tokens (~$5 worth)
- Once exhausted, requests fail
- Add billing method to account → restart

Option 2 (Reduce Usage):
- Change from 1500-word posts to 500-word posts
- Reduce frequency from daily to every 2-3 days
- Batch multiple prompts in one API call (more efficient)

Option 3 (Cost Monitoring):
- Monitor usage in Anthropic Console
- Set billing alerts at $10, $20, etc.
- Adjust model if needed (use Claude 3.5 Haiku for cheaper option)
```

**Verification:**
- Anthropic Console shows remaining tokens/balance
- API request succeeds with 200 status

---

## Publishing Workflow Issues

### Issue 10: "WordPress returns 401 Unauthorized"

**Symptoms:**
- HTTP POST to WordPress fails
- Error: "invalid credentials"

**Root Cause:**
- Wrong app password or username

**Fix:**
```
1. In WordPress Admin → Users → Your User → Edit
2. Scroll to "Application Passwords"
3. Generate new app password for n8n
4. Copy the 16-character password
5. In n8n Secrets:
   WP_USERNAME = "your-username"
   WP_APP_PASSWORD = "xxxx xxxx xxxx xxxx"
6. In HTTP Request authentication:
   Basic auth using those credentials
7. Test request
```

**Note:** Use app password, NOT your main WordPress password

---

### Issue 11: "WordPress POST succeeds but post doesn't appear as published"

**Symptoms:**
- HTTP returns 200 OK; post created
- But post is draft, not published

**Root Cause:**
- Body parameter `status: "publish"` missing or lowercase wrong

**Fix:**
```json
{
  "title": "...",
  "content": "...",
  "status": "publish",  ✓ (not "published")
  "format": "standard"
}
```

**Valid status values:**
- "draft"
- "publish"
- "pending"
- "private"
- "schedule" (with scheduled_date field)

---

### Issue 12: "If node routing sends to wrong platform"

**Symptoms:**
- Content meant for WordPress sends to Gumroad
- Or no platform matches condition

**Root Cause:**
- If node condition wrong or data field misspelled

**Fix:**
```
If Node condition: {{ $json.platform === 'wordpress' }}

Debug:
1. Add Set node before If to check value:
   debug_platform: {{ $json.platform }}
2. Look at preview; what is actual value?
3. Fix condition to match actual value exactly
4. Check for extra spaces: "wordpress " !== "wordpress"
```

**Verification:**
- Preview If node condition shows True or False
- Click through correct branch in test execution

---

## Error Monitoring Issues

### Issue 13: "Error workflow doesn't trigger"

**Symptoms:**
- Main workflow fails; error workflow doesn't run
- No Slack alert sent

**Root Cause:**
- Error workflow not connected to main workflow
- Error workflow has wrong trigger

**Fix:**
```
1. In main workflow (e.g., Revenue Capture):
   Workflow Settings → Error Workflow → Select error workflow

2. In error workflow:
   First node MUST be: Error Trigger
   (not Webhook, not Schedule)

3. Error Trigger setting:
   Type: "Error Trigger"
   This catches failures from linked workflow
```

**Verification:**
- Intentionally fail main workflow
- Error workflow triggers within 5 seconds
- Slack alert sent

---

### Issue 14: "Slack alert sends but missing key information"

**Symptoms:**
- Alert arrives but doesn't show sale amount, error code, etc.
- Shows empty fields or "undefined"

**Root Cause:**
- Message references wrong variable path

**Fix:**
Check Slack message template:

```
WRONG:
{{ $json.error_message }}  ← If error is nested

CORRECT:
{{ $error.message }}  ← Error trigger exposes as $error

WRONG:
{{ revenue.amount }}  ← Field doesn't exist

CORRECT:
{{ $json.amount }}  ← Correct path from Set node
```

**Fix:**
1. In Slack node, preview message
2. See what values appear
3. Click expression editor to see available fields
4. Map to correct paths

---

### Issue 15: "PostgreSQL error_log fills up; queries slow"

**Symptoms:**
- PostgreSQL queries slow down over time
- error_log table has millions of rows

**Root Cause:**
- Error workflow inserting same error repeatedly
- No cleanup/archival of old errors

**Fix:**
```sql
-- Archive old errors to separate table:
CREATE TABLE error_log_archive AS
SELECT * FROM error_log
WHERE timestamp < DATE_SUB(NOW(), INTERVAL 90 DAYS);

DELETE FROM error_log
WHERE timestamp < DATE_SUB(NOW(), INTERVAL 90 DAYS);

-- Create index for performance:
CREATE INDEX idx_error_log_severity
ON error_log(severity, timestamp);

-- Regular cleanup (run monthly):
DELETE FROM error_log WHERE timestamp < DATE_SUB(NOW(), INTERVAL 180 DAYS);
```

**Prevention:**
- Add automated cleanup job in n8n
- Or add retention policy in PostgreSQL

---

## General n8n Issues

### Issue 16: "Workflow executions keep restarting/looping"

**Symptoms:**
- Workflow runs; completes; starts again immediately
- Multiple executions shown in history

**Root Cause:**
- Trigger condition is always true
- Or error cause infinite retry

**Fix:**
```
1. Check Schedule Trigger:
   - Is "Minutes Between Trigger" correct? (should be 60, not 1)
   - Is Timezone set? (missing TZ causes re-trigger)

2. Check If node after trigger:
   - Does condition ever become False?
   - Or always True?

3. Check error retry logic:
   - Is Wait node actually waiting?
   - Or is retry loop infinite?

4. Fix:
   - Disable workflow temporarily (toggle off)
   - Fix trigger/condition
   - Re-enable and test
```

---

### Issue 17: "n8n cloud workflow times out (> 1 hour)"

**Symptoms:**
- Workflow starts but never completes
- Error: "execution timeout"

**Root Cause:**
- HTTP request hanging
- PostgreSQL query slow
- Wait node duration too long

**Fix:**
```
1. Check HTTP Request timeout:
   HTTP Request node → Advanced → Timeout (seconds)
   Set to 30 (don't wait > 30s for external API)

2. Check Wait node duration:
   If using Wait for delays, reduce to < 5 min total

3. Check PostgreSQL query:
   - Large INSERT loops? Use batch mode
   - Slow SELECT? Add index

4. If issue persists:
   - Break workflow into smaller pieces
   - Use webhook to chain workflows instead of single long workflow
```

---

### Issue 18: "Workflow works in test, fails in production"

**Symptoms:**
- Manual test execution succeeds
- Scheduled execution fails
- Or intermittent failures

**Root Cause:**
- Data variability (real data different from test data)
- Timing issues (race conditions)
- Network latency

**Fix:**
```
1. Use real data for testing:
   - Don't test with dummy values
   - Use sample of actual Gumroad sales

2. Test error conditions:
   - What if Gumroad returns empty array?
   - What if PostgreSQL is slow?
   - What if Claude API timeout?

3. Add data validation:
   [HTTP Request]
     ↓
   [Set: Validate response structure]
     ↓
   [If: Is response valid?]
     ├─ YES: Continue
     └─ NO: Skip and alert
```

---

## Monitoring & Observability

### Issue 19: "Can't see what's happening in workflow"

**Symptoms:**
- Workflow runs; can't debug why it failed
- No visibility into intermediate values

**Fix:**
```
1. Use Set nodes strategically to log state:
   [After each major step, add debug Set node]
     debug_revenue_count: {{ $input.all().length }}
     debug_first_sale: {{ $json[0] }}

2. Check node preview during test:
   Click "Preview" below each node to see output

3. Use PostgreSQL logging:
   Insert DEBUG rows at key points
   Later query: SELECT * FROM debug_log WHERE workflow = 'revenue'

4. Enable execution logging:
   n8n Settings → Logs → Enable detailed logging
   (Cloud tier only)
```

---

### Issue 20: "Need to understand workflow performance"

**Symptoms:**
- How long does each workflow take?
- Which step is slowest?
- How many errors per day?

**Fix:**
```sql
-- Query workflow execution table:
SELECT
  workflow_name,
  DATE(completed_at) as date,
  COUNT(*) as executions,
  AVG(duration_ms) as avg_duration_ms,
  SUM(items_processed) as total_items,
  SUM(items_failed) as total_failures
FROM workflow_executions
WHERE completed_at > DATE_SUB(NOW(), INTERVAL 7 DAYS)
GROUP BY workflow_name, DATE(completed_at);

-- Query error distribution:
SELECT
  workflow_name,
  severity,
  COUNT(*) as count
FROM error_log
WHERE timestamp > DATE_SUB(NOW(), INTERVAL 24 HOURS)
GROUP BY workflow_name, severity;
```

---

## Quick Reference: Most Common Fixes

| Issue | 90-Second Fix |
|-------|---|
| **401 Unauthorized** | Check API key in n8n Secrets; test connection |
| **429 Rate Limit** | Increase batch interval to 1000ms; add Wait node |
| **NULL in column** | Check Set node mapping; preview extraction |
| **Duplicate entry** | Add UNIQUE constraint; check filter logic |
| **Connection timeout** | Check firewall; add n8n IP to security group |
| **Slack message empty** | Check field path (use $json, not $error) |
| **Error workflow silent** | Verify workflow linked in settings; trigger = Error Trigger |
| **Workflow loops forever** | Check Schedule Trigger interval; disable & re-enable |

---

## When to Escalate

If issue persists after trying fixes above:

1. **Collect Logs:**
   - Screenshot of error message
   - n8n execution history (failed execution ID)
   - PostgreSQL query results
   - Slack error message

2. **Check Documentation:**
   - `CEO/research/n8n-automation-architecture.md`
   - n8n Official Docs: https://docs.n8n.io/

3. **Notify Board:**
   - Write to `CEO/inbox/question_YYYY-MM-DD_n8n-issue.md`
   - Include: symptoms, steps tried, logs collected
   - Tag as BLOCKER if revenue workflow down

---

**Keep this guide open while implementing Phase 1-4. Update with new issues as they occur.**

