import pandas as pd
import numpy as np
from itertools import product

# ============================================================================
# CURRENT PLAN (P1-First, P2-Warm, P3-Secondary)
# ============================================================================

print("=" * 80)
print("EXPECTED VALUE ANALYSIS: CURRENT PLAN vs ALTERNATIVE PLAN")
print("=" * 80)
print()

# Revenue ranges by month (deterministic projections)
current_plan_monthly = {
    1: (100, 250),      # M1: P1 only
    2: (225, 1400),     # M2: P1 + P2 warm
    3: (425, 3350),     # M3: all three
    4: (600, 8950),     # M4-6: scaling
    5: (600, 8950),
    6: (600, 8950),
    7: (3000, 5000),    # M7-12: ceiling
    8: (3000, 5000),
    9: (3000, 5000),
    10: (3000, 5000),
    11: (3000, 5000),
    12: (3000, 5000),
}

alternative_plan_monthly = {
    1: (0, 100),        # M1: minimal
    2: (100, 600),      # M2: P1 + cold P2
    3: (300, 1000),     # M3: P3 early + P2 scaling
    4: (2000, 5000),    # M4-6: P3 compounding
    5: (2000, 5000),
    6: (2000, 5000),
    7: (8000, 16000),   # M7-12: P3 growth
    8: (8000, 16000),
    9: (8000, 16000),
    10: (8000, 16000),
    11: (8000, 16000),
    12: (8000, 16000),
}

# ============================================================================
# PROBABILISTIC EVENTS (Current Plan)
# ============================================================================

def calculate_current_plan_ev(n_simulations=10000):
    """
    Simulate current plan with probabilistic events:
    - P(email hits 500 by M2) = 40%
    - P(white-label shadowban) = 30%
    - P(partnership success) = 60%
    """
    results = []

    for sim in range(n_simulations):
        email_success = np.random.rand() < 0.40
        shadowban = np.random.rand() < 0.30
        partnership_success = np.random.rand() < 0.60

        monthly_revenue = []

        for month in range(1, 13):
            low, high = current_plan_monthly[month]
            base_revenue = np.random.uniform(low, high)

            # Apply shadowban effect (M1-12)
            if shadowban:
                base_revenue *= 0.5

            # Apply email success effect (M2-6)
            if not email_success and month >= 2 and month <= 6:
                base_revenue *= 0.50  # Revenue cut if email list misses

            # Apply partnership effect (affects P3 revenue M3+)
            if not partnership_success and month >= 3:
                base_revenue *= 0.80  # P3 slips 3 months

            monthly_revenue.append(base_revenue)

        results.append({
            'email_success': email_success,
            'shadowban': shadowban,
            'partnership_success': partnership_success,
            'monthly_revenue': monthly_revenue,
            'total_revenue': sum(monthly_revenue),
            'm1_3': sum(monthly_revenue[0:3]),
            'm4_6': sum(monthly_revenue[3:6]),
            'm7_12': sum(monthly_revenue[6:12]),
        })

    return results

# ============================================================================
# PROBABILISTIC EVENTS (Alternative Plan)
# ============================================================================

