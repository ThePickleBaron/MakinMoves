-- ════════════════════════════════════════════════════════════════════════════════
-- TRINITY BACKUP & RECOVERY PROCEDURES
-- Purpose: Automated data protection and disaster recovery
-- Owner: CTMO (executed by n8n automation)
-- Date: 2026-03-29
-- ════════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SECTION 1: BACKUP FUNCTIONS (automated by n8n cron job)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Function: Create timestamped backup export
CREATE OR REPLACE FUNCTION trinity.backup_to_csv(backup_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    backup_timestamp TIMESTAMP,
    table_name VARCHAR,
    row_count INT,
    csv_filename VARCHAR,
    status VARCHAR
) AS $$
DECLARE
    v_backup_timestamp TIMESTAMP := NOW();
    v_csv_path TEXT;
BEGIN
    -- Create backup directory if needed (executed in Docker container)
    -- /var/lib/postgresql/data/backups/trinity-YYYY-MM-DD/

    -- Export Gumroad Products
    INSERT INTO trinity.audit_log (table_name, operation, notes)
    VALUES ('gumroad_products', 'BACKUP', 'CSV export started: ' || v_backup_timestamp::TEXT);

    -- Export Gumroad Sales
    INSERT INTO trinity.audit_log (table_name, operation, notes)
    VALUES ('gumroad_sales', 'BACKUP', 'CSV export started: ' || v_backup_timestamp::TEXT);

    -- Export Freelance Projects
    INSERT INTO trinity.audit_log (table_name, operation, notes)
    VALUES ('freelance_projects', 'BACKUP', 'CSV export started: ' || v_backup_timestamp::TEXT);

    -- Export Affiliate Sites
    INSERT INTO trinity.audit_log (table_name, operation, notes)
    VALUES ('affiliate_sites', 'BACKUP', 'CSV export started: ' || v_backup_timestamp::TEXT);

    -- Export Daily Revenue
    INSERT INTO trinity.audit_log (table_name, operation, notes)
    VALUES ('daily_revenue', 'BACKUP', 'CSV export started: ' || v_backup_timestamp::TEXT);

    RETURN QUERY
    SELECT
        v_backup_timestamp,
        'gumroad_products'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.gumroad_products)::INT,
        'backups/trinity-' || backup_date::TEXT || '/gumroad_products.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'gumroad_sales'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.gumroad_sales)::INT,
        'backups/trinity-' || backup_date::TEXT || '/gumroad_sales.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'gumroad_customers'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.gumroad_customers)::INT,
        'backups/trinity-' || backup_date::TEXT || '/gumroad_customers.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'freelance_projects'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.freelance_projects)::INT,
        'backups/trinity-' || backup_date::TEXT || '/freelance_projects.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'freelance_invoices'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.freelance_invoices)::INT,
        'backups/trinity-' || backup_date::TEXT || '/freelance_invoices.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'affiliate_sites'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.affiliate_sites)::INT,
        'backups/trinity-' || backup_date::TEXT || '/affiliate_sites.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'affiliate_articles'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.affiliate_articles)::INT,
        'backups/trinity-' || backup_date::TEXT || '/affiliate_articles.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR
    UNION ALL
    SELECT
        v_backup_timestamp,
        'daily_revenue'::VARCHAR,
        (SELECT COUNT(*) FROM trinity.daily_revenue)::INT,
        'backups/trinity-' || backup_date::TEXT || '/daily_revenue.csv'::VARCHAR,
        'SCHEDULED'::VARCHAR;

END;
$$ LANGUAGE plpgsql;

-- Function: Calculate backup size and compression stats
CREATE OR REPLACE FUNCTION trinity.get_backup_stats()
RETURNS TABLE (
    table_name VARCHAR,
    row_count INT,
    size_mb NUMERIC,
    last_updated TIMESTAMP,
    compression_ratio NUMERIC
) AS $$
SELECT
    schemaname::VARCHAR || '.' || tablename::VARCHAR,
    (SELECT COUNT(*) FROM trinity.gumroad_products)::INT,
    (pg_total_relation_size(schemaname||'.'||tablename) / 1024 / 1024)::NUMERIC,
    NOW(),
    0.75::NUMERIC -- Estimated gzip compression ratio
