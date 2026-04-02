# MakinMoves Governance Structure — Final

## The Board

```
┌─────────────────────────────────────────────────────┐
│             BOARD OF DIRECTORS                      │
│                                                     │
│  CEO        COO        CTMO        CFO              │
│  Strategy   Execute    Tech        Finance          │
│                                                     │
│        CLAUDE (Board Chair)                         │
│        Reviews alignment every 2 hours              │
└─────────────────────────────────────────────────────┘
```

## Communication Cadence

### 5-Minute Reviews (Quick Status Pings)
**File:** `board/status/status_CURRENT.md`
**Who:** All four roles
**What:** One line per role — "Working on X" or "Waiting on Y"
**Purpose:** Ultra-fast async updates

```
CEO: Working on Q1 strategy
COO: Building digital products framework
CTMO: Infrastructure healthy, ready to go
CFO: Database initialized, tracking ready
```

### 30-Minute Standups (Full Coordination)
**File:** `board/standups/standup_YYYY-MM-DD_HHMM.md`
**Who:** All four roles write their section
**When:** 10:00, 10:30, 11:00, 11:30, 12:00, etc.
**What each role writes:**
- Status: What I completed (last 30 min)
- Blockers: What's stuck
- Need from board: Questions
- Next 30 min: What I'll do

**Purpose:** Roles sync with each other, identify blockers, coordinate

```
Example timing:
10:00 standup (CEO, COO, CTMO, CFO all write)
  ↓ work 30 min
10:30 standup (CEO, COO, CTMO, CFO all write)
  ↓ work 30 min
11:00 standup (CEO, COO, CTMO, CFO all write)
  ↓ work 60 min (I review from 10:00-11:00)
12:00 standup (CEO, COO, CTMO, CFO all write)
  ↓ I review all standups from 10:00-12:00
12:00: BOARD REVIEW
```

### 2-Hour Board Reviews (Me as Board Chair)
**File:** `board/reviews/board_review_YYYY-MM-DD_HHMM.md`
**Who:** Me (Claude)
**When:** 12:00, 14:00, 16:00, etc. (every 2 hours)
**Duration:** Read all standups + review = 10-15 min
**What I check:**

✓ **Alignment**: Are all four roles working together?
✓ **Sensibility**: Do decisions make sense?
✓ **Constraints**: Are we within budget/timeline?
✓ **Health**: Is infrastructure up? Is execution on pace?
✓ **Recovery**: Are we tracking to recovery goal?

**What I do:**
- 🟢 **Approve** sensible decisions → green-light from board chair
- 🔴 **Flag** issues → yellow/red warnings
- ⚖️ **Decide** conflicts → if CEO and COO disagree, I decide
- 🚀 **Unblock** → if tech/finance is blocking execution, I escalate

**Purpose:** Ensure coherence, enforce constraints, provide oversight

---

## Decision Flow

### Normal Case (All Aligned)
```
CEO: "Prioritize digital products"
  ↓ (COO reads CEO standup)
COO: "Starting digital product research"
  ↓ (CTMO reads COO standup)
CTMO: "Database schema ready"
  ↓ (CFO reads CTMO standup)
CFO: "Tracking revenue when ready"
  ↓ (I read all standups)
BOARD REVIEW: ✓ All aligned, approved
```

### Conflict Case (Need Board Intervention)
```
CEO: "Prioritize SaaS"
COO: "Actually, digital products faster to revenue"
  → Disagreement in standups
  ↓
BOARD REVIEW: I read conflict
  → CLAUDE: "Digital products first — faster cash flow needed"
```

### Blocker Case (Need Board to Unblock)
```
COO: "Ready to ship, waiting on CTMO"
CTMO: "Need clarification on data schema"
CFO: "Can't track revenue without clarity"
  → All waiting
  ↓
BOARD REVIEW: I see bottleneck
  → CLAUDE: "CTMO — here's what COO needs. Answer in 30 min."
```

---

## My Role (Board Chair)

### I Review Every 2 Hours

