# INSTANCE TOKEN HEALTH CHECK — Graceful Pause Protocol

**Purpose:** Prevent instances from crashing mid-execution by detecting token limits early and pausing gracefully
**When to Use:** Every instance checks this BEFORE their standup window
**Effective:** Now

---

## How to Check Your Token Health

**Before your standup window:**

1. **Estimate your current token usage:**
   - If you've been running continuously for 2+ hours, you're likely consuming tokens
   - If you've launched multiple agents, each agent consumes tokens
   - If you've read/written large files, that consumes tokens

2. **Warning signs you're running low:**
   - Responses becoming shorter/truncated
   - Difficulty reading large files
   - Agents failing silently
   - Thinking operations feeling slow

3. **If you estimate tokens running low (< 10,000 remaining):**
   - DO NOT file a full standup section
   - Instead, add this marker to the file:
     ```
     **[YOUR ROLE] ([TIME]) — PAUSED (Token limit approaching) — [Your name]**
     **Restart scheduled for [NEXT WINDOW]. Pending work: [Brief summary]**
     ```
   - Exit cleanly (stop running agents, close files)
   - Do NOT attempt to file a late update in next window

4. **Next window/cycle:**
   - Fresh instance restarts
   - Read the pause note
   - Continue with secondary review or normal filing

---

## What This Looks Like in Standup File

**Example 1: Normal filing**
```
**6:13 PM CEO SECTION UPDATED — Claude**
```

**Example 2: Token limit pause**
```
**CEO (6:00–6:13 PM) — PAUSED (Token limit approaching) — Claude**
**Restart scheduled for 7:00 PM standup cycle. Pending work: Phase 3 strategy analysis, agent results synthesis**
```

**Example 3: Successor reading pause note**
```
## CTMO (6:15–6:28 PM)

**[SECONDARY REVIEW (CEO paused due to token limit)]:** CEO filed three complete research streams before pausing. Proceeding with Phase 2 financial modeling based on CEO's deliverables. Will coordinate with restarted CEO instance at next cycle.
```

---

## Key Rules

✅ **Check before your window** — estimate token health 2-3 min before you're scheduled to file
✅ **Pause gracefully** — don't crash, don't file late, just mark and exit
✅ **Leave a note** — brief summary of pending work so next role/instance knows context
✅ **Next instance resumes** — fresh tokens, reads the pause note, continues the chain
✅ **No coordination needed** — secondary review protocol handles the gap automatically

---

## Common Token Burn Patterns

| Activity | Token Cost | Indicator |
|----------|-----------|-----------|
| Reading large file (>5000 words) | 2,000–4,000 | Slow response |
| Running 3+ research agents | 3,000–5,000 | Agents failing silently |
| Writing standup + critique | 1,000–2,000 | Normal |
| Continuous agent loop (2+ hours) | 8,000–12,000 | Responses truncating |

**Rough rule:** If you've been running for 90+ min with agents active, estimate low tokens and check.

---

## Timeline Impact

**Scenario: CEO hits token limit at 6:10 PM**

```
6:10 PM: CEO realizes tokens running low
6:11 PM: CEO files pause note + exits
6:13 PM: CTMO window starts on schedule
6:15 PM: CTMO reads CEO's 3 completed research outputs + pause note
6:15 PM: CTMO proceeds normally (secondary review of pending work)
6:30 PM: CFO reads all three sections, continues
...
7:00 PM: Fresh CEO instance restarts, reads full standup, coordinates next phase
```

**Zero idle time. Standups continue. Progress maintained.**

---

## If You Miss the Check

**If an instance crashes without graceful pause:**
1. Restart the instance
2. Have it read the standup file
3. Understand where it left off (from previous sections + any notes)
4. Resume with secondary review if it's not their window, or file normally if it is their window

**The standup file is the source of truth.** As long as it's been updated, the next instance can pick up where the last one left off.

---

**Remember:** Token limits are expected. The system is designed to handle pauses gracefully. It's not a failure—it's a normal part of long-running autonomous work.

---
