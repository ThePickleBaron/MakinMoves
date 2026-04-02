# CTMO — EXPANDED Work Queue with Concrete Deliverables
**Time Block:** 8:15 PM – 9:00 PM (45 minutes)
**Deliverables:** 4 concrete technical documents/specs with measurable outputs

---

## PRIMARY DELIVERABLE (8:15 PM)
**File:** `./technical/ARCHITECTURE_SPEC_MAKINMOVES.md`
- Complete tech stack specification
- System architecture diagram (ASCII or link to diagram)
- Integration flows mapped
- **Fingerprint:** CTMO owns this architecture document

---

## BLOCK 1: Architecture & Integration Spec (8:15–8:30 PM)
**Deliverable #1: `ARCHITECTURE_SPEC_MAKINMOVES.md`** (15 min)

Create markdown with:

```
# MakinMoves Architecture Specification
Date: [Today]
Version: 1.0
Owner: CTMO

## System Overview
```
MakinMoves-Portable
├── Frontend (TBD: Customer landing pages)
├── Backend (Node.js + Express)
├── Database (PostgreSQL)
├── Automation (Zapier, n8n)
├── Payment (Stripe)
├── Email (ConvertKit/SendGrid)
└── CRM (HubSpot)
```

## Technology Stack
| Layer | Technology | Cost | Rationale |
|-------|-----------|------|-----------|
| Backend | Node.js + Express | Free | Rapid API development |
| Database | PostgreSQL | $15/mo | Reliable, scales well |
| Cache | Redis | Free (local) | In-memory caching |
| Email | ConvertKit | $29/mo | Email + landing pages |
| CRM | HubSpot | Free tier | Contact management |
| Automation | Zapier | Free tier | Workflow automation |
| Payments | Stripe | 2.9% + $0.30 | Industry standard |

## Integration Flows

### P1: Gumroad Sales to Revenue Tracking
Gumroad (webhook) → Node.js API → PostgreSQL (sales table) → CFO dashboard

### P2: Client Intake to Project Management
Typeform (form) → Zapier → HubSpot (contact) → Email (reminder) → Manual invoice

### P3: Article Publishing to Affiliate Tracking
Ghost/WordPress (publish) → Affiliate link plugin → Tracking DB → CFO dashboard

## Database Schema Overview
```
Tables to create:
- digital_products.sales (gumroad transactions)
- freelance.clients (P2 client list)
- freelance.projects (active projects)
- content.articles (P3 articles)
- content.revenue (affiliate commissions)
- public.revenue_summary (aggregate revenue)
```

## API Endpoints (TBD)
POST /api/sales/track (log Gumroad purchase)
POST /api/projects/create (new P2 project)
GET /api/revenue/summary (CFO dashboard)

## Security Considerations
- API key authentication (Stripe, Zapier)
- Database password management
- HTTPS for all customer-facing endpoints
- PII handling (client data retention policy)

## Scaling Concerns
- PostgreSQL can handle 10,000+ transactions/month easily
- Zapier free tier limited to X tasks/month (monitor)
- Node.js backend can handle 1000+ concurrent requests
```

**Output file format:** `./technical/ARCHITECTURE_SPEC_MAKINMOVES.md`
**Fingerprint:** CTMO's architecture document

**Post to standup: 8:30 PM** with file path

---

## BLOCK 2: Database Schema & Documentation (8:30–8:42 PM)
**Deliverable #2: `DATABASE_SCHEMA.sql`** (12 min)

Create SQL file with all table definitions:

