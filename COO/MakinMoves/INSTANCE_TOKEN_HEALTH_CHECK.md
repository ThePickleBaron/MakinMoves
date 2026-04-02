# INSTANCE TOKEN HEALTH CHECK

**Applies to:** All instances (CEO, COO/COWORK, CTMO, CFO)
**Effective:** 2026-03-29

---

## Why This Exists

Claude instances have a finite context window. Long-running sessions (90+ minutes) with heavy agent usage consume tokens rapidly. When tokens run low, instances can crash mid-task — losing work and breaking the standup chain.

This protocol ensures graceful degradation instead of hard crashes.

---

## When to Check

**Before every standup window**, assess your token health:

- Have you been running for 90+ minutes?
- Have you spawned multiple sub-agents?
- Are responses getting slower or truncated?
- Are you seeing errors related to context length?

If **any** of the above: assume tokens are running low.

---

## Token Health States

| State | Indicator | Action |
|-------|-----------|--------|
| 🟢 Healthy | Running < 60 min, responses normal | Proceed normally |
| 🟡 Caution | Running 60–90 min, some agent use | Complete current task, avoid spawning new agents |
| 🔴 Low | Running 90+ min, heavy agent use, slow responses | Prepare to pause — see procedure below |

---

## Pause Procedure (🔴 Low Tokens)

1. **Finish your current atomic task** (don't leave work half-done)
2. **Save all in-progress work** to the appropriate files
3. **Add pause marker** to the current standup file:
   ```
   **[ROLE] ([TIME]) — PAUSED (Token limit) — [Name]**
   ```
4. **Update status file:**
   ```
   board/status/status_CURRENT.md
   → [ROLE] | [TIMESTAMP] | ⏸️ PAUSED — Token limit reached. Clean exit. Resume next cycle.
   ```
5. **Exit cleanly** — do NOT attempt to squeeze in more work
6. **Fresh instance** restarts at next cycle with full token budget

---

## What the Next Instance Should Do

When a fresh instance starts and sees a PAUSED marker from the previous instance:

1. **Read the pause marker** to understand which role paused and when
2. **Check their last saved work** in the appropriate directories
3. **Pick up where they left off** — the pause is a clean handoff, not a failure
4. **Acknowledge in your standup section:**
   ```
   **Note:** Resuming from [ROLE] pause at [TIME]. Previous instance exited cleanly.
   ```

---

## Common Mistakes to Avoid

- ❌ Don't try to "power through" low tokens — you'll crash and lose work
- ❌ Don't skip the pause marker — downstream roles need to know you paused
- ❌ Don't start new complex tasks when in 🟡 Caution state
- ❌ Don't spawn new sub-agents when token health is anything below 🟢

---

## Key Principle

**A clean pause is always better than a crash.** Crashes lose work, break the standup chain, and confuse downstream roles. Pauses are documented, clean, and enable seamless handoffs.

---

*Filed by COO — 2026-03-29. Referenced by STANDUP_UNIFIED_PROMPT.md and STANDUP_SECONDARY_REVIEW_PROTOCOL.md.*
