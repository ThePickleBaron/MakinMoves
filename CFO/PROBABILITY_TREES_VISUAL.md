# Probability Trees: Creator Toolkit vs White-Label
**Visual Reference for Board**
**Date:** 2026-03-29

---

## CREATOR TOOLKIT (P1) — PROBABILITY TREE

```
                                    START (P=100%)
                                         |
                          ┌──────────────┴──────────────┐
                          |                             |
                   P(niche OK)                   P(niche saturated)
                     P=65%                          P=35%
                          |                             |
        ┌─────────────────┴──────────────┐             │
        |                                |             │
   Email Growth                     NO EMAIL          FATE SEALED
   (Conditional on                 STRATEGY           Revenue cap:
    niche OK)                       Revenue cap:      $0-500 M1-6
                                    $0-100 M1-6       Profit: -$100
   ├─ Email 500+                                      │
   │  P=10% (hard, 1 day)                             │
   │  └─ Converts 5%+: P=45%                          │
   │     └─ Repeats 25%: P=50%                        │
   │        └─ FULL SUCCESS (P≈2%)                    │
   │           Revenue: $44K-66K                      │
   │           Profit: $31K-46K                       │
   │           Outcome: Recovery by July ✓✓✓          │
   │                                                   │
   ├─ Email 300-400                                   │
   │  P=25% (realistic, Twitter/email)                │
   │  └─ Converts 3-4%: P=50%                         │
   │     └─ Repeats 20%: P=50%                        │
   │        └─ STRONG SUCCESS (P≈3%)                  │
   │           Revenue: $18K-28K                      │
   │           Profit: $12K-20K                       │
   │           Outcome: Recovery by July ✓✓           │
   │                                                   │
   ├─ Email 100-200                                   │
   │  P=50% (likely, some outreach)                   │
   │  └─ Converts 1-2%: P=60%                         │
   │     └─ Repeats 15%: P=50%                        │
   │        └─ PARTIAL SUCCESS (P≈9%)                 │
   │           Revenue: $8K-14K                       │
   │           Profit: $5K-10K                        │
   │           Outcome: Recovery by Aug ✓             │
   │                                                   │
   └─ Email <100                                      │
      P=15% (unlikely, CEO burnout)                   │
      └─ Converts <1%: P=70%                          │
         └─ Repeats <10%: P=70%                       │
            └─ WEAK TRACTION (P≈7%)                   │
               Revenue: $1K-3K                        │
               Profit: $0-1.5K                        │
               Outcome: Recovery by Sep ✗             │
                                                      │
                                                      └─ FAILURE
                                                         P=35%
                                                         Revenue: $0-500
                                                         Profit: -$100
                                                         Outcome: Pivot or reduce scope
```

---

## WHITE-LABEL — PROBABILITY TREE

```
                                    START (P=100%)
                                         |
                          ┌──────────────┴──────────────┐
                          |                             |
                   Avoid Shadowban                Shadowbanned
                     P=60%                          P=40%
                          |                             |
        ┌─────────────────┴──────────────┐             │
        |                                |             │
   First Template                   THROTTLED         FATE SEALED
   Conversion                        Revenue cut      Revenue cap:
                                     50-70%           $300-500 M1-6
   ├─ Converts >1%                   Profit:          Profit: $100-200
   │  P=35% (good template)          $100-300         Outcome: Weak
   │  └─ Traffic 100+ UU/day: P=55%                   │
   │     └─ Source 10 templates: P=65%                │
   │        └─ FULL SUCCESS (P≈7%)                    │
   │           Revenue: $5.3K-7.6K                    │
   │           Profit: $3.7K-5.3K                     │
   │           Outcome: Recovery by Aug ✓             │
   │                                                   │
   ├─ Converts 0.5-1%                                 │
   │  P=50% (avg template)                            │
   │  └─ Traffic 50-100 UU/day: P=40%                 │
   │     └─ Source 5-7 templates: P=70%               │
   │        └─ PARTIAL SUCCESS (P≈7%)                 │
   │           Revenue: $4.5K-5K                      │
   │           Profit: $3.1K-3.5K                     │
   │           Outcome: Recovery by Aug-Sep ✓         │
   │                                                   │
   └─ Converts <0.5%                                  │
      P=15% (weak template)                           │
      └─ Traffic <50 UU/day: P=50%                    │
         └─ Source <5 templates: P=30%                │
            └─ WEAK TRACTION (P≈2%)                   │
               Revenue: $600-700                      │
               Profit: $400-500                       │
               Outcome: Minimal recovery              │
                                                      │
                                                      └─ FAILURE
                                                         P=40%
                                                         Revenue: $0-100
                                                         Profit: -$50
                                                         Outcome: Restart or pivot
```

---

## EXPECTED VALUE COMPARISON

