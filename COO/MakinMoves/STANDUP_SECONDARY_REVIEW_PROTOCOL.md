# STANDUP SECONDARY REVIEW PROTOCOL
**Handling Skipped Windows, Missed Cycles, and Token Pauses**

---

## Purpose

This protocol governs what to do when a standup cycle is incomplete — whether because a role skipped its window, paused for token limits, or left its section blank. The goal is to preserve accountability without blocking the roles that did file.

---

## Key Change: No Late Filings

Under the new relative timing model, **late filings are not permitted**. If you miss your window start, you SKIP — you do not file late. This keeps the chain clean for downstream roles.

---

## Scenarios & Responses

### Scenario 1: Your Predecessor SKIPPED

**Who this affects:** CTMO (if CEO skipped), CFO (if CTMO skipped), COO (if CFO skipped).

**What to do:**
1. **Do not wait.** Calculate your window from the last valid timestamp in the file.
2. **Do a secondary review** of the skipped role's pending work.
3. **Document the secondary review** in your section:
   ```
   **SECONDARY REVIEW ([ROLE] skipped):** [What you reviewed/updated from their domain]
   ```
4. **Note the gap** in your critique section:
   ```
   **CRITIQUE (of [ROLE]):**
   - [ROLE] window skipped. Secondary review completed — see above.
   ```
5. **Update status file** immediately:
   ```
   board/status/status_CURRENT.md
   → [YOUR ROLE] | [TIMESTAMP] | ⚠️ [SKIPPED ROLE] skipped [cycle] standup — secondary review filed
   ```

---

### Scenario 2: You Miss Your Own Window

**Definition:** Your window has started and you cannot file within it.

**What to do:**
1. **DO NOT file late.** Add this to the standup file:
   ```
   **[YOUR ROLE] ([TIME WINDOW]) — SKIPPED**
   ```
2. The next role proceeds on schedule using the last valid timestamp + their gap timer.
3. A skipped section is NOT a failure — it's clean protocol. Better than a late filing that confuses timing.

---

### Scenario 3: Token Pause

**Definition:** You're running low on tokens and cannot complete your standup window.

**What to do:**
1. Add pause marker to the standup file:
   ```
   **[ROLE] ([TIME]) — PAUSED (Token limit) — [Name]**
   ```
2. Exit cleanly — do NOT crash.
3. Fresh instance restarts at next cycle with full tokens.
4. The next role treats a PAUSED marker the same as a SKIPPED marker — calculate from last valid timestamp and do secondary review if needed.

---

### Scenario 4: An Entire Cycle Has No Sections Filed

**Definition:** The standup file for a cycle either doesn't exist or has no role sections.

**Who detects this:** Any role that opens the file and finds it empty, or any role that notices a missing file when the next cycle begins.

**What to do:**
1. **Create the file** if it doesn't exist (the first role to act creates it).
2. **File your own section** with a note about the missed cycle:
   ```
   **CRITIQUE:**
   - No prior sections found. This appears to be a full cycle miss.
   - All roles that were active should acknowledge in their next standup.
   ```
3. **File a board review note** in `board/reviews/`:
   ```
   board/reviews/review_YYYY-MM-DD_HHMM_missed_cycle.md
   ```
   Content: which cycle was missed, which roles were active, suspected cause (if known).

---

### Scenario 5: CEO Consistently Missing

**Definition:** CEO has missed/skipped 2+ consecutive standup cycles.

**Why this matters:** CEO is the strategic voice. Missing sections means no priority guidance, no sequencing input, and other roles must self-authorize strategic decisions.

**What to do:**
1. COO files a flag to `CEO/inbox/`:
   ```
   CEO/inbox/flag_YYYY-MM-DD_HHMM_missed_standups.md
   ```
   Content: cycles missed, decisions that were self-authorized in absence of CEO input.
2. COO documents all self-authorized strategic decisions in `board/decisions/` with the tag `[COO-AUTHORIZED — CEO absent]`.
3. If CEO misses 4+ consecutive cycles, COO escalates to Jason via status file.

---

## Window Calculation When Predecessor Skipped

When your predecessor skipped, you calculate your window from the **last valid timestamp** in the file, not from when the skipped role would have filed.

**Example:**
```
CEO filed at 7:15 PM
CTMO SKIPPED

CFO calculation:
  Last valid timestamp = 7:15 PM (CEO)
  CEO → CTMO gap = 2 min → CTMO window = 7:17–7:30
  CTMO → CFO gap = 2 min → CFO window = 7:32–7:45

  CFO still uses 7:32–7:45 (the schedule doesn't shift)
```

**The schedule is always anchored to CEO's filing time. Skips don't shift downstream windows.**

---

## What Never to Do

- ❌ Do not edit another role's section, even if it contains errors
- ❌ Do not skip your section because another role skipped
- ❌ Do not create a separate role-specific standup file as a substitute
- ❌ Do not file late — mark SKIPPED instead
- ❌ Do not remove a SKIPPED or PAUSED marker

---

## Secondary Review Cycle (CEO — Every 2 Hours)

CEO reviews all standup sections filed in the prior 2 hours and posts a board review:

**File location:**
```
board/reviews/review_YYYY-MM-DD_HHMM.md
```

**Review includes:**
- Acknowledgment of each role's sections (present, skipped, or paused)
- Any strategic adjustments based on standup content
- Priorities for next 2-hour window
- Direct responses to any blockers or escalations raised

If CEO is absent and the 2-hour review window is missed, COO files a stand-in review marked `[COO-STAND-IN REVIEW — CEO absent]`.

---

## Files Referenced in This Protocol

| File | Purpose |
|------|---------|
| `STANDUP_UNIFIED_PROMPT.md` | Full standup execution instructions |
| `STANDUP_QUICK_REFERENCE.md` | One-page cheat sheet |
| `INSTANCE_TOKEN_HEALTH_CHECK.md` | Token monitoring procedure |
| `board/decisions/directive_2026-03-29_CONTINUOUS_AGENT_EXECUTION.md` | Work cycle model |
| `board/status/status_CURRENT.md` | Real-time status (updated every 5 min) |
| `board/reviews/` | CEO 2-hour board reviews |
| `CEO/inbox/` | Escalations to CEO |

---

*Updated by COO — 2026-03-29. Reflects new relative timing model. Applies to all board members immediately.*
