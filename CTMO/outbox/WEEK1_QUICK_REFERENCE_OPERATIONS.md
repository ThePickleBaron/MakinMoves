# Week 1 Autonomous Operations — Quick Reference Card
## April 1–7, 2026 (Trinity System)

---

## DAILY SCHEDULE (What Runs When)

```
06:00 AM  → Content Generation (n8n) → 3 items to content_queue
           → COO approves within 1-2 hours (or auto-approve at 07:00)

09:00 AM  → Publishing Pipeline (n8n) → approved items → 5 platforms
           → Updates content_queue status="published"

Hourly    → Revenue Capture (n8n) → query all APIs → insert revenue_summary
           → Happens at top of each hour (00, 01, 02, etc)

07:00 AM  → CFO Daily Report (manual query) → logs/daily_status_YYYY-MM-DD.md
           → Email to user with 1-line summary

SUNDAY    → CFO Weekly Report (manual query) → logs/week_summary_YYYY-MM-DD.md
           → Email to user with full Week 1 retrospective
```

---

## CRITICAL DECISION POINTS

### Hour 48 (Wednesday, April 3 00:00)
**Check:** Total revenue captured = ?
- ✓ **≥$20** → Systems working. Continue.
- ✗ **$0** → API issue. Check error_logs for auth failures.

### Hour 72 (Friday, April 4 00:00)
**Check:** Total revenue captured = ?
- ✓ **≥$50** → On track for Week 1 success.
- ⚠ **$10–$50** → Slower than expected but viable. Monitor.
- ✗ **$0** → Critical failure. Run diagnostics.

### Hour 120 (Monday, April 7 00:00)
**Check:** Week 1 total = ?
- ✓ **≥$300** → Excellent start. Scale Week 2.
- ⚠ **$50–$300** → Acceptable. Continue strategy, tweak.
- ✗ **<$50** → Reassess. Possible fundamental issue (API, content quality, traffic).

---

## ERROR DECISION TREE

### "Revenue is $0 after 48 hours"

```
Step 1: Check if content published
  SELECT COUNT(*) FROM publishing_log
  WHERE published_at >= '2026-04-01';

  Result: 0 items → Publishing failed
            >0 items → Publishing worked, but no sales yet

Step 2: If 0 items, check why
  SELECT error_type, COUNT(*)
  FROM error_logs
  WHERE workflow_name = 'publishing'
  GROUP BY error_type;

  Result: auth_failure → API key expired (user action needed)
          timeout → Retry later
          rate_limit → Wait 1 hour
          content_rejected → Quality issue

Step 3: If >0 items published but $0 revenue
  → Systems working correctly
  → No customers yet (normal for Day 1–2)
  → Continue monitoring
```

---

### "Error logs show 10+ critical errors in 1 hour"

```
Step 1: Identify the common error type
  SELECT error_type, error_message, COUNT(*)
  FROM error_logs
  WHERE logged_at >= NOW() - INTERVAL '1 hour'
    AND severity = 'critical'
  GROUP BY error_type, error_message;

Step 2: Route to fix

  IF error_type = 'database_connection'
    → Restart PostgreSQL
    $ docker restart mm-postgres
    → Check uptime, retry workflows

  IF error_type = 'auth_failure'
    → One or more API keys expired
    → Log which platform: error_message contains platform name
    → Escalate to CEO inbox: "API key needs refresh"

  IF error_type = 'api_timeout'
    → Platform might be down
    → Check platform status page
    → Retry after 30 min

  IF error_type = 'invalid_content'
    → Content violating TOS
    → Log in publishing_log
    → Adjust Claude prompts
```

---

### "Publishing success rate < 50%"

