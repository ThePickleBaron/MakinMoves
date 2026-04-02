# Open-Source Stack Component Specification
## Technical Implementation Details for Each Layer

**Date:** 2026-03-29
**From:** CTMO
**Purpose:** Detailed technical spec for Phase 1 (Lean) + Phase 2 (Standard) deployment
**Audience:** CTMO, DevOps, Future maintainers

---

## 1. Hosting & Containerization

### 1.1 Docker Compose Configuration (Phase 1)

**File:** `docker-compose.yml` (current, validated)

```yaml
version: '3.8'

services:
  # PostgreSQL (Primary Database)
  postgres:
    image: postgres:16-alpine
    container_name: mm-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: makinmoves
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-changeme123}
      POSTGRES_DB: makinmoves
    ports:
      - "5432:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data
      - ./docker/init-db.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U makinmoves"]
      interval: 10s
      timeout: 5s
      retries: 5

  # n8n (Workflow Automation Engine)
  n8n:
    image: n8nio/n8n:latest
    container_name: mm-n8n
    restart: unless-stopped
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_USER:-admin}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD:-changeme123}
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=makinmoves
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD:-changeme123}
      - N8N_PORT=5678
      - WEBHOOK_URL=http://localhost:5678/
    ports:
      - "5678:5678"
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy

  # Redis (Caching & Queues)
  redis:
    image: redis:7-alpine
    container_name: mm-redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru

  # Selenium (Web Scraping)
  selenium:
    image: selenium/standalone-chromium:latest
    container_name: mm-selenium
    restart: unless-stopped
    ports:
      - "4444:4444"
      - "7900:7900"  # noVNC viewer
    shm_size: "2gb"
    environment:
      - SE_NODE_MAX_SESSIONS=3
      - SE_VNC_NO_PASSWORD=1

  # WordPress (Content Publishing)
  wordpress:
    image: wordpress:6.4-apache
    container_name: mm-wordpress
    restart: unless-stopped
    environment:
      WORDPRESS_DB_HOST: postgres:5432
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: makinmoves
      WORDPRESS_DB_PASSWORD: ${POSTGRES_PASSWORD:-changeme123}
    ports:
      - "8080:80"
    volumes:
      - wp_content:/var/www/html/wp-content
      - ./docker/wordpress-config.php:/var/www/html/wp-config-extra.php
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  pg_data:
  n8n_data:
  redis_data:
  wp_content:
```

**Quick start:**
```bash
# Copy .env template
cp .env.example .env

# Edit .env with your secrets
nano .env

# Start all services
docker compose up -d

# Verify health
docker compose ps
docker compose logs postgres | head -20
docker compose logs n8n | tail -20

# Access services
# n8n: http://localhost:5678
# WordPress: http://localhost:8080
# PostgreSQL: localhost:5432
```

### 1.2 Deployment Scripts

**Script: `scripts/backup.sh` (Daily backup to GitHub)**

```bash
#!/bin/bash
# Automated PostgreSQL backup to GitHub releases
# Run via cron: 0 2 * * * /path/to/backup.sh

set -e

BACKUP_DIR="/tmp/mm-backups"
DB_NAME="makinmoves"
DB_USER="makinmoves"
REPO_OWNER="user"
REPO_NAME="makinmoves-backups"
BACKUP_DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/backup_$BACKUP_DATE.sql.gz"

# Create backup
mkdir -p "$BACKUP_DIR"
pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Upload to GitHub (requires gh CLI + auth)
if command -v gh &> /dev/null; then
  gh release create "backup-$BACKUP_DATE" \
    "$BACKUP_FILE" \
    --repo "$REPO_OWNER/$REPO_NAME" \
    --title "PostgreSQL Backup - $BACKUP_DATE" \
    --notes "Automated backup from n8n monitoring" \
    2>/dev/null || echo "Release already exists"
fi

# Cleanup old backups (keep last 7 days)
find "$BACKUP_DIR" -name "backup_*.sql.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_FILE"
```

**Script: `scripts/restore.sh` (Recovery from backup)**

```bash
#!/bin/bash
# Restore database from GitHub backup
# Usage: ./scripts/restore.sh backup_2026-03-29.sql.gz

BACKUP_FILE="${1:-}"
if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 <backup_file>"
  exit 1
fi

DB_NAME="makinmoves"
DB_USER="makinmoves"

echo "Restoring from $BACKUP_FILE..."
gunzip < "$BACKUP_FILE" | psql -U "$DB_USER" -d "$DB_NAME"
echo "Restore completed"
```

---

## 2. Database Layer

### 2.1 PostgreSQL Schema

**File:** `docker/init-db.sql`

