# n8n Autonomous Workflows — Setup Guide

**Objective:** Automate all CFO financial tracking via n8n scheduled workflows
**Platform:** n8n (running in Docker)
**Database:** PostgreSQL (localhost:5432)
**Timeline:** 60 minutes to deploy all 5 workflows

---

## WORKFLOW 1: Hourly Revenue Sync

**Schedule:** Every hour at :00 (0 * * * *)
**Duration:** 2-3 minutes per run
**Output:** Updates `daily_revenue`, `hourly_revenue` tables

### n8n Flow:

```
START (Schedule: 0 * * * *)
  ↓
[1] PostgreSQL: Query all revenue sources
  ├─ SELECT * FROM digital_products.sales WHERE sale_date >= NOW() - INTERVAL '1 hour'
  ├─ SELECT * FROM saas.subscribers WHERE status = 'active'
  ├─ SELECT * FROM content.revenue WHERE period_end >= CURRENT_DATE
  ├─ SELECT * FROM trading.trades WHERE executed_at >= NOW() - INTERVAL '1 hour'
  ↓
[2] JavaScript: Aggregate results
  ├─ total_dp = sum(digital_products.net_amount)
  ├─ total_saas = sum(saas.mrr)
  ├─ total_content = sum(content.amount)
  ├─ total_trading = sum(trading.pnl)
  ├─ total_combined = total_dp + total_saas + total_content + total_trading
  ↓
[3] PostgreSQL: Upsert hourly_revenue
  INSERT INTO public.hourly_revenue (hour, digital_products, saas_mrr, content, trading_pnl, total, new_transactions)
  VALUES (DATE_TRUNC('hour', NOW()), $1, $2, $3, $4, $5, ...)
  ON CONFLICT (hour) DO UPDATE SET ...
  ↓
[4] PostgreSQL: Update daily_revenue
  UPDATE public.daily_revenue SET
    digital_products = (SELECT SUM(digital_products) FROM hourly_revenue WHERE DATE(hour) = CURRENT_DATE),
    saas_mrr = (SELECT SUM(saas_mrr) FROM hourly_revenue WHERE DATE(hour) = CURRENT_DATE),
    ... [etc for all fields]
  WHERE date = CURRENT_DATE
  ↓
[5] PostgreSQL: Check escalation thresholds
  ├─ IF daily_revenue < (7_day_avg * 0.5) THEN create CRITICAL alert
  ├─ IF costs > (daily_revenue * 0.4) THEN create WARNING alert
  ├─ IF processor_fees > (daily_revenue * 0.05) THEN create WARNING alert
  ↓
[6] Error Handler: If PostgreSQL fails
  ├─ INSERT INTO public.errors (error_type, source, message, resolved)
  ├─ Email CTMO + CFO (workflow error)
  ↓
[7] Log: Write to CFO inbox (ready for standup)
  → ~/CFO/outbox/hourly_sync_YYYY-MM-DD_HH-00.json
  ↓
END
```

### n8n Configuration (JSON):

```json
{
  "name": "Hourly Revenue Sync",
  "nodes": [
    {
      "type": "Schedule Trigger",
      "typeVersion": 1,
      "position": [100, 100],
      "properties": {
        "interval": [1, "hour"],
        "cronExpression": "0 * * * *"
      }
    },
    {
      "type": "PostgreSQL",
      "typeVersion": 1,
      "position": [300, 100],
      "properties": {
        "host": "postgres",
        "port": 5432,
        "database": "n8n",
        "user": "postgres",
        "password": "{{ env('POSTGRES_PASSWORD') }}",
        "queries": {
          "digital_products": "SELECT COALESCE(SUM(net_amount), 0) FROM digital_products.sales WHERE sale_date >= NOW() - INTERVAL '1 hour'",
          "saas_mrr": "SELECT COALESCE(SUM(mrr), 0) FROM saas.subscribers WHERE status = 'active'",
          "content": "SELECT COALESCE(SUM(amount), 0) FROM content.revenue WHERE period_end >= CURRENT_DATE",
          "trading": "SELECT COALESCE(SUM(pnl), 0) FROM trading.trades WHERE executed_at >= NOW() - INTERVAL '1 hour'"
        }
      }
    },
    {
      "type": "JavaScript",
      "typeVersion": 1,
      "position": [500, 100],
      "properties": {
        "code": "return {\n  digital_products: $input.first().json.digital_products[0].coalesce,\n  saas_mrr: $input.first().json.saas_mrr[0].coalesce,\n  content: $input.first().json.content[0].coalesce,\n  trading: $input.first().json.trading[0].coalesce,\n  total: ($input.first().json.digital_products[0].coalesce || 0) + ($input.first().json.saas_mrr[0].coalesce || 0) + ($input.first().json.content[0].coalesce || 0) + ($input.first().json.trading[0].coalesce || 0)\n};"
      }
    },
    {
      "type": "PostgreSQL",
      "typeVersion": 1,
      "position": [700, 100],
      "properties": {
        "host": "postgres",
        "port": 5432,
        "database": "n8n",
        "user": "postgres",
        "query": "INSERT INTO public.hourly_revenue (hour, digital_products, saas_mrr, content, trading_pnl, total) VALUES (DATE_TRUNC('hour', NOW()), {{ $json.digital_products }}, {{ $json.saas_mrr }}, {{ $json.content }}, {{ $json.trading }}, {{ $json.total }}) ON CONFLICT (hour) DO UPDATE SET digital_products = EXCLUDED.digital_products, saas_mrr = EXCLUDED.saas_mrr, content = EXCLUDED.content, trading_pnl = EXCLUDED.trading_pnl, total = EXCLUDED.total"
      }
    }
  ]
}
```