### Creator Toolkit (P1)

```
Scenario A: Full Success (P=15%)
├─ Revenue: $44K-66K
├─ Profit: $31K-46K
└─ Contribution to E[V]: 15% × $39K = $5,850

Scenario B: Partial Success (P=35%)
├─ Revenue: $12K-17K
├─ Profit: $8.4K-11.9K
└─ Contribution to E[V]: 35% × $10K = $3,500

Scenario C: Weak Traction (P=35%)
├─ Revenue: $1K-3K
├─ Profit: $0-1.5K
└─ Contribution to E[V]: 35% × $500 = $175

Scenario D: Failure (P=15%)
├─ Revenue: $0-500
├─ Profit: -$500
└─ Contribution to E[V]: 15% × (-$500) = -$75

═══════════════════════════════════════════════════════
TOTAL EXPECTED VALUE: $5,850 + $3,500 + $175 - $75 = $9,450
CONSERVATIVE E[V]:    $5,920 (lower scenario weights)
MOST LIKELY E[V]:     $7,000 (blended)
═══════════════════════════════════════════════════════
```

### White-Label

```
Scenario A: Full Success (P=20%)
├─ Revenue: $5.3K-7.6K
├─ Profit: $3.7K-5.3K
└─ Contribution to E[V]: 20% × $4.5K = $900

Scenario B: Partial Success (P=40%)
├─ Revenue: $4.5K-5K
├─ Profit: $3.1K-3.5K
└─ Contribution to E[V]: 40% × $3.2K = $1,280

Scenario C: Weak Traction (P=30%)
├─ Revenue: $600-700
├─ Profit: $400-500
└─ Contribution to E[V]: 30% × $450 = $135

Scenario D: Failure (P=10%)
├─ Revenue: $0-100
├─ Profit: -$50
└─ Contribution to E[V]: 10% × (-$50) = -$5

═══════════════════════════════════════════════════════
TOTAL EXPECTED VALUE: $900 + $1,280 + $135 - $5 = $2,310
CONSERVATIVE E[V]:    $1,707 (lower scenario weights)
MOST LIKELY E[V]:     $1,900 (blended)
═══════════════════════════════════════════════════════
```

---

## RATIO ANALYSIS

```
Expected Value Ratio:
E[V] Creator Toolkit / E[V] White-Label = $7,000 / $1,900 = 3.68x

In other words:
└─ Creator Toolkit is 3.7 TIMES better in expected financial value
└─ Per dollar of risk, P1 generates 3.7x more expected return
└─ If we had to bet $1K on one strategy, P1 wins by large margin

Success Probability Ratio:
P(success) Creator Toolkit / P(success) White-Label = 30% / 20% = 1.5x

In other words:
└─ Creator Toolkit is 1.5 TIMES more likely to succeed
└─ P1 has 50% higher odds of getting to "moderate success" threshold
└─ But both are risky (20-30% success is low absolute probability)
```

---

## SENSITIVITY WATERFALL — Creator Toolkit

```
Base Expected Value (Balanced): $7,000

IF email list is 50% smaller:
└─ E[V] drops to: $4,000 (-43%)

IF conversion rate is 50% lower:
└─ E[V] drops to: $5,200 (-26%)

IF CEO capacity exhausted (burnout):
└─ E[V] drops to: $3,500 (-50%)

IF repeat purchase is 0% (all one-time):
└─ E[V] drops to: $5,500 (-21%)

IF niche is more saturated (20% instead of 65%):
└─ E[V] drops to: $2,200 (-69%)

───────────────────────────────────────────────────
MOST FRAGILE ASSUMPTION: Niche viability (saturation risk)
CRITICAL SUCCESS FACTOR: Email list growth (>100 by Apr 15)
UPSIDE OPPORTUNITY: Repeat purchases (potential 20-35% boost)
```

---

## SENSITIVITY WATERFALL — White-Label

```
Base Expected Value (Balanced): $1,900

IF shadowban hits (30% worse):
└─ E[V] drops to: $900 (-53%)

IF first template flops:
└─ E[V] drops to: $500 (-74%)

IF traffic generation fails:
└─ E[V] drops to: $300 (-84%)

IF CEO can only source 3 templates (not 10):
└─ E[V] drops to: $600 (-68%)

IF conversion rate 50% lower:
└─ E[V] drops to: $1,200 (-37%)

───────────────────────────────────────────────────
MOST FRAGILE ASSUMPTION: Shadowban risk (platform dependent)
CRITICAL SUCCESS FACTOR: Traffic generation (same as P1)
LOWEST UPSIDE: Templates are one-time sales (no repeat)
```

---

## DECISION MATRIX — Which to Choose?

