# n8n Workflow Skeletons — Implementation Reference

**Status:** Detailed specifications for building 5 core workflows

**Owner:** CTMO

**Timeline:** 6-8 hours to build all workflows

---

## Overview of Workflows

| Workflow | Trigger | Input | Output | Platform |
|----------|---------|-------|--------|----------|
| Workflow A | Daily 8:00 AM | Notion DB | CSV file | Notion→File |
| Workflow B | Hourly 9-22:00 | CSV file | API calls | CSV→Gumroad/Etsy/WordPress |
| Workflow C | Real-time webhook | JSON payload | PostgreSQL | Platform→PostgreSQL |
| Workflow D | Manual trigger | Notion DB | Article content | Notion→Claude API→WordPress |
| Workflow E | Hourly | Platform APIs | CSV update | Platforms→PostgreSQL |

---

## WORKFLOW A: Daily Notion Export to CSV

**Purpose:** Sync Notion databases to CSV files for COO approval

**Trigger:** Cron job at 8:00 AM daily

**Build time:** 1 hour

### Flow Structure

```
┌─ Cron (Daily 8:00 AM)
│
├─ Notion API: Query "Digital Products" DB
│  └─ Filter: All rows (or only modified since last export)
│
├─ Code: Transform to CSV format
│  ├─ Map Notion properties → CSV columns
│  ├─ Handle file URLs (download and store locally)
│  └─ Format dates as YYYY-MM-DD
│
├─ File: Write to `/content/drafts/digital-products-YYYY-MM-DD.csv`
│  └─ Timestamp filename for history
│
├─ (Repeat above for POD Designs and Affiliate Articles)
│
├─ PostgreSQL: Insert into `content_exports` table
│  └─ Record: export_id, stream, item_count, status, timestamp
│
├─ Gmail: Send COO summary email
│  ├─ Subject: "Daily Content Sync — X items ready"
│  ├─ Body: List of new items in each stream
│  └─ CTA: "Review in /content/approved/"
│
└─ END
```

### n8n Node Configuration

**Node 1: Cron (Trigger)**
```json
{
  "type": "trigger",
  "name": "Cron - 8:00 AM Daily",
  "cronExpression": "0 8 * * *",
  "timezone": "UTC"
}
```

**Node 2: Notion - Query Database**
```json
{
  "type": "notion",
  "operation": "database-query",
  "databaseId": "{{ NOTION_DB_DIGITAL_PRODUCTS }}",
  "filters": {
    "property": "Modified Time",
    "condition": "greater_than",
    "value": "{{ $now.subtract(24,'hours').toISOString() }}"
  }
}
```

**Node 3: Code - Transform to CSV**
```javascript
// Input: Array of Notion database items
// Output: CSV string

const items = $input.all()[0].json.results;

const headers = [
  'product_id',
  'title',
  'description',
  'niche',
  'product_type',
  'price_usd',
  'platform',
  'gumroad_url',
  'etsy_url',
  'status',
  'created_date',
  'approved_date',
  'published_date'
];

let csv = headers.join(',') + '\n';

items.forEach((item) => {
  const props = item.properties;

  const row = [
    item.id.slice(0, 8).toUpperCase(), // product_id (use part of Notion ID)
    props.Title?.title?.[0]?.text?.content || '',
    props.Description?.rich_text?.[0]?.text?.content || '',
    props.Niche?.select?.name || '',
    props['Product Type']?.select?.name || '',
    props.Price?.number || '',
    props.Platform?.select?.name || '',
    props['Gumroad URL']?.url || '',
    props['Etsy URL']?.url || '',
    props.Status?.select?.name || 'draft',
    props['Created']?.created_time?.slice(0, 10) || '',
    props['Approved Date']?.date?.start || '',
    props['Published Date']?.date?.start || ''
  ];

  // Escape quotes in CSV fields
  csv += row.map(field =>
    typeof field === 'string' && field.includes(',')
      ? `"${field.replace(/"/g, '""')}"`
      : field
  ).join(',') + '\n';
});

