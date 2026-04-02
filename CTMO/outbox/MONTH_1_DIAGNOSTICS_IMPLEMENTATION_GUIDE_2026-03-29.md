# MONTH 1 DIAGNOSTICS — TECHNICAL IMPLEMENTATION GUIDE
**For CTMO & CFO: Building the Autonomous Monitoring & Testing Infrastructure**

**Date:** 2026-03-29
**Status:** Ready to implement by EOD March 30
**Owner:** CTMO (infrastructure), CFO (reporting)

---

## OVERVIEW: WHAT GETS BUILT

By the end of March 30, the following systems must be operational:

1. **Daily Metrics Dashboard** — Auto-query all platforms at 08:00 AM daily, generate report
2. **Weekly Diagnostic Report** — Auto-analyze metrics, identify bottlenecks, recommend actions
3. **A/B Testing Harness** — Route traffic, measure variants, calculate significance
4. **Revenue Escalation System** — Alert CEO if revenue <$30/day or other RED conditions
5. **Test Result Tracker** — Log all tests, winners/losers, learnings
6. **Budget Spend Authorizer** — Auto-approve <$100 spend, escalate >$100

---

## PART 1: DAILY METRICS DASHBOARD

### Data Schema (PostgreSQL)

```sql
-- Daily metrics table (auto-populated hourly/daily)
CREATE TABLE IF NOT EXISTS daily_metrics (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL,
  stream VARCHAR(50) NOT NULL, -- 'P1_digital', 'P2_freelance', 'P3_affiliate'

  -- Traffic metrics
  visitors_count INTEGER DEFAULT 0,
  unique_visitors INTEGER DEFAULT 0,

  -- Sales metrics
  conversions INTEGER DEFAULT 0,
  conversion_rate DECIMAL(5,3) DEFAULT 0,
  avg_order_value DECIMAL(10,2) DEFAULT 0,
  revenue_gross DECIMAL(10,2) DEFAULT 0,
  revenue_net DECIMAL(10,2) DEFAULT 0,

  -- Affiliate-specific
  clicks_affiliate INTEGER DEFAULT 0,
  click_rate DECIMAL(5,3) DEFAULT 0,
  commission_per_click DECIMAL(10,2) DEFAULT 0,

  -- Freelance-specific
  proposals_sent INTEGER DEFAULT 0,
  proposals_accepted INTEGER DEFAULT 0,
  deal_size_avg DECIMAL(10,2) DEFAULT 0,

  -- Metadata
  data_source VARCHAR(100), -- 'gumroad', 'etsy', 'medium', 'google_analytics'
  confidence_score DECIMAL(3,2), -- 0.0–1.0, how complete is data?
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(date, stream, data_source)
);

-- Summary table (aggregated daily for dashboard)
CREATE TABLE IF NOT EXISTS daily_summary (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL UNIQUE,

  p1_revenue_net DECIMAL(10,2) DEFAULT 0,
  p2_revenue_net DECIMAL(10,2) DEFAULT 0,
  p3_revenue_net DECIMAL(10,2) DEFAULT 0,
  total_revenue_net DECIMAL(10,2) DEFAULT 0,

  p1_visitors INTEGER DEFAULT 0,
  p2_proposals INTEGER DEFAULT 0,
  p3_visitors INTEGER DEFAULT 0,

  revenue_forecast_month_end DECIMAL(10,2), -- Projection based on current pace
  on_track_status VARCHAR(20), -- 'GREEN', 'YELLOW', 'RED'
  anomalies TEXT, -- Flagged issues

  created_at TIMESTAMP DEFAULT NOW()
);

-- Test tracking table
CREATE TABLE IF NOT EXISTS ab_tests (
  id SERIAL PRIMARY KEY,
  test_id VARCHAR(100) UNIQUE NOT NULL,
  stream VARCHAR(50), -- 'P1_digital', etc.
  test_name VARCHAR(200),
  start_date DATE NOT NULL,
  end_date DATE,

  variant_a_name VARCHAR(200),
  variant_a_visitors INTEGER DEFAULT 0,
  variant_a_conversions INTEGER DEFAULT 0,
  variant_a_conversion_rate DECIMAL(5,3),
  variant_a_revenue DECIMAL(10,2),

  variant_b_name VARCHAR(200),
  variant_b_visitors INTEGER DEFAULT 0,
  variant_b_conversions INTEGER DEFAULT 0,
  variant_b_conversion_rate DECIMAL(5,3),
  variant_b_revenue DECIMAL(10,2),

  -- Statistical significance (chi-squared or similar)
  chi_squared_value DECIMAL(10,4),
  p_value DECIMAL(5,4),
  is_significant BOOLEAN DEFAULT FALSE,

  winner VARCHAR(1), -- 'A', 'B', or NULL if tie
  learning TEXT,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

---

### Daily Metrics Query (PostgreSQL Function)

This function runs at 08:00 AM daily, pulls data from all platform APIs, populates `daily_metrics` and `daily_summary`:

```sql
-- Function to populate daily metrics
CREATE OR REPLACE FUNCTION populate_daily_metrics(report_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
  report_status VARCHAR,
  total_revenue DECIMAL,
  p1_revenue DECIMAL,
  p2_revenue DECIMAL,
  p3_revenue DECIMAL,
  anomalies TEXT
) AS $$
DECLARE
  gumroad_revenue DECIMAL;
  etsy_revenue DECIMAL;
  medium_views INTEGER;
  gumroad_visitors INTEGER;
  affiliate_clicks INTEGER;
  proposal_count INTEGER;
  month_projected DECIMAL;
  status_flag VARCHAR;
  anomaly_list TEXT;
