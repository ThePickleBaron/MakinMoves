-- ════════════════════════════════════════════════════════════════════════════════
-- CFO QUICK REFERENCE: Copy/Paste Queries for Autonomous Tracking
-- ════════════════════════════════════════════════════════════════════════════════
-- Last Updated: 2026-03-29
-- Usage: Copy query section, paste into psql or n8n PostgreSQL node
-- ════════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERY 1: HOURLY DASHBOARD (Run Every Hour at :00)
-- ════════════════════════════════════════════════════════════════════════════════
-- CFO Dashboard — Recovery % + Today's Revenue + ETA
-- Output: 7 columns, 1 row
-- Use in: Hourly standup, n8n workflow

WITH goal AS (
    SELECT target_amount FROM public.recovery_goals
    ORDER BY created_at DESC LIMIT 1
),
today_revenue AS (
    SELECT COALESCE(SUM(total), 0) as today_total
    FROM public.daily_revenue
    WHERE date = CURRENT_DATE
),
cumulative AS (
    SELECT COALESCE(SUM(total), 0) as all_time_revenue
    FROM public.daily_revenue
    WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)
),
current_hour AS (
    SELECT
        COALESCE(digital_products, 0) as dp,
        COALESCE(saas_mrr, 0) as saas,
        COALESCE(content, 0) as content,
        COALESCE(trading_pnl, 0) as trading,
        COALESCE(total, 0) as hour_total
    FROM public.hourly_revenue
    WHERE hour >= DATE_TRUNC('hour', NOW())
    LIMIT 1
)
SELECT
    (SELECT target_amount FROM goal) as goal,
    (SELECT all_time_revenue FROM cumulative) as total_recovered,
    ROUND(((SELECT all_time_revenue FROM cumulative) / (SELECT target_amount FROM goal)) * 100, 2) as recovery_pct,
    (SELECT today_total FROM today_revenue) as today_revenue,
    (SELECT hour_total FROM current_hour) as this_hour_revenue,
    (SELECT target_amount FROM goal) - (SELECT all_time_revenue FROM cumulative) as remaining_to_goal,
    ROUND(EXTRACT(DAY FROM NOW() - (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)), 1) as days_elapsed;

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERY 2: REVENUE BY STREAM (Run Every 4 Hours)
-- ════════════════════════════════════════════════════════════════════════════════
-- Compare each stream: this week vs last week + trend
-- Output: 5 columns (stream, this_week, last_week, trend_pct, [4 rows for 4 streams])
-- Use in: n8n daily workflow, Board reporting

