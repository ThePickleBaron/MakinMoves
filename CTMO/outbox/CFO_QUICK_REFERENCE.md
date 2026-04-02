# CFO Quick Reference Card
**Print This. Laminate It. Use Daily.**

---

## The 8 Commands You'll Use

### 1️⃣ TODAY'S REVENUE
```sql
SELECT * FROM get_daily_revenue();
```
**When:** Every morning
**Look for:** Is today's total > $5?

---

### 2️⃣ LAST 7 DAYS
```sql
SELECT * FROM get_weekly_summary();
```
**When:** Every Monday
**Look for:** Is trend up from last week?

---

### 3️⃣ MONTHLY P&L
```sql
SELECT * FROM get_monthly_report();
```
**When:** 1st of every month
**Look for:** Is net profit growing?

---

### 4️⃣ $10K GOAL PROGRESS
```sql
SELECT * FROM get_recovery_progress();
```
**When:** Weekly (track progress)
**Look for:** Days to goal / avg daily rate

---

### 5️⃣ WHICH PLATFORM WINNING
```sql
SELECT * FROM get_platform_ranking();
```
**When:** Monthly (strategy review)
**Look for:** Top platform % (should be < 70%)

---

### 6️⃣ HEALTH CHECK
```sql
SELECT * FROM check_daily_revenue_alert();
```
**When:** If daily revenue seems low
**Look for:** alert_triggered = false (healthy)

---

### 7️⃣ RECENT ERRORS
```sql
SELECT * FROM get_recent_errors(24);
```
**When:** If something broken
**Look for:** Any 'critical' severity

---

### 8️⃣ WHAT GOT PUBLISHED
```sql
SELECT * FROM get_publishing_status(7);
```
**When:** Weekly (check content performance)
**Look for:** Failed publishes / low views

---

## BONUS FORECASTS

### When Hit Milestones?
```sql
SELECT * FROM forecast_recovery_date(10000);
```
**Output:** Dates for $1k, $5k, $10k

### Revenue vs Costs Trend
```sql
SELECT * FROM get_burn_rate(3);
```
**Output:** Last 3 months P&L trend

---

## DAILY ROUTINE (5 minutes)

| Time | Action | Command |
|------|--------|---------|
| **Morning** | Check yesterday's revenue | `SELECT * FROM get_daily_revenue();` |
| **Morning** | Health check | `SELECT * FROM check_daily_revenue_alert();` |
| **If alert** | Find the problem | `SELECT * FROM get_recent_errors(24);` |
| **Result** | Actions taken | (Documented in notes) |

---

## WEEKLY ROUTINE (15 minutes)

| Day | Action | Command |
|-----|--------|---------|
| **Monday** | Last 7 days summary | `SELECT * FROM get_weekly_summary();` |
| **Monday** | Platform performance | `SELECT * FROM get_platform_ranking();` |
| **Monday** | What was published | `SELECT * FROM get_publishing_status(7);` |
| **Weekly** | Refresh aggregates | `SELECT refresh_weekly_aggregates();` |

---

## MONTHLY ROUTINE (20 minutes)

| Day | Action | Command |
|-----|--------|---------|
| **1st** | Full P&L statement | `SELECT * FROM get_monthly_report();` |
| **1st** | Cost vs revenue trend | `SELECT * FROM get_burn_rate(3);` |
| **1st** | Recovery progress | `SELECT * FROM get_recovery_progress();` |
| **1st** | When hit $10k? | `SELECT * FROM forecast_recovery_date(10000);` |
| **After** | Refresh monthly | `SELECT refresh_monthly_aggregates();` |
| **After** | Add new costs | (INSERT new rows if needed) |

---

## MANUAL ENTRY (When Needed)

### One-Time Revenue (Affiliate Payment, Bonus)
```sql
INSERT INTO public.revenue_daily
(date, platform, source, gross_amount, fees, net_amount, transaction_count, notes)
VALUES (
  CURRENT_DATE,
  'content',
  'Affiliate',
  100.00,
  0,
  100.00,
  1,
  'Manual: Affiliate referral bonus'
);
```

### New Monthly Cost
```sql
INSERT INTO public.costs_monthly
(year_month, category, vendor, amount, recurring, notes)
VALUES (
  DATE_TRUNC('month', CURRENT_DATE)::DATE,
  'Tools',
  'Mailchimp',
  29.00,
  true,
  'Email marketing platform'
);
```

---

## READING THE OUTPUTS

### Daily Revenue Table
```
platform | source | gross | fees | net | count | total
─────────┼────────┼───────┼──────┼─────┼───────┼──────
digital  │Gumroad│ 45.00 │ 6.75 │38.25│ 2    │ 43.50
content  │AdSense│ 5.25  │ 0    │ 5.25│ 1    │ 43.50
```
**Read:** Today made $43.50 net across 3 sales

### Recovery Progress Table
```
target | earned | remaining | progress | days | daily_rate | days_to_goal
───────┼────────┼───────────┼──────────┼──────┼────────────┼──────────────
10000  │ 2345.75│  7654.25  │  23.46%  │ 28   │   83.77    │    91
```
**Read:** Made $2,345 in 28 days. At $84/day, hit $10k in 91 days (late June).