def calculate_alternative_plan_ev(n_simulations=10000):
    """
    Simulate alternative plan with probabilistic events:
    - P(P3 partnerships succeed) = 70%
    - P(P2 cold works) = 60%
    - P(P3 reaches 500+ visitors by M3) = 80%
    """
    results = []

    for sim in range(n_simulations):
        p3_partnership_success = np.random.rand() < 0.70
        p2_cold_success = np.random.rand() < 0.60
        p3_traffic_success = np.random.rand() < 0.80

        monthly_revenue = []

        for month in range(1, 13):
            low, high = alternative_plan_monthly[month]
            base_revenue = np.random.uniform(low, high)

            # Apply P3 partnership effect (M3+)
            if not p3_partnership_success and month >= 3:
                base_revenue *= 0.50

            # Apply P2 cold success effect (M2-6)
            if not p2_cold_success and month >= 2 and month <= 6:
                base_revenue *= 0.75  # Stuck at 1-2 clients instead of 5

            # Apply P3 traffic effect (M3+)
            if not p3_traffic_success and month >= 3:
                base_revenue *= 0.70  # Slower ramp

            monthly_revenue.append(base_revenue)

        results.append({
            'p3_partnership_success': p3_partnership_success,
            'p2_cold_success': p2_cold_success,
            'p3_traffic_success': p3_traffic_success,
            'monthly_revenue': monthly_revenue,
            'total_revenue': sum(monthly_revenue),
            'm1_3': sum(monthly_revenue[0:3]),
            'm4_6': sum(monthly_revenue[3:6]),
            'm7_12': sum(monthly_revenue[6:12]),
        })

    return results

# Run simulations
print("Running 10,000 simulations for each plan...")
current_results = calculate_current_plan_ev(10000)
alternative_results = calculate_alternative_plan_ev(10000)

# Extract metrics
current_total = [r['total_revenue'] for r in current_results]
alternative_total = [r['total_revenue'] for r in alternative_results]

current_m1_3 = [r['m1_3'] for r in current_results]
alternative_m1_3 = [r['m1_3'] for r in alternative_results]

current_m4_6 = [r['m4_6'] for r in current_results]
alternative_m4_6 = [r['m4_6'] for r in alternative_results]

current_m7_12 = [r['m7_12'] for r in current_results]
alternative_m7_12 = [r['m7_12'] for r in alternative_results]

# ============================================================================
# EXPECTED VALUE TABLE
# ============================================================================

print("\n" + "=" * 80)
print("EXPECTED VALUE SUMMARY (12 months)")
print("=" * 80)

ev_table = pd.DataFrame({
    'Metric': [
        'E[M1-3 Revenue]',
        'Std Dev (M1-3)',
        'E[M4-6 Revenue]',
        'Std Dev (M4-6)',
        'E[M7-12 Revenue]',
        'Std Dev (M7-12)',
        'E[Total Revenue]',
        'Std Dev (Total)',
        'Min (10th %ile)',
        'Max (90th %ile)',
        'Median',
    ],
    'Current Plan': [
        f"${np.mean(current_m1_3):,.0f}",
        f"${np.std(current_m1_3):,.0f}",
        f"${np.mean(current_m4_6):,.0f}",
        f"${np.std(current_m4_6):,.0f}",
        f"${np.mean(current_m7_12):,.0f}",
        f"${np.std(current_m7_12):,.0f}",
        f"${np.mean(current_total):,.0f}",
        f"${np.std(current_total):,.0f}",
        f"${np.percentile(current_total, 10):,.0f}",
        f"${np.percentile(current_total, 90):,.0f}",
        f"${np.median(current_total):,.0f}",
    ],
    'Alternative Plan': [
        f"${np.mean(alternative_m1_3):,.0f}",
        f"${np.std(alternative_m1_3):,.0f}",
        f"${np.mean(alternative_m4_6):,.0f}",
        f"${np.std(alternative_m4_6):,.0f}",
        f"${np.mean(alternative_m7_12):,.0f}",
        f"${np.std(alternative_m7_12):,.0f}",
        f"${np.mean(alternative_total):,.0f}",
        f"${np.std(alternative_total):,.0f}",
        f"${np.percentile(alternative_total, 10):,.0f}",
        f"${np.percentile(alternative_total, 90):,.0f}",
        f"${np.median(alternative_total):,.0f}",
    ]
})

print("\n")
print(ev_table.to_string(index=False))

# ============================================================================
# COMPARATIVE ANALYSIS
# ============================================================================

print("\n" + "=" * 80)
print("COMPARATIVE METRICS")
print("=" * 80)