return { csv: csv };
```

**Node 4: File - Write to Drafts**
```json
{
  "type": "file",
  "operation": "write",
  "filePath": "/content/drafts/digital-products-{{ $now.format('YYYY-MM-DD') }}.csv",
  "fileContent": "{{ $input.json.csv }}"
}
```

**Node 5: PostgreSQL - Log Export**
```sql
INSERT INTO content_exports (
  export_id,
  stream,
  item_count,
  export_status,
  created_at
) VALUES (
  gen_random_uuid(),
  'digital-products',
  {{ $input.json.item_count }},
  'success',
  NOW()
);
```

**Node 6: Gmail - Send Summary Email**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "user@makinmoves.io",
  "subject": "Daily Content Sync — {{ $input.json.digital_product_count }} items ready",
  "html": "<p>New items awaiting review in /content/approved/</p><p><strong>Digital Products:</strong> {{ $input.json.digital_product_count }}</p><p><strong>PoD Designs:</strong> {{ $input.json.pod_count }}</p>"
}
```

---

## WORKFLOW B: Hourly Publishing to Platforms

**Purpose:** Monitor /content/approved/ folder and publish approved items

**Trigger:** Cron job hourly (9 AM - 10 PM)

**Build time:** 2-3 hours (build 1 per platform, then repeat)

### Flow Structure (Generic)

```
┌─ Cron (Hourly 9-22:00)
│
├─ File: Read `/content/approved/digital-products.csv`
│
├─ Code: Parse CSV
│  └─ Filter: status="approved" AND published_date IS NULL
│
├─ FOR EACH approved item:
│   ├─ [PLATFORM] API: Create product listing
│   │  └─ Payload: title, description, price, image, etc.
│   │
│   ├─ Code: Extract platform_id and product_url from response
│   │
│   ├─ Code: Update CSV row
│   │  ├─ published_date = NOW()
│   │  ├─ [platform]_url = [captured_url]
│   │  └─ status = "published"
│   │
│   ├─ PostgreSQL: Log publishing action
│   │  └─ INSERT publishing_log
│   │
│   └─ IF ERROR:
│       └─ PostgreSQL: Log error
│           └─ INSERT publishing_errors
│
├─ File: Write updated CSV back
│
├─ IF errors_occurred:
│   └─ Gmail: Send error report to CTMO
│
├─ Gmail: Send summary to COO
│  └─ "✓ 3 products published, 0 errors"
│
└─ END
```

### n8n Node Configuration (Gumroad Example)

**Node 1: Cron (Trigger)**
```json
{
  "type": "trigger",
  "name": "Cron - Hourly 9-22",
  "cronExpression": "0 9-22 * * *"
}
```

**Node 2: File - Read CSV**
```json
{
  "type": "file",
  "operation": "read",
  "filePath": "/content/approved/digital-products.csv"
}
```

**Node 3: Code - Parse and Filter**
```javascript
// Input: CSV file content
// Output: Array of approved items

const csv = $input.json.content;
const lines = csv.trim().split('\n');
const headers = lines[0].split(',');

const items = [];
for (let i = 1; i < lines.length; i++) {
  const values = lines[i].split(',');
  const item = {};
  headers.forEach((header, idx) => {
    item[header.trim()] = values[idx]?.trim() || '';
  });

  // Filter: approved and not yet published
  if (item.status === 'approved' && !item.published_date) {
    items.push(item);
  }
}

return { items: items, count: items.length };
```

**Node 4: Loop - For Each Item**
```json
{
  "type": "loop",
  "iterations": "{{ $input.json.items.length }}"
}
```

**Node 5: Gumroad API - Create Product (Inside Loop)**
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://api.gumroad.com/v2/products",
  "auth": "Bearer {{ $env.GUMROAD_API_KEY }}",
  "body": {
    "name": "{{ $input.json.items[$loop.index].title }}",
    "description": "{{ $input.json.items[$loop.index].description }}",
    "price": "{{ $input.json.items[$loop.index].price_usd }}",
    "product_type": "subscription",
    "currency": "usd"
  }
}
```

**Node 6: Code - Extract URL and Update Row (Inside Loop)**
```javascript
// Input: Gumroad API response + current CSV
// Output: Updated row data

const gumroadResponse = $input.json;
const currentItem = $input.json.current_item; // passed from previous node

const updatedItem = {
  ...currentItem,
  gumroad_url: gumroadResponse.product.url,
  platform_id: gumroadResponse.product.id,
  published_date: new Date().toISOString().slice(0, 10),
  status: 'published'
};

