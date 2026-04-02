# Weekly Risk Assessment — CEO Standup Checklist
**Version 1.0 | Updated 2026-03-29**

**Purpose:** 5-minute risk review every Sunday (or before board meetings)
**Owner:** CEO + CFO (joint)
**Duration:** 5 minutes maximum
**Output:** Log results to `CEO/logs/weekly-risk-log.md` + escalate RED flags within 1 hour

---

## QUICK REFERENCE: COLOR CODES

```
🟢 GREEN:  On track, no action needed, continue
🟡 YELLOW: Watch closely, may need action next week
🔴 RED:    Critical issue, escalate to CEO NOW
```

---

## WEEKLY CHECKLIST (Copy-Paste Template)

```markdown
# Weekly Risk Assessment — Week [#]
**Date:** YYYY-MM-DD
**Period:** [Last 7 days]
**CEO:** [Sign initials]

## STREAM PERFORMANCE (vs. forecast)
- [ ] P1 (Digital Products): On track / Lagging / Exceeding
  - Expected: $[X], Actual: $[Y], Variance: [+/-Z]%
  - Status: 🟢 / 🟡 / 🔴
  - Issue (if red): [___________________]

- [ ] P2 (Affiliate Blog): On track / Lagging / Exceeding
  - Expected: $[X], Actual: $[Y], Variance: [+/-Z]%
  - Status: 🟢 / 🟡 / 🔴
  - Issue (if red): [___________________]

- [ ] P3 (PoD + N8N): On track / Lagging / Exceeding
  - Expected: $[X], Actual: $[Y], Variance: [+/-Z]%
  - Status: 🟢 / 🟡 / 🔴
  - Issue (if red): [___________________]

## FOUNDER HEALTH (Burnout Risk)
- [ ] Founder completed planned tasks: YES / NO / PARTIAL
- [ ] Founder missed deadlines: NO / 1 / 2+ (red if 2+)
- [ ] Founder hours worked: <40 / 40-50 / >50
  - Status: 🟢 / 🟡 / 🔴
  - If red: Escalate burnout protocol (descope or hire)

- [ ] Quality maintained: YES / NO / Declining
  - Status: 🟢 / 🟡 / 🔴

- [ ] Standups on-time: YES / NO
  - Status: 🟢 / 🔴 (missing standups = serious signal)

## INFRASTRUCTURE & PLATFORMS
- [ ] Gumroad: Live / Issues / Suspended
  - Status: 🟢 / 🟡 / 🔴
  - Contingency: [SendOwl / Podia active if red]

- [ ] Stripe: Processing / Under Review / Suspended
  - Status: 🟢 / 🟡 / 🔴
  - Contingency: [Square active if red]

- [ ] Redbubble: Designs approved / Rejections / Blocked
  - Approval rate: [_]%
  - Status: 🟢 / 🟡 / 🔴
  - Contingency: [Printful active if red]

- [ ] WordPress/Email: Working / Issues / Down
  - Status: 🟢 / 🟡 / 🔴
  - Contingency: [Substack active if red]

- [ ] N8N data pipeline: Flowing / Errors / Broken
  - Status: 🟢 / 🟡 / 🔴
  - Fallback: [Manual CSV import if red]

## METRICS HEALTH CHECK
- [ ] Revenue tracking live: YES / NO / Partial
  - Status: 🟢 / 🟡 / 🔴

- [ ] Email deliverability: Good / Degrading / Poor
  - Open rate: [_]%, Bounce: [_]%, Spam reports: [#]
  - Status: 🟢 / 🟡 / 🔴

- [ ] Product ATC rate: >1.5% / 0.5-1.5% / <0.5%
  - Status: 🟢 / 🟡 / 🔴

- [ ] Email signup rate: >2% / 1-2% / <1%
  - Status: 🟢 / 🟡 / 🔴

## RED FLAGS THIS WEEK?
(Check all that apply)
- [ ] Revenue <50% of forecast (all streams combined)
- [ ] Founder >50 hours/week OR missed deadline
- [ ] Platform account suspended or banned
- [ ] Product ATC rate <0.5% (no sales despite traffic)
- [ ] Email signup <1% (list not growing)
- [ ] Standup missed OR quality drop noticed
- [ ] Payment processing blocked
- [ ] Data pipeline broken (CFO blind to metrics)

## ESCALATION DECISION
```

