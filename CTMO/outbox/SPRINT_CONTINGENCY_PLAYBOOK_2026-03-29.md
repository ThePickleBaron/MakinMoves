# 45-Hour Sprint: Emergency Contingency Playbook
**Purpose:** What to do when things break, Jason gets exhausted, or the plan falls apart.

---

## SECTION 1: COMMON PROBLEMS (Ranked by Frequency)

---

### PROBLEM 1: "I Can't Focus / My Brain Is Foggy" (Hour 16+)

**Symptoms:**
- Reading same sentence multiple times
- Losing track of what you're doing mid-task
- Can't remember what you just typed
- Making same mistake repeatedly

**Diagnosis:** Sleep deprivation + cognitive overload. Normal at hours 16+.

**Immediate Actions (Next 15 Min):**
1. Stop working immediately
2. Drink water + eat protein (20g min — egg, nuts, yogurt)
3. Walk outside for 5 minutes (cold air, movement)
4. If still foggy after 5 min: → Go to NAPPING PROTOCOL below

**Napping Protocol (If Fogginess Persists):**
- Set alarm for 2 hours ahead
- Dark, quiet room
- No phone, no checking work
- Sleep immediately
- Upon waking: Chug water, eat, 10-min walk
- **Cognitive capacity will jump +25-30%**

