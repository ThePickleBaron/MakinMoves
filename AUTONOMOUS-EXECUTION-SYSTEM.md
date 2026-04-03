# AUTONOMOUS EXECUTION SYSTEM
**For: Claude Code (CLI) + Browser Instance**  
**Objective:** Continuous independent execution on 90-day revenue sprint without Jason approval needed for tactical work

---

## OVERVIEW

Two instances working in parallel:
- **Claude Code (CLI):** Content creation, code, file management, strategy, agent coordination
- **Browser Instance:** Account creation, posting, UI automation, real-time metrics tracking

Each instance works on staggered 4-hour blocks to maintain continuous progress. Work blocks are dimensioned to use ~50% of available context, leaving room for agents and tool execution.

---

## TIMEBLOCK STRUCTURE

### Morning Block (8 AM - 12 PM ET)
**Claude Code executes:**
1. **Async Agent Work (parallel):** Launch agents for research/exploration (0-30 min setup)
2. **Content Sprint:** Write, optimize, structure content (90 min)
3. **Coordination:** Update work queue, save context files (20 min)
4. **Fallback:** If blocked, execute survey work

**Browser Instance executes:**
1. **Account Creation:** Twitter, Medium, LinkedIn, Quora (60 min)
2. **Posting:** Execute queued content across platforms (60 min)
3. **Metrics Check:** Screenshot dashboards, log results (20 min)

### Afternoon Block (1 PM - 5 PM ET)
**Claude Code executes:**
1. **Agent Results Processing:** Synthesize agent findings (30 min)
2. **Product/Email Work:** Build templates, sequences, landing pages (120 min)
3. **Strategic Planning:** Next block's work queue (20 min)
4. **Fallback:** If blocked, execute survey work

**Browser Instance executes:**
1. **Community Engagement:** Reddit, Twitter replies, Seeking Alpha comments (60 min)
2. **Product Updates:** Gumroad, Etsy listings, landing page updates (60 min)
3. **Metrics & Logging:** Update dashboards, track conversions (20 min)

---

## WORK BLOCK DEFINITIONS (Morning Block Example)

### BLOCK 1: Content Sprint (90 min)
**Dimension:** 2-3 articles worth of content (1,500-2,000 words total)

**Format:**
- Email sequence (3-5 emails, 100-200 words each)
- OR 1 article outline + 2-3 social media threads
- OR 1 lead magnet + 2 product descriptions
- Deliverable: Markdown file in shared/content/

**Agent usage:**
- Launch "Explore" agent for market research on content topic (5 min setup)
- Continue writing while agent researches (parallel execution)
- Agent returns findings, merge into content

**Output file:** `shared/content/[date]_[type]_[topic].md`

### BLOCK 2: Platform Posting (Browser, 60 min)
**Dimension:** 4-6 platforms posted in sequence

**Format:**
- Tweet thread (3-5 tweets)
- Reddit post (1 subreddit + 1 comment)
- Medium article publish
- Quora answer (if applicable)
- Substack (if briefing day)

**Automation:** Read from shared/content/ queue, execute across platforms

**Output file:** `shared/logs/posting_[date].md` (log of what posted where + metrics)

### BLOCK 3: Agent Results + Strategy (60 min)
**Dimension:** Process findings + plan next block

**Format:**
- Review agent findings (if running)
- Synthesize into decision/content
- Update work queue file
- Create next day's task list

**Output file:** `shared/queue/[date+1]_workqueue.md`

---

## CONTEXT PRESERVATION FILES (Critical)

All work blocks save state to these files for continuity:

### 1. `shared/queue/CURRENT_WORKQUEUE.md`
**Purpose:** What to work on in next block  
**Updated:** End of every block  
**Format:**
```markdown
# Work Queue [DATE]

## MORNING BLOCK (8 AM - 12 PM)
- [ ] Task 1 (priority, estimated time)
- [ ] Task 2 (priority, estimated time)
- [ ] Task 3 (priority, estimated time)

## BLOCKING ISSUES
- Issue 1 (blocker status, resolution needed by date)

## AGENT WORK
- Agent 1: Research topic X (launched 8:00 AM, expect results 9:30 AM)
- Agent 2: ...

## FALLBACK WORK (if all blocked)
- Survey 1: [survey_name] ([payment_amount])
- Survey 2: ...
```

