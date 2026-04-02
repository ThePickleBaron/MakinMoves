# Content Format Architecture for Autonomous Publishing
**CTMO Technical Decision Document**

**Date:** 2026-03-29
**Timeline:** Implementation in 36-hour sprint (delivery by 2026-03-30 23:59)
**Owner:** CTMO
**Status:** RESEARCH COMPLETE — READY FOR EXECUTION

---

## Executive Summary

To enable autonomous content publishing across 3 streams (Digital Products, Print-on-Demand, Affiliate Articles) without human intervention after March 31, we need:

1. **Single content source of truth** that all streams pull from
2. **Approval workflow** that COO can use WITHOUT touching code or databases
3. **n8n automation** that handles publishing to all platforms
4. **File-based interface** so COO just "drops content in a folder"

**Recommendation:** Hybrid Notion + CSV + File-System approach
- **Notion for drafting** (human-friendly, collaborative, flexible)
- **CSV exports** for structured data (n8n-native, easy to validate)
- **File system (folder approval)** for lightweight publishing triggers
- **PostgreSQL** for revenue tracking (already set up)

---

## RESEARCH FINDINGS

### Content Format Comparison

| Aspect | Notion JSON | CSV | Markdown | Hybrid (Notion→CSV→Files) | Hybrid (Folder-Based) |
|--------|------------|-----|----------|--------------------------|----------------------|
| **Human-friendly input** | ✓✓✓ Best | ✓ Okay | ✓✓ Good | ✓✓✓ Best | ✓ Okay |
| **n8n compatibility** | ✗ No native support | ✓✓✓ Native | ✓✓ Via plugin | ✓✓✓ CSV export | ✓✓ File monitoring |
| **Approval workflow** | ✓ Status column | ✓ Approval column | ✗ Manual | ✓✓ Best: Status in CSV | ✓✓ Folder rename |
| **Scalability** | ✓✓ 100+ items | ✓✓✓ 1000+ items | ✓✓ 100+ items | ✓✓✓ 1000+ items | ✓ 100+ items |
| **Metadata tracking** | ✓✓ Rich properties | ✓ Flat columns | ✓ Frontmatter | ✓✓ All in CSV | ✓ Filename + YAML |
| **Error handling** | ✓ Can see issues | ✓✓ Easy validation | ✓✓ Easy validation | ✓✓✓ Best (CSV rules) | ✓ Via script |
| **COO ease of use** | ✓✓✓ Highest | ✗ Low | ✗ Very low | ✓✓✓ Highest | ✓✓ Medium |
| **Build time** | ✓✓ 6 hours | ✓ 3 hours | ✓ 2 hours | ✓✓ 8 hours | ✓ 4 hours |

---

## CHOSEN ARCHITECTURE: Hybrid Notion→CSV→Folder-Based Approval

### Why This Approach?

1. **Notion is COO's drafting tool** — No learning curve, visual, collaborative
2. **CSV is n8n's native format** — Direct import, validation, error messaging
3. **Folder-based approval is foolproof** — No database flags, no SQL, just move file
4. **PostgreSQL tracks revenue** — Feeds back to Notion for reporting

### Flow Diagram

```
COO WORKFLOW (Human-Friendly):
┌─────────────────────────────────────────┐
│   Notion Workspace (Drafting)           │
│  ├─ Digital Products DB                 │
│  ├─ Print-on-Demand DB                  │
│  └─ Affiliate Articles DB               │
└──────────────┬──────────────────────────┘
               │ (Manual export or webhook)
               ▼
┌─────────────────────────────────────────┐
│   CSV Files in /content/drafts/         │
│  ├─ digital-products-drafts.csv         │
│  ├─ pod-designs-drafts.csv              │
│  └─ affiliate-articles-drafts.csv       │
└──────────────┬──────────────────────────┘
               │ (COO reviews & approves)
               ▼
┌─────────────────────────────────────────┐
│   /content/approved/ (Move files here)  │
│  ├─ digital-products.csv (approved)     │
│  ├─ pod-designs.csv (approved)          │
│  └─ affiliate-articles.csv (approved)   │
└──────────────┬──────────────────────────┘
               │ (n8n polls hourly)
               ▼
┌─────────────────────────────────────────┐
│   n8n Workflows                         │
│  ├─ Publish to Gumroad                  │
│  ├─ Publish to Etsy                     │
│  ├─ Publish to Redbubble                │
│  ├─ Publish to WordPress                │
│  └─ Post to social media                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   Platform Webhooks (Revenue Capture)   │
│  ├─ Gumroad sales → PostgreSQL          │
│  ├─ Etsy orders → PostgreSQL            │
│  ├─ Redbubble orders → PostgreSQL       │
│  └─ WordPress views → PostgreSQL        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   PostgreSQL Dashboard                  │
│  ├─ Revenue Summary                     │
│  ├─ Recovery Tracker                    │
│  └─ Content Performance                 │
└─────────────────────────────────────────┘
```