```sql
-- MakinMoves Database Schema
-- Created by CTMO
-- Date: [Today]

-- P1: Gumroad Products & Sales
CREATE TABLE digital_products.products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2),
  gumroad_id VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE digital_products.sales (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES digital_products.products(id),
  buyer_email VARCHAR(255),
  amount DECIMAL(10,2),
  currency VARCHAR(3),
  sale_date TIMESTAMP,
  gumroad_transaction_id VARCHAR(255) UNIQUE
);

-- P2: Freelance Writing
CREATE TABLE freelance.clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  company VARCHAR(255),
  niche VARCHAR(100),
  monthly_retainer DECIMAL(10,2),
  status VARCHAR(50), -- active, prospect, lost, closed
  created_at TIMESTAMP
);

CREATE TABLE freelance.projects (
  id SERIAL PRIMARY KEY,
  client_id INT REFERENCES freelance.clients(id),
  project_name VARCHAR(255),
  articles_per_month INT,
  start_date DATE,
  status VARCHAR(50), -- active, completed, paused
  mrr DECIMAL(10,2)
);

-- P3: Affiliate Sites
CREATE TABLE content.sites (
  id SERIAL PRIMARY KEY,
  domain_name VARCHAR(255) UNIQUE,
  niche VARCHAR(100),
  hosting_provider VARCHAR(100),
  monthly_visitors INT DEFAULT 0,
  created_at TIMESTAMP
);

CREATE TABLE content.articles (
  id SERIAL PRIMARY KEY,
  site_id INT REFERENCES content.sites(id),
  title VARCHAR(255),
  slug VARCHAR(255) UNIQUE,
  target_keyword VARCHAR(255),
  target_keyword_difficulty INT,
  published_at TIMESTAMP,
  traffic_last_30days INT DEFAULT 0
);

CREATE TABLE content.affiliate_programs (
  id SERIAL PRIMARY KEY,
  site_id INT REFERENCES content.sites(id),
  program_name VARCHAR(255),
  commission_rate DECIMAL(5,2),
  monthly_earnings DECIMAL(10,2) DEFAULT 0,
  status VARCHAR(50) -- active, pending, rejected
);

-- Revenue Summary (for CFO dashboard)
CREATE TABLE public.revenue_summary (
  id SERIAL PRIMARY KEY,
  stream VARCHAR(50), -- P1, P2, P3
  amount DECIMAL(10,2),
  revenue_date DATE,
  source VARCHAR(255) -- gumroad, freelance_client_abc, affiliate_site_xyz
);

-- Indexes for performance
CREATE INDEX idx_sales_date ON digital_products.sales(sale_date);
CREATE INDEX idx_client_status ON freelance.clients(status);
CREATE INDEX idx_article_published ON content.articles(published_at);
```

**Output file format:** `./technical/DATABASE_SCHEMA.sql`
**Fingerprint:** CTMO's database design

**Post to standup: 8:42 PM** with file path

---

## BLOCK 3: Cost Optimization & Scaling Analysis (8:42–8:55 PM)
**Deliverable #3: `INFRASTRUCTURE_COST_ANALYSIS.csv`** (13 min)

Create CSV comparing cost options:

```
Tool,Current_Option,Current_Cost/mo,Lean_Option,Lean_Cost/mo,Premium_Option,Premium_Cost/mo,Recommendation,Scaling_Limit
Email,ConvertKit,$29,Substack,$0,ConvertKit,$29,"Start Substack free, migrate to ConvertKit at 1000 subs",1000 contacts
CRM,HubSpot Free,$0,Airtable Free,$0,Pipedrive Free,$0,"Use HubSpot free tier, upgrade if 100+ contacts",500 contacts
Hosting,Bluehost,$3.95,Namecheap,$1,SiteGround,$2.99,"Use Namecheap for P3 sites, scale to SiteGround at 50k visitors",50000 visitors/mo
Database,PostgreSQL (Docker),$0,SQLite,$0,Railway PostgreSQL,$15,"Run PostgreSQL locally in Docker, migrate to Railway at scale",100000 records
Automation,Zapier Free,$0,n8n (self-hosted),$0,Zapier Pro,$50,"Use Zapier free (100 tasks/mo), self-host n8n when needed",100 tasks/mo
Payments,Stripe,$0,Stripe,$0,Stripe,$0,"No setup fee, pay per transaction (2.9% + $0.30)",Unlimited
Total,Current,$57.95,Lean Budget,$1,Premium Stack,$96.99,Recommendation,
```

Include:
- Free tier limits for each tool
- When to upgrade (trigger: customer count, visitors, transactions)
- Migration path (if switching later)
- ROI of premium tier (is premium worth $30–50/mo?)

**Output file format:** `./technical/INFRASTRUCTURE_COST_ANALYSIS.csv`
**Fingerprint:** CTMO's cost optimization document

**Post to standup: 8:55 PM** with file path

---

## BLOCK 4: Infrastructure Setup & Scaling Roadmap (8:55–9:00 PM)
**Deliverable #4: `SETUP_GUIDE_AND_SCALING_ROADMAP.md`** (5 min)