```sql
-- ========================================
-- TRINITY MAKINMOVES DATABASE SCHEMA
-- PostgreSQL 16+
-- ========================================

-- Create n8n database (if not exists)
CREATE DATABASE IF NOT EXISTS n8n;

-- ========================================
-- P1: DIGITAL PRODUCTS
-- ========================================

CREATE TABLE IF NOT EXISTS digital_products (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL,
  description TEXT,
  platform VARCHAR(50) NOT NULL, -- 'gumroad', 'etsy', 'redbubble', 'printful'
  platform_id VARCHAR(255) UNIQUE, -- External platform ID
  price DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',
  status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'published', 'archived'
  sales_count INT DEFAULT 0,
  revenue DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  published_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS digital_product_sales (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES digital_products(id) ON DELETE CASCADE,
  platform VARCHAR(50),
  platform_transaction_id VARCHAR(255) UNIQUE,
  amount DECIMAL(10,2),
  currency VARCHAR(3),
  buyer_email VARCHAR(255),
  sale_date TIMESTAMP,
  captured_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_product_sales_date ON digital_product_sales(sale_date);
CREATE INDEX idx_product_sales_platform ON digital_product_sales(platform);

-- ========================================
-- P2: FREELANCE WRITING / AFFILIATE CONTENT
-- ========================================

CREATE TABLE IF NOT EXISTS affiliate_content (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE,
  content TEXT, -- Full article markdown
  platform VARCHAR(50) NOT NULL, -- 'medium', 'wordpress', 'hashnode', 'dev.to'
  platform_id VARCHAR(255), -- External article ID
  status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'published', 'archived'
  seo_keywords VARCHAR(500), -- Comma-separated keywords
  word_count INT,
  published_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  author_id INT
);

CREATE TABLE IF NOT EXISTS affiliate_links (
  id SERIAL PRIMARY KEY,
  content_id INT REFERENCES affiliate_content(id) ON DELETE CASCADE,
  program VARCHAR(50), -- 'amazon', 'gumroad', 'clickbank', 'custom'
  program_url VARCHAR(500),
  link_text VARCHAR(255),
  position INT, -- Position in article (1st, 2nd, etc)
  clicks INT DEFAULT 0,
  revenue DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS affiliate_clicks (
  id SERIAL PRIMARY KEY,
  link_id INT REFERENCES affiliate_links(id) ON DELETE CASCADE,
  click_date TIMESTAMP DEFAULT NOW(),
  referrer_url VARCHAR(500),
  user_agent VARCHAR(500)
);

CREATE INDEX idx_affiliate_clicks_date ON affiliate_clicks(click_date);
CREATE INDEX idx_affiliate_content_status ON affiliate_content(status);
CREATE INDEX idx_affiliate_content_platform ON affiliate_content(platform);

-- ========================================
-- REVENUE SUMMARY (CFO TRACKING)
-- ========================================

CREATE TABLE IF NOT EXISTS revenue_summary (
  id SERIAL PRIMARY KEY,
  date DATE NOT NULL,
  stream VARCHAR(50) NOT NULL, -- 'digital_products', 'affiliate', 'medium_partner', 'pod'
  platform VARCHAR(50), -- 'gumroad', 'medium', 'etsy', 'amazon', etc
  transaction_count INT DEFAULT 0,
  total_revenue DECIMAL(15,2) DEFAULT 0,
  currency VARCHAR(3) DEFAULT 'USD',
  captured_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_revenue_date ON revenue_summary(date);
CREATE INDEX idx_revenue_stream ON revenue_summary(stream);

-- ========================================
-- CONTENT QUEUE (n8n PUBLISHING PIPELINE)
-- ========================================

CREATE TABLE IF NOT EXISTS content_queue (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(50) NOT NULL, -- 'digital_product', 'affiliate_article', 'pod_design'
  title VARCHAR(255),
  description TEXT,
  metadata JSONB, -- Format-specific data
  status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'approved', 'published', 'failed'
  approved_by VARCHAR(255),
  approved_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  published_at TIMESTAMP,
  platform VARCHAR(50)
);

CREATE INDEX idx_queue_status ON content_queue(status);
CREATE INDEX idx_queue_type ON content_queue(content_type);

-- ========================================
-- PUBLISHING LOG (n8n OPERATIONS)
-- ========================================

CREATE TABLE IF NOT EXISTS publishing_log (
  id SERIAL PRIMARY KEY,
  content_id INT REFERENCES content_queue(id) ON DELETE SET NULL,
  platform VARCHAR(50),
  platform_response JSONB, -- Full API response
  status VARCHAR(50), -- 'success', 'failed', 'retry'
  error_message TEXT,
  attempt_number INT DEFAULT 1,
  published_url VARCHAR(500),
  published_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_publish_status ON publishing_log(status);
CREATE INDEX idx_publish_date ON publishing_log(published_at);

-- ========================================
-- ERROR LOGS (MONITORING & ALERTS)
-- ========================================

CREATE TABLE IF NOT EXISTS error_logs (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100),
  error_type VARCHAR(100),
  error_message TEXT,
  context JSONB, -- What was happening
  severity VARCHAR(50), -- 'info', 'warning', 'critical'
  resolved BOOLEAN DEFAULT FALSE,
  logged_at TIMESTAMP DEFAULT NOW(),
  resolved_at TIMESTAMP
);

CREATE INDEX idx_errors_severity ON error_logs(severity);
CREATE INDEX idx_errors_workflow ON error_logs(workflow_name);
CREATE INDEX idx_errors_unresolved ON error_logs(resolved);

-- ========================================
-- CFO FINANCIAL VIEWS
-- ========================================

-- Daily revenue snapshot
CREATE OR REPLACE VIEW revenue_daily AS
SELECT
  date,
  stream,
  SUM(total_revenue) as daily_total,
  SUM(transaction_count) as transaction_count,
  currency
FROM revenue_summary
GROUP BY date, stream, currency
ORDER BY date DESC;

-- Weekly revenue summary
CREATE OR REPLACE VIEW revenue_weekly AS
SELECT
  DATE_TRUNC('week', date) as week,
  stream,
  SUM(total_revenue) as weekly_total,
  COUNT(DISTINCT date) as days_active,
  currency
FROM revenue_summary
GROUP BY week, stream, currency
ORDER BY week DESC;

-- Cumulative recovery tracker
CREATE OR REPLACE VIEW recovery_tracker AS
SELECT
  DATE_TRUNC('day', captured_at) as day,
  SUM(total_revenue) OVER (ORDER BY DATE_TRUNC('day', captured_at)) as cumulative_revenue,
  SUM(total_revenue) as daily_revenue
FROM revenue_summary
GROUP BY DATE_TRUNC('day', captured_at)
ORDER BY day DESC;

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- Function: Get today's revenue
CREATE OR REPLACE FUNCTION get_todays_revenue()
RETURNS TABLE(stream VARCHAR, platform VARCHAR, total DECIMAL) AS $$
SELECT stream, platform, SUM(total_revenue) as total
FROM revenue_summary
WHERE date = CURRENT_DATE
GROUP BY stream, platform;
$$ LANGUAGE SQL;

-- Function: Get recovery progress
CREATE OR REPLACE FUNCTION get_recovery_progress()
RETURNS TABLE(total_recovered DECIMAL, goal DECIMAL, percentage NUMERIC) AS $$
SELECT
  COALESCE(SUM(total_revenue), 0) as total_recovered,
  10000.00 as goal, -- $10,000 recovery target
  ROUND((COALESCE(SUM(total_revenue), 0) / 10000.00 * 100)::NUMERIC, 2) as percentage
FROM revenue_summary;
$$ LANGUAGE SQL;

-- Function: Get error statistics
CREATE OR REPLACE FUNCTION get_error_stats()
RETURNS TABLE(severity VARCHAR, count BIGINT, unresolved BIGINT) AS $$
SELECT
  severity,
  COUNT(*) as count,
  COUNT(*) FILTER (WHERE resolved = FALSE) as unresolved
FROM error_logs
WHERE logged_at >= NOW() - INTERVAL '7 days'
GROUP BY severity;
$$ LANGUAGE SQL;

-- ========================================
-- GRANTS (n8n user)
-- ========================================

GRANT USAGE ON SCHEMA public TO makinmoves;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO makinmoves;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO makinmoves;

-- ========================================
-- END OF SCHEMA
-- ========================================
```