---

## DETAILED FORMAT SPECS

### 1. DIGITAL PRODUCTS (Notion Templates + Canva)

**CSV Format:** `digital-products.csv`

```csv
product_id,title,description,niche,product_type,price_usd,platform,gumroad_url,etsy_url,notion_url,status,created_date,approved_date,published_date,image_url
DP001,SaaS Founder Project Tracker,Notion template for managing projects and revenue,SaaS Founders,Notion Template,19.99,Gumroad,https://gumroad.com/...,null,https://notion.so/...,approved,2026-03-29,2026-03-29,2026-03-30,https://...
DP002,Freelancer Invoice Template,Canva invoice template for consultants,Freelancers,Canva Template,9.99,Etsy,null,https://etsy.com/...,null,draft,2026-03-29,null,null,https://...
```

**Fields explained:**
- `product_id` — Unique ID (DP001, DP002, etc.)
- `title` — Product name (visible on platform)
- `description` — Full product description (2–3 sentences for Gumroad, keywords for Etsy)
- `niche` — Target audience
- `product_type` — "Notion Template" or "Canva Template"
- `price_usd` — Selling price
- `platform` — Primary platform (Gumroad, Etsy, Notion Marketplace)
- `[platform]_url` — Link to product page (auto-populated by n8n after publishing)
- `status` — "draft", "approved", or "published"
- `created_date` — When content was created
- `approved_date` — When COO approved it (n8n auto-fills)
- `published_date` — When n8n published (auto-filled)
- `image_url` — Link to product preview image

**n8n handling:**
- Read from `/content/approved/digital-products.csv`
- Filter for `status="approved"`
- For each row, check if already published (compare `published_date` with today)
- If not published, upload to platform API (Gumroad, Etsy, Notion)
- Update `published_date` and `[platform]_url` in same file
- Log each action to PostgreSQL

---

### 2. PRINT-ON-DEMAND DESIGNS (Canva + Merch by Amazon/Redbubble)

**CSV Format:** `pod-designs.csv`

```csv
design_id,design_name,niche,shirt_message,image_path,design_colors,merch_asin,redbubble_id,status,created_date,approved_date,published_date,price_usd,units_sold
POD001,DevOps Humor Shirt,DevOps,"YAML is Not Code (It's a Lifestyle)",/designs/devops-01.png,black-white,B0XXXXX,12345678,approved,2026-03-29,2026-03-29,2026-03-30,19.99,0
POD002,Solopreneur Founder Shirt,Founders,"I Lost $50K On This Idea",/designs/founder-01.png,charcoal-red,null,null,draft,2026-03-29,null,null,22.99,0
```

**Fields explained:**
- `design_id` — Unique ID (POD001, POD002)
- `design_name` — Human-readable name
- `niche` — Target community
- `shirt_message` — Main text on shirt
- `image_path` — Local path to Canva export (PNG, 4500x5400px, 300 DPI)
- `design_colors` — Color variants available
- `merch_asin` / `redbubble_id` — Platform product IDs (auto-populated by n8n)
- `status` — "draft", "approved", "published"
- `price_usd` — Selling price
- `units_sold` — Sync from platform webhooks (read-only)

**n8n handling:**
- Monitor `/content/approved/pod-designs.csv`
- For each approved design, check if `merch_asin` is empty
- Upload image to Merch by Amazon and Redbubble APIs
- Capture product IDs and update CSV
- Track units_sold via webhook from platforms (hourly)

---

### 3. AFFILIATE ARTICLES (Blog Posts + Email Copy)

**CSV Format:** `affiliate-articles.csv`

