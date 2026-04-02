-- MakinMoves Revenue Capture Database Schema
-- Database: makinmoves
-- Purpose: Centralized revenue tracking across 5 platforms (Gumroad, Etsy, WordPress, Medium, Redbubble)
-- Created: 2026-03-29

-- =============================================================================
-- 1. GUMROAD SALES TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS gumroad_sales (
  id SERIAL PRIMARY KEY,
  product_id TEXT NOT NULL,
  sale_id TEXT NOT NULL UNIQUE,
  amount DECIMAL(10, 2) NOT NULL,
  currency TEXT DEFAULT 'usd',
  customer_email_hash TEXT NOT NULL,  -- SHA256 hash (no PII in plaintext)
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  source TEXT DEFAULT 'gumroad',
  notes TEXT,
  CONSTRAINT gumroad_amount_positive CHECK (amount >= 0),
  INDEX idx_gumroad_created_at (created_at),
  INDEX idx_gumroad_product_id (product_id),
  INDEX idx_gumroad_sale_id (sale_id)
);

CREATE TABLE IF NOT EXISTS gumroad_products (
  id SERIAL PRIMARY KEY,
  product_id TEXT NOT NULL UNIQUE,
  product_name TEXT,
  product_url TEXT,
  last_synced TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  active BOOLEAN DEFAULT true,
  notes TEXT,
  INDEX idx_gumroad_products_product_id (product_id)
);

CREATE TABLE IF NOT EXISTS gumroad_errors (
  id SERIAL PRIMARY KEY,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  retry_count INT DEFAULT 0,
  resolved BOOLEAN DEFAULT false,
  INDEX idx_gumroad_errors_timestamp (request_timestamp)
);

-- =============================================================================
-- 2. ETSY SALES TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS etsy_sales (
  id SERIAL PRIMARY KEY,
  listing_id TEXT NOT NULL,
  transaction_id TEXT NOT NULL UNIQUE,
  amount DECIMAL(10, 2) NOT NULL,
  currency TEXT DEFAULT 'usd',
  buyer_username_hash TEXT,  -- SHA256 hash (pseudonymous, still hashed)
  quantity INT DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  source TEXT DEFAULT 'etsy',
  notes TEXT,
  CONSTRAINT etsy_amount_positive CHECK (amount >= 0),
  CONSTRAINT etsy_quantity_positive CHECK (quantity > 0),
  INDEX idx_etsy_created_at (created_at),
  INDEX idx_etsy_listing_id (listing_id),
  INDEX idx_etsy_transaction_id (transaction_id)
);

CREATE TABLE IF NOT EXISTS etsy_listings (
  id SERIAL PRIMARY KEY,
  listing_id TEXT NOT NULL UNIQUE,
  listing_title TEXT,
  shop_id INT,
  last_stats_fetch TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  active BOOLEAN DEFAULT true,
  notes TEXT,
  INDEX idx_etsy_listings_listing_id (listing_id),
  INDEX idx_etsy_listings_shop_id (shop_id)
);

CREATE TABLE IF NOT EXISTS etsy_rate_limit_tracking (
  id SERIAL PRIMARY KEY,
  requests_today INT DEFAULT 0,
  last_reset TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  rolling_window_start TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  qps_limit INT DEFAULT 10,
  qpd_limit INT DEFAULT 10000,
  notes TEXT,
  CONSTRAINT etsy_requests_non_negative CHECK (requests_today >= 0)
);

CREATE TABLE IF NOT EXISTS etsy_errors (
  id SERIAL PRIMARY KEY,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  retry_count INT DEFAULT 0,
  resolved BOOLEAN DEFAULT false,
  INDEX idx_etsy_errors_timestamp (request_timestamp)
);

-- =============================================================================
-- 3. WORDPRESS EARNINGS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS wordpress_earnings (
  id SERIAL PRIMARY KEY,
  post_id INT NOT NULL UNIQUE,
  affiliate_program TEXT NOT NULL,  -- e.g., 'amazon_associates', 'refersion'
  earnings DECIMAL(10, 2) NOT NULL,
  clicks INT DEFAULT 0,
  impressions INT DEFAULT 0,
  conversion_rate DECIMAL(5, 2),  -- percentage
  date DATE NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  manual_entry BOOLEAN DEFAULT true,
  notes TEXT,
  CONSTRAINT wp_earnings_non_negative CHECK (earnings >= 0),
  CONSTRAINT wp_clicks_non_negative CHECK (clicks >= 0),
  INDEX idx_wordpress_date (date),
  INDEX idx_wordpress_program (affiliate_program),
  UNIQUE (affiliate_program, date)
);