---

## WORKFLOW 2: Daily Cost & Profit Report (8am UTC)

**Schedule:** 0 8 * * * (every day at 8am)
**Duration:** 2 minutes
**Output:** Updates `daily_revenue` costs, alerts on cost spike

### n8n Flow:

```
START (Schedule: 0 8 * * *)
  ↓
[1] PostgreSQL: Get today's costs
  SELECT SUM(amount) FROM public.costs WHERE date = CURRENT_DATE
  ↓
[2] PostgreSQL: Get revenue sources (processor fees auto-calculated)
  SELECT SUM(fee_amount) FROM public.processor_fees WHERE DATE(date) = CURRENT_DATE
  ↓
[3] JavaScript: Calculate metrics
  daily_revenue = (from hourly_revenue sum for today)
  daily_costs = costs + processor_fees
  daily_profit = daily_revenue - daily_costs
  cost_ratio = (daily_costs / daily_revenue) * 100
  ↓
[4] PostgreSQL: Update daily_revenue
  UPDATE public.daily_revenue SET
    costs = $1,
    net = $2,
    updated_at = NOW()
  WHERE date = CURRENT_DATE
  ↓
[5] Conditional: Check cost ratio
  IF cost_ratio > 40% THEN
    INSERT INTO public.alerts (alert_type, severity, message, ...)
  ↓
[6] Log: Write to CFO outbox
  → ~/CFO/outbox/daily_cost_report_YYYY-MM-DD.md
  ↓
END
```

---

## WORKFLOW 3: Daily Recovery Progress (9am UTC)

**Schedule:** 0 9 * * * (every day at 9am)
**Duration:** 1 minute
**Output:** Updates recovery %, ETA, escalates milestones

### n8n Flow:

```
START (Schedule: 0 9 * * *)
  ↓
[1] PostgreSQL: Run Query 5 (Recovery Progress & ETA)
  ↓
[2] JavaScript: Extract key metrics
  recovery_pct = (recovered / goal) * 100
  days_to_goal = (goal - recovered) / daily_avg
  projected_completion = start_date + days_to_goal
  ↓
[3] PostgreSQL: Update daily_revenue cumulative columns
  UPDATE public.daily_revenue SET
    cumulative_revenue = SUM(total) WHERE date <= CURRENT_DATE,
    recovery_pct = (cumulative_revenue / 10000) * 100
  ↓
[4] Conditional: Check milestone thresholds
  IF recovery_pct crosses 10%, 25%, 50%, 75%, 90% THEN
    INSERT INTO public.alerts (severity='ESCALATION', message="Recovery milestone reached")
    → Write to CEO inbox (CRITICAL alert)
  ↓
[5] Log: Write CFO outbox
  → ~/CFO/outbox/recovery_progress_YYYY-MM-DD.json
  ↓
[6] Update BOARD.md (append recovery status)
  ↓
END
```

---

## WORKFLOW 4: Active Alerts Digest (Every 4 Hours)

**Schedule:** 0 */4 * * * (every 4 hours)
**Duration:** 1 minute
**Output:** Aggregates alerts, escalates critical issues

### n8n Flow:

```
START (Schedule: 0 */4 * * *)
  ↓
[1] PostgreSQL: Get unacknowledged alerts + errors
  SELECT * FROM public.alerts WHERE acknowledged = FALSE AND created_at >= NOW() - INTERVAL '24 hours'
  SELECT * FROM public.errors WHERE resolved = FALSE AND last_occurred >= NOW() - INTERVAL '24 hours'
  ↓
[2] JavaScript: Count by severity
  info_count = COUNT(severity = 'info')
  warning_count = COUNT(severity = 'warning')
  critical_count = COUNT(severity = 'critical')
  escalation_count = COUNT(type = 'ESCALATION')
  ↓
[3] Conditional: Escalate to CEO if needed
  IF critical_count > 0 OR escalation_count > 0 THEN
    Write to ~/CEO/inbox/financial_alert_YYYY-MM-DD.md
  ↓
[4] Log: Write to CFO outbox
  → ~/CFO/outbox/alert_digest_YYYY-MM-DD_HH00.json
  ↓
END
```

---

