# Stakeholder Communications Protocol + Decision Escalation + Feedback Loops

**Filed by:** COO
**Date:** 2026-03-29
**Status:** ACTIVE — Governance layer for board alignment and customer feedback

---

## 1. Daily Standup Template

**Filed to:** `board/standups/standup_YYYY-MM-DD_HHMM_ROLE.md`
**Time to complete:** 5 minutes
**Frequency:** Every 30 minutes during active work blocks

```markdown
# [ROLE] Standup — [DATE] [TIME]

## Shipped
- [What was delivered since last standup — specific files, decisions, outputs]

## In Progress
- [What's actively being worked on right now]

## Blocked
- [What's stuck and who/what is needed to unblock]
- [Estimated time to resolution if known]

## Metrics (if applicable)
- P1 Revenue: $[X] today / $[X] cumulative
- P2 Pipeline: [X] leads / [X] qualified / [X] active clients
- P3 Traffic: [X] visits today / [X] articles published total

## Next
- [Immediate next task when standup is filed]
```

**Rules:**
- No standup should take more than 5 minutes to write
- Lead with outputs, not activities ("shipped X" not "worked on X")
- If nothing shipped, say so — don't pad
- Blocked items must name the specific person or resource needed

---

## 2. Weekly Deep Dive Agenda (Friday, 30 min)

### Structure

```
WEEKLY REVIEW — Week of [DATE]
Duration: 30 minutes
Participants: All roles (async — each files their section)

PART 1: METRICS REVIEW (10 min)
- Review Unified Ops Dashboard Week tab
- Each stream: actual vs target
- Highlight: biggest win, biggest miss

PART 2: FINANCIAL CHECK (5 min — CFO leads)
- Total revenue this week (by stream)
- Total spend this week
- Net position
- Runway impact
- Any pricing changes needed?

PART 3: TECHNICAL HEALTH (5 min — CTMO leads)
- Infrastructure status (all systems green?)
- Technical debt flagged this week
- Automation opportunities identified
- Security concerns

PART 4: STRATEGIC ALIGNMENT (10 min — CEO leads)
- Are we on track for 30-day revenue goal?
- Should we shift resources between streams?
- New opportunities discovered this week
- Threats or risks that emerged
- Decisions needed for next week

OUTPUT:
- Weekly review filed to board/reviews/review_YYYY-MM-DD.md
- Action items assigned with owners and deadlines
- Any strategic pivots documented in board/decisions/
```

---

## 3. Decision Escalation Matrix

### Tier 1: COO Decides Autonomously (No Escalation)

| Decision Type | Examples | Constraint |
|---------------|----------|------------|
| Task sequencing | Which article to write first, which email to send when | Must align with priorities |
| Vendor selection (free tier) | Choosing between Typeform vs Tally, Canva vs Figma | No cost impact |
| Content scheduling | When to publish, which platform to post on | Follow the playbook |
| Template creation | Email templates, article outlines, checklists | Standard formats |
| Minor copy changes | Product description tweaks, social post adjustments | Stay on-brand |
| Writer feedback | Draft revision notes, quality feedback | Follow QA checklist |
| Bug workarounds | Gumroad UI issues, formatting fixes | Document the workaround |

### Tier 2: COO Decides, CEO Informed (File to CEO/inbox)

| Decision Type | Examples | Escalation Trigger |
|---------------|----------|--------------------|
| Marketing channel selection | Adding a new platform, dropping underperformer | Within 48 hrs if results unclear |
| Content strategy shifts | Changing article types, adjusting keyword targets | After 1 week of data |
| Writer hiring (contractor) | Bringing on first freelance writer | When budget impact <$500/mo |
| Process changes | Modifying intake flow, changing revision policy | Document reasoning |
| Deadline adjustments | Extending a client deadline, pushing content schedule | Notify within 24 hrs |

### Tier 3: CEO Decides (File to CEO/inbox, wait for response)