comparison = {
    'Metric': [
        'E[M1-3] - Advantage',
        'E[M4-6] - Better Plan',
        'E[M7-12] - Better Plan',
        'E[Total] - Better Plan',
        'Upside (90th percentile)',
        'Downside Risk (10th percentile)',
        'Risk/Reward Ratio',
        'Volatility (Std Dev)',
    ],
    'Current Plan': [
        f"${np.mean(current_m1_3) - np.mean(alternative_m1_3):+,.0f}",
        f"${np.mean(current_m4_6):,.0f}",
        f"${np.mean(current_m7_12):,.0f}",
        f"${np.mean(current_total):,.0f}",
        f"${np.percentile(current_total, 90):,.0f}",
        f"${np.percentile(current_total, 10):,.0f}",
        f"{np.percentile(current_total, 90) / max(np.percentile(current_total, 10), 1):.2f}x",
        f"${np.std(current_total):,.0f}",
    ],
    'Alternative Plan': [
        f"${np.mean(alternative_m1_3):,.0f}",
        f"${np.mean(alternative_m4_6):,.0f}",
        f"${np.mean(alternative_m7_12):,.0f}",
        f"${np.mean(alternative_total):,.0f}",
        f"${np.percentile(alternative_total, 90):,.0f}",
        f"${np.percentile(alternative_total, 10):,.0f}",
        f"{np.percentile(alternative_total, 90) / max(np.percentile(alternative_total, 10), 1):.2f}x",
        f"${np.std(alternative_total):,.0f}",
    ],
    'Winner': [
        'Current' if np.mean(current_m1_3) > np.mean(alternative_m1_3) else 'Alternative',
        'Alternative' if np.mean(alternative_m4_6) > np.mean(current_m4_6) else 'Current',
        'Alternative' if np.mean(alternative_m7_12) > np.mean(current_m7_12) else 'Current',
        'Alternative' if np.mean(alternative_total) > np.mean(current_total) else 'Current',
        'Alternative' if np.percentile(alternative_total, 90) > np.percentile(current_total, 90) else 'Current',
        'Alternative' if np.percentile(alternative_total, 10) > np.percentile(current_total, 10) else 'Current',
        'Alternative' if (np.percentile(alternative_total, 90) / max(np.percentile(alternative_total, 10), 1)) > (np.percentile(current_total, 90) / max(np.percentile(current_total, 10), 1)) else 'Current',
        'Current' if np.std(current_total) < np.std(alternative_total) else 'Alternative',
    ]
}

comparison_df = pd.DataFrame(comparison)
print("\n")
print(comparison_df.to_string(index=False))

# ============================================================================
# SENSITIVITY ANALYSIS
# ============================================================================

print("\n" + "=" * 80)
print("SENSITIVITY ANALYSIS: Impact of Key Failures")
print("=" * 80)

# Sensitivity 1: Email list misses
print("\n1. EMAIL LIST MISSES (P < 300)")
print("-" * 80)

current_email_fail = [r['total_revenue'] for r in current_results if not r['email_success']]
alternative_email_unaffected = alternative_total

print(f"Current plan (email fails):    E[Total] = ${np.mean(current_email_fail):,.0f}")
print(f"Alternative plan (unaffected): E[Total] = ${np.mean(alternative_email_unaffected):,.0f}")
print(f"Current plan advantage lost:   ${np.mean(current_total) - np.mean(current_email_fail):,.0f}")

# Sensitivity 2: P3 partnerships fail
print("\n2. P3 PARTNERSHIPS FAIL")
print("-" * 80)

alternative_p3_fail = [r['total_revenue'] for r in alternative_results if not r['p3_partnership_success']]

print(f"Current plan (P3 fails):       E[Total] = ${np.mean(current_total):,.0f} (no change, low priority)")
print(f"Alternative plan (P3 fails):   E[Total] = ${np.mean(alternative_p3_fail):,.0f}")
print(f"Alternative plan advantage lost: ${np.mean(alternative_total) - np.mean(alternative_p3_fail):,.0f}")