## WORKFLOW 5: Weekly Financial Report (Monday 6am)

**Schedule:** 0 6 * * 1 (Monday 6am UTC)
**Duration:** 5 minutes
**Output:** Comprehensive weekly markdown report

### n8n Flow:

```
START (Schedule: 0 6 * * 1)
  ↓
[1] PostgreSQL: Query all week metrics (all 5 queries)
  ├─ Query 1: Hourly dashboard
  ├─ Query 2: Revenue by stream
  ├─ Query 3: Costs & profit
  ├─ Query 4: Alerts
  ├─ Query 5: Recovery progress
  ↓
[2] JavaScript: Format as markdown report
  Compile template:
  # Weekly Financial Report — Week of YYYY-MM-DD

  ## Revenue This Week
  - Digital Products: $XXX
  - SaaS: $XXX
  - Content: $XXX
  - Trading: $XXX
  - **Total: $XXX**

  ## Recovery Progress
  - Target: $10,000
  - Recovered: $XXXX
  - Progress: XX%
  - ETA: YYYY-MM-DD

  ## Costs
  - Total this week: $XX
  - Cost ratio: X%
  - Processor fees: $X

  ## Alerts & Issues
  - Critical: X
  - Warnings: X
  - Resolved: X

  ## Recommendations
  [Auto-generated based on metrics]
  ↓
[3] File Write: Save to CFO outbox
  → ~/CFO/outbox/report_YYYY-MM-DD_weekly.md
  ↓
[4] Conditional: Email report to CEO
  IF any CRITICAL issues THEN send immediately
  ELSE queue for Monday standup
  ↓
END
```

---

## INSTALLATION STEPS (In n8n UI)

### Step 1: Create PostgreSQL Credentials

```
Settings → Credentials → PostgreSQL
- Host: postgres
- Port: 5432
- Database: n8n
- User: postgres
- Password: [from .env]
- Test connection → Should show ✓
```

### Step 2: Import Workflow 1 (Hourly Sync)

1. Create new workflow → "Hourly Revenue Sync"
2. Add node: "Schedule Trigger"
   - Repeat every: 1 hour
   - Cron: 0 * * * *
3. Add node: "PostgreSQL" (Query)
   - Credential: [from Step 1]
   - Query: (see Workflow 1 code above)
4. Add node: "JavaScript"
   - Code: (see Workflow 1 code above)
5. Add node: "PostgreSQL" (Execute)
   - INSERT INTO hourly_revenue
6. Add node: "PostgreSQL" (Check escalations)
   - IF daily_revenue < threshold
7. Add node: "Error Handler"
   - Catch failures, log to errors table
8. Save and activate

### Step 3: Import Workflows 2–5

Repeat Step 2 for each workflow, using the flow diagrams above.

### Step 4: Test All Workflows

```bash
# In n8n UI:
1. For each workflow, click "Test Workflow"
2. Verify PostgreSQL connection succeeds
3. Check tables are created (SELECT COUNT(*) FROM public.daily_revenue)
4. Manually trigger each once (should execute successfully)
5. Check logs for errors
```

### Step 5: Verify Schedule

```bash
# In n8n UI → Executions:
- Workflow 1 should run at :00 every hour
- Workflow 2 should run at 08:00 UTC daily
- Workflow 3 should run at 09:00 UTC daily
- Workflow 4 should run at 0, 4, 8, 12, 16, 20 hours
- Workflow 5 should run Monday at 06:00 UTC
```

---

## ERROR HANDLING & RECOVERY

### If n8n Workflow Fails

1. **Check n8n Execution Log:**
   - Go to workflow → Executions
   - Find failed run → view error message

2. **Common Issues:**
   - PostgreSQL connection lost → Restart postgres container
   - Query syntax error → Review SQL in node
   - File write failure → Check file permissions

3. **Recovery:**
   - Fix issue
   - Restart workflow
   - Manual data sync (CFO runs Query 1 manually)

### If Data Gets Stale

1. CFO manually runs Query 1 + Query 3
2. Updates daily_revenue manually
3. Escalates to CTMO if n8n is offline > 15 min

### Monitoring Checklist

- [ ] All 5 workflows scheduled
- [ ] All workflows show "Active"
- [ ] Last execution time is recent
- [ ] No red error messages
- [ ] PostgreSQL tables have data (SELECT COUNT(*) > 0)

---

## ENVIRONMENT VARIABLES (Docker)

In `docker-compose.yml` or `.env`:

```
# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=[strong password]
POSTGRES_DB=n8n

# n8n
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=[strong password]
```

---

## NEXT STEPS

1. **Deploy schemas** → Run init-db.sql
2. **Create PostgreSQL credentials** in n8n
3. **Import 5 workflows** from templates above
4. **Test each workflow** manually
5. **Enable schedules** (set to active)
6. **Monitor first 24 hours** — ensure all run on time
7. **CFO integrates Query 1 into hourly standup**

**Total deployment time: ~60 minutes**

