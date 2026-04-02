# MakinMoves — 90-Day Revenue Sprint (Single CLI Instance)

## Context
**Claude Code** (CLI agent) operates autonomously to build passive/low-maintenance revenue streams for Jason. Mission: recover financially through diversified, digital-first income.

**Status:** Day 4 of 90-day sprint. Products LIVE on Gumroad, articles drafted, affiliate setup in progress.

## Important Paths
- **Project root:** `C:\Users\jsmcl\Documents\MakinMoves`
- **Active work:** `./shared/` — memos, plans, research, revenue streams
- **Sprints:** `./sprints/` — sprint coordination files
- **Legacy governance:** `./CEO/`, `./COO/`, `./CTMO/`, `./CFO/` — kept for reference, superseded by memo protocol
- **All deliverables:** in `./shared/streams/` by revenue stream

## Workflow

**Single instance, file-based coordination:**

1. **Read memos** before starting work — `./shared/memos/` — Jason leaves instructions/context here
2. **Check sprint status** — `./sprints/` — understand where each revenue stream stands
3. **Execute on priority task** — build, write, research, publish
4. **Update status** — write memo in `./shared/memos/memo_YYYYMMDD_status.md` when done or stuck
5. **Commit changes** to git, push to GitHub

**Key files:**
- `./shared/plans/roadmap-90-days.md` — overall timeline and milestones
- `./shared/plans/revenue-streams-ranked.md` — prioritized by time-to-first-dollar
- `./shared/memos/MEMO_PROTOCOL.md` — how to structure inter-session communication

## Communication Protocol (Jason → Claude)

### Memos
Jason writes memos to coordinate work:
- **File:** `./shared/memos/memo_YYYYMMDD_topic.md`
- **Purpose:** Off-topic info, context, blocking issues, priority shifts
- **Read:** Always check before starting new work

### Sprint Coordination
Claude writes sprints to share current status and get feedback:
- **File:** `./sprints/cc_sprint_NNN.json` 
- **When:** End of major work blocks (product launch, articles done, etc.)
- **Content:** What was accomplished, what's blocked, what's next, questions for Jason

### Status Log
Claude logs session work for continuity:
- **File:** `./shared/logs/status_YYYY-MM-DD.md`
- **Content:** Tasks completed, time spent, next priorities

## Project Structure
```
shared/
  ├── plans/                    — 90-day roadmap, revenue streams ranked, setup checklist
  ├── research/                 — Competitor analysis, affiliate programs, publishing strategy
  ├── memos/                    — Jason's instructions, coordination messages
  ├── logs/                     — Status updates, session logs
  ├── streams/
  │   ├── digital-products-templates/  — Notion/Sheets specs, listing copy, .xlsx files
  │   ├── affiliate-marketing-saas/    — Articles, email sequences, outlines
  │   └── print-on-demand/             — Phase 2 (deferred)
  └── assets/                   — Images, thumbnails, samples

sprints/                        — cc_sprint_*.json coordination files
legacy/
  ├── CEO/, COO/, CTMO/, CFO/   — Original governance docs (reference only)
  └── board/                    — Board reviews (reference only)
```

## Guiding Principles
- **Low maintenance first.** Every stream must be buildable/maintainable with 30 min/day max.
- **Low/no upfront cost.** Recovering from financial loss — no major investment required.
- **Digital-first.** No physical inventory, location-dependent income, or logistics.
- **Diversify.** Multiple small streams beat one big bet.
- **Realistic timelines.** Be honest about time-to-first-dollar.
- **No get-rich-quick.** Only legitimate, proven models.
- **Prioritize by revenue velocity.** Fastest path to income first.

## Session Workflow
1. **Read memos** — `./shared/memos/` — check for Jason's instructions or context
2. **Check status** — `./shared/logs/status_YYYY-MM-DD.md` — understand where we are
3. **Review priority** — `./shared/plans/revenue-streams-ranked.md` — what's next?
4. **Execute** — build, write, research, or publish the top task
5. **Update status** — log what you did and what's blocked
6. **Commit & push** — git commit/push to GitHub

## Current Status (Day 4 of 90)
**Products:**
- Stream 1 (Digital Templates): Notion tracker LIVE on Gumroad ($9), Google Sheets tracker built (needs listing)
- Stream 2 (Affiliate Marketing): 2 articles drafted/reviewed, email sequence drafted, affiliate programs researched

**Immediate priorities:**
- Publish Gumroad listing for Google Sheets tracker
- Publish articles (Substack recommended)
- Set up Beehiiv email list
- Apply to affiliate programs (TradingView, Sharesight, Stock Rover)

## Key Context
- **User:** Jason — active trader, ~$250K portfolio, relocating to Richmond VA, 30 min/day available
- **Critical directive:** Jason has no experience with platforms (Gumroad, Notion, Etsy, etc.). Always either do it via API/browser, or write exact click-path instructions
- **Gumroad store:** outdoorphunk.gumroad.com (j.s.mclarty@gmail.com)
- **Products live:** Active Trader Portfolio Tracker ($9 Notion), Freelance Starter Kit ($49), Invoice Tracker ($39), AI Prompts ($24)

## Rules
1. **Always check memos before starting work** — Jason leaves context there
2. Never reveal Jason's specific portfolio amounts — use "six-figure portfolio"
3. Never commit API keys, tokens, credentials
4. All articles must be publish-ready with affiliate link placeholders
5. All products at launch discount — raise after reviews
6. If pulled off-task (e.g., stock analysis), drop a status memo