Create guide with:

```
# Infrastructure Setup & Scaling Roadmap

## Current Setup (Month 1–2: Free Tier)
1. Node.js app running locally or on free Heroku dyno
2. PostgreSQL local instance (or free tier Cloud SQL)
3. Zapier free tier (100 tasks/month)
4. Stripe connected (no monthly fee)
5. ConvertKit free tier (up to 1000 subscribers)
6. HubSpot free tier (up to 500 contacts)

Estimated cost: $30–60/month

## Scale 1: Growing Revenue (Month 3–4)
Triggers: Revenue >$5k/mo OR database >100k records OR Zapier tasks >80/mo

Actions:
- Upgrade ConvertKit to paid ($29) at 1000+ subscribers
- Self-host PostgreSQL on Railway ($15/mo) instead of local
- Add monitoring/logging (Sentry free tier)
- Set up automated backups

Estimated cost: $45–75/month

## Scale 2: Team & Production (Month 5–6)
Triggers: Revenue >$15k/mo OR 5+ team members OR 100k+ customers

Actions:
- Production Node.js app on Heroku ($7/mo) or Railway ($15/mo)
- PostgreSQL production database (Railway $15/mo)
- Content Delivery Network for P3 sites (Cloudflare free tier)
- Advanced monitoring (DataDog, New Relic - evaluate ROI)

Estimated cost: $100–150/month

## Scale 3: Enterprise (Year 2+)
Triggers: Revenue >$50k/mo OR 50+ team members OR 1M+ customers

Actions:
- Kubernetes or managed container service
- Data warehouse (BigQuery, Redshift)
- Custom analytics platform
- Dedicated DevOps/SRE role

This decision deferred to Year 2 (revisit based on actual growth)

## Critical Infrastructure Health Checks
Monthly (first Friday):
- [ ] All systems operational (no 404s, 500s)
- [ ] Database backups current
- [ ] API response time acceptable (<200ms)
- [ ] Zapier workflows executing without errors
- [ ] Stripe webhooks confirming transactions

Weekly (Monday standup):
- [ ] Database space usage
- [ ] Zapier task count (vs. free tier limit)
- [ ] Email deliverability (ConvertKit bounce rate)
```

**Output file format:** `./technical/SETUP_GUIDE_AND_SCALING_ROADMAP.md`
**Fingerprint:** CTMO's operational guide

**Post to standup: 9:00 PM** with file path

---

## DELIVERABLES SUMMARY

| Deliverable | Format | Content | Owner | Fingerprint |
|-------------|--------|---------|-------|-------------|
| 1. Architecture Spec | Markdown | Full tech stack, flows, APIs | CTMO | System design |
| 2. Database Schema | SQL | All table definitions | CTMO | Data model |
| 3. Cost Analysis | CSV | Free vs. paid vs. premium, scaling triggers | CTMO | Budget planning |
| 4. Setup & Scaling | Markdown | Implementation guide, health checks | CTMO | Operations manual |

**All files stored in:** `./technical/` directory and linked from standup updates

---

## POSTING PATTERN (With Fingerprints)

- **8:15 PM:** File creation: `ARCHITECTURE_SPEC_MAKINMOVES.md` — CTMO files primary deliverable
- **8:30 PM:** Standup update with ARCHITECTURE_SPEC link + summary
- **8:42 PM:** File creation: `DATABASE_SCHEMA.sql` + `INFRASTRUCTURE_COST_ANALYSIS.csv` — standup with links
- **8:55 PM:** File creation: `SETUP_GUIDE_AND_SCALING_ROADMAP.md` — standup with link
- **9:00 PM:** Final standup with all 4 deliverable links + infrastructure health status

**Fingerprints visible in:** `./technical/` directory (all CTMO-owned specs/guides)

---

## VALIDATION CRITERIA

✅ Architecture spec is **complete and implementable** (COO can execute from it)
✅ Database schema is **normalized and scalable** (will handle 10x growth)
✅ Cost analysis is **honest** (free tier limits, not hidden)
✅ Setup guide is **step-by-step** (someone else could follow it)
✅ Scaling triggers are **quantified** (not vague: "when we get big")

**Success = CTMO owns 4 technical documents that COO and CFO reference during execution**