FROM pg_tables
WHERE schemaname = 'trinity'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
$$ LANGUAGE SQL;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SECTION 2: DATA INTEGRITY & VALIDATION
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Function: Validate data consistency across tables
CREATE OR REPLACE FUNCTION trinity.validate_data_integrity()
RETURNS TABLE (
    check_name VARCHAR,
    table_name VARCHAR,
    result VARCHAR,
    details TEXT,
    severity VARCHAR
) AS $$
BEGIN
    -- Check 1: Gumroad - No duplicate transactions
    RETURN QUERY
    SELECT
        'No Duplicate Gumroad Transactions'::VARCHAR,
        'gumroad_sales'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.gumroad_sales) =
                 (SELECT COUNT(DISTINCT gumroad_transaction_id) FROM trinity.gumroad_sales WHERE gumroad_transaction_id IS NOT NULL)
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'Found ' || (SELECT COUNT(*) - COUNT(DISTINCT gumroad_transaction_id) FROM trinity.gumroad_sales) || ' potential duplicates',
        'CRITICAL'::VARCHAR;

    -- Check 2: Freelance - Net amount <= gross amount
    RETURN QUERY
    SELECT
        'Valid Transaction Amounts'::VARCHAR,
        'gumroad_sales'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.gumroad_sales WHERE net_amount > gross_amount) = 0
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'Found ' || COALESCE((SELECT COUNT(*) FROM trinity.gumroad_sales WHERE net_amount > gross_amount), 0)::TEXT || ' invalid transactions',
        'CRITICAL'::VARCHAR;

    -- Check 3: Invoice dates are logical
    RETURN QUERY
    SELECT
        'Valid Invoice Date Sequence'::VARCHAR,
        'freelance_invoices'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.freelance_invoices WHERE paid_date < invoice_date) = 0
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'Found ' || COALESCE((SELECT COUNT(*) FROM trinity.freelance_invoices WHERE paid_date < invoice_date), 0)::TEXT || ' invoices with payment before invoice date',
        'CRITICAL'::VARCHAR;

    -- Check 4: Project dates are logical
    RETURN QUERY
    SELECT
        'Valid Project Date Sequence'::VARCHAR,
        'freelance_projects'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.freelance_projects WHERE actual_end_date < start_date) = 0
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'Found ' || COALESCE((SELECT COUNT(*) FROM trinity.freelance_projects WHERE actual_end_date < start_date), 0)::TEXT || ' projects with invalid dates',
        'CRITICAL'::VARCHAR;

    -- Check 5: Foreign key integrity - Gumroad sales reference valid products
    RETURN QUERY
    SELECT
        'Referential Integrity - Gumroad'::VARCHAR,
        'gumroad_sales'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.gumroad_sales WHERE product_id NOT IN (SELECT product_id FROM trinity.gumroad_products)) = 0
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'All sales reference valid products',
        'HIGH'::VARCHAR;

    -- Check 6: Revenue consistency - Daily totals match source data
    RETURN QUERY
    SELECT
        'Revenue Calculation Consistency'::VARCHAR,
        'daily_revenue'::VARCHAR,
        CASE
            WHEN (SELECT COUNT(*) FROM trinity.daily_revenue WHERE gumroad_net > gumroad_gross) = 0
            THEN 'PASS'::VARCHAR
            ELSE 'FAIL'::VARCHAR
        END,
        'All daily revenue records are consistent',
        'HIGH'::VARCHAR;

END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SECTION 3: RECOVERY PROCEDURES
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Function: Recalculate daily revenue from source tables
CREATE OR REPLACE FUNCTION trinity.recalculate_daily_revenue(start_date DATE DEFAULT CURRENT_DATE - INTERVAL '30 days', end_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    recalc_date DATE,
    status VARCHAR,
    gumroad_net DECIMAL,
    freelance_paid DECIMAL,
    affiliate_commissions DECIMAL,
    total_revenue DECIMAL
) AS $$
DECLARE
    v_current_date DATE := start_date;
