# n8n Node Configuration Reference for CTMO

**For:** CTMO workflow implementation
**Status:** Ready to implement
**Reference:** See CEO/research/n8n-automation-architecture.md for full strategy

---

## Quick Start: Node Types

Core nodes you'll use in all 4 workflows:

```
Schedule Trigger → Set → HTTP Request → PostgreSQL → Slack/Error Handler
```

---

## WORKFLOW 1: REVENUE CAPTURE (GUMROAD)

### Node 1: Schedule Trigger
```
Type: Schedule Trigger
Label: "Hourly Gumroad Check"
Interval: Every Minute
Minutes: 60
Timezone: UTC
Execute Once on Startup: FALSE
Trigger on Weekends: TRUE
```

### Node 2: HTTP Request (Gumroad Sales)
```
Name: Gumroad Sales Request
Method: GET
URL: https://api.gumroad.com/v2/sales
Authentication: Header
Headers:
  Authorization: Bearer {{ $secrets.GUMROAD_API_TOKEN }}

Query Parameters:
  from_date: {{ $now.minus({hours: 1}).toISO() }}

Advanced:
  Retry on Fail: YES
  Max Retries: 3
  Wait Between Tries (ms): 1000
  Batch Size: 1
  Batch Interval (ms): 500
```

### Node 3: Set Node (Normalize)
```
Name: Normalize Revenue Data
Keep Only Set Fields: FALSE
Mapping:
  sale_id: $json.id
  product_name: $json.product.name
  amount: $json.price
  currency: $json.currency
  buyer_email: $json.license_key
  timestamp: $json.created_at
  platform: "gumroad"
  captured_at: $now.toISO()
```

### Node 4: Loop Over Items
```
Name: Process Each Sale
Batch Size: 1
Mode: Expression
Expression: {{ $input.all() }}
```

### Node 5: PostgreSQL (Insert Revenue)
```
Name: Log Revenue
Operation: Execute Query
Query:
  INSERT INTO revenue_log
  (sale_id, product_name, amount, currency, buyer_email, timestamp, platform, captured_at)
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8)

Query Parameters:
  [
    "{{ $json.sale_id }}",
    "{{ $json.product_name }}",
    "{{ $json.amount }}",
    "{{ $json.currency }}",
    "{{ $json.buyer_email }}",
    "{{ $json.timestamp }}",
    "{{ $json.platform }}",
    "{{ $json.captured_at }}"
  ]

Batch Mode: Independently
Return Data: Full rows
```

### Node 6: Slack (Success)
```
Name: Notify Revenue Captured
Select a Channel: #automation-alerts
Message Type: Block Kit
Message: Logged {{ $input.all().length }} sales from Gumroad
```

### Node 7: Error Handler
```
Type: Error Trigger workflow
Name: error-revenue-capture
(Separate workflow; see Workflow 4)
```

**Estimated Build Time:** 25 minutes
**Test Data:** 1-2 mock sales in Gumroad

---

## WORKFLOW 2: CONTENT GENERATION (CLAUDE)

### Node 1: Schedule Trigger
```
Type: Schedule Trigger
Label: "Daily Content Generation"
Interval: Every Day
Time: 08:00
Timezone: UTC
Execute Once on Startup: FALSE
```

### Node 2: Set Node (Prepare Prompts)
```
Name: Build Content Request
Keep Only Set: FALSE
Mapping:
  content_type: "blog_post"
  topic: "Building passive income streams with automation"
  platform: "wordpress"
  tone: "informative, encouraging"
  length: "1500 words"
  includes_cta: true
  cta_text: "Try n8n for free"
  keywords: ["automation", "revenue", "n8n"]
```

### Node 3: HTTP Request (Claude API)
```
Name: Claude Content Generation
Method: POST
URL: https://api.anthropic.com/v1/messages
Authentication: Header
Headers:
  x-api-key: {{ $secrets.CLAUDE_API_KEY }}
  content-type: application/json

Body:
{
  "model": "claude-opus-4-1",
  "max_tokens": 2000,
  "temperature": 0.7,
  "system": "You are a content creator specializing in automation and digital products. Write high-quality, actionable content.",
  "messages": [
    {
      "role": "user",
      "content": "Write a {{ $json.length }}-word {{ $json.content_type }} about {{ $json.topic }} in a {{ $json.tone }} tone. Include this CTA: {{ $json.cta_text }}. Keywords: {{ $json.keywords.join(', ') }}"
    }
  ]
}

Retry on Fail: YES
Max Retries: 3
Wait Between Tries (ms): 1000
Batch Size: 1
```

### Node 4: Set Node (Parse Response)
```
Name: Extract Content
Mapping:
  content_body: $json.content[0].text
  platform: $input.first().json.platform
  content_type: $input.first().json.content_type
  generated_at: $now.toISO()
  status: "draft"
  word_count: $json.content[0].text.split(' ').length
```

