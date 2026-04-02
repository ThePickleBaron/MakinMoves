-- ════════════════════════════════════════════════════════════════════════════════
-- TRINITY REVENUE TRACKING SCHEMA
-- Purpose: Production-ready PostgreSQL schema for P1 Gumroad + P2 Freelance + P3 Affiliate
-- Goal: Capture data from Day 1, support autonomous financial reporting
-- Date: 2026-03-29
-- Owner: CTMO
-- ════════════════════════════════════════════════════════════════════════════════

-- Create Trinity schema if not exists
CREATE SCHEMA IF NOT EXISTS trinity CASCADE;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- P1: GUMROAD DIGITAL PRODUCTS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Products catalog
CREATE TABLE trinity.gumroad_products (
    product_id SERIAL PRIMARY KEY,
    gumroad_id VARCHAR(100) UNIQUE,           -- Gumroad's internal ID (if available)
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),                    -- ebook, template, course, bundle, printable
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    launch_date TIMESTAMP,
    gumroad_url TEXT,
    thumbnail_url TEXT,
    status VARCHAR(20) DEFAULT 'active',      -- active, archived, paused
    tags TEXT,                                -- comma-separated
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_gumroad_products_status ON trinity.gumroad_products(status);
CREATE INDEX idx_gumroad_products_category ON trinity.gumroad_products(category);
CREATE INDEX idx_gumroad_products_launch_date ON trinity.gumroad_products(launch_date);