### 2.2 PostgreSQL Maintenance

**Health check query:**
```sql
-- Check database size
SELECT
  pg_size_pretty(pg_database_size('makinmoves')) as database_size,
  (SELECT COUNT(*) FROM digital_products) as product_count,
  (SELECT COUNT(*) FROM affiliate_content) as article_count,
  (SELECT COUNT(*) FROM digital_product_sales) as sales_count;

-- Check table sizes
SELECT schemaname, tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check for bloat
SELECT schemaname, tablename,
  ROUND(100 - ROUND(OTTA * CURRENT_SETTING('block_size')::NUMERIC / NATURAL_HEIGHT * 100) / 3, 2) AS table_waste_ratio
FROM pgstattuple_approx(schemaname||'.'||tablename)
WHERE waste_ratio > 10;
```

---

## 3. Automation Layer (n8n)

### 3.1 Workflow 1: Revenue Capture (Hourly)

**Trigger:** Cron (every hour at :00)

**Flow:**
```
Cron (hourly)
  ↓
Loop through platforms [Gumroad, Etsy, Medium]
  ↓
For each platform:
  - Query API (last hour's sales)
  - Parse response → revenue amount, transaction ID, timestamp
  - Check if transaction already in PostgreSQL (prevent duplicates)
  ↓
Insert into digital_product_sales / revenue_summary
  ↓
If any API error:
  - Log to error_logs (severity: warning)
  - Attempt retry (exponential backoff)
  ↓
Send success summary to CFO (daily digest at 8am)
```