### Node 5: Set Node (Format for WordPress)
```
Name: Format WordPress Metadata
Mapping:
  title: $json.content_body.split('\n')[0].slice(0, 60)
  content: $json.content_body
  status: "draft"
  type: "post"
  categories: ["automation", "revenue"]
  tags: ["n8n", "no-code", "revenue"]
  excerpt: $json.content_body.split('\n')[1] ?? ""
```

### Node 6: PostgreSQL (Insert Staged Content)
```
Name: Stage Content for Review
Operation: Execute Query
Query:
  INSERT INTO content_staging
  (title, content, platform, status, word_count, generated_at)
  VALUES ($1, $2, $3, $4, $5, $6)
  RETURNING id

Query Parameters:
  [
    "{{ $json.title }}",
    "{{ $json.content }}",
    "{{ $json.platform }}",
    "{{ $json.status }}",
    "{{ $json.word_count }}",
    "{{ $json.generated_at }}"
  ]

Return Data: Full rows
```

### Node 7: Slack (Notification)
```
Name: Notify Content Ready
Channel: #content-queue
Message:
  ✍️ Content Generated: {{ $json.title }}
  Platform: {{ $json.platform }}
  Word Count: {{ $json.word_count }}
  Status: DRAFT (Review in DB)
```

**Estimated Build Time:** 35 minutes
**Test Data:** Single topic; review output before storing

---

## WORKFLOW 3: PUBLISHING (WORDPRESS)

### Node 1: Webhook Trigger
```
Type: Webhook
Label: "Content Ready to Publish"
Webhook Path: /publish-content
Method: POST
Respond When: "Last node in workflow execution"

Expected Payload:
{
  "content_id": 123,
  "platform": "wordpress",
  "status": "ready"
}
```

### Node 2: PostgreSQL (Fetch Staged Content)
```
Name: Get Staged Content
Operation: Execute Query
Query:
  SELECT * FROM content_staging WHERE id = $1

Query Parameters:
  ["{{ $json.content_id }}"]

Return Data: Full rows
```

### Node 3: If Node (Route by Platform)
```
Name: Check Platform
Condition: {{ $json.platform === 'wordpress' }}
Combine with: AND
```

### Node 4: HTTP Request (WordPress POST)
```
Name: Publish to WordPress
Method: POST
URL: https://yoursite.com/wp-json/wp/v2/posts
Authentication: Basic
Username: {{ $secrets.WP_USERNAME }}
Password: {{ $secrets.WP_APP_PASSWORD }}

Headers:
  Content-Type: application/json

Body:
{
  "title": "{{ $json.title }}",
  "content": "{{ $json.content }}",
  "status": "publish",
  "format": "standard",
  "categories": [1, 2],
  "tags": [5, 6]
}

Retry on Fail: YES
Max Retries: 2
```

### Node 5: Set Node (Extract WordPress Response)
```
Name: Extract Live URL
Mapping:
  post_id: $json.id
  live_url: $json.link
  published_at: $now.toISO()
```

### Node 6: PostgreSQL (Update Status)
```
Name: Mark as Published
Operation: Execute Query
Query:
  UPDATE content_staging
  SET status = 'published', published_at = NOW(), published_url = $1
  WHERE id = $2

Query Parameters:
  [
    "{{ $json.live_url }}",
    "{{ $input.first().json.id }}"
  ]
```

### Node 7: Slack (Live Link)
```
Name: Announce Live Post
Channel: #published-content
Message:
  ✅ Live: {{ $json.title }}
  URL: {{ $json.live_url }}
```

**Estimated Build Time:** 40 minutes
**Test Data:** Draft post in WordPress; trigger webhook manually to test

---

## WORKFLOW 4: ERROR MONITORING

### Node 1: Error Trigger
```
Type: Error Trigger
Label: "Catch All Errors"
(Set in Workflow Settings of each main workflow)
```

### Node 2: Set Node (Normalize Error)
```
Name: Classify Error
Mapping:
  error_message: $error.message
  error_code: $error.statusCode
  error_stack: $error.stack
  workflow_name: $execution.workflow
  execution_id: $execution.id
  timestamp: $now.toISO()
  severity: |
    {{
      if($error.statusCode >= 500) {
        'CRITICAL'
      } else if($error.statusCode >= 400) {
        'WARNING'
      } else {
        'INFO'
      }
    }}
```

### Node 3: PostgreSQL (Log Error)
```
Name: Log Error
Operation: Execute Query
Query:
  INSERT INTO error_log
  (error_message, error_code, workflow_name, execution_id, timestamp, severity)
  VALUES ($1, $2, $3, $4, $5, $6)

Query Parameters:
  [
    "{{ $json.error_message }}",
    "{{ $json.error_code }}",
    "{{ $json.workflow_name }}",
    "{{ $json.execution_id }}",
    "{{ $json.timestamp }}",
    "{{ $json.severity }}"
  ]
```

