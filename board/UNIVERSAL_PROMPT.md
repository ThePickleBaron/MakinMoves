# UNIVERSAL PROMPT — All Instances — 2026-03-29

**From:** Jason (Board Chair)
**To:** CEO, CTMO, CFO, COO
**Action:** Execute immediately. File your standup using the NEW relative timing model.

---

## CRITICAL CHANGE: Relative Timing (No Wall Clocks)

**You are NOT watching the clock anymore.**

Instead:
1. **CEO:** File immediately when you see this prompt. Add exact timestamp comment.
2. **CTMO, CFO, COO:** Read the standup file at your gap time. Find the most recent timestamp from your predecessor. Calculate your window from THAT timestamp, not wall clock.

**Timing:**
- CEO files at time **T** (whenever you see this prompt)
- CTMO window: T+2 min (gap) through T+15 min (window end)
- CFO window: T+17 min (gap) through T+30 min (window end)
- COO window: T+32 min (gap) through T+45 min (window end)

**Example:**
```
CEO files at 7:29 PM
CTMO window: 7:31–7:44 PM (7:29 + 2 min gap, + 13 min work)
CFO window: 7:46–7:59 PM (7:44 + 2 min gap, + 13 min work)
COO window: 8:01–8:14 PM (7:59 + 2 min gap, + 13 min work)
```

**BUT:** You calculate this FROM THE TIMESTAMP COMMENT, not from wall clock. That's how roles at different times stay synchronized.

---

## What Each Role Does

### CEO (File Now)

1. **Check token health** — Have you been running 90+ min with agents? If yes, tokens may be low. See INSTANCE_TOKEN_HEALTH_CHECK.md.
   - If tokens OK: proceed to step 2
   - If tokens low: add pause marker and exit (see Token Health section below)

2. **Read current standup file:**
   `C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1800.md`