```csv
article_id,title,niche,target_keyword,word_count,outline,internal_links,affiliate_products,wordpress_slug,published_date,url,status,created_date,approved_date,traffic_30d,clicks_30d,earnings_30d
AA001,Best Email Tools for Solopreneurs 2025,Email Marketing,"email marketing tools solopreneurs",2500,"1. Intro (300 words)\n2. Comparison table\n3. Reviews (5 tools)\n4. Conclusion",AA002,ConvertKit(30%),best-email-tools-2025,2026-03-31,https://blog.makinmoves.io/...,approved,2026-03-29,2026-03-29,0,0,0.00
AA002,How to Use ConvertKit for Your Course,Email Marketing,"convert kit course creators",1200,"1. Setup\n2. List building\n3. Integration",AA001,ConvertKit(30%),convertkit-course,null,null,draft,2026-03-29,null,0,0,0.00
```

**Fields explained:**
- `article_id` — Unique ID (AA001, AA002)
- `title` — SEO headline
- `niche` — Content category
- `target_keyword` — Primary SEO keyword
- `word_count` — Target length
- `outline` — Article structure (newline-separated sections)
- `internal_links` — Which other articles to link to
- `affiliate_products` — Format: "ProductName(commission%)" separated by comma
- `wordpress_slug` — URL slug (auto-generated if empty)
- `published_date` — When published (auto-filled)
- `url` — Live WordPress URL (auto-filled)
- `status` — "draft", "approved", "published"
- `traffic_30d`, `clicks_30d`, `earnings_30d` — Synced via Google Analytics + affiliate dashboards

**n8n handling:**
1. Read outline from CSV
2. Call Claude API to expand outline into full article (3–4 hours per article)
3. Add internal links (auto-replace `[AA002]` with actual link)
4. Insert affiliate disclosure
5. Create WordPress post via REST API
6. Update `published_date` and `url` in CSV
7. Schedule social media posts (Twitter, LinkedIn)
8. Poll Google Analytics and affiliate dashboards (daily) for traffic/earnings

---

## APPROVAL WORKFLOW (Zero Code for COO)

### Step 1: COO Creates Content in Notion

**Location:** Shared Notion workspace (created during setup)

**Three databases:**
- `Digital Products` — One row per product template
- `Print-on-Demand Designs` — One row per shirt design
- `Affiliate Articles` — One row per blog post

**Notion structure example (Digital Products DB):**
```
Columns in Notion:
├─ Title (text)
├─ Description (text)
├─ Niche (select)
├─ Product Type (select: "Notion Template" | "Canva Template")
├─ Price (number)
├─ Platform (select: "Gumroad" | "Etsy" | "Notion Marketplace")
├─ Preview Image (file upload)
├─ Status (select: "Draft" | "Ready for Review" | "Approved")
└─ Internal Notes (text)
```

**COO workflow (per product):**
1. Create new row in "Digital Products"
2. Fill in all fields
3. Upload preview image
4. Set `Status = "Ready for Review"`
5. **DONE** — No other action needed

### Step 2: Daily CSV Export (Automated)

**Trigger:** 8:00 AM daily, n8n webhook from Notion API

**Process:**
1. Query Notion database
2. Export to CSV: `/content/drafts/digital-products-drafts.csv`
3. Convert Notion file uploads to URLs in CSV
4. Log export to PostgreSQL

**Result:** Fresh CSV every morning with latest Notion changes

### Step 3: COO Reviews & Approves (Manual, 15 min)

**Process:**
1. COO opens `/content/approved/` folder
2. Opens current CSV in Excel/Sheets
3. Compares with `/content/drafts/` CSV
4. For items to approve:
   - Set `status = "approved"`
   - Set `approved_date = TODAY()`
5. **Save and move file to approved folder**

**File naming:**
- Drafts: `/content/drafts/digital-products-YYYY-MM-DD.csv` (read-only, timestamped)
- Approved: `/content/approved/digital-products.csv` (current working file)

### Step 4: n8n Automatic Publishing

**Trigger:** Every hour, 9:00 AM - 10:00 PM (can run manually anytime)

**Process:**
1. Check if `/content/approved/digital-products.csv` exists
2. Filter rows where `status = "approved"` AND `published_date` is empty
3. For each row:
   - Call platform API (Gumroad, Etsy, etc.)
   - Create product listing
   - Capture product URL
   - Update CSV: `published_date = NOW()`, `[platform]_url = [captured_url]`
   - Update `status = "published"`
   - Log success to PostgreSQL `publishing_log` table