**When To Use This:**
- Hour 16-20: First sign of fogginess → NAP immediately
- Hour 20-24: If fogginess → NAP (this is critical window)
- Hour 26+: If fogginess AND about to make important decision → NAP (can't afford mistakes)

**When NOT To Use:**
- Don't push through to "just finish this"
- Don't have coffee instead (temporary, crashes harder)
- Don't "come back to it later" (fogginess is a signal to rest NOW)

---

### PROBLEM 2: "I Made a Mistake / Found a Bug" (Any Hour)

**Symptoms:**
- Feature not working as expected
- Data in wrong format
- API call returning errors
- Product page has typo/wrong info

**Diagnosis:** Depends on severity and hour.

**Severity Assessment:**

#### CRITICAL (Breaks Autonomous Operation)
- Example: n8n workflow won't start
- Example: Database schema is wrong (data won't save)
- Example: Revenue tracking completely broken

**Action:**
1. **Hour 0-20:** Fix immediately (brain is sharp enough)
2. **Hour 20+:** Can you defer this fix to morning? → Yes? DEFER. → No? Continue below.
3. If deferring: Document exactly what's broken, what needs to be done to fix
4. If not deferring: Don't debug alone, ask Claude instance for help
5. Set max 30-minute time box. If not fixed by then, escalate + defer.

#### HIGH (Impacts User Experience But Not Blocking)
- Example: Gumroad product page has poor copy
- Example: Operations manual is unclear
- Example: Early test failure in n8n

**Action:**
1. **Hour 0-20:** Fix if time allows (worth 1-2 hours)
2. **Hour 20-32:** Only fix if it's quick (< 15 min). Otherwise defer to post-launch patch.
3. **Hour 32+:** Defer to post-launch. Document the issue.

#### MEDIUM (Nice-To-Have, Can Launch Without Fix)
- Example: Dashboard formatting is ugly
- Example: Email announcement could be better
- Example: Minor typo in product description

**Action:**
- **Always defer.** Fix after autonomous operation is stable.

---

### PROBLEM 3: "I'm Exhausted and Can't Continue" (Hour 24+)

**Symptoms:**
- Physical: Headache, blurred vision, dizziness, shaking
- Mental: Can't think, can't decide, want to quit
- Emotional: Despair, frustration, want to give up

**Diagnosis:** Sleep deprivation + cumulative stress. This is dangerous.

**Immediate Actions (NEXT 5 MIN):**
1. **STOP WORKING.** Stand up. Walk away from desk.
2. If physical symptoms (dizziness, shaking): **MEDICAL PRIORITY.** Drink water, eat, rest 30 min. If not better → Pause sprint.
3. If mental exhaustion: → NAPPING PROTOCOL (2-hour nap)
4. After nap + recovery: Reassess. Can you continue? Yes → Resume. No → ESCALATE (see below).

**Escalation (If You Can't Continue After Nap):**
1. **Call Board Chair** (in COWORK channel): "I'm hitting a wall. Can't continue safely."
2. **Board Chair options:**
   - Defer non-critical work to Week 1 (reduce scope, extend timeline slightly)
   - Pause sprint, resume tomorrow (lose 6 hours, but quality improves)
   - Continue with reduced scope (only critical path, defer extras)

**DO NOT POWER THROUGH.** Exhaustion-driven mistakes cost 10x the time to fix.

---

### PROBLEM 4: "A Platform API Is Down / Not Working" (Any Hour)

**Symptoms:**
- API returns 500 error
- Rate limiting (429 error)
- Authentication failed
- API response wrong format

**Diagnosis:** Platform issue (not your fault). Happens 5-10% of the time.

**Immediate Actions:**

**Step 1: Verify It's Actually Down**
- Check platform status page (most platforms have public status)
- Try from different browser/IP (rule out your network issue)
- Check API docs for known issues

**Step 2: If It's Definitely Down**
- **Hour 0-20:** Try alternative platform. Example: if Etsy API down, test Gumroad instead.
- **Hour 20+:** Document the issue, move on to other work. Come back to it later.
- **Critical Dependency:** If core API (revenue capture) is down, escalate immediately to Board Chair.

**Step 3: If It's Your Config (Not Platform)**
- Check API key (is it correct? Not expired?)
- Check endpoint URL (typo?)
- Check headers (missing auth header?)
- If you find the issue → Fix immediately
- If unclear → Ask Claude instance for code review (don't debug alone when tired)

**Step 4: Fallback Plan**
- No Gumroad API? → Manual CSV upload temporarily
- No Etsy API? → Publish manually, add to database by hand
- No n8n? → Use PostgreSQL cron jobs instead (slower, but works)

---

### PROBLEM 5: "Gumroad Launch Quality Looks Terrible" (Hour 16-20)

**Symptoms:**
- Product page looks unprofessional
- Copy is confusing or weak
- Layout is ugly
- Price seems wrong

**Diagnosis:** Usually caused by rushing during fatigue. Can be fixed.

**Assessment (5 Min):**
1. Is this a blocker to launch? (e.g., broken button? No product description?)
   - Yes → Must fix before publishing
   - No → Can launch and patch within 24 hours
2. Is there time to fix without delaying launch? (< 30 min)
   - Yes → Fix it
   - No → Launch as-is, patch post-launch

**If Fixing:**
- Revert to pre-written copy (you wrote this fresh in hour 0-6)
- Use pre-designed layout (not improvising)
- Test on real product page before publishing
- Verify screenshot looks professional

**If Launching As-Is:**
- Note what needs fixing
- Plan 30-min patch for day after launch
- Communicate to team: "Launching v1.0, v1.1 patch planned Day 2"

**Philosophy:** A 95% product launched today > 100% product launched next week. Iterate fast.

---

### PROBLEM 6: "n8n Workflow Is Broken / Has Bugs" (Hour 30+)

**Symptoms:**
- Workflow triggers but produces wrong output
- Data not flowing to database
- Error logs filling with failures
- API calls returning errors

**Diagnosis:** Common during fatigue hours. Usually configuration or logic error.

**Assessment (5 Min):**

**Critical:** Does this block autonomous operation?
- Yes (revenue capture doesn't work) → Must fix now
- No (publishing workflow has bugs) → Can defer to Week 1

**Debugging Strategy:**

**If Hour 30-36 (Still somewhat coherent):**
1. Check logs (what error is it reporting?)
2. Check one node at a time (is the API call working? Is the database insert working?)
3. If obvious fix → Apply it
4. If unclear → Ask Claude instance for code review
5. Max 30 min. If not fixed by then, defer + document.

**If Hour 36-42 (Very tired):**
- Don't debug yourself
- Ask Claude (CTMO) instance: "Workflow X is broken. What's wrong?"
- Claude debugs, you apply fix (don't change code yourself)
- Verify it works, move on

**If Hour 42+ (Exhausted):**
- Don't touch it
- Document the issue
- Defer to morning when fresh
- Deploy without this workflow (use fallback)

**Fallback Option:**
- If n8n workflow is broken and can't be fixed in time:
  - Disable it
  - Use manual process instead (slower, but works)
  - Example: Manual daily CSV export instead of automated API sync

---

### PROBLEM 7: "The Plan Is Too Ambitious / I Can't Finish" (Hour 20+)

**Symptoms:**
- Fell behind on time estimates
- Only 50% through work, only 50% of time left
- Exhausted, still 3 major tasks remaining

**Diagnosis:** Common. Estimates are usually optimistic.

**Immediate Action: Prioritize Ruthlessly**

**Critical Path (MUST be done):**
1. Gumroad launch (P1)
2. Revenue tracking (n8n + database)
3. Error monitoring (catch issues)
4. Handoff documentation

**Important but Deferrable (to Week 1):**
1. Complete n8n automation (defer 2 of 4 workflows)
2. Operations manual edge cases (core flow only, details later)
3. Week 1 detailed roadmap (overview is enough)

**Nice-To-Have (Drop):**
1. Optimization
2. Extra testing
3. Documentation prettification

**Recovery Plan:**
1. Cut 25% of scope immediately (defer the "Important" list above)
2. Focus on critical path only (hours remaining)
3. Extend autonomous operation timeline by 1 week (defer non-critical work)
4. Launch with 80% feature set, improve in Week 1

**Board Chair Decision:**
- If Jason can't catch up: Board Chair decides what to defer
- Better to launch with 80% on-time than 100% late

---

## SECTION 2: HOUR-SPECIFIC CRISIS PROTOCOLS

---

### CRISIS PROTOCOL: Hour 16 ("The Fatigue Wall")

**What's Happening:**
- Jason's brain is starting to fog (first signs of impairment)
- Already worked 16 hours, decisions are getting slower
- Temptation to "just push through"

**Warning Signs:**
- "I can't decide if this is good enough"
- "Let me just check this one more time"
- "I'll fix it later" (procrastination)

**What To Do:**
1. **STOP.** Whatever you're doing, mark as "in progress," don't continue.
2. **QUICK ASSESSMENT:** Can this task be finished in next 60 min?
   - Yes → Finish it
   - No → Switch to task that can be finished in 60 min
3. **After 60 min of light work:** → Check NAPPING PROTOCOL above. You probably need a nap.
4. **Don't push past hour 20 without napping.** Your judgment will be dangerously impaired.

---

### CRISIS PROTOCOL: Hour 24 ("Midnight Cognitive Cliff")

**What's Happening:**
- Jason has been awake 24 hours
- Sleep deprivation equivalent to blood alcohol 0.08% (drunk)
- Decision-making dangerously impaired
- This is the most dangerous hour

**Warning Signs:**
- "I'll just quickly do X" (actually takes 2 hours)
- Overconfidence about decisions
- Making same mistake repeatedly
- Skipping verification steps

**What To Do:**
1. **DO NOT MAKE ANY DECISIONS AT HOUR 24.**
2. **Every action must be mechanical:** Follow a checklist. No thinking.
3. **If error found:** Don't fix it yourself. Wake Claude instance, ask for help.
4. **If task requires judgment:** DEFER to morning. Post a note for yourself explaining what needs doing.
5. **SLEEP.** You've earned it. The rest can wait 6 hours.

---

### CRISIS PROTOCOL: Hour 32 ("The Exhaustion Threshold")

**What's Happening:**
- Jason is running on empty (awake 24+ hours, slept only 6 hours)
- Judgment severely impaired
- High risk of silent failures (bad code that looks okay)
- This is the danger zone for critical mistakes

**Warning Signs:**
- "This looks right to me" (when it's not)
- Deploying without testing
- Trusting gut instead of process
- Impatience, want to finish

**What To Do:**
1. **EXTREME CAUTION MODE.**
2. **Triple-check everything:** If you think it's done, verify 3 times.
3. **No changes to running systems.** Only testing, not deployment.
4. **Pair verify:** Have Claude instance double-check before deploying.
5. **If you feel unsafe:** PAUSE. Call Board Chair. Defer to morning.

---

### CRISIS PROTOCOL: Hour 38 ("The Final Push")

**What's Happening:**
- Jason is barely conscious (awake 28+ hours, minimal sleep)
- This is the home stretch
- Danger of critical failures due to extreme fatigue

**Warning Signs:**
- Difficulty reading code/instructions
- Skipped steps because "I know this already"
- Overconfidence despite exhaustion
- "Almost there, just push through"

**What To Do:**
1. **READ SCRIPTS ONLY.** Every action must be pre-written.
2. **No new thinking.** Verification, not execution.
3. **If you can't read clearly:** That's your sign to stop. Rest.
4. **If critical task remains:** Defer to morning (with 8-hour rest).

---

## SECTION 3: SCOPE REDUCTION OPTIONS

### Option 1: Defer Non-Critical n8n Workflows (Saves 12-16 Hours)

**Current Plan:** 4 workflows (revenue, publishing, content gen, error monitoring)

**Reduced Plan:** 2 critical workflows (revenue + error monitoring)

**Deferral Details:**
- **Publishing workflow:** Defer to Week 1. Use manual publishing for Day 1.
- **Content generation workflow:** Defer to Week 2. Use pre-generated content template for Day 1.

**Impact:**
- Saves 12-16 hours of CTMO work
- Reduces hours 30-42 from highly technical to moderate complexity
- Extends autonomous operation to Week 2 for these features

**Recommendation:** If Jason is falling behind by hour 20, implement this immediately.

---

### Option 2: Defer Operations Manual Edge Cases (Saves 4-6 Hours)

**Current Plan:** Complete Operations Manual with all decision trees, edge cases, templates

**Reduced Plan:** Core workflow only (happy path + 1 contingency)

**Deferral Details:**
- Week 1: Do manual P2/P3 operations (Jason or contractor)
- Week 2: Document edge cases, automate based on learned patterns

**Impact:**
- Saves 4-6 hours of documentation
- Reduces quality initially but allows learning-driven improvement
- More realistic approach (you'll find edge cases in practice anyway)

**Recommendation:** Use this if hour 24 check-in shows progress is slow.

---

### Option 3: Defer Week 1 Detailed Roadmap (Saves 2-3 Hours)

**Current Plan:** Hour-by-hour Day 1 roadmap + Day-by-day Week 1 plan

**Reduced Plan:** High-level checklist only

**Deferral Details:**
- Day 1 Morning: Jason reviews pre-prepared checklist (30 min)
- As day progresses: Adjust based on live results
- Document lessons for Week 2

**Impact:**
- Saves 2-3 hours of planning
- Slightly higher chaos Week 1 (less prepared)
- More adaptive (can respond to actual results)

**Recommendation:** Lower priority. Only defer if hours 42-45 are critical.

---

### Option 4: Reduce Gumroad Product Count (Saves 2-4 Hours)

**Current Plan:** 3-5 products live by end of sprint

**Reduced Plan:** 1-2 flagship products live, rest follow within 48 hours

**Deferral Details:**
- AI Prompts Bundle (core) → Live March 30
- Freelancer Automation Suite → Live April 1
- Notion Invoice Template → Live April 2

**Impact:**
- Saves 2-4 hours of product builds
- Allows higher quality for launch product
- Extends Week 1 to multiday launch campaign instead of everything at once

**Recommendation:** Consider if hour 16 check-in shows quality suffering.

---

## SECTION 4: ESCALATION MATRIX

### When To Call Board Chair

**Escalate if:**

| Situation | Severity | Action |
|-----------|----------|--------|
| Can't continue, physically/mentally exhausted | CRITICAL | Stop work, nap, reassess. If still blocked → Call Board Chair |
| Critical bug found, can't fix in time | CRITICAL | Document bug, defer to Week 1, focus on other work |
| Behind schedule, won't finish by midnight | HIGH | Review scope reduction options, implement one |
| Platform API down (critical path) | HIGH | Switch to fallback, document issue, continue |
| Gumroad quality looks bad, need to decide fix vs. defer | MEDIUM | Fix if < 30 min. Otherwise defer, launch, patch post-launch |
| COO thinks Operations Manual needs overhaul | MEDIUM | Use template, defer edge cases to Week 1 |
| Jason making repeated mistakes (sign of exhaustion) | MEDIUM | Pause, nap, reassess. If pattern continues → Call Board Chair |
| Uncertain if quality is acceptable | LOW | Pair verify with Claude instance |

---

## SECTION 5: JASON'S PERSONAL CHECKLIST

### Print This & Keep At Desk

```
BEFORE SPRINT STARTS (Do These Today)
☐ Pre-write Gumroad product copy
☐ Pre-design product page layout
☐ Research 10 competitors for positioning validation
☐ Outline Operations Manual templates
☐ Outline n8n automation flow
☐ Print this contingency playbook
☐ Print hour-by-hour cognitive map
☐ Print escalation matrix

DURING SPRINT: Hourly Check-In
(Every hour, take 2 min to assess your state)

☐ Am I able to focus? (YES / NO)
☐ Are my decisions clear or muddy? (CLEAR / MUDDY)
☐ Have I made a mistake in the last 30 min? (YES / NO)
☐ Do I need a break/nap? (YES / NO)
☐ Are there blockers? (NONE / MINOR / CRITICAL)

If ANY answer is concerning → Take a break, reassess

CRITICAL DECISION POINTS

Hour 6: ☐ Are all strategic decisions locked? If no → Fix this first
Hour 16: ☐ Fogginess starting? → Plan nap in next 4 hours
Hour 20: ☐ Gumroad ready to launch? Quality acceptable? If no → Fix or defer
Hour 24: ☐ Take nap if you haven't (you're drunk-tired now)
Hour 30: ☐ Record handoff video (before you're too incoherent)
Hour 36: ☐ Core automation working end-to-end? If no → Escalate
Hour 42: ☐ All systems green? Ready to hand off?
Hour 45: ☐ SLEEP NOW
```

---

**You've got this. Follow the checklist. When in doubt, rest. When critical, escalate.**

**Your brain will fail you. Your checklist won't.**