return { updated_item: updatedItem };
```

**Node 7: PostgreSQL - Log Publishing (Inside Loop)**
```sql
INSERT INTO publishing_log (
  id,
  product_id,
  action,
  platform,
  status_code,
  response,
  timestamp
) VALUES (
  gen_random_uuid(),
  '{{ $input.json.current_item.product_id }}',
  'published',
  'gumroad',
  200,
  '{{ JSON.stringify($input.json.gumroadResponse) }}',
  NOW()
);
```

**Node 8: Code - Rebuild CSV with Updates (After Loop)**
```javascript
// Input: Original CSV + all updated items
// Output: CSV with published items marked

const originalCsv = $input.json.original_csv;
const updatedItems = $input.json.updated_items; // Array from loop

const lines = originalCsv.trim().split('\n');
const headers = lines[0];

let newCsv = headers + '\n';

for (let i = 1; i < lines.length; i++) {
  const values = lines[i].split(',');
  const productId = values[0];

  // Check if this item was updated
  const updated = updatedItems.find(item => item.product_id === productId);

  if (updated) {
    // Reconstruct row with updated values
    const newRow = [
      updated.product_id,
      updated.title,
      updated.description,
      updated.niche,
      updated.product_type,
      updated.price_usd,
      updated.platform,
      updated.gumroad_url,
      updated.etsy_url,
      updated.status,
      updated.created_date,
      updated.approved_date,
      updated.published_date
    ];
    newCsv += newRow.join(',') + '\n';
  } else {
    // Unchanged row
    newCsv += lines[i] + '\n';
  }
}

return { updated_csv: newCsv };
```

**Node 9: File - Write Updated CSV**
```json
{
  "type": "file",
  "operation": "write",
  "filePath": "/content/approved/digital-products.csv",
  "fileContent": "{{ $input.json.updated_csv }}"
}
```

**Node 10: Gmail - Send Summary**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "coo@makinmoves.io",
  "subject": "✓ Publishing Summary — {{ $input.json.success_count }} items published",
  "html": "<p><strong>{{ $input.json.success_count }}</strong> products published successfully.</p><p><strong>Errors:</strong> {{ $input.json.error_count }}</p>"
}
```

---

## WORKFLOW C: Real-Time Revenue Capture (Webhook Handler)

**Purpose:** Listen for sales webhooks from platforms and update PostgreSQL

**Trigger:** HTTP POST webhook from Gumroad/Etsy/Redbubble

**Build time:** 1 hour

### Flow Structure

```
┌─ Webhook: POST /webhooks/gumroad
│
├─ Code: Validate webhook signature (security)
│
├─ Code: Parse webhook payload
│  └─ Extract: product_id, amount, customer, timestamp
│
├─ PostgreSQL: Lookup product in content_products
│  └─ Check if product exists
│
├─ IF product found:
│   ├─ PostgreSQL: BEGIN TRANSACTION
│   │  ├─ INSERT revenue_log
│   │  ├─ UPDATE content_products (units_sold++)
│   │  ├─ UPDATE recovery_tracker (total_revenue += amount)
│   │  └─ COMMIT
│   │
│   └─ HTTP: Respond 200 OK to Gumroad
│
├─ IF product NOT found:
│   ├─ PostgreSQL: INSERT publishing_errors
│   └─ HTTP: Respond 400 Bad Request
│
└─ END
```

### n8n Node Configuration

**Node 1: Webhook (Trigger)**
```json
{
  "type": "webhook",
  "httpMethod": "POST",
  "path": "webhooks/gumroad",
  "authentication": "bearer_token",
  "bearerToken": "{{ $env.WEBHOOK_SECRET }}"
}
```

**Node 2: Code - Validate & Parse Webhook**
```javascript
// Input: HTTP POST body from Gumroad
// Output: Parsed data

const payload = $input.json.body;

// Validate required fields
if (!payload.product_id || !payload.price || !payload.customer_email) {
  throw new Error('Missing required fields in webhook');
}

return {
  product_id: payload.product_id,
  amount: parseFloat(payload.price),
  customer_email: payload.customer_email,
  timestamp: new Date().toISOString(),
  platform: 'gumroad'
};
```

**Node 3: PostgreSQL - Lookup Product**
```sql
SELECT
  id,
  title,
  platform_id
FROM content_products
WHERE platform_id = '{{ $input.json.product_id }}'
LIMIT 1;
```

**Node 4: If/Then - Check if Product Exists**
```json
{
  "type": "if",
  "condition": "{{ $input.json.rows.length > 0 }}"
}
```

