-- ════════════════════════════════════════════════════════════════════════════════
-- TRINITY CRITICAL QUERIES
-- Purpose: 5 essential queries for autonomous financial reporting
-- Owner: CFO (executed via dashboard or n8n automation)
-- Date: 2026-03-29
-- ════════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERY 1: DAILY REVENUE DASHBOARD
-- Purpose: What revenue came in TODAY across all streams?
-- CFO Dashboard: Run this query every 24 hours to populate daily_revenue table
-- ═══════════════════════════════════════════════════════════════════════════════════

WITH daily_gumroad AS (
    SELECT
        DATE(gs.transaction_date) as report_date,
        SUM(gs.gross_amount) as gross_amount,
        SUM(gs.gumroad_fee) as fees,
        SUM(gs.net_amount) as net_amount,
        COUNT(*) as transaction_count
    FROM trinity.gumroad_sales gs
    WHERE DATE(gs.transaction_date) = CURRENT_DATE
    GROUP BY DATE(gs.transaction_date)
),
daily_freelance_invoiced AS (
    SELECT
        DATE(fi.invoice_date) as report_date,
        SUM(fi.amount) as gross_amount
    FROM trinity.freelance_invoices fi
    WHERE DATE(fi.invoice_date) = CURRENT_DATE
    GROUP BY DATE(fi.invoice_date)
),
daily_freelance_paid AS (
    SELECT
        DATE(fi.paid_date) as report_date,
        SUM(fi.amount) as paid_amount
    FROM trinity.freelance_invoices fi
    WHERE DATE(fi.paid_date) = CURRENT_DATE AND fi.paid_date IS NOT NULL
    GROUP BY DATE(fi.paid_date)
),
daily_affiliate AS (
    SELECT
        DATE(ac.click_timestamp) as report_date,
        COUNT(*) as clicks,
        SUM(ac.commission_earned) as commissions
    FROM trinity.affiliate_clicks ac
    WHERE DATE(ac.click_timestamp) = CURRENT_DATE
        AND ac.conversion_status IN ('converted', 'commission_earned')
    GROUP BY DATE(ac.click_timestamp)
)
SELECT
    CURRENT_DATE as report_date,
    COALESCE(dg.gross_amount, 0) as gumroad_gross,
    COALESCE(dg.net_amount, 0) as gumroad_net,
    COALESCE(dfi.gross_amount, 0) as freelance_invoiced,
    COALESCE(dfp.paid_amount, 0) as freelance_paid,
    (COALESCE(dfi.gross_amount, 0) - COALESCE(dfp.paid_amount, 0)) as freelance_pending,
    COALESCE(da.clicks, 0) as affiliate_clicks,
    COALESCE(da.commissions, 0) as affiliate_commissions,
    (COALESCE(dg.net_amount, 0) + COALESCE(dfp.paid_amount, 0) + COALESCE(da.commissions, 0)) as total_daily_revenue,
    COALESCE(dg.transaction_count, 0) as transaction_count
FROM daily_gumroad dg
FULL OUTER JOIN daily_freelance_invoiced dfi ON dg.report_date = dfi.report_date
FULL OUTER JOIN daily_freelance_paid dfp ON dg.report_date = dfp.report_date
FULL OUTER JOIN daily_affiliate da ON dg.report_date = da.report_date;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERY 2: MONTHLY BURN RATE & RECOVERY PROGRESS
-- Purpose: Are we on track to recover $10K? How much runway is left?
-- CFO Dashboard: Run on the 1st of each month or on-demand for recovery tracking
-- ═══════════════════════════════════════════════════════════════════════════════════