BEGIN
  -- 1. Fetch P1 (Digital Products) from Gumroad API
  SELECT COALESCE(SUM(amount), 0)
  INTO gumroad_revenue
  FROM transactions
  WHERE source = 'gumroad' AND DATE(transaction_date) = report_date;

  -- 2. Fetch P1 (Digital Products) from Etsy API
  SELECT COALESCE(SUM(amount), 0)
  INTO etsy_revenue
  FROM transactions
  WHERE source = 'etsy' AND DATE(transaction_date) = report_date;

  -- 3. Fetch P2 (Freelance) — proposals sent this week
  SELECT COUNT(*)
  INTO proposal_count
  FROM freelance_proposals
  WHERE DATE(created_at) >= (report_date - INTERVAL '7 days')
    AND DATE(created_at) <= report_date;

  -- 4. Fetch P3 (Affiliate) from Google Analytics API
  SELECT COALESCE(SUM(clicks), 0)
  INTO affiliate_clicks
  FROM affiliate_tracking
  WHERE DATE(click_date) = report_date;

  -- 5. Fetch traffic from Google Analytics
  SELECT COALESCE(SUM(sessions), 0)
  INTO gumroad_visitors
  FROM analytics
  WHERE source = 'gumroad' AND DATE(event_date) = report_date;

  -- 6. Calculate total revenue for the day
  total_revenue := gumroad_revenue + etsy_revenue + (affiliate_clicks * 25); -- Assume $25 per click

  -- 7. Project to month end
  month_projected := total_revenue * 30 / EXTRACT(DAY FROM report_date);

  -- 8. Determine status
  IF total_revenue < 30 THEN
    status_flag := 'RED';
    anomaly_list := 'Revenue below $30/day threshold';
  ELSIF total_revenue < 50 THEN
    status_flag := 'YELLOW';
    anomaly_list := 'Revenue below $50/day threshold';
  ELSE
    status_flag := 'GREEN';
    anomaly_list := '';
  END IF;

  -- 9. Check for stream-specific anomalies
  IF gumroad_visitors < 100 THEN
    anomaly_list := anomaly_list || ' | P1 traffic low (' || gumroad_visitors || ' visitors)';
  END IF;

  IF proposal_count = 0 THEN
    anomaly_list := anomaly_list || ' | P2 proposals at 0 (RED FLAG)';
  END IF;

  IF affiliate_clicks = 0 THEN
    anomaly_list := anomaly_list || ' | P3 affiliate clicks at 0';
  END IF;

  -- 10. Insert into daily_summary table
  INSERT INTO daily_summary (
    date, p1_revenue_net, p2_revenue_net, p3_revenue_net,
    total_revenue_net, revenue_forecast_month_end, on_track_status, anomalies
  ) VALUES (
    report_date,
    COALESCE(gumroad_revenue + etsy_revenue, 0),
    0, -- P2 payment received (not daily)
    COALESCE((affiliate_clicks * 25), 0),
    COALESCE(total_revenue, 0),
    month_projected,
    status_flag,
    anomaly_list
  )
  ON CONFLICT (date) DO UPDATE SET
    p1_revenue_net = EXCLUDED.p1_revenue_net,
    p3_revenue_net = EXCLUDED.p3_revenue_net,
    total_revenue_net = EXCLUDED.total_revenue_net,
    revenue_forecast_month_end = EXCLUDED.revenue_forecast_month_end,
    on_track_status = EXCLUDED.on_track_status,
    anomalies = EXCLUDED.anomalies;

  -- 11. Return results
  RETURN QUERY
  SELECT status_flag, total_revenue, gumroad_revenue + etsy_revenue, 0::DECIMAL, affiliate_clicks * 25, anomaly_list;