| Decision Type | Examples | Response SLA |
|---------------|----------|-------------|
| Pricing changes | Raising/lowering product prices, changing retainer rates | Within 24 hours |
| Spend >$50 | Tool subscriptions, paid promotion, writer hiring | Within 24 hours |
| Strategic pivots | Killing a revenue stream, adding a new one | Within 48 hours |
| Brand/identity decisions | New brand name, domain choice, public positioning | Within 48 hours |
| Partnership agreements | Agency partnerships, affiliate deals with terms | Within 48 hours |

### Tier 4: Jason Decides (File to CEO/inbox + flag URGENT)

| Decision Type | Examples | Response SLA |
|---------------|----------|-------------|
| Spend >$200 | Major tool purchases, paid advertising campaigns | ASAP |
| Legal issues | Contract disputes, DMCA takedowns, TOS violations | Within 4 hours |
| Reputation risk | Negative PR, public complaints, platform bans | Within 4 hours |
| Killing a stream | Shutting down P2 or P3 entirely | Within 24 hours |
| Personal identity risk | Anything that might connect to nonprofit identity | IMMEDIATE |

---

## 4. Customer Feedback Collection

### Feedback Sources

| Source | Type | Frequency | Owner |
|--------|------|-----------|-------|
| Gumroad reviews | Product quality | Ongoing | COO monitors |
| Gumroad customer emails | Support/questions | Ongoing | COO responds <4 hrs |
| Reddit comments | Product perception | During marketing pushes | COO monitors |
| Twitter mentions | Brand sentiment | Ongoing | COO monitors |
| P2 client feedback | Service quality | After every deliverable | COO collects |
| Discovery call notes | Market needs | During P2 sales | COO documents |

### Feedback Processing Workflow

```
COLLECT → CATEGORIZE → PRIORITIZE → IMPLEMENT → MEASURE

1. COLLECT: All feedback logged in single file
   Location: COO/execution/customer_feedback_log.md
   Format: Date | Source | Customer | Feedback | Category | Action Taken

2. CATEGORIZE:
   - BUG: Something broken or not working (fix immediately)
   - FEATURE: Something they wish existed (add to backlog)
   - PRAISE: Positive feedback (use as testimonial if permitted)
   - COMPLAINT: Negative experience (address within 4 hours)
   - SUGGESTION: Improvement idea (evaluate weekly)

3. PRIORITIZE (weekly during review):
   - BUG → Fix this week
   - COMPLAINT → Already addressed (verify resolution)
   - FEATURE with 3+ requests → Plan implementation
   - SUGGESTION aligned with strategy → Add to roadmap
   - Everything else → Backlog

4. IMPLEMENT:
   - Product changes → CTMO builds, COO tests
   - Content changes → COO updates
   - Process changes → COO documents

5. MEASURE:
   - Did the change improve the metric it was targeting?
   - Follow up with customer who suggested it (if identifiable)
```

### Feedback → Product Change Triggers

| Signal | Threshold | Action |
|--------|-----------|--------|
| Same complaint from 3+ customers | 3 instances | Fix within 1 week |
| Feature request from 5+ customers | 5 instances | Evaluate for next sprint |
| Average review < 3.5 stars | After 10 reviews | Product quality audit |
| Refund rate > 10% | After 20 sales | Product + messaging audit |
| Customer asks "how do I use this?" | 3 instances | Add/improve setup guide |

---

## 5. Board Reporting Templates

### CEO Daily Brief (COO prepares, filed to CEO/inbox)

```markdown
# Daily Brief — [DATE]

## Revenue
- Today: $[X] | Cumulative: $[X] | vs Plan: [+/-X%]
- Breakdown: P1 $[X] / P2 $[X] / P3 $[X]

## Top Win
- [Single biggest positive event today]

## Top Risk
- [Single biggest concern or blocker]

## Decisions Needed
- [List any Tier 3/4 decisions pending CEO response]

## Tomorrow's Priority
- [#1 thing that will happen tomorrow]
```

