-- Initialize databases for MakinMoves services
CREATE DATABASE n8n;

-- Create schemas for different income stream projects
CREATE SCHEMA IF NOT EXISTS digital_products;
CREATE SCHEMA IF NOT EXISTS saas;
CREATE SCHEMA IF NOT EXISTS content;
CREATE SCHEMA IF NOT EXISTS trading;

-- ── Digital Products Tracking ─────────────────────────
CREATE TABLE digital_products.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL, -- ebook, template, course, printable
    platform VARCHAR(100),      -- gumroad, etsy, shopify, etc.
    price DECIMAL(10,2),
    cost DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'idea', -- idea, in-progress, published, archived
    url TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE digital_products.sales (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES digital_products.products(id),
    amount DECIMAL(10,2) NOT NULL,
    platform_fee DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2),
    sale_date TIMESTAMP DEFAULT NOW()
);

-- ── SaaS Projects ─────────────────────────────────────
CREATE TABLE saas.projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    tech_stack TEXT,
    monthly_cost DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'planning',
    url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE saas.subscribers (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES saas.projects(id),
    plan VARCHAR(50),
    mrr DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'active',
    started_at TIMESTAMP DEFAULT NOW()
);

-- ── Content / Affiliate ───────────────────────────────
CREATE TABLE content.sites (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    domain VARCHAR(255),
    niche VARCHAR(100),
    platform VARCHAR(50), -- wordpress, ghost, astro, etc.
    status VARCHAR(20) DEFAULT 'planning',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE content.articles (
    id SERIAL PRIMARY KEY,
    site_id INT REFERENCES content.sites(id),
    title VARCHAR(500) NOT NULL,
    slug VARCHAR(500),
    status VARCHAR(20) DEFAULT 'draft',
    target_keywords TEXT,
    affiliate_links TEXT,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE content.revenue (
    id SERIAL PRIMARY KEY,
    site_id INT REFERENCES content.sites(id),
    source VARCHAR(100), -- adsense, affiliate, sponsor
    amount DECIMAL(10,2),
    period_start DATE,
    period_end DATE,
    notes TEXT
);

-- ── Trading / Bots ────────────────────────────────────
CREATE TABLE trading.strategies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50), -- crypto, stocks, forex
    description TEXT,
    status VARCHAR(20) DEFAULT 'backtesting',
    risk_level VARCHAR(20) DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE trading.trades (
    id SERIAL PRIMARY KEY,
    strategy_id INT REFERENCES trading.strategies(id),
    symbol VARCHAR(20) NOT NULL,
    side VARCHAR(10) NOT NULL, -- buy, sell
    quantity DECIMAL(18,8),
    price DECIMAL(18,8),
    fee DECIMAL(10,4) DEFAULT 0,
    pnl DECIMAL(18,8),
    executed_at TIMESTAMP DEFAULT NOW()
);

-- ── Master Revenue Dashboard ──────────────────────────
CREATE TABLE public.revenue_summary (
    id SERIAL PRIMARY KEY,
    stream VARCHAR(50) NOT NULL, -- digital_products, saas, content, trading, other
    source VARCHAR(100),
    amount DECIMAL(10,2) NOT NULL,
    period DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ── Recovery Goal Tracker ─────────────────────────────
CREATE TABLE public.recovery_tracker (
    id SERIAL PRIMARY KEY,
    target_amount DECIMAL(10,2),
    recovered_amount DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
