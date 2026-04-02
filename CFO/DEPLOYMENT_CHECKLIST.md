# Sensitivity Dashboard Deployment Checklist

**Date:** 2026-03-29 21:45
**Owner:** CFO
**Target:** Live tracking by April 1 (tomorrow)
**Approval:** Conditional on weekly gate reviews

---

## PHASE 1: DOCUMENTATION REVIEW (30 min — Today)

- [x] **SENSITIVITY_DASHBOARD_2.5X_VIABILITY.md** — Complete (27KB)
  - [x] 8 assumptions analyzed (base/upside/downside)
  - [x] Tornado diagram created
  - [x] Stress testing scenarios documented
  - [x] Validation schedule defined
  - [x] Critical findings identified

- [x] **SENSITIVITY_EXECUTIVE_SUMMARY.md** — Complete (11KB)
  - [x] Board-ready headline (3 critical assumptions)
  - [x] 3 validation gates defined (Apr 7, 14, 28)
  - [x] 4 financial scenarios with probabilities
  - [x] CFO recommendation drafted
  - [x] Standing orders for execution

- [x] **SENSITIVITY_QUICK_REFERENCE.md** — Complete (7.3KB)
  - [x] Quick lookup table (8 assumptions + impact)
  - [x] Daily checklist created
  - [x] Weekly gate review checklist
  - [x] Escalation triggers defined
  - [x] Decision trees drafted
  - [x] Standup template provided

- [x] **SENSITIVITY_INDEX.md** — Complete (11KB)
  - [x] Document navigation guide
  - [x] How-to-use guide
  - [x] Key decision points summary
  - [x] Example standup updates
  - [x] Red flag response protocols

---

## PHASE 2: TRACKING INFRASTRUCTURE (April 1 — Tomorrow)

### CFO Daily Dashboard Setup
- [ ] **P1 Gumroad Tracking Sheet**
  - [ ] Daily sales ✓
  - [ ] Daily list growth ✓
  - [ ] Impressions/views ✓
  - [ ] Any platform alerts? ✓
  - [ ] Method: Screenshot or API (if available)

- [ ] **P2 Email Metrics**
  - [ ] Emails queued (count)
  - [ ] Opens (if sent)
  - [ ] Clicks (if sent)
  - [ ] Inquiries (count)
  - [ ] Method: Email platform (ConvertKit/HubSpot)

- [ ] **CEO Effort Tracking**
  - [ ] Hours logged per stream (P1/P2/P3)
  - [ ] Total hours this week
  - [ ] Trend line (hours increasing? stable? decreasing?)
  - [ ] Method: Time-tracking app or CEO log sheet

- [ ] **Financial Snapshot**
  - [ ] Revenue this week (by stream)
  - [ ] Costs this week
  - [ ] Cumulative M1 revenue
  - [ ] Burn rate (costs/week)
  - [ ] Method: PostgreSQL queries or spreadsheet

### Dashboard Format
- [ ] Spreadsheet or markdown file created
- [ ] Shared location: `CFO/logs/daily_tracking_YYYY-MM-DD.md` (created daily)
- [ ] Owner: CFO
- [ ] Update frequency: Daily (morning check)

---

## PHASE 3: GATE REVIEW PROTOCOL (Weekly — Friday)

### Gate 1: April 7 (10 Days Away)
- [ ] **Measure:** P2 inquiry rate + P1 shadowban + CEO effort
- [ ] **Threshold:**
  - P2 inquiry rate ≥ 5% ✓ GO
  - P1 no throttling ✓ GO
  - CEO effort ≤ 12 hrs ✓ GO
- [ ] **Decision:** All 3 pass → approve 3x strategy
- [ ] **Escalation:** If any fails → notify CEO/COO, recommend fallback
- [ ] **Documentation:** Gate 1 review written to `CFO/inbox/gate_1_review_apr_07.md`

