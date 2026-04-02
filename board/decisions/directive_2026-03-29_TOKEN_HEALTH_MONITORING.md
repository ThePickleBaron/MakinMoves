# DIRECTIVE — Token Health Monitoring — 2026-03-29

**From:** Jason / Board Coordinator
**To:** CEO, CTMO, CFO, COO/COWORK (All instances)
**Urgency:** Standard
**Effective:** Immediately

---

## The Reality

As instances run continuously and launch agents, they consume tokens (context). When tokens run out:
- Instance can't read new files
- Instance can't write to standup file
- Instance stops working
- You have to manually restart it
- Progress halts until restart

---

## The Solution

**Instances should pause gracefully when tokens run low, not crash.**

Check your token health BEFORE your standup window. If you're running low:
1. File a pause note (2 sentences max)
2. Exit cleanly
3. Next instance continues where you left off
4. Fresh restart at next cycle

---

## What to Do

### Every Instance, Before Your Window:

```
Estimate: Have I been running for 90+ min with agents active?
  → YES: Tokens likely low (~5,000 or less remaining)
  → NO: Proceed normally

If tokens low:
  1. Add pause marker to standup file:
     **[YOUR ROLE] ([TIME]) — PAUSED (Token limit) — [Name]**
     **Pending: [1-line summary]**
  2. Stop all running agents
  3. Close files
  4. Exit
  5. DO NOT attempt to file in next window — let fresh instance restart

If tokens OK:
  1. Proceed with normal standup filing
  2. File timestamp comment: **[TIME] [ROLE] UPDATED — [Name]**
  3. Exit normally
```

---

## Why This Works

- **No crashes** — you pause before tokens hit zero
- **No idle time** — secondary review protocol handles the gap
- **No manual intervention needed** — Jason restarts at next cycle, reads pause note, continues
- **Progress preserved** — standup file is the source of truth

---

## Examples

**Example 1: Healthy tokens, normal file**
```
**6:13 PM CEO SECTION UPDATED — Claude**
[Full standup section with research results]
```

**Example 2: Low tokens, graceful pause**
```
**CEO (6:00–6:13 PM) — PAUSED (Token limit) — Claude**
**Pending: Phase 3 strategy analysis (3 agents completed research outputs cached)**
```

**Example 3: Next instance reads pause note**
```
## CTMO (6:15–6:28 PM)

CEO paused due to token limit but delivered three complete research streams.
Proceeding with cost modeling based on CEO's outputs.
```

---

## Reference Document

See `INSTANCE_TOKEN_HEALTH_CHECK.md` for detailed checking procedure.

---

**Status:** All instances should understand graceful pause protocol. No exceptions.

---
