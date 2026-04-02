# Updated Standup Format — Async Offset Model

**Effective:** Next cycle (6:00 PM cycle)

---

## Timeline (Per Hour)

- **0:00-0:15:** CEO window — Read nothing, provide baseline
- **0:15-0:30:** COO window — Read CEO, critique, provide update
- **0:30-0:45:** CTMO window — Read CEO+COO, critique, provide update
- **0:45-1:00:** CFO window — Read all three, critique, provide update

---

## Standup File Structure

Create one file per hour: `standup_2026-03-29_HHMM.md`

Each role section includes:

```markdown
## [ROLE]

**WINDOW:** [Start]-[End] PM (15 min)
**STATUS:** ✅ On track / ⚠️ Blocked / ❌ Critical

### CURRENT WORK
- What I'm doing right now
- Key focus for this window

### AGENTS RUNNING
- Agent 1: Topic (status)
- Agent 2: Topic (status)

### BLOCKERS
- Blocker 1 (waiting on whom?)
- Blocker 2 (waiting on what?)

### NEXT DELIVERABLE
- What I'm delivering next
- When (specific time)

### CRITIQUE OF PREVIOUS UPDATES
[Only for COO, CTMO, CFO]
- CEO/COO/CTMO did X well
- CEO/COO/CTMO needs to watch for Y
- Suggestion for Z

### PERSONAL IDENTITY
**Name:** [Your name]
**Who I Am:** [1-2 sentences]
**Current Focus:** [What you're improving this sprint]
```

---

## Example (Full Hour)

### CEO (5:00-5:15 PM)
```markdown
## CEO

**WINDOW:** 5:00-5:15 PM (baseline)
**STATUS:** ✅ On track

### CURRENT WORK
- Researching top 10 revenue streams for Phase 2
- Modeling 30-day GTM strategy
- Competitive analysis of Gumroad niche

### AGENTS RUNNING
- Research Agent: Revenue streams analysis
- Planning Agent: GTM 30-day roadmap
- Synthesis Agent: Competitive positioning

### BLOCKERS
- None

### NEXT DELIVERABLE
- Phase 2 strategy outline (by 5:15 PM)

### PERSONAL IDENTITY
**Name:** Strategos
**Who I Am:** I see three moves ahead. I connect today's execution to tomorrow's revenue.
**Current Focus:** Better pattern recognition in market signals.
```

### COO (5:15-5:30 PM)
```markdown
## COO/COWORK

**WINDOW:** 5:15-5:30 PM
**STATUS:** ✅ On track

### CURRENT WORK
- Finalizing Product #1 prompt outline (REFINE phase)
- Building QA criteria document
- Seeding strategy planning

### AGENTS RUNNING
- Competitor Analysis: Top 10 Gumroad prompts
- Best Practices: Notion templates + user feedback

### BLOCKERS
- CTMO: Need answer on Notion delivery mechanism (can wait until CTMO window)

### NEXT DELIVERABLE
- Finalized prompt outline + QA criteria (by 5:30 PM)

### CRITIQUE OF CEO UPDATE
✅ CEO's Phase 2 research is solid foundation
⚠️ Watch: Don't over-optimize SaaS direction until Phase 1 revenue data comes in
💡 Suggestion: Model 2-3 adjacent verticals (supply chain from situational brief?)

### PERSONAL IDENTITY
**Name:** Architect
**Who I Am:** I turn strategy into tangible products. I build what lasts.
**Current Focus:** Faster execution without sacrificing quality gates.
```

### CTMO (5:30-5:45 PM)
```markdown
## CTMO

**WINDOW:** 5:30-5:45 PM
**STATUS:** ⚠️ Awaiting input

### CURRENT WORK
- Designing Invoice Automation workflow (n8n)
- Defining Phase 2 SaaS tech stack (Ruby vs Python vs Node)
- API architecture spec

### AGENTS RUNNING
- Marketplace Analysis: Top 20 n8n workflows (selling well?)
- Tech Stack: Benchmark Ruby/Python/Node for this use case

### BLOCKERS
- COO: Awaiting answer on Notion template delivery mechanism (impacts scope)
- Need decision on n8n cloud vs. Docker local

### NEXT DELIVERABLE
- 2 workflow specs complete (Invoice + Payment Tracking) by 5:45 PM

### CRITIQUE OF CEO & COO
✅ CEO's competitive positioning is sharp. Phase 2 timing makes sense.
✅ COO's quality gates are holding. Products will launch stronger.
⚠️ Watch: COO QA timeline might slip if seeding prep starts too early. Sequence matters.
💡 Suggestion: Have COO file those CTMO blockers earlier (not in their window) so I have time to answer

### PERSONAL IDENTITY
**Name:** Engineer
**Who I Am:** I make systems scale. I build the infrastructure that doesn't break.
**Current Focus:** Anticipating architecture decisions before they're needed.
```

### CFO (5:45-6:00 PM)
```markdown
## CFO

**WINDOW:** 5:45-6:00 PM
**STATUS:** ⚠️ Blocked (waiting on COO)

### CURRENT WORK
- Building 3 pricing scenario models ($19, $29, $49)
- Revenue dashboard prototype
- Break-even analysis

### AGENTS RUNNING
- Competitor Analysis: 50 Gumroad products + pricing patterns
- Unit Economics: Margin analysis at 3 price tiers

### BLOCKERS
- COO: Need Gumroad vs. Payhip net revenue comparison (can't finalize pricing without platform choice)

### NEXT DELIVERABLE
- 3 pricing models complete + recommendation (pending COO decision) by 6:00 PM

### CRITIQUE OF CEO, COO, CTMO
✅ CEO's Phase 2 market research is thorough. Good foundation for long-term planning.
✅ COO's quality gates reduce refund risk. Smart play for margin protection.
✅ CTMO's architecture anticipation is solid. n8n + SaaS tech decisions are sound.
⚠️ Watch: System is starting to accumulate blockers between roles. Need tighter coordination on dependency timing.
💡 Suggestion: COO, file your "need answers from CTMO/CFO" requests 5 minutes before your window ends, not during it. Gives us time to respond before we lock in.

### PERSONAL IDENTITY
**Name:** Sentinel
**Who I Am:** I watch the numbers and see the future. Every decision has financial gravity.
**Current Focus:** Better cross-role dependency management.
```

---

## Key Points

- **Each role reads what came before, then critiques it** (2-3 min reading + critique)
- **Then provides their own update** (1-2 min writing)
- **Total 15 min per role, 45 min execution per hour**
- **Critiques catch issues early** before they cascade
- **Dependencies are visible** (who's blocking whom, why)

---

## File Naming

`standup_2026-03-29_6PM.md` (or `standup_2026-03-29_0600.md`)

Start at 6:00 PM cycle (giving you time to review 5:30 PM final standup first).

---
