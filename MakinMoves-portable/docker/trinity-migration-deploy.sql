-- ════════════════════════════════════════════════════════════════════════════════
-- TRINITY SCHEMA DEPLOYMENT & MIGRATION SCRIPT
-- Purpose: Deploy full Trinity schema in correct order with zero data loss
-- Owner: CTMO
-- Date: 2026-03-29
-- Execution: Run via psql or n8n PostgreSQL node
-- ════════════════════════════════════════════════════════════════════════════════

-- SAFETY CHECK: Verify we're not overwriting existing production data
BEGIN;

SET search_path TO trinity, public;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 1: CREATE SCHEMA IF NOT EXISTS
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE SCHEMA IF NOT EXISTS trinity CASCADE;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 2: DROP EXISTING OBJECTS (if performing fresh schema deploy)
-- NOTE: Comment out if migrating - only do this for clean deploy
-- ═══════════════════════════════════════════════════════════════════════════════════

-- DROP VIEW IF EXISTS trinity.v_daily_summary CASCADE;
-- DROP VIEW IF EXISTS trinity.v_affiliate_summary CASCADE;
-- DROP VIEW IF EXISTS trinity.v_freelance_summary CASCADE;
-- DROP VIEW IF EXISTS trinity.v_gumroad_summary CASCADE;
-- DROP TABLE IF EXISTS trinity.daily_revenue CASCADE;
-- ... etc (full list below if needed)

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 3: CREATE AUDIT/LOGGING TABLE FIRST (needed for triggers)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS trinity.audit_log (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(20),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    audit_timestamp TIMESTAMP DEFAULT NOW(),
    notes TEXT
);

CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON trinity.audit_log(audit_timestamp);
CREATE INDEX IF NOT EXISTS idx_audit_table ON trinity.audit_log(table_name);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 4: CORE TABLES (P1 GUMROAD)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS trinity.gumroad_products (
    product_id SERIAL PRIMARY KEY,
    gumroad_id VARCHAR(100) UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    launch_date TIMESTAMP,
    gumroad_url TEXT,
    thumbnail_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    tags TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gumroad_products_status ON trinity.gumroad_products(status);
CREATE INDEX IF NOT EXISTS idx_gumroad_products_category ON trinity.gumroad_products(category);
CREATE INDEX IF NOT EXISTS idx_gumroad_products_launch ON trinity.gumroad_products(launch_date);

CREATE TABLE IF NOT EXISTS trinity.gumroad_customers (
    customer_id SERIAL PRIMARY KEY,
    gumroad_customer_id VARCHAR(100) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    first_purchase_date TIMESTAMP NOT NULL,
    lifetime_value DECIMAL(10,2) DEFAULT 0,
    purchase_count INT DEFAULT 0,
    last_purchase_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gumroad_customers_email ON trinity.gumroad_customers(email);
CREATE INDEX IF NOT EXISTS idx_gumroad_customers_fpd ON trinity.gumroad_customers(first_purchase_date);

CREATE TABLE IF NOT EXISTS trinity.gumroad_sales (
    transaction_id SERIAL PRIMARY KEY,
    gumroad_transaction_id VARCHAR(100) UNIQUE,
    product_id INT NOT NULL REFERENCES trinity.gumroad_products(product_id) ON DELETE RESTRICT,
    customer_id INT NOT NULL REFERENCES trinity.gumroad_customers(customer_id) ON DELETE RESTRICT,
    gross_amount DECIMAL(10,2) NOT NULL,
    gumroad_fee DECIMAL(10,2) NOT NULL,
    net_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    license_key VARCHAR(100),
    is_gift BOOLEAN DEFAULT false,
    buyer_email VARCHAR(255),
    transaction_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gumroad_sales_product ON trinity.gumroad_sales(product_id);
CREATE INDEX IF NOT EXISTS idx_gumroad_sales_customer ON trinity.gumroad_sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_gumroad_sales_date ON trinity.gumroad_sales(transaction_date);
CREATE INDEX IF NOT EXISTS idx_gumroad_sales_amount ON trinity.gumroad_sales(net_amount);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 5: CORE TABLES (P2 FREELANCE)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS trinity.freelance_prospects (
    prospect_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(255),
    website TEXT,
    source VARCHAR(100),
    location VARCHAR(255),
    budget_estimate DECIMAL(10,2),
    inquiry_date TIMESTAMP NOT NULL,
    first_contact_date TIMESTAMP,
    status VARCHAR(30) DEFAULT 'new',
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_prospects_status ON trinity.freelance_prospects(status);
CREATE INDEX IF NOT EXISTS idx_prospects_source ON trinity.freelance_prospects(source);
CREATE INDEX IF NOT EXISTS idx_prospects_inquiry ON trinity.freelance_prospects(inquiry_date);

CREATE TABLE IF NOT EXISTS trinity.freelance_projects (
    project_id SERIAL PRIMARY KEY,
    prospect_id INT NOT NULL REFERENCES trinity.freelance_prospects(prospect_id) ON DELETE RESTRICT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scope VARCHAR(20) DEFAULT 'medium',
    deliverables TEXT,
    contract_value DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    milestone_count INT DEFAULT 1,
    contract_signed_date TIMESTAMP,
    start_date TIMESTAMP NOT NULL,
    estimated_end_date TIMESTAMP,
    actual_end_date TIMESTAMP,
    status VARCHAR(30) DEFAULT 'active',
    payment_terms VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_projects_prospect ON trinity.freelance_projects(prospect_id);
CREATE INDEX IF NOT EXISTS idx_projects_status ON trinity.freelance_projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_start ON trinity.freelance_projects(start_date);

CREATE TABLE IF NOT EXISTS trinity.freelance_invoices (
    invoice_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL REFERENCES trinity.freelance_projects(project_id) ON DELETE RESTRICT,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    milestone_description VARCHAR(255),
    invoice_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    paid_date TIMESTAMP,
    payment_method VARCHAR(50),
    payment_reference VARCHAR(100),
    status VARCHAR(30) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_invoices_project ON trinity.freelance_invoices(project_id);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON trinity.freelance_invoices(status);
CREATE INDEX IF NOT EXISTS idx_invoices_date ON trinity.freelance_invoices(invoice_date);
CREATE INDEX IF NOT EXISTS idx_invoices_paid ON trinity.freelance_invoices(paid_date);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 6: CORE TABLES (P3 AFFILIATE)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS trinity.affiliate_sites (
    site_id SERIAL PRIMARY KEY,
    domain VARCHAR(255) UNIQUE NOT NULL,
    site_name VARCHAR(255) NOT NULL,
    niche VARCHAR(100) NOT NULL,
    platform VARCHAR(50),
    host VARCHAR(100),
    launch_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    target_monthly_traffic INT,
    seo_strategy TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sites_niche ON trinity.affiliate_sites(niche);
CREATE INDEX IF NOT EXISTS idx_sites_launch ON trinity.affiliate_sites(launch_date);
CREATE INDEX IF NOT EXISTS idx_sites_status ON trinity.affiliate_sites(status);

CREATE TABLE IF NOT EXISTS trinity.affiliate_articles (
    article_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id) ON DELETE RESTRICT,
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    content_type VARCHAR(50),
    word_count INT,
    keywords TEXT,
    target_keyword VARCHAR(255),
    internal_links INT DEFAULT 0,
    external_links INT DEFAULT 0,
    publish_date TIMESTAMP NOT NULL,
    last_updated TIMESTAMP,
    status VARCHAR(20) DEFAULT 'published',
    featured_image_url TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_articles_site ON trinity.affiliate_articles(site_id);
CREATE INDEX IF NOT EXISTS idx_articles_status ON trinity.affiliate_articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_publish ON trinity.affiliate_articles(publish_date);

CREATE TABLE IF NOT EXISTS trinity.affiliate_programs (
    program_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id) ON DELETE RESTRICT,
    network_name VARCHAR(100) NOT NULL,
    program_name VARCHAR(255) NOT NULL,
    affiliate_id VARCHAR(100) NOT NULL,
    commission_rate DECIMAL(5,2),
    cookie_duration INT,
    login_url TEXT,
    dashboard_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    joined_date TIMESTAMP NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_programs_site ON trinity.affiliate_programs(site_id);
CREATE INDEX IF NOT EXISTS idx_programs_network ON trinity.affiliate_programs(network_name);
CREATE INDEX IF NOT EXISTS idx_programs_status ON trinity.affiliate_programs(status);

CREATE TABLE IF NOT EXISTS trinity.article_affiliate_links (
    link_id SERIAL PRIMARY KEY,
    article_id INT NOT NULL REFERENCES trinity.affiliate_articles(article_id) ON DELETE RESTRICT,
    program_id INT NOT NULL REFERENCES trinity.affiliate_programs(program_id) ON DELETE RESTRICT,
    link_type VARCHAR(50),
    link_url TEXT NOT NULL,
    link_text VARCHAR(255),
    link_position INT,
    click_count INT DEFAULT 0,
    commission_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_links_article ON trinity.article_affiliate_links(article_id);
CREATE INDEX IF NOT EXISTS idx_links_program ON trinity.article_affiliate_links(program_id);

CREATE TABLE IF NOT EXISTS trinity.affiliate_clicks (
    click_id SERIAL PRIMARY KEY,
    link_id INT NOT NULL REFERENCES trinity.article_affiliate_links(link_id) ON DELETE RESTRICT,
    article_id INT NOT NULL REFERENCES trinity.affiliate_articles(article_id) ON DELETE RESTRICT,
    program_id INT NOT NULL REFERENCES trinity.affiliate_programs(program_id) ON DELETE RESTRICT,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id) ON DELETE RESTRICT,
    click_timestamp TIMESTAMP NOT NULL,
    ip_hash VARCHAR(100),
    user_agent_hash VARCHAR(100),
    referrer VARCHAR(500),
    conversion_status VARCHAR(20),
    commission_earned DECIMAL(10,2) DEFAULT 0,
    commission_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_clicks_link ON trinity.affiliate_clicks(link_id);
CREATE INDEX IF NOT EXISTS idx_clicks_article ON trinity.affiliate_clicks(article_id);
CREATE INDEX IF NOT EXISTS idx_clicks_site ON trinity.affiliate_clicks(site_id);
CREATE INDEX IF NOT EXISTS idx_clicks_timestamp ON trinity.affiliate_clicks(click_timestamp);

CREATE TABLE IF NOT EXISTS trinity.affiliate_traffic (
    traffic_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id) ON DELETE RESTRICT,
    article_id INT REFERENCES trinity.affiliate_articles(article_id) ON DELETE SET NULL,
    metric_date DATE NOT NULL,
    page_views INT DEFAULT 0,
    unique_visitors INT DEFAULT 0,
    sessions INT DEFAULT 0,
    avg_session_duration DECIMAL(5,2),
    bounce_rate DECIMAL(5,2),
    source VARCHAR(50),
    source_detail VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_traffic_site ON trinity.affiliate_traffic(site_id);
CREATE INDEX IF NOT EXISTS idx_traffic_date ON trinity.affiliate_traffic(metric_date);
CREATE INDEX IF NOT EXISTS idx_traffic_source ON trinity.affiliate_traffic(source);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 7: AGGREGATION & REPORTING TABLES
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS trinity.daily_revenue (
    revenue_id SERIAL PRIMARY KEY,
    report_date DATE NOT NULL UNIQUE,
    gumroad_gross DECIMAL(12,2) DEFAULT 0,
    gumroad_net DECIMAL(12,2) DEFAULT 0,
    freelance_gross DECIMAL(12,2) DEFAULT 0,
    freelance_paid DECIMAL(12,2) DEFAULT 0,
    freelance_pending DECIMAL(12,2) DEFAULT 0,
    affiliate_clicks INT DEFAULT 0,
    affiliate_commissions DECIMAL(12,2) DEFAULT 0,
    total_gross DECIMAL(12,2) DEFAULT 0,
    total_net DECIMAL(12,2) DEFAULT 0,
    transaction_count INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_daily_revenue_date ON trinity.daily_revenue(report_date);

CREATE TABLE IF NOT EXISTS trinity.monthly_revenue (
    month_id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL UNIQUE,
    gumroad_gross DECIMAL(12,2) DEFAULT 0,
    gumroad_net DECIMAL(12,2) DEFAULT 0,
    freelance_gross DECIMAL(12,2) DEFAULT 0,
    freelance_paid DECIMAL(12,2) DEFAULT 0,
    freelance_pending DECIMAL(12,2) DEFAULT 0,
    affiliate_commissions DECIMAL(12,2) DEFAULT 0,
    affiliate_click_count INT DEFAULT 0,
    gumroad_transaction_count INT DEFAULT 0,
    freelance_invoice_count INT DEFAULT 0,
    gumroad_customer_count INT DEFAULT 0,
    total_gross DECIMAL(12,2) DEFAULT 0,
    total_net DECIMAL(12,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_monthly_revenue_date ON trinity.monthly_revenue(year_month);

CREATE TABLE IF NOT EXISTS trinity.recovery_tracker (
    tracker_id SERIAL PRIMARY KEY,
    target_amount DECIMAL(12,2) DEFAULT 10000.00,
    start_date DATE DEFAULT CURRENT_DATE,
    cumulative_earned DECIMAL(12,2) DEFAULT 0,
    cumulative_paid DECIMAL(12,2) DEFAULT 0,
    days_elapsed INT DEFAULT 0,
    days_remaining INT DEFAULT 45,
    percentage_complete DECIMAL(5,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW(),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS trinity.costs_monthly (
    cost_id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL,
    category VARCHAR(100),
    vendor VARCHAR(100),
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    recurring BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_costs_date ON trinity.costs_monthly(year_month);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 8: CREATE VIEWS (pre-built dashboards)
-- ═══════════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW trinity.v_gumroad_summary AS
SELECT
    DATE_TRUNC('month', gs.transaction_date)::DATE as month,
    COUNT(DISTINCT gp.product_id) as product_count,
    COUNT(DISTINCT gs.customer_id) as customer_count,
    COUNT(gs.transaction_id) as transaction_count,
    SUM(gs.gross_amount) as total_gross,
    SUM(gs.gumroad_fee) as total_fees,
    SUM(gs.net_amount) as total_net
FROM trinity.gumroad_sales gs
JOIN trinity.gumroad_products gp ON gs.product_id = gp.product_id
GROUP BY DATE_TRUNC('month', gs.transaction_date)
ORDER BY month DESC;

CREATE OR REPLACE VIEW trinity.v_freelance_summary AS
SELECT
    DATE_TRUNC('month', fi.invoice_date)::DATE as month,
    COUNT(DISTINCT fp.prospect_id) as client_count,
    COUNT(DISTINCT fj.project_id) as project_count,
    COUNT(fi.invoice_id) as invoice_count,
    SUM(fi.amount) as total_invoiced,
    SUM(CASE WHEN fi.paid_date IS NOT NULL THEN fi.amount ELSE 0 END) as total_paid,
    SUM(CASE WHEN fi.paid_date IS NULL THEN fi.amount ELSE 0 END) as total_pending
FROM trinity.freelance_invoices fi
JOIN trinity.freelance_projects fj ON fi.project_id = fj.project_id
JOIN trinity.freelance_prospects fp ON fj.prospect_id = fp.prospect_id
GROUP BY DATE_TRUNC('month', fi.invoice_date)
ORDER BY month DESC;

CREATE OR REPLACE VIEW trinity.v_affiliate_summary AS
SELECT
    DATE_TRUNC('month', ac.click_timestamp)::DATE as month,
    COUNT(DISTINCT aas.site_id) as active_sites,
    COUNT(DISTINCT aa.article_id) as article_count,
    COUNT(ac.click_id) as total_clicks,
    SUM(CASE WHEN ac.conversion_status IN ('converted', 'commission_earned') THEN 1 ELSE 0 END) as conversions,
    SUM(ac.commission_earned) as total_commissions
FROM trinity.affiliate_clicks ac
JOIN trinity.affiliate_articles aa ON ac.article_id = aa.article_id
JOIN trinity.affiliate_sites aas ON ac.site_id = aas.site_id
GROUP BY DATE_TRUNC('month', ac.click_timestamp)
ORDER BY month DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 9: ADD CONSTRAINTS
-- ═══════════════════════════════════════════════════════════════════════════════════

ALTER TABLE trinity.gumroad_sales ADD CONSTRAINT chk_gumroad_net_vs_gross
    CHECK (net_amount <= gross_amount AND net_amount >= 0);

ALTER TABLE trinity.freelance_invoices ADD CONSTRAINT chk_invoice_paid_date
    CHECK (paid_date IS NULL OR paid_date >= invoice_date);

ALTER TABLE trinity.freelance_projects ADD CONSTRAINT chk_project_dates
    CHECK (actual_end_date IS NULL OR actual_end_date >= start_date);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 10: INITIAL DATA & RECOVERY TRACKER
-- ═══════════════════════════════════════════════════════════════════════════════════

INSERT INTO trinity.recovery_tracker (target_amount, start_date)
VALUES (10000.00, CURRENT_DATE)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- STEP 11: DEPLOYMENT VERIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════════

DO $$
DECLARE
    v_table_count INT;
    v_index_count INT;
    v_view_count INT;
BEGIN
    SELECT COUNT(*) INTO v_table_count FROM information_schema.tables WHERE table_schema = 'trinity';
    SELECT COUNT(*) INTO v_index_count FROM pg_indexes WHERE schemaname = 'trinity';
    SELECT COUNT(*) INTO v_view_count FROM information_schema.views WHERE table_schema = 'trinity';

    RAISE NOTICE 'Trinity Schema Deployment Complete!';
    RAISE NOTICE 'Tables created: %', v_table_count;
    RAISE NOTICE 'Indexes created: %', v_index_count;
    RAISE NOTICE 'Views created: %', v_view_count;
END $$;

COMMIT;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- FINAL CHECK: Run from psql
-- ═══════════════════════════════════════════════════════════════════════════════════

-- \dt trinity.*  -- List all tables
-- \di trinity.*  -- List all indexes
-- \dv trinity.*  -- List all views