CREATE TABLE IF NOT EXISTS wordpress_errors (
  id SERIAL PRIMARY KEY,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  retry_count INT DEFAULT 0,
  resolved BOOLEAN DEFAULT false,
  INDEX idx_wordpress_errors_timestamp (request_timestamp)
);

-- =============================================================================
-- 4. MEDIUM EARNINGS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS medium_earnings (
  id SERIAL PRIMARY KEY,
  earnings DECIMAL(10, 2) NOT NULL,
  views INT DEFAULT 0,
  reads INT DEFAULT 0,
  fans INT DEFAULT 0,
  date DATE NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  manual_entry BOOLEAN DEFAULT true,
  notes TEXT,
  CONSTRAINT medium_earnings_non_negative CHECK (earnings >= 0),
  CONSTRAINT medium_views_non_negative CHECK (views >= 0),
  CONSTRAINT medium_reads_non_negative CHECK (reads >= 0),
  INDEX idx_medium_date (date),
  UNIQUE (date)
);

CREATE TABLE IF NOT EXISTS medium_errors (
  id SERIAL PRIMARY KEY,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  retry_count INT DEFAULT 0,
  resolved BOOLEAN DEFAULT false,
  INDEX idx_medium_errors_timestamp (request_timestamp)
);

-- =============================================================================
-- 5. REDBUBBLE EARNINGS TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS redbubble_earnings (
  id SERIAL PRIMARY KEY,
  earnings DECIMAL(10, 2) NOT NULL,
  orders INT DEFAULT 0,
  views INT DEFAULT 0,
  conversion_rate DECIMAL(5, 2),  -- percentage
  date DATE NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  manual_entry BOOLEAN DEFAULT true,
  notes TEXT,
  CONSTRAINT redbubble_earnings_non_negative CHECK (earnings >= 0),
  CONSTRAINT redbubble_orders_non_negative CHECK (orders >= 0),
  CONSTRAINT redbubble_views_non_negative CHECK (views >= 0),
  INDEX idx_redbubble_date (date),
  UNIQUE (date)
);

CREATE TABLE IF NOT EXISTS redbubble_errors (
  id SERIAL PRIMARY KEY,
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  retry_count INT DEFAULT 0,
  resolved BOOLEAN DEFAULT false,
  INDEX idx_redbubble_errors_timestamp (request_timestamp)
);

-- =============================================================================
-- 6. UNIFIED REVENUE SUMMARY TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS daily_revenue_summary (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL UNIQUE,
  gumroad_revenue DECIMAL(10, 2) DEFAULT 0,
  gumroad_transactions INT DEFAULT 0,
  etsy_revenue DECIMAL(10, 2) DEFAULT 0,
  etsy_transactions INT DEFAULT 0,
  wordpress_revenue DECIMAL(10, 2) DEFAULT 0,
  medium_revenue DECIMAL(10, 2) DEFAULT 0,
  redbubble_revenue DECIMAL(10, 2) DEFAULT 0,
  total_revenue DECIMAL(10, 2) GENERATED ALWAYS AS (
    COALESCE(gumroad_revenue, 0) +
    COALESCE(etsy_revenue, 0) +
    COALESCE(wordpress_revenue, 0) +
    COALESCE(medium_revenue, 0) +
    COALESCE(redbubble_revenue, 0)
  ) STORED,
  total_transactions INT GENERATED ALWAYS AS (
    COALESCE(gumroad_transactions, 0) +
    COALESCE(etsy_transactions, 0)
  ) STORED,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,
  CONSTRAINT summary_date_valid CHECK (date < CURRENT_DATE),
  INDEX idx_daily_summary_date (date)
);

-- Trigger to update updated_at on summary changes
CREATE OR REPLACE FUNCTION update_summary_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_summary_timestamp ON daily_revenue_summary;
CREATE TRIGGER trigger_update_summary_timestamp
BEFORE UPDATE ON daily_revenue_summary
FOR EACH ROW
EXECUTE FUNCTION update_summary_timestamp();