4. If any errors, log to `publishing_errors` table (COO can review)
5. **Email COO summary:** "3 products published, 0 errors"

---

## FILE SYSTEM STRUCTURE

```
/C/Users/jsmcl/documents/makinmoves/MakinMoves-portable/content/

├── drafts/
│   ├── digital-products-YYYY-MM-DD.csv    (read-only, historical)
│   ├── pod-designs-YYYY-MM-DD.csv
│   └── affiliate-articles-YYYY-MM-DD.csv
│
├── approved/
│   ├── digital-products.csv               (ACTIVE — COO edits this)
│   ├── pod-designs.csv                    (ACTIVE)
│   ├── affiliate-articles.csv             (ACTIVE)
│   └── publishing-queue/
│       ├── DP001-gumroad.json            (auto-generated by n8n)
│       └── AA001-wordpress.json
│
├── published/
│   ├── digital-products-published-2026-03-30.csv
│   ├── pod-designs-published-2026-03-30.csv
│   └── affiliate-articles-published-2026-03-30.csv
│
├── images/
│   ├── designs/
│   │   ├── POD001.png (4500x5400px)
│   │   ├── POD002.png
│   │   └── ...
│   ├── products/
│   │   ├── DP001-preview.jpg
│   │   └── ...
│   └── articles/
│       └── (AI-generated cover images)
│
└── logs/
    ├── publishing.log          (n8n publishing history)
    ├── publishing-errors.log   (failures for COO review)
    └── exports.log             (Notion export history)
```

---

## n8n WORKFLOW ARCHITECTURE

### Workflow 1: Daily Content Sync (Notion → Drafts)

**Trigger:** 8:00 AM daily

**Steps:**
1. Query Notion database (Digital Products)
2. Transform to CSV format
3. Save to `/content/drafts/digital-products-YYYY-MM-DD.csv`
4. Log to PostgreSQL: `content_exports` table
5. (Repeat for POD and Articles)

**n8n flow:**
```
Cron (8:00 AM)
  ├─ Notion: Query "Digital Products" DB
  ├─ Code: Transform to CSV format
  ├─ File: Write to /drafts/
  └─ PostgreSQL: Log export
```

### Workflow 2: Hourly Publishing (Approved → Platforms)

**Trigger:** Every hour, 9 AM - 10 PM daily

**Steps:**
1. Read `/content/approved/digital-products.csv`
2. Filter: `status="approved"` AND `published_date` IS NULL
3. For each row:
   a. Call Gumroad API to create product
   b. Capture product URL
   c. Update CSV row: `published_date`, `gumroad_url`, `status="published"`
4. Repeat for POD (Merch by Amazon, Redbubble) and Articles (WordPress)
5. Email summary to COO

**n8n flow:**
```
Cron (hourly)
  ├─ File: Read /approved/digital-products.csv
  ├─ Code: Parse CSV, filter approved items
  ├─ Loop (for each approved item):
  │   ├─ Gumroad: Create product
  │   ├─ Code: Extract URL
  │   └─ File: Update CSV row
  ├─ File: Write updated CSV back
  ├─ PostgreSQL: Log publishing results
  └─ Gmail: Send COO summary
```

### Workflow 3: Revenue Capture (Platform Webhooks → PostgreSQL)

**Trigger:** Real-time webhooks from Gumroad, Etsy, Redbubble, WordPress

**Steps:**
1. Receive webhook from platform (sale, view, click)
2. Parse webhook data
3. Insert into PostgreSQL `revenue_log` table
4. Update product record in `digital_products` / `pod_designs` / `affiliate_articles` tables
5. Update `recovery_tracker` with new total

**n8n flow:**
```
Webhook received (Gumroad sale)
  ├─ Code: Parse webhook
  ├─ PostgreSQL: Insert into revenue_log
  ├─ PostgreSQL: Update product sales count
  ├─ PostgreSQL: Increment recovery_tracker
  └─ PostgreSQL: Log transaction
```

---

## COO INSTRUCTIONS (Copy-Paste Ready)

### Setup (One-time, 30 min)

1. **Create Notion workspace:**
   - Go to notion.so
   - Create new workspace: "MakinMoves Content"
   - Share link with CTMO

2. **Create three databases:**
   - Digital Products (columns listed above)
   - Print-on-Demand Designs (columns listed above)
   - Affiliate Articles (columns listed above)