**n8n Nodes:**
```
1. Cron Trigger
   - Expression: "0 * * * *" (hourly)

2. Set Variables
   - platforms = ["gumroad", "etsy", "medium"]
   - api_keys = load from .env

3. Loop through platforms
   4a. Gumroad HTTP Request
       - Method: GET
       - URL: https://api.gumroad.com/v2/sales?access_token={{api_key}}
       - Query: after={{last_check_timestamp}}
       - Response: Parse JSON → sales[]

   4b. PostgreSQL Insert
       - For each sale: INSERT into digital_product_sales
       - Fields: product_id, platform, platform_transaction_id, amount, sale_date

   4c. Error Handler (if HTTP fails)
       - Log to error_logs table
       - Set severity="warning"
       - Attempt retry after 5 min

5. Aggregate Revenue
   - SELECT SUM(amount) FROM digital_product_sales WHERE sale_date > NOW() - INTERVAL '1 hour'
   - INSERT into revenue_summary

6. Conditional: If errors occurred
   - Send alert email to CFO (severity >= 'warning')
```

**Error handling:**
```sql
-- Avoid duplicate transactions
INSERT INTO digital_product_sales (...)
SELECT ... FROM staging_table
ON CONFLICT (platform_transaction_id) DO NOTHING;
```

### 3.2 Workflow 2: Content Generation (Daily 6:00 AM)

**Trigger:** Cron (daily at 06:00 UTC)

**Flow:**
```
Cron (06:00)
  ↓
Generate 1 Digital Product (Claude API)
  - Template: product name, description, pricing
  - Insert into content_queue (status: pending)
  ↓
Generate 1 Affiliate Article (Claude API)
  - Template: topic, outline, SEO keywords, affiliate links
  - Insert into content_queue (status: pending)
  ↓
Generate 1 Print-on-Demand Design (Claude API)
  - Template: niche, color, size specs
  - Insert into content_queue with metadata (status: pending)
  ↓
Send COO notification (what was generated, waiting for approval)
```

**n8n Nodes:**
```
1. Cron Trigger
   - Expression: "0 6 * * *" (daily at 6am)

2. Call Claude API (Digital Product)
   - Model: claude-opus
   - Prompt: templates/digital_product_prompt.txt
   - Parse response: {{$json.content}}

3. PostgreSQL Insert (content_queue)
   - Table: content_queue
   - Fields: content_type='digital_product', title, description, metadata, status='pending'

4. Call Claude API (Affiliate Article)
   - Prompt: templates/affiliate_article_prompt.txt
   - Parse response: extract title, content, keywords, affiliate_links

5. PostgreSQL Insert (content_queue)
   - Fields: content_type='affiliate_article', title, description, metadata

6. Call Claude API (PoD Design)
   - Prompt: templates/pod_design_prompt.txt
   - Parse response: design_description, color_palette, dimensions

7. PostgreSQL Insert (content_queue)
   - Fields: content_type='pod_design', title, metadata

8. Send Email (COO notification)
   - To: coo@makinmoves.local (or file-based notification)
   - Subject: "3 new content items generated - awaiting approval"
   - Body: List of generated items with metadata
```

**Claude API integration:**
```bash
# Requires: CLAUDE_API_KEY in .env

# Digital product prompt template
templates/digital_product_prompt.txt:
---
You are a digital product strategist. Generate a single sellable digital product
for indie entrepreneurs. Return JSON:
{
  "product_name": "...",
  "description": "...",
  "price": 29,
  "target_audience": "..."
}
---

# Affiliate article prompt template
templates/affiliate_article_prompt.txt:
---
You are an SEO content writer specializing in product reviews. Write a 1000-word
affiliate article in markdown format. Include 3 affiliate links naturally.
Return JSON:
{
  "title": "...",
  "content": "...",
  "seo_keywords": ["keyword1", "keyword2"],
  "affiliate_links": [
    {"program": "amazon", "url": "...", "anchor_text": "..."}
  ]
}
---
```

### 3.3 Workflow 3: Automated Publishing (Daily 9:00 AM)

**Trigger:** Cron (daily at 09:00 UTC)

