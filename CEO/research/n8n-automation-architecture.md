# n8n Automation Architecture for Autonomous Revenue Operations
**Research Date:** 2026-03-29
**Status:** Strategic Framework for Board Review

---

## EXECUTIVE SUMMARY

n8n is a viable automation backbone for autonomous revenue operations. Key finding: **Gumroad and WordPress are easiest to integrate; Etsy requires API credentials but is well-documented; Medium API is deprecated (critical blocker); Redbubble has no official API (major constraint).**

Platform integration difficulty varies significantly. This research identifies 4 critical workflows, API rate limits, PostgreSQL logging strategy, and a realistic implementation timeline.

**Recommendation:** Prioritize Gumroad + WordPress for phase 1 (fastest time-to-value), plan Etsy integration in phase 2, deprioritize Medium, and treat Redbubble as manual or third-party scraper solution.

---

## 1. PLATFORM INTEGRATION RANKING (Easiest → Hardest)

### Tier 1: EASIEST (Built-in n8n Nodes, Webhook Support)

#### **Gumroad** ✅ EASIEST
- **Status:** Official n8n integration available
- **Node Types:** Gumroad Trigger node (webhook-based) + HTTP Request node for custom calls
- **Authentication:** API token in query parameters (no OAuth required)
- **Setup Time:** 20-30 minutes
- **Strengths:**
  - Webhook trigger available for purchase events (real-time capture)
  - Can trigger on product sales, subscription events, license codes
  - Minimal API endpoints needed (products, sales, customers)
  - Low rate limiting concerns (no public docs, but generous in practice)
- **Data Available:** Customer info, product details, sale amounts, delivery timestamps
- **Rate Limits:** Undocumented; recommended approach = exponential backoff + 429 handling
- **n8n Node Configuration:**
  - Gumroad Trigger: Set to "Sale" event
  - HTTP Request: GET `/resource/products`, POST to `/resource/licenses`

**Why Easy:** Webhook-native platform; real-time event delivery; no complex OAuth.

---

#### **WordPress** ✅ TIER 1 (But Requires Plugin)
- **Status:** Native REST API + webhook support via plugins
- **Node Types:** HTTP Request node (direct REST API) or Webhook trigger + WP Webhooks plugin
- **Authentication:** Basic auth or custom API tokens
- **Setup Time:** 30-45 minutes (includes plugin install)
- **Strengths:**
  - REST API enabled by default (v4.7+)
  - Webhook plugins like WP Webhooks integrate cleanly with n8n
  - Can trigger on: post published, user registered, form submitted, product sold (WooCommerce)
  - Direct database access possible via custom endpoints
- **Data Available:** Posts, pages, user data, custom post types, form submissions
- **Rate Limits:** None from WordPress; depends on hosting
- **n8n Node Configuration:**
  - Webhook Trigger: Set URL from n8n, point WP plugin to it
  - HTTP Request: `GET /wp-json/wp/v2/posts`, `POST /wp-json/wp/v2/posts`

**Why Easy:** Built-in REST API; mature webhook ecosystem; flexibility with HTTP Request node.

---

### Tier 2: MODERATE (Official Support, Standard OAuth/API Keys)

#### **Etsy** ⚠️ MODERATE
- **Status:** Official API with good documentation; n8n HTTP Request node integration
- **Node Types:** HTTP Request node (no native Etsy node; use Pipedream or direct API)
- **Authentication:** OAuth 2.0 required (3-legged flow)
- **Setup Time:** 45-60 minutes (OAuth setup + credential storage)
- **Strengths:**
  - Mature, well-documented REST API
  - Can trigger on: sales, shop updates, inventory changes
  - Stock alert automations already proven in community
  - Rate limits are clear and manageable for small-scale ops
- **Data Available:** Shop info, listings, sales, inventory, reviews, shop sections
- **Rate Limits:**
  - **10,000 requests per 24-hour period** (daily limit)
  - **10 requests per second** (per-second limit)
  - Response headers show `X-Remaining-Today`, `X-Remaining-This-Second`
  - Sliding window (rolling 24-hour block)
  - Can request higher limits (must apply to Etsy)
- **Critical Issue:** Requires OAuth setup; n8n doesn't have native Etsy node, so HTTP Request node needed with token refresh logic
- **n8n Node Configuration:**
  - HTTP Request: `GET /v3/application/shops/{shop_id}/listings`
  - Add retry logic for 429 responses
  - Store `access_token` + `refresh_token` in n8n secrets

**Why Moderate:** Good API design but OAuth overhead; rate limits are conservative; no native n8n node (requires manual HTTP setup).

---

### Tier 3: HARD (Deprecated, No Official API, or Complex Auth)

#### **Medium** ❌ DEPRECATED (DO NOT PRIORITIZE)
- **Status:** API is officially deprecated and no longer supported
- **Node Types:** Medium node exists in n8n but credentials can't be configured for new integrations
- **Authentication:** OAuth (deprecated)
- **Setup Time:** Not applicable; integration not possible
- **Critical Blocker:** Medium shut down API access; existing tokens won't work for new setups
- **Alternative:** Use manual posting or Medium's browser automation (not recommended for autonomous ops)
- **Recommendation:** Remove from roadmap; pivot to Substack or Ghost (both have active APIs)

---