**Node 5: PostgreSQL - Insert Revenue Log (If Product Found)**
```sql
INSERT INTO revenue_log (
  id,
  product_id,
  platform,
  amount,
  customer_id,
  transaction_timestamp,
  created_at
) VALUES (
  gen_random_uuid(),
  '{{ $input.json.rows[0].id }}',
  '{{ $input.json.platform }}',
  {{ $input.json.amount }},
  '{{ md5($input.json.customer_email) }}',
  '{{ $input.json.timestamp }}',
  NOW()
);
```

**Node 6: PostgreSQL - Update Content Product (If Product Found)**
```sql
UPDATE content_products
SET
  units_sold = units_sold + 1,
  metadata = jsonb_set(
    metadata,
    '{last_sale}',
    to_jsonb(NOW())
  )
WHERE id = '{{ $input.json.rows[0].id }}';
```

**Node 7: PostgreSQL - Update Recovery Tracker (If Product Found)**
```sql
UPDATE recovery_tracker
SET
  total_revenue = total_revenue + {{ $input.json.amount }},
  updated_at = NOW()
WHERE goal_amount = 10000;
```

**Node 8: HTTP Response - Success (If Product Found)**
```json
{
  "type": "http",
  "statusCode": 200,
  "body": { "status": "success", "amount_processed": "{{ $input.json.amount }}" }
}
```

**Node 9: PostgreSQL - Log Error (If Product NOT Found)**
```sql
INSERT INTO publishing_errors (
  id,
  error_type,
  error_message,
  created_at
) VALUES (
  gen_random_uuid(),
  'webhook_unknown_product',
  'Webhook received for unknown product: {{ $input.json.product_id }}',
  NOW()
);
```

**Node 10: HTTP Response - Error (If Product NOT Found)**
```json
{
  "type": "http",
  "statusCode": 400,
  "body": { "error": "Product not found" }
}
```

---

## WORKFLOW D: Daily Content Generation (Claude API → WordPress)

**Purpose:** Expand article outlines into full articles using Claude API

**Trigger:** Daily at 7:00 AM (before publishing workflow runs)

**Build time:** 2 hours

### Flow Structure

```
┌─ Cron (Daily 7:00 AM)
│
├─ File: Read `/content/approved/affiliate-articles.csv`
│
├─ Code: Filter articles with status="approved" AND article_content IS NULL
│
├─ FOR EACH outline:
│   ├─ Claude API: Expand outline to full article
│   │  ├─ Prompt: "Expand this outline into a 1500-word article: [outline]"
│   │  ├─ Model: claude-3-5-sonnet
│   │  └─ Tokens: Max 4000
│   │
│   ├─ Code: Format article with frontmatter
│   │  ├─ Add metadata (title, tags, excerpt)
│   │  ├─ Insert affiliate links (from CSV)
│   │  └─ Add FTC disclosure
│   │
│   ├─ File: Save article to `/content/articles/[article_id].md`
│   │
│   ├─ Code: Update CSV
│   │  ├─ article_content_generated = true
│   │  └─ generated_at = NOW()
│   │
│   └─ PostgreSQL: Log content generation
│
├─ File: Write updated CSV
│
└─ END
```

### n8n Node Configuration

**Node 1: Cron (Trigger)**
```json
{
  "type": "trigger",
  "name": "Cron - Daily 7 AM",
  "cronExpression": "0 7 * * *"
}
```

**Node 2: File - Read Articles CSV**
```json
{
  "type": "file",
  "operation": "read",
  "filePath": "/content/approved/affiliate-articles.csv"
}
```

**Node 3: Code - Parse and Filter**
```javascript
const csv = $input.json.content;
const lines = csv.trim().split('\n');
const headers = lines[0].split(',');

const outlines = [];
for (let i = 1; i < lines.length; i++) {
  const values = lines[i].split(',');
  const item = {};
  headers.forEach((h, idx) => {
    item[h.trim()] = values[idx]?.trim() || '';
  });

  // Only generate if no content exists yet
  if (item.status === 'approved' && !item.article_content) {
    outlines.push(item);
  }
}

return { outlines: outlines };
```

**Node 4: Loop - For Each Article Outline**
```json
{
  "type": "loop",
  "iterations": "{{ $input.json.outlines.length }}"
}
```

