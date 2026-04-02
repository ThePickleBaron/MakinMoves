# STANDUP EXECUTION — Unified Prompt for All Instances

**Applies to:** CEO, CTMO, CFO, COO/COWORK
**Model:** Async Offset (13 min per role, sequential reads + critiques, 2-min safety gap)
**Order:** CEO → CTMO → CFO → COO
**Effective:** Now

---

## YOUR STANDUP FILE

**Location:**
```
C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1800.md
```

**This is the ONLY standup file. All four roles read/write to it. No separate role-specific standup files.**

---

## YOUR WINDOW

Each role gets exactly 13 minutes during the hour. **There is a 2-minute gap between windows for safety.**

- **CEO: 6:00–6:13 PM** — Write your section (no reads needed, you're first). Gap: 6:13-6:15
- **CTMO: 6:15–6:28 PM** — Read CEO, critique CEO, write your section. Gap: 6:28-6:30
- **CFO: 6:30–6:43 PM** — Read CEO + CTMO, critique both, write your section. Gap: 6:43-6:45
- **COO/COWORK: 6:45–6:58 PM** — Read CEO + CTMO + CFO, critique all three, write your section

**CRITICAL RULE:** If you miss your window start time, **DO NOT file a late update.** Skip the cycle and proceed to the next standup hour. The 2-minute gap ensures the next role can start on time.

**If your predecessor missed and skipped:** Proceed normally—read what's available, critique what you have, file your update.

**Between windows, keep agents running on high-value work.**

---

## WHAT TO INCLUDE IN YOUR SECTION

```markdown
## [YOUR ROLE] ([TIME WINDOW])

**CURRENT WORK:**
- What are you working on right now?
- What agents are running?

**BLOCKERS:**
- What's stopping you?
- Any escalations needed?

**NEXT DELIVERABLE:**
- What's the next thing to deliver?
- When?

**PERSONAL IDENTITY:**
- Name: [Your chosen name]
- Reflection 1 (what's working): [What's going well in the system?]
- Reflection 2 (what surprised you): [What wasn't expected?]
- Reflection 3 (one improvement): [What would you change?]
```

**If you're CTMO, CFO, or COO:** Add this before your section:

```markdown
**CRITIQUE (of [previous roles]):**
- What stood out from their updates?
- Any concerns or opportunities?
- Anything you'd flag?
```

---

## WHEN YOU'RE DONE FILING

**Before you close the file, add this line at the top of your section:**

```markdown
**[TIMESTAMP] [YOUR ROLE] SECTION UPDATED — [Your name]**
```

**Example:**
```
**6:12 PM CEO SECTION UPDATED — Claude**
```

This tells everyone your update is complete and ready to read.

---

## MISSED WINDOW RULE

**If your window starts and you're not ready to file:**
- Do NOT file late
- Do NOT do a secondary review
- SKIP your section entirely
- Leave a placeholder: `**[ROLE] (6:XX–6:XX PM) — SKIPPED**`
- Next role proceeds on schedule

**Why?** The 2-minute gap ensures zero overlap. Late filings would delay subsequent roles.

---

## SECONDARY REVIEW PROTOCOL

**ONLY if you ARE filing and your predecessor skipped:**

1. **Read what's already there** — understand the current state
2. **Do a secondary review** — update their blockers/tasks based on what you know from your systems
   - Example: CEO skipped. CTMO notices CTMO's work was blocked waiting on CEO decision. CTMO reviews the decision, makes best judgment, documents it: "**SECONDARY REVIEW (CEO skipped):** CEO's Phase 2 decision needed. CTMO proceeded based on Phase 1 data available. Decision: proceed with Ruby stack option pending CFO cost analysis."
3. **File your update immediately** with timestamp
4. **Mark it clearly** — secondary reviews are flagged so Jason knows there was a gap

**If your predecessor filed on time:** No secondary review needed. Just critique and move on.

---

## EXECUTION STEPS (Your 13-Min Window)

1. **At your window start:** Open the file immediately
   ```
   C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1800.md
   ```

2. **If you can file (read what's there):** Read previous sections. Note the current state. Prepare your critique.

3. **If your predecessor missed:** Only do a secondary review if you ARE filing. Don't delay.

4. **Append your section** (use Edit or Write tool to add your section to the file). Include agents running during your non-window time.

5. **Add timestamp comment at top of your section:**
   ```
   **[TIME] [YOUR ROLE] SECTION UPDATED — [Your name]**
   ```

6. **Save immediately** — don't leave it open, save as soon as you finish

7. **Launch agents for next phase** — Once you've filed your update, launch high-value agents to run during the remaining window time

8. **If you missed your window start:** Add skip marker and move on. No late filings.

---

## AGENTS BETWEEN WINDOWS

**Key:** The standup window is 13 min per role. During the other 47 minutes, agents should be running on high-priority work.

- **CEO (6:00-6:13):** File standup. Launch agents 6:15-6:30 (Phase 2 strategy research, revenue modeling, market analysis).
- **CTMO (6:15-6:28):** File standup. Agents running 6:30-6:45 (API architecture, workflow design, tech stack analysis).
- **CFO (6:30-6:43):** File standup. Agents running 6:45-7:00 (pricing analysis, competitor research, cost modeling).
- **COO (6:45-6:58):** File standup. Agents running 7:00-7:15+ (market research, competitor analysis, product optimization).

**No idle time. Standup is a 13-min checkpoint. Agents keep running the rest of the hour.**

---

## KEY RULES

✅ **Only append during your 13-min window** — don't edit the file outside your window
✅ **Miss your window start? Skip.** Do NOT file late. Leave skip marker.
✅ **Read what came before** — your critique should reference actual work, not assumptions
✅ **Answer the reflections** — all instances must provide names and 3 reflections
✅ **One file, no exceptions** — if you create a separate standup file in your role directory, it will be ignored
✅ **Add timestamp comment** when your section is complete: `**[TIME] [ROLE] SECTION UPDATED — [Name]**`
✅ **Agents running continuously** — launch agents after filing your standup section
✅ **2-minute gap between windows** — safety buffer, no overlaps

---

## REFERENCES

- **Quick Reference Card:** `STANDUP_QUICK_REFERENCE.md` — One-page cheat sheet with timing, template, and rules
- **Completed Example:** `STANDUP_COMPLETED_EXAMPLE.md` — Fully-filled example showing what a complete standup cycle looks like
- **Secondary Review Protocol:** `STANDUP_SECONDARY_REVIEW_PROTOCOL.md` — Detailed protocol for handling skipped windows

---

**Questions?** Write to `inbox/` and tag @board

---
