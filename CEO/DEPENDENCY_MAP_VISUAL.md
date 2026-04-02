# ExsituInnovations — Visual Dependency Map & Failure Cascade

**Purpose:** Quick visual reference for understanding how failures propagate
**Audience:** CEO + Board (standups, decision gates)
**Updated:** 2026-03-29

---

## MASTER DEPENDENCY DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         RECOVERY GOAL: $10K                             │
│                      (by August 2026, ~5 months)                        │
└──────────────────────────────────────┬──────────────────────────────────┘
                                       │
                    ┌──────────────────┴──────────────────┐
                    │   FOUNDER'S EFFORT & CAPACITY       │
                    │   (60+ hrs/week = BURNOUT ZONE)    │
                    └──────────────────┬──────────────────┘
                                       │
                 ┌─────────────────────┼─────────────────────┐
                 │                     │                     │
         ┌───────▼────────┐    ┌───────▼────────┐    ┌───────▼────────┐
         │  P1: DIGITAL   │    │  P2: AFFILIATE │    │  P3: POD + N8N │
         │  PRODUCTS      │    │  BLOG          │    │  TEMPLATES     │
         │ (Gumroad)      │    │ (WordPress)    │    │ (Redbubble)    │
         └───────┬────────┘    └───────┬────────┘    └───────┬────────┘
                 │                     │                     │
       ┌─────────┼─────────┐   ┌───────┼────────┐    ┌──────┼───────┐
       │         │         │   │       │        │    │      │       │
   PRODUCTS   PRICING  SEEDING TRAFFIC  EMAIL  AFFI  DESIGN QUALITY PACKAG
   QUALITY              LIST  SIGNUP  NETWORKS
       │         │         │   │       │        │    │      │       │
       ▼         ▼         ▼   ▼       ▼        ▼    ▼      ▼       ▼
    ╔═══╗   ╔═══╗   ╔═══╗ ╔══╗╔═══╗ ╔═══╗   ╔═╗ ╔════╗ ╔═══╗
    ║ ✓ ║   ║ ? ║   ║ ? ║ ║ X║║ ? ║ ║ ? ║   ║?║ ║ ?  ║ ║ ? ║
    ╚═══╝   ╚═══╝   ╚═══╝ ╚══╝╚═══╝ ╚═══╝   ╚═╝ ╚════╝ ╚═══╝
    TESTED  ASSUME ASSUME UNKNOWN UNKNOWN UNKNOWN ASSUMED UNKNOWN

                             │         │         │
                    ┌────────┴────┬────┴────┬────┴────────┐
                    │             │         │             │
                    ▼             ▼         ▼             ▼
            ┌──────────────┐ ┌───────┐ ┌─────────┐ ┌────────────┐
            │ REVENUE      │ │ EMAIL │ │ TRAFFIC │ │ CONVERSION │
            │ COLLECTION   │ │ DELIVERY
            │ (Stripe)     │ │       │ │         │ │ (QUALITY)  │
            └──────────────┘ └───────┘ └─────────┘ └────────────┘
                    │             │         │             │
                    └─────────────┴─────────┴─────────────┘
                                  │
                          ┌───────▼───────┐
                          │   CFO VIEW:   │
                          │ REVENUE DATA  │
                          │ (PostgreSQL)  │
                          └───────┬───────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              ┌─────▼─────┐          ┌──────────▼──────┐
              │ MONTH 1   │          │ MONTH 2-3       │
              │ $200-350  │          │ $500-1,200      │
              │ (GO/NO-GO)│          │ (SCALE GATE)    │
              └───────────┘          └─────────────────┘