**Flow:**
```
Cron (09:00)
  ↓
Query content_queue WHERE status = 'approved' AND published_at IS NULL
  ↓
For each approved content:
  - If content_type = 'digital_product':
      → Call Gumroad API: POST /products
  - If content_type = 'affiliate_article':
      → Call WordPress REST API: POST /wp-json/wp/v2/posts
  - If content_type = 'pod_design':
      → Call Redbubble API or Printful API
  ↓
Update content_queue: status = 'published', published_at = NOW()
  ↓
Log to publishing_log (success or error)
  ↓
If any failures: Set severity = 'critical', alert CFO
```

**n8n Nodes:**
```
1. Cron Trigger
   - Expression: "0 9 * * *" (daily at 9am)

2. PostgreSQL Query
   - SELECT * FROM content_queue
   - WHERE status = 'approved' AND published_at IS NULL
   - Result: content_items[]

3. Loop through content_items
   4a. Switch (content_type)
       - Case 'digital_product': → Gumroad publishing
       - Case 'affiliate_article': → WordPress publishing
       - Case 'pod_design': → Redbubble publishing

   4b. Gumroad HTTP Request (POST)
       - URL: https://api.gumroad.com/v2/products
       - Headers: Authorization: Bearer {{gumroad_token}}
       - Body: {
           "name": "{{item.title}}",
           "description": "{{item.description}}",
           "price": "{{item.metadata.price}}"
         }
       - Response: {{$json.product.id}} → store as platform_id

   4c. WordPress HTTP Request (POST)
       - URL: http://localhost:8080/wp-json/wp/v2/posts
       - Headers: Authorization: Bearer {{wp_token}}
       - Body: {
           "title": "{{item.title}}",
           "content": "{{item.description}}",
           "status": "publish"
         }

   4d. Redbubble HTTP Request (if API available)
       - URL: https://api.redbubble.com/v1/designs
       - Headers: Authorization: Bearer {{redbubble_token}}
       - Body: Multipart (image + metadata)

5. Update content_queue
   - UPDATE content_queue
   - SET status='published', published_at=NOW()
   - WHERE id = {{item.id}}

6. Log to publishing_log
   - INSERT publishing_log (content_id, platform, status, published_url, published_at)

7. Error handler
   - If HTTP status != 200:
     - Log to error_logs (severity='critical')
     - INSERT publishing_log (status='failed', error_message)
     - Send alert email
```

### 3.4 Workflow 4: Error Monitoring (Real-time)

**Trigger:** On all workflow errors (error handler nodes in workflows 1–3)

**Flow:**
```
Any error in n8n workflow
  ↓
Error handler catches exception
  ↓
Insert into error_logs (severity, message, context)
  ↓
If severity = 'critical':
  - Send immediate email alert to CFO
  - Page escalation (optional: webhook to Slack, etc)
  ↓
If severity = 'warning':
  - Log to database, summarize daily
  ↓
If severity = 'info':
  - Log only, no alert
```

**n8n Error Handler Nodes:**
```
1. HTTP Error Catcher (all HTTP nodes)
   - On error: Continue
   - Pass to error handler node

2. Error Handler Node
   - Log: {
       "workflow_name": "{{$workflow.name}}",
       "error_type": "HTTP_ERROR",
       "error_message": "{{$error.message}}",
       "status_code": "{{$response.statusCode}}",
       "retry_count": "{{retry_attempt}}",
       "context": {
         "timestamp": "{{$now}}",
         "url": "{{$node['HTTP Request'].data.url}}",
         "method": "{{$node['HTTP Request'].data.method}}"
       }
     }

3. PostgreSQL Insert (error_logs)
   - INSERT into error_logs (workflow_name, error_type, error_message, context, severity)

4. Conditional: If severity >= 'critical'
   - Send Email Alert to CFO
   - Subject: "[CRITICAL] {{workflow_name}} failed"
   - Body: Error message + retry instruction
```

---

## 4. CMS / Content Layer (WordPress)

### 4.1 WordPress Installation via Docker

**Build image with plugins:**

```dockerfile
# Dockerfile.wordpress
FROM wordpress:6.4-apache

# Install WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Install required plugins
RUN wp plugin install yoast-seo --allow-root
RUN wp plugin install thirstyaffiliates --allow-root
RUN wp plugin install mailchimp-for-wordpress --allow-root
RUN wp plugin install wp-mail-smtp --allow-root
RUN wp plugin install elementor --allow-root

# Activate plugins
RUN wp plugin activate yoast-seo --allow-root
RUN wp plugin activate thirstyaffiliates --allow-root
RUN wp plugin activate mailchimp-for-wordpress --allow-root
RUN wp plugin activate wp-mail-smtp --allow-root
```