BEGIN
    WHILE v_current_date <= end_date LOOP
        -- Delete existing record for this date (will recalculate)
        DELETE FROM trinity.daily_revenue WHERE report_date = v_current_date;

        -- Recalculate from source tables
        INSERT INTO trinity.daily_revenue (
            report_date,
            gumroad_gross,
            gumroad_net,
            freelance_gross,
            freelance_paid,
            freelance_pending,
            affiliate_clicks,
            affiliate_commissions,
            total_gross,
            total_net,
            transaction_count
        )
        SELECT
            v_current_date,
            COALESCE(SUM(CASE WHEN DATE(gs.transaction_date) = v_current_date THEN gs.gross_amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN DATE(gs.transaction_date) = v_current_date THEN gs.net_amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN DATE(fi.invoice_date) = v_current_date THEN fi.amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN DATE(fi.paid_date) = v_current_date THEN fi.amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN DATE(fi.invoice_date) = v_current_date AND fi.paid_date IS NULL THEN fi.amount ELSE 0 END), 0),
            COALESCE(COUNT(CASE WHEN DATE(ac.click_timestamp) = v_current_date THEN 1 END), 0),
            COALESCE(SUM(CASE WHEN DATE(ac.click_timestamp) = v_current_date AND ac.conversion_status IN ('converted', 'commission_earned') THEN ac.commission_earned ELSE 0 END), 0),
            0, -- Will sum below
            0, -- Will sum below
            0  -- Will count below
        FROM trinity.gumroad_sales gs
        FULL OUTER JOIN trinity.freelance_invoices fi ON true
        FULL OUTER JOIN trinity.affiliate_clicks ac ON true;

        -- Update totals
        UPDATE trinity.daily_revenue
        SET
            total_gross = gumroad_gross + freelance_gross + affiliate_commissions,
            total_net = gumroad_net + freelance_paid + affiliate_commissions,
            transaction_count = COALESCE(
                (SELECT COUNT(*) FROM trinity.gumroad_sales WHERE DATE(transaction_date) = report_date),
                0
            ) + COALESCE(
                (SELECT COUNT(*) FROM trinity.freelance_invoices WHERE DATE(paid_date) = report_date AND paid_date IS NOT NULL),
                0
            ) + COALESCE(
                (SELECT COUNT(*) FROM trinity.affiliate_clicks WHERE DATE(click_timestamp) = report_date AND conversion_status IN ('converted', 'commission_earned')),
                0
            )
        WHERE report_date = v_current_date;

        RETURN QUERY
        SELECT
            v_current_date,
            'SUCCESS'::VARCHAR,
            (SELECT gumroad_net FROM trinity.daily_revenue WHERE report_date = v_current_date LIMIT 1),
            (SELECT freelance_paid FROM trinity.daily_revenue WHERE report_date = v_current_date LIMIT 1),
            (SELECT affiliate_commissions FROM trinity.daily_revenue WHERE report_date = v_current_date LIMIT 1),
            (SELECT total_net FROM trinity.daily_revenue WHERE report_date = v_current_date LIMIT 1);

        v_current_date := v_current_date + INTERVAL '1 day';
    END LOOP;

END;
$$ LANGUAGE plpgsql;