END;
$$ LANGUAGE plpgsql;

-- Schedule this to run daily at 08:00 AM via n8n or cron
-- SELECT populate_daily_metrics(CURRENT_DATE);
```

---

### Daily Dashboard Generation (Markdown Report)

```bash
#!/bin/bash
# Script: generate_daily_dashboard.sh
# Runs daily at 08:00 AM via n8n; generates markdown report

DATE=$(date +%Y-%m-%d)
REPORT_FILE="../board/CFO/daily_reports/metrics_$DATE.md"

# Query PostgreSQL for daily metrics
psql -d makinmoves_db -c "
SELECT
  '# Daily Metrics — ' || '$DATE' || '
' ||
  '## P1: Digital Products
- Traffic (24h): ' || p1_visitors || ' visitors
- Conversion rate: ' || ROUND(p1_conversion_rate::numeric, 2) || '%
- AOV: $' || ROUND(p1_aov::numeric, 2) || '
- **Revenue today:** $' || ROUND(p1_revenue_net::numeric, 2) || '

## P2: Freelance Writing
- Proposals sent (week): ' || (
  SELECT COUNT(*) FROM freelance_proposals
  WHERE DATE(created_at) >= CURRENT_DATE - INTERVAL '\''7 days'\''
) || '
- Close rate: [TBD after proposal response]
- Deal size: [TBD]
- **Revenue today:** [Depends on payment schedule]

## P3: Affiliate Marketing
- Site traffic (24h): ' || p3_visitors || ' visitors
- Affiliate clicks: ' || p3_clicks || '
- Commission per click: $25
- **Revenue today:** $' || ROUND(p3_revenue_net::numeric, 2) || '

## DAILY TOTAL: $' || ROUND(total_revenue_net::numeric, 2) || '
- 7-day average: $[from query]
- Month-to-date: $[from query]
- Projection (month-end): $' || ROUND(revenue_forecast_month_end::numeric, 2) || '

## DAILY STATUS: ' || on_track_status || '
- GREEN: >$100/day average → On track
- YELLOW: $50–$100/day average → Monitor closely
- RED: <$50/day average → ESCALATE

## ANOMALIES DETECTED:
' || COALESCE(anomalies, 'None') || '
' FROM daily_summary WHERE date = CURRENT_DATE;
" > "$REPORT_FILE"

echo "Dashboard generated: $REPORT_FILE"
```

**CTMO Implementation Checklist:**
- [ ] Create `daily_metrics`, `daily_summary`, `ab_tests` tables
- [ ] Create `populate_daily_metrics()` function
- [ ] Create `generate_daily_dashboard.sh` script
- [ ] Schedule script to run daily @ 08:00 AM via n8n cron job
- [ ] Test with sample data (Apr 1, 2 am)
- [ ] Verify report generates correctly
- [ ] Add to CTMO backups

---

## PART 2: WEEKLY DIAGNOSTIC REPORT

### Weekly Analysis Query (CFO)

```sql
-- Weekly aggregation + diagnostics
CREATE OR REPLACE FUNCTION generate_weekly_diagnostic(
  report_week_start DATE DEFAULT (CURRENT_DATE - INTERVAL '7 days'),
  report_week_end DATE DEFAULT CURRENT_DATE
)
RETURNS TEXT AS $$
DECLARE
  week_revenue DECIMAL;
  week_p1_revenue DECIMAL;
  week_p2_revenue DECIMAL;
  week_p3_revenue DECIMAL;
  week_p1_conversion DECIMAL;
  week_p3_traffic INTEGER;
  plan_revenue DECIMAL;
  revenue_pct_of_plan DECIMAL;
  p1_status VARCHAR;
  p2_status VARCHAR;
  p3_status VARCHAR;
  report TEXT;
