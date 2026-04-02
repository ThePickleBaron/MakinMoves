# Jason's 45-Hour Sprint Checklist (PRINTABLE)
**Print this. Post it on your desk. Follow it religiously.**

---

## PRE-SPRINT TODAY (Before Hour 0)

### Strategic Preparation (3-4 Hours — Do This NOW)

- [ ] **Write Gumroad Product Copy** (Already decided? Write the actual copy now)
  - Title (1 line)
  - Description (2-3 paragraphs)
  - Benefits (3-5 bullet points)
  - Price justification (why $24.99?)

- [ ] **Design Product Page Layout** (Sketch or write specs)
  - Banner/header
  - Product description placement
  - CTA button
  - Email signup section
  - Image/visual placement

- [ ] **Research Competitor Positioning** (10 min)
  - 10 competing "AI Prompts" products
  - Their pricing
  - Their positioning angle
  - Why yours is different

- [ ] **Outline Operations Manual Templates**
  - P2 Freelance Workflow (main steps)
  - P3 Affiliate Site Process (main steps)
  - Don't write full manual yet — just outline

- [ ] **Outline n8n Automation** (Pencil sketch is fine)
  - Revenue capture: Which APIs? How to database?
  - Publishing: Which platforms? When to publish?
  - Content generation: What to generate? Store where?
  - Error monitoring: What to monitor? Escalation path?

- [ ] **Print All Documents**
  - [ ] This checklist
  - [ ] Hour-by-hour cognitive map
  - [ ] Contingency playbook
  - [ ] Escalation matrix

- [ ] **Schedule Nap Reminder**
  - Set calendar reminder: "2-HOUR NAP" at Hour 20-22 (exact time)
  - Set alarm for 2 hours later
  - Ensure alarm is LOUD (wake-up guaranteed)