```
Step 1: Check which platforms failing
  SELECT platform, status, COUNT(*)
  FROM publishing_log
  WHERE published_at >= CURRENT_DATE
  GROUP BY platform, status;

Step 2: Categorize
  - 1–2 platforms failing → Acceptable, continue
  - 3+ platforms failing → System issue, investigate
  - All platforms failing → Critical, check database/n8n

Step 3: Fix
  If Gumroad failing but Etsy working:
    → Gumroad API issue or key expired
    → Log, continue with other platforms
    → Will revisit tomorrow

  If all failing:
    → Likely database or n8n engine issue
    → Check: docker ps (all running?)
    → Check: error_logs (what's the common error?)
    → Restart n8n: docker restart n8n
```

---

## ALERT ESCALATION RULES

**Send to CEO/inbox/ immediately if:**
- [ ] Database offline (PostgreSQL not responding)
- [ ] All API credentials invalid (auth failures on 3+ platforms)
- [ ] Publishing success <30% (cascading failures)
- [ ] Revenue = $0 after 72 hours
- [ ] Error count >50 critical in 1 hour

**Monitor but don't escalate:**
- Single platform timeout (will retry)
- 1–2 publishing failures (within tolerance)
- Revenue = $0 on Days 1–2 (expected)
- Random info-level errors (normal operations)

---

## CFO QUERY TEMPLATES (Copy-Paste)

### Daily Revenue Summary
```sql
SELECT
  COALESCE(platform, 'TOTAL') as platform,
  COUNT(*) as transactions,
  SUM(revenue_amount) as daily_revenue
FROM public.revenue_summary
WHERE DATE_TRUNC('day', captured_at) = CURRENT_DATE
GROUP BY ROLLUP(platform)
ORDER BY daily_revenue DESC;
```

### Recovery Progress
```sql
SELECT
  target_amount,
  recovered_amount,
  (target_amount - recovered_amount) as remaining,
  ROUND((recovered_amount / target_amount * 100), 2) as pct_complete,
  ROUND((recovered_amount / NULLIF(EXTRACT(DAY FROM NOW() - '2026-04-01'::timestamp), 0)), 2) as daily_rate
FROM public.recovery_tracker
ORDER BY created_at DESC LIMIT 1;
```

### Error Summary (Last 24h)
```sql
SELECT
  error_type,
  severity,
  COUNT(*) as count,
  COUNT(*) FILTER (WHERE resolved = FALSE) as unresolved
FROM error_logs
WHERE logged_at >= NOW() - INTERVAL '24 hours'
GROUP BY error_type, severity
ORDER BY count DESC;
```

### Publishing Performance
```sql
SELECT
  platform,
  COUNT(*) as total_attempts,
  COUNT(*) FILTER (WHERE status='success') as successes,
  ROUND(100.0 * COUNT(*) FILTER (WHERE status='success') / COUNT(*), 1) as success_rate
FROM publishing_log
WHERE published_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY platform
ORDER BY success_rate DESC;
```

---

## PLATFORM API REFERENCE

| Platform | Check API | Key Type | Expiry Risk | Fallback |
|----------|-----------|----------|-------------|----------|
| Gumroad | Hourly | Bearer token | Low | CSV export |
| Etsy | Hourly | OAuth2 | Medium | Manual refresh |
| Redbubble | Hourly | API key | Low | CSV export |
| Medium | Daily | API key | Low | RSS sync |
| WordPress | Daily | REST API token | Medium | XMLRPC |
| Claude | Daily | API key | Low | Pre-written templates |
| Stripe | (On-demand) | Secret key | Low | Manual logging |

---

## WHAT "SUCCESS" LOOKS LIKE

| Day | Revenue | Content | Errors | Status |
|-----|---------|---------|--------|--------|
| 1 (Apr 1) | $0–$20 | 3 pub | 0–2 | ✓ Nominal |
| 2 (Apr 2) | $20–$50 | 6 pub | 0–3 | ✓ Nominal |
| 3 (Apr 3) | $50–$100 | 9 pub | 0–5 | ✓ On track |
| 4 (Apr 4) | $100–$200 | 12 pub | 0–5 | ✓ On track |
| 5 (Apr 5) | $150–$300 | 15 pub | 0–5 | ✓ Excellent |
| 6 (Apr 6) | $200–$400 | 18 pub | 0–5 | ✓ Excellent |
| 7 (Apr 7) | $300–$500 | 18 pub | 0–5 | ✓ Ready to scale |