SELECT
    rt.target_amount,
    rt.start_date,
    CURRENT_DATE as today,
    EXTRACT(DAY FROM (CURRENT_DATE - rt.start_date)) as days_elapsed,
    EXTRACT(DAY FROM (DATE_TRUNC('month', rt.start_date) + INTERVAL '45 days' - rt.start_date)) as days_total_window,
    COALESCE(
        SUM(CASE
            WHEN gs.transaction_date::DATE <= CURRENT_DATE THEN gs.net_amount
            ELSE 0
        END), 0
    ) as gumroad_earned,
    COALESCE(
        SUM(CASE
            WHEN fi.paid_date::DATE <= CURRENT_DATE THEN fi.amount
            ELSE 0
        END), 0
    ) as freelance_earned,
    COALESCE(
        SUM(CASE
            WHEN ac.conversion_status IN ('converted', 'commission_earned')
            AND ac.click_timestamp::DATE <= CURRENT_DATE THEN ac.commission_earned
            ELSE 0
        END), 0
    ) as affiliate_earned,
    (COALESCE(
        SUM(CASE
            WHEN gs.transaction_date::DATE <= CURRENT_DATE THEN gs.net_amount
            ELSE 0
        END), 0
    ) + COALESCE(
        SUM(CASE
            WHEN fi.paid_date::DATE <= CURRENT_DATE THEN fi.amount
            ELSE 0
        END), 0
    ) + COALESCE(
        SUM(CASE
            WHEN ac.conversion_status IN ('converted', 'commission_earned')
            AND ac.click_timestamp::DATE <= CURRENT_DATE THEN ac.commission_earned
            ELSE 0
        END), 0
    )) as total_earned,
    ROUND(
        ((COALESCE(
            SUM(CASE
                WHEN gs.transaction_date::DATE <= CURRENT_DATE THEN gs.net_amount
                ELSE 0
            END), 0
        ) + COALESCE(
            SUM(CASE
                WHEN fi.paid_date::DATE <= CURRENT_DATE THEN fi.amount
                ELSE 0
            END), 0
        ) + COALESCE(
            SUM(CASE
                WHEN ac.conversion_status IN ('converted', 'commission_earned')
                AND ac.click_timestamp::DATE <= CURRENT_DATE THEN ac.commission_earned
                ELSE 0
            END), 0
        )) / rt.target_amount * 100)::NUMERIC, 1
    ) as percentage_complete,
    ROUND(
        (rt.target_amount - (COALESCE(
            SUM(CASE
                WHEN gs.transaction_date::DATE <= CURRENT_DATE THEN gs.net_amount
                ELSE 0
            END), 0
        ) + COALESCE(
            SUM(CASE
                WHEN fi.paid_date::DATE <= CURRENT_DATE THEN fi.amount
                ELSE 0
            END), 0
        ) + COALESCE(
            SUM(CASE
                WHEN ac.conversion_status IN ('converted', 'commission_earned')
                AND ac.click_timestamp::DATE <= CURRENT_DATE THEN ac.commission_earned
                ELSE 0
            END), 0
        )))::NUMERIC, 2
    ) as amount_remaining,
    CASE
        WHEN EXTRACT(DAY FROM (CURRENT_DATE - rt.start_date)) > 0
        THEN ROUND(
            ((COALESCE(
                SUM(CASE
                    WHEN gs.transaction_date::DATE <= CURRENT_DATE THEN gs.net_amount
                    ELSE 0
                END), 0
            ) + COALESCE(
                SUM(CASE
                    WHEN fi.paid_date::DATE <= CURRENT_DATE THEN fi.amount
                    ELSE 0
                END), 0
            ) + COALESCE(
                SUM(CASE
                    WHEN ac.conversion_status IN ('converted', 'commission_earned')
                    AND ac.click_timestamp::DATE <= CURRENT_DATE THEN ac.commission_earned
                    ELSE 0
                END), 0
            )) / EXTRACT(DAY FROM (CURRENT_DATE - rt.start_date)))::NUMERIC, 2
        )
        ELSE 0
    END as daily_avg_earned
FROM trinity.recovery_tracker rt
LEFT JOIN trinity.gumroad_sales gs ON true
LEFT JOIN trinity.freelance_invoices fi ON true
LEFT JOIN trinity.affiliate_clicks ac ON true
GROUP BY rt.target_amount, rt.start_date
LIMIT 1;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERY 3: REVENUE BY STREAM (MONTHLY COMPARISON)
-- Purpose: Which stream is performing best? How is month-to-month growth?
-- CFO Dashboard: Run monthly to compare stream performance
-- ═══════════════════════════════════════════════════════════════════════════════════