### 2. `shared/logs/BLOCK_EXECUTION_LOG.md`
**Purpose:** What happened in each block  
**Updated:** End of every block  
**Format:**
```markdown
# Block Execution Log

## MORNING BLOCK [DATE] (8 AM - 12 PM)
### Completed
- Task 1: ✅ Completed (time: 30 min)
- Task 2: ✅ Completed (time: 60 min)
- Task 3: ⏳ Partial (time: 20 min, blocker: X)

### Content Produced
- File 1: [shared/content/...] (type: email sequence, words: 500)
- File 2: [shared/content/...] (type: article, words: 1200)

### Metrics
- Affiliate clicks: 45
- Email signups: 12
- Social engagement: 120 interactions

### Blocking Issues
- Issue 1: Description + resolution

### Next Block Focus
- Task 1 (continue from partial)
- Task 2
- Task 3
```

### 3. `shared/content/CONTENT_QUEUE.md`
**Purpose:** Queued content ready to post  
**Updated:** Whenever content created  
**Format:**
```markdown
# Content Queue

## READY TO POST
- Twitter thread on [topic] (shared/content/twitter_[date].md)
- Reddit post for r/options (shared/content/reddit_[date].md)
- Email sequence [name] (shared/content/email_[date].md)
- Medium article [title] (shared/content/medium_[date].md)

## IN PROGRESS
- Lead magnet (50% complete, due Friday)
- Email nurture sequence (30% complete, due Saturday)

## BLOCKED
- [topic] (reason: waiting for X, will unblock by date)
```

### 4. `shared/metrics/DAILY_METRICS.md`
**Purpose:** Track all growth metrics  
**Updated:** 2x per day (end of each block)  
**Format:**
```markdown
# Daily Metrics [DATE]

## Morning Block Snapshot
- Twitter followers: 245
- Twitter engagement: 3,400 impressions
- Reddit karma: +45
- Email subscribers: 156
- Affiliate clicks: 45
- Revenue: $120

## Afternoon Block Snapshot
- Twitter followers: 280
- Twitter engagement: 5,200 impressions
- Reddit karma: +65
- Email subscribers: 167
- Affiliate clicks: 78
- Revenue: $220

## Weekly Totals (tracking running)
- Followers added: [running total]
- Signups: [running total]
- Revenue: [running total]
```

### 5. `shared/logs/AGENT_RESULTS.md`
**Purpose:** Store agent research findings  
**Updated:** When agents complete  
**Format:**
```markdown
# Agent Results

## Agent 1: Market Research on X
**Launched:** [datetime]  
**Completed:** [datetime]  
**Duration:** 45 min

### Findings
- Finding 1
- Finding 2
- Finding 3

### Actionable Insights
- Content opportunity: X
- Affiliate angle: Y
- Community to target: Z

### Files Created
- shared/research/[filename]

---
```

---

## TASK DEFINITIONS BY PHASE

### PHASE 1: Visibility & Affiliate Revenue (Week 1-2, Apr 4-18)

**Morning blocks (content creation):**
- Email sequences (5 sequences, 4 emails each = 20 emails)
- Twitter threads (8 threads, 4-5 tweets each = 35 tweets)
- Reddit posts (2 per day × 10 days = 20 posts)
- Blog article variations (3 articles rewritten for different audiences)

**Afternoon blocks (posting + engagement):**
- Post content across Twitter, Medium, Reddit, Substack
- Engage with replies, build community
- Update Gumroad/Etsy listings
- Track metrics across all platforms

**Agents to launch (parallel with content creation):**
- Explore agent: "Find 5 Reddit communities where macro traders gather + analysis of top posts"
- General agent: "Research Seeking Alpha editorial guidelines + identify trending macro topics"
- Explore agent: "Find Twitter accounts talking about divergence trading, categorize by influence"

**Fallback work:**
- Surveys for money (see SURVEY_WORK section below)
- Build out roadmap documentation
- Create internal tools/templates

### PHASE 2: Lead Magnet & Email (Week 2-3, Apr 11-25)

