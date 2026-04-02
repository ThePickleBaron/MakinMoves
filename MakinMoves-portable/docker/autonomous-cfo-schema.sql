-- ════════════════════════════════════════════════════════════════════════════════
-- AUTONOMOUS FINANCIAL TRACKING SYSTEM (CFO Operations)
-- Purpose: Enable CFO to run financial reports without writing SQL
-- Date: 2026-03-29
-- ════════════════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════════════════
-- 1. CORE FINANCIAL TABLES
-- ══════════════════════════════════════════════════════════════════════════════════

-- Daily Revenue Summary (consolidated from all platforms)
CREATE TABLE IF NOT EXISTS public.revenue_daily (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    platform VARCHAR(50),  -- digital_products, saas, content, trading, manual, other
    source VARCHAR(100),   -- Gumroad, Etsy, Stripe, Google AdSense, etc.
    gross_amount DECIMAL(12,2) NOT NULL,
    fees DECIMAL(12,2) DEFAULT 0,
    net_amount DECIMAL(12,2) NOT NULL,
    transaction_count INT DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Weekly Aggregated Revenue (rolled up from daily)
CREATE TABLE IF NOT EXISTS public.revenue_weekly (
    id SERIAL PRIMARY KEY,
    week_start DATE NOT NULL,
    week_end DATE NOT NULL,
    platform VARCHAR(50),
    gross_amount DECIMAL(12,2) NOT NULL,
    fees DECIMAL(12,2) DEFAULT 0,
    net_amount DECIMAL(12,2) NOT NULL,
    transaction_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Monthly Aggregated Revenue
CREATE TABLE IF NOT EXISTS public.revenue_monthly (
    id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL UNIQUE,  -- First day of month
    platform VARCHAR(50),
    gross_amount DECIMAL(12,2) NOT NULL,
    fees DECIMAL(12,2) DEFAULT 0,
    net_amount DECIMAL(12,2) NOT NULL,
    transaction_count INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Costs & Infrastructure Expenses
CREATE TABLE IF NOT EXISTS public.costs_monthly (
    id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL,
    category VARCHAR(100),  -- hosting, tools, domain, payment_processing, etc.
    vendor VARCHAR(100),    -- Railway, Stripe, Mailchimp, etc.
    amount DECIMAL(12,2) NOT NULL,
    recurring BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ══════════════════════════════════════════════════════════════════════════════════
-- 2. RECOVERY TRACKING (Goal: $10,000)
-- ══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.recovery_goal (
    id SERIAL PRIMARY KEY,
    target_amount DECIMAL(12,2) DEFAULT 10000.00,
    start_date DATE DEFAULT CURRENT_DATE,
    cumulative_earned DECIMAL(12,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW(),
    notes TEXT
);

-- ══════════════════════════════════════════════════════════════════════════════════
-- 3. MONITORING & ALERTS
-- ══════════════════════════════════════════════════════════════════════════════════

-- Error/Failure Tracking
CREATE TABLE IF NOT EXISTS public.error_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    source VARCHAR(100),   -- n8n_workflow, api_integration, database, etc.
    error_type VARCHAR(50), -- timeout, auth_failure, rate_limit, other
    error_message TEXT,
    severity VARCHAR(20),   -- critical, high, medium, low
    resolved BOOLEAN DEFAULT false,
    resolved_at TIMESTAMP,
    notes TEXT
);

-- Publishing/Distribution Tracking
CREATE TABLE IF NOT EXISTS public.publishing_log (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    platform VARCHAR(100),  -- Gumroad, Twitter, Medium, Email, etc.
    content_type VARCHAR(50), -- product, article, update, newsletter, etc.
    title VARCHAR(255),
    status VARCHAR(20),     -- success, failed, pending
    error_message TEXT,
    views INT DEFAULT 0,
    revenue_generated DECIMAL(12,2) DEFAULT 0
);

-- Scheduled Reports Log
CREATE TABLE IF NOT EXISTS public.report_runs (
    id SERIAL PRIMARY KEY,
    report_type VARCHAR(50), -- daily, weekly, monthly, recovery
    run_timestamp TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20),      -- success, failed, pending
    message TEXT
);

-- ══════════════════════════════════════════════════════════════════════════════════
-- 4. PLATFORM METADATA (for reporting)
-- ══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.platforms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50),   -- digital_products, saas, content, trading
    status VARCHAR(20),     -- active, inactive, experimental
    launch_date DATE,
    monthly_cost DECIMAL(12,2) DEFAULT 0,
    api_key_expires TIMESTAMP,
    notes TEXT
);

-- Insert default platforms
INSERT INTO public.platforms (name, category, status) VALUES
    ('Gumroad', 'digital_products', 'active'),
    ('Etsy', 'digital_products', 'planning'),
    ('Shopify', 'digital_products', 'planning'),
    ('Stripe', 'saas', 'active'),
    ('Google AdSense', 'content', 'planning'),
    ('Medium Partner Program', 'content', 'planning'),
    ('Affiliate Network', 'content', 'active'),
    ('Trading Bot', 'trading', 'planning')
ON CONFLICT (name) DO NOTHING;

-- ══════════════════════════════════════════════════════════════════════════════════
-- 5. AUTONOMOUS QUERY FUNCTIONS (CFO Uses These)
-- ══════════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_daily_revenue()
-- Returns today's revenue by platform
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_daily_revenue()
RETURNS TABLE (
    platform VARCHAR,
    source VARCHAR,
    gross_amount NUMERIC,
    fees NUMERIC,
    net_amount NUMERIC,
    transaction_count INT,
    total_net NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(rd.platform, 'TOTAL') AS platform,
        rd.source,
        rd.gross_amount,
        rd.fees,
        rd.net_amount,
        rd.transaction_count,
        (SELECT COALESCE(SUM(net_amount), 0) FROM public.revenue_daily WHERE date = CURRENT_DATE) AS total_net
    FROM public.revenue_daily rd
    WHERE rd.date = CURRENT_DATE
    ORDER BY rd.net_amount DESC NULLS LAST;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_weekly_summary(week_start_date DATE)
-- Returns last 7 days of revenue by platform
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_weekly_summary(p_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    platform VARCHAR,
    total_transactions INT,
    total_gross NUMERIC,
    total_fees NUMERIC,
    total_net NUMERIC,
    avg_daily NUMERIC
) AS $$
DECLARE
    v_week_start DATE;
BEGIN
    v_week_start := p_date - INTERVAL '6 days';

    RETURN QUERY
    SELECT
        COALESCE(rd.platform, 'TOTAL') AS platform,
        SUM(rd.transaction_count)::INT,
        SUM(rd.gross_amount),
        SUM(rd.fees),
        SUM(rd.net_amount),
        ROUND(SUM(rd.net_amount) / 7.0, 2)
    FROM public.revenue_daily rd
    WHERE rd.date BETWEEN v_week_start AND p_date
    GROUP BY rd.platform
    ORDER BY total_net DESC NULLS LAST;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_monthly_report(year_month DATE)
-- Returns detailed monthly financials
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_monthly_report(p_year_month DATE DEFAULT DATE_TRUNC('month', CURRENT_DATE))
RETURNS TABLE (
    metric VARCHAR,
    platform VARCHAR,
    value NUMERIC,
    transaction_count INT
) AS $$
BEGIN
    RETURN QUERY
    WITH monthly_revenue AS (
        SELECT
            rd.platform,
            SUM(rd.net_amount) as total_net,
            SUM(rd.transaction_count) as txn_count
        FROM public.revenue_daily rd
        WHERE DATE_TRUNC('month', rd.date) = p_year_month
        GROUP BY rd.platform
    ),
    monthly_costs AS (
        SELECT
            'Costs' as category,
            SUM(amount) as total_cost
        FROM public.costs_monthly
        WHERE year_month = p_year_month
    )
    SELECT
        'Revenue' as metric,
        COALESCE(mr.platform, 'TOTAL') as platform,
        mr.total_net,
        mr.txn_count::INT
    FROM monthly_revenue mr
    UNION ALL
    SELECT
        'Costs',
        'Infrastructure' as platform,
        (SELECT total_cost FROM monthly_costs),
        0
    UNION ALL
    SELECT
        'Net Profit',
        'BOTTOM LINE' as platform,
        (SELECT SUM(total_net) FROM (
            SELECT SUM(net_amount) as total_net
            FROM public.revenue_daily
            WHERE DATE_TRUNC('month', date) = p_year_month
        ) rev)
        -
        COALESCE((SELECT SUM(amount) FROM public.costs_monthly WHERE year_month = p_year_month), 0),
        0;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_recovery_progress()
-- Tracks progress toward $10k recovery goal
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_recovery_progress()
RETURNS TABLE (
    target_amount NUMERIC,
    total_earned NUMERIC,
    amount_remaining NUMERIC,
    progress_percent NUMERIC,
    days_elapsed INT,
    avg_daily_rate NUMERIC,
    days_to_goal INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        (SELECT target_amount FROM public.recovery_goal ORDER BY id DESC LIMIT 1)::NUMERIC,
        COALESCE(SUM(rd.net_amount), 0),
        COALESCE((SELECT target_amount FROM public.recovery_goal ORDER BY id DESC LIMIT 1), 10000)
            - COALESCE(SUM(rd.net_amount), 0),
        ROUND(
            COALESCE(SUM(rd.net_amount), 0) * 100.0 /
            COALESCE((SELECT target_amount FROM public.recovery_goal ORDER BY id DESC LIMIT 1), 10000),
            2
        ),
        (CURRENT_DATE - (SELECT start_date FROM public.recovery_goal ORDER BY id DESC LIMIT 1))::INT,
        CASE
            WHEN (CURRENT_DATE - (SELECT start_date FROM public.recovery_goal ORDER BY id DESC LIMIT 1)) > 0
            THEN ROUND(
                COALESCE(SUM(rd.net_amount), 0)::NUMERIC /
                (CURRENT_DATE - (SELECT start_date FROM public.recovery_goal ORDER BY id DESC LIMIT 1))::NUMERIC,
                2
            )
            ELSE 0
        END,
        CASE
            WHEN ROUND(
                COALESCE(SUM(rd.net_amount), 0)::NUMERIC /
                (CURRENT_DATE - (SELECT start_date FROM public.recovery_goal ORDER BY id DESC LIMIT 1))::NUMERIC,
                2
            ) > 0
            THEN CEIL(
                (COALESCE((SELECT target_amount FROM public.recovery_goal ORDER BY id DESC LIMIT 1), 10000)
                    - COALESCE(SUM(rd.net_amount), 0)) /
                ROUND(
                    COALESCE(SUM(rd.net_amount), 0)::NUMERIC /
                    (CURRENT_DATE - (SELECT start_date FROM public.recovery_goal ORDER BY id DESC LIMIT 1))::NUMERIC,
                    2
                )
            )::INT
            ELSE 99999
        END
    FROM public.revenue_daily rd;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_platform_ranking()
-- Ranks platforms by total earnings
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_platform_ranking()
RETURNS TABLE (
    rank INT,
    platform VARCHAR,
    total_revenue NUMERIC,
    percentage_of_total NUMERIC,
    transactions INT,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    WITH platform_totals AS (
        SELECT
            rd.platform,
            SUM(rd.net_amount) as total_revenue,
            SUM(rd.transaction_count) as txn_count
        FROM public.revenue_daily rd
        GROUP BY rd.platform
    ),
    platform_totals_with_pct AS (
        SELECT
            pt.platform,
            pt.total_revenue,
            ROUND(pt.total_revenue * 100.0 / (SELECT SUM(total_revenue) FROM platform_totals), 2) as pct,
            pt.txn_count,
            ROW_NUMBER() OVER (ORDER BY pt.total_revenue DESC) as rank_num
        FROM platform_totals pt
    )
    SELECT
        rank_num::INT,
        COALESCE(ptwp.platform, 'Unknown'),
        ptwp.total_revenue,
        ptwp.pct,
        ptwp.txn_count::INT,
        COALESCE(p.status, 'N/A')
    FROM platform_totals_with_pct ptwp
    LEFT JOIN public.platforms p ON p.name = ptwp.platform
    ORDER BY rank_num;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_burn_rate(p_months INT DEFAULT 3)
-- Monthly costs vs. revenue (trend analysis)
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_burn_rate(p_months INT DEFAULT 3)
RETURNS TABLE (
    month_name VARCHAR,
    total_revenue NUMERIC,
    total_costs NUMERIC,
    net_profit NUMERIC,
    profit_margin_percent NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH monthly_data AS (
        SELECT
            DATE_TRUNC('month', rd.date)::DATE as month_date,
            SUM(rd.net_amount) as revenue
        FROM public.revenue_daily rd
        WHERE rd.date >= CURRENT_DATE - (p_months || ' months')::INTERVAL
        GROUP BY DATE_TRUNC('month', rd.date)
    ),
    monthly_costs_data AS (
        SELECT
            year_month as month_date,
            SUM(amount) as costs
        FROM public.costs_monthly
        WHERE year_month >= CURRENT_DATE - (p_months || ' months')::INTERVAL
        GROUP BY year_month
    )
    SELECT
        TO_CHAR(md.month_date, 'YYYY-MM') as month_name,
        COALESCE(md.revenue, 0),
        COALESCE(mcd.costs, 0),
        COALESCE(md.revenue, 0) - COALESCE(mcd.costs, 0),
        CASE
            WHEN COALESCE(md.revenue, 0) > 0 THEN
                ROUND((COALESCE(md.revenue, 0) - COALESCE(mcd.costs, 0)) * 100.0 / COALESCE(md.revenue, 0), 2)
            ELSE 0
        END
    FROM monthly_data md
    LEFT JOIN monthly_costs_data mcd ON md.month_date = mcd.month_date
    ORDER BY md.month_date DESC;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: forecast_recovery_date(p_target DECIMAL DEFAULT 10000)
-- Projects when we'll hit recovery milestones
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION forecast_recovery_date(p_target DECIMAL DEFAULT 10000)
RETURNS TABLE (
    milestone_amount NUMERIC,
    days_to_milestone INT,
    projected_date DATE,
    confidence VARCHAR
) AS $$
DECLARE
    v_current_earned NUMERIC;
    v_days_elapsed INT;
    v_daily_avg NUMERIC;
    v_remaining NUMERIC;
BEGIN
    -- Get current earned amount
    SELECT COALESCE(SUM(net_amount), 0) INTO v_current_earned
    FROM public.revenue_daily;

    -- Get days since start
    SELECT COALESCE((CURRENT_DATE - start_date), 1)::INT INTO v_days_elapsed
    FROM public.recovery_goal
    ORDER BY id DESC LIMIT 1;

    -- Calculate daily average (minimum 1 day to avoid division by zero)
    v_daily_avg := GREATEST(v_current_earned::NUMERIC / GREATEST(v_days_elapsed, 1)::NUMERIC, 0.01);

    -- Return milestones: $1k, $5k, $10k
    RETURN QUERY
    WITH milestones AS (
        SELECT 1000::NUMERIC as amount
        UNION ALL
        SELECT 5000::NUMERIC
        UNION ALL
        SELECT p_target::NUMERIC
    )
    SELECT
        m.amount,
        CASE
            WHEN m.amount <= v_current_earned THEN 0
            ELSE CEIL(((m.amount - v_current_earned) / v_daily_avg))::INT
        END,
        CASE
            WHEN m.amount <= v_current_earned THEN CURRENT_DATE
            ELSE CURRENT_DATE + (CEIL(((m.amount - v_current_earned) / v_daily_avg))::INT || ' days')::INTERVAL
        END,
        CASE
            WHEN v_days_elapsed < 7 THEN 'Low (< 1 week data)'
            WHEN v_days_elapsed < 30 THEN 'Medium (< 1 month data)'
            ELSE 'High (> 1 month data)'
        END
    FROM milestones m
    ORDER BY m.amount;
END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 6. MONITORING & ALERT FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: check_daily_revenue_alert()
-- Alert if daily revenue drops below threshold (health check)
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION check_daily_revenue_alert(p_threshold DECIMAL DEFAULT 5)
RETURNS TABLE (
    alert_triggered BOOLEAN,
    today_revenue NUMERIC,
    threshold NUMERIC,
    message TEXT,
    action_required TEXT
) AS $$
DECLARE
    v_today_revenue NUMERIC;
BEGIN
    SELECT COALESCE(SUM(net_amount), 0) INTO v_today_revenue
    FROM public.revenue_daily
    WHERE date = CURRENT_DATE;

    RETURN QUERY
    SELECT
        (v_today_revenue < p_threshold)::BOOLEAN,
        v_today_revenue,
        p_threshold,
        CASE
            WHEN v_today_revenue = 0 THEN 'No revenue recorded today - check publishing status'
            WHEN v_today_revenue < p_threshold THEN 'Below minimum threshold - check for errors'
            ELSE 'Revenue healthy'
        END,
        CASE
            WHEN v_today_revenue = 0 THEN 'Review publishing_log and error_logs for failures'
            WHEN v_today_revenue < p_threshold THEN 'Check n8n workflows and API integrations'
            ELSE 'None'
        END;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_recent_errors()
-- Shows recent errors and failures
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_recent_errors(p_hours INT DEFAULT 24)
RETURNS TABLE (
    error_id INT,
    timestamp TIMESTAMP,
    source VARCHAR,
    error_type VARCHAR,
    severity VARCHAR,
    message TEXT,
    resolved BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        el.id,
        el.timestamp,
        el.source,
        el.error_type,
        el.severity,
        el.error_message,
        el.resolved
    FROM public.error_logs el
    WHERE el.timestamp >= NOW() - (p_hours || ' hours')::INTERVAL
    AND el.resolved = false
    ORDER BY el.timestamp DESC;
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- FUNCTION: get_publishing_status(p_days INT DEFAULT 7)
-- Shows what was published and how it performed
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_publishing_status(p_days INT DEFAULT 7)
RETURNS TABLE (
    publish_date DATE,
    platform VARCHAR,
    content_type VARCHAR,
    title VARCHAR,
    status VARCHAR,
    views INT,
    revenue_generated NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        DATE(pl.timestamp),
        pl.platform,
        pl.content_type,
        pl.title,
        pl.status,
        pl.views,
        pl.revenue_generated
    FROM public.publishing_log pl
    WHERE pl.timestamp >= NOW() - (p_days || ' days')::INTERVAL
    ORDER BY pl.timestamp DESC;
END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 7. DATA REFRESH/AGGREGATION PROCEDURES
-- ═══════════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- PROCEDURE: refresh_weekly_aggregates()
-- Updates weekly_revenue table from daily data (call daily)
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION refresh_weekly_aggregates()
RETURNS void AS $$
BEGIN
    -- Delete existing week data for last 2 weeks
    DELETE FROM public.revenue_weekly
    WHERE week_start >= CURRENT_DATE - INTERVAL '14 days';

    -- Insert fresh weekly aggregates
    INSERT INTO public.revenue_weekly (week_start, week_end, platform, gross_amount, fees, net_amount, transaction_count)
    SELECT
        DATE_TRUNC('week', rd.date)::DATE as week_start,
        (DATE_TRUNC('week', rd.date) + INTERVAL '6 days')::DATE as week_end,
        rd.platform,
        SUM(rd.gross_amount),
        SUM(rd.fees),
        SUM(rd.net_amount),
        SUM(rd.transaction_count)
    FROM public.revenue_daily rd
    WHERE rd.date >= CURRENT_DATE - INTERVAL '14 days'
    GROUP BY DATE_TRUNC('week', rd.date), rd.platform;

    RAISE NOTICE 'Weekly aggregates refreshed';
END;
$$ LANGUAGE plpgsql;

-- ───────────────────────────────────────────────────────────────────────────────
-- PROCEDURE: refresh_monthly_aggregates()
-- Updates monthly_revenue table (call daily or weekly)
-- ───────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION refresh_monthly_aggregates()
RETURNS void AS $$
BEGIN
    -- Delete existing month data for last 3 months
    DELETE FROM public.revenue_monthly
    WHERE year_month >= CURRENT_DATE - INTERVAL '90 days';

    -- Insert fresh monthly aggregates
    INSERT INTO public.revenue_monthly (year_month, platform, gross_amount, fees, net_amount, transaction_count)
    SELECT
        DATE_TRUNC('month', rd.date)::DATE as year_month,
        rd.platform,
        SUM(rd.gross_amount),
        SUM(rd.fees),
        SUM(rd.net_amount),
        SUM(rd.transaction_count)
    FROM public.revenue_daily rd
    WHERE rd.date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY DATE_TRUNC('month', rd.date), rd.platform;

    RAISE NOTICE 'Monthly aggregates refreshed';
END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 8. INDEXES FOR PERFORMANCE
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_revenue_daily_date ON public.revenue_daily(date DESC);
CREATE INDEX IF NOT EXISTS idx_revenue_daily_platform ON public.revenue_daily(platform);
CREATE INDEX IF NOT EXISTS idx_revenue_weekly_week ON public.revenue_weekly(week_start DESC);
CREATE INDEX IF NOT EXISTS idx_revenue_monthly_month ON public.revenue_monthly(year_month DESC);
CREATE INDEX IF NOT EXISTS idx_error_logs_timestamp ON public.error_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_error_logs_resolved ON public.error_logs(resolved);
CREATE INDEX IF NOT EXISTS idx_publishing_log_timestamp ON public.publishing_log(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_publishing_log_status ON public.publishing_log(status);
CREATE INDEX IF NOT EXISTS idx_costs_monthly_date ON public.costs_monthly(year_month DESC);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- 9. INITIAL SETUP DATA
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Initialize recovery goal (if not exists)
INSERT INTO public.recovery_goal (target_amount, start_date)
SELECT 10000.00, CURRENT_DATE
WHERE NOT EXISTS (SELECT 1 FROM public.recovery_goal);

-- Sample cost structure (monthly subscriptions)
INSERT INTO public.costs_monthly (year_month, category, vendor, amount, recurring)
SELECT
    DATE_TRUNC('month', CURRENT_DATE)::DATE,
    'Hosting',
    'Railway',
    50.00,
    true
WHERE NOT EXISTS (
    SELECT 1 FROM public.costs_monthly
    WHERE year_month = DATE_TRUNC('month', CURRENT_DATE)::DATE
    AND vendor = 'Railway'
);

RAISE NOTICE 'Autonomous CFO Schema initialized';