BEGIN
  -- 1. Get aggregated weekly revenue
  SELECT
    COALESCE(SUM(total_revenue_net), 0),
    COALESCE(SUM(p1_revenue_net), 0),
    COALESCE(SUM(p2_revenue_net), 0),
    COALESCE(SUM(p3_revenue_net), 0)
  INTO week_revenue, week_p1_revenue, week_p2_revenue, week_p3_revenue
  FROM daily_summary
  WHERE date >= report_week_start AND date <= report_week_end;

  -- 2. Get P1 conversion rate for week
  SELECT AVG(conversion_rate)
  INTO week_p1_conversion
  FROM daily_metrics
  WHERE stream = 'P1_digital'
    AND date >= report_week_start AND date <= report_week_end;

  -- 3. Get P3 traffic
  SELECT COALESCE(SUM(visitors_count), 0)
  INTO week_p3_traffic
  FROM daily_metrics
  WHERE stream = 'P3_affiliate'
    AND date >= report_week_start AND date <= report_week_end;

  -- 4. Compare to plan
  -- Conservative plan: ~$50/day = $350/week
  plan_revenue := 350;
  revenue_pct_of_plan := ROUND((week_revenue / plan_revenue * 100)::numeric, 1);

  -- 5. Determine status flags
  IF week_p1_revenue > 200 THEN p1_status := '✓ ON TRACK';
  ELSIF week_p1_revenue > 100 THEN p1_status := '⚠ BELOW PLAN';
  ELSE p1_status := '✗ RED FLAG'; END IF;

  IF week_p2_revenue > 100 THEN p2_status := '✓ ON TRACK';
  ELSIF week_p2_revenue > 50 THEN p2_status := '⚠ BELOW PLAN';
  ELSE p2_status := '✗ RED FLAG'; END IF;

  IF week_p3_traffic > 500 THEN p3_status := '✓ ON TRACK';
  ELSIF week_p3_traffic > 200 THEN p3_status := '⚠ BELOW PLAN';
  ELSE p3_status := '✗ RED FLAG'; END IF;

  -- 6. Build report markdown
  report := '# Weekly Diagnostic Report — ' || report_week_start || ' to ' || report_week_end || '

## Revenue vs. Plan
| Stream | Week Actual | Month Plan | Status |
|--------|-------------|-----------|--------|
| P1 Digital Products | $' || ROUND(week_p1_revenue::numeric, 2) || ' | $240 | ' || p1_status || ' |
| P2 Freelance Writing | $' || ROUND(week_p2_revenue::numeric, 2) || ' | $200 | ' || p2_status || ' |
| P3 Affiliate Marketing | $' || ROUND(week_p3_revenue::numeric, 2) || ' | $50 | ' || p3_status || ' |
| **TOTAL** | **$' || ROUND(week_revenue::numeric, 2) || '** | **$490** | **' || revenue_pct_of_plan || '% of plan** |

## Metrics Deep-Dive
- **P1 Conversion Rate:** ' || ROUND(week_p1_conversion::numeric, 2) || '% (expected 5%)
- **P3 Traffic:** ' || week_p3_traffic || ' visitors (expected 1,000+)
- **P2 Pipeline:** [Manual count needed]

## Recommended Actions
[Auto-generate based on which stream is below plan]

## Escalation Check
' || CASE
  WHEN revenue_pct_of_plan < 25 THEN '🔴 RED: Revenue at ' || revenue_pct_of_plan || '% of plan — ESCALATE to CEO'
  WHEN revenue_pct_of_plan < 50 THEN '🟡 YELLOW: Revenue at ' || revenue_pct_of_plan || '% of plan — MONITOR'
  ELSE '🟢 GREEN: Revenue at ' || revenue_pct_of_plan || '% of plan — ON TRACK'
END;

  RETURN report;
END;
$$ LANGUAGE plpgsql;

-- Run this every Sunday @ 08:00 AM
-- SELECT generate_weekly_diagnostic();
```

---

## PART 3: A/B TESTING HARNESS

### Traffic Routing (n8n Workflow)

**Workflow Name:** `P1_COPY_AB_TEST_TRAFFIC_ROUTER`
**Trigger:** Every visitor to `gumroad.com/[product]` (via UTM param `?ab_test=true`)
**Logic:**

```yaml
Webhook Input:
  - user_id (hashed)
  - timestamp
  - utm_ab_test (indicates A/B test active)