#### **Redbubble** ❌ HARDEST (No Official API)
- **Status:** No official public API; only unofficial scrapers and workarounds
- **Integration Options:**
  1. **Unofficial/Homebrew API** (GitHub: prolificjones82/Redbubble-API) — web scraper, unreliable
  2. **Third-party scrapers** (Oxylabs, Apify) — paid, requires extra infrastructure
  3. **Automation tools** (LazyMerch, Auup) — closed-source, not integrated with n8n
  4. **Python/Node automation** — write custom uploader, high maintenance
- **Authentication:** None; uses session cookies + CSRF tokens (fragile)
- **Setup Time:** 120+ minutes; high ongoing maintenance
- **Critical Issues:**
  - Terms of Service prohibit scraping
  - No API means session-based auth (breaks easily)
  - No webhook support
  - High risk of account suspension
- **Recommendation:** Use managed tool (Auup, LazyMerch) or deprioritize; not suitable for autonomous n8n operations
- **Alternative:** Merch by Amazon (has unofficial API paths), Printful (has API), or manual uploads

**Why Hard:** No official API; legal/TOS risks; fragile scraping; high maintenance burden.

---

### INTEGRATION DIFFICULTY SUMMARY TABLE

| Platform | n8n Support | Auth Type | Setup Time | Rate Limits | Risk | Recommendation |
|----------|-------------|-----------|-----------|------------|------|-----------------|
| **Gumroad** | Native Trigger + HTTP | API Token | 20-30m | Undocumented (generous) | Low | ✅ PHASE 1 |
| **WordPress** | REST API + Webhook plugins | Basic/Token | 30-45m | None (hosting dependent) | Low | ✅ PHASE 1 |
| **Etsy** | HTTP Request node | OAuth 2.0 | 45-60m | 10k/day, 10/sec | Medium | ✅ PHASE 2 |
| **Medium** | Native but deprecated | OAuth (inactive) | N/A | N/A | HIGH | ❌ SKIP |
| **Redbubble** | None (scrapers only) | Session cookies | 120+m | N/A | VERY HIGH | ❌ DEPRIORITIZE |

---

## 2. THE 4 CRITICAL n8n WORKFLOWS

### Workflow 1: REVENUE CAPTURE (Hourly)

**Purpose:** Poll revenue platforms hourly, capture sales data, log to PostgreSQL.

**Trigger:** Schedule Trigger (every 60 minutes)

**Node Architecture:**

```
[Schedule Trigger: Every 60 min]
  ↓
[Gumroad HTTP Request: GET /resource/sales?since=<last_hour>]
  ↓
[Transform: Set node to normalize data]
  ↓
[Loop Over Items: Process each sale]
  ↓
[PostgreSQL: INSERT INTO revenue_log]
  ↓
[Error Handler: Log failures to Slack]
```

**Detailed Node Configuration:**

1. **Schedule Trigger Node**
   - Type: "Schedule Trigger"
   - Interval: Every 1 hour
   - Timezone: UTC (recommended for consistency)
   - Time to run: Top of hour (consistent timing)

2. **HTTP Request Node (Gumroad)**
   ```
   - URL: https://api.gumroad.com/v2/sales
   - Method: GET
   - Authentication: Header "Authorization: Bearer {{$secrets.GUMROAD_API_TOKEN}}"
   - Params: filter[from_date] = {{ $now.minus({hours: 1}).toISO() }}
   - Retry on Fail: YES (Max 3 retries, exponential backoff)
   - Batch: 1 item per batch, 500ms interval
   ```

3. **Set Node (Data Normalization)**
   ```json
   {
     "sale_id": "{{ $json.id }}",
     "product_name": "{{ $json.product.name }}",
     "amount": "{{ $json.price }}",
     "currency": "{{ $json.currency }}",
     "buyer_email": "{{ $json.license_key }}",
     "timestamp": "{{ $json.created_at }}",
     "platform": "gumroad",
     "captured_at": "{{ $now.toISO() }}"
   }
   ```

4. **Loop Over Items Node**
   - Batch Size: 1 (process one sale per iteration for clarity)
   - Expression: `{{ $input.all() }}`

5. **PostgreSQL Node**
   ```
   - Query Type: INSERT
   - Table: revenue_log
   - Columns: sale_id, product_name, amount, currency, buyer_email, timestamp, platform, captured_at
   - Query Params: Use parameterized queries to prevent SQL injection
   - Batch Mode: "Independently" (one INSERT per sale)
   ```

6. **Error Handler (Slack Notification)**
   - Trigger: Error workflow
   - Message: "Revenue capture failed at {{ $now.toISO() }}: {{ $error.message }}"
   - Send to: #automation-alerts Slack channel

**Expected Data Output:**
```
{
  "sale_id": "abc123",
  "product_name": "Email Marketing Template",
  "amount": 29.99,
  "currency": "USD",
  "buyer_email": "customer@example.com",
  "timestamp": "2026-03-29T14:00:00Z",
  "platform": "gumroad",
  "captured_at": "2026-03-29T15:00:00Z"
}
```

**Rate Limit Handling:**
- Gumroad: No public rate limit; retry with exponential backoff (1s, 2s, 5s, 13s)
- PostgreSQL: No limit; batch inserts for efficiency

**Estimated Setup Time:** 25 minutes
**Estimated Execution Time:** 30-60 seconds per hour

---

### Workflow 2: CONTENT GENERATION (Daily, via Claude API)

**Purpose:** Generate content daily (blog posts, product descriptions, social captions) using Claude API; stage for publishing.