If ANY RED FLAG above:
```
🔴 RED ESCALATION
├─ Issue: [___________________]
├─ Contingency: [___________________]
├─ Action: [___________________]
├─ Decision owner: CEO
├─ Timeline: Within 4 hours
└─ Document: board/decisions/decision_YYYY-MM-DD_[issue].md
```

Else:
```
🟢 GREEN / 🟡 YELLOW: Continue as planned
├─ Watch for [___________] next week
└─ No escalation needed
```

## QUICK ACTIONS FOR YELLOW FLAGS

| Issue | Quick Fix | Timeline |
|-------|-----------|----------|
| P1 ATC low | A/B test lower price ($14.99) | 1 week |
| P2 no list growth | Improve CTA + free checklist | 1 week |
| P3 high rejections | Switch to Printful | 1 day |
| Founder stress rising | Descope P2 writing | Immediate |
| Email spam rate up | Test Substack | 1 day |
| Revenue tracking broken | Manual CSV fallback | 1 day |

## NEXT WEEK FORECAST
```
Expected revenue: $[X]
Expected challenges: [_____________________]
Confidence level: [1-10] — if <6, need contingency prep
```

---

END CHECKLIST
```

---

## USAGE GUIDE

### When to Run This Checklist
- **Regular:** Every Sunday at 6 PM (30 min before CEO evening review)
- **Emergency:** Anytime a RED flag is detected during the week
- **Decision gates:** Day 30, 45, 60, 90 (full deep-dive version)

### How to Complete (5 Min Protocol)
1. **Quick scan:** Check each line (2 min)
2. **Color code:** Mark 🟢/🟡/🔴 (1 min)
3. **Escalate if RED:** Flag issue, call CEO within 1 hour (1 min)
4. **Log results:** Copy to `CEO/logs/weekly-risk-log.md` (1 min)

### Who Participates
- **CEO:** Reads + makes decisions
- **CFO:** Runs numbers, provides metrics
- **COO:** Reports status on streams
- **CTMO:** Reports platform + infrastructure status

### Escalation Path for RED Flags
```
RED FLAG DETECTED (any time)
        ↓
CEO notified within 1 hour
        ↓
Contingency activated within 4 hours
        ↓
Decision documented in board/decisions/
        ↓
Next board standup: Review + learn
```

---

## EXAMPLE FILLED-OUT CHECKLIST (Week 2)

```markdown
# Weekly Risk Assessment — Week 2
**Date:** 2026-04-06
**Period:** Mar 30 - Apr 6
**CEO:** JAS (initials)

## STREAM PERFORMANCE
- [x] P1 (Digital Products): On track ✓
  - Expected: $75, Actual: $120, Variance: +60%
  - Status: 🟢

- [x] P2 (Affiliate Blog): Lagging slightly
  - Expected: $25, Actual: $0, Variance: -100%
  - Status: 🟡 (expected — SEO needs 3-5 weeks)
  - Issue (if red): GSC shows 5 impressions, 0 clicks (normal)

- [x] P3 (PoD + N8N): On track
  - Expected: $30, Actual: $45, Variance: +50%
  - Status: 🟢

## FOUNDER HEALTH
- [x] Founder completed planned tasks: YES ✓
- [x] Founder missed deadlines: NO
- [x] Founder hours worked: 40-50
  - Status: 🟢 (within sustainable range)
- [x] Quality maintained: YES ✓
- [x] Standups on-time: YES ✓

## INFRASTRUCTURE
- [x] Gumroad: Live ✓
  - Status: 🟢
