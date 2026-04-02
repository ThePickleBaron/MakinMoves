# Board Directive — Continuous Agent Execution Model
**Filed:** 2026-03-29
**Filed by:** COO/COWORK (relaying Jason's directive)
**Type:** Governance — Operating Cadence
**Status:** ✅ ACTIVE — All roles must comply immediately

---

## The Core Model

Each hour is divided as follows:

```
:00 – :45  →  WORK WINDOW (45 min) — agents execute their active tasks
:45 – :00  →  STANDUP WINDOW (15 min) — agents file standup, read others, critique
```

**The standup is a checkpoint, not the work.**
Agents are expected to be actively producing output during the 45-minute work window. The standup captures what happened — it is not where work happens.

---

## What This Changes

### ❌ OLD (Incorrect) Model
- Agents treat each standup as a discrete "shift"
- Agents only produce output when prompted by standup format
- Downtime between standups = unaccounted idle time
- CEO absence at standup = no CEO work happening

### ✅ NEW (Correct) Model
- Each agent runs continuous 45-minute work cycles
- Standup is a structured 15-min self-report + peer critique
- Between standups = primary execution period (where value is created)
- Missed standup window ≠ missed work — see STANDUP_SECONDARY_REVIEW_PROTOCOL.md

---

## Per-Role Work Expectations (45-min Windows)

### CEO
- Strategic synthesis: reviewing market signals, updating priorities, adjusting revenue stream sequencing
- Filing board decisions when conditions change
- Reading COO/CTMO/CFO outputs and providing guidance

### COO/COWORK
- Active product execution: writing prompts, building seeding campaigns, drafting copy
- Research advancement: moving pipeline stages forward
- Filing plans, templates, and execution artifacts to COO/execution/

### CTMO
- Technical infrastructure: advancing builds, testing components, filing architecture docs
- n8n workflow development, Docker environment management
- Filing technical notes and architecture decisions to CTMO/technical/

### CFO
- Financial modeling, pricing analysis, competitor research
- Revenue tracking, projection updates
- Filing reports to CFO/reports/

---

## Standup Windows (Relative Timing — Updated 2026-03-29)

> **TIMING MODEL UPDATED:** Standup windows now use relative timing anchored to CEO's filing time, not fixed clock positions. See `STANDUP_UNIFIED_PROMPT.md` and `board/decisions/decision_2026-03-29_universal_prompt_review.md` for the full updated model.

Standup windows are **read-write checkpoints**:
1. CEO files immediately → CTMO at T+2 → CFO at T+17 → COO at T+32
2. Each role gets a 13-min window with 2-min gaps between
3. Read what peers have filed, write your critique
4. Add timestamp comment so the next role can calculate their window
5. Done — return to work

If your window is **missed**, mark SKIPPED (no late filings). See `STANDUP_SECONDARY_REVIEW_PROTOCOL.md`.

---

## Status Update Cadence (Unchanged)

- **Every 5 min:** `board/status/status_CURRENT.md` — one-line update of current task
- **Every 30 min (standup):** Unified standup file entry
- **Every 2 hours:** CEO reviews standups, posts board feedback to `board/reviews/`

---

## Why This Matters

Jason is in a recovery situation from a rental scam and is actively relocating. Time is not abstract. Every 45-minute work window has dollar value. Agents treating standups as their primary output unit waste the majority of each hour. This directive makes it explicit: **the standup is the receipt, not the work.**

---

*Directive active immediately. All roles must update their operating rhythm accordingly.*
*Questions → COO/inbox/ or CEO/inbox/*
