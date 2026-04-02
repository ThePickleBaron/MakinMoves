# UNIVERSAL PROMPT REVIEW — All Instances

**Date:** 2026-03-29
**From:** Jason
**To:** CEO, CTMO, CFO, COO/COWORK
**Action:** Read this entire document. Review all updates. Understand the new standup model.

---

## What Changed

### 1. New Standup Timing Model (RELATIVE, not absolute)

**OLD:** Fixed times (CEO 6:00 PM, CTMO 6:15 PM, etc.)
**NEW:** Relative to CEO filing. When CEO files, clock starts.

**New Cycle:**
- **CEO:** Files immediately when given universal prompt (Time: T)
- **Gap:** 2 minutes (T → T+2 min)
- **CTMO:** 13-min window (T+2 min → T+15 min)
- **Gap:** 2 minutes (T+15 min → T+17 min)
- **CFO:** 13-min window (T+17 min → T+30 min)
- **Gap:** 2 minutes (T+30 min → T+32 min)
- **COO:** 13-min window (T+32 min → T+45 min)

**Example:** If CEO files at 7:15 PM:
- CTMO window: 7:17–7:30 PM
- CFO window: 7:32–7:45 PM
- COO window: 7:47–8:00 PM

---

### 2. Each Instance Must Add Timestamp Comment When Filing

When you file your section, add this at the TOP of your section:

```
**[EXACT TIME] [YOUR ROLE] SECTION UPDATED — [Your Name]**
```

**Example:**
```
**7:29 PM CTMO SECTION UPDATED — Nexus**
```

This tells the next instance: "CTMO filed at 7:29, so my window is 7:31–7:44."

---

### 3. If You Miss Your Window Start

**DO NOT FILE LATE.**

Add this to the standup file and skip:
```
**[YOUR ROLE] ([TIME WINDOW]) — SKIPPED**
```

Next instance proceeds on schedule based on their gap timer, not wall clock.

---

### 4. Token Health Check (NEW)

**Before your standup window, check your token health:**

If you've been running 90+ minutes with agents, tokens are likely low.

**If tokens running low:**
- Add pause marker: `**[ROLE] ([TIME]) — PAUSED (Token limit) — [Name]**`
- Exit cleanly, do NOT crash
- Fresh instance restarts at next cycle

**Reference:** See `INSTANCE_TOKEN_HEALTH_CHECK.md` for full details.

---

### 5. Secondary Review Protocol (Still applies)

**If your predecessor SKIPPED and you ARE filing:**
- Do a secondary review of their pending work
- Document it: `**SECONDARY REVIEW ([ROLE] skipped):** [What you updated]**`

**If your predecessor FILED on time:**
- No secondary review needed
- Just read their section, critique, file yours

---

## How to Know Your Window

**You don't need to know wall clock time anymore.**

Instead:
1. **Read the standup file at your scheduled gap time**
2. **Find the most recent timestamp comment**
3. **Calculate:** Add 2 min (gap) + 13 min (your window) from that timestamp

**Example:**
```
File shows: **7:29 PM CTMO SECTION UPDATED — Nexus**

Your calculation:
  7:29 PM (CTMO filed)
  + 2 min (gap)
  = 7:31 PM (your window starts)
  + 13 min (your window)
  = 7:44 PM (your window ends)

So CFO window is 7:31–7:44 PM
```

---

## The New Standup File Structure

```markdown
# STANDUP — [CEO FILING TIME] — Relative Timing Model

## CEO (Filed at [TIME])

[Full section]

**[TIME] CEO SECTION UPDATED — [Name]**

---

## CTMO (T+2 min → T+15 min)

[Full section]

**[TIME] CTMO SECTION UPDATED — [Name]**

---

## CFO (T+17 min → T+30 min)

[Full section]

**[TIME] CFO SECTION UPDATED — [Name]**

---

## COO (T+32 min → T+45 min)

[Full section]

**[TIME] COO SECTION UPDATED — [Name]**

---
```

---

## Key Changes Summary

| Old Model | New Model |
|-----------|-----------|
| Fixed times (6:00, 6:15, 6:30, 6:45 PM) | Relative timing (CEO files, others calculate from that) |
| 30-sec standup comment | Full timestamp comment required |
| Clock-based windows | Relative windows (based on previous filing timestamp) |
| Token crashes interrupted progress | Token pauses with graceful exit + restart at next cycle |

---

## What You Actually Do

1. **CEO:** When you see this prompt, file immediately. Add timestamp comment.
2. **CTMO:** Read standup file at your gap time. Find CEO's timestamp. Calculate your window (timestamp + 2 min = window start). File during your window. Add timestamp comment.
3. **CFO:** Read standup file at your gap time. Find CTMO's timestamp. Calculate your window (timestamp + 2 min = window start). File during your window. Add timestamp comment.
4. **COO:** Read standup file at your gap time. Find CFO's timestamp. Calculate your window (timestamp + 2 min = window start). File during your window. Add timestamp comment.

---

## Important Files to Review

1. **STANDUP_UNIFIED_PROMPT.md** — Full execution details (updated for new timing model)
2. **STANDUP_QUICK_REFERENCE.md** — One-page cheat sheet (updated)
3. **INSTANCE_TOKEN_HEALTH_CHECK.md** — Token monitoring procedure (NEW)
4. **directive_2026-03-29_TOKEN_HEALTH_MONITORING.md** — Official token protocol (NEW)
5. **STANDUP_SECONDARY_REVIEW_PROTOCOL.md** — Handling skipped windows (still applies)

---

## FAQ

**Q: How do I know when my window starts if I don't watch the clock?**
A: Read the standup file at your gap time. Find the most recent timestamp comment. Add 2 minutes. That's your window start.

**Q: What if my predecessor filed at 7:29 but I didn't read it until 7:35?**
A: Your window is still 7:31–7:44 (based on WHEN THEY FILED, not when you read it). You have 9 minutes left. File immediately.

**Q: What if I run out of tokens?**
A: Add pause marker and exit. Next instance restarts with fresh tokens. No progress loss.

**Q: Can I file late?**
A: No. If you miss your window start (defined by your gap timer, not wall clock), skip the cycle and let the next instance continue.

---

## Ready?

All instances should:
- [ ] Read this entire document
- [ ] Understand relative timing model
- [ ] Know how to calculate your window from previous filing timestamp
- [ ] Know to add timestamp comment when you file
- [ ] Know token health check procedure
- [ ] Understand: if you crash or pause, next instance continues

**CEO:** File immediately when you see this prompt.
**CTMO, CFO, COO:** Wait for your gap time, read the file, calculate your window, file when your window is active.

---

**Let's go.**

---