**Trigger:** Schedule Trigger (daily at 8 AM UTC)

**Node Architecture:**

```
[Schedule Trigger: Daily 8 AM]
  ↓
[Set Node: Prepare prompts from template]
  ↓
[HTTP Request: Call Claude API (Messages endpoint)]
  ↓
[Transform: Parse Claude response, extract text]
  ↓
[Set Node: Format for platform (WordPress, Medium, etc.)]
  ↓
[PostgreSQL: INSERT INTO content_staging]
  ↓
[Slack Notification: Notify user of generated content]
```

**Detailed Node Configuration:**

1. **Schedule Trigger Node**
   - Interval: Every day
   - Time: 08:00 UTC
   - Timezone: UTC

2. **Set Node (Prepare Prompts)**
   ```json
   {
     "content_type": "blog_post",
     "topic": "AI-powered content creation for indie creators",
     "platform": "wordpress",
     "tone": "informative, encouraging",
     "length": "1500 words",
     "includes_cta": true,
     "cta_text": "Try our template"
   }
   ```

3. **HTTP Request Node (Claude API)**
   ```
   - URL: https://api.anthropic.com/v1/messages
   - Method: POST
   - Authentication: Header "x-api-key: {{ $secrets.CLAUDE_API_KEY }}"
   - Headers: "content-type: application/json"
   - Body:
     {
       "model": "claude-opus-4-1",
       "max_tokens": 2000,
       "system": "You are a content creator specializing in digital products for indie makers...",
       "messages": [
         {
           "role": "user",
           "content": "Write a {{ $json.length }}-word {{ $json.content_type }} about {{ $json.topic }} in a {{ $json.tone }} tone. Include CTA: {{ $json.cta_text }}"
         }
       ]
     }
   - Retry on Fail: YES (Max 3 retries)
   - Rate Limit Handling: Wait 1s between requests (Claude rate limit: depends on plan, typically 50k tokens/min for standard)
   ```

4. **Set Node (Parse Claude Response)**
   ```json
   {
     "content_body": "{{ $json.content[0].text }}",
     "platform": "{{ $input.first().json.platform }}",
     "content_type": "{{ $input.first().json.content_type }}",
     "generated_at": "{{ $now.toISO() }}",
     "status": "draft",
     "word_count": "{{ $json.content[0].text.split(' ').length }}"
   }
   ```

5. **Set Node (Format for WordPress)**
   ```json
   {
     "title": "{{ $json.content_body.split('\n')[0].slice(0, 60) }}",
     "content": "{{ $json.content_body }}",
     "status": "draft",
     "type": "post",
     "categories": ["business", "automation"]
   }
   ```

6. **PostgreSQL Node**
   ```
   - Query: INSERT INTO content_staging (title, content, platform, status, generated_at, word_count)
   - Values: ({{ title }}, {{ content }}, {{ platform }}, {{ status }}, {{ generated_at }}, {{ word_count }})
   ```

7. **Slack Notification**
   - Message: "Generated {{ $json.content_type }} ({{ $json.word_count }} words) for {{ $json.platform }}. Review at: [link to staging DB]"

**Claude API Rate Limits:**
- **Standard Plan:** 50k tokens/minute, 10k requests/day
- **Pro Plan:** Higher limits
- **Strategy:** Batch multiple content pieces in one API call if possible; use exponential backoff for 429s

**Estimated Setup Time:** 30-40 minutes
**Estimated Execution Time:** 20-40 seconds per day (depends on content length)
**Daily Cost:** ~$0.30-$1.00 per blog post (Claude pricing)

---

### Workflow 3: PUBLISHING (Automated to Platforms)

**Purpose:** Publish staged content to WordPress, Gumroad, and other platforms automatically when status = "ready".

**Trigger:** Webhook trigger OR Manual approval trigger (safer for first iteration)

**Node Architecture:**

```
[Webhook Trigger: Content ready for publish]
  ↓
[Query PostgreSQL: Get staged content]
  ↓
[If condition: Check platform type]
  ├─→ [WordPress: HTTP POST to /wp-json/wp/v2/posts]
  ├─→ [Gumroad: HTTP POST to product endpoint]
  └─→ [Medium: SKIP (deprecated)]
  ↓
[PostgreSQL: UPDATE content_staging status = published]
  ↓
[Slack: Confirm publish + live URLs]
```

**Detailed Node Configuration:**

1. **Webhook Trigger Node**
   - Webhook Path: `/publish-content`
   - Method: POST
   - Expected payload:
     ```json
     {
       "content_id": 123,
       "platform": "wordpress",
       "status": "ready"
     }
     ```

2. **PostgreSQL Node (Fetch Staged Content)**
   ```
   - Query: SELECT * FROM content_staging WHERE id = {{ $json.content_id }}
   - Fetch Mode: Single row
   ```

3. **If Node (Route by Platform)**
   - Condition: `{{ $json.platform === 'wordpress' }}`
   - True: WordPress HTTP Request
   - False: Check next condition (Gumroad, etc.)

4. **HTTP Request Node (WordPress POST)**
   ```
   - URL: https://yoursite.com/wp-json/wp/v2/posts
   - Method: POST
   - Authentication: Basic auth (WordPress app password)
   - Body:
     {
       "title": "{{ $json.title }}",
       "content": "{{ $json.content }}",
       "status": "publish",
       "format": "standard",
       "categories": [1, 2],
       "tags": ["automation", "revenue"]
     }
   - Response mapping: Extract post.id, post.link
   ```