### Gate 2: April 14 (17 Days Away)
- [ ] **Measure:** P3 partnerships + P2 warm revenue
- [ ] **Threshold:**
  - P3 commitments ≥ 2 ✓ GO or fallback to organic-only
  - P2 first customer by Apr 14 ✓ GO
- [ ] **Decision:** Approve scaling or activate P3 fallback
- [ ] **Escalation:** If P2 conversion weak → review pitch, consider cold outreach
- [ ] **Documentation:** Gate 2 review written to `CFO/inbox/gate_2_review_apr_14.md`

### Gate 3: April 28 (28 Days Away)
- [ ] **Measure:** Cumulative revenue + list size + recovery projection
- [ ] **Threshold:**
  - Cumulative revenue ≥ $1,500 ✓ on track
  - P1 list ≥ 400 ✓ on track
  - Recovery projection ≤ Day 90 ✓ on track
- [ ] **Decision:** On track for Day 85-90 recovery or escalate
- [ ] **Escalation:** If revenue <$800 → full sensitivity review
- [ ] **Documentation:** Monthly review written to `CFO/logs/monthly_review_apr_28.md`

---

## PHASE 4: STANDUP INTEGRATION (Daily — Starting Tomorrow)

- [ ] **CFO Standup Template Deployed**
  - [ ] Location: Board standup file weekly
  - [ ] Length: 5 min (3 bullet points per section)
  - [ ] Frequency: Every Friday (gate review)
  - [ ] Template: Copy from SENSITIVITY_QUICK_REFERENCE.md

- [ ] **Board Notification Protocol**
  - [ ] Green (On track): Status quo, continue
  - [ ] Yellow (At risk): 1 assumption trending wrong, watch carefully
  - [ ] Red (Failed): Gate crossed, fallback activated immediately
  - [ ] Escalation format: Email CEO/COO within 2 hours of threshold crossed

---

## PHASE 5: ESCALATION RESPONSE (Ready to Deploy)

### If P2 Inquiry Rate < 2% (By Apr 10)
- [ ] **Action Plan Drafted:** QUICK_REFERENCE.md "Red Flags" section
- [ ] **Fallback Ready:** Cold outreach sequence prepared
- [ ] **Timeline:** 7-day pivot window
- [ ] **Notification:** Email to CEO/COO with recommendation

### If P1 Shadowban Confirmed (By Apr 7)
- [ ] **Action Plan Drafted:** Shift 50% to Etsy, keep 50% Gumroad
- [ ] **Fallback Ready:** Etsy account + Stripe direct checkout
- [ ] **Timeline:** 7-day platform migration
- [ ] **Notification:** Email to CEO/COO + CTMO immediately

### If CEO Effort > 70 hrs/mo (Weekly Check)
- [ ] **Action Plan Drafted:** Outsource design ($200-400) or reduce scope
- [ ] **Fallback Ready:** 15-template MVP instead of 30
- [ ] **Timeline:** 1-week intervention
- [ ] **Notification:** Email to CEO + COO immediately

---

## PHASE 6: MONTHLY REVIEW CADENCE (April 28 & Ongoing)

- [ ] **Monthly Financial Review**
  - [ ] Actual revenue vs. forecast (all streams)
  - [ ] Actual costs vs. forecast
  - [ ] Actual burn rate vs. forecast
  - [ ] Update recovery date projection
  - [ ] File: `CFO/logs/monthly_review_YYYY-04.md`

- [ ] **Sensitivity Update**
  - [ ] Which assumptions proving correct/wrong?
  - [ ] Update variance estimates
  - [ ] Recalculate recovery scenarios
  - [ ] File: Append to monthly review

- [ ] **Board Summary**
  - [ ] Create monthly financial report for CEO
  - [ ] CFO recommendation on strategy (continue/adjust/pivot)
  - [ ] File: `CFO/outbox/financial_report_YYYY-04.md`

---

## SUCCESS CRITERIA FOR DEPLOYMENT