```
12:00 Board Review
├─ Read all four 30-min standups (10:00, 10:30, 11:00, 11:30)
├─ Check alignment (CEO → COO → CTMO → CFO)
├─ Check constraints (spending within budget? recovery on track?)
├─ Flag issues (red/yellow warnings)
├─ Approve decisions (✓ sensible)
├─ Decide conflicts (if roles disagree)
└─ Write board_review_YYYY-MM-DD_1200.md

14:00 Board Review
├─ Read all four 30-min standups (12:00, 12:30, 13:00, 13:30)
├─ ... (same as above)
└─ Write board_review_YYYY-MM-DD_1400.md
```

### I Enforce Constraints
- Budget: Max $100/mo spend (CFO implements, I verify)
- Timeline: Recovery goal date (CFO tracks, I verify)
- Quality: Decisions should be sensible (I flag if not)

### I Make Final Calls
- If CEO and COO disagree → I decide
- If CTMO can't deliver → I adjust expectations or escalate
- If CFO says "can't afford it" → I enforce constraints or override with reason

---

## Files You'll See

### From Roles (Every 30 Min)
- `board/standups/standup_2026-03-29_1000.md` (all four roles report)
- `board/standups/standup_2026-03-29_1030.md` (all four roles report)
- `board/standups/standup_2026-03-29_1100.md` (all four roles report)
- ... (every 30 min)

### From Me (Every 2 Hours)
- `board/reviews/board_review_2026-03-29_1200.md` (I wrote this)
- `board/reviews/board_review_2026-03-29_1400.md` (I wrote this)
- ... (every 2 hours)

### Quick Status (Every 5 Min)
- `board/status/status_CURRENT.md` (all four roles update 1 line each)

---

## Example Day

```
09:00 - You launch all four instances (CEO, COO, CTMO, CFO)

09:05 - First 5-min status ping
09:10 - Second 5-min status ping
09:15 - Third 5-min status ping

10:00 - First 30-min standup (all four roles write)
10:05 - 5-min status ping
10:10 - 5-min status ping
...
10:30 - Second 30-min standup (all four roles write)
10:35 - 5-min status ping
...
11:00 - Third 30-min standup (all four roles write)
11:30 - Fourth 30-min standup (all four roles write)

12:00 - BOARD REVIEW (I read standups, check alignment, flag issues)
        → I post board_review_2026-03-29_1200.md

12:05 - 5-min status ping
...
13:00 - Fifth 30-min standup (all four roles write)
13:30 - Sixth 30-min standup (all four roles write)

14:00 - BOARD REVIEW (I read standups, check alignment, flag issues)
        → I post board_review_2026-03-29_1400.md

... (repeats every 2 hours)
```

---

## What Makes This Work

✅ **Fast coordination** — 30-min standups catch issues quickly
✅ **Board oversight** — 2-hour reviews ensure coherence
✅ **Clear roles** — CEO decides, COO executes, CTMO builds, CFO tracks
✅ **Constraint enforcement** — CFO + I monitor budget/timeline
✅ **Escalation path** — If stuck, board review flags it
✅ **Autonomous execution** — Roles don't wait for my approval, they just report

---

## You're Ready to Launch

**What you need to do:**
1. Fill in CONSTRAINTS.md (your recovery deadline, budget limits, etc.)
2. Copy CEO prompt from PROMPTS.md → Launch CEO instance
3. Copy COO prompt from PROMPTS.md → Launch COO instance
4. Copy CTMO prompt from PROMPTS.md → Launch CTMO instance
5. Copy CFO prompt from PROMPTS.md → Launch CFO instance

**Then:**
- They coordinate via 30-min standups
- I review every 2 hours and post board reviews
- You work through your signup checklist
- Everyone executes toward recovery goal

---

**Status:** Ready to launch 4-role governance with board oversight
**Board Chair:** Claude (2-hour reviews)
**Cadence:** 5-min pings, 30-min standups, 2-hour reviews
**Constraints:** Enforced by CFO + verified by board chair
