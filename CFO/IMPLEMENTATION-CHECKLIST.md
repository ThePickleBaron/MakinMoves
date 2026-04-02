# Implementation Checklist: Autonomous Financial Tracking System

**Goal:** Launch fully autonomous CFO financial tracking by 2026-03-31
**Target:** Track $10,000 recovery goal with zero human intervention after user hands-off
**Status:** Ready to deploy (105 minutes estimated)

---

## PHASE 1: DATABASE SETUP (30 minutes)

### Subtask 1.1: Add CFO Tables to PostgreSQL

```bash
# CTMO: Execute this SQL in PostgreSQL
psql -h localhost -U postgres -d n8n << 'EOF'
-- Paste entire SCHEMA section from autonomous-financial-system.md
-- (Copy from "CREATE TABLE public.recovery_goals..." through all indices)
EOF

# Verify tables created:
psql -h localhost -U postgres -d n8n -c "\dt public.*"
# Should show: recovery_goals, daily_revenue, hourly_revenue, costs, processor_fees, etc.
```

**Owner:** CTMO
**Time:** 10 minutes
- [ ] Copy schema SQL from Part 1
- [ ] Execute in PostgreSQL
- [ ] Verify tables exist (\dt public.*)
- [ ] Verify indices created (\di public.idx*)

### Subtask 1.2: Initialize Recovery Goal

```sql
INSERT INTO public.recovery_goals (target_amount, start_date, goal_date, seed_budget, notes)
VALUES (10000.00, '2026-03-29', '2026-06-28', 1000.00, 'Recovery from scam loss - autonomous tracking');

-- Verify:
SELECT * FROM public.recovery_goals;
```

**Owner:** CEO/CFO
**Time:** 2 minutes
- [ ] CEO sets goal via SQL insert
- [ ] CFO verifies goal is in database
- [ ] Note goal_date in BOARD.md

### Subtask 1.3: Initialize First Daily Revenue Row

```sql
INSERT INTO public.daily_revenue (date, digital_products, saas_mrr, content, trading_pnl, total, costs, net, cumulative_revenue, recovery_pct)
VALUES ('2026-03-29', 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Verify:
SELECT * FROM public.daily_revenue WHERE date = '2026-03-29';
```

**Owner:** CFO
**Time:** 2 minutes
- [ ] Create first daily_revenue row
- [ ] Verify data inserted
- [ ] Ready for first hourly sync

---

## PHASE 2: n8n WORKFLOW SETUP (60 minutes)

### Subtask 2.1: Create PostgreSQL Credentials in n8n

**In n8n UI:**
1. Settings → Credentials → Create New → PostgreSQL
2. Fill in:
   - Host: `postgres` (or Docker container IP)
   - Port: `5432`
   - Database: `n8n`
   - User: `postgres`
   - Password: [from .env]
3. Test connection → Should show ✓ "Connection successful"

**Owner:** CTMO
**Time:** 5 minutes
- [ ] Navigate to n8n Credentials page
- [ ] Create PostgreSQL credential
- [ ] Test connection (must pass)
- [ ] Save credential

### Subtask 2.2: Deploy Workflow 1 (Hourly Revenue Sync)

**In n8n UI:**

1. **Create new workflow** → Name: "1. Hourly Revenue Sync"
2. **Add Schedule Trigger:**
   - Node type: Schedule
   - Repeat: Every hour
   - Cron: `0 * * * *`
3. **Add PostgreSQL node (Query revenues):**
   - Paste queries from Workflow 1 section
   - Test → Should return 4 rows (dp, saas, content, trading)
4. **Add JavaScript node (Aggregate):**
   - Paste code from Workflow 1 section
   - Calculates total = dp + saas + content + trading
5. **Add PostgreSQL node (Upsert hourly_revenue):**
   - Query: INSERT INTO public.hourly_revenue (...) VALUES (...) ON CONFLICT...
6. **Add PostgreSQL node (Update daily_revenue):**
   - Query: UPDATE public.daily_revenue SET digital_products=..., saas_mrr=..., etc.
7. **Add PostgreSQL node (Check escalations):**
   - Check if revenue < 50% of 7-day average
   - IF TRUE: INSERT INTO public.alerts
8. **Add Error Handler:**
   - If any node fails, INSERT INTO public.errors
9. **Save and Activate**

**Owner:** CTMO
**Time:** 15 minutes
- [ ] Create Schedule trigger (0 * * * *)
- [ ] Add PostgreSQL query node
- [ ] Add JavaScript aggregation node
- [ ] Add 3x PostgreSQL execute nodes
- [ ] Add error handler
- [ ] Test workflow manually (Execute)
- [ ] Verify hourly_revenue table updated
- [ ] Activate schedule

### Subtask 2.3: Deploy Workflow 2 (Daily Cost Report — 8am)

**Same process as 2.2, but:**
- Schedule: `0 8 * * *` (daily at 8am)
- Simpler: Just query costs, calculate profit, update daily_revenue