**Docker Compose entry:**
```yaml
wordpress:
  build:
    context: .
    dockerfile: Dockerfile.wordpress
  environment:
    WORDPRESS_DB_HOST: postgres:5432
    WORDPRESS_DB_NAME: wordpress
    WORDPRESS_DB_USER: makinmoves
    WORDPRESS_DB_PASSWORD: ${POSTGRES_PASSWORD}
    WORDPRESS_TABLE_PREFIX: wp_
    # Disable auto-updates (we manage via CI/CD)
    AUTOMATIC_UPDATER_DISABLED: "true"
  volumes:
    - wp_content:/var/www/html/wp-content
    - ./config/wp-config.php:/var/www/html/wp-config-extra.php
```

### 4.2 WordPress Configuration

**File: `config/wp-config.php` (additions)**

```php
<?php
// Custom configuration for Trinity

// Security headers
define('DISALLOW_FILE_EDIT', true); // Disable theme/plugin editor
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

// Performance
define('WP_MEMORY_LIMIT', '256M');
define('WP_MAX_MEMORY_LIMIT', '512M');

// Cache
define('WP_CACHE', true);

// Database query logging (for debugging)
if (getenv('WP_DEBUG')) {
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', false);
}

// Affiliate links (ThirstyAffiliates)
define('THIRSTYAFFILIATES_CLOAK_REDIRECT', true);

// Email (WP Mail SMTP)
define('WPMS_ON', true);
define('WPMS_MAILER', 'sendgrid');

// API settings (for n8n)
define('REST_API_ENABLED', true);
define('JSON_API_ENABLED', true);
?>
```

### 4.3 Affiliate Link Integration

**ThirstyAffiliates setup:**

```sql
-- WordPress table structure (created by plugin)
-- wp_aff_links (stores affiliate links)
-- wp_aff_stats (click tracking)

-- Manual link creation (if needed)
INSERT INTO wp_aff_links (name, url, cloaked_url, count)
VALUES
  ('Amazon Associates - Product A', 'https://amazon.com/product/a', '/go/amazon-a', 0),
  ('Gumroad - Course X', 'https://gumroad.com/product/x', '/go/gumroad-x', 0),
  ('Clickbank - Affiliate Y', 'https://clickbank.com/y', '/go/clickbank-y', 0);
```

**WordPress REST API integration (for n8n):**

```bash
# Create WordPress REST API user
wp user create api_user api@trinity.local --user_pass=random_token --role=editor

# Generate application password
wp rest-api create-app-password api_user "n8n Automation"
# Returns: base64 encoded token → use in n8n HTTP headers
```

---

## 5. Email & CRM Layer (Mailchimp)

### 5.1 Mailchimp Free Tier Setup

**Integration steps:**

```bash
# 1. Create Mailchimp account (free tier)
# https://mailchimp.com/signup

# 2. Create audience (list) for Trinity
# Audience name: "Trinity Subscribers"
# Default from name: "Trinity"
# Default from email: noreply@trinity.local

# 3. Generate API key
# Account → Extras → API keys → Create Key
# Store in .env: MAILCHIMP_API_KEY=xxxxx

# 4. Get Mailchimp Server Prefix (e.g., "us15")
# Server prefix is in API key URL: https://us15.api.mailchimp.com
# Store in .env: MAILCHIMP_SERVER=us15
```

### 5.2 Mailchimp ↔ WordPress Integration

**Plugin: Mailchimp for WordPress**

```php
// After plugin activation via WP CLI
// Configuration via WordPress admin

// Settings:
// - API Key: [paste from .env]
// - List ID: [select Trinity list]
// - Form style: Embedded form
// - Checkbox text: "Subscribe to Trinity newsletter"
// - Success message: "Welcome aboard!"

// WordPress form placement:
// [mc4wp_form]  // Shortcode in post footer
// Or: Elementor widget "Mailchimp Form"
```

### 5.3 Mailchimp Automation (n8n Integration)

**n8n node setup:**

```json
{
  "node": "Mailchimp",
  "operation": "Add/Update Contact",
  "parameters": {
    "api_key": "{{env.MAILCHIMP_API_KEY}}",
    "server": "{{env.MAILCHIMP_SERVER}}",
    "list_id": "{{env.MAILCHIMP_LIST_ID}}",
    "email": "{{$json.email}}",
    "first_name": "{{$json.first_name}}",
    "tags": ["affiliate", "p2-content"],
    "status": "subscribed"
  }
}
```

---

## 6. SEO & Analytics (Rank Math + Google Search Console)

### 6.1 Rank Math WordPress Plugin Setup

**Installation (via WP CLI):**

```bash
wp plugin install rank-math --activate

# Activate modules
wp rank-math activate advanced-seo
wp rank-math activate schema
wp rank-math activate sitemap
```

**Configuration:**