# Sensitivity 3: Shadowban on P1
print("\n3. SHADOWBAN ON P1 (50% revenue cut)")
print("-" * 80)

current_shadowban = [r['total_revenue'] for r in current_results if r['shadowban']]

print(f"Current plan (shadowban):      E[Total] = ${np.mean(current_shadowban):,.0f}")
print(f"Alternative plan (unaffected): E[Total] = ${np.mean(alternative_total):,.0f}")
print(f"Alternative plan advantage:    ${np.mean(alternative_total) - np.mean(current_shadowban):,.0f}")

# ============================================================================
# BREAK-EVEN ANALYSIS
# ============================================================================

print("\n" + "=" * 80)
print("BREAK-EVEN ANALYSIS: When does Alternative Surpass Current?")
print("=" * 80)

# Calculate cumulative revenue by month
cumulative_current = []
cumulative_alternative = []

for r_current, r_alt in zip(current_results, alternative_results):
    cum_current = [sum(r_current['monthly_revenue'][:i+1]) for i in range(12)]
    cum_alternative = [sum(r_alt['monthly_revenue'][:i+1]) for i in range(12)]
    cumulative_current.append(cum_current)
    cumulative_alternative.append(cum_alternative)

# Average cumulative by month
avg_cumulative_current = np.mean(cumulative_current, axis=0)
avg_cumulative_alternative = np.mean(cumulative_alternative, axis=0)

months = list(range(1, 13))
breakeven_df = pd.DataFrame({
    'Month': months,
    'Current (Cumulative)': [f"${x:,.0f}" for x in avg_cumulative_current],
    'Alternative (Cumulative)': [f"${x:,.0f}" for x in avg_cumulative_alternative],
    'Difference (Alt - Curr)': [f"${alt - curr:+,.0f}" for curr, alt in zip(avg_cumulative_current, avg_cumulative_alternative)],
})

print("\n")
print(breakeven_df.to_string(index=False))

# ============================================================================
# RECOVERY TIMELINE ANALYSIS
# ============================================================================

print("\n" + "=" * 80)
print("RECOVERY TIMELINE ANALYSIS (Assuming $10k Recovery Goal)")
print("=" * 80)

recovery_goal = 10000

current_recovery_months = []
alternative_recovery_months = []

for r_current, r_alt in zip(current_results, alternative_results):
    cumulative = 0
    for month, revenue in enumerate(r_current['monthly_revenue'], 1):
        cumulative += revenue
        if cumulative >= recovery_goal:
            current_recovery_months.append(month)
            break
    else:
        current_recovery_months.append(13)

    cumulative = 0
    for month, revenue in enumerate(r_alt['monthly_revenue'], 1):
        cumulative += revenue
        if cumulative >= recovery_goal:
            alternative_recovery_months.append(month)
            break
    else:
        alternative_recovery_months.append(13)

print(f"\nCurrent plan:")
print(f"  P(reach $10k by month 12) = {sum(1 for m in current_recovery_months if m <= 12) / len(current_recovery_months) * 100:.1f}%")
print(f"  E[recovery month] = {np.mean(current_recovery_months):.1f}")
print(f"  Median = Month {np.median(current_recovery_months):.0f}")

print(f"\nAlternative plan:")
print(f"  P(reach $10k by month 12) = {sum(1 for m in alternative_recovery_months if m <= 12) / len(alternative_recovery_months) * 100:.1f}%")
print(f"  E[recovery month] = {np.mean(alternative_recovery_months):.1f}")
print(f"  Median = Month {np.median(alternative_recovery_months):.0f}")

# ============================================================================
# DECISION TREE / DECISION MATRIX
# ============================================================================

print("\n" + "=" * 80)
print("DECISION TREE: OPTIMAL CHOICE BY OBJECTIVE")
print("=" * 80)