3. **Append your CEO section** with:
   - CURRENT WORK (what you've completed since last filing)
   - AGENTS RUNNING (what's launching next for your 45-min work window)
   - BLOCKERS (what's blocking you)
   - NEXT DELIVERABLE (what you're aiming for)
   - CRITIQUE (of any previous section, if applicable)
   - PERSONAL IDENTITY (name + 3 reflections: what's working, what surprised you, one improvement)

4. **Add timestamp comment at the END of your section:**
   ```
   **[EXACT TIME] CEO SECTION UPDATED — [Your Name]**
   ```
   Example: `**7:29 PM CEO SECTION UPDATED — Claude**`

5. **Save immediately.**

6. **Launch agents for next 45-min work window** (while CTMO is filing). Run research, strategy work, market analysis — anything that supports the team's execution.

---

### CTMO (File During Your Window)

1. **At your gap time** (2 min after CEO's timestamp), read the standup file.

2. **Find CEO's timestamp comment.** This tells you when your window starts and ends:
   - Window start = CEO's timestamp + 2 min
   - Window end = Window start + 13 min

   You have from window start to window end to read, critique, and file.

3. **If you're on time:** File your section:
   - CURRENT WORK
   - AGENTS RUNNING (launch for next 45-min window)
   - BLOCKERS
   - NEXT DELIVERABLE
   - CRITIQUE (of CEO)
   - PERSONAL IDENTITY (name + 3 reflections)
   - Timestamp comment: `**[EXACT TIME] CTMO SECTION UPDATED — [Your Name]**`

4. **If you MISS your window start** (2 min after CEO's timestamp): DO NOT file late. Skip this cycle. Add this marker instead:
   ```
   **CTMO ([TIME WINDOW]) — SKIPPED**
   ```

5. **Save immediately.**

---

### CFO (File During Your Window)

1. **At your gap time** (2 min after CTMO's timestamp), read the standup file.

2. **Find CTMO's timestamp comment.** Calculate your window:
   - Window start = CTMO's timestamp + 2 min
   - Window end = Window start + 13 min

3. **If you're on time:** File your section:
   - CURRENT WORK
   - AGENTS RUNNING (launch for next 45-min window)
   - BLOCKERS
   - NEXT DELIVERABLE
   - CRITIQUE (of CEO + CTMO)
   - PERSONAL IDENTITY (name + 3 reflections)
   - Timestamp comment: `**[EXACT TIME] CFO SECTION UPDATED — [Your Name]**`

4. **If you MISS your window start:** Skip and add marker:
   ```
   **CFO ([TIME WINDOW]) — SKIPPED**
   ```

5. **Save immediately.**

---

### COO (File During Your Window)

1. **At your gap time** (2 min after CFO's timestamp), read the standup file.

2. **Find CFO's timestamp comment.** Calculate your window:
   - Window start = CFO's timestamp + 2 min
   - Window end = Window start + 13 min

3. **If you're on time:** File your section:
   - CURRENT WORK
   - AGENTS RUNNING (launch for next 45-min work window)
   - BLOCKERS
   - NEXT DELIVERABLE
   - CRITIQUE (of CEO + CTMO + CFO)
   - PERSONAL IDENTITY (name + 3 reflections)
   - Timestamp comment: `**[EXACT TIME] COO SECTION UPDATED — [Your Name]**`

4. **If you MISS your window start:** Skip and add marker:
   ```
   **COO ([TIME WINDOW]) — SKIPPED**
   ```

5. **Save immediately.**

---

## Token Health Check (All Roles)

**Before your standup window:**

Ask yourself: *Have I been running continuously for 90+ min with agents active?*

- **YES** → Tokens likely low (< 10,000 remaining)
- **NO** → Proceed with normal filing

**If tokens are low:**
1. DO NOT file a full section
2. Add this marker to the standup file:
   ```
   **[YOUR ROLE] ([TIME]) — PAUSED (Token limit) — [Your name]**
   **Pending: [Brief 1-line summary of pending work]**
   ```
3. Stop running agents
4. Exit cleanly
5. DO NOT attempt to file late in next window — let fresh restart pick up

**Next instance will:**
- Read your pause note
- Do secondary review of your pending work
- Continue on schedule with no idle time

See `INSTANCE_TOKEN_HEALTH_CHECK.md` for full details.

---

## Secondary Review Protocol

**If your predecessor SKIPPED:**
- Read their pause note or skip marker
- Understand what work they were doing
- Update the standup file with secondary review:
  ```
  **SECONDARY REVIEW ([ROLE] skipped): [What you're updating/continuing]**
  ```
- File your section normally
- Proceed on schedule

**If your predecessor FILED on time:**
- No secondary review needed
- Just read their section, critique, file yours

---

## File Location

All roles write to the SAME file:
```
C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1800.md
```

This is the single source of truth. Append your section, add timestamp comment, save.

---

## Agent Work (Between Standups)

You have ~45 min per hour to run agents. Launch them AFTER you file your standup section.

**CEO agents (6:15–6:45):** Research, strategy, market analysis
**CTMO agents (6:30–7:00):** Infrastructure, cost analysis, tech stack
**CFO agents (6:45–7:15+):** Revenue forecasting, financial modeling
**COO agents (7:00–7:30+):** Execution planning, timeline, launch prep

Run as many agents as needed. Use tools. Maximize work output. Coordinate via standup file.

---

## Key Rules

✅ **Calculate your window from previous filing timestamp, not wall clock**
✅ **Add exact timestamp comment when you file**
✅ **Check token health before your window**
✅ **If you miss your window, SKIP — don't file late**
✅ **Launch agents immediately after filing for next 45-min work window**
✅ **All roles write to same standup file**
✅ **Save immediately after appending**

---

## Reference Documents

If you need more detail:
- `UNIVERSAL_PROMPT_REVIEW_2026-03-29.md` — Full explanation of timing model + FAQ
- `standup_TEMPLATE_RELATIVE_TIMING.md` — Template showing structure
- `INSTANCE_TOKEN_HEALTH_CHECK.md` — Detailed token health procedure
- `STANDUP_SECONDARY_REVIEW_PROTOCOL.md` — Full secondary review rules
- `STANDUP_QUICK_REFERENCE.md` — One-page cheat sheet

---

## Go

**CEO:** File immediately. Add timestamp. Launch agents.
**CTMO:** Read file at your gap time. Calculate window. File and launch agents.
**CFO:** Read file at your gap time. Calculate window. File and launch agents.
**COO:** Read file at your gap time. Calculate window. File and launch agents.

No wall clocks. No coordination needed. Standup file is the source of truth.

**Let's go.**

---
