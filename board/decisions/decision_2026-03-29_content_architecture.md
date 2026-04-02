# DECISION: Content Format Architecture for Autonomous Publishing

**Date:** 2026-03-29 17:00 UTC

**Owner:** CTMO

**Status:** APPROVED FOR IMPLEMENTATION

**Timeline:** 36-hour sprint (build by 2026-03-30 23:59)

---

## DECISION

**Approved:** Hybrid Notion→CSV→Folder-Based Approval Architecture

This architecture enables autonomous content publishing to all platforms (Gumroad, Etsy, Merch by Amazon, Redbubble, WordPress) without human intervention after March 31, while keeping the approval workflow simple enough for COO to execute in 10 minutes/day.

---

## WHAT THIS MEANS

### For COO (Human-Facing)
- Create content drafts in Notion (visual, easy)
- Review CSV files in Excel/Sheets (1 per stream)
- Change `status` from "draft" to "approved"
- Save file — **everything else is automatic**

**Time required:** 10 minutes per day

### For CTMO (Automation)
- Build 5 n8n workflows (export, 3x publish, webhooks)
- Create PostgreSQL schema (4 tables for tracking)
- Set up file system structure (`/content/approved/`, `/content/drafts/`, etc.)
- Implement error logging and email alerts

**Time required:** 16 hours (fits in 36-hour window)

### For Platforms
- All platforms receive products/articles via API
- Webhooks send sales data back to PostgreSQL
- No manual data entry after March 31

**Result:** Fully autonomous, 24/7 operation

---

## ARCHITECTURE (High Level)

```
Notion (drafting)
  ↓ (8:00 AM daily)
CSV export (/content/approved/)
  ↓ (COO changes "draft" to "approved")
File-based approval (move file = approve)
  ↓ (9 AM, 12 PM, 3 PM, 6 PM, 9 PM hourly)
n8n publishing
  ├─ Gumroad API (digital products)
  ├─ Etsy API (digital products + PoD)
  ├─ Merch by Amazon API (PoD)
  ├─ Redbubble API (PoD)
  └─ WordPress REST API (articles)
  ↓ (real-time)
Platform webhooks
  └─ PostgreSQL (sales tracking)
  ↓ (automatic)
Recovery tracker (updated hourly)
  └─ Email summary to COO
```

---

## KEY INNOVATION: File-Based Approval

Instead of complex database flags or web interfaces, uses simple file operations:

| Action | What to do |
|--------|-----------|
| **Approve item** | Change CSV: `status="draft"` → `status="approved"` |
| **Reject item** | Leave as `status="draft"` |
| **Save approval** | Press Ctrl+S (save file) |