5. **HTTP Request Node (Gumroad Product Update)**
   ```
   - URL: https://api.gumroad.com/v2/products/{{ $json.product_id }}
   - Method: PUT
   - Body:
     {
       "name": "{{ $json.title }}",
       "description": "{{ $json.content }}",
       "published": true
     }
   ```

6. **PostgreSQL Node (Mark as Published)**
   ```
   - Query: UPDATE content_staging SET status = 'published', published_at = NOW(), published_url = '{{ $json.wordpress_url }}' WHERE id = {{ $json.id }}
   ```

7. **Slack Notification**
   - Message: "✅ Published to {{ $json.platform }}: [{{ $json.title }}]({{ $json.published_url }})"

**Estimated Setup Time:** 40 minutes
**Estimated Execution Time:** 5-10 seconds per publish

---

### Workflow 4: ERROR MONITORING + ALERTS

**Purpose:** Centralized error handling; notify via Slack + log to database for review.

**Trigger:** Error Trigger (catches failures from all 3 workflows above)

**Node Architecture:**

```
[Error Trigger: Catches any workflow error]
  ↓
[Set Node: Normalize error data]
  ↓
[PostgreSQL: INSERT INTO error_log]
  ↓
[If severity >= CRITICAL]
  ├─→ [Slack: Critical alert + action button]
  ├─→ [Email: Escalation]
  └─→ [SMS: If revenue-blocking]
  ↓
[If severity = LOW/MEDIUM]
  └─→ [Slack: #automation-alerts channel]
```

**Detailed Node Configuration:**

1. **Error Trigger Node**
   - Applies to: All workflows (set in each workflow settings)
   - Error workflow name: "Error Monitor"

2. **Set Node (Normalize Error)**
   ```json
   {
     "error_message": "{{ $error.message }}",
     "error_code": "{{ $error.statusCode }}",
     "error_stack": "{{ $error.stack }}",
     "workflow_name": "{{ $execution.workflow }}",
     "execution_id": "{{ $execution.id }}",
     "timestamp": "{{ $now.toISO() }}",
     "severity": "{{ if($error.statusCode >= 500) { 'CRITICAL' } else if($error.statusCode >= 400) { 'WARNING' } else { 'INFO' } }}"
   }
   ```

3. **PostgreSQL Node (Log Error)**
   ```
   - Query: INSERT INTO error_log (error_message, error_code, workflow_name, execution_id, timestamp, severity)
   - Values: ({{ error_message }}, {{ error_code }}, {{ workflow_name }}, {{ execution_id }}, {{ timestamp }}, {{ severity }})
   ```

4. **If Node (Severity Check)**
   - Condition: `{{ $json.severity === 'CRITICAL' }}`
   - TRUE branch: Slack critical alert
   - FALSE branch: Standard alert

5. **Slack Node (Critical Alert)**
   ```
   - Channel: #critical-alerts
   - Message:
     🚨 CRITICAL ERROR in {{ $json.workflow_name }}
     Code: {{ $json.error_code }}
     Message: {{ $json.error_message }}
     Execution: {{ $json.execution_id }}
     [View Logs](#) [Manual Retry](#)
   ```

6. **Slack Node (Standard Alert)**
   ```
   - Channel: #automation-alerts
   - Message:
     ⚠️ Error in {{ $json.workflow_name }} ({{ $json.severity }})
     {{ $json.error_message }}
   ```

7. **Email Node (Escalation for Critical)**
   - To: ceo@yourdomain.com
   - Subject: "CRITICAL: {{ $json.workflow_name }} failed"
   - Body: Full error details + troubleshooting steps

**Retry Strategy Within Main Workflows:**

For transient failures (5xx, timeouts, 429s):
```
Error Code | Action | Retry Count | Backoff |
-----------|--------|-------------|---------|
5xx        | Retry  | 3          | Exp     |
429        | Retry  | 5          | Exp     |
4xx (auth) | Alert  | 0          | N/A     |
Timeout    | Retry  | 3          | Exp     |
```

**Estimated Setup Time:** 35 minutes
**Estimated Execution Time:** 2-5 seconds per error

---

## 3. POSTGRESQL INTEGRATION

### Connection Architecture

**Best Practice:** Direct connection (not via webhook)

```
n8n PostgreSQL Node
      ↓
[Credentials: Host, Port, DB, User, Password]
      ↓
Direct TCP to PostgreSQL
      ↓
Execute query (INSERT, SELECT, UPDATE)
```

### n8n PostgreSQL Node Setup

1. **Create Credentials in n8n**
   - Host: `your-postgres-server.com` (or localhost:5432)
   - Database: `makinmoves_db`
   - User: `n8n_user`
   - Password: Store in n8n secrets manager
   - Port: 5432 (default)
   - Use SSL: YES (for production)

2. **Database Schema for Revenue Ops**

