# MakinMoves — Board Governance
## Operating Entity: ExsituInnovations

> Last updated: 2026-03-29 16:40
> Mission: Generate passive income streams while Jason is relocating, to recover from a rental scam.
> **MODE: AUTONOMOUS OPERATIONS** — See board/decisions/decision_2026-03-29_autonomous_ops.md

---

## ⚡ Autonomous Operations Mandate (2026-03-29)

All roles operate autonomously. **Do not wait for permission, confirmation, or approval** unless costs change. Execute, stay busy, and escalate ONLY if spend deviates from plan. Defaults are final decisions. If blocked, find or create new work. See full directive in board/decisions/.

---

## The Board

MakinMoves operates as a four-role AI-powered executive team. Each role runs as an independent Claude agent with its own inbox, outbox, and operating doc.

| Role | Responsibility | Inbox | Outbox |
|------|---------------|-------|--------|
| CEO | Vision, priorities, capital allocation | CEO/inbox/ | CEO/outbox/ |
| COO | Execution, delivery, operations | COO/inbox/ | COO/outbox/ |
| CTMO | Technology, infrastructure, platforms | CTMO/inbox/ | CTMO/outbox/ |
| CFO | Finance, revenue tracking, cost control | CFO/inbox/ | CFO/outbox/ |

---

## Operating Rules

### Communication Protocol
- All cross-role requests go through inbox/outbox folders
- CEO writes decisions to board/decisions/ — all roles must read before acting
- Standups are filed to board/standups/ hourly (top of hour) by each role
- Format: `standup_YYYY-MM-DD_ROLE.md`

### Decision Authority
- CEO: All strategic decisions, revenue stream prioritization, spend >$100
- COO: Execution decisions, vendor choices, task sequencing
- CTMO: Technology stack, infrastructure, architecture
- CFO: Payment processor selection, pricing, financial modeling

### Cadence
- **Every 5 min:** Each role updates `board/status/status_CURRENT.md` (1 line — current task)
- **Every 30 min:** Full standup filed to `board/standups/standup_YYYY-MM-DD_HHMM_ROLE.md`
- **Every 2 hours:** CEO reviews standups and posts board feedback to `board/reviews/`
- Revenue report: CFO files after every sale event + daily summary in CFO/reports/
- Decision turnaround: CEO responds to escalations within 30 minutes when active
- Cross-role requests: Acknowledged within 15 minutes, resolved within 30 minutes

### Product Development Pipeline (MANDATORY)
Every product must pass through these stages before launch. See `board/decisions/decision_2026-03-29_quality_first.md` for full details.
- **🔬 RESEARCH** (2+ hours min): Market analysis, competitive landscape, demand signals
- **📝 CRITIQUE**: All roles review and file feedback from their domain expertise
- **🔧 REFINE**: Revised spec incorporates all critiques
- **🧪 PROTOTYPE**: Build testable draft
- **✅ LAUNCH READY**: Go/No-Go filed to board/decisions/
- **🚀 LIVE**: Upload, list, market

### Domain Research Requirement
Each role must research modern best practices in their function before contributing to product work:
- **COO**: Launch strategy, Gumroad optimization, conversion best practices
- **CTMO**: Template markets, AI prompt engineering, packaging/delivery tech
- **CFO**: Gumroad economics, pricing psychology, competitor pricing analysis

---

## Revenue Streams

Streams are defined and prioritized by the CEO. See BOARD.md for current status.

| Stream | Status | Owner | Revenue to Date |
|--------|--------|-------|----------------|
| Stream 1 — AI Prompts for Freelancers | 🔬 RESEARCH | COO | $0 |
| Stream 2 — Freelancer Invoice + Client Tracker (Notion) | 🔬 RESEARCH | COO | $0 |
| Stream 3 — n8n Workflow Templates | 🔬 RESEARCH | COO/CTMO | $0 |
| Stream 4 — AI Meeting Transcription SaaS | 🔬 RESEARCH | CTMO | $0 |

---

## Infrastructure (CTMO-managed)

- PostgreSQL 16 — localhost:5432
- n8n automation — http://localhost:5678
- Redis — localhost:6379
- Selenium — localhost:4444
- Docker Compose — auto-restart enabled

---

## File Conventions

- Plans: `COO/execution/plan_YYYY-MM-DD_streamname.md`
- Standups: `board/standups/standup_YYYY-MM-DD_HHMM_ROLE.md`
- Status (live): `board/status/status_CURRENT.md` (overwritten every 5 min)
- Board reviews: `board/reviews/review_YYYY-MM-DD_HHMM.md` (CEO files every 2 hrs)
- Decisions: `board/decisions/decision_YYYY-MM-DD_topic.md`
- Tech architecture: `CTMO/technical/architecture_YYYY-MM-DD.md`
- Revenue reports: `CFO/reports/revenue_YYYY-MM-DD.md`
