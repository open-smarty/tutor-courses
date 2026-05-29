"""
Module 4, Lesson 1 — Shewhart Cycle (Solution)
"""
import numpy as np
from scipy import stats

actions = [
    {"description": "Collect 30 days of baseline ETL error rates and calculate the current average.", "phase": "Plan"},
    {"description": "Deploy new data validation rules in the staging environment for 2 weeks.", "phase": "Do"},
    {"description": "Analyse the p-chart for the staging pipeline and compare the new error rate to the target.", "phase": "Study"},
    {"description": "Promote the validated rules to the production pipeline and update the runbook.", "phase": "Act"},
    {"description": "Set the improvement target: reduce error rate from 2.8% to below 0.5%.", "phase": "Plan"},
    {"description": "Run the improved pipeline on a small subset of daily data (10% of records).", "phase": "Do"},
    {"description": "Identify that 80% of errors originate from 2 of the 15 data sources.", "phase": "Study"},
    {"description": "Begin the next improvement cycle targeting the remaining 0.4% error rate.", "phase": "Act"},
]

np.random.seed(99)
before = np.random.normal(loc=50.0, scale=5.0, size=30)
after  = np.random.normal(loc=46.0, scale=4.5, size=30)

t_stat, p_value = stats.ttest_ind(before, after)

print("=== Part 1: PDCA Phase Mapping ===")
for a in actions:
    print(f"  [{a['phase']:5s}] {a['description']}")

print("\n=== Part 2: Before/After t-Test ===")
print(f"Before: mean={before.mean():.2f}, std={before.std():.2f}")
print(f"After:  mean={after.mean():.2f},  std={after.std():.2f}")
print(f"t-statistic: {t_stat:.3f}")
print(f"p-value:     {p_value:.4f}")
alpha = 0.05
if p_value < alpha:
    print(f"\nConclusion: p={p_value:.4f} < α={alpha} → Statistically significant improvement.")
    print("The improvement in the Study phase is real, not random variation. Proceed to Act.")
else:
    print(f"\nConclusion: p={p_value:.4f} >= α={alpha} → No significant improvement detected.")
    print("The change did not produce a real improvement. Return to Plan and revise the approach.")