```sql
-- Revenue Log Table
CREATE TABLE revenue_log (
  id SERIAL PRIMARY KEY,
  sale_id VARCHAR(255) UNIQUE NOT NULL,
  product_name VARCHAR(255),
  amount DECIMAL(10,2),
  currency VARCHAR(3),
  buyer_email VARCHAR(255),
  timestamp TIMESTAMP,
  platform VARCHAR(50),
  captured_at TIMESTAMP DEFAULT NOW(),
  processed BOOLEAN DEFAULT FALSE,
  INDEX(timestamp, platform)
);

-- Content Staging Table
CREATE TABLE content_staging (
  id SERIAL PRIMARY KEY,
  title VARCHAR(500),
  content TEXT,
  platform VARCHAR(50),
  status VARCHAR(20) DEFAULT 'draft', -- draft, ready, published
  word_count INT,
  generated_at TIMESTAMP,
  published_at TIMESTAMP,
  published_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  INDEX(status, platform)
);

-- Error Log Table
CREATE TABLE error_log (
  id SERIAL PRIMARY KEY,
  error_message TEXT,
  error_code INT,
  workflow_name VARCHAR(255),
  execution_id VARCHAR(255),
  timestamp TIMESTAMP,
  severity VARCHAR(20),
  resolved BOOLEAN DEFAULT FALSE,
  resolution_notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  INDEX(workflow_name, timestamp, severity)
);

-- Workflow Execution Log (optional, for performance monitoring)
CREATE TABLE workflow_executions (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(255),
  execution_id VARCHAR(255),
  status VARCHAR(20), -- success, error, incomplete
  duration_ms INT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  items_processed INT,
  items_failed INT,
  INDEX(workflow_name, completed_at)
);
```

3. **n8n PostgreSQL Node Syntax**

```javascript
// Query Type: Execute Query
Query: INSERT INTO revenue_log (sale_id, product_name, amount, currency, buyer_email, timestamp, platform) VALUES ($1, $2, $3, $4, $5, $6, $7);

Query Parameters:
[
  "{{ $json.sale_id }}",
  "{{ $json.product_name }}",
  "{{ $json.amount }}",
  "{{ $json.currency }}",
  "{{ $json.buyer_email }}",
  "{{ $json.timestamp }}",
  "{{ $json.platform }}"
]

// Batch Mode: "Independently" (one query per item)
// Return Data: Full rows
```

### Direct vs. Webhook Integration

| Method | Pros | Cons | Use Case |
|--------|------|------|----------|
| **Direct (TCP)** | Fast, reliable, real-time | Requires network access, credentials in n8n | Primary choice for revenue + error logs |
| **Webhook** | No direct DB access | Slow, requires intermediary, harder to debug | Not recommended for this use case |

**Recommendation:** Use direct PostgreSQL node; store credentials in n8n secrets manager.

### Connection Security Best Practices

1. **Use PostgreSQL app user (not admin)**
   ```sql
   CREATE USER n8n_user WITH PASSWORD 'strong_password';
   GRANT CONNECT ON DATABASE makinmoves_db TO n8n_user;
   GRANT USAGE ON SCHEMA public TO n8n_user;
   GRANT INSERT, SELECT, UPDATE ON ALL TABLES IN SCHEMA public TO n8n_user;
   ```

2. **Enable SSL in n8n credentials**
   - Set "SSL: YES" in n8n PostgreSQL node
   - Provide CA certificate if self-signed

3. **Use n8n Secrets Manager**
   - Store password as `{{ $secrets.POSTGRES_PASSWORD }}`
   - Never hardcode credentials in workflows

4. **Firewall Rules**
   - Allow n8n IP to PostgreSQL port 5432 only
   - Restrict outbound to necessary IPs

---

## 4. API RATE LIMITS & THROTTLING STRATEGY

### Platform Rate Limits Summary

| Platform | Rate Limit | Recommendation | Strategy |
|----------|-----------|-----------------|----------|
| **Gumroad** | Undocumented | Conservative | 1 req/sec, backoff on 429 |
| **Etsy** | 10k/day, 10/sec | Well-managed | Batch requests, monitor headers |
| **WordPress** | None (hosting limited) | Check hosting plan | Batch via loop, stagger requests |
| **Claude API** | 50k tokens/min (standard) | Batch content | Process 1-5 pieces/day, distribute |
| **PostgreSQL** | None (local) | Batch writes | 1000+ rows/sec possible, no throttle |

### n8n Built-in Rate Limit Handling

**Method 1: HTTP Request Node Batching**
```
HTTP Request Node Settings:
  - Batching: YES
  - Items per Batch: 5
  - Batch Interval (ms): 500
  → Effect: Sends 5 items every 500ms = 10 items/sec max
```

**Method 2: Retry on Fail**
```
Retry on Fail: YES
Max Retries: 3
Wait Between Tries (ms): 1000
→ Effect: Automatic exponential backoff on failure
```

**Method 3: Custom Exponential Backoff Loop**
```
[HTTP Request]
  ↓
[On Error: Set node to track retry count]
  ↓
[If Node: Is retry_count < 5?]
  ├─→ YES: Calculate backoff = 1000 * (2 ^ retry_count) + jitter(±20%)
  ├─→ [Wait node: Sleep for backoff ms]
  └─→ [Loop back to HTTP Request]
  ├─→ NO: Route to error handler
```

### Recommended Throttling for Each Workflow

**Revenue Capture (Hourly)**
- Gumroad: 1 request per hour (no throttle needed)
- PostgreSQL: Single INSERT per sale; batch if >100 sales/hour
- No rate limit concerns

**Content Generation (Daily)**
- Claude: 1 request per day → 50k tokens is more than enough
- No throttle needed; slow naturally due to content generation time

**Publishing (On-demand)**
- WordPress: 1-5 posts per day; no throttle needed
- Gumroad: 1-2 product updates per day; no throttle needed
- Etsy: 10k/day limit allows ~100 operations; safe for autonomous use

