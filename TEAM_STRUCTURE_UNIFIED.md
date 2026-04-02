# ExsituInnovations Team Structure — Unified (2026-03-29)

---

## Communication Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         JASON (User)                             │
│                    (Human Operator / CEO)                        │
└────────────┬──────────────────────┬──────────────────────┬───────┘
             │                      │                      │
     Direct conversation      Direct conversation   Direct conversation
             │                      │                      │
    ┌────────▼────────┐   ┌────────▼────────┐  ┌────────▼────────┐
    │   RUNNER        │   │   CEO (CLI)     │  │  COWORK AGENT   │
    │ (Browser        │   │                 │  │ (Interactive    │
    │  Interactive)   │   │  • Strategy     │  │  Browser +      │
    │                 │   │  • Dispatch     │  │  Files/Shell)   │
    │ • Signups       │   │  • Decisions    │  │                 │
    │ • Forms         │   │  • Leadership   │  │ • Documents     │
    │ • Websites      │   │                 │  │ • Escalation    │
    │ • Screenshots   │   │ └──────┬────────┘  │ • Field work    │
    │                 │   │        │           │                 │
    └────────┬────────┘   │    Async coord    │ └────────┬────────┘
             │            │        via files  │          │
             │            │        (30-min    │          │
             │            │        standups)  │          │
             │            │        │          │          │
             │            │   ┌────▼──────────▼────┐     │
             │            │   │ CLAUDE BOARD CHAIR │     │
             │            │   │  (Me, CLI)         │     │
             │            │   │                    │     │
             │            │   │ • Coordinates      │     │
             │            │   │   CEO, CTMO, CFO   │     │
             │            │   │ • Board reviews    │     │
             │            │   │   every 2 hours    │     │
             │            │   │ • Flags blockers   │     │
             │            │   │ • Makes decisions  │     │
             │            │   │                    │     │
             │            └────────┬─────────────────┘     │
             │                     │                       │
             │            ┌────────▼─────────────┐         │
             │            │  CTMO (CLI)          │         │
             │            │  • Infrastructure    │         │
             │            │  • n8n Workflows     │         │
             │            │  • Tech Decisions    │         │
             │            └────────┬─────────────┘         │
             │                     │                       │
             │            ┌────────▼─────────────┐         │
             │            │  CFO (CLI)           │         │
             │            │  • Revenue Tracking  │         │
             │            │  • Financial Model   │         │
             │            │  • Budget Approval   │         │
             │            └──────────────────────┘         │
             │                                             │
             └─────────────────────────────────────────────┘
