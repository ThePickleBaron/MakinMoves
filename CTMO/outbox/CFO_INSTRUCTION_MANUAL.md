# CFO Operations Manual: Autonomous Financial Reporting
**Version 1.0** | Effective 2026-03-31 | No SQL Knowledge Required

## Quick Start: 5-Minute Setup

You have **8 built-in SQL functions** that run without you writing any code. Just call them, read results.

### The 5 Core Reports You'll Use

| Report | Command | When to Run | Output |
|--------|---------|-----------|--------|
| **Daily Snapshot** | `SELECT * FROM get_daily_revenue();` | Every morning | Today's revenue by platform |
| **Weekly Summary** | `SELECT * FROM get_weekly_summary();` | Every Monday | Last 7 days breakdown |
| **Monthly Report** | `SELECT * FROM get_monthly_report();` | 1st of month | Full P&L statement |
| **Recovery Progress** | `SELECT * FROM get_recovery_progress();` | Anytime | Progress toward $10k goal |
| **Platform Ranking** | `SELECT * FROM get_platform_ranking();` | Weekly | Which platform is winning |

---

## Part 1: Core Financial Functions (No SQL Needed)

### 1. DAILY REVENUE SNAPSHOT

**What it does:** Shows today's total earnings + breakdown by platform

**How to run:**
```sql
SELECT * FROM get_daily_revenue();
```

**What you see:**
```
platform            | source     | gross_amount | fees  | net_amount | transaction_count | total_net
────────────────────┼────────────┼──────────────┼───────┼────────────┼──────────────────┼──────────
digital_products    | Gumroad    | 45.00        | 6.75  | 38.25      | 2                 | 43.50
content             | AdSense    | 5.25         | 0     | 5.25       | 1                 | 43.50
```

**What to look for:**
- ✅ Total net > $5? = Health OK
- ⚠️ Total net = $0? = Check error logs (see below)
- ✅ Multiple platforms earning? = Good diversification

---

### 2. WEEKLY SUMMARY

**What it does:** Last 7 days of revenue by platform + daily average

**How to run:**
```sql
SELECT * FROM get_weekly_summary();
```

**What you see:**
```
platform          | total_transactions | total_gross | total_fees | total_net | avg_daily
──────────────────┼───────────────────┼─────────────┼────────────┼───────────┼──────────
digital_products  | 14                 | 320.00      | 48.00      | 272.00    | 38.86
content           | 7                  | 52.50       | 0          | 52.50     | 7.50
TOTAL             | 21                 | 372.50      | 48.00      | 324.50    | 46.36
```

**What to analyze:**
- Trending up week-to-week? = Platform gaining momentum
- Which platform carries most revenue? = Focus area for optimization
- Average daily tells you baseline (should be consistent or growing)

---

### 3. MONTHLY FINANCIAL REPORT

**What it does:** Full P&L statement: Revenue vs. Costs vs. Net Profit

**How to run:**
```sql
SELECT * FROM get_monthly_report();
```

**What you see:**
```
metric       | platform          | value   | transaction_count
─────────────┼───────────────────┼─────────┼───────────────────
Revenue      | digital_products  | 1245.00 | 52
Revenue      | content           | 315.00  | 28
Revenue      | TOTAL             | 1560.00 | 80
Costs        | Infrastructure    | 50.00   | 0
Net Profit   | BOTTOM LINE       | 1510.00 | 0
```

**Analysis checklist:**
- Net Profit > 0? = You're ahead that month
- Cost % of Revenue < 10%? = Healthy (your target)
- Revenue growing month-to-month? = Compound effect working

---

### 4. RECOVERY PROGRESS TRACKER

**What it does:** Shows progress toward $10,000 recovery goal + days until target

**How to run:**
```sql
SELECT * FROM get_recovery_progress();
```

**What you see:**
```
target_amount | total_earned | amount_remaining | progress_percent | days_elapsed | avg_daily_rate | days_to_goal
──────────────┼──────────────┼──────────────────┼──────────────────┼──────────────┼────────────────┼──────────────
10000.00      | 2345.75      | 7654.25          | 23.46            | 28           | 83.77          | 91
```

**What it means:**
- **progress_percent:** You're 23.46% of the way to $10k
- **avg_daily_rate:** Making ~$84/day on average
- **days_to_goal:** ~91 days at current rate (mid-June 2026)
- **Key insight:** If this is trending down, revenue is slowing