**Error Monitoring**
- No external API calls; PostgreSQL writes only
- No throttle needed

---

## 5. ERROR HANDLING & RETRY STRATEGY

### Error Classification Matrix

```
Error Type        | HTTP Code | Retryable | Strategy
------------------|-----------|-----------|--------------------
Rate Limited      | 429       | YES       | Exponential backoff + jitter
Server Error      | 5xx       | YES       | Exponential backoff + jitter
Timeout           | -         | YES       | Exponential backoff + jitter
Auth Error        | 401, 403  | NO        | Alert + manual fix
Data Error        | 422       | NO        | Log + alert + dead letter queue
Network Error     | ECONNREFUSED | YES    | Exponential backoff + jitter
Database Error    | -         | MAYBE     | Log + alert; retry if transient
```

### Exponential Backoff Implementation

**n8n JavaScript Formula:**
```javascript
// In Set node:
base_delay_ms = 1000;
retry_count = {{ $json.retry_count }};
jitter = Math.random() * 0.4 - 0.2; // ±20%
backoff_ms = Math.ceil(base_delay_ms * Math.pow(2, retry_count) * (1 + jitter));
// Result: 1s, 2s, 5s, 13s, 32s... with randomness
```

### Dead Letter Queue Pattern

For transient failures that can't be immediately retried:

```
[Main workflow error]
  ↓
[If retryable && retries_exhausted]
  ↓
[INSERT INTO dead_letter_queue (workflow, data, error, timestamp)]
  ↓
[Separate workflow runs every 30 min]
  └─→ [SELECT FROM dead_letter_queue]
  └─→ [Retry main operation]
  └─→ [If success: DELETE from DLQ; if fail again: increment retry_count]
```

### Monitoring & Alerting

**Slack Alert for Each Error Type:**

```
429 (Rate Limited):
  Message: "⚠️ Rate limited by {{ platform }}. Retry automatically scheduled."
  Action: Auto-retry (no user action needed)

5xx (Server Error):
  Message: "⚠️ {{ platform }} error ({{ code }}). Retrying..."
  Action: Auto-retry up to 3x; alert if persistent

401/403 (Auth Error):
  Message: "🚨 AUTH FAILED for {{ platform }}. Manual action required."
  Action: Stop workflow; require user to re-authenticate

422 (Data Error):
  Message: "❌ Invalid data sent to {{ platform }}: {{ details }}"
  Action: Log to error_log; skip this item; continue with others
```

---

## 6. IMPLEMENTATION TIMELINE & SETUP COSTS

### Phase 1: MVP (Week 1-2, 8-10 hours)
**Goal:** Get first 2 workflows running (Gumroad revenue + WordPress publishing)

| Task | Est. Time | Difficulty | Dependencies |
|------|-----------|------------|--------------|
| Set up n8n instance (local or cloud) | 30 min | Easy | - |
| Create PostgreSQL database + tables | 20 min | Easy | - |
| Build Revenue Capture workflow (Gumroad) | 30 min | Easy | n8n access |
| Test revenue capture with dummy data | 15 min | Easy | Gumroad test account |
| Build Publishing workflow (WordPress) | 45 min | Moderate | WordPress REST API knowledge |
| Test publishing to WordPress staging | 20 min | Easy | WordPress test site |
| Set up error monitoring (Slack) | 30 min | Easy | Slack workspace |
| **TOTAL PHASE 1** | **3 hours** | - | - |

### Phase 2: Content Automation (Week 2-3, 5-7 hours)
**Goal:** Add Claude-powered content generation workflow

| Task | Est. Time | Difficulty | Dependencies |
|------|-----------|------------|--------------|
| Set up Claude API credentials | 10 min | Easy | Claude API key |
| Build Content Generation workflow | 40 min | Moderate | Claude API knowledge |
| Test content generation with staging DB | 20 min | Easy | PostgreSQL |
| Create approval mechanism (optional) | 30 min | Moderate | Slack/webhook |
| Refine prompts + test outputs | 60 min | Moderate | Domain knowledge |
| **TOTAL PHASE 2** | **3 hours** | - | Phase 1 complete |

### Phase 3: Etsy Integration (Week 4, 4-6 hours)
**Goal:** Add Etsy shop revenue capture + product automation

| Task | Est. Time | Difficulty | Dependencies |
|------|-----------|------------|--------------|
| Register Etsy API app + OAuth setup | 20 min | Moderate | Etsy seller account |
| Build Etsy revenue capture workflow | 35 min | Moderate | Etsy API docs |
| Test with Etsy sandbox | 20 min | Easy | - |
| Build Etsy product update workflow | 40 min | Moderate | Etsy product knowledge |
| Rate limit testing (10/sec, 10k/day) | 30 min | Easy | Etsy sandbox |
| **TOTAL PHASE 3** | **2.5 hours** | - | Phase 1-2 complete |

### Phase 4: Monitoring & Scaling (Ongoing, 2-3 hours/week)
**Goal:** Production hardening, performance tuning, new platforms

| Task | Est. Time | Difficulty |
|------|-----------|------------|
| Set up dashboard (revenue metrics) | 45 min | Moderate |
| Optimize workflows (batch processing) | 30 min | Moderate |
| Add new platforms (Redbubble alternative, etc.) | 60 min | Varies |
| Capacity planning (if revenue scales) | 30 min | Easy |