```

---

## SINGLE POINTS OF FAILURE (CRITICAL PATH)

### Failure Cascade Chain

```
                        FOUNDER CAPACITY
                        (Jason 60+ hrs/week)
                               │
                               │ (burnout)
                               ▼
                    ┌──────────────────────┐
                    │  ALL 3 STREAMS FAIL  │
                    │ (-100% revenue)      │
                    │ By Week 3-4          │
                    └──────────────────────┘

        GUMROAD ACCOUNT BAN               STRIPE SUSPENDED
                │                                │
                ▼                                ▼
        ┌──────────────────┐         ┌─────────────────────┐
        │ P1 FAILS (-30%)  │         │ NO REVENUE COLLECTION│
        │ Recovery: 2-3 days          Recovery: 24-48 hours
        │ Fallback: SendOwl│         │ Fallback: Square
        │ Revenue loss: $200          Revenue loss: $500-1K
        └──────────────────┘         └─────────────────────┘

        REDBUBBLE REJECTS            EMAIL SPAM ISSUES
        DESIGNS                              │
                │                           ▼
                ▼                  ┌──────────────────────┐
        ┌──────────────────┐       │ P2 FAILS (-50%)      │
        │ P3 FAILS (-40%)  │       │ Recovery: 1 week
        │ Recovery: 1-2 days       │ Fallback: Substack
        │ Fallback: Printful       │ Revenue loss: $100
        │ Revenue loss: $50
        └──────────────────┘

        LOW ATC RATE (<0.5%)       AFFILIATE NETWORKS BAN
                │                           │
                ▼                           ▼
        ┌──────────────────┐       ┌──────────────────────┐
        │ P1 FAILS (-30%)  │       │ P2 FAILS (-50%)      │
        │ Recovery: 7 days │       │ Recovery: 3 days
        │ Pivot niche      │       │ Fallback: 5 alt networks
        │ Revenue loss: $0 │       │ Revenue loss: $100-200
        └──────────────────┘       └──────────────────────┘
```

---

## DEPENDENCY MATRIX: Who Breaks If What Fails?

```
┌─────────────────────┬──────────┬──────────┬──────────┬──────────────┐
│ FAILURE EVENT       │ P1 IMPACT│ P2 IMPACT│ P3 IMPACT│ TOTAL RISK   │
├─────────────────────┼──────────┼──────────┼──────────┼──────────────┤
│ Gumroad banned      │ -100%    │ NONE     │ NONE     │ -30% overall │
│ Stripe suspended    │ BLOCKED  │ BLOCKED  │ BLOCKED  │ -100%        │
│ Redbubble rejects   │ NONE     │ NONE     │ -100%    │ -20% overall │
│ Affiliate nets ban   │ NONE     │ -100%    │ NONE     │ -25% overall │
│ Founder burns out   │ -80%     │ -80%     │ -80%     │ -80% overall │
│ Email spam issues   │ NONE     │ -50%     │ NONE     │ -12% overall │
│ Content quality low │ -50%     │ -30%     │ -50%     │ -45% overall │
│ Low ATC (<0.5%)     │ -100%    │ NONE     │ NONE     │ -30% overall │
│ Niche saturated     │ -100%    │ -100%    │ -80%     │ -95% overall │
│ Pricing wrong       │ -40%     │ NONE     │ NONE     │ -12% overall │
│ Poor design quality │ NONE     │ NONE     │ -80%     │ -20% overall │
│ No email signups    │ NONE     │ -50%     │ NONE     │ -12% overall │
└─────────────────────┴──────────┴──────────┴──────────┴──────────────┘

Legend:
-100%  = Stream completely fails
-50%   = Stream loses half revenue
-30%   = Stream loses 30% revenue
BLOCKED = Revenue cannot be collected (platform failure)
NONE   = No direct impact
```

---

## FAILURE PROBABILITY & IMPACT HEATMAP

```
                    PROBABILITY (Likelihood)
                Low (5%)        Medium (20%)      High (40%+)
         ┌─────────────────┬─────────────────┬─────────────────┐
    HIGH │ Stripe banned   │ Low ATC rate    │ Founder burnout │ ← CRITICAL
  IMPACT │ (-100%, hard)   │ (-30%)          │ (-80%)          │   WATCH
  (80%+) │ [Contingency]   │ [A/B test]      │ [DESCOPE NOW]   │
         ├─────────────────┼─────────────────┼─────────────────┤
   MED   │ Gumroad banned  │ Email spam      │ Niche saturated │
  IMPACT │ (-30%)          │ (-12%)          │ (-95%)          │
  (30-50)│ [Switch to      │ [Try Substack]  │ [Pivot Week 5]  │
         │  SendOwl]       │                 │                 │
         ├─────────────────┼─────────────────┼─────────────────┤
    LOW  │ Affiliate ban   │ No email list   │ Pricing wrong   │
  IMPACT │ (-25%)          │ (-12%)          │ (-12%)          │
  (<30%) │ [5 alt networks]│ [Improve CTA]   │ [Lower price]   │
         └─────────────────┴─────────────────┴─────────────────┘