- [ ] **Prepare Handoff Script** (Hour 30, ~5 min prep now)
  - What should Claude instances know?
  - How to escalate issues?
  - What to monitor daily?
  - Rough notes (you'll record video at hour 30)

---

## DAY 1 (March 29, Hours 0-10)

### HOURS 0-6: GOLDEN WINDOW (Strategic Work — Fresh Brain)

**Time Block:** 2:00 PM - 8:00 PM

**Your Cognitive State:** 100% capacity. Make all strategic decisions NOW.

**Work:**
- [ ] **CEO: Finalize Niche + Positioning** (1 hour)
  - Is AI Prompts for Freelancers the right niche?
  - Positioning: Solve what problem for freelancers?
  - Is positioning differentiated from competitors?
  - ✓ LOCKED (no changes after this)

- [ ] **CEO: Confirm Product Specs** (1 hour)
  - AI Prompts: 50 prompts, 5 categories, PDF format?
  - Price: $24.99? Justified?
  - Launch: Today or tomorrow morning?
  - ✓ LOCKED (no changes after this)

- [ ] **CTMO: Confirm n8n Architecture** (1.5 hours)
  - Revenue capture: API → Database ✓?
  - Platform priority: Gumroad → Etsy → Redbubble?
  - Database schema: What tables do we need?
  - Error handling: What errors matter?
  - ✓ LOCKED (no changes after this)

- [ ] **CEO: Content Calendar Preview** (1 hour)
  - Week 1 content calendar (high-level)
  - Announcement schedule (when to announce?)
  - Follow-up cadence (Day 1? Day 3? Week 1?)
  - ✓ LOCKED (no changes after this)

- [ ] **CEO: Contingencies** (1.5 hours)
  - If Gumroad down → Plan B: Etsy
  - If Stripe delayed → Plan B: Manual PayPal
  - If first day sales are zero → Don't panic, Day 2-3 is ramp
  - If n8n broken → Use manual process, fix Day 1

**Hourly Status Check (Every Hour):**
- [ ] Am I focusing? YES / NO
- [ ] Are decisions clear? YES / NO
- [ ] Have I made a mistake? YES / NO

**Standup at Hour 6 (8:00 PM):**
> **Status:** All strategic decisions locked. Gumroad copy ready. n8n architecture confirmed. Week 1 contingencies planned.
> **Blockers:** None — ready for execution phase.
> **Next 4 hours:** Gumroad product build.

---

### HOURS 6-10: STILL-STRONG WINDOW (Build Phase — Fresh-ish Brain)

**Time Block:** 8:00 PM - 12:00 AM (midnight)

**Your Cognitive State:** 85% capacity. Still good for execution.

**Work:**
- [ ] **COO: Build Gumroad Product** (4 hours)
  - [ ] Log into Gumroad
  - [ ] Create product: "AI Prompts for Freelancers Bundle"
  - [ ] Upload product description (from pre-written copy)
  - [ ] Upload product images/PDF (use prepared assets)
  - [ ] Set price: $24.99
  - [ ] Configure email capture: "Join waitlist"
  - [ ] Test product page (looks professional?)
  - [ ] ✓ Product ready (not published yet)

- [ ] **CTMO: Map Platform APIs** (1 hour, parallel while COO builds)
  - [ ] Gumroad API: Endpoint, auth, rate limits
  - [ ] Etsy API: Endpoint, auth, rate limits
  - [ ] Redbubble API: Endpoint, auth, rate limits
  - [ ] Medium API: Endpoint, auth, rate limits
  - [ ] Document in text file (n8n will reference this)

- [ ] **CEO: Draft Launch Announcement Email** (1 hour, while COO builds)
  - [ ] Subject line
  - [ ] Body (5-7 sentences)
  - [ ] CTA button text
  - [ ] Ready to send tomorrow morning

**Hourly Status Check:**
- [ ] Staying focused? YES / NO
- [ ] Making progress? YES / NO
- [ ] Energy level? GOOD / OKAY / DECLINING

**Standup at Hour 10 (12:00 AM):**
> **Status:** Gumroad product 95% built (ready to publish). Platform APIs documented. Launch email drafted.
> **Blockers:** Any final touches needed on Gumroad page?
> **Next 2 hours:** Final Gumroad review, prepare for publish.

---

## TRANSITION: MIDNIGHT DANGER ZONE (Hours 10-12)

### HOURS 10-12: EDGE WINDOW (Publishing + First Build)

**Time Block:** 12:00 AM - 2:00 AM

**Your Cognitive State:** 65% capacity. Fatigue starting. Use checklists only.

**Work:**
- [ ] **COO: Final Gumroad Review** (30 min)
  - [ ] Product title: Clear and compelling?
  - [ ] Description: Matches pre-written copy?
  - [ ] Price: Correct?
  - [ ] CTA: Works?
  - [ ] Email capture: Working?
  - [ ] NO CHANGES — if something looks off, note it, fix later

- [ ] **COO: Publish Gumroad Product** (15 min, follow checklist)
  - [ ] Product visibility: SET TO PUBLIC
  - [ ] Confirm: "Are you sure?" YES
  - [ ] Confirm: URL created
  - [ ] Screenshot the URL (save for announcement email)
  - [ ] ✓ GUMROAD LIVE

- [ ] **CTMO: Start n8n Workflow 1 — Revenue Capture** (1 hour)
  - [ ] Create new n8n workflow: "Revenue Capture Hourly"
  - [ ] Add Gumroad API node (use documented endpoint)
  - [ ] Add transform node (parse JSON response)
  - [ ] Add PostgreSQL INSERT node (write to revenue_summary table)
  - [ ] Add error handler (log to error_logs)
  - [ ] **DO NOT TEST YET** — just build, testing comes later

**Critical Safety Check:**
- [ ] Is Gumroad actually live? (Can you visit the URL?)
- [ ] Is n8n workflow structure correct? (Nodes connected?)
- [ ] Did you take notes on any issues? (For fixing later)

**Standup at Hour 12 (2:00 AM):**
> **Status:** Gumroad LIVE! 🎉 First workflow started. (No sales yet, that's normal for 2 AM.)
> **Blockers:** None critical.
> **IMPORTANT:** You're about to take a 2-hour nap. This is MANDATORY. Set alarm. Sleep now.

---

## CRITICAL REST WINDOW

### HOURS 12-14: MANDATORY 2-HOUR NAP

**Time:** 2:00 AM - 4:00 AM

**INSTRUCTIONS:**
- [ ] Set alarm for 4:00 AM (LOUD alarm)
- [ ] Go to dark, quiet room
- [ ] No phone, no checking work
- [ ] Sleep immediately
- [ ] Upon waking: Drink water immediately, eat something (protein), 5-min walk outside

**Why:** You've been awake 12 hours on 6 hours of sleep from last night. Your brain is foggy. This 2-hour nap will restore +25-30% cognitive capacity for the final 14 hours.

**No debate. No exceptions. Sleep now.**

---

## DAY 2 MORNING (March 30, Hours 14-20)

### HOURS 14-20: MODERATE WINDOW (Build Phase II — Recovered But Impaired)

**Time Block:** 4:00 AM - 10:00 AM

**Your Cognitive State:** 65-70% capacity (recovered from nap, but cumulative tiredness).

**Work:**
- [ ] **CTMO: Finish n8n Workflow 1 Testing** (1.5 hours)
  - [ ] Complete revenue capture node setup
  - [ ] Test with sample Gumroad data
  - [ ] Verify: Data writes to PostgreSQL correctly
  - [ ] Verify: Errors are logged
  - [ ] ✓ Workflow 1 tested and ready

- [ ] **CTMO: Build n8n Workflow 2 — Publishing** (2.5 hours)
  - [ ] Create workflow: "Daily Publishing Pipeline"
  - [ ] Add trigger: 09:00 each morning
  - [ ] Add Gumroad API node (publish products)
  - [ ] Add Etsy API node (publish listings)
  - [ ] Add error handler
  - [ ] **DO NOT TEST YET** — build complete, testing comes later

- [ ] **CTMO: Integration Testing — Revenue to Database** (1 hour)
  - [ ] Verify n8n → PostgreSQL connection working
  - [ ] Query database: SELECT * FROM revenue_summary (should be empty, that's okay)
  - [ ] Verify schema exists (all columns present)
  - [ ] ✓ Integration verified

- [ ] **COO: Monitor Gumroad Sales** (1 hour, passive while CTMO works)
  - [ ] Check Gumroad dashboard hourly
  - [ ] Any sales yet? (Probably not, that's okay)
  - [ ] Any customer questions? (Answer them)
  - [ ] Any issues? (Note them, don't fix)

**Hourly Status Check:**
- [ ] Energy level? GOOD / OKAY / DECLINING
- [ ] Making progress? YES / NO
- [ ] Any bugs found? NONE / MINOR / CRITICAL

**Standup at Hour 20 (10:00 AM):**
> **Status:** Workflow 1 tested. Workflow 2 built. Integration verified. Gumroad: 1-2 sales so far.
> **Blockers:** Any API integration issues?
> **Next 6 hours:** Finish remaining workflows, integration testing.

---

## DAY 2 AFTERNOON (March 30, Hours 20-32)

### HOURS 20-26: DECLINING WINDOW (Mechanical Work — Fatigue Setting In)

**Time Block:** 10:00 AM - 4:00 PM

**Your Cognitive State:** 55% capacity. Fatigue noticeable. Stay templated.

**Work:**
- [ ] **COO: Operations Manual P2 (Freelance)** (2 hours, use template outline from pre-sprint)
  - [ ] Define: Client intake flow (form → CRM → call)
  - [ ] Define: Writer workflow (brief → draft → revisions → delivery)
  - [ ] Define: Payment & invoicing process
  - [ ] Template emails for each stage
  - [ ] **Use outline from pre-sprint, don't redesign**

- [ ] **COO: Operations Manual P3 (Affiliate)** (2 hours, use template outline)
  - [ ] Define: Keyword research workflow
  - [ ] Define: Content creation process
  - [ ] Define: Publishing schedule
  - [ ] Affiliate program assignments (which product for which niche?)
  - [ ] **Use outline from pre-sprint, don't redesign**

- [ ] **CTMO: Build n8n Workflow 3 — Content Generation** (2 hours)
  - [ ] Create workflow: "Daily Content Generation"
  - [ ] Add trigger: 06:00 each morning
  - [ ] Add Claude API node (generate product ideas)
  - [ ] Add transform node (format output)
  - [ ] Add PostgreSQL INSERT node (write to content_queue)
  - [ ] **DO NOT TEST YET** — build complete

**Critical Rules (You're Getting Tired):**
- ✓ Use pre-made templates (don't invent new approaches)
- ✓ Use checklists (don't trust memory)
- ✓ Double-check before publishing anything
- ❌ No new creative decisions (stick to plan)

**Standup at Hour 26 (4:00 PM):**
> **Status:** Operations manuals drafted (both P2 and P3). Workflow 3 built. 3 sales on Gumroad so far.
> **Blockers:** Any feedback on operations manuals?
> **Next 6 hours:** Final workflow, full integration testing, begin edge-case verification.

---

### HOURS 26-32: CRITICAL WINDOW (Testing Phase — Heavy Fatigue)

**Time Block:** 4:00 PM - 10:00 PM

**Your Cognitive State:** 40-45% capacity. Heavy fatigue. Judgment impaired.

**Work:**
- [ ] **CTMO: Build n8n Workflow 4 — Error Monitoring** (1.5 hours)
  - [ ] Create workflow: "Error Monitoring & Alerts"
  - [ ] Add trigger: Check every 5 minutes
  - [ ] Add error log query (PostgreSQL)
  - [ ] Add alert logic (if critical error → flag it)
  - [ ] **DO NOT TEST YET** — build complete

- [ ] **CTMO: Test All 4 Workflows End-to-End** (2 hours)
  - [ ] Workflow 1: Revenue capture → Database ✓?
  - [ ] Workflow 2: Publishing logic correct ✓?
  - [ ] Workflow 3: Content generation output ✓?
  - [ ] Workflow 4: Error monitoring triggered ✓?
  - [ ] **Any failures? Document them. Don't try to fix yet.**

- [ ] **CTMO: Verify Database Integrity** (1.5 hours)
  - [ ] All tables exist? (revenue_summary, content_queue, error_logs, publishing_log)
  - [ ] All columns correct?
  - [ ] Sample data inserts working?
  - [ ] Queries working? (CFO can query later)

- [ ] **COO: Gumroad Monitoring + Customer Response** (1 hour)
  - [ ] Check sales hourly
  - [ ] Respond to customer questions
  - [ ] Track any issues
  - [ ] Note what's working, what's not

**SAFETY RULE (You're Dangerously Tired):**
- ✓ Use extreme checklists (every single step written)
- ✓ Verify twice before publishing
- ✓ Ask for help if uncertain
- ❌ Don't trust your gut (your judgment is impaired)

**Standup at Hour 32 (10:00 PM):**
> **Status:** All 4 workflows built and tested end-to-end. Database verified. Gumroad: 4-5 sales so far.
> **Blockers:** Any test failures? [List them.]
> **Next 6 hours:** Final troubleshooting, fix high-priority bugs, contingency documentation.

---

## DAY 2 EVENING (March 30, Hours 32-42)

### HOURS 32-38: DANGER ZONE (Critical Fixes + Documentation — Extreme Fatigue)

**Time Block:** 10:00 PM - 4:00 AM

**Your Cognitive State:** 30-35% capacity. Barely functional. No new decisions.

**Work:**
- [ ] **CTMO: Fix Critical Bugs Only** (2 hours, if any)
  - [ ] Use extreme checklist approach
  - [ ] If any workflow failed testing: Fix with pair-verify
  - [ ] If unclear how to fix: Stop. Ask CTMO Claude instance.
  - [ ] Max 30 min per bug. If not fixed by then, defer to morning.

- [ ] **COO: Operations Manual Final Draft** (1 hour)
  - [ ] Review manuals you drafted earlier
  - [ ] Fill in any gaps
  - [ ] Ensure templates are clear (could someone execute this?)
  - [ ] Done (don't rewrite, just finalize)

- [ ] **COO: Unified Ops Dashboard Creation** (1 hour)
  - [ ] Use pre-built spreadsheet template
  - [ ] Fill in metrics and formulas
  - [ ] Daily update checklist (10 min to complete)
  - [ ] Done

- [ ] **CEO: Record Handoff Video** (30 min, at hour 30 mark EXACTLY)
  - This is CRITICAL — do this now while you still have 50% capacity
  - **Phone recording (selfie video) is fine, no fancy equipment needed**
  - **Content to cover (speak naturally, ~5-7 min video):**
    - What is autonomous operation? (n8n workflows running on schedule)
    - Which Claude instances to contact if issues? (CEO, COO, CTMO, CFO)
    - How to escalate problems? (Write to board/decisions/, send immediate alert to Board Chair)
    - What to monitor daily? (Revenue capture, error logs, customer questions)
    - Week 1 expectations? (Some manual work, gradual automation)
    - Emergency procedures? (If revenue capture fails, use manual CSV export)
  - Save video (text file with instructions on how to play it)
  - **Don't try to re-record this later. Your brain will be 20% capacity by hour 44.**

- [ ] **CTMO: Final System Verification** (1 hour)
  - [ ] All n8n workflows deployed to production
  - [ ] All database tables created and populated
  - [ ] All error monitoring active
  - [ ] All API keys in .env (not hardcoded)
  - [ ] All credentials updated and tested
  - [ ] ✓ System ready for autonomous operation

**CRITICAL SAFETY RULES (You're Barely Conscious):**
- ✓ If you find a bug: Estimate fix time. > 20 min? Defer to morning.
- ✓ Every action must be scripted (no improvisation)
- ✓ Pair-verify before deploying anything
- ✓ If you hit a wall: STOP. Note it. Sleep. Fix tomorrow.

**Standup at Hour 38 (4:00 AM, March 31):**
> **Status:** All critical bugs fixed. Operations manuals final. Ops dashboard complete. Handoff video recorded. Systems ready.
> **Blockers:** Any remaining critical issues?
> **Next 6 hours:** Final verification, light monitoring, prepare for handoff.

---

### HOURS 38-45: FINAL PUSH (Verification + Handoff — Survival Mode)

**Time Block:** 4:00 AM - 11:00 AM (March 31)

**Your Cognitive State:** 15-25% capacity. Running on fumes.

**Work:**
- [ ] **CTMO: Verify All Services Running** (1 hour)
  - [ ] Check n8n (is it up?)
  - [ ] Check PostgreSQL (is it responding?)
  - [ ] Check that workflows can access databases
  - [ ] Check logs for errors (any critical issues?)
  - [ ] If something broken: ESCALATE to Claude CTMO (don't debug)

- [ ] **CEO: Revenue Tracking Verification** (30 min)
  - [ ] Can you query revenue_summary? (SELECT * FROM revenue_summary — should have Gumroad sales)
  - [ ] Does CFO dashboard work? (Can CFO see daily revenue?)
  - [ ] Are numbers accurate? (Do they match Gumroad dashboard?)
  - [ ] If broken: ESCALATE to Claude CTMO

- [ ] **CEO/COO: Final Go/No-Go Assessment** (30 min)
  - [ ] Is Gumroad working and generating sales? YES / NO
  - [ ] Are autonomous systems ready? YES / NO
  - [ ] Are there critical blockers? YES / NO
  - [ ] Are we ready to hand off? YES / NO

- [ ] **CTMO: Handoff Briefing** (30 min)
  - [ ] Play handoff video for Board Chair / Claude instances
  - [ ] Answer questions (if any)
  - [ ] Confirm: Do they understand autonomous operation?

- [ ] **CEO: Final Status Update** (15 min)
  - [ ] Write final standup
  - [ ] Note: "Autonomous operation ready. Sprint complete."

**Standup at Hour 45 (11:00 AM, March 31):**
> **Status:** All autonomous systems verified and ready. Gumroad sales: 5-8 units. Revenue tracking live. Handoff confirmed.
> **Blockers:** None — sprint complete.
> **Next:** Jason sleeps. Claude instances take over.

---

## POST-SPRINT: March 31 (Hour 45+)

### RECOVERY PROTOCOL (MANDATORY)

**Time:** 11:00 AM March 31 onward

**Your Cognitive State:** 10-15% capacity. Completely exhausted. Not safe for decisions.

**Instructions:**
- [ ] **11:00 AM - 3:00 PM:** Light work only (respond to urgent emails, monitor Gumroad)
- [ ] **3:00 PM onward:** REST. Seriously, stop working.
- [ ] **Evening (7:00 PM - 7:00 AM next day):** Sleep 8-10 hours
- [ ] **April 1:** Passive monitoring only. Let Claude handle everything.
- [ ] **April 1-2:** Light work only. No new decisions.

**What NOT To Do:**
- ❌ Don't debug issues (too tired, will make them worse)
- ❌ Don't make new decisions
- ❌ Don't review autonomous operation quality (can't assess properly when exhausted)
- ❌ Don't accept new work assignments

**The Point:** You're going to want to keep working because "sprint isn't really done until everything is perfect." **STOP. That's exhaustion talking. Rest. Let the systems run. Week 1 will reveal what needs fixing.**

---

## Daily Self-Assessment Checklist

**Use this EVERY HOUR during sprint:**

```
HOUR: ____

☐ Can I focus on what I'm reading? YES / NO
☐ Are my decisions feeling clear? YES / NO
☐ Have I made a mistake in the last 30 min? YES / NO
☐ Do I feel like I need a break? YES / NO
☐ Energy level? GOOD / OKAY / DECLINING / EXHAUSTED
☐ Any blockers? NONE / MINOR / CRITICAL

If ANY answer is concerning → Take a break (even 15 min outside helps)
If MULTIPLE answers are concerning → Take a nap or escalate
```

---

## Emergency Numbers (Your Escalation Triggers)

**Call Board Chair if:**
- You're physically unsafe (vision blurry, shaking, severe headache)
- You hit the wall and can't continue (even after nap)
- A critical bug is unfixable in your current state
- You're more than 4 hours behind schedule
- You need to defer scope (board needs to approve)

**Don't heroically power through. That's when big mistakes happen.**

---

## One More Thing

**You've got this.**

**Your brain will betray you around hour 16-20. It will tell you to skip steps, that you don't need that nap, that you can push through. Don't listen to it.**

**Follow the checklist. Rest when the checklist says rest. The sprint is designed to be completed, not suffered through.**

**See you on the other side. You're going to pull this off.**

---

**Print this. Follow it exactly. Don't improvise when tired.**