3. **Create `/content/approved/` folder:**
   ```bash
   mkdir -p /c/Users/jsmcl/documents/makinmoves/MakinMoves-portable/content/approved/
   mkdir -p /c/Users/jsmcl/documents/makinmoves/MakinMoves-portable/content/drafts/
   mkdir -p /c/Users/jsmcl/documents/makinmoves/MakinMoves-portable/content/images/designs/
   ```

### Daily Workflow (10 min)

**Morning (After new CSV is exported):**

1. Open `/content/approved/digital-products.csv` in Excel/Sheets
2. Review each row that has `status="draft"`
3. For items you approve:
   - Change `status` from "draft" to "approved"
   - Leave other fields as-is (n8n fills in dates/URLs)
4. Save file (IMPORTANT: Keep filename exactly `digital-products.csv`)
5. Done! n8n will publish at 9:00 AM

**For PoD designs:**
1. Same as above, but file is `/content/approved/pod-designs.csv`
2. Ensure image file exists at path specified in `image_path` column

**For Articles:**
1. Same as above, but file is `/content/approved/affiliate-articles.csv`
2. Outline column can be multi-line (use "\n" for line breaks)

### Troubleshooting (If publishing fails)

1. Check `/content/logs/publishing-errors.log` for error message
2. Common issues:
   - Missing image file: Ensure image_path points to actual file
   - Invalid price: Must be number with 2 decimals (e.g., 19.99)
   - API key expired: CTMO needs to refresh (contact CTMO)
3. Fix in CSV and re-save; n8n will retry next hour

---

## POSTGRESQL SCHEMA

### Table: `content_products` (unified content tracking)

```sql
CREATE TABLE content_products (
  id UUID PRIMARY KEY,
  content_type VARCHAR(50), -- 'digital-product', 'pod-design', 'affiliate-article'
  title VARCHAR(500),
  niche VARCHAR(100),
  status VARCHAR(20), -- 'draft', 'approved', 'published'
  created_at TIMESTAMP,
  approved_at TIMESTAMP,
  published_at TIMESTAMP,
  platform VARCHAR(50), -- 'gumroad', 'etsy', 'merch', 'redbubble', 'wordpress'
  platform_url TEXT,
  platform_id VARCHAR(500),
  metadata JSONB, -- flexible storage for content-specific fields
  created_by VARCHAR(50),
  CONSTRAINT status_check CHECK (status IN ('draft', 'approved', 'published'))
);
```

### Table: `publishing_log` (audit trail)

```sql
CREATE TABLE publishing_log (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES content_products(id),
  action VARCHAR(50), -- 'published', 'updated', 'error'
  platform VARCHAR(50),
  status_code INT,
  response JSONB,
  timestamp TIMESTAMP DEFAULT NOW()
);
```

### Table: `publishing_errors` (for COO review)