-- =============================================================================
-- 7. API ERROR LOG TABLE (Unified)
-- =============================================================================
CREATE TABLE IF NOT EXISTS api_errors (
  id SERIAL PRIMARY KEY,
  platform TEXT NOT NULL,  -- 'gumroad', 'etsy', 'wordpress', 'medium', 'redbubble'
  endpoint TEXT,
  error_code INT,
  error_message TEXT,
  request_data JSONB,  -- Full request (sanitized, no tokens)
  response_data JSONB,  -- Full response
  http_status INT,
  attempt_number INT DEFAULT 1,
  occurred_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT api_errors_platform_valid CHECK (platform IN ('gumroad', 'etsy', 'wordpress', 'medium', 'redbubble')),
  INDEX idx_api_errors_platform (platform),
  INDEX idx_api_errors_occurred_at (occurred_at),
  INDEX idx_api_errors_status (http_status)
);

-- =============================================================================
-- 8. WORKFLOW EXECUTION LOG TABLE
-- =============================================================================
CREATE TABLE IF NOT EXISTS workflow_execution_log (
  id SERIAL PRIMARY KEY,
  workflow_name TEXT NOT NULL,
  platform TEXT,
  execution_start TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  execution_end TIMESTAMP WITH TIME ZONE,
  status TEXT DEFAULT 'running',  -- 'running', 'success', 'failed', 'partial'
  rows_processed INT DEFAULT 0,
  rows_inserted INT DEFAULT 0,
  rows_updated INT DEFAULT 0,
  revenue_captured DECIMAL(10, 2),
  error_message TEXT,
  error_count INT DEFAULT 0,
  retry_count INT DEFAULT 0,
  CONSTRAINT workflow_status_valid CHECK (status IN ('running', 'success', 'failed', 'partial')),
  INDEX idx_workflow_execution_start (execution_start),
  INDEX idx_workflow_execution_platform (platform),
  INDEX idx_workflow_execution_status (status)
);

-- =============================================================================
-- 9. CREDENTIALS & SECRETS TABLE (Encrypted, DO NOT STORE PLAINTEXT!)
-- =============================================================================
-- NOTE: In production, use n8n's native credential storage instead of this table.
-- This table is for metadata tracking only.

CREATE TABLE IF NOT EXISTS credentials_metadata (
  id SERIAL PRIMARY KEY,
  platform TEXT NOT NULL UNIQUE,
  credential_type TEXT NOT NULL,  -- 'oauth', 'api_key', 'basic_auth', 'custom'
  last_rotated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE,
  is_active BOOLEAN DEFAULT true,
  notes TEXT,
  CONSTRAINT credentials_metadata_platform_valid CHECK (platform IN ('gumroad', 'etsy', 'wordpress', 'medium', 'redbubble'))
);

-- =============================================================================
-- 10. MATERIALIZED VIEWS (for quick reporting)
-- =============================================================================

-- Monthly revenue rollup
CREATE MATERIALIZED VIEW IF NOT EXISTS monthly_revenue_summary AS
SELECT
  DATE_TRUNC('month', date)::DATE AS month,
  SUM(gumroad_revenue) AS gumroad_total,
  SUM(etsy_revenue) AS etsy_total,
  SUM(wordpress_revenue) AS wordpress_total,
  SUM(medium_revenue) AS medium_total,
  SUM(redbubble_revenue) AS redbubble_total,
  SUM(total_revenue) AS grand_total,
  COUNT(*) AS days_tracked
FROM daily_revenue_summary
GROUP BY DATE_TRUNC('month', date)
ORDER BY month DESC;

-- Platform performance ranking
CREATE MATERIALIZED VIEW IF NOT EXISTS platform_performance AS
SELECT
  'gumroad' AS platform,
  COUNT(*) AS transaction_count,
  SUM(amount) AS total_revenue,
  AVG(amount) AS avg_transaction_value,
  MAX(amount) AS max_transaction_value,
  MIN(created_at) AS first_transaction,
  MAX(created_at) AS last_transaction
FROM gumroad_sales
UNION ALL
SELECT
  'etsy' AS platform,
  COUNT(*),
  SUM(amount),
  AVG(amount),
  MAX(amount),
  MIN(created_at),
  MAX(created_at)
FROM etsy_sales
ORDER BY total_revenue DESC;