**TOTAL SETUP TIME:** 8.5 hours (1-2 weeks of part-time work)

---

## 7. n8n NODE TYPES & CONFIGURATION REFERENCE

### Core Node Types Used

| Node Type | Purpose | Common Use Cases |
|-----------|---------|------------------|
| **Schedule Trigger** | Time-based workflow start | Hourly revenue capture, daily content generation |
| **Webhook Trigger** | Event-based workflow start | Manual publish approval, external app integration |
| **HTTP Request** | Call external APIs | Gumroad, Etsy, Claude, WordPress |
| **Set (Edit Fields)** | Transform/normalize data | Reshape API responses, prepare for database |
| **Loop Over Items** | Process array items | Process multiple sales, batch publishing |
| **If Node** | Conditional routing | Route by platform, check severity |
| **PostgreSQL** | Database operations | INSERT, SELECT, UPDATE logging |
| **Slack** | Send notifications | Error alerts, publish confirmations |
| **Wait** | Pause workflow | Implement delays, throttle requests |
| **Error Trigger** | Catch errors | Centralized error handling |
| **Respond to Webhook** | Return HTTP response | ACK webhook deliveries |

### Node Configuration Snippets

**Schedule Trigger (Every 60 Minutes)**
```
Trigger: Schedule
Interval: Every Minute
Minutes Between Trigger: 60
Timezone: UTC
Trigger on Weekends: TRUE
Trigger on Weekdays: TRUE
```

**HTTP Request (with Retry)**
```
Method: GET
URL: https://api.platform.com/endpoint
Authentication: Headers
Headers: {
  "Authorization": "Bearer {{ $secrets.API_KEY }}",
  "Content-Type": "application/json"
}
Retry on Fail: YES
Max Retries: 3
Wait Between Tries (ms): 1000
Batch Size: 5
Batch Interval (ms): 500
```

**PostgreSQL Node (INSERT)**
```
Operation: Execute Query
Query: INSERT INTO table (col1, col2, col3) VALUES ($1, $2, $3)
Query Parameters: ["{{ $json.field1 }}", "{{ $json.field2 }}", "{{ $json.field3 }}"]
Batch Mode: Independently
Return Data: Full rows
```

**Set Node (Normalize Data)**
```
Keep Only Set: FALSE
Mapping:
  revenue_id: $json.id
  amount: $json.price
  status: "processed"
  captured_at: $now.toISO()
```

**Loop Over Items**
```
Batch Size: 1
Mode: Expression
Expression: {{ $input.all() }}
```

**If Node (Condition)**
```
Condition: {{ $json.platform === 'wordpress' }}
Combine with: AND (if multiple conditions)
```

**Slack Node (Notification)**
```
Select a Channel: #automation-alerts
Message Type: Block Kit
Message: {blocks: [{"type": "section", "text": {"type": "mrkdwn", "text": "Revenue: ${{ $json.amount }}"}}]}
```

---

## 8. GOTCHAS & BLOCKERS TO AVOID

### Platform-Specific

1. **Medium API Deprecated**
   - **Gotcha:** Medium shut down API support; existing n8n integrations won't work
   - **Fix:** Remove from roadmap; use Ghost or Substack instead
   - **Cost:** 3+ hours of rework if not caught early

2. **Redbubble No Official API**
   - **Gotcha:** No public API; all integrations use fragile web scraping
   - **Fix:** Use LazyMerch/Auup managed tools; don't build custom n8n integration
   - **Cost:** 10+ hours of failed attempts if you try to build it

3. **Etsy OAuth Complexity**
   - **Gotcha:** OAuth token refresh required; n8n doesn't auto-refresh tokens
   - **Fix:** Implement token refresh logic in Set node; test regularly
   - **Cost:** 1-2 hours of troubleshooting when token expires

4. **Gumroad API Undocumented Rate Limits**
   - **Gotcha:** No public rate limit docs; will fail silently at some point
   - **Fix:** Implement aggressive retry logic (exponential backoff + jitter)
   - **Cost:** None if prepared; 2+ hours if not

### n8n-Specific

5. **PostgreSQL Connection Timeouts in Cloud**
   - **Gotcha:** If n8n and PostgreSQL on different regions, TCP timeouts occur
   - **Fix:** Use cloud provider's connection pooling; ensure network ACLs allow traffic
   - **Cost:** 30 min of troubleshooting

6. **Error Trigger Doesn't Catch Everything**
   - **Gotcha:** Some errors (missing data, malformed JSON) won't trigger error workflow
   - **Fix:** Add explicit validation nodes; use Try/Catch pattern with If nodes
   - **Cost:** Test thoroughly before going live

7. **Rate Limit Headers Not Consistent**
   - **Gotcha:** Different APIs return different rate limit headers (X-Remaining-Today vs RateLimit-Remaining)
   - **Fix:** Parse response headers generically; map to standard variable
   - **Cost:** 30 min to implement parser

8. **Workflow Execution Logs Not Persisted by Default**
   - **Gotcha:** n8n cloud free tier deletes execution history after 30 days
   - **Fix:** Save execution metadata to PostgreSQL manually (in workflows)
   - **Cost:** 20 min to add logging

9. **n8n Cloud Instance Cold Starts**
   - **Gotcha:** n8n cloud free tier sleeps after 15 min inactivity; first request slow
   - **Fix:** Use self-hosted n8n or pay for always-on tier
   - **Cost:** Recurring; $10-50/month for production reliability