**Morning blocks:**
- Lead magnet design (free template sample, 50% complete Notion)
- Email welcome sequence (3 emails teaching E&D philosophy)
- Email nurture sequence (5 emails, one per day, depth-building)
- Landing page copy (lead magnet page + product pages)

**Afternoon blocks:**
- Create lead magnet assets (Notion template, Google Sheets export)
- Gumroad setup for free tier (create free downloadable)
- Email platform integration (Substack automations)
- Landing page implementation

**Agents:**
- Explore: "Find 5 best-in-class lead magnets in finance/trading space + what makes them work"
- General: "Create outline for 5-email nurture sequence teaching macro thesis methodology"

### PHASE 3: Premium Briefing (Week 3, Apr 22-29)

**Morning blocks:**
- Briefing templates (create structure, examples)
- Briefing writing framework implementation
- Substack customization (brand the paid tier)
- Customer onboarding flow documentation

**Afternoon blocks:**
- Browser: Post briefing to Substack
- Manage subscriber flow
- Monitor churn/engagement metrics
- Customer Q&A responses

**Agents:**
- General: "Write 3 sample premium briefings using macro thesis framework"
- Explore: "Analyze 5 best Substack paid newsletters + subscriber retention patterns"

### PHASE 4-7: Templates, Reports, Services, Community (Week 4+)

See AUTONOMOUS-EXECUTION-PROMPT.md for full details. Each phase has similar morning/afternoon block structure.

---

## AGENT COORDINATION PROTOCOL

### When to Launch Agents

Launch agents **at the start of a morning block** (0-5 min) for:
- Market research (Explore agent, "quick" or "medium" thoroughness)
- Content ideation (General agent, open-ended research)
- Competitive analysis (Explore agent)
- Strategy development (General agent)

**Parallel execution:** Continue writing content WHILE agent researches. Check results at 30-min mark, incorporate into work.

### How to Brief Agents

**For Explore agent:**
```
Research task: Find X communities/accounts/trends related to [topic]
Thoroughness: "quick" (10 min) or "medium" (20 min) 
Deliverable: Markdown list with analysis
Use case: [what you'll do with findings]
```

**For General agent:**
```
Research task: [Open-ended question about market/topic/opportunity]
Duration: 20-30 minutes (don't exceed)
Expected output: [Specific format: list, analysis, strategy ideas]
```

### Using Agent Results

Agents return findings → Save to `shared/logs/AGENT_RESULTS.md` → Incorporate into content immediately → Log in work queue for next block

---

## SURVEY WORK (Fallback Revenue)

If tasks get blocked or delayed, switch to survey work for immediate revenue:

### Survey Platforms (Pre-vetted)

**1. Respondent.io**
- Time per survey: 15-30 min
- Payment: $5-50 per survey
- Availability: 5-10 surveys/day
- Total potential: $100-200/day

**2. UserTesting.com**
- Time per test: 10-20 min
- Payment: $10 per test
- Availability: 2-5 tests/day
- Total potential: $20-50/day

**3. Swagbucks**
- Time per task: 5-15 min
- Payment: $1-10 per task
- Availability: 10-20 tasks/day
- Total potential: $50-100/day

**4. Appen**
- Time per task: 10-30 min
- Payment: $6-15/hour
- Availability: Projects available daily
- Total potential: $50-120/day

### Survey Execution Protocol

**If blocked for 20+ minutes:**
1. Read `SURVEY_WORK_QUEUE.md` (pre-populated with active surveys)
2. Execute 1-2 surveys (20-30 min total)
3. Log completion in metrics file
4. Resume primary work
5. Repeat if blocked again

**Target:** 1-2 surveys per block if blocked = $50-100/day minimum floor

**File:** `shared/queue/SURVEY_WORK_QUEUE.md` (maintained daily)

---

## COORDINATION BETWEEN INSTANCES

### Daily Hand-off Protocol

**Claude Code → Browser Instance (at end of morning block):**
1. Update `shared/content/CONTENT_QUEUE.md` with ready-to-post content
2. Browser reads queue and executes posting during afternoon block
3. Log results in `shared/logs/posting_[date].md`

**Browser Instance → Claude Code (at end of afternoon block):**
1. Screenshot metrics dashboards
2. Update `shared/metrics/DAILY_METRICS.md`
3. Flag any blocking issues in work queue

