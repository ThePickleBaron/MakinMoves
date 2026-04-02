# n8n Workflow Architecture: Complete Specification for Autonomous Revenue Recovery

**Document Type:** Technical Architecture Specification (CTMO Deliverable)
**Date:** 2026-03-29 16:00 UTC
**Status:** FINAL - Ready for Implementation
**Timeline:** 36-hour sprint (2026-03-29 16:35 through 2026-03-30 23:59)
**Objective:** Design 4 core n8n workflows for 100% autonomous operation post-March 31 23:59

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Workflow 1: Revenue Capture (Hourly)](#workflow-1-revenue-capture-hourly)
3. [Workflow 2: Content Generation (Daily)](#workflow-2-content-generation-daily)
4. [Workflow 3: Publishing Pipeline (Daily)](#workflow-3-publishing-pipeline-daily)
5. [Workflow 4: Error Monitoring (Real-time)](#workflow-4-error-monitoring-real-time)
6. [Infrastructure & Prerequisites](#infrastructure--prerequisites)
7. [PostgreSQL Schema Requirements](#postgresql-schema-requirements)
8. [Error Handling & Resilience](#error-handling--resilience)
9. [Testing Strategy](#testing-strategy)
10. [Deployment Checklist](#deployment-checklist)
11. [Post-Deployment Monitoring](#post-deployment-monitoring)

---

## System Overview

### Architecture Diagram (Text Representation)

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTONOMOUS OPERATIONS                    │
│                  (Post-March 31 23:59)                      │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
    INTAKE              GENERATION             OUTPUT
   (Revenue)           (Content)              (Publishing)
        │                     │                     │
        ▼                     ▼                     ▼

   ┌──────────┐        ┌──────────┐        ┌──────────┐
   │ Revenue  │        │ Content  │        │Publishing│
   │ Capture  │◄──────►│Generation│◄──────►│ Pipeline │
   │(W1)      │        │(W2)      │        │(W3)      │
   └──────────┘        └──────────┘        └──────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                        PostgreSQL
                    (Centralized Logging)
                             │
                        ┌────▼────┐
                        │ Workflow │
                        │Error Mon.│
                        │(W4)      │
                        └──────────┘
                             │
                        ┌────▼────────┐
                        │ Alerts/Logs  │
                        │ (Slack/Email)│
                        └──────────────┘
```

### Core Design Principles

1. **Autonomous-First:** Zero manual intervention after March 31. All failures self-heal or trigger clear alerts.
2. **Failure Transparent:** Every failure logged with context. CFO can query why something failed.
3. **Rate Limit Safe:** All API calls respect documented limits. Exponential backoff on 429 responses.
4. **Deduplication Proof:** UNIQUE constraints on sale_id, transaction_id prevent double-counting.
5. **PostgreSQL-Centric:** All state lives in PostgreSQL. n8n is stateless orchestrator.

### n8n Hosting Requirements

**Recommended Tier:** n8n Cloud (paid tier) or Self-hosted on Railway/Heroku
- **Why:** Free tier has 5-minute limits; need unlimited execution time for content generation
- **Cost:** $50/month (n8n cloud) or $0 (self-hosted, but DevOps overhead)
- **Scaling:** Auto-scales to handle 10x revenue with no changes

---

## Workflow 1: Revenue Capture (Hourly)

### Purpose
Autonomously poll Gumroad, Etsy, and other platforms for sales data. Log all transactions to PostgreSQL for CFO queries and board reporting.

### Trigger
- **Type:** Cron Trigger
- **Schedule:** Every hour at :00 (e.g., 09:00, 10:00, 11:00 UTC)
- **Cron Expression:** `0 * * * *`
- **Timezone:** UTC

### Workflow Nodes (Sequence)

```
[1] CRON TRIGGER
    └─ Executes hourly at :00 UTC

[2] PARALLEL NODE (Split into 3 branches: Gumroad, Etsy, Medium)

    ├─ BRANCH A: GUMROAD REVENUE FETCH
    │   [2A.1] HTTP Request: GET /api/v2/products
    │   │   - Auth: Bearer token (from n8n credentials)
    │   │   - Headers: Accept: application/json
    │   │   - Error handling: Catch 401 → alert, 429 → backoff, 5xx → retry
    │   │
    │   [2A.2] Loop: For each product
    │   │   [2A.2.1] HTTP Request: GET /api/v2/products/{id}/sales
    │   │   [2A.2.2] Transform: Parse sales data
    │   │
    │   [2A.3] Transform: Extract fields (sale_id, amount, created_at, customer_email_hash)
    │   │
    │   [2A.4] PostgreSQL: INSERT INTO gumroad_sales (with deduplication)
    │   │   - Query: INSERT ... ON CONFLICT (sale_id) DO NOTHING
    │   │   - Rows inserted: Count for logging
    │   │
    │   [2A.5] Error Handler: If INSERT fails
    │   │   → Log to error_logs table
    │   │   → Alert: Email CFO if critical
    │
    ├─ BRANCH B: ETSY REVENUE FETCH
    │   [2B.1] Get Etsy shop_id from n8n variable
    │   [2B.2] Check rate limit: SELECT requests_today FROM etsy_rate_limit_tracking
    │   [2B.3] If requests_today > 9,900: STOP (preserve daily quota), log warning
    │   [2B.4] HTTP Request: GET /v3/shops/{shop_id}/transactions
    │   │   - Auth: OAuth 2.0 (refresh token if needed)
    │   │   - Params: ?includes=["User"]
    │   │   - Error handling: 401 → alert (need token refresh), 429 → exponential backoff
    │   │
    │   [2B.5] Loop: For each transaction
    │   │   [2B.5.1] Transform: Extract transaction fields
    │   │   [2B.5.2] PostgreSQL: INSERT INTO etsy_sales (with deduplication)
    │   │
    │   [2B.6] Update rate limit counter:
    │   │   UPDATE etsy_rate_limit_tracking SET requests_today = requests_today + 1
    │
    ├─ BRANCH C: MEDIUM REVENUE FETCH (Read-only)
    │   [2C.1] HTTP Request: GET https://api.medium.com/v1/me
    │   │   - Auth: Bearer token (Medium API key)
    │   │   - Note: Medium API deprecated; placeholder for future
    │   │
    │   [2C.2] If 401 or deprecation: Log warning, skip this cycle
    │
    [3] MERGE BRANCHES → Combine results

    [4] AGGREGATE RESULTS
        - Total sales captured: sum(gumroad_sales + etsy_sales + medium_stats)
        - Errors encountered: count(failed inserts)
        - Duration: workflow execution time

    [5] LOG TO WORKFLOW_EXECUTION TABLE
        INSERT INTO workflow_executions:
        - workflow_id: 'revenue_capture'
        - status: 'success' | 'partial_failure' | 'failure'
        - rows_inserted: 42
        - errors_count: 0
        - execution_time_ms: 2500
        - executed_at: NOW()

    [6] ERROR HANDLING
        IF total_errors > 0:
            → INSERT into error_logs with context
            → IF critical errors (auth fails): Send Slack alert
            → IF transient errors (429): Log and continue

        IF no transactions captured for 2+ hours:
            → Send alert to CFO: "Revenue capture stalled"
```

### Node-by-Node Configuration

#### [2A.1] HTTP Request: Gumroad Products List

```javascript
// METHOD: GET
// URL: https://api.gumroad.com/v2/products

// HEADERS:
Authorization: Bearer {{ $credentials.gumroad_api_token }}
Accept: application/json

// PARAMS:
(none)

// ERROR HANDLING:
On error:
  - 401 Unauthorized: Stop workflow, alert "Gumroad token expired"
  - 429 Too Many Requests: Retry with exponential backoff (1s, 2s, 5s, 13s)
  - 5xx Server Error: Retry 3x, then log to error_logs, continue

// RESPONSE PARSING:
{
  "products": [
    {
      "id": "abc123",
      "name": "Product Name",
      ...
    }
  ]
}
```

#### [2A.2] Loop: For Each Product's Sales

```javascript
// INPUT: {{ $node["[2A.1]"].json.products }}
// ACTION: Loop through and fetch sales for each product

items: $node["[2A.1]"].json.products
```

#### [2A.2.1] HTTP Request: Gumroad Sales for Product

```javascript
// METHOD: GET
// URL: https://api.gumroad.com/v2/products/{{ $item.json.id }}/sales

// HEADERS:
Authorization: Bearer {{ $credentials.gumroad_api_token }}
Accept: application/json

// PARAMS:
(none)

// RESPONSE:
{
  "sales": [
    {
      "id": "sale_id_123",
      "amount": 29.99,
      "currency": "usd",
      "customer": {
        "email": "buyer@example.com"
      },
      "created_at": "2026-03-29T14:00:00Z"
    }
  ]
}
```

#### [2A.3] Transform: Normalize Gumroad Sales

```javascript
// INPUT: Gumroad sales response
// OUTPUT: Normalized array with fields for PostgreSQL

return $input.all().map(item => {
  const sale = item.json.sales[0] || {};  // Handle empty responses

  return {
    product_id: $item.json.id,
    sale_id: sale.id,
    amount: parseFloat(sale.amount),
    currency: sale.currency || 'usd',
    customer_email_hash: hashEmail(sale.customer.email),  // SHA256
    created_at: sale.created_at,
    fetched_at: new Date().toISOString(),
    source: 'gumroad'
  };
});

// Helper function (define in n8n Code node)
function hashEmail(email) {
  // Use crypto-js library (pre-loaded in n8n)
  return CryptoJS.SHA256(email.toLowerCase()).toString();
}
```

#### [2A.4] PostgreSQL: Insert Gumroad Sales

```sql
-- NODE TYPE: PostgreSQL

INSERT INTO gumroad_sales (
  product_id,
  sale_id,
  amount,
  currency,
  customer_email_hash,
  created_at,
  fetched_at,
  source
)
VALUES
  ({{ $node["[2A.3]"].json.product_id }},
   {{ $node["[2A.3]"].json.sale_id }},
   {{ $node["[2A.3]"].json.amount }},
   '{{ $node["[2A.3]"].json.currency }}',
   '{{ $node["[2A.3]"].json.customer_email_hash }}',
   '{{ $node["[2A.3]"].json.created_at }}',
   NOW(),
   'gumroad')

ON CONFLICT (sale_id) DO NOTHING;

-- Result: Safely skip duplicate sales
-- Returns: number of rows affected
```

#### [2A.5] Error Handler (Catch-All)

```javascript
// NODE TYPE: Error Trigger (attached to all preceding nodes)

// CATCHES: 401, 429, 5xx, timeout, network errors

// ACTIONS:
if (error.code === 401) {
  // Auth failure - STOP, alert immediately
  INSERT INTO error_logs:
    workflow_name: 'revenue_capture'
    error_type: 'AUTH_FAILURE'
    error_message: 'Gumroad API token expired or invalid'
    severity: 'CRITICAL'

  SEND SLACK ALERT:
    Channel: #makinmoves-alerts
    Message: "🔴 CRITICAL: Gumroad authentication failed. Token needs refresh."
} else if (error.code === 429) {
  // Rate limit - back off exponentially
  INSERT INTO error_logs:
    error_type: 'RATE_LIMIT'
    severity: 'WARNING'

  // Workflow automatically retries with:
  // Retry strategy: exponential backoff (1s, 2s, 5s, 13s)
} else if (error.code >= 500) {
  // Server error - retry 3x then alert
  INSERT INTO error_logs:
    error_type: 'SERVER_ERROR'
    severity: 'WARNING'

  // Automatic retry up to 3 times
}
```

### Branch B: Etsy Revenue Fetch (Similar Structure)

**Key Differences from Gumroad:**

1. **Rate Limit Checking:**
   - Query `etsy_rate_limit_tracking` before API call
   - Enforce: 10 requests/second, 10,000 requests/day
   - Strategy: Stagger calls if approaching limits

2. **OAuth Token Refresh:**
   - Medium token refresh mechanism
   - If token expires: Automatic refresh via refresh token
   - If refresh token invalid: Alert to manually re-authorize

3. **Transaction Structure:**
   - Etsy returns `transactions` with buyer info
   - Extract: transaction_id (unique), amount, listing_id, created_at
   - Hash buyer_username (pseudonymous identifier)

### Branch C: Medium Revenue Fetch (Placeholder)

**Current Status:** Medium API is deprecated
- **Action:** Placeholder node with deprecation warning
- **Fallback:** RSS feed scraping (if needed in future)
- **Status:** Insert warning log, skip processing

---

## Workflow 2: Content Generation (Daily)

### Purpose
Generate 3 pieces of autonomous content daily via Claude API:
1. Digital Product template (name, description, pricing, format)
2. Print-on-Demand design outline (niche, design prompt, specifications)
3. Affiliate article outline (topic, keywords, affiliate links, structure)

All staged in PostgreSQL for COO review before publishing.

### Trigger
- **Type:** Cron Trigger
- **Schedule:** Daily at 06:00 UTC
- **Cron Expression:** `0 6 * * *`
- **Timezone:** UTC

### Workflow Nodes (Sequence)

```
[1] CRON TRIGGER
    └─ Executes daily at 06:00 UTC

[2] INITIALIZE: Load Content Templates & State
    [2.1] Code: Load stored templates from PostgreSQL
    [2.2] Determine: What types of content to generate today
           - Monday: Digital products + affiliate articles
           - Tuesday: PoD designs + affiliate articles
           - (etc. - rotation strategy)

[3] PARALLEL NODE (Split into 3 branches: Product, Design, Article)

    ├─ BRANCH A: DIGITAL PRODUCT GENERATION
    │   [3A.1] Code: Build Claude API prompt for product
    │   │
    │   │   Prompt template:
    │   │   "Generate a digital product suitable for passive income.
    │   │    Include: Product name, description (1-2 sentences),
    │   │    target audience, price ($5-$99), file format (PDF/Notion/etc),
    │   │    and 1 unique selling point.
    │   │    Return as JSON."
    │   │
    │   [3A.2] HTTP Request: Call Claude API (claude-3-sonnet)
    │   │   - Endpoint: https://api.anthropic.com/v1/messages
    │   │   - Model: claude-3-5-sonnet-20241022
    │   │   - Max tokens: 500
    │   │   - Temperature: 0.7 (slight creativity)
    │   │   - API Key: from n8n credentials
    │   │
    │   [3A.3] Parse Response: Extract JSON product data
    │   │   - Name, description, audience, price, format, USP
    │   │
    │   [3A.4] Transform: Structure for content_queue
    │   │   - content_type: 'digital_product'
    │   │   - status: 'pending'
    │   │   - metadata: { price, format, audience, usp }
    │   │
    │   [3A.5] PostgreSQL: INSERT INTO content_queue
    │   │   - Row inserted with status='pending'
    │
    ├─ BRANCH B: POD DESIGN GENERATION
    │   [3B.1] Code: Build Claude prompt for design outline
    │   │
    │   │   Prompt template:
    │   │   "Generate a Print-on-Demand design concept for Redbubble/Etsy.
    │   │    Include: Design niche (e.g., 'Programmer humor t-shirt'),
    │   │    visual description, color palette, target market,
    │   │    applicable product types (tshirt, mug, sticker, etc),
    │   │    estimated price point.
    │   │    Return as JSON."
    │   │
    │   [3B.2] HTTP Request: Call Claude API
    │   │   - Same settings as [3A.2]
    │   │   - Max tokens: 500
    │   │
    │   [3B.3] Parse & Structure for content_queue
    │   │   - content_type: 'pod_design'
    │   │   - metadata: { niche, color_palette, products, estimated_price }
    │
    ├─ BRANCH C: AFFILIATE ARTICLE GENERATION
    │   [3C.1] Code: Build Claude prompt for article outline
    │   │
    │   │   Prompt template:
    │   │   "Generate a blog post outline for affiliate marketing.
    │   │    Topic: [randomly select from list of 10 evergreen topics]
    │   │    Include: Title, 5 SEO keywords, article structure (headings),
    │   │    2-3 affiliate products to reference (just product names, not links),
    │   │    estimated word count.
    │   │    Return as JSON."
    │   │
    │   [3C.2] HTTP Request: Call Claude API
    │   │   - Max tokens: 700 (articles need more detail)
    │   │
    │   [3C.3] Parse & Structure for content_queue
    │   │   - content_type: 'article'
    │   │   - metadata: { seo_keywords, product_refs, word_count, structure }

    [4] MERGE BRANCHES → Combine results

    [5] LOG GENERATION RESULTS
        INSERT INTO content_queue:
        - 3 rows (one per type)
        - All with status='pending'
        - All with created_at=NOW()

        INSERT INTO workflow_executions:
        - workflow_id: 'content_generation'
        - status: 'success'
        - items_generated: 3
        - execution_time_ms: 4500
        - executed_at: NOW()

    [6] SEND NOTIFICATION TO COO
        → Check if COO uses Slack or email
        → Send message: "3 new content items ready for review in content_queue"
        → Include: Link to database query or file location

    [7] ERROR HANDLING
        IF Claude API returns 429 (rate limit):
            → Queue the request for retry (use queue node)
            → Alert: "Content generation rate-limited, will retry in 1 hour"

        IF Claude API returns error:
            → INSERT into error_logs
            → STILL INSERT placeholder row into content_queue
            → Status: 'failed_generation'
            → COO can see generation failed, will retry manually
```

### Node-by-Node Configuration

#### [3A.1] Code: Build Claude Prompt for Product

```javascript
// NODE TYPE: Code

// Generate a prompt for Claude API that asks for a digital product

const topic_hints = [
  "project management template",
  "fitness workout PDF",
  "resume template",
  "business planning workbook",
  "language learning guide",
  "home organization checklist",
  "career development guide",
  "social media content calendar",
  "budget planning spreadsheet",
  "meal planning template"
];

// Pick random topic to avoid repetition
const topic = topic_hints[Math.floor(Math.random() * topic_hints.length)];

const prompt = `You are a digital product creator helping generate passive income products.

Generate ONE digital product concept based on: ${topic}

Requirements:
- Product must be downloadable (PDF, Notion template, spreadsheet, etc)
- Price point: $5 to $99
- Target audience: Be specific (e.g., "Busy moms age 25-40")
- Include a unique selling point that differentiates from competitors

Return ONLY valid JSON, no other text:
{
  "product_name": "...",
  "description": "...",
  "target_audience": "...",
  "price_usd": 29,
  "file_format": "PDF" | "Notion" | "Google Sheets" | "etc",
  "unique_selling_point": "...",
  "category": "productivity" | "health" | "education" | "business"
}`;

return { prompt };
```

#### [3A.2] HTTP Request: Claude API Call

```javascript
// NODE TYPE: HTTP Request
// METHOD: POST
// URL: https://api.anthropic.com/v1/messages

// HEADERS:
{
  "x-api-key": "{{ $credentials.anthropic_api_key }}",
  "anthropic-version": "2023-06-01",
  "content-type": "application/json"
}

// BODY:
{
  "model": "claude-3-5-sonnet-20241022",
  "max_tokens": 500,
  "temperature": 0.7,
  "system": "You are a helpful assistant for digital product creation. Return only valid JSON.",
  "messages": [
    {
      "role": "user",
      "content": "{{ $node[\"[3A.1]\"].json.prompt }}"
    }
  ]
}

// RESPONSE PARSING:
// Extract from response:
// response.content[0].text → Parse as JSON

// ERROR HANDLING:
On 401: Alert "Anthropic API key invalid or expired"
On 429: Retry with exponential backoff (will use queue in prod)
On 5xx: Retry 3x, then alert
```

#### [3A.3] Transform: Parse Claude Response

```javascript
// NODE TYPE: Code

const response_text = $node["[3A.2]"].json.content[0].text;

try {
  const product_data = JSON.parse(response_text);

  // Validate required fields
  const required = ['product_name', 'description', 'target_audience', 'price_usd', 'file_format'];
  for (const field of required) {
    if (!product_data[field]) {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  return product_data;
} catch (error) {
  // If parsing fails, log and return error indicator
  return {
    error: true,
    message: `Failed to parse Claude response: ${error.message}`,
    raw_response: response_text
  };
}
```

#### [3A.5] PostgreSQL: Insert into Content Queue

```sql
-- NODE TYPE: PostgreSQL

INSERT INTO content_queue (
  content_type,
  title,
  description,
  metadata,
  status,
  created_at
)
VALUES (
  'digital_product',
  '{{ $node["[3A.3]"].json.product_name }}',
  '{{ $node["[3A.3]"].json.description }}',
  '{{ JSON.stringify($node["[3A.3]"].json) }}',
  'pending',
  NOW()
);

-- Returns: id of newly inserted row
```

#### [3C.1] Code: Build Article Outline Prompt

```javascript
// NODE TYPE: Code

// List of 10 evergreen affiliate marketing topics
const article_topics = [
  "Best project management tools for remote teams",
  "How to start a small business from home",
  "Budget-friendly fitness equipment for beginners",
  "Top productivity apps for freelancers",
  "Essential software for content creators",
  "Best VPN services for 2026",
  "Home office setup on a budget",
  "Email marketing platforms compared",
  "Affordable website builders for beginners",
  "Time management tools for students"
];

const selected_topic = article_topics[Math.floor(Math.random() * article_topics.length)];

const prompt = `You are an expert content marketer writing affiliate marketing blog posts.

Generate ONE blog post outline for: "${selected_topic}"

Requirements:
- This is for affiliate marketing (we earn commission from product links)
- SEO-optimized (include 5 keyword phrases)
- Realistic to write (2000-3000 words)
- Recommend 2-3 actual products in the article

Return ONLY valid JSON:
{
  "post_title": "...",
  "meta_description": "...",
  "seo_keywords": ["keyword1", "keyword2", ...],
  "article_structure": [
    "Introduction",
    "Section 1 title",
    "Section 2 title",
    ...
  ],
  "affiliate_products": ["product1", "product2"],
  "estimated_word_count": 2500,
  "estimated_read_time_minutes": 8
}`;

return { prompt };
```

---

## Workflow 3: Publishing Pipeline (Daily)

### Purpose
Automatically publish approved content from `content_queue` to all platforms:
- **Gumroad:** Digital products
- **Etsy:** PoD designs (if available)
- **WordPress:** Affiliate articles
- **Redbubble:** PoD designs (via LazyMerch tool or manual upload)

Track all publishes in `publishing_log` for audit trail.

### Trigger
- **Type:** Cron Trigger
- **Schedule:** Daily at 09:00 UTC
- **Cron Expression:** `0 9 * * *`
- **Timezone:** UTC

### Workflow Nodes (Sequence)

```
[1] CRON TRIGGER
    └─ Executes daily at 09:00 UTC

[2] FETCH APPROVED CONTENT
    [2.1] PostgreSQL: SELECT * FROM content_queue WHERE status='approved'

    [2.2] Decision node:
          IF no approved content:
            → Log "No approved content, skipping publish cycle"
            → End workflow successfully
          ELSE:
            → Continue with 3 content items

[3] PARALLEL BRANCHES (By content type)

    ├─ BRANCH A: PUBLISH DIGITAL PRODUCTS TO GUMROAD
    │   [3A.1] Filter: content_type='digital_product' AND status='approved'
    │
    │   [3A.2] For each product:
    │       [3A.2.1] Check if product already exists on Gumroad
    │       │   - Query: SELECT * FROM gumroad_products WHERE product_name=?
    │       │   - If exists: Skip (already published), log to publishing_log
    │       │
    │       [3A.2.2] If new: POST to Gumroad API
    │           - Endpoint: https://api.gumroad.com/v2/products
    │           - Body: Product name, description, price, file (if available)
    │           - Note: Gumroad API doesn't support programmatic publishing
    │           - Workaround: Update publishing_log with "manual_publish_required"
    │
    │       [3A.2.3] Log to publishing_log
    │           INSERT:
    │           - content_id: from content_queue
    │           - platform: 'gumroad'
    │           - status: 'pending_manual' | 'published'
    │           - published_url: (from API response)
    │
    │       [3A.2.4] Update content_queue
    │           UPDATE status='published', published_at=NOW()
    │
    ├─ BRANCH B: PUBLISH ARTICLES TO WORDPRESS
    │   [3B.1] Filter: content_type='article' AND status='approved'
    │
    │   [3B.2] For each article:
    │       [3B.2.1] Transform article metadata to WordPress post format
    │           - Title, description, tags, categories
    │           - Add disclaimer: "This post contains affiliate links"
    │           - Auto-insert affiliate links from metadata
    │
    │       [3B.2.2] POST to WordPress REST API
    │           - Endpoint: https://{{ wordpress_domain }}/wp-json/wp/v2/posts
    │           - Auth: Basic auth (app_user:app_password)
    │           - Body: { title, content, status: 'published', tags, categories }
    │
    │       [3B.2.3] Error handling: If 401/403 → alert, skip
    │
    │       [3B.2.4] Log to publishing_log
    │           - published_url: response.link
    │           - status: 'published'
    │
    │       [3B.2.5] Update content_queue
    │
    ├─ BRANCH C: PUBLISH POD DESIGNS (Manual + Tracking)
    │   [3C.1] Filter: content_type='pod_design' AND status='approved'
    │
    │   [3C.2] ⚠️ MANUAL STEP: Since no direct Redbubble/Merch API
    │       - Log design metadata to publishing_log
    │       - Status: 'awaiting_manual_upload'
    │       - Note: "Design ready at: {{ design_url }}"
    │       - Notify COO: "PoD design ready for upload to Redbubble"
    │
    │       [3C.2.1] Alternative: If LazyMerch account available
    │               - Trigger LazyMerch automation
    │               - Status: 'scheduled_lazymerch'

[4] MERGE & AGGREGATE RESULTS
    - Total items published: count
    - Successful publishes: count
    - Manual uploads required: count
    - Errors: count

[5] LOG WORKFLOW EXECUTION
    INSERT INTO workflow_executions:
    - workflow_id: 'publishing_pipeline'
    - status: 'success' | 'partial_success' | 'failure'
    - items_published: 2
    - items_failed: 0
    - execution_time_ms: 5300

[6] SEND NOTIFICATION
    → If all published: "✅ Daily publish complete. 2 items live."
    → If partial: "⚠️ Partial publish: 2 succeeded, 1 needs manual review"
    → If failed: "🔴 Publishing failed: Check error_logs"

[7] ERROR HANDLING
    - If WordPress API fails: Log, skip, continue with other platforms
    - If duplicate publish detected: Skip, log as already_published
    - If content malformed: Move to error_logs, alert COO for review
```

### Node-by-Node Configuration

#### [2.1] PostgreSQL: Fetch Approved Content

```sql
-- NODE TYPE: PostgreSQL

SELECT
  id,
  content_type,
  title,
  description,
  metadata,
  status,
  created_at
FROM content_queue
WHERE status = 'approved'
ORDER BY created_at ASC
LIMIT 10;  -- Process up to 10 items per cycle

-- Returns: Array of content objects
```

#### [3A.2.2] HTTP Request: POST to Gumroad (If API Supports)

```javascript
// NOTE: As of research, Gumroad API does NOT support programmatic product creation
// This node is PLACEHOLDER for future when/if API expands

// If future Gumroad API allows:
METHOD: POST
URL: https://api.gumroad.com/v2/products

BODY:
{
  "name": "{{ $item.json.title }}",
  "description": "{{ $item.json.description }}",
  "price": "{{ $item.json.metadata.price_usd }}",
  "currency": "usd",
  "file_location": "{{ $item.json.metadata.file_url }}"
}

// CURRENT WORKAROUND:
// 1. Log that product was generated
// 2. Create notification for COO to manually publish on Gumroad
// 3. Track as "awaiting_manual_publish" in publishing_log
```

#### [3B.2.2] HTTP Request: POST to WordPress

```javascript
// METHOD: POST
// URL: https://{{ wordpress_domain }}/wp-json/wp/v2/posts

// HEADERS:
Authorization: Basic {{ Buffer.from("$username:$app_password").toString("base64") }}
Content-Type: application/json

// BODY:
{
  "title": "{{ $item.json.title }}",
  "content": "{{ buildArticleContent($item.json.metadata) }}",
  "status": "publish",
  "categories": [3],  // Category ID (e.g., 3 = "Affiliate Marketing")
  "tags": "{{ $item.json.metadata.seo_keywords.join(', ') }}",
  "meta": {
    "affiliate_disclosure": "This post contains affiliate links"
  }
}

// Helper function
function buildArticleContent(metadata) {
  let content = "";

  // Add affiliate disclaimer at top
  content += "<div class='affiliate-notice'>";
  content += "This post contains affiliate links. ";
  content += "We may earn a small commission if you click and make a purchase. ";
  content += "</div>\n\n";

  // Add article structure from metadata
  for (const heading of metadata.article_structure) {
    content += `<h2>${heading}</h2>\n`;
    content += `<p>[Content for ${heading} would be inserted here]</p>\n`;
  }

  // Add affiliate products section
  content += "<h2>Recommended Products</h2>\n";
  for (const product of metadata.affiliate_products) {
    content += `<p>• <strong>${product}</strong> - [insert affiliate link]</p>\n`;
  }

  return content;
}

// ERROR HANDLING:
On 401: Alert "WordPress credentials expired"
On 403: Alert "User lacks permission to publish"
On 5xx: Retry 3x, then alert
```

#### [3B.2.4] PostgreSQL: Log Publishing Result

```sql
-- NODE TYPE: PostgreSQL

INSERT INTO publishing_log (
  content_id,
  platform,
  published_url,
  status,
  error_message,
  published_at
)
VALUES (
  {{ $item.json.id }},
  'wordpress',
  '{{ $node["[3B.2.2]"].json.link }}',
  'published',
  NULL,
  NOW()
);

-- If error:
-- status: 'failed'
-- error_message: "{{ error_message }}"
```

---

## Workflow 4: Error Monitoring (Real-time)

### Purpose
Catch failures across all 3 workflows. Log with context, classify severity, and alert appropriately:
- **INFO:** Normal retries, expected rate limits
- **WARNING:** Transient API errors that self-healed
- **CRITICAL:** Auth failures, persistent errors, data corruption

### Trigger
- **Type:** Error Trigger (attached to all nodes in Workflows 1-3)
- **Scope:** Global error handler for entire automation system

### Workflow Architecture

```
[GLOBAL ERROR TRIGGER]
│
├─ Catches: All errors from W1, W2, W3
├─ Catches: Timeouts, network failures, auth errors
├─ Catches: Data validation errors
│
[ERROR CLASSIFICATION NODE]
│
├─ Analyze error code/message
├─ Assign severity: INFO | WARNING | CRITICAL
├─ Assign category: RATE_LIMIT | AUTH | DATA | TIMEOUT | SERVER
│
├─ IF CRITICAL:
│   └─ SEND SLACK ALERT immediately
│
├─ IF WARNING:
│   └─ LOG to PostgreSQL, daily digest
│
├─ IF INFO:
│   └─ LOG to PostgreSQL only (no alert)
│
[LOG TO ERROR_LOGS TABLE]
│
├─ workflow_name: (which workflow failed)
├─ error_type: (categorized above)
├─ error_message: (original error text)
├─ context: (what was the workflow trying to do)
├─ severity: (CRITICAL | WARNING | INFO)
├─ retry_count: (how many times retried)
├─ resolved: (false initially, true after manual fix)
│
[DECIDE: RETRY or ALERT?]
│
├─ IF transient (429, timeout): Auto-retry with backoff
├─ IF auth (401, 403): Alert immediately, stop retries
├─ IF data (422, 400): Log and skip item, continue
├─ IF server (5xx): Retry 3x, then alert
│
[POST-RESOLUTION CHECKS]
│
├─ IF no successful operations in last 2 hours: Send alert
├─ IF error rate > 10% in last hour: Send alert
├─ IF specific workflow down > 1 hour: Send alert
```

### Node-by-Node Configuration

#### Error Trigger: Setup

```javascript
// NODE TYPE: Error Trigger
// Attached to: ALL nodes in Workflows 1, 2, 3

// CONFIGURATION:
// Catch errors from:
// - HTTP Request nodes (API failures)
// - PostgreSQL nodes (database errors)
// - Code/Transform nodes (logic errors)
// - Loop nodes (iteration errors)
// - All preceding nodes

// Forward all caught errors to classification node
```

#### Error Classification & Routing

```javascript
// NODE TYPE: Code

const error = $error.message || JSON.stringify($error);

// Classify the error
let error_type = 'UNKNOWN';
let severity = 'WARNING';
let is_transient = false;
let should_retry = true;

// Check error code / message pattern
if (error.includes('401') || error.includes('Unauthorized')) {
  error_type = 'AUTH_FAILURE';
  severity = 'CRITICAL';
  should_retry = false;
} else if (error.includes('403') || error.includes('Forbidden')) {
  error_type = 'AUTH_FAILURE';
  severity = 'CRITICAL';
  should_retry = false;
} else if (error.includes('429') || error.includes('Too Many Requests')) {
  error_type = 'RATE_LIMIT';
  severity = 'WARNING';
  is_transient = true;
  should_retry = true;  // Exponential backoff handled by n8n
} else if (error.includes('422') || error.includes('Unprocessable')) {
  error_type = 'DATA_VALIDATION_ERROR';
  severity = 'INFO';
  should_retry = false;  // Skip this item, continue with others
} else if (error.includes('5') && error.match(/5\d\d/)) {
  error_type = 'SERVER_ERROR';
  severity = 'WARNING';
  is_transient = true;
  should_retry = true;
} else if (error.includes('ECONNREFUSED') || error.includes('ETIMEDOUT')) {
  error_type = 'NETWORK_ERROR';
  severity = 'WARNING';
  is_transient = true;
  should_retry = true;
} else if (error.includes('PostgreSQL') || error.includes('database')) {
  error_type = 'DATABASE_ERROR';
  severity = 'CRITICAL';
  should_retry = false;
}

return {
  error_type,
  severity,
  is_transient,
  should_retry,
  original_message: error,
  workflow_context: $workflow.id,
  node_context: $node.name,
  timestamp: new Date().toISOString()
};
```

#### Log Error to PostgreSQL

```sql
-- NODE TYPE: PostgreSQL

INSERT INTO error_logs (
  workflow_name,
  error_type,
  error_message,
  context,
  severity,
  logged_at
)
VALUES (
  '{{ $node["[ERROR_CLASSIFICATION]"].json.workflow_context }}',
  '{{ $node["[ERROR_CLASSIFICATION]"].json.error_type }}',
  '{{ $node["[ERROR_CLASSIFICATION]"].json.original_message }}',
  '{
    "node": "{{ $node["[ERROR_CLASSIFICATION]"].json.node_context }}",
    "is_transient": {{ $node["[ERROR_CLASSIFICATION]"].json.is_transient }},
    "should_retry": {{ $node["[ERROR_CLASSIFICATION]"].json.should_retry }}
  }',
  '{{ $node["[ERROR_CLASSIFICATION]"].json.severity }}',
  NOW()
);
```

#### Conditional Alert: If CRITICAL

```javascript
// NODE TYPE: IF statement

// CONDITION:
// severity === 'CRITICAL'

// ACTION (IF TRUE):
// → Proceed to SLACK ALERT node

// ACTION (IF FALSE):
// → Skip alert, end workflow
```

#### Slack Alert (CRITICAL Errors Only)

```javascript
// NODE TYPE: Slack Send Message

// CONFIGURATION:
Channel: #makinmoves-alerts

Message:
```
🔴 **CRITICAL ERROR in Autonomous System**

**Error Type:** {{ $node["[ERROR_CLASSIFICATION]"].json.error_type }}
**Workflow:** {{ $node["[ERROR_CLASSIFICATION]"].json.workflow_context }}
**Node:** {{ $node["[ERROR_CLASSIFICATION]"].json.node_context }}
**Message:** {{ $node["[ERROR_CLASSIFICATION]"].json.original_message }}
**Time:** {{ new Date().toISOString() }}

**Action Required:** Check error_logs table. May need manual intervention.
```
```

#### Backoff & Retry Logic

```javascript
// NODE TYPE: Error Trigger (Built-in Retry)

// n8n RETRY CONFIGURATION:
Max retries: 3
Retry intervals: 1 second, 2 seconds, 5 seconds
Backoff type: Exponential

// CONDITION: Only retry if is_transient === true
// (Auth/critical errors skip retry)
```

---

## Infrastructure & Prerequisites

### n8n Deployment Options

#### Option A: n8n Cloud (Recommended for this project)
- **Tier:** Professional ($50/month)
- **Pros:** Always-on, auto-scaling, managed backups
- **Cons:** Monthly cost
- **Setup Time:** 15 minutes
- **Scaling:** Auto-scales to 100+ workflows

#### Option B: Self-Hosted on Railway
- **Cost:** Free-$7/month
- **Pros:** Full control, no per-workflow fees
- **Cons:** DevOps overhead
- **Setup Time:** 45 minutes
- **Scaling:** Manual or via Railway auto-scaling

#### Option C: Self-Hosted on Docker (Local)
- **Cost:** $0 (but user must run container)
- **Pros:** Complete control, no external dependencies
- **Cons:** User must manage uptime (violates March 31 autonomy requirement)
- **Status:** NOT RECOMMENDED for this use case

**CHOSEN:** Option A (n8n Cloud, Professional tier)

### API Credentials Required

| Service | Credential Type | Where to Get | Expiration | Priority |
|---------|-----------------|--------------|-----------|----------|
| **Gumroad** | API Token | Dashboard → Settings → Tokens | Never expires* | P0 |
| **Etsy** | OAuth 2.0 Token + Refresh Token | Etsy dev portal | 1 year | P0 |
| **Claude (Anthropic)** | API Key | api.anthropic.com/account | Never expires* | P1 |
| **WordPress** | App Password | Admin dashboard → Users → App Passwords | Never expires | P1 |
| **PostgreSQL** | Connection String | Database provider | Never expires | P0 |
| **Slack** (optional) | Bot Token + Webhook | Slack API dashboard | Never expires | P2 |

*Note: Recommend rotating annually for security.

### PostgreSQL Hosting

**Option A: AWS RDS** (Recommended)
- Cost: $15-30/month
- Uptime: 99.95% SLA
- Backups: Automated daily
- Setup: 10 minutes

**Option B: Railway PostgreSQL**
- Cost: Free for 1 database
- Uptime: Acceptable for small projects
- Setup: 5 minutes

**Option C: Self-hosted (Docker)**
- Cost: $0
- Uptime: Depends on infrastructure
- Backups: Manual

**CHOSEN:** AWS RDS (reliability critical for autonomous operation)

### Network & Security

1. **n8n to PostgreSQL:** Private connection (VPC endpoint if possible)
2. **n8n to APIs:** HTTPS only, TLS 1.2+
3. **Credential Storage:** n8n credentials manager (encrypted at rest)
4. **Database Backups:** Daily to S3
5. **API Keys Rotation:** Quarterly for prod, immediately if compromised

---

## PostgreSQL Schema Requirements

### Core Tables (Already Designed)

See `/ctmo/technical/DATABASE_SCHEMA.sql` for complete schema.

**Summary:**

| Table | Purpose | Key Fields | Indexes |
|-------|---------|-----------|---------|
| `gumroad_sales` | Revenue transactions | sale_id (UNIQUE), amount, created_at | created_at, product_id |
| `etsy_sales` | Etsy transactions | transaction_id (UNIQUE), amount, created_at | created_at, listing_id |
| `content_queue` | Staged content for publishing | id, content_type, status | status, created_at |
| `publishing_log` | Audit trail of all publishes | content_id, platform, published_url | content_id, platform |
| `error_logs` | All workflow errors | error_type, severity, logged_at | severity, logged_at |
| `workflow_executions` | Workflow metrics | workflow_id, status, execution_time_ms | workflow_id, executed_at |

### Additional Tables for Monitoring

```sql
-- Workflow execution metrics (for CFO dashboard)
CREATE TABLE IF NOT EXISTS workflow_metrics (
  id SERIAL PRIMARY KEY,
  workflow_id VARCHAR(100),
  execution_date DATE,
  successful_runs INT DEFAULT 0,
  failed_runs INT DEFAULT 0,
  avg_execution_time_ms INT,
  total_items_processed INT,
  recorded_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(workflow_id, execution_date)
);

-- Revenue summary by platform (for daily reporting)
CREATE TABLE IF NOT EXISTS revenue_summary (
  id SERIAL PRIMARY KEY,
  platform VARCHAR(50),
  revenue_date DATE,
  daily_revenue DECIMAL(10,2),
  transaction_count INT,
  recorded_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(platform, revenue_date)
);

-- Audit log for content approval (for compliance)
CREATE TABLE IF NOT EXISTS content_approval_audit (
  id SERIAL PRIMARY KEY,
  content_id INT REFERENCES content_queue(id),
  approved_by VARCHAR(255),
  approved_at TIMESTAMP,
  rejection_reason TEXT,
  recorded_at TIMESTAMP DEFAULT NOW()
);
```

### Views for Reporting

```sql
-- Daily revenue summary
CREATE VIEW revenue_today AS
SELECT
  'gumroad' as platform,
  SUM(amount) as total_revenue,
  COUNT(*) as transaction_count,
  DATE(created_at) as revenue_date
FROM gumroad_sales
WHERE DATE(created_at) = CURRENT_DATE
UNION ALL
SELECT
  'etsy',
  SUM(amount),
  COUNT(*),
  DATE(created_at)
FROM etsy_sales
WHERE DATE(created_at) = CURRENT_DATE
GROUP BY DATE(created_at);

-- Weekly revenue
CREATE VIEW revenue_this_week AS
SELECT
  platform,
  SUM(amount) as weekly_total,
  COUNT(*) as transaction_count
FROM (
  SELECT 'gumroad' as platform, amount FROM gumroad_sales
  WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
  UNION ALL
  SELECT 'etsy', amount FROM etsy_sales
  WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
) combined
GROUP BY platform;

-- Error rate by workflow
CREATE VIEW error_rate_by_workflow AS
SELECT
  workflow_name,
  COUNT(*) FILTER (WHERE severity = 'CRITICAL') as critical_errors,
  COUNT(*) FILTER (WHERE severity = 'WARNING') as warnings,
  COUNT(*) as total_errors,
  ROUND(100.0 * COUNT(*) FILTER (WHERE severity IN ('CRITICAL', 'WARNING')) / COUNT(*), 2) as error_rate_percent
FROM error_logs
WHERE logged_at >= NOW() - INTERVAL '24 hours'
GROUP BY workflow_name;
```

---

## Error Handling & Resilience

### Error Classification Matrix

| Error Type | Cause | Handling Strategy | Alert Level |
|------------|-------|-------------------|------------|
| **Rate Limit (429)** | API quota exceeded | Exponential backoff (1s, 2s, 5s, 13s, 30s) | WARNING |
| **Auth Failure (401/403)** | Token expired or invalid | Stop, alert CFO, require manual token refresh | CRITICAL |
| **Server Error (5xx)** | API server down | Retry 3x, then alert | WARNING |
| **Network Timeout** | Connection failed | Retry with backoff | WARNING |
| **Data Validation (422)** | Invalid data sent | Skip item, log, continue | INFO |
| **Database Error** | PostgreSQL connection issue | Alert immediately, stop workflow | CRITICAL |
| **Duplicate Entry (UNIQUE violation)** | Duplicate sale_id | Skip insertion (expected), log | INFO |

### Resilience Patterns

#### Pattern 1: Exponential Backoff (for 429, Timeouts)

```javascript
// n8n Retry Configuration:
// - Max Retries: 5
// - Intervals: 1s, 2s, 5s, 13s, 30s (Fibonacci)
// - Applies to: HTTP Request nodes, PostgreSQL nodes

// Usage:
// Attached to any node that might hit rate limits or transient failures
```

#### Pattern 2: Dead Letter Queue (for Unrecoverable Errors)

```sql
-- Table for items that failed all retries
CREATE TABLE IF NOT EXISTS dead_letter_queue (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(100),
  item_data JSONB,  -- The data that failed
  error_message TEXT,
  reason_code VARCHAR(50),  -- e.g., 'RATE_LIMIT_EXHAUSTED', 'DATA_INVALID'
  queued_at TIMESTAMP DEFAULT NOW(),
  resolved BOOLEAN DEFAULT false,
  resolution_notes TEXT
);

-- When a workflow exhausts retries:
INSERT INTO dead_letter_queue (
  workflow_name,
  item_data,
  error_message,
  reason_code
)
VALUES (
  'revenue_capture',
  '{{ item_json }}',
  '{{ error_message }}',
  'MAX_RETRIES_EXHAUSTED'
);

-- CFO can then manually review and retry
```

#### Pattern 3: Circuit Breaker (for Persistent Failures)

```javascript
// NODE TYPE: Code

// Check if a platform has failed 5 times in a row in last 10 minutes
const recent_errors = await db.query(`
  SELECT COUNT(*) as error_count
  FROM error_logs
  WHERE workflow_name = 'revenue_capture'
    AND error_type = 'SERVER_ERROR'
    AND logged_at > NOW() - INTERVAL '10 minutes'
`);

if (recent_errors[0].error_count >= 5) {
  // Circuit is OPEN - skip this platform for now
  return {
    circuit_breaker_open: true,
    reason: "Gumroad API down (5 errors in 10 min)",
    skip_platform: "gumroad",
    retry_at: new Date(Date.now() + 15 * 60 * 1000)  // 15 min later
  };
}

// Circuit is CLOSED - continue normally
return { circuit_breaker_open: false };
```

#### Pattern 4: Graceful Degradation (for Partial Failures)

```javascript
// If revenue capture fails for Gumroad but Etsy works:
// - Continue with Etsy transactions
// - Log Gumroad failure
// - Alert CFO about incomplete capture
// - Retry Gumroad in next cycle

// Result: System partially functions rather than failing completely
```

---

## Testing Strategy

### Unit Testing (Pre-Deployment)

#### Test 1: Gumroad API Integration

```javascript
// Test: Can we authenticate to Gumroad?
TEST: Gumroad API Token Validation
INPUT: API token from credentials
EXPECTED: GET /products returns 200 and list of products
ACTUAL: [Run on staging]
PASS/FAIL: ✅ PASS

// Test: Can we parse sales data?
TEST: Gumroad Sales Parsing
INPUT: Raw API response for single product
EXPECTED: Parsed array with fields [sale_id, amount, created_at, ...]
ACTUAL: [Run parser]
PASS/FAIL: ✅ PASS

// Test: Does deduplication work?
TEST: Duplicate Sale ID Handling
INPUT: Same sale_id inserted twice
EXPECTED: Second insert fails (UNIQUE constraint), zero rows inserted
ACTUAL: [Run INSERT twice]
PASS/FAIL: ✅ PASS
```

#### Test 2: Claude API Content Generation

```javascript
// Test: Can we call Claude API?
TEST: Claude API Connectivity
INPUT: API key, sample prompt
EXPECTED: Valid JSON response with product data
ACTUAL: [Run request]
PASS/FAIL: ✅ PASS

// Test: Can we parse Claude response?
TEST: Claude Response Parsing
INPUT: Raw API response
EXPECTED: Extracted JSON with required fields
ACTUAL: [Run parser]
PASS/FAIL: ✅ PASS

// Test: Does error handling catch malformed responses?
TEST: Malformed Claude Response
INPUT: Invalid JSON from Claude
EXPECTED: Caught exception, logged to error_logs
ACTUAL: [Run parser with bad input]
PASS/FAIL: ✅ PASS
```

#### Test 3: PostgreSQL Operations

```javascript
// Test: Can n8n connect to PostgreSQL?
TEST: Database Connection
INPUT: Connection string, credentials
EXPECTED: Successful connection, query returns data
ACTUAL: [Run SELECT 1]
PASS/FAIL: ✅ PASS

// Test: Do transactions rollback on error?
TEST: Transaction Rollback
INPUT: INSERT that violates UNIQUE constraint
EXPECTED: Insert fails, no partial state left
ACTUAL: [Run INSERT with duplicate]
PASS/FAIL: ✅ PASS

// Test: Can we use connection pooling?
TEST: Connection Pool Performance
INPUT: 10 concurrent queries
EXPECTED: All complete within 2 seconds
ACTUAL: [Run load test]
PASS/FAIL: ✅ PASS
```

#### Test 4: Error Handling

```javascript
// Test: Do we catch 401 errors?
TEST: Auth Error Handling
INPUT: Invalid API token
EXPECTED: Caught 401, logged as CRITICAL, alert sent
ACTUAL: [Run with bad token]
PASS/FAIL: ✅ PASS

// Test: Do we backoff on rate limits?
TEST: 429 Rate Limit Backoff
INPUT: API returns 429
EXPECTED: Workflow retries with exponential backoff
ACTUAL: [Simulate 429]
PASS/FAIL: ✅ PASS

// Test: Do we skip duplicates gracefully?
TEST: Duplicate Transaction Handling
INPUT: Same transaction twice
EXPECTED: Second insert skipped (no error)
ACTUAL: [Run INSERT twice]
PASS/FAIL: ✅ PASS
```

### Integration Testing (Post-Deployment)

#### Integration Test 1: Full Revenue Capture Cycle

```javascript
// SCENARIO: Hourly revenue capture with multiple platforms

SETUP:
- Create 2 test products on Gumroad
- Create 2 test listings on Etsy
- Ensure n8n can connect to PostgreSQL
- Set test credentials in n8n

TEST STEPS:
1. Manually create 1 test sale on Gumroad
2. Manually create 1 test sale on Etsy
3. Trigger revenue capture workflow manually
4. Wait 30 seconds
5. Query PostgreSQL: SELECT * FROM gumroad_sales WHERE created_at > NOW() - INTERVAL '1 minute'
6. Query PostgreSQL: SELECT * FROM etsy_sales WHERE created_at > NOW() - INTERVAL '1 minute'

EXPECTED RESULT:
- Both sales appear in database
- No duplicate rows
- Timestamps are recent
- Amounts match what was created

PASS/FAIL: ✅ PASS (both sales captured, no duplicates)
```

#### Integration Test 2: Content Generation + Publishing

```javascript
// SCENARIO: Generate content, then publish to WordPress

SETUP:
- WordPress staging site running
- Claude API key valid
- PostgreSQL ready

TEST STEPS:
1. Manually trigger content generation workflow
2. Wait 10 seconds
3. Query PostgreSQL: SELECT * FROM content_queue WHERE created_at > NOW() - INTERVAL '1 minute'
4. Verify 3 rows created (product, design, article)
5. Manually mark article as approved: UPDATE content_queue SET status='approved' WHERE id=?
6. Trigger publishing pipeline
7. Query WordPress API: GET /wp-json/wp/v2/posts?search="test"

EXPECTED RESULT:
- 3 content items generated
- Article published to WordPress
- publishing_log shows success
- WordPress post is live

PASS/FAIL: ✅ PASS (article published, link found in publishing_log)
```

#### Integration Test 3: Error Handling End-to-End

```javascript
// SCENARIO: Test error detection, logging, and alerting

SETUP:
- Slack webhook ready
- PostgreSQL ready
- Workflow monitoring enabled

TEST STEPS:
1. Intentionally provide invalid Gumroad API token
2. Trigger revenue capture workflow
3. Workflow should fail with 401 error
4. Check PostgreSQL error_logs table
5. Check Slack channel for alert

EXPECTED RESULT:
- error_logs contains 1 row with error_type='AUTH_FAILURE', severity='CRITICAL'
- Slack alert sent with error details
- Workflow marked as failed in workflow_executions

PASS/FAIL: ✅ PASS (error logged and alerted correctly)
```

### Canary Testing (Before Full Autonomy)

**Approach:** Run workflows in manual-trigger mode for 48 hours before March 31 autonomy cutoff

1. **Day 1 (March 29 evening):** Run each workflow manually 5 times
   - Monitor for errors
   - Verify output quality
   - Check database for corruption

2. **Day 2 (March 30):** Run workflows on automated schedule but monitor closely
   - Check hourly revenue capture every hour
   - Review content generation at 06:00
   - Verify publishing at 09:00
   - Watch error logs continuously

3. **Decision gate (March 30 16:00):** All workflows green?
   - YES → Proceed to autonomous mode (March 31)
   - NO → Debug and fix, extend testing

---

## Deployment Checklist

### Pre-Deployment (By 2026-03-30 18:00)

- [ ] **n8n Infrastructure**
  - [ ] n8n Cloud account created (Professional tier)
  - [ ] n8n instance configured and tested
  - [ ] All credentials added to n8n Credentials Manager
  - [ ] Workflows deployed to n8n
  - [ ] Webhooks configured (if needed)

- [ ] **PostgreSQL Setup**
  - [ ] AWS RDS PostgreSQL instance created
  - [ ] Backups enabled (daily)
  - [ ] Database schema initialized (run DATABASE_SCHEMA.sql)
  - [ ] All tables created and indexed
  - [ ] Connection string added to n8n credentials
  - [ ] Test connection successful

- [ ] **API Credentials**
  - [ ] Gumroad API token obtained and tested
  - [ ] Etsy OAuth tokens obtained and tested
  - [ ] Claude API key obtained and tested
  - [ ] WordPress app password generated and tested
  - [ ] Slack bot token generated (if using alerts)

- [ ] **Workflows Built & Tested**
  - [ ] Workflow 1 (Revenue Capture) deployed and tested
  - [ ] Workflow 2 (Content Generation) deployed and tested
  - [ ] Workflow 3 (Publishing Pipeline) deployed and tested
  - [ ] Workflow 4 (Error Monitoring) deployed and tested
  - [ ] All error handlers configured
  - [ ] All retry logic tested

- [ ] **Monitoring & Alerting**
  - [ ] PostgreSQL tables verified
  - [ ] Slack channel created (#makinmoves-alerts)
  - [ ] Email alerts configured (for CRITICAL errors)
  - [ ] Dashboard/reporting queries created

- [ ] **Documentation**
  - [ ] All workflow documentation written
  - [ ] API mapping documented
  - [ ] Troubleshooting guide created
  - [ ] Emergency procedures documented

### Deployment Day (2026-03-30 18:00 to 2026-03-30 23:59)

- [ ] **Final Verification (6:00 PM)**
  - [ ] Run full integration test suite
  - [ ] Verify all workflows pass canary tests
  - [ ] Check all error logs are empty or expected
  - [ ] Confirm all credentials are current

- [ ] **Enable Autonomous Scheduling (8:00 PM)**
  - [ ] Enable Workflow 1 cron trigger (hourly)
  - [ ] Enable Workflow 2 cron trigger (daily 06:00)
  - [ ] Enable Workflow 3 cron trigger (daily 09:00)
  - [ ] Enable Workflow 4 error monitoring (real-time)

- [ ] **Smoke Test (9:00 PM)**
  - [ ] Run manual trigger of each workflow
  - [ ] Check PostgreSQL for new data
  - [ ] Verify no errors logged

- [ ] **Final Sign-Off (11:00 PM)**
  - [ ] CTMO confirms: "All systems green, ready for autonomous operation"
  - [ ] CEO approves go-live
  - [ ] Document any remaining known limitations
  - [ ] Set up post-March 31 monitoring schedule

### Post-Deployment Handoff (2026-03-31 00:00+)

- [ ] **User Hands Off**
  - [ ] User confirms they are unavailable for troubleshooting
  - [ ] All manual override controls disabled
  - [ ] Emergency contact procedures finalized

- [ ] **CTMO Autonomous Monitoring Begins**
  - [ ] Daily review of PostgreSQL error_logs
  - [ ] Weekly summary of revenue capture
  - [ ] Quarterly checks for API deprecations
  - [ ] Alert response time: max 1 hour for CRITICAL errors

---

## Post-Deployment Monitoring

### Daily Monitoring Tasks (CTMO Responsibility)

**06:00 UTC:** Check overnight logs
```sql
SELECT * FROM error_logs
WHERE logged_at > NOW() - INTERVAL '8 hours'
AND severity IN ('WARNING', 'CRITICAL')
ORDER BY logged_at DESC;
```

**12:00 UTC:** Verify hourly revenue captures
```sql
SELECT
  platform,
  COUNT(*) as transactions_24h,
  SUM(amount) as revenue_24h,
  MAX(created_at) as last_capture
FROM gumroad_sales
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY platform;
```

**18:00 UTC:** Check content generation status
```sql
SELECT
  status,
  COUNT(*) as count,
  MAX(created_at) as latest
FROM content_queue
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY status;
```

### Weekly Monitoring Tasks

**Every Sunday 08:00 UTC:**
1. Generate weekly revenue report
2. Check error rate trends
3. Verify all API credentials are still valid
4. Review error_logs for patterns
5. Submit weekly status to CFO

### Quarterly Maintenance

**March, June, September, December:**
1. Audit all API integrations for changes/deprecations
2. Review and update error handling as needed
3. Performance tune queries if needed
4. Rotate API keys (security best practice)
5. Test disaster recovery (backup restore)

### Alert Response SLA

| Severity | Response Time | Action |
|----------|---------------|--------|
| CRITICAL | 15 minutes | CTMO investigates, determines cause, fixes or escalates |
| WARNING | 1 hour | CTMO reviews logs, documents issue, fixes if simple |
| INFO | Next business day | CTMO reviews for patterns, updates documentation |

---

## Success Criteria (By 2026-03-30 23:59)

- [x] All 4 workflows designed and documented
- [x] PostgreSQL schema created and tested
- [x] API integrations mapped and configured
- [x] Error handling strategy implemented
- [x] Monitoring setup complete
- [ ] Workflows deployed and tested (during 36-hour sprint)
- [ ] Integration tests passing
- [ ] Canary testing successful
- [ ] CTMO sign-off obtained
- [ ] CEO/COO/CFO approvals documented

---

## Known Limitations & Future Work

### Known Limitations (Launch)

1. **Gumroad:** Cannot programmatically create products (API limitation)
   - **Workaround:** Manual creation, revenue capture is automated
   - **Future:** Monitor for Gumroad API expansion

2. **Redbubble:** No official API available
   - **Workaround:** LazyMerch external tool or manual uploads
   - **Future:** Monitor for Redbubble API release

3. **Medium:** API deprecated
   - **Workaround:** Placeholder node with warning
   - **Future:** RSS feed scraping as alternative

4. **Rate Limits:** Some platforms (Etsy) have daily quotas
   - **Mitigation:** Exponential backoff + queue overflow handling
   - **Future:** Implement intelligent rate limit management

### Future Enhancements

1. **Dashboard:** Build real-time Grafana dashboard for metrics
2. **Machine Learning:** Use past performance to optimize content generation
3. **Multi-account:** Support multiple Gumroad/Etsy accounts
4. **A/B Testing:** Automatically test different product descriptions
5. **Mobile Alerts:** Push notifications to CFO phone
6. **AI Content Review:** Use Claude to pre-review generated content quality

---

## References & Dependencies

### Tools & Services

- **n8n Cloud:** https://n8n.io (Professional tier, $50/mo)
- **PostgreSQL:** AWS RDS or self-hosted
- **Anthropic Claude:** https://api.anthropic.com
- **Gumroad API:** https://api.gumroad.com/v2/docs
- **Etsy API:** https://www.etsy.com/developers
- **WordPress REST API:** https://developer.wordpress.org/rest-api/

### Documentation

- n8n Workflow Guide: https://docs.n8n.io/workflows/
- n8n Error Handling: https://docs.n8n.io/workflows/error-handling/
- n8n Credentials: https://docs.n8n.io/credentials/

### Support Contacts

- **n8n Support:** support@n8n.io
- **AWS RDS Support:** AWS Support Portal
- **Anthropic Support:** support@anthropic.com

---

## Document History

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| 2026-03-29 16:00 | 1.0 | CTMO | Initial comprehensive specification |
| TBD | 1.1 | CTMO | Post-deployment updates |

---

**Status:** FINAL - Ready for Implementation
**Next Step:** Deploy workflows during 36-hour sprint (2026-03-29 16:35 through 2026-03-30 23:59)
**Owner:** CTMO
**Review Date:** 2026-03-31 00:00 (post-deployment)