### Week 1 (Apr 1-7)
- [ ] Daily tracking running without errors
- [ ] P1 validation complete (no shadowban, acceptable list growth)
- [ ] P2 pitch test complete (inquiry rate measured)
- [ ] CEO effort tracking accurate
- [ ] **Gate 1 decision made by Apr 7**

### Week 2-3 (Apr 8-21)
- [ ] Gate reviews on schedule
- [ ] Red flags identified early (if any)
- [ ] Fallbacks activated if thresholds crossed
- [ ] Recovery projection updated
- [ ] **Gate 2 decision made by Apr 14**

### Month 1 (Apr 1-28)
- [ ] Zero tracking gaps
- [ ] All assumptions validated or flagged
- [ ] Recovery timeline confirmed (on track, early, late?)
- [ ] Team confidence in strategy high (or fallback active)
- [ ] **Gate 3 decision made by Apr 28**

---

## HANDOFF REQUIREMENTS

### For Tomorrow (April 1)

**To CTMO:**
- [ ] Daily tracking dashboard format specified (spreadsheet or markdown?)
- [ ] P1/P2 data sources confirmed (Gumroad API? Email platform API?)
- [ ] CEO effort tracking method confirmed (time-tracking app?)
- [ ] Testing: All tracking live by 9 AM tomorrow

**To CEO:**
- [ ] 3x strategy approval (conditional on gates)
- [ ] Weekly time budget commitment (60 hrs/mo max)
- [ ] P3 partnership outreach due by Apr 2
- [ ] 30-day check-in: Apr 1 11 AM (confirm effort tracking method)

**To COO:**
- [ ] P2 warm email sequences ready by Apr 7
- [ ] P2 conversion tracking live (customer data in database)
- [ ] CEO effort tracking method clear
- [ ] Weekly standup: CFO section due Friday 5 PM

---

## CONTINGENCY PLANS

### If Tracking Infrastructure Not Ready by Apr 1
- **Fallback:** Manual spreadsheet (CSV file, CFO updates daily)
- **Duration:** 7 days (CTMO prioritizes API integration)
- **Impact:** None (data still collected, just slower update)

### If Gate 1 Results Ambiguous (e.g., 3-4% inquiry rate instead of 5%+)
- **Decision:** Continue with caution, increase monitoring frequency
- [ ] Daily inquiry rate tracking (vs. weekly)
- [ ] Retest pitch by Apr 14 if trending stays 3-4%
- [ ] No escalation unless trend continues downward

### If CEO Effort Data Missing or Unreliable
- **Fallback:** CFO estimates based on output quality (rebranded templates, email sequences, etc.)
- [ ] Weekly check-in call with CEO to confirm hours
- [ ] Observation-based assessment if self-reported data gaps
- [ ] Duration: Until time-tracking app deployed

---

## DEPENDENCIES & CONFIRMATIONS

- [ ] **CEO:** Confirm 60-hour/month budget by tomorrow 9 AM
- [ ] **CTMO:** Confirm tracking infrastructure by tomorrow 3 PM
- [ ] **COO:** Confirm effort tracking method by tomorrow 3 PM
- [ ] **CFO:** All documents deployed and reviewed by tomorrow 5 PM

**If any dependency missing:** Fallback to manual tracking + weekly gate reviews (less automated, but workable)

---

## SIGN-OFF

- [ ] **CFO:** Ready to deploy daily tracking by April 1
- [ ] **CEO:** Ready to commit to 60-hour/month effort cap
- [ ] **CTMO:** Ready to support tracking infrastructure
- [ ] **COO:** Ready to execute weekly gate reviews

**Deployment Status:** Ready (pending confirmations)
**Target Go-Live:** 2026-04-01 09:00 AM
**First Gate Review:** 2026-04-07 18:00 (Friday evening)

---

**This checklist is your playbook for deploying the sensitivity dashboard. Treat it as a living document — update as you go, mark items as complete, adjust timelines based on real progress.**

**Questions? Escalate to CEO. Blockers? Document in CFO inbox.**