---

### 5. PLATFORM RANKING

**What it does:** Ranks which revenue stream is performing best

**How to run:**
```sql
SELECT * FROM get_platform_ranking();
```

**What you see:**
```
rank | platform          | total_revenue | percentage_of_total | transactions | status
─────┼───────────────────┼───────────────┼─────────────────────┼──────────────┼────────
1    | digital_products  | 3450.00       | 68.5%               | 142          | active
2    | content           | 1240.00       | 24.6%               | 68           | active
3    | saas              | 340.00        | 6.8%                | 12           | planning
```

**Action items:**
- Top platform doing 68.5% = Maybe too concentrated? Build #2 & #3?
- SaaS at 6.8% = Still experimental, needs growth push
- Content earning steadily = Good for passive income

---

## Part 2: Monitoring & Alerts

### 6. DAILY HEALTH CHECK

**What it does:** Alerts you if today's revenue is suspiciously low (< $5)

**How to run:**
```sql
SELECT * FROM check_daily_revenue_alert();
```

**What you see (if healthy):**
```
alert_triggered | today_revenue | threshold | message           | action_required
────────────────┼───────────────┼───────────┼───────────────────┼────────────────
false           | 47.50         | 5         | Revenue healthy   | None
```

**What you see (if problem):**
```
alert_triggered | today_revenue | threshold | message                                      | action_required
────────────────┼───────────────┼───────────┼──────────────────────────────────────────────┼─────────────────────────────────────────
true            | 0             | 5         | No revenue recorded today - check publishing | Review publishing_log and error_logs
```

**If alert triggered:**
1. Check recent errors (see below)
2. Verify n8n workflows are running
3. Check publishing_log to see what failed

---

### 7. RECENT ERRORS

**What it does:** Shows failed integrations, API errors, n8n workflow failures

**How to run:**
```sql
SELECT * FROM get_recent_errors(24);  -- Last 24 hours (adjust as needed)
```

**What you see:**
```
error_id | timestamp           | source      | error_type   | severity | message                    | resolved
─────────┼─────────────────────┼─────────────┼──────────────┼──────────┼────────────────────────────┼──────────
42       | 2026-03-29 14:32:15 | n8n_workflow| timeout      | high     | Gumroad API timeout        | false
41       | 2026-03-29 10:15:00 | api         | auth_failure | critical | Stripe key expired         | false
```

**Action:**
- **auth_failure on Stripe?** = Refresh API key immediately
- **timeout?** = Usually temporary, will auto-retry
- **If critical:** = Platform may be down, needs manual intervention

---

### 8. PUBLISHING LOG

**What it does:** Tracks what was published and initial performance

**How to run:**
```sql
SELECT * FROM get_publishing_status(7);  -- Last 7 days (adjust as needed)
```

**What you see:**
```
publish_date | platform   | content_type | title                         | status  | views | revenue_generated
─────────────┼────────────┼──────────────┼───────────────────────────────┼─────────┼───────┼──────────────────
2026-03-29   | Gumroad    | product      | Email Template Bundle #5      | success | 247   | 38.25
2026-03-29   | Medium     | article      | Beginner's Guide to Workflows | success | 1842  | 12.50
2026-03-28   | Twitter    | update       | New product launch            | failed  | 0     | 0
```

**What to monitor:**
- Views > 100 on new content? = Good initial traction
- Failed status? = Check error_logs for what went wrong
- Revenue trending with views? = Content monetizing properly

---

## Part 3: Forecasting & Analysis

### 9. FORECAST RECOVERY DATES

**What it does:** Projects when you'll hit $1k, $5k, $10k milestones

**How to run:**
```sql
SELECT * FROM forecast_recovery_date(10000);
```

**What you see:**
```
milestone_amount | days_to_milestone | projected_date | confidence
─────────────────┼───────────────────┼────────────────┼──────────────────────
1000             | 3                 | 2026-04-01     | Medium
5000             | 45                | 2026-05-13     | Medium
10000            | 91                | 2026-06-29     | Medium
```

