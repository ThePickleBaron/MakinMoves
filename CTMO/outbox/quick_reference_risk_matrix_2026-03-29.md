# Quick Reference: Risk Matrix & Emergency Actions
**Keep this open during Sunday sprint. Print if needed.**

---

## FAILURE RISKS (Ranked by Probability)

| Rank | Risk | P(%) | If It Happens | Emergency Action |
|------|------|------|---|---|
| **1** | COO execution velocity | 85% | Tasks slip, articles/designs late | Reduce P3 scope (5→3 designs) or hire freelancer |
| **2** | P3 content quality | 70% | Designs/articles rushed, low quality | Accept lower revenue M1, iterate Week 2 |
| **3** | CTMO infrastructure | 65% | Workflows incomplete/untested | Deploy revenue capture only, manual publishing Week 1 |
| **4** | P1 validation (frameworks) | 60% | Frameworks weak/late | Pivot to white-label backup, defer CTK to Week 2 |
| **5** | Autonomous handoff | 55% | Hidden bugs cause Week 1 failures | Keep manual override active, COO monitors Week 1 |
| **6** | API breakage | 50% | Platform API unavailable | CSV fallback, manual uploads Week 1 |

---

## CONTINGENCY TRIGGERS & ACTIONS

### Saturday Evening (Today ~8pm)
**Red flags to watch:**
- CEO: "Frameworks are 90% done" → need polish
- COO: "Haven't tested accounts yet" → approval delays possible
- CTMO: "Redbubble API looks broken" → workaround needed

**Action:** If any red flag, report immediately to CEO

---

### Sunday Morning (7am)
**Critical sync points:**
- **12pm deadline:** CEO frameworks delivered (rough OK)
- **3pm deadline:** COO has article #1 done, can start #2
- **6pm deadline:** CTMO has APIs tested, workflows prioritized

**Red flags:**
- CEO: "Still 3 hours away from frameworks" → ACTIVATE SCOPE REDUCTION
- COO: "Can't finish 2 articles" → HIRE FREELANCER or reduce to 1 article
- CTMO: "API broken, no workaround" → CSV fallback or defer to April 3

---

### Sunday Afternoon (3pm Decision Point)
**If ANY role is behind schedule:**

| If Behind | Do This | Cost |
|---|---|---|
| **P1 (frameworks)** | Switch to white-label (2-3 templates), defer CTK to Week 2 | -$500-1000 M1 revenue |
| **P2 (articles)** | Hire freelancer for 1 article ($100-150) or reduce to 1 article | +$100-150 cost or -$200/month |
| **P3 (designs)** | Reduce from 5 to 3 designs, add #4-5 April 2-3 | -$100-300 revenue |
| **CTMO workflows** | Deploy revenue capture only, manual publish/generate Week 1 | +10-15 hours manual work |

---

### Sunday Evening (9pm Check)
**Pre-flight checklist before handoff:**

- [ ] P1 product live on Gumroad?
- [ ] P2 article + WordPress live?
- [ ] P3 designs (3+) live on Redbubble?
- [ ] Revenue tracking active?
- [ ] Error logs functional?
- [ ] At least 1 workflow automated?
- [ ] All credentials staged?
- [ ] Documentation complete?

**If ALL checked:** GO for handoff
**If ANY unchecked:** Activate scope reduction + prioritize essentials only

---

## PRIORITY ORDER (If forced to cut)

**Streams (pick which ones ship):**
1. ✅ P1 (highest margin, MUST launch)
2. ✅ P2 (content compounding, MUST launch with 1 article)
3. 🤔 P3 (can reduce scope or delay to April 1-3)

**Automation (pick what gets automated):**
1. ✅ Revenue capture (essential for CFO tracking)
2. ✅ Error monitoring (watch for failures)
3. 🤔 Publishing (can be manual Week 1)
4. 🤔 Content generation (can be manual Week 1)

**If forced to choose:** P1 + P2 + revenue tracking > all 3 streams with incomplete automation