WITH monthly_gumroad AS (
    SELECT
        DATE_TRUNC('month', gs.transaction_date)::DATE as month,
        'Gumroad' as stream,
        COUNT(DISTINCT gs.customer_id) as customer_count,
        COUNT(*) as transaction_count,
        SUM(gs.gross_amount) as gross_revenue,
        SUM(gs.gumroad_fee) as fees,
        SUM(gs.net_amount) as net_revenue,
        ROUND(AVG(gs.net_amount)::NUMERIC, 2) as avg_transaction
    FROM trinity.gumroad_sales gs
    GROUP BY DATE_TRUNC('month', gs.transaction_date)
),
monthly_freelance AS (
    SELECT
        DATE_TRUNC('month', fi.invoice_date)::DATE as month,
        'Freelance' as stream,
        COUNT(DISTINCT fj.prospect_id) as customer_count,
        COUNT(fi.invoice_id) as transaction_count,
        SUM(fi.amount) as gross_revenue,
        0 as fees,  -- No platform fees for freelance
        SUM(CASE WHEN fi.paid_date IS NOT NULL THEN fi.amount ELSE 0 END) as net_revenue,
        ROUND(AVG(fi.amount)::NUMERIC, 2) as avg_transaction
    FROM trinity.freelance_invoices fi
    JOIN trinity.freelance_projects fj ON fi.project_id = fj.project_id
    WHERE fi.invoice_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', fi.invoice_date)
),
monthly_affiliate AS (
    SELECT
        DATE_TRUNC('month', ac.click_timestamp)::DATE as month,
        'Affiliate' as stream,
        COUNT(DISTINCT aas.site_id) as customer_count,
        COUNT(ac.click_id) as transaction_count,
        SUM(CASE WHEN ac.conversion_status IN ('converted', 'commission_earned') THEN ac.commission_earned ELSE 0 END) as gross_revenue,
        0 as fees,
        SUM(CASE WHEN ac.conversion_status IN ('converted', 'commission_earned') THEN ac.commission_earned ELSE 0 END) as net_revenue,
        ROUND(AVG(CASE WHEN ac.conversion_status IN ('converted', 'commission_earned') THEN ac.commission_earned ELSE 0 END)::NUMERIC, 2) as avg_transaction
    FROM trinity.affiliate_clicks ac
    JOIN trinity.affiliate_sites aas ON ac.site_id = aas.site_id
    WHERE ac.conversion_status IN ('converted', 'commission_earned')
    GROUP BY DATE_TRUNC('month', ac.click_timestamp)
)
SELECT
    month,
    stream,
    customer_count,
    transaction_count,
    ROUND(gross_revenue::NUMERIC, 2) as gross_revenue,
    ROUND(fees::NUMERIC, 2) as fees,
    ROUND(net_revenue::NUMERIC, 2) as net_revenue,
    ROUND(avg_transaction::NUMERIC, 2) as avg_transaction_size
FROM (
    SELECT * FROM monthly_gumroad
    UNION ALL
    SELECT * FROM monthly_freelance
    UNION ALL
    SELECT * FROM monthly_affiliate
) combined
ORDER BY month DESC, stream;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERY 4: CUSTOMER ACQUISITION COST & LIFETIME VALUE (by stream)
-- Purpose: What's our CAC and LTV? Are we profitable per customer?
-- CFO Dashboard: Run quarterly for business model health check
-- ═══════════════════════════════════════════════════════════════════════════════════

-- P1: Gumroad LTV
SELECT
    'Gumroad' as stream,
    COUNT(DISTINCT gc.customer_id) as total_customers,
    ROUND(COUNT(DISTINCT gc.customer_id)::NUMERIC / EXTRACT(DAY FROM (NOW() - MIN(gc.first_purchase_date)))::NUMERIC * 365, 0)::INT as annual_customers_projected,
    ROUND(AVG(gc.purchase_count)::NUMERIC, 1) as avg_purchases_per_customer,
    ROUND(AVG(gc.lifetime_value)::NUMERIC, 2) as avg_ltv,
    ROUND(MAX(gc.lifetime_value)::NUMERIC, 2) as max_ltv,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gc.lifetime_value)::NUMERIC, 2) as median_ltv,
    'No platform CAC' as notes
FROM trinity.gumroad_customers gc
UNION ALL
-- P2: Freelance CAC/LTV
SELECT
    'Freelance' as stream,
    COUNT(DISTINCT fp.prospect_id) as total_customers,
    COUNT(DISTINCT fj.project_id) as projects,
    ROUND(SUM(fj.contract_value) / NULLIF(COUNT(DISTINCT fp.prospect_id), 0)::NUMERIC, 2) as avg_project_value,
    ROUND(SUM(fj.contract_value) / NULLIF(COUNT(DISTINCT fp.prospect_id), 0)::NUMERIC, 2) as avg_ltv,
    ROUND(MAX(fj.contract_value)::NUMERIC, 2) as max_project_value,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fj.contract_value)::NUMERIC, 2) as median_project_value,
    'Self-sourced (low CAC)' as notes