-- 7-day rolling average
CREATE MATERIALIZED VIEW IF NOT EXISTS rolling_7day_revenue AS
SELECT
  date,
  AVG(total_revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_7day_revenue,
  MAX(total_revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS max_7day_revenue,
  MIN(total_revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS min_7day_revenue
FROM daily_revenue_summary
ORDER BY date DESC;

-- =============================================================================
-- 11. HELPER FUNCTIONS
-- =============================================================================

-- Function: Generate daily summary from raw sales tables
CREATE OR REPLACE FUNCTION generate_daily_summary(target_date DATE)
RETURNS TABLE (
  date DATE,
  gumroad_revenue DECIMAL,
  gumroad_transactions INT,
  etsy_revenue DECIMAL,
  etsy_transactions INT,
  wordpress_revenue DECIMAL,
  medium_revenue DECIMAL,
  redbubble_revenue DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    target_date,
    COALESCE(SUM(gs.amount) FILTER (WHERE DATE(gs.created_at) = target_date), 0),
    COUNT(*) FILTER (WHERE DATE(gs.created_at) = target_date),
    COALESCE(SUM(es.amount) FILTER (WHERE DATE(es.created_at) = target_date), 0),
    COUNT(*) FILTER (WHERE DATE(es.created_at) = target_date),
    COALESCE(SUM(we.earnings) FILTER (WHERE we.date = target_date), 0),
    COALESCE(SUM(me.earnings) FILTER (WHERE me.date = target_date), 0),
    COALESCE(SUM(re.earnings) FILTER (WHERE re.date = target_date), 0)
  FROM
    (SELECT 1) AS dummy
  LEFT JOIN gumroad_sales gs ON TRUE
  LEFT JOIN etsy_sales es ON TRUE
  LEFT JOIN wordpress_earnings we ON TRUE
  LEFT JOIN medium_earnings me ON TRUE
  LEFT JOIN redbubble_earnings re ON TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function: Get error count by platform for time range
CREATE OR REPLACE FUNCTION get_error_summary(start_date TIMESTAMP, end_date TIMESTAMP)
RETURNS TABLE (
  platform TEXT,
  error_count INT,
  critical_errors INT,
  warning_errors INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ae.platform,
    COUNT(*),
    COUNT(*) FILTER (WHERE ae.http_status >= 500),
    COUNT(*) FILTER (WHERE ae.http_status BETWEEN 400 AND 499)
  FROM api_errors ae
  WHERE ae.occurred_at BETWEEN start_date AND end_date
  GROUP BY ae.platform
  ORDER BY COUNT(*) DESC;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- 12. INDEXES FOR PERFORMANCE
-- =============================================================================

-- Revenue summary queries
CREATE INDEX IF NOT EXISTS idx_gumroad_created_at_amount ON gumroad_sales(created_at, amount);
CREATE INDEX IF NOT EXISTS idx_etsy_created_at_amount ON etsy_sales(created_at, amount);
CREATE INDEX IF NOT EXISTS idx_wordpress_date_earnings ON wordpress_earnings(date, earnings);
CREATE INDEX IF NOT EXISTS idx_medium_date_earnings ON medium_earnings(date, earnings);
CREATE INDEX IF NOT EXISTS idx_redbubble_date_earnings ON redbubble_earnings(date, earnings);

-- Error tracking queries
CREATE INDEX IF NOT EXISTS idx_api_errors_unresolved ON api_errors(resolved) WHERE NOT resolved;
CREATE INDEX IF NOT EXISTS idx_api_errors_platform_timestamp ON api_errors(platform, occurred_at);

-- Workflow execution queries
CREATE INDEX IF NOT EXISTS idx_workflow_recent ON workflow_execution_log(execution_start DESC);
CREATE INDEX IF NOT EXISTS idx_workflow_platform_status ON workflow_execution_log(platform, status);

-- =============================================================================
-- 13. SETUP VERIFICATION QUERIES
-- =============================================================================

-- Run these to verify schema is correctly installed:

-- Count tables
-- SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';
-- Expected: 14 (plus system tables)

-- List all tables
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;

-- Verify views created
-- SELECT matviewname FROM pg_matviews;
-- Expected: 3 (monthly_revenue_summary, platform_performance, rolling_7day_revenue)

-- Verify functions created
-- SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'public';
-- Expected: 2 (generate_daily_summary, get_error_summary)

-- =============================================================================
-- END OF SCHEMA
-- =============================================================================