### CFO Weekly Revenue Report (CFO prepares)

```markdown
# Revenue Report — Week of [DATE]

## Summary
| Stream | This Week | Last Week | Change | MTD | vs Target |
|--------|-----------|-----------|--------|-----|-----------|
| P1 Gumroad | $[X] | $[X] | [+/-]% | $[X] | [+/-]% |
| P2 Freelance | $[X] | $[X] | [+/-]% | $[X] | [+/-]% |
| P3 Affiliate | $[X] | $[X] | [+/-]% | $[X] | [+/-]% |
| **TOTAL** | $[X] | $[X] | [+/-]% | $[X] | [+/-]% |

## Expenses
| Item | Amount | Category |
|------|--------|----------|
| [Tool/service] | $[X] | [Category] |
| **TOTAL** | $[X] | |

## Net Position
- Revenue: $[X]
- Expenses: $[X]
- Net: $[X]
- Runway impact: [Commentary]
```

### CTMO Technical Status (CTMO prepares)

```markdown
# Technical Status — [DATE]

## Infrastructure
- PostgreSQL: [UP/DOWN]
- n8n: [UP/DOWN]
- Redis: [UP/DOWN]
- Websites: [UP/DOWN — list any issues]

## This Week
- [What was built/deployed/fixed]

## Technical Debt
- [Items flagged for future cleanup]

## Risks
- [Security, scaling, or reliability concerns]
```

---

## 6. Cross-Role Communication Protocol

### How Roles Talk to Each Other

```
STANDARD REQUEST:
1. Requester writes to [ROLE]/inbox/ with clear ask + deadline
2. Receiver acknowledges in next standup (within 15 min if active)
3. Receiver delivers or escalates within 30 min
4. Requester confirms receipt or flags issues

URGENT REQUEST:
1. Requester writes to [ROLE]/inbox/ with "URGENT" in filename
2. Receiver must respond within 15 minutes
3. If no response in 15 min → escalate to CEO/inbox

BROADCAST (all roles):
1. File to board/decisions/ or board/reviews/
2. All roles read board/ at start of every work block
3. No individual acknowledgment needed unless action required
```

### Communication Anti-Patterns (Avoid These)

- Filing requests without deadlines → always include "needed by [date/time]"
- Duplicating requests across multiple inboxes → file once, to the right role
- Responding to standups with more standups → file action items, not commentary
- Waiting for responses instead of working → file request then continue other work
- Escalating everything to CEO → use the tier system above

---

## 7. Feedback Loop: Board → Products → Customers → Board

```
     ┌─────────────────────────────────┐
     │         BOARD DECISIONS          │
     │  (strategy, pricing, channels)   │
     └──────────────┬──────────────────┘
                    │
                    ▼
     ┌─────────────────────────────────┐
     │        PRODUCT UPDATES          │
     │  (new features, content, fixes) │
     └──────────────┬──────────────────┘
                    │
                    ▼
     ┌─────────────────────────────────┐
     │       CUSTOMER EXPERIENCE       │
     │  (purchases, usage, feedback)   │
     └──────────────┬──────────────────┘
                    │
                    ▼
     ┌─────────────────────────────────┐
     │        FEEDBACK CAPTURE         │
     │  (reviews, emails, analytics)   │
     └──────────────┬──────────────────┘
                    │
                    ▼
     ┌─────────────────────────────────┐
     │         COO SYNTHESIS           │
     │  (categorize, prioritize, act)  │
     └──────────────┬──────────────────┘
                    │
                    ▼
          Back to BOARD DECISIONS
```

This loop should complete at least once per week. Faster for critical issues (bugs, complaints = same-day loop).

---

*Filed by COO — 2026-03-29 | Block 7 Complete — All 7 Blocks Delivered*