```php
// Rank Math settings (via WordPress admin)

// Business Schema
// - Business name: Trinity
// - Business type: Digital Products Company
// - Logo URL: /assets/logo.png

// XML Sitemaps
// - Enable sitemap
// - Index: /sitemap.xml
// - Post types: Posts, Products
// - Auto-update: Yes

// Redirects (affiliate link cloaking)
// - Enable redirects
// - Default redirect type: 301 (permanent)

// Content Analyzer
// - Free tier: 5 keywords tracked
// - Keywords: ["digital products", "freelance writing", "affiliate marketing", "passive income", "online course"]
```

### 6.2 Google Search Console Integration

**Verification:**

```bash
# Add domain to Google Search Console
# https://search.google.com/search-console

# Verification methods:
# 1. HTML file upload (simplest)
# 2. HTML meta tag in <head>
# 3. Google Analytics account
# 4. Google Tag Manager

# Rank Math auto-submits sitemap
# GSC will automatically index: /sitemap.xml
```

**Monitoring queries:**

```bash
# Key metrics to track
# - Impressions (how many times Trinity appeared in search)
# - CTR (click-through rate)
# - Top queries (what people searched)
# - Top pages (which content ranked)
# - Top countries (geographic reach)

# Export monthly reports (manual, but free)
# GSC → Performance → Export data as CSV for CFO tracking
```

---

## 7. Backup & Recovery

### 7.1 Automated Backup (via Cron)

**File: `docker/backup-cron.sh`**

```bash
#!/bin/bash
# Automated daily backup

BACKUP_TIME=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/backups/trinity"
RETENTION_DAYS=30

mkdir -p "$BACKUP_DIR"

# Backup PostgreSQL
pg_dump -U makinmoves -d makinmoves | \
  gzip > "$BACKUP_DIR/postgres_$BACKUP_TIME.sql.gz"

# Backup WordPress content
tar -czf "$BACKUP_DIR/wordpress_$BACKUP_TIME.tar.gz" \
  /var/www/html/wp-content

# Upload to GitHub releases (if gh CLI available)
if command -v gh &> /dev/null; then
  # Assume gh auth already configured
  cd "$BACKUP_DIR"

  # Create release (one per day)
  RELEASE_TAG="backup-$(date +%Y-%m-%d)"
  gh release create "$RELEASE_TAG" \
    postgres_$BACKUP_TIME.sql.gz \
    wordpress_$BACKUP_TIME.tar.gz \
    --repo "user/makinmoves-backups" \
    2>/dev/null || echo "Release already exists for today"
fi

# Cleanup old backups (keep 30 days)
find "$BACKUP_DIR" -name "*.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup completed at $BACKUP_TIME"
```

**Cron entry (add to `/etc/crontab`):**

```cron
# Run backup daily at 2 AM
0 2 * * * root /path/to/docker/backup-cron.sh >> /var/log/trinity-backup.log 2>&1
```

### 7.2 Disaster Recovery Plan

**If PostgreSQL fails:**

```bash
# 1. Restore from latest backup
latest_backup=$(ls -t /backups/trinity/postgres_*.sql.gz | head -1)

# 2. Connect to PostgreSQL container
docker exec -it mm-postgres bash

# 3. Restore database
gunzip < "$latest_backup" | psql -U makinmoves -d makinmoves

# 4. Verify data
psql -U makinmoves -d makinmoves -c \
  "SELECT COUNT(*) FROM digital_products;"

# 5. Restart n8n to reconnect
docker restart mm-n8n
```

**If WordPress fails:**

```bash
# 1. Restore WordPress content
latest_backup=$(ls -t /backups/trinity/wordpress_*.tar.gz | head -1)

# 2. Extract to new WordPress container
tar -xzf "$latest_backup" -C /var/www/html

# 3. Permissions
docker exec -it mm-wordpress \
  chown -R www-data:www-data /var/www/html/wp-content

# 4. Restart WordPress
docker restart mm-wordpress
```

---

## 8. Monitoring & Alerting

### 8.1 Health Checks (Daily)

**Script: `scripts/health-check.sh`**

```bash
#!/bin/bash

echo "=== Trinity Infrastructure Health Check ==="
echo "Timestamp: $(date)"

# Check all Docker containers
echo -e "\n[Docker Services]"
docker compose ps

# Check PostgreSQL
echo -e "\n[PostgreSQL]"
docker exec -it mm-postgres pg_isready -U makinmoves && echo "✓ PostgreSQL OK" || echo "✗ PostgreSQL DOWN"

# Check n8n
echo -e "\n[n8n]"
curl -s http://localhost:5678 > /dev/null && echo "✓ n8n OK" || echo "✗ n8n DOWN"

# Check WordPress
echo -e "\n[WordPress]"
curl -s http://localhost:8080 > /dev/null && echo "✓ WordPress OK" || echo "✗ WordPress DOWN"

# Check disk usage
echo -e "\n[Disk Usage]"
df -h | grep -E "Filesystem|/$|/var"

# Check PostgreSQL database size
echo -e "\n[Database Size]"
docker exec mm-postgres psql -U makinmoves -d makinmoves -c \
  "SELECT pg_size_pretty(pg_database_size('makinmoves'));"

# Check recent errors
echo -e "\n[Recent Errors (last 24h)]"
docker exec mm-postgres psql -U makinmoves -d makinmoves -c \
  "SELECT COUNT(*), severity FROM error_logs WHERE logged_at > NOW() - INTERVAL '1 day' GROUP BY severity;"

echo -e "\n=== Health Check Complete ==="
```

