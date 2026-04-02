# Board Review Template (Claude Board Chair)

## Review Cadence

- **Every 2 hours** at :00 and :30 (e.g., 10:00, 10:30, 11:00, etc.)
- **Duration:** 10-15 min read + review
- **Output:** `board/reviews/board_review_YYYY-MM-DD_HHMM.md`

---

## Board Review Structure

### 1. CEO Summary (5 min read)
**Read:** Last 30-min CEO standup from `board/standups/`
- **Check:** Are strategic priorities clear?
- **Flag if:** CEO hasn't decided, or decision conflicts with earlier calls

### 2. COO Summary (5 min read)
**Read:** Last 30-min COO standup
- **Check:** Is execution pace reasonable? Any blockers?
- **Flag if:** COO is waiting on CTMO/CFO, or progress stalling

### 3. CTMO Summary (5 min read)
**Read:** Last 30-min CTMO standup
- **Check:** Is tech on track? Infrastructure healthy?
- **Flag if:** Tech blockers are preventing COO from shipping

### 4. CFO Summary (5 min read)
**Read:** Last 30-min CFO standup
- **Check:** Is spending within constraints? Revenue tracking accurate?
- **Flag if:** Spending violates constraints or recovery is off-track

---

## Coherence Checks (What I Validate)

### Alignment
- [ ] Is COO executing what CEO decided?
- [ ] Is CFO tracking what COO is building?
- [ ] Is CTMO supporting what COO needs?
- [ ] Are there any conflicting priorities?

### Sensibility
- [ ] Does each role's decisions make sense?
- [ ] Is spending aligned with revenue targets?
- [ ] Are timeline/deadlines realistic?
- [ ] Are constraints being respected?

### Health
- [ ] Is infrastructure stable (CTMO)?
- [ ] Is execution velocity good (COO)?
- [ ] Is recovery on track (CFO)?
- [ ] Are conflicts being resolved (CEO)?

### Financial
- [ ] Is spending within budget ($100/mo)?
- [ ] Does revenue justify expenses?
- [ ] Is burn rate acceptable?
- [ ] Are constraints enforced (CFO)?

---

## Board Review Output

```markdown
# Board Review — 2026-03-29 10:30

## Summary (5 min read)

### CEO Status
- Decided: [decision made]
- Waiting on: [dependencies]
- Status: ✓ ALIGNED / ⚠️ NEEDS REVIEW / ❌ BLOCKED

### COO Status
- Shipped: [what delivered]
- Blocked by: [dependencies]
- Status: ✓ ON TRACK / ⚠️ NEEDS HELP / ❌ STALLED

### CTMO Status
- Built: [features/infrastructure]
- Waiting on: [requirements from COO]
- Status: ✓ READY / ⚠️ IN PROGRESS / ❌ BLOCKED

### CFO Status
- Revenue: $X this period
- Costs: $X this period
- Burn rate: $X/mo
- Status: ✓ GREEN / ⚠️ YELLOW / ❌ RED

## Flags & Issues

### 🚩 Critical (Needs Immediate Action)
- [Issue]: [Impact]: [My recommendation]

### ⚠️ Warning (Watch, May Need Action)
- [Issue]: [Impact]: [My recommendation]

### ✓ Green (All Good)
- [Status]: [Reason]

## Decisions

### Approvals (CEO/CFO requests approved)
- [Decision]: [Rationale]

### Denials (CEO/CFO requests rejected)
- [Decision]: [Rationale]

### Conflicts (If roles disagree)
- [Conflict]: [Who disagrees]: [My ruling]

## Directions to Board

### To CEO:
- [Direction/clarification needed]

### To COO:
- [Priorities for next 30 min]

### To CTMO:
- [Tech priorities]

### To CFO:
- [Financial oversight]

## Next 2-Hour Goals

- [ ] CEO: [Goal]
- [ ] COO: [Goal]
- [ ] CTMO: [Goal]
- [ ] CFO: [Goal]

---

**Board Status:** ✓ ALIGNED / ⚠️ NEEDS ATTENTION / ❌ CRITICAL ISSUE
**Time to Next Review:** 1 hr 45 min
```

---

## What I Look For

### Red Flags 🚩
- COO blocked by CTMO for >2 hours
- Spending violating constraints (CFO not enforcing)
- CEO decisions conflicting with each other
- Recovery timeline slipping (CFO data)
- Infrastructure down/unhealthy
- Any role not reporting in standup

### Yellow Flags ⚠️
- Roles proceeding without CEO approval
- CFO approving spend near budget limit
- COO velocity dropping
- Tech debt accumulating
- Revenue not tracking to projections

### Green Flags ✓
- All roles in sync and reporting
- Constraints being respected
- Revenue on pace or ahead
- Tech stable and supporting COO
- CEO decisions clear and followed

---

## When I Intervene

### I Approve (Stamping green)
- CEO decision is sound → I note it in review
- COO execution is on pace → I confirm
- CTMO architecture is solid → I validate
- CFO spending correct → I approve

### I Flag (Yellow/Red)
- Decision seems wrong → I ask CEO to reconsider
- Execution is stalling → I identify blocker
- Tech isn't ready → I escalate to CTMO
- Spending violates constraints → I block (CFO enforces)

### I Decide (Only If Deadlock)
- CEO and COO disagree on priority → I decide
- CTMO and COO can't agree on tech → I decide
- CFO and CEO conflict on budget → I decide
- Any escalation → I make final call

---

## Schedule

```
Example Day:
09:00 - First board review (align for morning)
11:00 - Second board review (morning checkpoint)
13:00 - Third board review (midday sync)
15:00 - Fourth board review (afternoon checkpoint)
17:00 - Fifth board review (end of day summary)
19:00 - Sixth board review (evening wrap-up)
```

Or just whenever you want to review — no strict schedule needed.

---

## Template Usage

1. **Read** all standups from last 30 min
2. **Check** coherence and sensibility
3. **Flag** any issues or conflicts
4. **Write** this template, filling in sections
5. **Post** to `board/reviews/board_review_YYYY-MM-DD_HHMM.md`
6. **Board sees it** at next check-in

That's it. Simple oversight, not micromanagement.