### Data Integrity

10. **Duplicate Revenue Entries**
    - **Gotcha:** If workflow runs twice, inserts duplicate sales
    - **Fix:** Use UNIQUE constraint on sale_id; add idempotency key
    - **Cost:** 15 min to add constraint

11. **Lost Data on Workflow Failure**
    - **Gotcha:** If PostgreSQL INSERT fails, data is lost (no queue)
    - **Fix:** Implement dead letter queue pattern; retry failed inserts
    - **Cost:** 1 hour to implement DLQ

12. **Timezone Mismatches**
    - **Gotcha:** WordPress time != Claude time != PostgreSQL time
    - **Fix:** Always use UTC; set timezone in n8n instance
    - **Cost:** 30 min to standardize

---

## 9. COST BREAKDOWN (Annual)

### Software

| Item | Cost | Notes |
|------|------|-------|
| n8n Cloud (Standard) | $50/month ($600/year) | Always-on, priority support |
| n8n Self-Hosted | $0 (free) | On-premises, requires DevOps |
| PostgreSQL Cloud | $15/month ($180/year) | AWS RDS, minimal instance |
| PostgreSQL Self-Hosted | $0 (free) | On your server |
| Claude API | ~$5/month ($60/year) | 1 blog post/day = $0.30-1.00/day |
| Gumroad | 0% commission | Free to use |
| WordPress Hosting | $15/month ($180/year) | Managed WordPress, e.g., Bluehost |
| Slack | $0 (free) | Free tier; $5/month for pro |
| **TOTAL (Cloud)** | **~$540/year** | Production-ready |
| **TOTAL (Self-hosted)** | **~$60/year** | DIY; requires admin work |

### Development Time (One-time)

| Phase | Hours | Cost (@ $50/hr) |
|-------|-------|-----------------|
| Phase 1 (MVP) | 3 | $150 |
| Phase 2 (Content) | 3 | $150 |
| Phase 3 (Etsy) | 2.5 | $125 |
| Phase 4 (Scaling) | 2 | $100 |
| **TOTAL** | **10.5 hours** | **$525** |

### Total First-Year Cost (Cloud)

```
Software: $540
Development: $525 (one-time)
Operational Support: ~$200/year (estimate)
---
TOTAL: ~$1,265 first year
Ongoing (Year 2+): ~$60/year (if self-hosted DB + n8n)
```

---

## 10. RECOMMENDATION SUMMARY

### What to Build First (Priority Order)

**✅ PHASE 1 (This Month):**
1. **Gumroad Revenue Capture** → Easiest API, real-time webhooks, immediate revenue visibility
2. **PostgreSQL Logging** → Foundation for all future workflows
3. **Error Monitoring** → Production safety net

**✅ PHASE 2 (Next Month):**
4. **Claude Content Generation** → Daily automation; feeds into publishing
5. **WordPress Publishing** → Convert generated content to live blog posts

**✅ PHASE 3 (Month 3):**
6. **Etsy Integration** → Expand revenue streams; API is manageable with OAuth

**❌ SKIP (Don't Build):**
- **Medium Integration** → API deprecated; use Substack instead
- **Redbubble Integration** → No API; use LazyMerch managed tool instead

### Platform Prioritization for n8n

| Rank | Platform | Reason | Timeline |
|------|----------|--------|----------|
| 1 | **Gumroad** | Webhook-native, real-time, easiest API | Week 1 |
| 2 | **WordPress** | REST API mature, flexible, low barrier | Week 1 |
| 3 | **Etsy** | Solid API, well-documented, 10k/day sustainable | Week 4 |
| 4 | **Claude API** | For content generation; batch capable | Week 2 |
| 5 | ~~Medium~~ | ❌ Deprecated; skip | Never |
| 5 | ~~Redbubble~~ | ❌ No API; use managed tool | Never |

### Success Metrics (Track These)

- **Revenue Capture Latency:** < 1 minute from sale to database
- **Content Generation Cost:** < $1 per blog post
- **Publishing Reliability:** 99%+ success rate (< 1 error/month)
- **Error Response Time:** Alert within 5 minutes of failure
- **Workflow Runtime:** Revenue capture < 60 sec/hour, publishing < 10 sec/event

---

## SOURCES

Research conducted via comprehensive web search. Key references:

- [n8n Integrations Directory](https://n8n.io/integrations/)
- [n8n Documentation - Postgres Integration](https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.postgres/)
- [n8n Documentation - Error Handling](https://docs.n8n.io/flow-logic/error-handling/)
- [n8n Documentation - Rate Limits](https://docs.n8n.io/integrations/builtin/rate-limits/)
- [Etsy API Documentation - Rate Limits](https://developer.etsy.com/documentation/essentials/rate-limits/)
- [Gumroad API Documentation](https://gumroad.com/api)
- [WordPress REST API](https://developer.wordpress.org/rest-api/)
- [Anthropic Claude API Documentation](https://docs.anthropic.com/claude/reference/messages)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [n8n Community Workflows](https://n8n.io/workflows/)

---

**Document Status:** Ready for Board Review
**Next Steps:**
1. CEO approves Phase 1 prioritization
2. CTMO builds Gumroad + PostgreSQL workflows
3. COO sets up infrastructure (n8n cloud, PostgreSQL, test accounts)
4. Weekly sync on Phase 1 completion

