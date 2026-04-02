# MakinMoves Board Structure — Updated 2026-03-29

## Four-Role Governance

```
┌─────────────────────────────────────────────┐
│           BOARD OF DIRECTORS                │
│                                             │
│  CEO        COO        CTMO        CFO      │
│  (S)        (E)         (T)        (F)      │
└─────────────────────────────────────────────┘

S = Strategy    E = Execution    T = Technology    F = Financial
```

### Role Matrix

| Role | Responsibility | Focus | 30-Min Standup |
|------|---|---|---|
| **CEO** | Strategic vision, prioritization, final decisions | Market fit, recovery goal, board alignment | Strategy decisions, blockers |
| **COO** | Execution, delivery, operational management | Building products, hitting targets, shipping | What shipped, what's blocked |
| **CTMO** | Technology, infrastructure, platform building | Architecture, tools, automation, databases | Tech delivered, capacity, blockers |
| **CFO** | Financial tracking, cash flow, recovery metrics | Revenue tracking, costs, payment processing, recovery progress | Revenue, burn rate, recovery % |

**Plus:** Me (Board Chair) doing 2-hour reviews to ensure coherence & enforce constraints

## Communication Cadence

### 5-Minute Reviews (Quick Status Pings)
**Every 5 minutes** — quick async update to `board/status/status_CURRENT.md`
- One line per role: "Working on X, no blockers" or "Waiting on Y"
- No discussion, just status ping

### 30-Minute Standups (Full Coordination)
**Every 30 minutes:** All four roles write to `./board/standups/standup_YYYY-MM-DD_HHMM.md`

Each role writes:
- Status: What I completed (last 30 min)
- Blockers: What's stuck
- Need from board: Questions
- Next 30 min: What I'll do

**Example timing:**
```
10:00 standup (all four roles)
10:30 standup (all four roles)
11:00 standup (all four roles)
```

### 2-Hour Board Reviews (Me as Board Chair)
**Every 2 hours:** I review for coherence & sensibility

```
10:00–11:50: Roles execute & standup (10:00, 10:30, 11:00, 11:30)
       ↓
12:00: BOARD REVIEW (I read all standups, check alignment, flag issues)
       ↓
12:00–13:50: Roles execute & standup (12:00, 12:30, 13:00, 13:30)
       ↓
14:00: BOARD REVIEW (I read all standups, check alignment, flag issues)
```

**My job each review:**
- ✓ Are all four roles aligned?
- ✓ Are decisions sensible?
- ✓ Are constraints being respected?
- ⚠️ Flag any conflicts
- 🚀 Approve sensible decisions
- ❌ Block bad decisions (if needed)

## Decision Flow

```
CEO decides strategy
  ↓
CEO → COO: Execute this
  ↓
CEO → CFO: Track financial impact
  ↓
CEO → CTMO: What's the tech requirement?
  ↓
COO + CFO + CTMO: All three execute/track/build
  ↓
Report back to CEO in standup
```

## File Structure

```
MakinMoves/
├── CLAUDE.md                ← Board governance overview
├── BOARD.md                 ← Current state, decisions, metrics
├── STRUCTURE.md             ← This file
│
├── board/
│   ├── standups/            ← Hourly syncs (all four roles)
│   ├── decisions/           ← CEO strategic decisions (logged)
│   └── disputes/            ← Escalation docs if roles disagree
│
├── CEO/
│   ├── CLAUDE.md            ← CEO responsibilities
│   ├── inbox/               ← Questions/blockers for CEO
│   └── outbox/              ← CEO decisions/direction
│
├── COO/
│   ├── CLAUDE.md            ← COO execution checklist
│   ├── inbox/               ← Tasks/decisions for COO
│   ├── outbox/              ← COO status/completion reports
│   └── execution/           ← Current work in progress
│
├── CTMO/
│   ├── CLAUDE.md            ← CTMO tech roadmap
│   ├── inbox/               ← Tech decisions for CTMO
│   ├── outbox/              ← Tech solutions/architecture
│   └── technical/           ← Architecture decisions
│
├── CFO/
│   ├── CLAUDE.md            ← CFO financial tracking
│   ├── inbox/               ← Budget/financial requests for CFO
│   └── outbox/              ← Financial reports/tracking
│
├── logs/
│   ├── status_YYYY-MM-DD.md ← Session logs (all roles)
│   └── financial_YYYY-MM-DD.md ← CFO detailed tracking
│
└── MakinMoves-portable/
    └── (Product repo with Docker services)
```

## Role-Specific Workflows

### CEO Workflow
1. Read board standups → Understand current state
2. Check CEO inbox → See blocked decisions
3. Review CEO outbox → Confirm my decisions are clear
4. Make strategic decisions → Write to `board/decisions/`
5. Weekly: Update `../BOARD.md` with new priorities
6. Hourly: Write standup section

### COO Workflow
1. Read board standups → Know what CEO/CFO/CTMO doing
2. Check COO inbox → See new execution requests
3. Execute highest-priority task
4. Update CFO on revenue/payments (when relevant)
5. Coordinate with CTMO on tech blockers
6. Hourly: Write standup with status

### CTMO Workflow
1. Read board standups → Understand exec needs
2. Check CTMO inbox → See tech questions/decisions
3. Build/deploy features or answer tech questions
4. Monitor infrastructure health
5. Inform CFO of cost implications
6. Hourly: Write standup with tech status

### CFO Workflow
1. Read board standups → Understand execution pace
2. Check CFO inbox → See budget/payment requests
3. Query PostgreSQL → Get real-time revenue numbers
4. Track cash flow, MRR, recovery progress
5. Approve/deny budget requests (with reasoning)
6. Weekly: Update recovery tracker in `BOARD.md`
7. Hourly: Write standup with financial snapshot

## Communication Patterns

### Inbox/Outbox (Per Role)
- **When blocked:** Write to `{role}/inbox/question_YYYY-MM-DD_topic.md`
- **When deciding:** Write to `{role}/outbox/answer_YYYY-MM-DD_topic.md`
- **Status updates:** Write to `logs/status_YYYY-MM-DD.md`

### Board-Level Decisions
- **All written:** `board/decisions/decision_YYYY-MM-DD_topic.md`
- **Timestamped:** Always include decision date/time
- **Documented:** Always include rationale and impact

### Escalation (If Roles Disagree)
1. Document disagreement in `board/disputes/`
2. Both sides write reasoning
3. CEO makes final call
4. All proceed with decided direction

## Success Metrics (Tracked by CFO, Reported Hourly)

- **Revenue generated** (total + by stream)
- **Costs** (infrastructure + tools + fees)
- **Net profit**
- **Recovery progress** (% toward goal)
- **Task velocity** (COO delivery rate)
- **Tech health** (infrastructure uptime, no critical bugs)
- **Board alignment** (zero escalations ideal)

## Launch Checklist

- [ ] CEO instance reading from `./CEO/CLAUDE.md`
- [ ] COO instance reading from `./COO/CLAUDE.md`
- [ ] CTMO instance reading from `./CTMO/CLAUDE.md`
- [ ] CFO instance reading from `./CFO/CLAUDE.md`
- [ ] All instances configured to hourly sync
- [ ] Docker services running (verify with `npm run docker:logs`)
- [ ] Database accessible to CFO for queries
- [ ] All four roles in sync at top of hour

---

**Status:** Ready for four-role autonomous operation
**Updated:** 2026-03-29
**Next sync:** Top of next hour