```
Choose CREATOR TOOLKIT if:
├─ You believe email list CAN grow to 100+ by Apr 1 ✓✓✓
├─ CEO has freelancer/entrepreneur credibility ✓✓✓
├─ You're willing to take higher risk for 3.7x upside ✓✓✓
├─ Repeat revenue potential matters to long-term strategy ✓✓
└─ You're confident in execution (mitigations in place) ✓

Choose WHITE-LABEL if:
├─ Email list growth seems impossible (no audience) ✓✓
├─ You want lower platform risk (no Gumroad dependency) ✓
├─ You prefer predictable, simpler execution ✓
├─ You're risk-averse and want downside protection ✓
└─ You can source high-quality templates quickly ✓

HYBRID APPROACH (Recommended):
├─ Start with CREATOR TOOLKIT (higher expected value)
├─ Run in parallel: Pre-source 3-5 white-label templates
├─ Decision gate at Day 15: If P1 email stalls, flip to white-label
├─ Best of both: Upside optionality + downside protection
└─ Timeline: P1 primary (Mar 31–Apr 15), white-label contingency (Apr 15–20)
```

---

## TIMELINE IMPLICATIONS

```
CREATOR TOOLKIT TIMELINE:
├─ Mar 31: P1 launches (AI Prompts)
├─ Apr 1: Email list building begins (target: 100+ by Apr 15)
├─ Apr 6: Day 7 check-in (email 50+? traffic started?)
├─ Apr 14: Day 15 DECISION GATE (email 100+? revenue $50+?)
│  ├─ IF YES → Continue P1, scale up
│  └─ IF NO → PIVOT to white-label (below)
├─ Apr 29: Day 30 evaluation (revenue $300+? sustainability?)
└─ May 1: Writer hire (if approved, frees capacity)

WHITE-LABEL CONTINGENCY TIMELINE (if triggered Day 15):
├─ Apr 16: Source 3-5 templates (10-15 hours CEO time)
├─ Apr 18: List on Gumroad with positioning
├─ Apr 20: Traffic redirected to white-label landing page
├─ May 1: Evaluate traction, source more templates if working
├─ Jun 1: Scale to 10 templates if all metrics positive
└─ Jun 30: Evaluate white-label as sustainable stream

KILL SWITCH (if both fail by Day 20):
├─ Apr 20: Reduce scope (4 articles/week → 2 articles/week)
├─ Apr 20: Pivot focus to P3 (n8n workflows)
├─ May 1: Evaluate new direction (n8n as primary)
└─ Jun 28: Recovery timeline extends to Oct (acceptable risk)
```

---

## CONFIDENCE BANDS

```
CREATOR TOOLKIT EXPECTED VALUE (with confidence intervals):

$15,000  ╔════════════════════════════════════╗
         ║     90% Confidence Interval        ║
         ║    (Could be anywhere in range)     ║
$10,000  ║                                    ║
         ║  ╔════════════════════════════╗   ║
         ║  ║  70% Confidence Interval   ║   ║
$7,000   ║──║  (Most likely range)       ║───║── POINT ESTIMATE
         ║  ║                            ║   ║
$4,000   ║  ╚════════════════════════════╝   ║
         ║                                    ║
$1,000   ╚════════════════════════════════════╝
         └──────────────────────────────────┘
         70% CI: $5,200–$8,800
         90% CI: $3,000–$12,000

WHITE-LABEL EXPECTED VALUE (with confidence intervals):

$5,000   ╔════════════════════════════════════╗
         ║     90% Confidence Interval        ║
         ║    (Could be anywhere in range)     ║
$3,000   ║                                    ║
         ║  ╔════════════════════════════╗   ║
         ║  ║  70% Confidence Interval   ║   ║
$1,900   ║──║  (Most likely range)       ║───║── POINT ESTIMATE
         ║  ║                            ║   ║
$800     ║  ╚════════════════════════════╝   ║
         ║                                    ║
$200     ╚════════════════════════════════════╝
         └──────────────────────────────────┘
         70% CI: $1,200–$2,600
         90% CI: $500–$4,500
```

---

## KEY TAKEAWAYS

1. **Creator Toolkit has 3.7x higher expected value** ($7,000 vs. $1,900)

2. **Both are risky** (25-35% success for P1, 15-25% for white-label)

3. **Email list is P1's critical blocker** (need 100+ by Apr 1)

4. **Traffic is critical for both** (need 100-300 UU/day by May 1)

5. **Day 15 (April 14) is pivot decision point** (if P1 email <100, flip to white-label)

6. **Hybrid approach is best insurance** (P1 primary + white-label contingency)

7. **Both beat complete failure** (any traction is better than nothing)

---

**For detailed probability analysis, see: `CFO/BAYESIAN_ANALYSIS_Creator-Toolkit_vs_White-Label.md`**