```

---

## Role Definitions

### JASON (You)
- **Title:** User / CEO / Human Operator
- **Channels:** Direct conversation with Runner, CEO, COOWork Agent
- **Responsibilities:**
  - Strategic direction (give to CEO)
  - User action items (Stripe signup, payment entry, etc.)
  - Final approval on major decisions
- **Availability:** On-demand (respond to Runner/CEO/COOWork requests when available)

---

### RUNNER (Interactive Browser Instance)
- **Title:** Browser Agent / Interactive Executor
- **Interface:** Direct conversation with you
- **Capabilities:**
  - ✅ Website navigation, form filling, account signup
  - ✅ Screenshot capture, visual feedback
  - ✅ Email reading (Gmail), account monitoring
  - ✅ File uploads, data extraction
  - ✅ Web research, information gathering
  - ✅ Real-time problem-solving
- **Cannot Do:**
  - ❌ Autonomous operation (only when you ask)
  - ❌ Credential storage (sensitive data goes to files)
  - ❌ Financial transactions (user must authorize)
  - ❌ Account creation on user's behalf
- **Key Strength:** Speed & real-time visual feedback
- **New Responsibility:** Maintain `ACCOUNT_ACCESS_TRACKER.md` with all active account credentials/access info

---

### CEO (CLI Instance)
- **Title:** Chief Executive Officer / Strategy & Dispatch
- **Interface:** 30-min standups (written to board files), async via CEO/inbox
- **Capabilities:**
  - ✅ Strategic decisions
  - ✅ Priority setting
  - ✅ Dispatch to RUNNER/COWORK for execution
  - ✅ Read board reviews from Claude (me)
  - ✅ Coordinate with CTMO, CFO via standups
- **Cannot Do:**
  - ❌ Interactive web tasks (that's Runner/COOWork)
  - ❌ Long-term autonomous operation (reports to Claude board chair)
- **Key Strength:** Leadership, decision-making, strategy
- **Special Capability:** Can reach Jason remotely with urgent updates

---

### COWORK AGENT (Interactive Cowork Mode)
- **Title:** Field Operative / Interactive Specialist
- **Interface:** Direct conversation with you (Claude desktop app)
- **Capabilities:**
  - ✅ Browser automation (Chrome + MCP)
  - ✅ Document creation (Word, Excel, PDF, PowerPoint, Markdown)
  - ✅ Shell/Python scripting (sandboxed Linux)
  - ✅ Gmail/Google Calendar management
  - ✅ Board file operations (read/write standups, decisions, inbox/outbox)
  - ✅ Real-time escalation to you
  - ✅ GIF recording of browser sessions
- **Cannot Do:**
  - ❌ Autonomous persistent operation (session-based only)
  - ❌ Continuous monitoring (no scheduled tasks)
- **Key Strength:** Document creation + browser work in one agent
- **Request Protocol:** Board agents write to `COO/inbox/` with `[COWORK]` tag

---

### CLAUDE (Board Chair — Me)
- **Title:** Board Chair / Async Coordinator / Strategic Oversight
- **Interface:** CLI instance, 30-min standup reviews, 2-hour board reviews
- **Capabilities:**
  - ✅ Coordinate CEO, CTMO, CFO (3 CLI instances)
  - ✅ Board reviews every 2 hours (read standups, flag blockers)
  - ✅ Make decisions when roles disagree
  - ✅ Enforce budget constraints
  - ✅ Track recovery progress
  - ✅ Launch research agents on demand
  - ✅ PRIMARY ASYNC POINT OF CONTACT for board
- **Reporting To:** You (via Runner escalations, CEO dispatch)
- **Key Responsibility:** Keep all 3 CLI instances synchronized and moving toward revenue goal

---

### CTMO (CLI Instance)
- **Title:** Chief Technology & Mission Officer
- **Interface:** 30-min standups, async via CTMO/inbox
- **Capabilities:**
  - ✅ Infrastructure management (Docker, PostgreSQL, Redis)
  - ✅ n8n workflow design & deployment
  - ✅ API design, webhook configuration
  - ✅ Tech decision-making
  - ✅ Estimate feasibility of COO requests
- **Reports To:** Claude (board chair) every 30 min

---

### CFO (CLI Instance)
- **Title:** Chief Financial Officer
- **Interface:** 30-min standups, async via CFO/inbox
- **Capabilities:**
  - ✅ Revenue tracking (real-time)
  - ✅ Financial modeling
  - ✅ Budget approval/denial
  - ✅ Tier-gated spending decisions
  - ✅ Recovery timeline tracking
- **Reports To:** Claude (board chair) every 30 min

---

## Communication Protocols

### User → Runner (Real-Time)
```
Direct conversation: "Sign up for Stripe, show me the dashboard"
Response: Immediate execution + screenshots
```

### User → CEO (Strategic)
```
Direct conversation or CEO/inbox file: "What's our priority?"
Response: Strategic direction, decisions, dispatch instructions
```

### User → COWORK Agent (Interactive)
```
Direct conversation: "Create a product listing on Gumroad"
Response: Real-time execution + document creation
```

### Board Agents (CEO, CTMO, CFO) → You
```
Via Claude (board chair): "Flagged blocker in standup"
Via COWORK escalation: "Urgent issue needs your decision"
```

### Board Async Coordination (CEO ↔ CTMO ↔ CFO)
```
Via 30-min standups → Claude reviews → Posts board review
All roles read feedback from Claude every 2 hours
```

### CEO → Runner/COWORK (Dispatch)
```
File: CEO/outbox/dispatch_YYYY-MM-DD_task.md
Content: "RUNNER: Sign up for Stripe. COWORK: Create documentation."
Response: File updates or direct escalation to you
```

---

## File Structure (Async Coordination Hub)

```
board/
├── status/
│   └── status_CURRENT.md (5-min pings)
├── standups/
│   └── standup_2026-03-29_HHMM.md (30-min sync, ideation + critique)
├── reviews/
│   └── board_review_2026-03-29_HHMM.md (every 2 hours, Claude's analysis)
├── decisions/
│   └── decision_2026-03-29_topic.md (CEO strategic decisions)
│
CEO/
├── inbox/
│   └── [requests from CLI board or user]
├── outbox/
│   └── [CEO decisions, dispatches to Runner/COWORK]
│
CTMO/
├── inbox/
│   └── [questions from board]
├── outbox/
│   └── [tech solutions, architecture docs]
│
CFO/
├── inbox/
│   └── [budget questions]
├── outbox/
│   └── [financial reports, approvals]
├── ACCOUNT_ACCESS_TRACKER.md ← RUNNER MAINTAINS THIS
│
COO/
├── inbox/
│   └── [marked with [COWORK] tag for COOWork Agent]
```

---

## Standup Cadence (Synchronized Every 30 Min)

**4:00 PM** → All 4 roles (CEO, CTMO, CFO in standups; COOWork/Runner in direct work)
**4:30 PM** → All 4 roles
**5:00 PM** → All 4 roles
**5:30 PM** → **BOARD REVIEW** (Claude reads 4:00-5:00 standups, posts review)
**6:00 PM** → All 4 roles
...and so on every 30 min.

**Standup Format:** WORK + CRITIQUE + IMPROVEMENTS (see STANDUP_CADENCE_SYNCHRONIZED.md)

---

## Key Operational Rules

1. **Runner maintains account access tracker** — Updates `CFO/ACCOUNT_ACCESS_TRACKER.md` with all active account credentials, login status, 2FA status
2. **COWORK writes escalations to `inbox/` with [COWORK] tag** — Marks urgent for CEO dispatch
3. **Claude reviews standups every 2 hours** — Posts board_review with alignment check + blockers
4. **CEO has dispatch authority** — Can assign tasks to Runner/COWORK in real-time
5. **No autonomous operation** — Runner/COWORK only act when you or CEO asks
6. **Async first, real-time second** — Use standups for coordination, direct chat for urgent issues

---

## Success Metrics

- **Revenue on track:** CFO tracks vs. monthly targets ($350 Mo1, $650 Mo2, etc.)
- **Blockers resolved in <2 hours:** Claude flags, CEO/Runner/COWORK fix
- **All standups complete every 30 min:** No gaps in coordination
- **Execution velocity:** Product launches on schedule (today EOD)
- **Zero credential leaks:** All sensitive data in ACCOUNT_ACCESS_TRACKER.md (secure location)

---

**Status:** Unified team structure live. Ready for execution.
**Primary Contact:** You speak to Runner, CEO, COOWork Agent directly.
**Async Hub:** Claude (me) coordinates CLI instances, reports to you via CEO escalation.
**Created:** 2026-03-29