**Node 5: Claude API - Generate Full Article (Inside Loop)**
```json
{
  "type": "anthropic",
  "model": "claude-3-5-sonnet",
  "prompt": "You are a professional blog writer. Expand the following outline into a full, SEO-optimized article (1500-1800 words). Include 2-3 affiliate links naturally. Write in a conversational but professional tone.\n\nTitle: {{ $input.json.outlines[$loop.index].title }}\nOutline:\n{{ $input.json.outlines[$loop.index].outline }}\n\nAffiliate products to mention: {{ $input.json.outlines[$loop.index].affiliate_products }}\n\nStart with an engaging introduction that hooks the reader. Use subheadings (H2) to break up content. End with a conclusion and call-to-action.",
  "maxTokens": 4000
}
```

**Node 6: Code - Format Article with Frontmatter (Inside Loop)**
```javascript
const articleContent = $input.json.content;
const outline = $input.json.outlines[$loop.index];

const frontmatter = `---
title: "${outline.title}"
slug: ${outline.wordpress_slug || outline.title.toLowerCase().replace(/\s+/g, '-')}
excerpt: "{{ outline.excerpt || 'Learn about ' + outline.niche }}"
date: ${new Date().toISOString()}
category: ${outline.niche}
tags: [${outline.target_keyword}, automation, tools]
---

${articleContent}

---

**Disclosure:** I earn a commission if you purchase through the affiliate links in this article at no extra cost to you. This helps support my work.`;

return { formatted_article: frontmatter, filename: outline.article_id };
```

**Node 7: File - Save Article Markdown**
```json
{
  "type": "file",
  "operation": "write",
  "filePath": "/content/articles/{{ $input.json.filename }}.md",
  "fileContent": "{{ $input.json.formatted_article }}"
}
```

**Node 8: Code - Update CSV Row (Inside Loop)**
```javascript
const outline = $input.json.outlines[$loop.index];

return {
  article_id: outline.article_id,
  article_content: 'generated',
  generated_at: new Date().toISOString().slice(0, 10),
  word_count: outline.word_count
};
```

**Node 9: PostgreSQL - Log Content Generation (Inside Loop)**
```sql
INSERT INTO content_generation_log (
  id,
  article_id,
  model,
  tokens_used,
  generated_at
) VALUES (
  gen_random_uuid(),
  '{{ $input.json.article_id }}',
  'claude-3-5-sonnet',
  {{ $input.json.tokens_used }},
  NOW()
);
```

**Node 10: Code - Rebuild CSV (After Loop)**
```javascript
// Similar to Workflow B, reconstruct CSV with generated articles marked
const originalCsv = $input.json.original_csv;
const generatedArticles = $input.json.generated_articles;

// [Implementation similar to Workflow B Node 8]
```

**Node 11: File - Write Updated CSV**
```json
{
  "type": "file",
  "operation": "write",
  "filePath": "/content/approved/affiliate-articles.csv",
  "fileContent": "{{ $input.json.updated_csv }}"
}
```

---

## WORKFLOW E: Hourly Revenue Sync (Platform APIs → PostgreSQL)

**Purpose:** Poll platform dashboards for updated sales/earnings data

**Trigger:** Cron job every hour (during business hours)

**Build time:** 1.5 hours

### Flow Structure

```
┌─ Cron (Hourly 9 AM - 10 PM)
│
├─ FOR EACH platform (Gumroad, Etsy, Redbubble):
│   ├─ [PLATFORM] API: Get sales since last sync
│   │  ├─ Filter: sales_timestamp > last_sync_timestamp
│   │  └─ Return: product_id, amount, quantity, timestamp
│   │
│   ├─ PostgreSQL: For each sale, insert/update revenue_log
│   │
│   ├─ PostgreSQL: Update content_products (units_sold, revenue)
│   │
│   └─ PostgreSQL: Update last_sync_timestamp
│
├─ PostgreSQL: Calculate recovery progress
│  └─ Update recovery_tracker with new totals
│
├─ PostgreSQL: Query dashboard data
│  └─ Summary: Total revenue, items sold, earnings this hour
│
└─ END
```

### n8n Node Configuration (Gumroad Example)

**Node 1: Cron (Trigger)**
```json
{
  "type": "trigger",
  "name": "Cron - Hourly",
  "cronExpression": "0 9-22 * * *"
}
```