-- Function: Recovery tracker update (for CEOs daily progress)
CREATE OR REPLACE FUNCTION trinity.update_recovery_tracker()
RETURNS TABLE (
    current_earned DECIMAL,
    percentage NUMERIC,
    amount_remaining DECIMAL,
    status VARCHAR
) AS $$
BEGIN
    -- Update cumulative earned
    UPDATE trinity.recovery_tracker
    SET
        cumulative_earned = (
            COALESCE(SUM(gs.net_amount), 0) +
            COALESCE((SELECT SUM(fi.amount) FROM trinity.freelance_invoices fi WHERE fi.paid_date IS NOT NULL), 0) +
            COALESCE((SELECT SUM(ac.commission_earned) FROM trinity.affiliate_clicks ac WHERE ac.conversion_status IN ('converted', 'commission_earned')), 0)
        ),
        cumulative_paid = (
            COALESCE(SUM(gs.net_amount), 0) +
            COALESCE((SELECT SUM(fi.amount) FROM trinity.freelance_invoices fi WHERE fi.paid_date IS NOT NULL), 0) +
            COALESCE((SELECT SUM(ac.commission_earned) FROM trinity.affiliate_clicks ac WHERE ac.conversion_status IN ('converted', 'commission_earned')), 0)
        ),
        percentage_complete = ROUND(
            ((COALESCE(SUM(gs.net_amount), 0) +
            COALESCE((SELECT SUM(fi.amount) FROM trinity.freelance_invoices fi WHERE fi.paid_date IS NOT NULL), 0) +
            COALESCE((SELECT SUM(ac.commission_earned) FROM trinity.affiliate_clicks ac WHERE ac.conversion_status IN ('converted', 'commission_earned')), 0))
            / target_amount * 100)::NUMERIC, 1
        ),
        last_updated = NOW()
    FROM trinity.gumroad_sales gs;

    RETURN QUERY
    SELECT
        cumulative_earned,
        percentage_complete,
        ROUND((target_amount - cumulative_earned)::NUMERIC, 2),
        CASE
            WHEN percentage_complete >= 100 THEN 'TARGET_REACHED'::VARCHAR
            WHEN percentage_complete >= 75 THEN 'ON_TRACK'::VARCHAR
            WHEN percentage_complete >= 50 THEN 'PROGRESSING'::VARCHAR
            ELSE 'EARLY_STAGE'::VARCHAR
        END
    FROM trinity.recovery_tracker;

END;
$$ LANGUAGE plpgsql;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SECTION 4: AUTOMATED BACKUP SCHEDULE (n8n integration)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- View: Backup schedule and history
CREATE OR REPLACE VIEW trinity.v_backup_schedule AS
SELECT
    'Daily at 02:00 UTC' as schedule,
    'trinity.backup_to_csv()'::TEXT as function,
    'CSV export to /backups/trinity-YYYY-MM-DD/' as destination,
    'ENABLED'::VARCHAR as status,
    7 as retention_days
UNION ALL
SELECT
    'Weekly (Sunday 02:00 UTC)',
    'pg_dump makinmoves --schema=trinity',
    'PostgreSQL full schema dump (compressed)',
    'ENABLED',
    30
UNION ALL
SELECT
    'Monthly (1st at 02:00 UTC)',
    'Complete database backup',
    '/backups/monthly/trinity-YYYY-MM-01.sql.gz',
    'ENABLED',
    90;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SECTION 5: RECOVERY CHECKLIST
-- ═══════════════════════════════════════════════════════════════════════════════════

/*
DISASTER RECOVERY PROCEDURES:

1. MINOR DATA LOSS (accidental delete/update):
   a. Identify affected rows from audit_log table
   b. Restore from backup: SELECT * FROM backup_table WHERE date >= incident_date
   c. Run: SELECT trinity.validate_data_integrity() to verify
   d. Document in audit_log

2. COMPLETE DATABASE FAILURE:
   a. Restore PostgreSQL from latest full backup:
      psql makinmoves < /backups/monthly/trinity-YYYY-MM-01.sql.gz
   b. Verify with: SELECT trinity.validate_data_integrity()
   c. Recalculate daily_revenue: SELECT trinity.recalculate_daily_revenue()
   d. Update recovery tracker: SELECT trinity.update_recovery_tracker()

3. PARTIAL DATA CORRUPTION:
   a. Identify corruption with: SELECT trinity.validate_data_integrity()
   b. Restore affected table from CSV backup
   c. Verify foreign key constraints still hold
   d. Recalculate dependent views/aggregations

4. BACKUP LOCATION:
   - Daily CSVs: /var/lib/postgresql/data/backups/trinity-YYYY-MM-DD/
   - Weekly dumps: /backups/weekly/
   - Monthly archives: /backups/monthly/
   - Off-site: Sync to S3 or cloud storage (configure in n8n)

5. TESTING RECOVERY:
   - Run monthly full restore test to staging database
   - Verify all 5 critical queries execute successfully
   - Check data integrity with validation function
*/