-- Customers (unique buyers)
CREATE TABLE trinity.gumroad_customers (
    customer_id SERIAL PRIMARY KEY,
    gumroad_customer_id VARCHAR(100) UNIQUE, -- Gumroad internal customer ID
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    first_purchase_date TIMESTAMP NOT NULL,
    lifetime_value DECIMAL(10,2) DEFAULT 0,
    purchase_count INT DEFAULT 0,
    last_purchase_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',     -- active, churn
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_gumroad_customers_email ON trinity.gumroad_customers(email);
CREATE INDEX idx_gumroad_customers_first_purchase ON trinity.gumroad_customers(first_purchase_date);

-- Sales transactions
CREATE TABLE trinity.gumroad_sales (
    transaction_id SERIAL PRIMARY KEY,
    gumroad_transaction_id VARCHAR(100) UNIQUE, -- Gumroad transaction ID
    product_id INT NOT NULL REFERENCES trinity.gumroad_products(product_id),
    customer_id INT NOT NULL REFERENCES trinity.gumroad_customers(customer_id),
    gross_amount DECIMAL(10,2) NOT NULL,
    gumroad_fee DECIMAL(10,2) NOT NULL,        -- Gumroad takes ~10%
    net_amount DECIMAL(10,2) NOT NULL,         -- Amount user receives
    currency VARCHAR(3) DEFAULT 'USD',
    license_key VARCHAR(100),                  -- If applicable
    is_gift BOOLEAN DEFAULT false,
    buyer_email VARCHAR(255),                  -- May differ from customer_email for gifts
    transaction_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_gumroad_sales_product ON trinity.gumroad_sales(product_id);
CREATE INDEX idx_gumroad_sales_customer ON trinity.gumroad_sales(customer_id);
CREATE INDEX idx_gumroad_sales_date ON trinity.gumroad_sales(transaction_date);
CREATE INDEX idx_gumroad_sales_amount ON trinity.gumroad_sales(net_amount);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- P2: FREELANCE / CONSULTING PROJECTS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Prospects and leads
CREATE TABLE trinity.freelance_prospects (
    prospect_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(255),
    website TEXT,
    source VARCHAR(100),                      -- platform, referral, cold, social, marketplace
    location VARCHAR(255),
    budget_estimate DECIMAL(10,2),
    inquiry_date TIMESTAMP NOT NULL,
    first_contact_date TIMESTAMP,
    status VARCHAR(30) DEFAULT 'new',         -- new, contacted, negotiating, qualified, won, lost, on-hold
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_prospects_status ON trinity.freelance_prospects(status);
CREATE INDEX idx_prospects_source ON trinity.freelance_prospects(source);
CREATE INDEX idx_prospects_inquiry_date ON trinity.freelance_prospects(inquiry_date);
CREATE INDEX idx_prospects_email ON trinity.freelance_prospects(email);

-- Projects
CREATE TABLE trinity.freelance_projects (
    project_id SERIAL PRIMARY KEY,
    prospect_id INT NOT NULL REFERENCES trinity.freelance_prospects(prospect_id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scope VARCHAR(20) DEFAULT 'medium',       -- small, medium, large
    deliverables TEXT,                        -- comma-separated list or detailed description
    contract_value DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    milestone_count INT DEFAULT 1,
    contract_signed_date TIMESTAMP,
    start_date TIMESTAMP NOT NULL,
    estimated_end_date TIMESTAMP,
    actual_end_date TIMESTAMP,
    status VARCHAR(30) DEFAULT 'active',      -- active, completed, paused, cancelled
    payment_terms VARCHAR(100),                -- Net 30, 50/50 split, etc.
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_projects_prospect ON trinity.freelance_projects(prospect_id);
CREATE INDEX idx_projects_status ON trinity.freelance_projects(status);
CREATE INDEX idx_projects_start_date ON trinity.freelance_projects(start_date);
CREATE INDEX idx_projects_value ON trinity.freelance_projects(contract_value);

-- Milestones/Invoices (tied to projects)
CREATE TABLE trinity.freelance_invoices (
    invoice_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL REFERENCES trinity.freelance_projects(project_id),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    milestone_description VARCHAR(255),
    invoice_date TIMESTAMP NOT NULL,
    due_date TIMESTAMP NOT NULL,
    paid_date TIMESTAMP,
    payment_method VARCHAR(50),                -- bank_transfer, paypal, stripe, cash, check
    payment_reference VARCHAR(100),            -- transaction ID or check number
    status VARCHAR(30) DEFAULT 'pending',     -- pending, partially_paid, paid, overdue, cancelled
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_invoices_project ON trinity.freelance_invoices(project_id);
CREATE INDEX idx_invoices_status ON trinity.freelance_invoices(status);
CREATE INDEX idx_invoices_invoice_date ON trinity.freelance_invoices(invoice_date);
CREATE INDEX idx_invoices_paid_date ON trinity.freelance_invoices(paid_date);
CREATE INDEX idx_invoices_amount ON trinity.freelance_invoices(amount);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- P3: AFFILIATE / CONTENT SITES
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Content sites (blogs, niche sites)
CREATE TABLE trinity.affiliate_sites (
    site_id SERIAL PRIMARY KEY,
    domain VARCHAR(255) UNIQUE NOT NULL,
    site_name VARCHAR(255) NOT NULL,
    niche VARCHAR(100) NOT NULL,              -- e.g., productivity, finance, health
    platform VARCHAR(50),                     -- wordpress, hugo, astro, ghost, custom
    host VARCHAR(100),                        -- namecheap, vercel, netlify, etc.
    launch_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active',      -- active, planning, paused, archived
    target_monthly_traffic INT,               -- Expected monthly visitors
    seo_strategy TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_affiliate_sites_niche ON trinity.affiliate_sites(niche);
CREATE INDEX idx_affiliate_sites_launch_date ON trinity.affiliate_sites(launch_date);
CREATE INDEX idx_affiliate_sites_status ON trinity.affiliate_sites(status);

-- Articles/Content pieces
CREATE TABLE trinity.affiliate_articles (
    article_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id),
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500) UNIQUE NOT NULL,
    content_type VARCHAR(50),                 -- blog_post, review, comparison, guide, roundup
    word_count INT,
    keywords TEXT,                            -- comma-separated primary and secondary keywords
    target_keyword VARCHAR(255),               -- Primary keyword targeting
    internal_links INT DEFAULT 0,
    external_links INT DEFAULT 0,
    publish_date TIMESTAMP NOT NULL,
    last_updated TIMESTAMP,
    status VARCHAR(20) DEFAULT 'published',   -- draft, published, scheduled, archived
    featured_image_url TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_articles_site ON trinity.affiliate_articles(site_id);
CREATE INDEX idx_articles_status ON trinity.affiliate_articles(status);
CREATE INDEX idx_articles_publish_date ON trinity.affiliate_articles(publish_date);
CREATE INDEX idx_articles_target_keyword ON trinity.affiliate_articles(target_keyword);

-- Affiliate networks/programs joined
CREATE TABLE trinity.affiliate_programs (
    program_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id),
    network_name VARCHAR(100) NOT NULL,       -- Amazon Associates, CJ Affiliate, Shareasale, etc.
    program_name VARCHAR(255) NOT NULL,       -- Specific program (e.g., Bluehost, ConvertKit)
    affiliate_id VARCHAR(100) NOT NULL,       -- User's affiliate ID in the network
    commission_rate DECIMAL(5,2),             -- e.g., 5.00 for 5%
    cookie_duration INT,                      -- Days (e.g., 30, 60, 90)
    login_url TEXT,
    dashboard_url TEXT,
    status VARCHAR(20) DEFAULT 'active',      -- active, pending_approval, rejected, inactive
    joined_date TIMESTAMP NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_affiliate_programs_site ON trinity.affiliate_programs(site_id);
CREATE INDEX idx_affiliate_programs_network ON trinity.affiliate_programs(network_name);
CREATE INDEX idx_affiliate_programs_status ON trinity.affiliate_programs(status);

-- Article-to-affiliate mappings (which articles promote which programs)
CREATE TABLE trinity.article_affiliate_links (
    link_id SERIAL PRIMARY KEY,
    article_id INT NOT NULL REFERENCES trinity.affiliate_articles(article_id),
    program_id INT NOT NULL REFERENCES trinity.affiliate_programs(program_id),
    link_type VARCHAR(50),                    -- primary, secondary, banner, cta
    link_url TEXT NOT NULL,                   -- The actual affiliate link
    link_text VARCHAR(255),
    link_position INT,                        -- Position in article (1=first, etc.)
    click_count INT DEFAULT 0,
    commission_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_article_links_article ON trinity.article_affiliate_links(article_id);
CREATE INDEX idx_article_links_program ON trinity.article_affiliate_links(program_id);

-- Clicks and conversions
CREATE TABLE trinity.affiliate_clicks (
    click_id SERIAL PRIMARY KEY,
    link_id INT NOT NULL REFERENCES trinity.article_affiliate_links(link_id),
    article_id INT NOT NULL REFERENCES trinity.affiliate_articles(article_id),
    program_id INT NOT NULL REFERENCES trinity.affiliate_programs(program_id),
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id),
    click_timestamp TIMESTAMP NOT NULL,
    ip_hash VARCHAR(100),                     -- Anonymized IP
    user_agent_hash VARCHAR(100),             -- Device/browser info (hashed)
    referrer VARCHAR(500),
    conversion_status VARCHAR(20),            -- click, converted, commission_earned, pending
    commission_earned DECIMAL(10,2) DEFAULT 0,
    commission_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_affiliate_clicks_link ON trinity.affiliate_clicks(link_id);
CREATE INDEX idx_affiliate_clicks_article ON trinity.affiliate_clicks(article_id);
CREATE INDEX idx_affiliate_clicks_program ON trinity.affiliate_clicks(program_id);
CREATE INDEX idx_affiliate_clicks_site ON trinity.affiliate_clicks(site_id);
CREATE INDEX idx_affiliate_clicks_timestamp ON trinity.affiliate_clicks(click_timestamp);
CREATE INDEX idx_affiliate_clicks_conversion ON trinity.affiliate_clicks(conversion_status);

-- Traffic metrics (daily/weekly rollup from analytics)
CREATE TABLE trinity.affiliate_traffic (
    traffic_id SERIAL PRIMARY KEY,
    site_id INT NOT NULL REFERENCES trinity.affiliate_sites(site_id),
    article_id INT REFERENCES trinity.affiliate_articles(article_id),
    metric_date DATE NOT NULL,
    page_views INT DEFAULT 0,
    unique_visitors INT DEFAULT 0,
    sessions INT DEFAULT 0,
    avg_session_duration DECIMAL(5,2),       -- Seconds
    bounce_rate DECIMAL(5,2),                 -- Percentage
    source VARCHAR(50),                       -- organic, referral, direct, paid, social
    source_detail VARCHAR(255),               -- google, twitter, etc.
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_traffic_site ON trinity.affiliate_traffic(site_id);
CREATE INDEX idx_traffic_article ON trinity.affiliate_traffic(article_id);
CREATE INDEX idx_traffic_date ON trinity.affiliate_traffic(metric_date);
CREATE INDEX idx_traffic_source ON trinity.affiliate_traffic(source);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- CROSS-STREAM: UNIFIED FINANCIAL REPORTING
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Daily consolidated revenue (automated aggregation from all streams)
CREATE TABLE trinity.daily_revenue (
    revenue_id SERIAL PRIMARY KEY,
    report_date DATE NOT NULL UNIQUE,
    gumroad_gross DECIMAL(12,2) DEFAULT 0,
    gumroad_net DECIMAL(12,2) DEFAULT 0,
    freelance_gross DECIMAL(12,2) DEFAULT 0,   -- Invoiced amount
    freelance_paid DECIMAL(12,2) DEFAULT 0,    -- Actually received
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

CREATE INDEX idx_daily_revenue_date ON trinity.daily_revenue(report_date);

-- Monthly aggregation
CREATE TABLE trinity.monthly_revenue (
    month_id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL UNIQUE,           -- First day of month
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

CREATE INDEX idx_monthly_revenue_date ON trinity.monthly_revenue(year_month);

-- Stream-specific monthly metrics
CREATE TABLE trinity.stream_metrics (
    metric_id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL,
    stream VARCHAR(50) NOT NULL,               -- gumroad, freelance, affiliate
    metric_name VARCHAR(100),                  -- e.g., "avg_product_price", "customer_count"
    metric_value DECIMAL(12,4),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_stream_metrics_date ON trinity.stream_metrics(year_month);
CREATE INDEX idx_stream_metrics_stream ON trinity.stream_metrics(stream);

-- Recovery goal tracking (target: $10,000)
CREATE TABLE trinity.recovery_tracker (
    tracker_id SERIAL PRIMARY KEY,
    target_amount DECIMAL(12,2) DEFAULT 10000.00,
    start_date DATE DEFAULT CURRENT_DATE,
    cumulative_earned DECIMAL(12,2) DEFAULT 0,
    cumulative_paid DECIMAL(12,2) DEFAULT 0,   -- Actual funds received
    days_elapsed INT DEFAULT 0,
    days_remaining INT DEFAULT 45,
    percentage_complete DECIMAL(5,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW(),
    notes TEXT
);

-- Infrastructure costs (for net revenue calculations)
CREATE TABLE trinity.costs_monthly (
    cost_id SERIAL PRIMARY KEY,
    year_month DATE NOT NULL,
    category VARCHAR(100),                    -- hosting, domain, tools, payment_processing
    vendor VARCHAR(100),
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    recurring BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_costs_date ON trinity.costs_monthly(year_month);
CREATE INDEX idx_costs_category ON trinity.costs_monthly(category);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- OPERATIONAL & AUDIT
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Data sync logs (for n8n automation auditing)
CREATE TABLE trinity.data_sync_log (
    sync_id SERIAL PRIMARY KEY,
    sync_type VARCHAR(50),                    -- gumroad_sales, freelance_invoices, affiliate_commissions
    status VARCHAR(20),                       -- success, failed, partial
    records_synced INT DEFAULT 0,
    sync_start_time TIMESTAMP,
    sync_end_time TIMESTAMP,
    error_message TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sync_log_type ON trinity.data_sync_log(sync_type);
CREATE INDEX idx_sync_log_status ON trinity.data_sync_log(status);

-- Data quality checks
CREATE TABLE trinity.audit_log (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(20),                    -- INSERT, UPDATE, DELETE, CHECK
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    audit_timestamp TIMESTAMP DEFAULT NOW(),
    notes TEXT
);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- HELPER VIEWS (Pre-built dashboards)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- P1: Gumroad performance
CREATE OR REPLACE VIEW trinity.v_gumroad_summary AS
SELECT
    DATE_TRUNC('month', gs.transaction_date)::DATE as month,
    COUNT(DISTINCT gp.product_id) as product_count,
    COUNT(DISTINCT gs.customer_id) as customer_count,
    COUNT(gs.transaction_id) as transaction_count,
    SUM(gs.gross_amount) as total_gross,
    SUM(gs.gumroad_fee) as total_fees,
    SUM(gs.net_amount) as total_net,
    ROUND(AVG(gs.net_amount)::NUMERIC, 2) as avg_transaction_value
FROM trinity.gumroad_sales gs
JOIN trinity.gumroad_products gp ON gs.product_id = gp.product_id
GROUP BY DATE_TRUNC('month', gs.transaction_date)
ORDER BY month DESC;

-- P2: Freelance revenue
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

-- P3: Affiliate commission tracking
CREATE OR REPLACE VIEW trinity.v_affiliate_summary AS
SELECT
    DATE_TRUNC('month', ac.click_timestamp)::DATE as month,
    COUNT(DISTINCT aas.site_id) as active_sites,
    COUNT(DISTINCT aa.article_id) as article_count,
    COUNT(DISTINCT ap.program_id) as program_count,
    COUNT(ac.click_id) as total_clicks,
    SUM(CASE WHEN ac.conversion_status IN ('converted', 'commission_earned') THEN 1 ELSE 0 END) as conversions,
    SUM(ac.commission_earned) as total_commissions
FROM trinity.affiliate_clicks ac
JOIN trinity.affiliate_articles aa ON ac.article_id = aa.article_id
JOIN trinity.affiliate_sites aas ON ac.site_id = aas.site_id
JOIN trinity.affiliate_programs ap ON ac.program_id = ap.program_id
GROUP BY DATE_TRUNC('month', ac.click_timestamp)
ORDER BY month DESC;

-- Combined daily revenue view
CREATE OR REPLACE VIEW trinity.v_daily_summary AS
SELECT
    COALESCE(dr.report_date, CURRENT_DATE) as date,
    COALESCE(dr.gumroad_net, 0) as gumroad_net,
    COALESCE(dr.freelance_paid, 0) as freelance_paid,
    COALESCE(dr.affiliate_commissions, 0) as affiliate_commissions,
    COALESCE(dr.gumroad_net, 0) + COALESCE(dr.freelance_paid, 0) + COALESCE(dr.affiliate_commissions, 0) as total_daily_net
FROM trinity.daily_revenue dr
ORDER BY dr.report_date DESC LIMIT 90;

-- Customer lifetime value (Gumroad)
CREATE OR REPLACE VIEW trinity.v_customer_ltv AS
SELECT
    gc.customer_id,
    gc.email,
    gc.first_name,
    gc.last_name,
    gc.first_purchase_date,
    gc.purchase_count,
    gc.lifetime_value,
    ROUND((gc.lifetime_value / GREATEST(EXTRACT(EPOCH FROM (NOW() - gc.first_purchase_date)) / 86400, 1))::NUMERIC, 4) as daily_ltv,
    DATEDIFF('day', gc.first_purchase_date, NOW()) as customer_age_days
FROM trinity.gumroad_customers gc
ORDER BY gc.lifetime_value DESC;

-- ═══════════════════════════════════════════════════════════════════════════════════
-- CONSTRAINTS & TRIGGERS
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Constraint: Net amount cannot exceed gross amount
ALTER TABLE trinity.gumroad_sales ADD CONSTRAINT chk_gumroad_net_vs_gross
    CHECK (net_amount <= gross_amount AND net_amount >= 0);

-- Constraint: Invoice paid date cannot be before invoice date
ALTER TABLE trinity.freelance_invoices ADD CONSTRAINT chk_invoice_paid_date
    CHECK (paid_date IS NULL OR paid_date >= invoice_date);

-- Constraint: Project end date cannot be before start date
ALTER TABLE trinity.freelance_projects ADD CONSTRAINT chk_project_dates
    CHECK (actual_end_date IS NULL OR actual_end_date >= start_date);

-- ═══════════════════════════════════════════════════════════════════════════════════
-- SAMPLE SEED DATA (for testing)
-- ═══════════════════════════════════════════════════════════════════════════════════

-- Seed Gumroad products
INSERT INTO trinity.gumroad_products (name, category, price, launch_date, gumroad_url, status)
VALUES
    ('Productivity Template Bundle', 'template', 29.99, NOW() - INTERVAL '10 days', 'https://gumroad.com/l/prod1', 'active'),
    ('Freelance Proposal Kit', 'template', 39.99, NOW() - INTERVAL '5 days', 'https://gumroad.com/l/prod2', 'active'),
    ('Content Creator Course', 'course', 99.99, NOW() - INTERVAL '1 day', 'https://gumroad.com/l/prod3', 'active')
ON CONFLICT DO NOTHING;

-- Seed customers
INSERT INTO trinity.gumroad_customers (email, first_name, last_name, first_purchase_date, status)
VALUES
    ('customer1@example.com', 'John', 'Doe', NOW() - INTERVAL '8 days', 'active'),
    ('customer2@example.com', 'Jane', 'Smith', NOW() - INTERVAL '3 days', 'active'),
    ('customer3@example.com', 'Bob', 'Johnson', NOW() - INTERVAL '1 day', 'active')
ON CONFLICT (email) DO NOTHING;

-- Seed sales
INSERT INTO trinity.gumroad_sales (product_id, customer_id, gross_amount, gumroad_fee, net_amount, transaction_date)
VALUES
    (1, 1, 29.99, 3.00, 26.99, NOW() - INTERVAL '8 days'),
    (2, 2, 39.99, 4.00, 35.99, NOW() - INTERVAL '3 days'),
    (3, 3, 99.99, 10.00, 89.99, NOW() - INTERVAL '1 day')
ON CONFLICT DO NOTHING;

-- Initialize recovery tracker
INSERT INTO trinity.recovery_tracker (target_amount, start_date)
VALUES (10000.00, CURRENT_DATE)
ON CONFLICT DO NOTHING;

COMMIT;