SELECT
    'Digital Products' as stream,
    COALESCE(SUM(digital_products), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN digital_products END), 0) as last_week,
    ROUND(((COALESCE(SUM(digital_products), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN digital_products END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'SaaS (MRR)',
    COALESCE(SUM(saas_mrr), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN saas_mrr END), 0) as last_week,
    ROUND(((COALESCE(SUM(saas_mrr), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN saas_mrr END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'Content/Affiliate',
    COALESCE(SUM(content), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN content END), 0) as last_week,
    ROUND(((COALESCE(SUM(content), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN content END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

UNION ALL

SELECT
    'Trading P&L',
    COALESCE(SUM(trading_pnl), 0) as this_week,
    COALESCE(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN trading_pnl END), 0) as last_week,
    ROUND(((COALESCE(SUM(trading_pnl), 0) / NULLIF(SUM(CASE WHEN date >= CURRENT_DATE - INTERVAL '14 days' AND date < CURRENT_DATE - INTERVAL '7 days' THEN trading_pnl END), 0)) - 1) * 100, 1) as trend_pct
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days'

ORDER BY this_week DESC;

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERY 3: COSTS & PROFIT (Run Daily at 8am)
-- ════════════════════════════════════════════════════════════════════════════════
-- Daily + weekly cost tracking, processor fees, profit margin
-- Output: 8 columns, 1 row
-- Use in: Daily financial report, CFO standup

SELECT
    CURRENT_DATE as report_date,
    COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE), 0) as daily_revenue,
    COALESCE((SELECT SUM(amount) FROM public.costs WHERE date = CURRENT_DATE), 0) as daily_costs,
    COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date = CURRENT_DATE), 0)
        - COALESCE((SELECT SUM(amount) FROM public.costs WHERE date = CURRENT_DATE), 0) as daily_profit,
    ROUND(COALESCE((SELECT SUM(amount) FROM public.costs WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) / 7, 2) as avg_daily_cost_week,
    ROUND(COALESCE((SELECT SUM(total) FROM public.daily_revenue WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) / 7, 2) as avg_daily_revenue_week,
    COALESCE((SELECT SUM(amount) FROM public.processor_fees WHERE date >= CURRENT_DATE - INTERVAL '7 days'), 0) as processor_fees_week,
    COALESCE((SELECT SUM(amount) FROM public.costs WHERE date >= CURRENT_DATE - INTERVAL '7 days' AND category != 'processor_fee'), 0) as other_costs_week;

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERY 4: ESCALATION ALERTS (Run Every Hour)
-- ════════════════════════════════════════════════════════════════════════════════
-- Active alerts + unresolved errors
-- Output: Shows critical issues requiring CFO action
-- Use in: Hourly check, alert to CEO if severity = CRITICAL

SELECT
    'ALERT' as type,
    alert_type as issue,
    severity,
    message,
    actual_value,
    expected_value,
    ROUND(((actual_value / NULLIF(expected_value, 0)) - 1) * 100, 1) as variance_pct,
    created_at as detected_at,
    EXTRACT(HOUR FROM NOW() - created_at)::INT as hours_active
FROM public.alerts
WHERE created_at >= NOW() - INTERVAL '24 hours'
AND acknowledged = FALSE

UNION ALL

SELECT
    'ERROR' as type,
    error_type as issue,
    CASE WHEN resolved THEN 'RESOLVED' ELSE 'CRITICAL' END as severity,
    source || ': ' || message as message,
    error_count::DECIMAL,
    NULL as expected_value,
    NULL as variance_pct,
    last_occurred,
    EXTRACT(HOUR FROM NOW() - last_occurred)::INT as hours_active
FROM public.errors
WHERE last_occurred >= NOW() - INTERVAL '24 hours'
AND resolved = FALSE

ORDER BY severity DESC, created_at DESC;

-- ════════════════════════════════════════════════════════════════════════════════
-- QUERY 5: RECOVERY PROGRESS & ETA (Run Daily at 9am)
-- ════════════════════════════════════════════════════════════════════════════════
-- Calculate ETA to $10,000 goal based on current velocity
-- Output: 10 columns, 1 row
-- Use in: Daily ETA forecast, recovery milestone planning

WITH revenue_stats AS (
    SELECT
        COUNT(*) as days_tracked,
        SUM(total) as total_revenue,
        AVG(total) as avg_daily_revenue,
        MAX(total) as peak_day,
        MIN(total) as min_day
    FROM public.daily_revenue
    WHERE date >= (SELECT start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1)
),
goal_data AS (
    SELECT target_amount, start_date FROM public.recovery_goals ORDER BY created_at DESC LIMIT 1
)
SELECT
    goal_data.target_amount as goal_amount,
    revenue_stats.total_revenue as recovered_to_date,
    ROUND((revenue_stats.total_revenue / goal_data.target_amount) * 100, 2) as recovery_pct,
    (goal_data.target_amount - revenue_stats.total_revenue) as remaining,
    revenue_stats.avg_daily_revenue as daily_avg,
    ROUND((goal_data.target_amount - revenue_stats.total_revenue) / NULLIF(revenue_stats.avg_daily_revenue, 0), 0)::INT as days_to_goal,
    goal_data.start_date + INTERVAL '1 day' * ROUND((goal_data.target_amount - revenue_stats.total_revenue) / NULLIF(revenue_stats.avg_daily_revenue, 0), 0) as projected_completion,
    revenue_stats.peak_day as best_day_revenue,
    revenue_stats.min_day as worst_day_revenue,
    revenue_stats.days_tracked as tracking_days
FROM revenue_stats, goal_data;

-- ════════════════════════════════════════════════════════════════════════════════
-- BONUS: MINI QUERIES FOR QUICK CHECKS
-- ════════════════════════════════════════════════════════════════════════════════

-- Today's total revenue (instant check)
SELECT COALESCE(SUM(total), 0) as today_revenue FROM public.daily_revenue WHERE date = CURRENT_DATE;

-- Recovery % (3 seconds)
SELECT ROUND((SUM(total) / 10000.0) * 100, 2) as recovery_pct FROM public.daily_revenue;

-- Days remaining to goal (at current velocity)
WITH stats AS (
  SELECT AVG(total) as daily_avg, SUM(total) as recovered
  FROM public.daily_revenue
  WHERE date >= CURRENT_DATE - INTERVAL '7 days'
)
SELECT ROUND((10000 - stats.recovered) / NULLIF(stats.daily_avg, 0), 0)::INT as days_to_goal FROM stats;

-- Cost ratio (% of revenue spent on costs)
SELECT ROUND((SUM(costs) / NULLIF(SUM(total), 0)) * 100, 1) as cost_ratio_pct FROM public.daily_revenue WHERE date >= CURRENT_DATE - INTERVAL '7 days';

-- Top stream this week
SELECT
    CASE
        WHEN SUM(digital_products) >= SUM(saas_mrr) AND SUM(digital_products) >= SUM(content) AND SUM(digital_products) >= COALESCE(SUM(trading_pnl), 0) THEN 'Digital Products'
        WHEN SUM(saas_mrr) >= SUM(digital_products) AND SUM(saas_mrr) >= SUM(content) AND SUM(saas_mrr) >= COALESCE(SUM(trading_pnl), 0) THEN 'SaaS (MRR)'
        WHEN SUM(content) >= SUM(digital_products) AND SUM(content) >= SUM(saas_mrr) AND SUM(content) >= COALESCE(SUM(trading_pnl), 0) THEN 'Content/Affiliate'
        ELSE 'Trading'
    END as top_stream,
    MAX(GREATEST(SUM(digital_products), SUM(saas_mrr), SUM(content), COALESCE(SUM(trading_pnl), 0))) as amount
FROM public.daily_revenue
WHERE date >= CURRENT_DATE - INTERVAL '7 days';

-- ════════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION QUERIES (Run Once on Day 1)
-- ════════════════════════════════════════════════════════════════════════════════

-- Initialize recovery goal (CEO sets target)
INSERT INTO public.recovery_goals (target_amount, start_date, goal_date, seed_budget, notes)
VALUES (10000.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days', 1000.00, 'Primary recovery goal from scam loss');

-- Initialize first daily revenue entry
INSERT INTO public.daily_revenue (date, digital_products, saas_mrr, content, trading_pnl, total, costs, net, cumulative_revenue, recovery_pct)
VALUES (CURRENT_DATE, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- ════════════════════════════════════════════════════════════════════════════════
-- MAINTENANCE: Update Cumulative Recovery % (Run hourly via n8n)
-- ════════════════════════════════════════════════════════════════════════════════

UPDATE public.daily_revenue
SET
    cumulative_revenue = (
        SELECT SUM(total) FROM public.daily_revenue
        WHERE date <= CURRENT_DATE
    ),
    recovery_pct = ROUND(
        ((SELECT SUM(total) FROM public.daily_revenue WHERE date <= CURRENT_DATE) / 10000.00) * 100, 2
    ),
    updated_at = NOW()
WHERE date = CURRENT_DATE;

-- ════════════════════════════════════════════════════════════════════════════════
-- DEBUG: Check table structure (if queries fail)
-- ════════════════════════════════════════════════════════════════════════════════

-- List all CFO tables
\dt public.*

-- Show daily_revenue schema
\d public.daily_revenue

-- Check row count (verify data is being inserted)
SELECT COUNT(*) as daily_rows FROM public.daily_revenue;
SELECT COUNT(*) as hourly_rows FROM public.hourly_revenue;
SELECT COUNT(*) as cost_rows FROM public.costs;
SELECT COUNT(*) as alert_rows FROM public.alerts;

-- ════════════════════════════════════════════════════════════════════════════════
-- END OF QUICK REFERENCE
-- ════════════════════════════════════════════════════════════════════════════════