DANGER ZONE (Red): High Impact + High Probability = Watch weekly
CAUTION ZONE (Yellow): Medium Impact OR Medium Probability = Prepare fallback
WATCH ZONE (Green): Low Impact OR Low Probability = Monitor but low priority
```

---

## CONTINGENCY ACTIVATION FLOWCHART

```
                    DAILY RED FLAG DETECTED
                              │
                              ▼
                 ┌────────────────────────┐
                 │ What failed?           │
                 └────────────────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
            ▼                 ▼                 ▼
      PLATFORM FAILURE  CONTENT FAILURE   CAPACITY FAILURE
      (Stripe, Gumroad) (Low ATC, Spam)   (Burnout)
            │                 │                 │
    ┌───────┴────────┐  ┌──────┴──────┐  ┌─────┴──────┐
    │                │  │             │  │            │
    ▼                ▼  ▼             ▼  ▼            ▼
 IMMEDIATE        WITHIN         SAME         THIS WEEK   WITHIN
 SWITCH-OVER      24 HOURS       WEEK                     2 WEEKS
 (backup active)  (diagnose      (test)                   (hire/descope)
 ← DO NOW          & fix)

Example:          Example:        Example:     Example:
Stripe ban        Low ATC         Email spam   Burnout
↓                 ↓               ↓            ↓
Square live       A/B test        Substack     Descope P2
in 2 hours        lower price     1-week trial Hire writer

Gumroad ban       Niche pivot
↓                 ↓
SendOwl live      New copy
in 4 hours        Week 5
```

---

## WEEK-BY-WEEK FAILURE RISK PROFILE

```
                    Weeks 1-2 (Launch)       Weeks 3-4 (Validation)
┌────────────────────────────────────────────────────────────────┐
│ HIGHEST RISK:                        │ HIGHEST RISK:           │
│ • Platform rejects (accts banned)    │ • Founder burnout       │
│ • Content quality issues             │ • Niche doesn't validate│
│ • Pricing wrong                      │ • Email list stalls     │
│ • Seeding fails (traffic = 0)        │ • Affiliate approval    │
│                                       │                         │
│ CONTINGENCY SPEED: 24-48 hours       │ CONTINGENCY SPEED: 3-7 days
│ IMPACT IF FAIL: -30% to -50%         │ IMPACT IF FAIL: -50% to -80%
│ DECISION: Fix or pivot?              │ DECISION: Continue or descope?
└────────────────────────────────────────────────────────────────┘

                    Weeks 5-8 (Scaling)      Weeks 9-13 (Sustain)
┌────────────────────────────────────────────────────────────────┐
│ HIGHEST RISK:                        │ HIGHEST RISK:           │
│ • Hiring wrong person (P2 writer)    │ • Platform rate hikes   │
│ • Overcommitment (too many projects) │ • Market saturation     │
│ • Budget overrun (Tier 2 burn)       │ • Affiliate compression │
│                                       │ • Competition emerges   │
│ CONTINGENCY SPEED: 1-2 weeks         │ CONTINGENCY SPEED: 2-4 weeks
│ IMPACT IF FAIL: -20% to -40%         │ IMPACT IF FAIL: -15% to -30%
│ DECISION: Scale or hold?             │ DECISION: Pivot or double down?
└────────────────────────────────────────────────────────────────┘
```

---

## REVENUE VARIANCE IMPACT TREE

```
TARGET: $200-350 by Day 30

If ACTUAL is <$100 (MISS by 50%+):
├─ P1 underperforms? (<$40)
│  ├─ Low ATC? (<0.5%) → Niche or pricing issue
│  │  └─ Fix: A/B test lower price ($14.99)
│  │  └─ OR pivot niche (if both fail)
│  │
│  └─ Low traffic? (<50 views) → Seeding failed
│     └─ Fix: Add Reddit/Twitter seeding
│
├─ P2 underperforms? ($0)
│  ├─ 0 impressions? → Normal (GSC needs 3-5 days)
│  │  └─ Fix: Manual traffic seeding (Reddit, Twitter)
│  │
│  ├─ Impressions but 0 signups? → CTA/lead magnet issue
│  │  └─ Fix: Improve CTA, test free PDF checklist
│  │
│  └─ Affiliate rejections? → Multiple networks failing
│     └─ Fix: Switch to 5 backup networks
│
└─ P3 underperforms? (<$15)
   ├─ Designs rejected? → Moderation issues
   │  └─ Fix: Switch to Printful (different moderation)
   │
   └─ Designs live but no sales? → Marketing/visibility
      └─ Fix: More designs (quantity = visibility in algorithm)

If ACTUAL is $100-200 (MISS by 25-50%):
├─ Acceptable variance (one stream lagging is OK)
├─ Action: Identify laggard, accelerate that stream
└─ No descope needed, but watch for Week 4