**Why this works:**
- Zero SQL knowledge required
- Visible and auditable (file timestamps)
- Atomic (can't partially save)
- Easy to rollback (move file back to /drafts/)

---

## COMPARISON TO ALTERNATIVES

### Alternative 1: Database Status Flags
❌ COO needs SQL knowledge
❌ No clear UI for approval
❌ Harder to audit (no file timestamps)

### Alternative 2: Web Dashboard
❌ 10+ hours to build (no time in 36-hour sprint)
❌ Requires login/authentication setup
❌ More complex to maintain

### Alternative 3: Email Approval Links
❌ Security risk (tokens in emails)
❌ Rate limiting on email
❌ No record of what was approved

**Winner:** File-based (simplest, fastest, most auditable)

---

## FORMATS (3 CSV Files)

### 1. Digital Products
```csv
product_id,title,niche,price_usd,platform,status,gumroad_url,published_date
DP001,SaaS Founder Tracker,SaaS Founders,19.99,Gumroad,approved,https://gumroad.com/...,2026-03-30
```

### 2. Print-on-Demand Designs
```csv
design_id,design_name,niche,shirt_message,image_path,status,merch_asin,published_date
POD001,DevOps Humor Shirt,DevOps,"YAML is Not Code",/designs/devops-01.png,approved,B0XXXXX,2026-03-30
```

### 3. Affiliate Articles
```csv
article_id,title,niche,target_keyword,word_count,outline,status,wordpress_slug,published_date
AA001,Best Email Tools,Email Marketing,"email marketing tools",2500,"1. Intro\n2. Reviews\n3. Conclusion",approved,best-email-tools,2026-03-30
```

**Key feature:** Each row has a `status` column that COO changes to trigger publishing.

---

## WORKFLOWS (5 n8n Automations)

| # | Workflow | Trigger | Input | Output | Time |
|---|----------|---------|-------|--------|------|
| A | Notion Export | Daily 8 AM | Notion DB | CSV files | 1 hr |
| B | Publishing | Hourly (9-22) | CSV files | Platform APIs | 3 hrs |
| C | Webhooks | Real-time | Sales data | PostgreSQL | 1 hr |
| D | Article Generation | Daily 7 AM | Outlines | Full articles | 2 hrs |
| E | Revenue Polling | Hourly | Platform APIs | PostgreSQL | 1 hr |

**Total build time:** 8 hours (includes testing)

---

## APPROVAL WORKFLOW (COO's Daily Task)

```
08:00 AM → Email arrives: "Daily Content Sync — 3 items ready"
08:10 AM → Open C:\...\content\approved\digital-products.csv
08:15 AM → Review 3 items (titles, niches, prices look good?)
08:20 AM → Change status: draft → approved for items you like
08:25 AM → Save file (Ctrl+S)
09:00 AM → n8n automatically publishes all approved items
10:00 AM → Email summary: "✓ 3 products published"
```

**Time required:** 10 minutes

**Complexity:** Change one column, save file

**No code, no SQL, no clicking API buttons**

---

## POSTGRESQL TRACKING

Four tables created:

1. **content_products** — All items (products, designs, articles)
2. **revenue_log** — Every sale (timestamp, amount, product_id)
3. **publishing_log** — Every publish action (success/failure, platform, response)
4. **publishing_errors** — Failed publishes (for COO to review)

**Result:** Complete audit trail + real-time revenue tracking

---

## FILE SYSTEM STRUCTURE

```
/content/
├── approved/              ← COO edits these
│   ├── digital-products.csv
│   ├── pod-designs.csv
│   └── affiliate-articles.csv
│
├── drafts/                ← Historical exports (read-only)
│   ├── digital-products-2026-03-29.csv
│   ├── digital-products-2026-03-30.csv
│   └── ...
│
├── images/
│   ├── designs/           ← Canva exports (PoD)
│   │   ├── POD001.png
│   │   └── ...
│   └── products/          ← Preview images
│       └── ...
│
├── articles/              ← Generated blog posts
│   ├── AA001.md
│   └── ...
│
└── logs/
    ├── publishing.log     ← n8n publishing history
    ├── publishing-errors.log
    └── exports.log
```

---

## IMPLEMENTATION PLAN (36-Hour Sprint)

### Phase 1: Setup (Day 1, 4 hours)
- [ ] Create Notion databases (3 templates)
- [ ] Create file system folders
- [ ] Create PostgreSQL schema
- [ ] Build n8n Workflow A (export)

### Phase 2: Automation (Day 2 morning, 6 hours)
- [ ] Build n8n Workflow B (publish to 4 platforms)
- [ ] Build n8n Workflow C (webhook handlers)
- [ ] Test each workflow with sample data

### Phase 3: Integration (Day 2 afternoon, 3 hours)
- [ ] End-to-end test (Notion → CSV → Approve → Publish)
- [ ] Error handling verification
- [ ] COO executes workflow solo

### Phase 4: Documentation (Day 2 evening, 1 hour)
- [ ] Write COO quick-start guide
- [ ] Document all workflows
- [ ] Create troubleshooting guide

**Buffer:** 5.5 hours for contingencies

**Total:** 19.5 hours (fits in 36-hour window)

---

## SUCCESS CRITERIA (By 2026-03-30 23:59)

✓ CSV formats validated with sample data (≥1 item per stream)
✓ n8n workflows built and tested (≥3 platforms working)
✓ End-to-end flow: Notion → CSV → Approve → Publish → PostgreSQL
✓ COO can approve content in <10 minutes without developer help
✓ Publishing errors logged and alerting works
✓ Recovery tracker updates in real-time as revenue comes in
✓ All documentation complete and reviewed by COO

---

## RISKS & MITIGATIONS

| Risk | Mitigation |
|------|-----------|
| API key expires | Test at startup, store in PostgreSQL encrypted |
| n8n crashes | Restart Docker, resume from checkpoint in PostgreSQL |
| CSV becomes corrupted | Historical backups in /drafts/ folder |
| Platform API rate limit | Stagger requests, implement backoff logic |
| COO misapproves content | CTMO reviews weekly, can unpublish if needed |
| Webhook unreliability | Supplement with hourly polling (Workflow E) |

---

## COST ANALYSIS

### Infrastructure
- PostgreSQL: $0 (already running in Docker)
- n8n: $0 (already running in Docker, self-hosted)
- Storage: Negligible (<$1/month)

### Platform Fees
- Gumroad: 10% + payment processor fees (only on sales)
- Etsy: $0.20/listing + 6.5% fee
- Merch by Amazon: 40-50% royalty (varies)
- Redbubble: $0-97/month (based on earnings)
- WordPress: $0 (self-hosted)

**Total:** $0-20/month (minimal, only pay on sales)

---

## NEXT STEPS

### Immediate (Now)
1. CTMO reads all specification documents
2. CTMO validates Merch by Amazon API capabilities
3. COO prepares 3-5 test items in Notion

### Tomorrow (2026-03-30)
1. CTMO executes build phases 1-4 (16 hours focused work)
2. COO tests approval workflow with CTMO
3. Board verifies success criteria

### Go Live (2026-03-31)
1. User hands-off at midnight
2. Autonomous operation begins (no human input)
3. Systems run 24/7 without intervention

---

## DECISION AUTHORITY

**Approved by:** CTMO (Chief Technology & Mission Officer)

**Validated by:** Research summary (see `/ctmo/technical/RESEARCH_SUMMARY_2026-03-29.md`)

**Specifications:**
- Full architecture: `/ctmo/technical/content_format_architecture_2026-03-29.md`
- Workflow details: `/ctmo/technical/n8n_workflow_skeletons_2026-03-29.md`
- COO guide: `/coo/content_approval_quickstart_2026-03-29.md`

**Implementation owner:** CTMO

**Success owner:** CTMO (delivery) + COO (approval workflow)

---

## ALIGNMENT WITH CONSTRAINTS

✓ **User hands-off March 31:** System fully autonomous by then
✓ **36-hour sprint:** 19.5 hours build time fits window
✓ **Zero human intervention after March 31:** n8n handles all publishing
✓ **Low cost:** $0-20/month (all fees are revenue-dependent)
✓ **Existing infrastructure:** Uses Docker, PostgreSQL, n8n already deployed

---

## APPROVAL

**Decision:** APPROVED

**Timeline:** Start build 2026-03-29 14:00, complete by 2026-03-30 23:59

**Next review:** 2026-03-30 12:00 (midpoint standup)

**Go-live:** 2026-03-31 00:00 (autonomous operation begins)

---

**Owner:** CTMO

**Status:** READY FOR IMPLEMENTATION

**Last updated:** 2026-03-29 17:00 UTC
