# DIRECTIVE — Continuous Agent Execution — 2026-03-29

**From:** Jason
**To:** CEO, CTMO, CFO, COO/COWORK
**Urgency:** Standard
**Effective:** Immediately

---

## The Point

Your standup window is 15 minutes. The remaining 45 minutes of each hour, agents should be running.

**No idle time. No waiting between windows. Agents keep running.**

---

## Model

```
6:00-6:15  [CEO: File standup] → Launch agents
6:15-6:30  [CTMO: File standup] (CEO agents running) → Launch agents
6:30-6:45  [CFO: File standup] (CEO + CTMO agents running) → Launch agents
6:45-7:00  [COO: File standup] (All agents running) → Launch agents
7:00+      All agents running until next standup cycle
```

---

## What This Means

1. **File your standup section** (15 min)
2. **Don't wait idle** — immediately launch agents on high-priority work
3. **Agents run while next role is filing** — you're not waiting, you're making progress
4. **Secondary review doesn't stop agents** — if your predecessor missed, you secondary review AND launch agents

---

## Examples

**CEO 6:00-6:15:**
- File standup (Phase 2 strategy outline, current work, blockers, reflections)
- Launch agents: "Top 10 revenue streams", "Competitor analysis", "Go-to-market strategy"
- Agents run 6:15-6:45 while CTMO and CFO are filing

**CTMO 6:15-6:30:**
- Read CEO
- File standup (API architecture, blockers, next deliverables, reflections)
- Launch agents: "n8n workflow library", "Tech stack cost modeling", "PostgreSQL scaling"
- Agents run 6:30-7:00+ while CFO and COO are filing

**CFO 6:30-6:45:**
- Read CEO + CTMO
- File standup (pricing models, unit economics, next deliverables, reflections)
- Launch agents: "50 competitor pricing analysis", "Revenue forecasting", "CAC modeling"
- Agents run 6:45-7:00+ while COO is filing

---

## Why This Works

- **Standup is a checkpoint, not idle time** — 15 min per role to update status
- **Agents provide next 15-min context** — by the time next role files, new research is ready
- **No waiting on decisions** — agents run in parallel, you decide as new data arrives
- **Momentum maintained** — when secondary reviews happen, agents are already running

---

## Blocking Rule

If your standup section lists agents running, those agents should actually be running in parallel during the cycle.

Example (correct):
```
**AGENTS RUNNING:**
- Research Agent: "Top 10 Gumroad competitors" (results by 7:15 PM)
- Planning Agent: "30-day go-to-market roadmap" (outline by 7:00 PM)
```

This means those agents are actually firing up and producing results, not hypothetical.

---

**Status:** All roles should understand agents run between windows. No exceptions.

---