- [x] Stripe: Processing ✓
  - Status: 🟢
- [x] Redbubble: Designs approved ✓
  - Approval rate: 95%
  - Status: 🟢
- [x] WordPress/Email: Working ✓
  - Status: 🟢
- [x] N8N data pipeline: Flowing ✓
  - Status: 🟢

## METRICS HEALTH
- [x] Revenue tracking live: YES ✓
- [x] Email deliverability: Good (28% open rate)
  - Status: 🟢
- [x] Product ATC rate: 2.1% ✓
  - Status: 🟢
- [x] Email signup rate: 3.2% ✓
  - Status: 🟢

## RED FLAGS THIS WEEK?
(All unchecked — GREEN week!)
- [ ] Revenue <50% of forecast
- [ ] Founder >50 hours/week
- [ ] Platform account issues
- [ ] Product ATC <0.5%
- [ ] Email signup <1%
- [ ] Standup missed
- [ ] Payment blocked
- [ ] Data pipeline broken

## ESCALATION DECISION
🟢 GREEN — All systems go
├─ Combined revenue: $165 (vs. $130 forecast, +27%)
├─ Founder healthy, no burnout signals
├─ Platforms stable, data flowing
└─ Continue as planned, watch P2 SEO growth

## QUICK ACTIONS FOR NEXT WEEK
- Keep momentum on P1/P3 (both exceeding)
- P2: Seed article on Reddit + Twitter (manual traffic)
- Monitor P2 for Week 3+ (should show traffic by then)

## NEXT WEEK FORECAST
Expected revenue: $200+ (on pace for Day 30 gate)
Confidence level: 9/10 — strong momentum
```

---

## DECISION QUICK REFERENCE

### If Revenue is <50% of Forecast
```
DIAGNOSIS:
1. Which stream is failing?
   - All three = Market/niche issue (pivot)
   - One stream = Stream-specific issue (fix or descope)

DECISION TREE:
├─ P1 failing: Niche or pricing issue
│  └─ Fix: A/B test $14.99 OR pivot niche Week 5
├─ P2 failing: Traffic or email signup issue
│  └─ Fix: Manual seeding (Reddit) OR improve CTA
└─ P3 failing: Design quality or moderation issue
   └─ Fix: Switch to Printful OR update design style

ESCALATE: If all three failing = CEO emergency meeting (Day 30+)
```

### If Founder Hours >50
```
DIAGNOSIS: Unsustainable workload, burnout risk

DECISION TREE:
├─ Which stream is most stressful?
│  ├─ P1: Too many products? → Slow down to 1 every 2 weeks
│  ├─ P2: Too much writing? → Descope to 0 articles (pause)
│  └─ P3: Too many designs? → Hire designer ($150/week)
│
└─ IMMEDIATE ACTION (today):
   ├─ Email CEO: "I'm at 60+ hours, need to descope"
   ├─ CEO chooses: Descope P2 OR Hire writer/designer
   ├─ Implementation: Start Week 4
   └─ Goal: Back to <45 hours/week

ESCALATE: If founder hits 60+ for 3 consecutive days = RED
```

### If Platform Banned / Account Suspended
```
DIAGNOSIS: Immediate revenue loss if not fixed

ACTION (within 4 hours):
├─ Activate backup platform (pre-built in Week 1)
├─ Copy product data → backup platform
├─ Email customers: "We've moved, same product"
├─ Update marketing links
└─ Monitor sales next 24 hours

TIMELINE:
├─ Hour 1-2: Activate + upload products
├─ Hour 2-3: Email + social + update links
├─ Hour 3-4: Monitor first sales
└─ Expected: 50% of normal sales by Hour 6

ESCALATE: If backup platform also has issues = CEO meeting
```

### If Email Signup Rate <1%
```
DIAGNOSIS: Lead magnet or CTA not compelling