```sql
CREATE TABLE publishing_errors (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES content_products(id),
  error_type VARCHAR(100),
  error_message TEXT,
  retry_count INT DEFAULT 0,
  last_retry_at TIMESTAMP,
  resolved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Setup (Day 1, 4 hours)

- [ ] Create Notion databases (3 templates)
- [ ] Create file system folders (/content/drafts, /content/approved, /content/images)
- [ ] Create PostgreSQL schema (content_products, publishing_log, publishing_errors)
- [ ] Build n8n workflow: Notion → CSV export (test manually first)
- [ ] Test COO approval flow (manual CSV edit + move to /approved/)

### Phase 2: Automation (Day 2, 6 hours)

- [ ] Build n8n workflow: Digital Products → Gumroad API
- [ ] Build n8n workflow: PoD Designs → Merch by Amazon API
- [ ] Build n8n workflow: PoD Designs → Redbubble API
- [ ] Build n8n workflow: Affiliate Articles → WordPress API
- [ ] Build n8n webhook handler: Gumroad sale → PostgreSQL
- [ ] Build n8n workflow: Hourly revenue sync (all platforms)
- [ ] Test each workflow with 1 sample item
- [ ] Set up error logging + email alerts

### Phase 3: Integration Testing (Day 2 evening, 3 hours)

- [ ] End-to-end test: Create article in Notion → Export to CSV → Approve → Publish to WordPress
- [ ] Test revenue capture: Create sale on Gumroad → Webhook fires → PostgreSQL updates
- [ ] Test error handling: Publish invalid item → Error logged → COO sees alert
- [ ] Test CSV update: Published item gets URL and date filled in automatically
- [ ] Verify no manual steps needed after Day 3

### Phase 4: Documentation & Handoff (Day 2, 1 hour)

- [ ] Write COO instructions document
- [ ] Create quick-start guide (1 page)
- [ ] Document all n8n workflows (screenshot + description)
- [ ] Test COO can execute approval workflow without help

---

## KEY TECHNICAL DECISIONS

### Decision 1: Why Not Pure Notion API?

**Rejected:** n8n has limited Notion support (can query, but can't easily publish back)

**Chosen:** Hybrid with CSV because:
- Notion API is unstable for complex operations
- CSV is universally compatible with n8n
- Easy for COO to edit in Excel/Sheets if needed
- Better error messages when validation fails

---

### Decision 2: Why File-Based Approval Instead of Database Flag?

**Rejected:** Database flag (`approved = TRUE`) because COO would need SQL access

**Chosen:** File-based ("move to /approved/ folder") because:
- Zero SQL knowledge required
- Visible (COO can see folder structure)
- Atomic operation (move = approve, simple)
- Easy to rollback (move back to /drafts/)

---

### Decision 3: Why n8n for Publishing, Not Custom Script?

**Rejected:** Custom Node.js script because:
- Need multiple platform APIs (Gumroad, Etsy, WordPress, etc.)
- Error handling is complex (retry logic, webhooks, etc.)
- Takes longer to build and debug

**Chosen:** n8n because:
- Pre-built connectors for all platforms
- Visual workflow builder (easy to debug)
- Built-in error handling + retry logic
- Runs on schedule or webhook (flexible)

---

## REALISTIC TIMELINE

**Setup Phase (Day 1 afternoon, 4 hours):**
- 2:00 PM: CTMO creates Notion databases + file structure
- 3:00 PM: CTMO builds Notion→CSV export workflow
- 4:00 PM: CTMO tests approval workflow with COO (manual CSV edit)
- 5:00 PM: Done, ready for Phase 2

**Automation Phase (Day 2 morning, 6 hours):**
- 6:00 AM: CTMO builds platform APIs (Gumroad, Etsy, WordPress)
- 9:00 AM: CTMO builds publishing workflows (1 per platform)
- 11:00 AM: CTMO tests each workflow with sample items
- 1:00 PM: CTMO integrates revenue webhook handlers
- 2:00 PM: Done, ready for Phase 3

**Integration Testing (Day 2 afternoon, 3 hours):**
- 2:00 PM: CTMO runs end-to-end tests with COO
- 3:30 PM: Fix any issues found
- 4:30 PM: Final verification, system green

**Documentation (Day 2 evening, 1 hour):**
- 5:00 PM: Write COO quick-start guide
- 5:30 PM: Test COO can execute workflow solo
- 6:00 PM: Done, ready for March 31 handoff

---

## FAILURE MODES & MITIGATION

### Risk 1: Notion API Rate Limits (CSV export fails)

**Mitigation:**
- Export only modified rows (incremental sync)
- If export fails, keep previous CSV as fallback
- Alert COO via email if export hasn't run in 24 hours

### Risk 2: Platform API Key Expires (Publishing fails)

**Mitigation:**
- Store API keys in PostgreSQL encrypted column
- Test API key validity at startup
- If expired, pause publishing + email alert to CTMO
- COO can continue approving (queue builds up, auto-resumes when key is refreshed)

### Risk 3: n8n Crashes or Runs Out of Memory

**Mitigation:**
- n8n runs in Docker with 2GB RAM limit
- If out of memory, stop and restart container
- PostgreSQL `publishing_log` stores last successful run timestamp
- Can resume from last successful checkpoint

### Risk 4: Invalid Data in CSV (CSV is malformed)

**Mitigation:**
- n8n CSV parser validates before processing
- If parse fails, log error + email COO
- Invalid rows skipped, valid rows still published
- COO fixes CSV and re-saves; n8n retries next hour

### Risk 5: Race Condition (COO edits CSV while n8n is publishing)

**Mitigation:**
- n8n reads into memory, processes, then writes back atomically
- If write conflicts, n8n waits 5 sec and retries
- Lock file prevents simultaneous access
- Max retry: 3 attempts, then alert COO

---

## EXAMPLE WORKFLOWS (n8n Pseudocode)

### Workflow: Digital Product Publishing (Gumroad)

```javascript
// Trigger: Hourly, 9 AM - 10 PM
// Reads: /content/approved/digital-products.csv