### 8.2 Error Monitoring Dashboard (PostgreSQL)

**View: Recent errors**

```sql
SELECT
  id,
  workflow_name,
  severity,
  error_message,
  logged_at,
  resolved
FROM error_logs
WHERE logged_at > NOW() - INTERVAL '24 hours'
ORDER BY logged_at DESC
LIMIT 20;
```

**View: Error rate by workflow**

```sql
SELECT
  workflow_name,
  COUNT(*) as total_errors,
  COUNT(*) FILTER (WHERE resolved = FALSE) as unresolved,
  ROUND(COUNT(*) FILTER (WHERE severity = 'critical')::NUMERIC / COUNT(*) * 100, 2) as critical_rate
FROM error_logs
WHERE logged_at > NOW() - INTERVAL '7 days'
GROUP BY workflow_name
ORDER BY total_errors DESC;
```

---

## 9. Phase 2 Migration (Days 29–31)

### 9.1 Migration to Railway

**Steps:**

```bash
# 1. Create Railway account
# https://railway.app/new/project

# 2. Create project "Trinity"

# 3. Add PostgreSQL service
# - PostgreSQL 16
# - Generate credentials
# - Note: Host, Port, Username, Password, Database

# 4. Export local database
pg_dump -U makinmoves -d makinmoves > /tmp/trinity-backup.sql

# 5. Import to Railway PostgreSQL
psql -h <railway-host> -U <railway-user> -d <railway-db> < /tmp/trinity-backup.sql

# 6. Add n8n service
# - Select Docker image: n8nio/n8n
# - Environment variables:
#   - DB_TYPE=postgresdb
#   - DB_POSTGRESDB_HOST=<railway-postgres-host>
#   - DB_POSTGRESDB_PORT=5432
#   - DB_POSTGRESDB_DATABASE=<railway-db>
#   - DB_POSTGRESDB_USER=<railway-user>
#   - DB_POSTGRESDB_PASSWORD=<railway-password>

# 7. Deploy and test
# - Verify n8n UI accessible
# - Test PostgreSQL connectivity
# - Import n8n workflows from backup

# 8. Update .env with new Railway credentials
# - POSTGRES_HOST=<railway-host>
# - N8N_URL=<railway-n8n-url>

# 9. Update WordPress to connect to Railway PostgreSQL
# - wp-config.php → update DB_HOST, DB_USER, DB_PASSWORD

# 10. Final verification
# - Test revenue capture workflow
# - Test publishing workflow
# - Verify CFO queries working
```

---

## 10. Troubleshooting Guide

| Issue | Symptom | Solution |
|-------|---------|----------|
| **n8n can't connect to PostgreSQL** | n8n container logs show "connection refused" | Check DB_POSTGRESDB_HOST is correct; verify PostgreSQL container is running |
| **WordPress database connection error** | "Error establishing database connection" | Check WORDPRESS_DB_PASSWORD matches POSTGRES_PASSWORD in .env |
| **Backup fails** | Cron job doesn't produce backup file | Check: 1) pg_dump installed, 2) cron permissions, 3) GitHub CLI auth |
| **n8n workflow times out** | Workflow runs >10 min, then fails | Split workflow into smaller steps; add retries with backoff |
| **PostgreSQL runs out of disk** | pg_isready hangs or fails | `docker exec mm-postgres df -h`; delete old backups or increase volume |
| **Affiliate links not tracking** | ThirstyAffiliates shows 0 clicks | Check: 1) Plugin activated, 2) Links inserted in WordPress, 3) click-tracking enabled |

---

## Conclusion

This specification provides complete technical implementation for all open-source components. Follow deployment order: Docker → PostgreSQL → n8n → WordPress → Backups → Monitoring.

**Timeline:** 4–6 hours setup (Phase 1), 2–3 hours migration (Phase 2)

**Next:** CTMO proceeds with Phase 1 execution (Day 1–2 sprint)

---

**Document:** Open-Source Stack Component Specification
**Version:** 1.0
**Date:** 2026-03-29
**Status:** READY FOR IMPLEMENTATION
