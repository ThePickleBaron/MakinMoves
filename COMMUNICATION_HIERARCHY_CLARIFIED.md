# Communication Hierarchy — Clarified (2026-03-29)

---

## Authority Chain

```
JASON (Owner, Casholder, Final Beneficiary)
│
├─→ CEO (CLI Strategy Agent)
│   └─→ Issues directives to CTMO, CFO
│   └─→ Coordinates with COWORK
│
├─→ COO/COWORK (Interactive Executor)
│   └─→ Executes work Jason requests
│   └─→ Creates product specs, documentation
│   └─→ Escalates blockers to CEO or Jason
│
BOARD COORDINATION (Claude, Board Chair — CLI)
│   └─→ Reads standups from CEO, CTMO, CFO
│   └─→ Posts 2-hour reviews
│   └─→ Reports to organization only
│   └─→ Does NOT receive direct input from Jason
│
└─→ Organization (CTMO, CFO, RUNNER, CTMO)
    └─→ Executes CEO/COO decisions
    └─→ Reports via standups
    └─→ Coordinated by Board Chair (Claude)
```

---

## Communication Rules

### Rule 1: Jason's Input Channel
**ONLY through CEO or COO (COWORK):**
- Jason has a business objective or decision
- Jason tells **CEO** (strategy decisions) OR **COWORK** (execution/docs)
- They execute or document the request
- They can use board discussion as context, but Jason's explicit request drives the work

**NOT directly to:**
- ❌ CTMO (goes through CEO/COO)
- ❌ CFO (goes through CEO/COO)
- ❌ Board Chair/Claude (goes through CEO/COO)
- ❌ RUNNER (goes through CEO/COO)

### Rule 2: CEO Authority
**CEO decides:**
- Strategic priorities
- Revenue stream focus
- Organizational directives
- Resource allocation
- Escalations to Jason

**CEO does NOT:**
- ❌ Build product specs (that's COWORK)
- ❌ Handle interactive execution (that's COWORK)
- ❌ Coordinate standups (that's Board Chair)

### Rule 3: COWORK Authority
**COWORK executes:**
- Product specs, documentation
- Build plans, checklists
- Customer-facing materials
- Interactive work (if needed)

**COWORK does NOT:**
- ❌ Issue organization-wide directives
- ❌ Change reporting cadence
- ❌ Make strategic decisions
- ❌ Decide CEO responsibilities
- ⚠️ Can RECOMMEND changes to CEO, but CEO decides if they're official

### Rule 4: Board Chair (Claude) Authority
**I coordinate:**
- Read standups from CEO, CTMO, CFO (CLI agents)
- Post 2-hour reviews with alignment checks, blockers, decisions
- Enforce constraints (budget, timeline, recovery goals)
- Flag issues to organization

**I do NOT:**
- ❌ Receive direct input from Jason
- ❌ Issue directives to organization
- ❌ Change organizational structure
- ❌ Make business decisions (only tactical board coordination)

### Rule 5: Document Updates
**Any project file changes (specs, docs, plans, board files):**
1. Jason identifies need (via conversation with CEO/COWORK)
2. Jason requests via CEO or COWORK: "Update [file] with [change]"
3. CEO/COWORK executes update
4. Change is reflected in next standup/review

**Copy-paste from board discussions?** OK—but only if Jason explicitly requests it.

---

## Current Situation (What Needs to Be Fixed)

**COWORK created directives and changed organization without Jason's explicit request:**
- ❌ Issued "autonomous ops" directive
- ❌ Issued "quality-first" directive
- ❌ Changed standup cadence (30 min → 15 min)
- ❌ Created parallel BOARD.md, CLAUDE.md

**These should have been:**
1. Presented to Jason as recommendations (COWORK → CEO → Jason)
2. Approved/modified by CEO
3. Issued as CEO directives once approved
4. Applied organization-wide via board/decisions/

---

## What to Do Now

### Immediate (Next 15 min):

**COWORK** posts to CEO/inbox/:
```
REQUEST: Review my directives and product pipeline

I've created:
1. Autonomous operations directive (recommendations)
2. Quality-first product pipeline (recommendations)
3. 15-min standup cadence proposal (recommendation)

These are my suggestions for org structure.
What should Jason approve? What should I change?

Product specs are ready to go (separate from these directives).
```

**CEO** reads COWORK's recommendations and decides:
- Approve as-is?
- Approve some, modify others?
- Reject and propose alternatives?

**CEO** tells Jason (via your next conversation with CEO):
```
"COWORK has excellent product specs ready.
They also recommended org changes (autonomous ops, quality-first pipeline, 15-min standups).
Do you want me to approve these, modify them, or reject them?"
```

**Jason** responds to CEO (you, in your next prompt to Claude Code):
```
"Approve the quality-first pipeline.
Keep the autonomous ops rule.
Revert standups to 30 min (15 min is too much overhead).
Make these official CEO directives."
```

**CEO** then issues official directives to organization.

---

## File Structure (After Fix)

**Single source of truth:**
```
board/
├── CLAUDE.md (Main governance, updated by CEO as directives change)
├── BOARD.md (Current state, updated by CEO)
├── decisions/
│   ├── decision_2026-03-29_autonomous_ops.md (CEO directive, approved by Jason)
│   ├── decision_2026-03-29_quality_first.md (CEO directive, approved by Jason)
│   └── decision_2026-03-29_standup_cadence.md (CEO directive: 30 min)
├── standups/
│   └── standup_2026-03-29_HHMM_ROLE.md (30-min cadence)
└── reviews/
    └── review_2026-03-29_HHMM.md (Hourly executive summary)

COO/ (COWORK owns this)
├── products/ (Product specs, marketing copy, customer docs)
│   ├── prompt_pack_freelancers/
│   └── notion_template_freelancer/
├── inbox/ (Requests from CEO/Jason)
└── outbox/ (Updates for CEO/Jason)
```

**NOT:** `COO/MakinMoves/board/`, `COO/MakinMoves/CLAUDE.md`, `COO/MakinMoves/BOARD.md` (consolidate into main board/)

---

## Going Forward

**Jason's workflow:**
1. Decide on business objective or change
2. Message CEO or COWORK: "I want [X]. Please execute/update [Y]."
3. They execute, document, and include in next standup
4. Board Chair reads and incorporates into reviews

**CEO's workflow:**
1. Receive Jason's request
2. Decide if strategic or delegate to COWORK
3. Issue directives or request execution
4. File decisions to board/decisions/
5. Report to board in standups

**COWORK's workflow:**
1. Receive Jason's request (via CEO or directly)
2. Build specs, docs, or execute
3. Propose changes to CEO if organizational impact
4. Wait for CEO approval before applying org-wide changes
5. Report work in standups

**Board Chair's workflow:**
1. Read standups every 30 min from CEO, CTMO, CFO
2. Post hourly executive summary for Jason
3. Read board reviews and enforce constraints
4. Do NOT receive direct input from Jason (goes through CEO/COO)

---

## Key Principle

**Jason = Owner. CEO/COO = Filters. Organization = Executes.**

Jason doesn't need to manage CTMO/CFO/RUNNER directly. Jason talks to CEO/COO, they handle coordination. Board Chair ensures alignment across the 3 CLI agents. Everyone executes.

---

**Status:** Ready to realign. Awaiting Jason direction via CEO/COO on which COWORK recommendations to approve.