If ACTUAL is >$200 (ON TRACK or BEATING):
├─ GO decision at Day 30 ✓
├─ Proceed to Phase 1B (full acceleration)
└─ Unlock Tier 1.5 budget ($20-30/mo)
```

---

## DECISION GATE DECISION TREE (Day 30)

```
                    ACTUAL REVENUE BY DAY 30
                              │
                ┌─────────────┼─────────────┐
                │             │             │
              <$100         $100-200      >$200
            (MISS 70%)    (MISS 25-50%)   (HIT or BEAT)
                │             │             │
                ▼             ▼             ▼
            ┌─────────┐  ┌──────────┐  ┌──────────┐
            │ NO-GO   │  │CONDITIONAL│  │   GO     │
            │SCENARIO │  │SCENARIO   │  │SCENARIO  │
            │  3      │  │    2      │  │    1     │
            └────┬────┘  └─────┬─────┘  └────┬─────┘
                 │             │             │
           ┌─────▼──────┐ ┌────▼────────┐ ┌─▼──────────┐
           │ ANALYZE    │ │ IDENTIFY    │ │ FULL       │
           │ Root cause │ │ LAGGARD     │ │ ACCEL      │
           │            │ │ STREAM      │ │            │
           │ Options:   │ │             │ │ • Unlock   │
           │ 1. Fix by  │ │ Options:    │ │   Tier 1.5 │
           │    Week 5  │ │ 1. Keep all │ │ • Approve  │
           │ 2. Pivot   │ │    3, focus │ │   hiring   │
           │    new     │ │    on best  │ │ • Scale    │
           │    niche   │ │ 2. Descope  │ │   to 3     │
           │ 3. Give up │ │    worst    │ │   streams  │
           │            │ │ 3. Pivot    │ │            │
           └────────────┘ │    niche    │ └────────────┘
                           └─────┬─────┘
                                 │
                      ┌──────────▼──────────┐
                      │ Decision by CEO     │
                      │ (within 4 hours)    │
                      └─────────┬───────────┘
                                │
                      ┌─────────▼──────────┐
                      │ Document decision  │
                      │ in board/decisions │
                      └────────────────────┘
```

---

## BURNOUT ESCALATION FLOWCHART

```
DAILY STANDUP CHECKS:
├─ Completed planned tasks? Y/N
├─ Missed deadlines? Y/N
├─ Hours worked: <40 / 40-50 / >50
└─ Stress level: 1-10 (target: <6)

            ┌──────────────────────┐
            │ ANY RED SIGNALS?      │
            │ (Missed tasks, >50hrs)│
            └──────┬───────────────┘
                   │
            ┌──────▼──────────┐
            │ DAY 2 CHECK      │
            │ Still red?       │
            └──────┬───────────┘
            YES    │    NO
            │      └──→ Continue watching
            │
    ┌───────▼──────────┐
    │ DAY 3 CHECK      │
    │ Still red?       │
    └───────┬──────────┘
    YES     │    NO
    │       └──→ Continue watching
    │
    └───────▼────────────────────────┐
            │                        │
            ▼                        ▼
    ┌──────────────────┐  ┌──────────────────┐
    │ ESCALATE TO CEO  │  │ Keep monitoring  │
    │ IMMEDIATELY      │  │ (watch if recurs)│
    │                  │  └──────────────────┘
    │ • Show burnout   │
    │   checklist      │
    │ • Recommend      │
    │   options:       │
    │   - Descope P2   │
    │   - Hire writer  │
    │   - Hire designer│
    │ • CEO decides    │
    │   within 4 hours │
    └──────┬───────────┘
           │
      ┌────▼───────┬──────────┬──────────┐
      ▼            ▼          ▼          ▼
   DESCOPE P2   HIRE WRITER HIRE        HOLD
   (Week 3)     (Week 4)    DESIGNER    (continue
   Pause        Cost: $400- (Week 4)    watching)
   articles     800/mo      Cost: $400-
   Revenue:     Revenue:    800/mo
   -$0          +$100-300   Revenue:
   Hours:       Hours:      +$100-300
   -15          -20         Hours:

