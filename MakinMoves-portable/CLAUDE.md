# MakinMoves — Portable Revenue Recovery Toolkit

## Overview
Self-contained, dockerized passive income platform for building and automating multiple revenue streams. Designed for autonomous operation with minimal daily maintenance.

## Working Directory
- **Root:** `C:\Users\jsmcl\Documents\MakinMoves\MakinMoves-portable`
- **Data:** `./data/` (persistent across sessions)
- **Logs:** `./logs/` (Docker logs available via `npm run docker:logs`)

## Key Services (Docker)
All services run in containers and are automatically managed:

| Service | URL | Credentials | Purpose |
|---------|-----|-------------|---------|
| **PostgreSQL** | `localhost:5432` | `makinmoves` / `changeme123` | Primary database for all streams |
| **n8n** | `http://localhost:5678` | `admin` / `changeme123` | Workflow automation (email, scraping, integrations) |
| **Redis** | `localhost:6379` | (none) | Caching, queues, background jobs |
| **Selenium** | `localhost:4444` | (none) | Web scraping automation |
| **VNC Viewer** | `http://localhost:7900` | (none) | Watch scraping live (for debugging) |

## Database Schemas
- **digital_products** — Products, sales tracking
- **saas** — Projects, subscriber management
- **content** — Sites, articles, affiliate links, revenue
- **trading** — Strategies, trade execution, P&L
- **public** — Revenue summary, recovery tracker

## Directory Structure

```
MakinMoves-portable/
├── CLAUDE.md                    ← Project instructions (this file)
├── docker-compose.yml           ← Service definitions
├── package.json                 ← Node.js dependencies
├── .mcp.json                    ← MCP server configuration
├── .env                         ← Environment variables (create as needed)
├── .env.example                 ← Template for .env
├── .gitignore
│
├── docker/
│   └── init-db.sql              ← Database initialization
│
├── data/
│   ├── .gitkeep
│   ├── makinmoves.db            ← SQLite cache (if using)
│   └── exports/                 ← CSV/JSON exports
│
├── scripts/
│   ├── start.sh                 ← Quick start (handles Docker + npm)
│   ├── db-migrate.js            ← Database migrations
│   └── health-check.js          ← Service health monitoring
│
├── tools/
│   ├── dashboard.js             ← Revenue dashboard
│   ├── scraper.js               ← Web scraping utility
│   ├── content-generator.js     ← AI content generation
│   ├── niche-researcher.js      ← Market research automation
│   └── views/
│       └── dashboard.ejs        ← Dashboard template
│
├── projects/
│   ├── digital-products/
│   │   ├── CLAUDE.md            ← Stream-specific instructions
│   │   ├── plan.md              ← Strategy & setup guide
│   │   ├── product-ideas.md     ← Brainstorming & templates
│   │   └── platforms.md         ← Gumroad, Etsy, Shopify guides
│   │
│   ├── saas/
│   │   ├── CLAUDE.md
│   │   ├── plan.md
│   │   ├── micro-saas-template.js
│   │   ├── deployment-guide.md
│   │   └── metrics.md           ← MRR, CAC, LTV tracking
│   │
│   ├── content/
│   │   ├── CLAUDE.md
│   │   ├── plan.md
│   │   ├── niche-ideas.md
│   │   ├── seo-checklist.md
│   │   ├── affiliate-networks.md
│   │   └── platforms.md         ← WordPress, Ghost, Astro guides
│   │
│   └── trading/
│       ├── CLAUDE.md
│       ├── plan.md
│       ├── bot-template.js
│       ├── strategies.md
│       ├── risk-management.md
│       └── backtest-results.md
│
├── inbox/                       ← Questions for user/coordinator
├── outbox/                      ← Answers & instructions from user
├── logs/                        ← Session status logs
└── .claude/
    └── settings.json            ← Claude Code configuration
```

## Quick Start

### 1. First Run (one-time setup)
```bash
bash scripts/start.sh
```
This will:
- ✓ Check Docker is running
- ✓ Start all containers
- ✓ Wait for PostgreSQL
- ✓ Install npm dependencies

### 2. Subsequent Runs
```bash
npm run docker:up    # Start services
npm run docker:logs  # View live logs
```

### 3. Common Commands
```bash
npm run dashboard           # Open revenue dashboard
npm run scrape              # Run web scraping job
npm run db:migrate          # Run database migrations
npm run docker:reset        # Full reset (erases data)
```

## Environment Setup

Create `.env` in root with:
```bash
# Database
POSTGRES_PASSWORD=changeme123

# n8n
N8N_USER=admin
N8N_PASSWORD=changeme123

# API Keys (for integrations)
BRAVE_API_KEY=              # For search automation
GITHUB_PERSONAL_ACCESS_TOKEN= # For code updates
STRIPE_API_KEY=             # For payment processing
STRIPE_WEBHOOK_SECRET=      # For webhooks
```

## Workflow Per Session
1. Start services: `bash scripts/start.sh` (or `npm run docker:up` if already running)
2. Check for new instructions in `inbox/`
3. Work on highest-priority task in a `projects/*/` directory
4. Log status to `logs/status_YYYY-MM-DD.md`
5. If blocked, create question file in `inbox/`
6. Never commit sensitive data (use `.env` instead)

## Per-Stream Instructions
Each revenue stream has its own CLAUDE.md:
- `projects/digital-products/CLAUDE.md`
- `projects/saas/CLAUDE.md`
- `projects/content/CLAUDE.md`
- `projects/trading/CLAUDE.md`

Reference these for stream-specific setup, strategies, and best practices.

## Principles
- **Low daily maintenance** — Automation-first, minimal manual work
- **Low/no startup cost** — Free tiers preferred, no ads/marketing spend
- **Diversified income** — Multiple streams reduce platform risk
- **Transparent tracking** — All revenue logged in PostgreSQL for dashboard
- **Autonomous operation** — Designed for hands-off, recurring tasks

## Data Safety
- `data/` directory is ignored by git (never commit user data)
- Database backups should be exported weekly via `npm run dashboard`
- Use `.env` for secrets, never commit credentials
- Docker volumes persist across container restarts

## Help & Logs
- Service logs: `npm run docker:logs`
- Docker status: `docker ps`
- Health check: `node scripts/health-check.js`
- Database: Connect with `psql -h localhost -U makinmoves -d makinmoves`

---
**Last Updated:** 2026-03-29