START
├─ File: Read /content/approved/digital-products.csv
├─ Code: Parse CSV
│  └─ Filter rows where status="approved" AND published_date IS NULL
├─ FOR EACH row:
│   ├─ Gumroad API: POST /products
│   │  └─ Payload: {
│   │     name: row.title,
│   │     description: row.description,
│   │     price: row.price_usd,
│   │     file: download(row.notion_url) // Get template file from Notion
│   │  }
│   ├─ Response: product_id, product_url
│   ├─ Code: Update row
│   │  └─ published_date = NOW()
│   │  └─ gumroad_url = product_url
│   │  └─ status = "published"
│   ├─ PostgreSQL: INSERT publishing_log
│   └─ PostgreSQL: INSERT content_products (for revenue tracking)
├─ File: Write updated CSV back to /content/approved/
├─ IF errors exist:
│   ├─ PostgreSQL: INSERT publishing_errors (for each error)
│   └─ Gmail: Send COO error report
├─ Gmail: Send summary email
└─ END
```

### Workflow: Revenue Capture (Gumroad Webhook)

```javascript
// Trigger: POST /webhooks/gumroad (webhook from Gumroad)
// Payload: { product_id, price, quantity, customer_email, timestamp }

START
├─ Code: Parse webhook
├─ PostgreSQL: SELECT content_products WHERE platform_id = product_id
├─ IF NOT found:
│  └─ ERROR: Unknown product, log to publishing_errors
├─ PostgreSQL: BEGIN TRANSACTION
│   ├─ INSERT revenue_log {
│   │    product_id, platform, amount, timestamp, customer_id
│   │  }
│   ├─ UPDATE content_products SET units_sold = units_sold + 1
│   ├─ UPDATE recovery_tracker SET total_revenue = total_revenue + amount
│   └─ COMMIT
├─ PostgreSQL: END TRANSACTION
├─ IF transaction fails:
│   └─ ROLLBACK + log error + retry next hour
└─ END (acknowledge to Gumroad, return 200 OK)
```

---

## NEXT STEPS

### For CTMO (Immediate)

1. **Validate assumptions:** Check if n8n connectors exist for all platforms
   - Gumroad: ✓ Has webhook support
   - Etsy: ✓ Has API
   - Merch by Amazon: ? Might need custom webhook
   - Redbubble: ? Limited API, might need scraping
   - WordPress: ✓ Has REST API

2. **Build POC (Proof of Concept):** Single workflow (Gumroad publishing) to validate approach

3. **Create Notion templates:** Set up 3 databases ready for COO to use

### For COO (Before March 31)

1. **Test approval workflow:** Create 1 test product in Notion, export to CSV, approve, see if publishes
2. **Prepare content:** Draft 10 products, 15 designs, 5 articles (can be outlines)
3. **Set up accounts:** Gumroad, Etsy, Merch by Amazon, WordPress accounts ready

### For CFO (Continuous)

1. **Track content_products table:** Monitor publishing success rate
2. **Monitor recovery_tracker:** Update hourly as revenue comes in
3. **Alert on thresholds:** If $10/day or $100 total revenue reached, notify team

---

## SUCCESS METRICS (By 2026-03-30 23:59)

- ✓ CSV format validated with sample data
- ✓ n8n workflows built and tested (1 per platform)
- ✓ End-to-end flow works: Notion → CSV → Approve → Publish → Revenue tracked
- ✓ COO can approve content without code/SQL
- ✓ Zero manual steps after content approved
- ✓ All errors logged to PostgreSQL
- ✓ COO receives hourly email summary
- ✓ Recovery tracker updates in real-time as revenue comes in

---

## OWNER & ESCALATION

**Owner:** CTMO (Claude Code instance)

**Questions/Issues:** Write to `/ctmo/inbox/`

**Status Updates:** Write standup section of `../board/standups/standup_YYYY-MM-DD_HH-00.md`

---

**Status:** READY FOR IMPLEMENTATION

**Last Updated:** 2026-03-29 16:00

**Next Review:** 2026-03-30 12:00 (midway through 36-hour sprint)