**What it means:**
- You should hit $1k in 3 days (April 1)
- $5k in ~6 weeks
- $10k in ~3 months (late June)
- **Confidence levels:**
  - Low = < 1 week of data (don't trust yet)
  - Medium = 1-4 weeks of data
  - High = > 1 month of data

**Use this to:**
- Adjust strategy if timeline slipping
- Identify which platform can get you there fastest
- Plan marketing pushes for lagging platforms

---

### 10. BURN RATE ANALYSIS

**What it does:** Monthly revenue vs. costs (3-month trend)

**How to run:**
```sql
SELECT * FROM get_burn_rate(3);  -- Last 3 months
```

**What you see:**
```
month_name | total_revenue | total_costs | net_profit | profit_margin_percent
───────────┼───────────────┼─────────────┼────────────┼──────────────────────
2026-03    | 1845.00       | 50.00       | 1795.00    | 97.29%
2026-02    | 1250.00       | 50.00       | 1200.00    | 96.00%
2026-01    | 890.00        | 50.00       | 840.00     | 94.38%
```

**Analysis:**
- **97% profit margin?** = Excellent. Infrastructure cost is negligible.
- **Trend up month-to-month?** = Compounding working (Jan→Feb→Mar growing)
- **If reversed?** = Alert: revenue declining while costs stay same

---

## Part 4: Feeding Data Into the System

### How Revenue Gets Recorded

CFO, you don't enter data manually. Here's how it flows:

**Flow:**
1. **n8n Workflows** pull sales data from Gumroad, Stripe, AdSense, etc.
2. **Automated scripts** insert into `revenue_daily` table
3. **Your reports** read from that table

**You only manually insert data if:**
- One-time sales (manual deal, referral payment)
- Platform doesn't have API integration yet
- Need to correct a past entry

### Manual Entry (If Needed)

```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES
(CURRENT_DATE, 'digital_products', 'Direct Sale', 100.00, 15.00, 85.00, 1, 'Manual entry: affiliate referral');
```

Then run refresh functions to update aggregates:
```sql
SELECT refresh_weekly_aggregates();
SELECT refresh_monthly_aggregates();
```

### Monthly Costs Entry

When you have a new recurring cost (e.g., new domain, tool subscription):

```sql
INSERT INTO public.costs_monthly
(year_month, category, vendor, amount, recurring, notes)
VALUES
(DATE_TRUNC('month', CURRENT_DATE)::DATE, 'Tools', 'ConvertKit', 29.00, true, 'Email platform for newsletters');
```

---

## Part 5: Daily/Weekly/Monthly Routines

### DAILY ROUTINE (5 minutes, every morning)

1. **Check today's revenue:**
   ```sql
   SELECT * FROM get_daily_revenue();
   ```

2. **Alert check:**
   ```sql
   SELECT * FROM check_daily_revenue_alert();
   ```
   - If alert triggered, check errors below

3. **Recent errors (last 24h):**
   ```sql
   SELECT * FROM get_recent_errors(24);
   ```
   - Any critical? Fix immediately

### WEEKLY ROUTINE (15 minutes, every Monday)

1. **Run weekly report:**
   ```sql
   SELECT * FROM get_weekly_summary();
   ```

2. **Platform ranking:**
   ```sql
   SELECT * FROM get_platform_ranking();
   ```

3. **Publishing status:**
   ```sql
   SELECT * FROM get_publishing_status(7);
   ```

4. **Refresh aggregates:**
   ```sql
   SELECT refresh_weekly_aggregates();
   ```

### MONTHLY ROUTINE (20 minutes, 1st of month)

1. **Full P&L statement:**
   ```sql
   SELECT * FROM get_monthly_report();
   ```

2. **Burn rate analysis:**
   ```sql
   SELECT * FROM get_burn_rate(3);
   ```

3. **Recovery progress:**
   ```sql
   SELECT * FROM get_recovery_progress();
   ```

4. **Forecast check:**
   ```sql
   SELECT * FROM forecast_recovery_date(10000);
   ```

5. **Refresh monthly data:**
   ```sql
   SELECT refresh_monthly_aggregates();
   ```

6. **Add any new costs for this month** (see Part 4)

---

## Part 6: Troubleshooting

### "My daily revenue shows $0 but I know there were sales"

**Check these (in order):**

1. **Did we record any revenue today?**
   ```sql
   SELECT COUNT(*) FROM public.revenue_daily WHERE date = CURRENT_DATE;
   ```
   - If 0 rows = n8n workflows didn't run

2. **Are there API errors?**
   ```sql
   SELECT * FROM get_recent_errors(24);
   ```
   - Look for 'auth_failure' or 'timeout'

3. **Did platform publishing fail?**
   ```sql
   SELECT * FROM get_publishing_status(1);  -- Last 1 day
   ```
   - Check if status = 'failed'

4. **Check n8n directly**
   - Log into n8n UI
   - Check workflow execution logs
   - Manually trigger workflow if stuck

### "Days to goal keeps increasing"

**Means:** Revenue is declining or flat relative to goal

**Action:**
```sql
SELECT * FROM get_burn_rate(3);  -- Check trend
SELECT * FROM get_platform_ranking();  -- Which platform slowed?
```

Then focus marketing effort on slowest platform.

### "An API key expired"

**Find it:**
```sql
SELECT * FROM get_recent_errors(24) WHERE error_type = 'auth_failure';
```

**Fix it:**
1. Identify which platform (e.g., Stripe)
2. Go to that platform's settings
3. Regenerate API key
4. Update n8n workflow with new key
5. Test integration

---

## Part 7: Database Backup & Disaster Recovery

### Weekly Backup

**You should do this every Sunday:**

```bash
# From your container
docker exec makinmoves-postgres pg_dump -U postgres -d n8n > backup_$(date +%Y-%m-%d).sql

# Or use managed backup if on Railway/Heroku (automatic)
```

**Store backups:**
- Local: `./backups/` folder
- Cloud: Drive/Dropbox for safety

### If Data Gets Corrupted

**Restore from backup:**
```bash
docker exec -i makinmoves-postgres psql -U postgres -d n8n < backup_2026-03-28.sql
```

---

## Part 8: When to Escalate to CTMO

You don't need to be technical, but know when to ask:

**Escalate if:**
- ❌ Functions return errors
- ❌ Can't connect to database
- ❌ Backup/restore fails
- ❌ Need to add new platform/revenue stream
- ❌ Want to modify report structure

**You CAN handle:**
- ✅ Running pre-built reports
- ✅ Entering manual revenue/costs
- ✅ Analyzing results
- ✅ Setting up alerts

---

## Part 9: The 8 Functions at a Glance

```
1. get_daily_revenue()           → Today's earnings by platform
2. get_weekly_summary()          → Last 7 days
3. get_monthly_report()          → Full P&L statement
4. get_recovery_progress()       → $10k goal progress
5. get_platform_ranking()        → Which platform winning
6. check_daily_revenue_alert()   → Health check (< $5 alert)
7. get_recent_errors()           → Failed integrations
8. get_publishing_status()       → What shipped, how it performed
+ forecast_recovery_date()       → When hit $1k/$5k/$10k
+ get_burn_rate()                → Cost vs. revenue trend
```

---

## Quick Reference: SQL Cheat Sheet

**Copy/paste these commands:**

```sql
-- Daily snapshot
SELECT * FROM get_daily_revenue();

-- Weekly summary
SELECT * FROM get_weekly_summary();

-- Monthly P&L
SELECT * FROM get_monthly_report();

-- Recovery tracker
SELECT * FROM get_recovery_progress();

-- Platform rankings
SELECT * FROM get_platform_ranking();

-- Health alert
SELECT * FROM check_daily_revenue_alert();

-- Recent errors (last 24 hours)
SELECT * FROM get_recent_errors(24);

-- Publishing performance (last 7 days)
SELECT * FROM get_publishing_status(7);

-- Forecast milestones
SELECT * FROM forecast_recovery_date(10000);

-- Burn rate (last 3 months)
SELECT * FROM get_burn_rate(3);

-- Refresh aggregates (do weekly)
SELECT refresh_weekly_aggregates();
SELECT refresh_monthly_aggregates();

-- Manual revenue entry
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count)
VALUES (CURRENT_DATE, 'platform_name', 'source_name', 100.00, 10.00, 90.00, 1);

-- Manual cost entry
INSERT INTO public.costs_monthly
(year_month, category, vendor, amount, recurring)
VALUES (DATE_TRUNC('month', CURRENT_DATE)::DATE, 'category', 'vendor', 29.00, true);
```

---

## Support

**For questions:**
1. Check this manual (Part 1-8)
2. Run the relevant function
3. If function errors: escalate to CTMO with function name + error message

**For new requirements:**
- Write to CTMO inbox: `CTMO/inbox/question_YYYY-MM-DD_<topic>.md`
- Example: "Can we track revenue by day of week?"

---

**Remember:** You're not learning SQL. You're reading pre-built reports. Just run the commands and read the results like a spreadsheet.

**Go hit that $10k goal.** 💪