---

## WHAT "FAILURE" LOOKS LIKE

| Condition | Day | Action |
|-----------|-----|--------|
| Revenue = $0 | Day 3 | Diagnostic: Check API credentials |
| Revenue = $0 | Day 5 | Escalate: Critical system failure |
| Publishing = 0% | Day 1 | Check: n8n workflow execution |
| Errors > 100/day | Day 2 | Check: Database or API issue |
| Success rate < 30% | Day 3 | Escalate: Systematic problem |

---

## FILE LOCATIONS (Absolute Paths)

```
Main board:
  C:\Users\jsmcl\documents\makinmoves\BOARD.md

Logs (where CFO writes reports):
  C:\Users\jsmcl\documents\makinmoves\logs\daily_status_YYYY-MM-DD.md
  C:\Users\jsmcl\documents\makinmoves\logs\week_summary_YYYY-MM-DD.md

Database (PostgreSQL):
  Database: makinmoves
  User: makinmoves
  Host: localhost:5432
  Tables: revenue_summary, content_queue, publishing_log, error_logs, recovery_tracker

n8n Dashboard:
  http://localhost:5678
  Workflows: Revenue Capture, Content Generation, Publishing, Error Monitoring

Escalation:
  CEO inbox: C:\Users\jsmcl\documents\makinmoves\CEO\inbox\
```

---

## CTMO MAINTENANCE (Weekly)

- [ ] Check PostgreSQL disk usage (should be < 100MB for Week 1)
- [ ] Verify n8n workflows all scheduled (4 should run daily + hourly)
- [ ] Test API credentials (call each API once to verify auth)
- [ ] Check backups running (PostgreSQL daily backup should exist)
- [ ] Monitor error_logs for patterns (any repeating errors?)

---

## COO APPROVAL WORKFLOW (Daily, < 5 minutes)

```
Step 1: Check content_queue table
  SELECT id, content_type, title, status
  FROM content_queue
  WHERE status = 'generated'
  ORDER BY created_at DESC;

Step 2: Review each item (3 per day)
  - Digital product: Is name/description sellable?
  - Design: Is brief viable? Can Canva/designer build this?
  - Article: Is outline compelling? Keywords relevant?

Step 3: Approve or reject
  UPDATE content_queue
  SET status = 'approved', approved_by = 'COO'
  WHERE id = [ITEM_ID];

  OR (if low quality):
  UPDATE content_queue
  SET status = 'rejected'
  WHERE id = [ITEM_ID];

Step 4: Done!
  Publishing runs at 09:00 with approved items
```

---

## USER COMMUNICATIONS (Email Templates)

### Daily Email (07:00 AM, Every Day)
```
Subject: Trinity Status — April X, 2026

✓ Systems operational
✓ Revenue today: $XXX (cumulative: $XXX)
✓ Content published: 3 items
✓ Errors: 0 critical

Next: April X+1 at 06:00 AM

—Trinity System
```

### Weekly Email (Sundays, 08:00 AM)
```
Subject: Trinity Week 1 Summary — April 1–7, 2026

Week 1 Results:
- Total revenue: $XXX
- Content published: 18 items
- System uptime: 100%

Recovery progress: $XXX / $10,000 (X%)
Pace: At current rate, $10k by [DATE]

Top performer: [Digital products / PoD / Affiliate]
Recommendation: [Continue / Scale / Adjust]

—Trinity System
```

---

## EMERGENCY RESTART (If Needed)

```bash
# Restart all services
docker-compose down
docker-compose up -d

# Verify
docker ps | grep -E "postgres|n8n|redis|selenium"

# Check logs
docker logs mm-postgres
docker logs n8n
```

---

**Print this card for quick reference during Week 1 operations.**

**Remember:** User is offline. All decisions automated. Stay calm, follow decision trees, escalate only critical issues.