### Node 4: If Node (Severity Check)
```
Name: Check Severity
Condition: {{ $json.severity === 'CRITICAL' }}
Combine with: AND
```

### Node 5a: Slack (Critical Alert) — IF CRITICAL
```
Name: Alert Critical
Channel: #critical-alerts
Message Type: Block Kit
Message:
{
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "🚨 CRITICAL ERROR\nWorkflow: {{ $json.workflow_name }}\nCode: {{ $json.error_code }}\nMessage: {{ $json.error_message }}\nExecution: {{ $json.execution_id }}"
      }
    },
    {
      "type": "actions",
      "elements": [
        {
          "type": "button",
          "text": { "type": "plain_text", "text": "View Logs" },
          "url": "https://your-n8n-instance/executions/{{ $json.execution_id }}"
        }
      ]
    }
  ]
}
```

### Node 5b: Slack (Standard Alert) — ELSE
```
Name: Alert Standard
Channel: #automation-alerts
Message:
  ⚠️ {{ $json.severity }}: {{ $json.workflow_name }}
  {{ $json.error_message }}
```

### Node 6: Respond to Webhook
```
Name: Return Error Response
Status: 500
Headers:
  Content-Type: application/json

Body:
{
  "status": "error",
  "message": "Workflow failed: {{ $json.error_message }}",
  "execution_id": "{{ $json.execution_id }}"
}
```

**Estimated Build Time:** 35 minutes
**Test Data:** Intentionally trigger errors in each workflow to test routing

---

## DATABASE SCHEMA (PostgreSQL)

Create these tables before running workflows:

```sql
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

CREATE TABLE content_staging (
  id SERIAL PRIMARY KEY,
  title VARCHAR(500),
  content TEXT,
  platform VARCHAR(50),
  status VARCHAR(20) DEFAULT 'draft',
  word_count INT,
  generated_at TIMESTAMP,
  published_at TIMESTAMP,
  published_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  INDEX(status, platform)
);

CREATE TABLE error_log (
  id SERIAL PRIMARY KEY,
  error_message TEXT,
  error_code INT,
  workflow_name VARCHAR(255),
  execution_id VARCHAR(255),
  timestamp TIMESTAMP,
  severity VARCHAR(20),
  resolved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  INDEX(workflow_name, timestamp, severity)
);

CREATE TABLE workflow_executions (
  id SERIAL PRIMARY KEY,
  workflow_name VARCHAR(255),
  execution_id VARCHAR(255),
  status VARCHAR(20),
  duration_ms INT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  items_processed INT,
  items_failed INT,
  INDEX(workflow_name, completed_at)
);
```

---

## SECRETS CONFIGURATION

In n8n Settings → Secrets Manager:

```
GUMROAD_API_TOKEN = "your-gumroad-token"
CLAUDE_API_KEY = "sk-ant-v3-your-claude-key"
POSTGRES_HOST = "your-db-host.com"
POSTGRES_USER = "n8n_user"
POSTGRES_PASSWORD = "strong-password"
POSTGRES_DB = "makinmoves_db"
WP_USERNAME = "wp-admin-user"
WP_APP_PASSWORD = "16-char-app-password"
SLACK_WEBHOOK = "https://hooks.slack.com/services/YOUR/WEBHOOK"
```

---

## TESTING CHECKLIST

Before going live:

- [ ] Schedule Trigger fires at correct time
- [ ] HTTP Request gets valid response (check response tab)
- [ ] Set node transforms data correctly (preview)
- [ ] Loop processes all items (check output)
- [ ] PostgreSQL INSERT succeeds (check DB)
- [ ] Slack notification sends with correct data
- [ ] Error workflow triggers on intentional failure
- [ ] Rate limit retry logic works (mock 429 response)
- [ ] Duplicate detection works (test duplicate sale_id)
- [ ] End-to-end test with real data

---

## COMMON ISSUES & FIXES

**Issue:** "API returned 401 Unauthorized"
**Fix:** Check secret key is set; test token expiration

**Issue:** "PostgreSQL: column count mismatch"
**Fix:** Ensure query params match column count; check order

**Issue:** "Gumroad HTTP returns 429 (rate limited)"
**Fix:** Add retry loop; increase batch interval to 1000ms

**Issue:** "Workflow runs but Slack notification doesn't send"
**Fix:** Check Slack webhook URL; test with hardcoded message

**Issue:** "Claude API returns truncated response"
**Fix:** Increase max_tokens in HTTP Request body; check for cost overages

---

**Ready to implement. Test Phase 1 by EOD.**