OUTCOME: Back to <45 hrs/week + on-time deliverables within 1 week
```

---

## PLATFORM FAILURE RECOVERY MATRIX

```
IF THIS FAILS:          SWITCH TO:           TIME:   REVENUE LOSS:
─────────────────────────────────────────────────────────────────
Gumroad banned          SendOwl or Podia     4-6h    $200-500
Stripe suspended        Square or 2Checkout  2-4h    $500-1K
Redbubble rejects       Printful or Merch    6-8h    $50-100
Affiliate network 1     5 backup networks    1-2h    $100-300
WordPress goes down     Substack or Medium   4-6h    $0-50
Email delivery spam     Substack free tier   2-4h    $0-100
N8N workflow breaks     Manual CSV import    1-2h    $0 (data safe)
Google Analytics down   Alt tracker (Plausible 30m   $0 (metrics only)

TOTAL RECOVERY TIME BUDGET: 24-48 hours maximum
EXPECTED: Revenue gap of 1-3 days, then resume
SUCCESS METRIC: >50% of pre-failure sales within 3 days
```

---

## FINAL VISUAL: COMPOUND RISK DASHBOARD

```
WEEK 1-2 RISK LEVEL: ████░░░░░░ (40%) — MANAGEABLE
  └─ Watch for: Platform rejections, seeding fails, content quality
  └─ Contingencies: Pre-built (SendOwl, alt niches, design templates)

WEEK 3-4 RISK LEVEL: ██████░░░░ (60%) — ELEVATED
  └─ Watch for: Burnout, niche validation, email list stall
  └─ Contingencies: Ready to descope P2 or hire writer

WEEK 5-8 RISK LEVEL: ████░░░░░░ (40%) — MODERATE
  └─ Watch for: Hiring mistakes, overscaling, budget overrun
  └─ Contingencies: Scale gradually, monitor costs weekly

WEEK 9-13 RISK LEVEL: ██░░░░░░░░ (20%) — LOW
  └─ Watch for: Market saturation, affiliate compression
  └─ Contingencies: Prepare Phase 2 pivot or new niches

────────────────────────────────────────────────────────────────
OVERALL RECOVERY CONFIDENCE: 85% (High)
  └─ IF all contingencies pre-built and monitored
  └─ IF CEO makes quick decisions (within 24h of red flags)
  └─ IF founder stays <50 hours/week (no burnout spiral)
```

---

## KEY TAKEAWAY: One-Pager

```
╔═══════════════════════════════════════════════════════════════╗
║           EXSITU INNOVATIONS RISK MANAGEMENT SUMMARY           ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║ FAILURE POINTS (Rank by Risk):                               ║
║ 🔴 P1: Burnout (founder 60+ hrs/week) — HIGH PROBABILITY    ║
║ 🟡 P2: Niche Saturation (all 3 streams fail) — LOW PROB      ║
║ 🟡 P3: Platform bans (Gumroad, Stripe, Redbubble) — LOW     ║
║ 🟢 P4: Content quality collapse — MEDIUM                     ║
║ 🟢 P5: Email deliverability — LOW                           ║
║                                                               ║
║ CONTINGENCY STATUS:                                          ║
║ ✓ Backup platforms created (SendOwl, Podia, Printful)      ║
║ ✓ Payment processors ready (Square, 2Checkout)              ║
║ ✓ Alternative niches researched (2 backups)                 ║
║ ✓ Hiring budget authorized (Tier 1.5 at Day 30)            ║
║ ✓ Burnout protocol in place (weekly checklist)              ║
║ ✓ Manual fallbacks ready (spreadsheet, data backup)         ║
║                                                               ║
║ CEO DECISION GATES:                                          ║
║ Day 30: Go/No-Go (revenue >$200?)                           ║
║ Day 45: Hire decision (P2 writer if revenue validates)       ║
║ Day 60: Scale decision (full acceleration or extend Phase 1?)║
║ Day 90: Phase 2 approval ($1,100+ cumulative revenue?)       ║
║                                                               ║
║ RED FLAG MONITORING:                                         ║
║ • Daily: Founder hours, revenue dashboard, platform status  ║
║ • Weekly: Risk assessment table (CEO + CFO), burnout check  ║
║ • Gate days: Full analysis vs. forecast, decision needed    ║
║                                                               ║
║ SUCCESS RATE: 85% (if contingencies ready + CEO decides fast)║
║ RECOVERY TARGET: $10K by early August 2026                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

**Document Status:** ✓ Ready for Board Review
**Last Updated:** 2026-03-29
**Next Review:** Day 30 (Apr 26) + weekly standups

For detailed playbooks, see: `DEPENDENCY_AND_FAILURE_ANALYSIS.md`
For decision framework, see: `roadmap_90day_executive_brief.md`