FROM trinity.freelance_prospects fp
LEFT JOIN trinity.freelance_projects fj ON fp.prospect_id = fj.prospect_id
UNION ALL
-- P3: Affiliate
SELECT
    'Affiliate' as stream,
    COUNT(DISTINCT aas.site_id) as active_sites,
    COUNT(DISTINCT aa.article_id) as articles,
    ROUND(SUM(ac.commission_earned) / NULLIF(COUNT(DISTINCT aas.site_id), 0)::NUMERIC, 2) as avg_commission_per_site,
    ROUND(SUM(ac.commission_earned) / NULLIF(COUNT(DISTINCT aas.site_id), 0)::NUMERIC, 2) as avg_ltv,
    ROUND(MAX(ac.commission_earned)::NUMERIC, 2) as max_commission,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ac.commission_earned)::NUMERIC, 2) as median_commission,
    'Organic (very low CAC)' as notes
FROM trinity.affiliate_sites aas
LEFT JOIN trinity.affiliate_articles aa ON aas.site_id = aa.site_id
LEFT JOIN trinity.affiliate_clicks ac ON aa.article_id = ac.article_id;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- QUERY 5: FINANCIAL HEALTH SCORECARD (Net Revenue after Costs)
-- Purpose: What's our actual profit after infrastructure costs?
-- CFO Dashboard: Monthly for board review
-- ═══════════════════════════════════════════════════════════════════════════════════

WITH monthly_revenue_totals AS (
    SELECT
        DATE_TRUNC('month', CURRENT_DATE)::DATE as year_month,
        COALESCE(SUM(CASE
            WHEN DATE_TRUNC('month', gs.transaction_date)::DATE = DATE_TRUNC('month', CURRENT_DATE)::DATE
            THEN gs.net_amount ELSE 0 END), 0) as gumroad_net,
        COALESCE(SUM(CASE
            WHEN DATE_TRUNC('month', fi.paid_date)::DATE = DATE_TRUNC('month', CURRENT_DATE)::DATE
            AND fi.paid_date IS NOT NULL
            THEN fi.amount ELSE 0 END), 0) as freelance_received,
        COALESCE(SUM(CASE
            WHEN DATE_TRUNC('month', ac.click_timestamp)::DATE = DATE_TRUNC('month', CURRENT_DATE)::DATE
            AND ac.conversion_status IN ('converted', 'commission_earned')
            THEN ac.commission_earned ELSE 0 END), 0) as affiliate_commissions
    FROM trinity.gumroad_sales gs
    FULL OUTER JOIN trinity.freelance_invoices fi ON true
    FULL OUTER JOIN trinity.affiliate_clicks ac ON true
),
monthly_costs_total AS (
    SELECT
        cm.year_month,
        COALESCE(SUM(cm.amount), 0) as total_costs
    FROM trinity.costs_monthly cm
    WHERE cm.year_month = DATE_TRUNC('month', CURRENT_DATE)::DATE
    GROUP BY cm.year_month
)
SELECT
    COALESCE(mrt.year_month, mct.year_month) as report_month,
    mrt.gumroad_net,
    mrt.freelance_received,
    mrt.affiliate_commissions,
    (mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions) as gross_revenue,
    COALESCE(mct.total_costs, 0) as monthly_costs,
    (mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions - COALESCE(mct.total_costs, 0)) as net_profit,
    ROUND(
        ((mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions - COALESCE(mct.total_costs, 0))
        / NULLIF(mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions, 0) * 100)::NUMERIC, 1
    ) as profit_margin_percent,
    CASE
        WHEN (mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions) > COALESCE(mct.total_costs, 0)
        THEN 'PROFITABLE'
        ELSE 'LOSS'
    END as status,
    CASE
        WHEN COALESCE(mct.total_costs, 0) > 0
        THEN ROUND((mrt.gumroad_net + mrt.freelance_received + mrt.affiliate_commissions) / mct.total_costs::NUMERIC, 2)
        ELSE NULL
    END as revenue_to_cost_ratio
FROM monthly_revenue_totals mrt
FULL OUTER JOIN monthly_costs_total mct ON mrt.year_month = mct.year_month;
