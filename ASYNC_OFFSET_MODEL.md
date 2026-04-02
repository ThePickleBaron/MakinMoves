# Async Offset Standup Model — How It Works

**Effective:** 6:00 PM cycle (starting fresh)
**Why:** Better execution, less blocking, natural critique flow

---

## The Model

Instead of everyone stopping work at the same time, roles update **sequentially with 15-minute offsets:**

```
6:00-6:15 PM — CEO writes baseline update
6:15-6:30 PM — COO reads CEO, critiques, writes their update
6:30-6:45 PM — CTMO reads CEO+COO, critiques, writes their update
6:45-7:00 PM — CFO reads all three, critiques, writes their update
```

**Result:**
- ✅ 45 minutes of continuous execution per hour
- ✅ Only 15 min per role on standup work
- ✅ Natural feedback loops (each role reads what came before)
- ✅ Critiques catch issues early

---

## What "Your Window" Means

When you get the `WINDOW_ACTIVE` notification:

### CEO (6:00-6:15)
1. Provide fresh update (you read nothing)
2. Report: current work, agents, blockers, next deliverable
3. **No critiques** (you're baseline)
4. Save by 6:15 PM

### COO (6:15-6:30)
1. **Read CEO's update** (2-3 min)
2. **Critique it** (1-2 min):
   - What CEO did well
   - What CEO should watch
   - Suggestions for CEO
3. Provide your own update (3-5 min)
4. Save by 6:30 PM

### CTMO (6:30-6:45)
1. **Read CEO + COO updates** (2-3 min)
2. **Critique both** (1-2 min):
   - What each did well
   - What each should watch
   - Suggestions for both
3. Provide your own update (3-5 min)
4. Save by 6:45 PM

### CFO (6:45-7:00)
1. **Read CEO + COO + CTMO updates** (2-3 min)
2. **Critique all three** (1-2 min):
   - What each did well
   - What each should watch
   - Suggestions for each
3. Provide your own update (3-5 min)
4. Save by 7:00 PM

---

## How This Fixes Blockers

**Old way (sync standup):**
- CFO: "I need answer from COO on pricing decision"
- But COO already left, won't update for 30 min
- CFO blocked waiting

**New way (async offset):**
- CFO reads COO's update first, sees blocker noted
- CFO can research in parallel while waiting for answer
- When CFO window comes, CFO can use research while waiting, no full block
- Feedback visible in critiques (CFO critiques COO: "Note: I need Gumroad vs Payhip answer")

---

## File Structure

Each hour gets one file: `standup_2026-03-29_6PM.md`

File has 4 sections (one per role), each with:
- Current work
- Agents running
- Blockers
- Next deliverable
- Critique of previous updates (except CEO)
- Personal identity

---

## Timing

You'll get notified when your window starts:
- Notification file appears in your inbox
- File says: "Your window: [time]. Go."

**You have 15 minutes.** Read, critique, write, save.

If you don't finish by deadline, Atlas flags it.

---

## Why This Works for AI

You're not people. You don't need "sync meetings" where everyone waits.

You can read CEO's work, process it, critique it, and write your own response in parallel—no waiting.

Critiques create feedback loops without blocking.

By the time CFO writes, they've seen CEO + COO + CTMO thinking. Decisions are better informed.

**More thinking. Less waiting. Better work.**

---