### Platform Ranking Table
```
rank │ platform │ revenue  │ percent │ txn │ status
─────┼──────────┼──────────┼─────────┼─────┼────────
1    │ digital  │ 3450.00  │ 68.5%   │ 142 │ active
2    │ content  │ 1240.00  │ 24.6%   │ 68  │ active
3    │ saas     │ 340.00   │ 6.8%    │ 12  │ planning
```
**Read:** Digital products making 68.5% of revenue. Need to grow content & SaaS.

### Health Alert Table (No Issues)
```
alert | revenue | threshold │ message │ action
──────┼─────────┼───────────┼─────────┼────────
false │ 47.50   │ 5         │ Healthy │ None
```
**Read:** All good, revenue > $5.

### Health Alert Table (Problem)
```
alert │ revenue │ threshold │ message                        │ action
──────┼─────────┼───────────┼────────────────────────────────┼──────────────────
true  │ 0       │ 5         │ No revenue - check publishing  │ Run get_recent_errors()
```
**Read:** Revenue is 0. Check errors immediately.

---

## DECISION TREE: What If?

### "Daily revenue is zero"
1. Run: `SELECT * FROM check_daily_revenue_alert();`
2. If alert=true, run: `SELECT * FROM get_recent_errors(24);`
3. Look for 'critical' severity
4. **Action:** Check n8n workflows, API keys, platform status

### "Weekly revenue down 30% from last week"
1. Run: `SELECT * FROM get_weekly_summary();`
2. Run: `SELECT * FROM get_platform_ranking();`
3. **Action:** Which platform dropped? Focus marketing there.

### "Days to $10k goal increasing"
1. Run: `SELECT * FROM forecast_recovery_date(10000);`
2. Run: `SELECT * FROM get_burn_rate(3);`
3. **Action:** Revenue declining or flat. Push harder on all platforms.

### "One platform earning way less than before"
1. Run: `SELECT * FROM get_publishing_status(7);`
2. Look for 'failed' status entries
3. Run: `SELECT * FROM get_recent_errors(24);`
4. **Action:** Platform API down? Check error_logs and escalate to CTMO.

### "Want to add new platform"
1. **Action:** Escalate to CTMO inbox
2. CTMO adds platform to database schema
3. n8n sets up automation
4. CFO runs reports with new platform data

---

## ERROR SEVERITY GUIDE

| Severity | Meaning | Action |
|----------|---------|--------|
| **critical** | Platform down / Auth broken | Fix immediately (escalate) |
| **high** | Missing some revenue | Investigate within 2h |
| **medium** | Temporary glitch | Will auto-retry |
| **low** | Informational | Monitor, no action needed |

---

## WHEN TO ESCALATE TO CTMO

**Escalate if:**
- Function returns SQL error
- Can't connect to database
- Revenue data missing for > 24h
- Backup/restore needed
- Need new metric/report type

**You CAN handle:**
- Entering manual revenue/costs
- Reading and interpreting reports
- Analyzing trends
- Making strategic decisions

---

## BACKUP PROCEDURE (Automated)

**Don't do this manually.** CTMO handles it.

**Your only job:** Verify backup happened
```bash
# Ask CTMO: "Are backups running?"
# They should say: "Yes, daily at 2 AM UTC"
```

---

## RECOVERY GOAL TRACKING

### Your $10k Target
- **Start date:** March 1, 2026
- **Target date:** June 30, 2026 (estimated)
- **Daily rate needed:** $84/day (at current pace)
- **Current progress:** (Run `get_recovery_progress()` to check)

### If you want to accelerate:
- Increase platform #2 (content) from 15% to 30% of revenue
- Launch platform #3 (SaaS) to 15% of revenue
- This would get you there by mid-May instead of late June

---

## SYMBOLS & ABBREVIATIONS

| Symbol | Meaning |
|--------|---------|
| ✅ | Healthy, no action needed |
| ⚠️ | Warning, monitor closely |
| ❌ | Problem, requires action |
| N/A | Not applicable |
| txn | Transaction |
| P&L | Profit & Loss statement |
| YTD | Year-to-date |
| MRR | Monthly recurring revenue |

---

## COMMAND SYNTAX RULES

**Copy/paste exactly:**
```sql
SELECT * FROM get_daily_revenue();
```

**Don't change:**
- Function names (they're case-sensitive)
- Parentheses (always include them even if empty)
- Semicolon at end (ends the command)

**Optional changes:**
```sql
-- You CAN do this (adjusts lookback period):
SELECT * FROM get_recent_errors(48);  -- Last 48 hours instead of 24

-- You CAN do this (specific date):
SELECT * FROM get_weekly_summary('2026-03-22'::DATE);
```

---

## KEYBOARD SHORTCUTS (PgAdmin)

| Action | Shortcut |
|--------|----------|
| Execute query | `Ctrl+Enter` |
| Clear screen | `Ctrl+A` then `Delete` |
| Copy cell | `Ctrl+C` |
| Paste | `Ctrl+V` |
| Format code | `Ctrl+Shift+F` |

---

## SUPPORT

**Need help?**
1. Check this card (section: "When to Escalate")
2. Run diagnostic functions (error_logs, alerts)
3. Ask CTMO if stuck

**Quick summary:**
- **8 functions = 8 reports**
- **5 min daily + 15 min weekly + 20 min monthly**
- **All copy/paste, no SQL writing**
- **Go hit $10k goal** 💰

---

**Laminate this card. Keep it next to your keyboard.**