QUICK FIXES:
├─ Option 1: Improve CTA text (Day 1)
│  └─ Change "Join list" → "Get free [checklist/template]"
├─ Option 2: Add lead magnet (Day 1-2)
│  └─ Free PDF checklist OR template OR guide
└─ Option 3: Test different platform (Day 2-3)
   └─ Substack → better inbox positioning

TIMELINE: Results by end of Week 2

ESCALATE: If still <1% after all 3 fixes = Content issue
```

---

## DECISION MATRIX (Quick Reference)

| Metric | 🟢 Green (OK) | 🟡 Yellow (Watch) | 🔴 Red (Act Now) | Action |
|--------|---------------|-------------------|------------------|--------|
| **Revenue % of forecast** | >80% | 50-80% | <50% | Fix stream or descope |
| **Founder hours/week** | <45 | 45-55 | >55 | Descope or hire |
| **Product ATC rate** | >1.5% | 0.5-1.5% | <0.5% | A/B test price/niche |
| **Email signup rate** | >2% | 1-2% | <1% | Improve CTA/magnet |
| **Platform status** | Live, processing | Under review | Banned/suspended | Activate backup |
| **Data pipeline** | Flowing | Slow/warnings | Broken | Manual fallback |
| **Standup completion** | 100% on-time | Occasional miss | 2+ missed | Escalate burnout |
| **Quality maintenance** | Consistent | Minor dips | Declining trend | Reduce scope |

---

## WEEKLY LOG TEMPLATE

```markdown
# CEO Weekly Risk Log

## Week 1 (Mar 30 - Apr 6)
- **Status:** GREEN ✓
- **Combined Revenue:** $165 (forecast $130, +27%)
- **Founder Health:** Excellent (40-45 hrs/week)
- **Platforms:** All live + processing
- **Escalations:** None
- **Next Week Watch:** P2 SEO growth, founder burnout (monitor)

## Week 2 (Apr 7 - Apr 13)
- **Status:** GREEN ✓
- **Combined Revenue:** $220 (forecast $150, +47%)
- **Founder Health:** Good (45-50 hrs/week, slightly stressed)
- **Platforms:** All live, 95%+ approval rates
- **Escalations:** None
- **Next Week Watch:** P2 seeding, prepare for Week 3 hiring decision

## Week 3 (Apr 14 - Apr 20)
- **Status:** YELLOW ⚠️
- **Combined Revenue:** $180 (forecast $200, -10%)
- **Founder Health:** CAUTION (52 hrs/week, 1 missed deadline)
- **Platforms:** All live, P3 rejection rate up to 15%
- **Escalations:** Consider descoping P2 or hiring writer for Week 4
- **Next Week Watch:** Founder burnout (monitor daily), P3 design quality

## Week 4 (Apr 21 - Apr 26) — DAY 30 GATE
- **Status:** GREEN ✓
- **Combined Revenue:** $245 (forecast $200, +22%)
- **Founder Health:** Improved (42 hrs/week after descope)
- **Platforms:** All live + stable
- **Escalations:** None
- **Gate Decision:** GO (proceed to Phase 1B, unlock Tier 1.5)
```

---

## FINAL CHECKLIST: Before Deployment

Before using this checklist in production (Week 1), confirm:

- [ ] CEO has printed this checklist (or bookmarked it)
- [ ] CEO understands color codes (🟢/🟡/🔴)
- [ ] CFO will provide metrics every Sunday (revenue, email, traffic)
- [ ] COO will report stream status + founder hours
- [ ] CTMO will report platform + infrastructure status
- [ ] Weekly log file created: `CEO/logs/weekly-risk-log.md`
- [ ] Board meeting invites scheduled (Sundays, 30 min)
- [ ] Escalation contacts known (who to call for RED flags)

---

**Status:** ✓ Ready to use
**Version:** 1.0
**Last Updated:** 2026-03-29
**Next Review:** Day 7 (Apr 6) — first real data point

---

**Print this. Use it every Sunday. Red flags = Act within 4 hours.**

**Good luck. Let's stay on top of this together.** 🎯