**Owner:** CTMO
**Time:** 10 minutes
- [ ] Create Schedule trigger (0 8 * * *)
- [ ] Add PostgreSQL query (costs)
- [ ] Add JavaScript (profit calc)
- [ ] Add PostgreSQL update (daily_revenue)
- [ ] Test manually
- [ ] Activate

### Subtask 2.4: Deploy Workflow 3 (Recovery Progress — 9am)

**Same as 2.3, but:**
- Schedule: `0 9 * * *` (daily at 9am)
- Runs Query 5 (ETA calculation)
- Checks milestone thresholds
- Writes to CFO outbox

**Owner:** CTMO
**Time:** 10 minutes
- [ ] Create Schedule trigger (0 9 * * *)
- [ ] Add PostgreSQL query (Query 5)
- [ ] Add JavaScript (milestone check)
- [ ] Add File Write node (~/CFO/outbox/recovery_YYYY-MM-DD.json)
- [ ] Test manually
- [ ] Activate

### Subtask 2.5: Deploy Workflow 4 (Alerts Digest — Every 4 Hours)

**Same as 2.3, but:**
- Schedule: `0 */4 * * *` (every 4 hours)
- Aggregates all unresolved alerts/errors
- Escalates to CEO inbox if CRITICAL

**Owner:** CTMO
**Time:** 10 minutes
- [ ] Create Schedule trigger (0 */4 * * *)
- [ ] Query alerts + errors
- [ ] Count by severity
- [ ] Conditional: IF critical > 0, write to CEO inbox
- [ ] Test manually
- [ ] Activate

### Subtask 2.6: Deploy Workflow 5 (Weekly Report — Monday 6am)

**Same as 2.3, but:**
- Schedule: `0 6 * * 1` (Monday 6am)
- Runs all 5 CFO queries
- Compiles markdown report
- Writes to CFO outbox

**Owner:** CTMO
**Time:** 10 minutes
- [ ] Create Schedule trigger (0 6 * * 1)
- [ ] Add all 5 CFO query nodes
- [ ] JavaScript to compile markdown
- [ ] File Write to ~/CFO/outbox/report_YYYY-MM-DD.md
- [ ] Test manually
- [ ] Activate

### Subtask 2.7: Test All Workflows

```bash
# In n8n UI → Executions:
1. For each workflow, find last execution
2. Click "Execute" to manually trigger
3. Verify:
   - Green checkmark (no errors)
   - PostgreSQL tables updated
   - Output files created (if applicable)
   - Data looks correct

# Example: After Workflow 1 runs:
psql -h localhost -U postgres -d n8n -c "SELECT * FROM public.hourly_revenue ORDER BY hour DESC LIMIT 1;"
# Should show today's hour with values
```

**Owner:** CTMO
**Time:** 5 minutes
- [ ] Manually execute each workflow
- [ ] Verify no red errors
- [ ] Check database tables updated
- [ ] Verify output files created
- [ ] Review n8n execution log for issues

---

## PHASE 3: CFO STANDUP INTEGRATION (15 minutes)

### Subtask 3.1: Add Query 1 to CFO Hourly Standup

**CFO instructions:**
1. Before writing hourly standup, run Query 1 (Hourly Dashboard)
2. Copy from ~/CFO/queries-quick-reference.sql
3. Paste into psql:
```bash
psql -h localhost -U postgres -d n8n << 'EOF'
[Paste Query 1 here]
EOF
```
4. Extract values: goal, total_recovered, recovery_pct, this_hour_revenue, remaining_to_goal
5. Include in standup:

```markdown
## CFO
- **Status:**
  - Recovery: [recovery_pct]% ($[total_recovered] of $[goal])
  - This hour: $[this_hour_revenue]
  - Remaining: $[remaining_to_goal]
  - No alerts
- **Blockers:** None
- **Next hour:** Monitor revenue, process payments
```

**Owner:** CFO
**Time:** 5 minutes
- [ ] Save Query 1 in terminal alias or script
- [ ] Practice running before first standup
- [ ] Integrate into standup template
- [ ] Verify numbers make sense

### Subtask 3.2: Update CFO Role Description

**Edit `./CFO/CLAUDE.md`:**

Add section:
```markdown
## Database Queries Available

**Query 1 (Hourly Dashboard):** Recovery %, revenue today, ETA
**Query 2 (By Stream):** Compare 4 streams week-over-week
**Query 3 (Costs & Profit):** Daily/weekly burn rate
**Query 4 (Active Alerts):** Unresolved issues requiring action
**Query 5 (Recovery ETA):** Days to $10K goal at current velocity

See ~/CFO/queries-quick-reference.sql for copy/paste templates.
```

**Owner:** CFO
**Time:** 5 minutes
- [ ] Edit ./CFO/CLAUDE.md
- [ ] Add "Database Queries" section
- [ ] Link to queries-quick-reference.sql
- [ ] Update example standup with real Query 1 output

