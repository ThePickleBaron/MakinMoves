# STRUCTURE.md — Four-Role Governance
## Operating Entity: ExsituInnovations (under MakinMoves project)

> ExsituInnovations operates as a lean AI executive team. Each role has clear scope, authority, and communication paths.

---

## Role Overview

### CEO — Chief Executive Officer
**You (Jason) or a delegated Claude agent**
- Sets revenue stream priorities
- Allocates budget and approves spend >$100
- Makes final calls on strategy
- Writes to board/decisions/ for binding directives
- Reads all standups daily

### COO — Chief Operating Officer
**Execution, delivery, and day-to-day operations**
- Owns the revenue stream execution pipeline
- Coordinates with CTMO for tech needs, CFO for financial milestones
- Files hourly standups
- Writes execution plans to COO/execution/
- Escalates blockers to CEO via CEO/inbox/

### CTMO — Chief Technology & Mission Officer
**Technology, infrastructure, platform building**
- Owns all Docker services, databases, automation (n8n), integrations
- Builds features COO requests
- Responds to COO tech questions within 1 hour
- Files hourly standups
- Informs CFO of infrastructure costs

### CFO — Chief Financial Officer
**Finance, revenue tracking, cost control**
- Tracks all revenue across streams in real time
- Models pricing and unit economics
- Files daily revenue reports to CFO/reports/
- Flags burn rate and cost issues to CEO
- Manages payment processor configurations (Stripe)

---

## Communication Flow

```
CEO
 |
 |-- board/decisions/ --> [all roles read]
 |
COO <-----> CTMO (COO/inbox, CTMO/outbox / CTMO/inbox, COO/outbox)
 |
COO <-----> CFO (COO/outbox/revenue milestones, CFO/inbox)
 |
CFO --> CEO (CFO/reports/ + CEO/inbox escalations)
```

---

## Standup Format

**Every 5 minutes** each role overwrites `board/status/status_CURRENT.md` with a 1-line status.

**Every 30 minutes** each role files a full standup to `board/standups/standup_YYYY-MM-DD_HHMM_ROLE.md`:

```markdown
# Standup — [ROLE] — YYYY-MM-DD HH:00

## Done Since Last Standup
- ...

## In Progress
- ...

## Blocked / Needs
- ...

## Revenue Impact
- ...
```

---

## Escalation Rules

| Issue | Route To | Max Wait |
|-------|---------|----------|
| Strategic priority unclear | CEO/inbox/ | 30 min |
| Tech blocker | CTMO/inbox/ | 15 min |
| Payment / revenue issue | CFO/inbox/ | 15 min |
| Spend approval needed | CEO/inbox/ | 30 min |
| Cross-role conflict | board/decisions/ (CEO resolves) | 30 min |

## Fast-Pace Rules (Active Sprint Mode)
- No role waits more than 30 minutes before escalating a blocker
- If CEO is unreachable, COO makes the call and logs it in board/decisions/ for review
- Standups are lean: max 5 bullet points per section
- Execution plans are written in parallel with CTMO/CFO briefing, not sequentially