**Node 2: PostgreSQL - Get Last Sync Time**
```sql
SELECT last_sync_timestamp
FROM sync_state
WHERE platform = 'gumroad'
ORDER BY updated_at DESC
LIMIT 1;
```

**Node 3: Gumroad API - Get Sales Since Last Sync**
```json
{
  "type": "http",
  "method": "GET",
  "url": "https://api.gumroad.com/v2/sales",
  "auth": "Bearer {{ $env.GUMROAD_API_KEY }}",
  "query": {
    "after": "{{ $input.json.rows[0].last_sync_timestamp }}"
  }
}
```

**Node 4: Code - Parse Sales Data**
```javascript
const sales = $input.json.sales || [];

const parsed = sales.map(sale => ({
  product_id: sale.product_id,
  product_name: sale.product_name,
  amount: parseFloat(sale.price),
  quantity: sale.quantity || 1,
  customer_email: sale.customer.email,
  timestamp: sale.created_at,
  platform: 'gumroad'
}));

return { sales: parsed, count: parsed.length };
```

**Node 5: Loop - For Each Sale**
```json
{
  "type": "loop",
  "iterations": "{{ $input.json.sales.length }}"
}
```

**Node 6: PostgreSQL - Upsert Revenue Log (Inside Loop)**
```sql
INSERT INTO revenue_log (id, product_id, platform, amount, customer_id, transaction_timestamp, created_at)
VALUES (
  gen_random_uuid(),
  '{{ $input.json.sales[$loop.index].product_id }}',
  'gumroad',
  {{ $input.json.sales[$loop.index].amount }},
  '{{ md5($input.json.sales[$loop.index].customer_email) }}',
  '{{ $input.json.sales[$loop.index].timestamp }}',
  NOW()
)
ON CONFLICT (product_id, customer_id, transaction_timestamp) DO NOTHING;
```

**Node 7: PostgreSQL - Update Sync State (After Loop)**
```sql
UPDATE sync_state
SET
  last_sync_timestamp = NOW(),
  updated_at = NOW()
WHERE platform = 'gumroad';
```

**Node 8: PostgreSQL - Aggregate Revenue Data**
```sql
SELECT
  SUM(amount) as total_revenue,
  COUNT(*) as transactions,
  COUNT(DISTINCT product_id) as products_sold
FROM revenue_log
WHERE platform = 'gumroad'
AND transaction_timestamp > NOW() - INTERVAL '1 hour';
```

---

## IMPLEMENTATION PRIORITY

**Phase 1 (First 2 hours):**
1. Workflow A: Notion → CSV export (foundation, needed for approval)

**Phase 2 (Next 3 hours):**
2. Workflow B (Part 1): CSV → Gumroad (single platform, test flow)
3. Workflow C: Webhook handler (real-time revenue capture)

**Phase 3 (Next 2 hours):**
4. Workflow B (Part 2-4): Add Etsy, Redbubble, WordPress (duplicate from Part 1)

**Phase 4 (Next 1.5 hours):**
5. Workflow D: Claude API → Article generation (optional but useful)
6. Workflow E: Platform polling (supplementary to webhooks)

---

## TESTING CHECKLIST

For each workflow:
- [ ] Nodes are connected correctly (no missing links)
- [ ] API credentials are set in environment variables
- [ ] Error handling is in place (try/catch or if/then)
- [ ] Test with sample data (not live data)
- [ ] Verify CSV output is valid (can open in Excel)
- [ ] Check PostgreSQL inserts (query the table afterwards)
- [ ] Verify email is sent (check inbox)
- [ ] Run workflow 2-3 times (idempotency check)

---

## DEBUGGING TIPS

**If workflow fails:**
1. Check n8n error message (Details tab)
2. Verify API credentials (test connection first)
3. Check if file exists (file path typo?)
4. Check PostgreSQL connection (can query from n8n test?)
5. Look at input/output of each node (use "Test" button)

**If CSV doesn't update:**
1. Check file permissions (can n8n write to folder?)
2. Verify CSV format (proper commas, no extra quotes)
3. Check loop is executing (should show X iterations)

**If revenue isn't captured:**
1. Check webhook is registered (Gumroad dashboard)
2. Verify webhook URL is correct (should point to n8n instance)
3. Check PostgreSQL transaction commits (query revenue_log table)

---

**Status:** READY FOR BUILD

**Owner:** CTMO

**Questions:** Reference `content_format_architecture_2026-03-29.md` for full context