Steps:
  1. Hash user_id + date → deterministic bucket (A or B)
  2. Redirect to Variant A or B based on bucket
  3. Log traffic assignment to ab_tests table
  4. Return redirect URL

Output:
  - Variant A URL: https://gumroad.com/products/p1-original?session_id=XXX
  - Variant B URL: https://gumroad.com/products/p1-copy-v2?session_id=XXX
```

**PostgreSQL Function (Traffic Assignment):**

```sql
CREATE OR REPLACE FUNCTION assign_ab_variant(
  user_id VARCHAR,
  test_id VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE
  hash_value INTEGER;
  variant VARCHAR;
BEGIN
  -- Hash user_id + test_id deterministically
  hash_value := (hashtext(user_id || test_id) % 100)::INTEGER;

  -- 50/50 split: hash 0–49 = A, 50–99 = B
  IF hash_value < 50 THEN
    variant := 'A';
  ELSE
    variant := 'B';
  END IF;

  -- Log assignment
  INSERT INTO ab_test_assignments (user_id, test_id, variant_assigned, timestamp)
  VALUES (user_id, test_id, variant, NOW());

  RETURN variant;
END;
$$ LANGUAGE plpgsql;
```

**CTMO Implementation Checklist:**
- [ ] Set up n8n webhook for traffic routing
- [ ] Create `ab_test_assignments` table
- [ ] Deploy `assign_ab_variant()` function
- [ ] Test with 10 sample visitors (5/5 split expected)
- [ ] Verify variant URLs route correctly

---

### Conversion Tracking & Statistical Significance

```sql
-- Function to calculate test significance
CREATE OR REPLACE FUNCTION calculate_test_significance(test_id VARCHAR)
RETURNS TABLE (
  variant_a_conv_rate DECIMAL,
  variant_b_conv_rate DECIMAL,
  chi_squared DECIMAL,
  p_value DECIMAL,
  is_significant BOOLEAN,
  recommendation VARCHAR
) AS $$
DECLARE
  a_visitors INTEGER;
  a_conversions INTEGER;
  b_visitors INTEGER;
  b_conversions INTEGER;
  chi_sq DECIMAL;
  p_val DECIMAL;
BEGIN
  -- Get variant A stats
  SELECT COUNT(*), COUNT(*) FILTER (WHERE converted = TRUE)
  INTO a_visitors, a_conversions
  FROM ab_test_assignments
  WHERE test_id = $1 AND variant_assigned = 'A'
    AND DATE(timestamp) >= (CURRENT_DATE - INTERVAL '7 days');

  -- Get variant B stats
  SELECT COUNT(*), COUNT(*) FILTER (WHERE converted = TRUE)
  INTO b_visitors, b_conversions
  FROM ab_test_assignments
  WHERE test_id = $1 AND variant_assigned = 'B'
    AND DATE(timestamp) >= (CURRENT_DATE - INTERVAL '7 days');

  -- Chi-squared test (simplified)
  -- Chi-sq = (|a_conv - b_conv| - 0.5)^2 / (a_conv + b_conv)
  chi_sq := POWER(ABS(a_conversions - b_conversions) - 0.5, 2) / (a_conversions + b_conversions + 0.1);

  -- P-value (simplified lookup; in production use chi2 CDF)
  -- chi-sq 3.84 ≈ p=0.05 (significant)
  p_val := CASE WHEN chi_sq > 3.84 THEN 0.05 ELSE 0.20 END;

  RETURN QUERY SELECT
    (a_conversions::DECIMAL / NULLIF(a_visitors, 0))::DECIMAL,
    (b_conversions::DECIMAL / NULLIF(b_visitors, 0))::DECIMAL,
    chi_sq,
    p_val,
    (chi_sq > 3.84) AS is_significant,
    CASE
      WHEN chi_sq > 3.84 AND a_conversions > b_conversions THEN 'Deploy Variant A'
      WHEN chi_sq > 3.84 AND b_conversions > a_conversions THEN 'Deploy Variant B'
      ELSE 'Test inconclusive; extend or pivot'
    END AS recommendation;
END;
$$ LANGUAGE plpgsql;
```

---

## PART 4: ESCALATION SYSTEM

### Alert Thresholds (CFO + CTMO)

```sql
-- Escalation rules table
CREATE TABLE IF NOT EXISTS escalation_rules (
  rule_id SERIAL PRIMARY KEY,
  rule_name VARCHAR(200),
  condition TEXT, -- SQL WHERE clause
  severity VARCHAR(20), -- 'CRITICAL', 'HIGH', 'MEDIUM'
  action VARCHAR(500), -- What happens when triggered?
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Insert escalation rules
INSERT INTO escalation_rules (rule_name, condition, severity, action) VALUES
('Revenue collapse', 'total_revenue_net < 30 FOR 24h', 'CRITICAL', 'Email CEO inbox: RED alert + recommendation'),
('P2 pipeline dry', '(SELECT COUNT(*) FROM freelance_proposals WHERE created_at > NOW() - INTERVAL ''7 days'') = 0 FOR 3+ days', 'HIGH', 'Email CEO: P2 pipeline empty, escalate'),
('Test inconclusive', 'p_value > 0.05 after 7 days AND conversions < 50', 'MEDIUM', 'Flag in weekly report: extend or pivot'),
('n8n workflow fail', 'workflow_status = ''FAILED'' AND retry_count > 3', 'CRITICAL', 'Email CTMO inbox: workflow needs investigation'),
('API auth failure', 'error_code = ''401'' AND source IN (''gumroad'', ''etsy'')', 'HIGH', 'Email CTMO: re-auth needed');
```

**Daily Escalation Check (CFO Function):**

```sql
CREATE OR REPLACE FUNCTION check_escalation_triggers()
RETURNS TABLE (
  rule_name VARCHAR,
  severity VARCHAR,
  triggered_at TIMESTAMP,
  recipient VARCHAR,
  action TEXT
) AS $$
DECLARE
  rule RECORD;
BEGIN
  -- Iterate through all active escalation rules
  FOR rule IN SELECT * FROM escalation_rules WHERE is_active THEN
    -- Check if rule condition is met
    EXECUTE rule.condition INTO result;

    IF result THEN
      -- Log escalation
      INSERT INTO escalation_log (rule_id, triggered_at, severity)
      VALUES (rule.rule_id, NOW(), rule.severity);

      -- Return escalation for email/Slack notification
      RETURN QUERY SELECT
        rule.rule_name,
        rule.severity,
        NOW(),
        CASE rule.severity
          WHEN 'CRITICAL' THEN 'ceo@inbox, ctmo@inbox'
          WHEN 'HIGH' THEN 'ceo@inbox'
          ELSE 'board@log'
        END,
        rule.action;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Run daily @ 18:00 (evening check)
-- SELECT check_escalation_triggers();
```

---

## PART 5: IMPLEMENTATION CHECKLIST (By EOD March 30)

### CTMO Deliverables

- [ ] **Database Schema Ready**
  - [ ] `daily_metrics` table created + indexed
  - [ ] `daily_summary` table created
  - [ ] `ab_tests` table created
  - [ ] `ab_test_assignments` table created
  - [ ] `escalation_rules` table created

- [ ] **Functions Deployed**
  - [ ] `populate_daily_metrics()` function working
  - [ ] `generate_weekly_diagnostic()` function working
  - [ ] `assign_ab_variant()` function working
  - [ ] `calculate_test_significance()` function working
  - [ ] `check_escalation_triggers()` function working

- [ ] **n8n Workflows Configured**
  - [ ] Daily metrics refresh @ 08:00 AM
  - [ ] Weekly diagnostic report generation @ Sundays 08:00 AM
  - [ ] A/B test traffic router active (if tests needed by Apr 8)
  - [ ] Escalation email sender (if triggers fire)

- [ ] **API Integrations Ready**
  - [ ] Gumroad API credentials + test query working
  - [ ] Etsy API credentials + test query working
  - [ ] Google Analytics API credentials + test query working
  - [ ] Medium API (if publishing there) + test query working

- [ ] **Testing Completed**
  - [ ] Daily dashboard generates correctly with sample data
  - [ ] Weekly diagnostic generates correctly
  - [ ] A/B test traffic router assigns 50/50 split (if enabled)
  - [ ] Escalation triggers fire correctly on test data

- [ ] **Backups Configured**
  - [ ] PostgreSQL daily backup (full + incremental)
  - [ ] n8n workflow backups
  - [ ] Disaster recovery procedure documented

---

### CFO Deliverables

- [ ] **Daily Report Template** in `../board/CFO/daily_reports/`
- [ ] **Weekly Report Template** in `../board/CFO/weekly_reports/`
- [ ] **Test Tracking Spreadsheet** (or query interface)
- [ ] **Month 1 Escalation Rules** documented + approved
- [ ] **Revenue Forecast Calculator** (auto-project month-end from current pace)

---

## REFERENCE: SQL QUERIES FOR COMMON DIAGNOSTICS

### Query 1: "Is P1 conversion rate the bottleneck?"

```sql
SELECT
  AVG(conversion_rate) as avg_conv_rate,
  MIN(conversion_rate) as min_conv_rate,
  MAX(conversion_rate) as max_conv_rate,
  STDDEV(conversion_rate) as stddev_conv_rate
FROM daily_metrics
WHERE stream = 'P1_digital'
  AND date >= CURRENT_DATE - INTERVAL '7 days'
  AND date <= CURRENT_DATE;

-- Expected: ~5% average
-- If <3%: Copy/positioning issue
-- If >7%: Good, focus on traffic
```

### Query 2: "Is P3 traffic growing or stalled?"

```sql
SELECT
  DATE_TRUNC('day', date) as day,
  SUM(visitors_count) as daily_visitors,
  LAG(SUM(visitors_count)) OVER (ORDER BY DATE_TRUNC('day', date)) as prev_day_visitors,
  ROUND(
    (SUM(visitors_count) - LAG(SUM(visitors_count)) OVER (ORDER BY DATE_TRUNC('day', date)))
    / LAG(SUM(visitors_count)) OVER (ORDER BY DATE_TRUNC('day', date)) * 100, 1
  ) as pct_growth
FROM daily_metrics
WHERE stream = 'P3_affiliate'
  AND date >= CURRENT_DATE - INTERVAL '14 days'
GROUP BY DATE_TRUNC('day', date)
ORDER BY day DESC;

-- Expected growth: +5–10%/day (ramp)
-- If flat/negative: Content not ranking or distribution broken
```

### Query 3: "Which A/B test is winning?"

```sql
SELECT
  test_id,
  variant_a_name,
  ROUND((variant_a_conversions::DECIMAL / variant_a_visitors * 100), 2) as variant_a_conv_rate,
  variant_b_name,
  ROUND((variant_b_conversions::DECIMAL / variant_b_visitors * 100), 2) as variant_b_conv_rate,
  CASE
    WHEN variant_a_conversion_rate > variant_b_conversion_rate THEN 'VARIANT A'
    WHEN variant_b_conversion_rate > variant_a_conversion_rate THEN 'VARIANT B'
    ELSE 'TIE'
  END as winner,
  is_significant as statistically_significant
FROM ab_tests
WHERE end_date IS NULL OR end_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY start_date DESC;
```

---

## TIMELINE: MARCH 29–30 IMPLEMENTATION

### March 29, 3:00 PM — CTMO Starts
- [ ] Create database schema (1 hour)
- [ ] Deploy PostgreSQL functions (1.5 hours)
- [ ] Configure n8n workflows (1.5 hours)
- [ ] Test with sample data (1 hour)
- **Status update:** 5:00 PM

### March 29, 5:00 PM — CFO Reviews Progress
- [ ] Verify functions work with CFO queries
- [ ] Check daily report template
- [ ] Approve escalation rules
- [ ] Create Month 1 reporting calendar

### March 30, 8:00 AM — CTMO Final Testing
- [ ] Live integration test (API connections)
- [ ] End-to-end test: Dashboard → Report → Escalation
- [ ] Backup/recovery test
- [ ] Go-live checklist approval

### March 30, 6:00 PM — CFO Final Verification
- [ ] Escalation email test (send sample alert)
- [ ] Weekly report generation test
- [ ] A/B test router test (if applicable)
- [ ] Sign-off: Ready for April 1

---

**END OF IMPLEMENTATION GUIDE**

**Owner:** CTMO (primary), CFO (secondary)
**Status:** Ready to implement
**Deadline:** March 30, 2026, 11:59 PM
**Next Review:** April 1, 08:00 AM (first dashboard generation)