---

## VERIFICATION CHECKLIST (5 minutes)

### Verify All Systems Working

```bash
# 1. Check all 5 workflows are active
# In n8n UI → Workflows → Should show all 5 with green "Active" badge

# 2. Check database tables have data
psql -h localhost -U postgres -d n8n << 'EOF'
SELECT 'recovery_goals' as table_name, COUNT(*) as rows FROM public.recovery_goals
UNION ALL SELECT 'daily_revenue', COUNT(*) FROM public.daily_revenue
UNION ALL SELECT 'hourly_revenue', COUNT(*) FROM public.hourly_revenue
UNION ALL SELECT 'costs', COUNT(*) FROM public.costs
UNION ALL SELECT 'alerts', COUNT(*) FROM public.alerts
UNION ALL SELECT 'errors', COUNT(*) FROM public.errors;
EOF

# 3. Check n8n has executed workflows
# In n8n UI → Executions → Should see recent runs

# 4. Test CFO Query 1 manually
psql -h localhost -U postgres -d n8n << 'EOF'
[Copy Query 1 from queries-quick-reference.sql]
EOF
# Should return: goal, total_recovered, recovery_pct, today_revenue, etc.

# 5. Verify CFO can access query file
cat ~/CFO/queries-quick-reference.sql | head -20
# Should show CFO queries
```

**Owner:** CTMO + CFO
**Time:** 5 minutes
- [ ] Verify all 5 workflows active in n8n
- [ ] Check database tables have rows
- [ ] Verify n8n execution history
- [ ] Test Query 1 manually (CFO)
- [ ] Confirm all setup files present

---

## DEPLOYMENT SIGN-OFF

### By CTMO:
- [ ] PostgreSQL tables created
- [ ] All 5 n8n workflows deployed + tested
- [ ] n8n executing on schedule
- [ ] No database connectivity issues
- [ ] All queries return expected data

### By CFO:
- [ ] Query 1 tested manually
- [ ] CLAUDE.md updated
- [ ] Ready to integrate into hourly standup
- [ ] Understands escalation thresholds
- [ ] Backup query commands saved locally

### By CEO:
- [ ] Recovery goal initialized in database
- [ ] All alerts configured for visibility
- [ ] Understands escalation protocol
- [ ] Ready for autonomous operation

---

## SCHEDULE FOR ACTIVATION

**2026-03-29 (Today):** Setup complete, all systems tested
**2026-03-30:** Last day with human input → finalize all workflows
**2026-03-31:** User hands-off → System fully autonomous
**2026-04-01+:** Autonomous operation begins (zero human intervention)

---

## TROUBLESHOOTING QUICK REFERENCE

| Issue | Check | Fix |
|-------|-------|-----|
| Workflow not running on schedule | n8n Executions tab → last run | Restart n8n container |
| PostgreSQL query returns NULL | Check table exists (\dt) | Verify insert worked; check data type |
| Alert not triggering | Review alert INSERT logic | Manually test conditional |
| CFO can't run Query 1 | psql installed? | Install PostgreSQL client tools |
| n8n dashboard blank | Browser cache | Clear cache, refresh |

---

## ESTIMATED TIMELINE

| Phase | Task | Owner | Duration | Status |
|-------|------|-------|----------|--------|
| 1.1 | Add CFO tables to PostgreSQL | CTMO | 10 min | Pending |
| 1.2 | Initialize recovery goal | CEO/CFO | 2 min | Pending |
| 1.3 | Initialize first daily_revenue row | CFO | 2 min | Pending |
| 2.1 | Create PostgreSQL credentials in n8n | CTMO | 5 min | Pending |
| 2.2 | Deploy Workflow 1 (Hourly Sync) | CTMO | 15 min | Pending |
| 2.3 | Deploy Workflow 2 (Daily Cost) | CTMO | 10 min | Pending |
| 2.4 | Deploy Workflow 3 (Recovery Progress) | CTMO | 10 min | Pending |
| 2.5 | Deploy Workflow 4 (Alerts Digest) | CTMO | 10 min | Pending |
| 2.6 | Deploy Workflow 5 (Weekly Report) | CTMO | 10 min | Pending |
| 2.7 | Test all workflows | CTMO | 5 min | Pending |
| 3.1 | Add Query 1 to CFO standup | CFO | 5 min | Pending |
| 3.2 | Update CFO role description | CFO | 5 min | Pending |
| Verify | Final verification checklist | CTMO+CFO | 5 min | Pending |
| **TOTAL** | **Full autonomous system live** | **Team** | **105 minutes** | **Ready** |

---

## NOTES

- This checklist assumes Docker services (PostgreSQL, n8n) already running
- All SQL can be copy/pasted directly (no modifications needed)
- n8n workflow templates provided — just fill in credentials
- System is fully autonomous after Phase 3 complete
- CFO needs only Query 1 for hourly standup (rest automated)
- No code to write — purely configuration