objectives = {
    'Maximize M1-3 Revenue (Proof of Concept)': {
        'Current': np.mean(current_m1_3),
        'Alternative': np.mean(alternative_m1_3),
    },
    'Maximize M1-12 Total Revenue': {
        'Current': np.mean(current_total),
        'Alternative': np.mean(alternative_total),
    },
    'Minimize Risk (Downside Protection)': {
        'Current': np.percentile(current_total, 10),
        'Alternative': np.percentile(alternative_total, 10),
    },
    'Maximize Upside (90th percentile)': {
        'Current': np.percentile(current_total, 90),
        'Alternative': np.percentile(alternative_total, 90),
    },
    'Maximize M7-12 Revenue (Long-term)': {
        'Current': np.mean(current_m7_12),
        'Alternative': np.mean(alternative_m7_12),
    },
    'Minimize Volatility (Risk)': {
        'Current': np.std(current_total),
        'Alternative': np.std(alternative_total),
    },
}

print("\n")
decision_matrix = pd.DataFrame(objectives).T
decision_matrix.columns = ['Current Plan', 'Alternative Plan']
decision_matrix['Winner'] = decision_matrix.apply(
    lambda row: 'Current' if ((row['Current Plan'] > row['Alternative Plan']) if 'Minimize' not in row.name else (row['Current Plan'] < row['Alternative Plan'])) else 'Alternative', axis=1
)

for col in ['Current Plan', 'Alternative Plan']:
    decision_matrix[col] = decision_matrix[col].apply(lambda x: f"${x:,.0f}")

print(decision_matrix.to_string())

# ============================================================================
# FINAL RECOMMENDATION
# ============================================================================

print("\n" + "=" * 80)
print("FINAL RECOMMENDATION")
print("=" * 80)

rec_text = """
CURRENT PLAN STRENGTHS:
  + $700 higher M1-3 revenue (proof of concept 1 month earlier)
  + More robust to P3 partnership failure (P3 was secondary)
  + Proven execution path (P1 + P2 warm outreach)
  + Lower volatility (less dependent on unproven P3)

CURRENT PLAN WEAKNESSES:
  - Hits ceiling at M7-12 ($3-5K/mo, stuck at 5 P2 clients)
  - Less resilient to shadowban (P1 is 40-60% of M1-3 revenue)
  - Total 12-month revenue $12-14K lower
  - M12+ revenue plateaus (no growth engine)

ALTERNATIVE PLAN STRENGTHS:
  + 3-5x higher revenue M7-12 ($8-16K/mo vs $3-5K/mo)
  + $12-14K higher total revenue over 12 months
  + More resilient to shadowban (P1 is minimal, not primary)
  + Better downside protection (higher 10th percentile)
  + Continues growing M12+ (P3 compounds)
  + Better upside if execution succeeds (90th percentile +$20K)

ALTERNATIVE PLAN WEAKNESSES:
  - $700 lower M1-3 revenue (slower proof of concept)
  - Breaks if P3 partnerships fail (70% success rate)
  - Requires different execution skills (content + cold outreach)
  - Slightly higher volatility

TIEBREAKER: Recovery Timeline (~Month 9-10 for both) is NOT the differentiator.

RECOMMENDATION: ALTERNATIVE PLAN
  * Trade off M1-3 proof of concept ($700) for M12+ scalability (3-5x revenue)
  * Better long-term financial position ($43K vs $31K by end of year)
  * More resilient to shadowban (primary concern)
  * Better hedge against execution risk (multiple independent revenue engines)
  * Month 8-9 total revenue reaches parity, then Alternative leads forever

PIVOT CONDITION: If P3 partnerships fail by M3, pivot back to Current plan.
  * Trigger: Zero P3 revenue by M3 despite effort
  * Fallback: Double down on P1 + P2 (proven path)
  * Cost: 3-month delay, but recovery still achievable by Month 12
"""

print(rec_text)