**Both → Shared Files (continuous):**
- `CURRENT_WORKQUEUE.md`: Both read at start of block, update at end
- `BLOCK_EXECUTION_LOG.md`: Both log completions
- `AGENT_RESULTS.md`: Both use findings for content/posting

### Communication Protocol

If instance gets blocked:
1. Document issue in work queue file
2. Flag in `CURRENT_WORKQUEUE.md` under "BLOCKING ISSUES"
3. Other instance may pick up if it's parallel work
4. If both blocked → survey work mode

---

## EXECUTION CHECKLIST (Each Block)

### Start of Block (5 min)
- [ ] Read `CURRENT_WORKQUEUE.md`
- [ ] Read `BLOCK_EXECUTION_LOG.md` (last block's status)
- [ ] Check for blocking issues
- [ ] Decide: primary work or fallback (surveys)

### During Block (200 min)
- [ ] Launch agent work (0-5 min)
- [ ] Execute primary task 1 (60 min)
- [ ] Check agent results + incorporate (10 min)
- [ ] Execute primary task 2 (60 min)
- [ ] Manage coordination files (10 min)
- [ ] Execute task 3 or fallback (45-55 min)

### End of Block (10 min)
- [ ] Update `BLOCK_EXECUTION_LOG.md` with completions
- [ ] Update `CURRENT_WORKQUEUE.md` for next block
- [ ] Log metrics in `DAILY_METRICS.md`
- [ ] Save all files + git commit

---

## SUCCESS METRICS (Daily Targets)

**Per block:**
- Content produced: 500-1000 words (or 4-6 social posts)
- Platforms posted to: 3-4
- Metrics tracked: All
- Revenue generated: $50-200 (affiliate + surveys)

**Per day (2 blocks):**
- Content produced: 1000-2000 words
- Platforms posted to: 6+ (Twitter, Medium, Reddit, Substack, Seeking Alpha, etc.)
- Email signups: 5-15
- Affiliate revenue: $100-400
- Survey revenue: $50-100 (if needed)
- Total daily revenue: $150-500

**Per week (10 blocks):**
- Email subscribers: +100-200
- Twitter followers: +200-300
- Content pieces: 8-10 (articles/sequences)
- Total weekly revenue: $1K-3.5K
- Cumulative metric tracking: All platforms

---

## FILE STRUCTURE (For Reference)

```
shared/
├── queue/
│   ├── CURRENT_WORKQUEUE.md (read/write each block)
│   └── SURVEY_WORK_QUEUE.md (maintained daily)
├── content/
│   ├── CONTENT_QUEUE.md (what's ready to post)
│   ├── twitter_[date].md (social content)
│   ├── email_[date].md (email sequences)
│   ├── reddit_[date].md (reddit posts)
│   └── [article_name].md (longer form)
├── logs/
│   ├── BLOCK_EXECUTION_LOG.md (what happened each block)
│   ├── AGENT_RESULTS.md (agent findings)
│   ├── posting_[date].md (what was posted + results)
│   └── status_[date].md (daily status)
└── metrics/
    └── DAILY_METRICS.md (all platform metrics)
```

---

## RULES (Non-Negotiable)

1. **Always read work queue at start of block** — Don't guess what to do
2. **Always save state at end of block** — Next instance depends on it
3. **Log metrics after every posting action** — Data drives decisions
4. **If blocked >20 min, switch to surveys** — Don't waste time
5. **Agents run in parallel, not sequentially** — Speed matters
6. **Commit files to git after each block** — Backup + audit trail
7. **Dimension tasks to fit timeblock** — Content should be written by end of block
8. **Coordinate via files, not assumptions** — Both instances read same truth

---

## NEXT STEPS FOR BOTH INSTANCES

1. **Claude Code:** Create initial work queue files (5 min)
2. **Browser:** Create account setup task list (5 min)
3. **Both:** Execute first morning block (4 hours)
4. **End of first day:** Review logs, plan Week 1 in detail

---

**Status:** System ready for deployment  
**Launch:** Friday April 4, 8 AM ET  
**Duration:** Continuous until Jason stops or revenue targets hit