---

## FREELANCER EMERGENCY CONTACTS

**If COO needs help with article:**
- Budget: $100-150 for 1 article
- Turnaround: 6-12 hours (rush delivery)
- Where to find: Fiverr ("blog writing, SEO, 1000+ words")
- Pre-approve: YES (CEO authorized, use reserve budget)

**If COO needs help with designs:**
- Budget: $50-100 per design
- Where to find: Fiverr ("Redbubble design, t-shirt mockup")
- Pre-approve: YES (if available)

---

## HIDDEN TIME BOMBS

**Watch out for these Sunday:**

1. **Gumroad account approval delays** (can take 2-6 hours)
   - Mitigation: Test accounts TODAY (Saturday)

2. **WordPress domain registration delays** (can take 1-2 hours)
   - Mitigation: Register domain TODAY (Saturday)

3. **Redbubble API undefined** (no official API)
   - Mitigation: Pre-build CSV fallback TODAY (Saturday)

4. **n8n performance under load** (workflows timeout with many tasks)
   - Mitigation: Test with real data before full deploy

5. **Claude API quota limits** (if content generation runs 10+ times)
   - Mitigation: Test quota limits TODAY (Saturday)

6. **Silent failures in scheduled jobs** (cron jobs failing without alert)
   - Mitigation: Add email alerts to error logs

---

## SUCCESS CHECKLIST (8 Criteria)

**By March 31 23:59, these MUST be true:**

- [ ] P1 live on Gumroad (even if $0 revenue, product is discoverable)
- [ ] P2 WordPress + 1 article (SEO basics covered, live for indexing)
- [ ] P3 Redbubble + 3 designs (enough for test sales volume)
- [ ] Revenue tracking active (CFO can query sales by platform)
- [ ] Error logging working (no silent failures go undetected)
- [ ] ≥1 workflow automated (at least one thing doesn't need human touch)
- [ ] Documentation complete (Week 2 team knows what's missing)
- [ ] Zero catastrophes (systems don't break unexpectedly)

**If 6/8 criteria met:** Acceptable launch
**If 8/8 criteria met:** Excellent launch
**If <6/8 criteria met:** Risky handoff (needs manual override Week 1)

---

## COMMUNICATION PROTOCOL SUNDAY

**Rapid updates (every 4 hours):**
- Post to `board/status/status_CURRENT.md` (one-liner status)
- If RED FLAG, escalate to CEO immediately (Slack if available)

**Formal updates (morning + evening):**
- Write standup to `board/standups/standup_2026-03-30_HHMM.md`
- Include blockers + next 2-hour plan

**Decision gates (3pm + 10pm):**
- If ANY red flags, CEO makes contingency call immediately
- Don't debate, execute

---

## ESCALATION PATH

**If something breaks Sunday:**

1. **Try to fix it** (30 min max)
2. **If not fixable, pivot to contingency** (activate from above matrix)
3. **If pivot doesn't work, escalate to CEO** (immediate decision)
4. **CEO decides:** Ship anyway, or delay feature/stream

**Example flow:**
```
09:00 Sun: CTMO reports "Redbubble API broken"
          ↓
09:30 Sun: Activate CSV fallback, test it
          ↓
10:00 Sun: Fallback works, manual uploads Week 1 acceptable
          ↓
Result: P3 ships with manual publication (acceptable)
```

---

## FINAL WORD

**If you're reading this Sunday and things are going wrong, remember:**

- **Imperfect launch today > perfect launch Monday** (deadline is hard)
- **2 streams well-executed > 3 streams half-baked** (quality matters)
- **Manual work Week 1 is OK** (nobody expects perfection Day 1)
- **Document what's missing** (next team (or user Week 2) knows what to fix)

**The goal is autonomous operation by March 31. If you ship 70% autonomous with 30% manual Week 1, that's still a WIN.**

---

**Print this. Reference during sprint. Update as you go.**

**Last updated: 2026-03-29 23:15**

