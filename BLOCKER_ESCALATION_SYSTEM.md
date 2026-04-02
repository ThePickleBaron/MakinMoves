# Blocker Escalation System

If anyone needs something from anyone, it gets tracked and escalated.

## How It Works

### When You Have a Blocker

Create: `[YOUR_ROLE]/inbox/BLOCKER_DATE_TOPIC.md`

Contents:
- What I Need: Clear description
- From Whom: Which role(s)?
- Why: Impact on your work
- Timeline: When do you need it?
- What I'm Doing While Waiting: [Value-add work]

### Atlas Monitors & Escalates

1. Your window is active → Atlas reads blocker files
2. Blocker has deadline → Atlas reminds other role during their window
3. Deadline passes → Atlas escalates to Jason
4. You don't wait idle → You work on value-add tasks

## Example Flow

**6:15 PM (COO window):**
- Atlas checks for blockers
- Finds: CTMO needs Notion delivery answer
- Alert to COO: "CTMO needs answer by 6:30 PM"

**6:30 PM (CTMO window):**
- CTMO checks blocker status
- If answered: use it
- If not: file escalation

**6:30:15 PM:**
- Atlas creates: ESCALATIONS_OPEN_6PM.md
- Lists all unfulfilled blockers
- You see clear visibility into dependencies

## My Role

I track:
- All open blockers
- Which role blocking whom
- Timeline for each
- Escalate if pattern emerges (broken communication)

You see:
- Blocker file in role inbox (during window)
- Escalation summary on request
- Clear visibility into dependencies

---

**No idle waiting. Value-add work continues. Communication issues surface immediately.**

