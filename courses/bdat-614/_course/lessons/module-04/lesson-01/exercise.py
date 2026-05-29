"""
Module 4, Lesson 1 — The Shewhart Cycle (PDCA/PDSA)
Exercise: Map actions to PDCA phases and simulate a before/after comparison.

Requirements: numpy, scipy
"""
import numpy as np
from scipy import stats

# ----- Part 1: PDCA Phase Mapping -----
# Assign each action to its PDCA phase: "Plan", "Do", "Study", or "Act"

actions = [
    {
        "description": "Collect 30 days of baseline ETL error rates and calculate the current average.",
        "phase": ""  # TODO
    },
    {
        "description": "Deploy new data validation rules in the staging environment for 2 weeks.",
        "phase": ""  # TODO
    },
    {
        "description": "Analyse the p-chart for the staging pipeline and compare the new error rate to the target.",
        "phase": ""  # TODO
    },
    {
        "description": "Promote the validated rules to the production pipeline and update the runbook.",
        "phase": ""  # TODO
    },
    {
        "description": "Set the improvement target: reduce error rate from 2.8% to below 0.5%.",
        "phase": ""  # TODO
    },
    {
        "description": "Run the improved pipeline on a small subset of daily data (10% of records).",
        "phase": ""  # TODO
    },
    {
        "description": "Identify that 80% of errors originate from 2 of the 15 data sources.",
        "phase": ""  # TODO
    },
    {
        "description": "Begin the next improvement cycle targeting the remaining 0.4% error rate.",
        "phase": ""  # TODO
    },
]

# ----- Part 2: Before/After Hypothesis Test -----
# A process change was made. We want to know if the improvement is statistically significant.

np.random.seed(99)
before = np.random.normal(loc=50.0, scale=5.0, size=30)  # before: mean=50, std=5
after  = np.random.normal(loc=46.0, scale=4.5, size=30)  # after:  mean=46, std=4.5

# TODO: Run a two-sample t-test to check if the means are significantly different
t_stat, p_value = None, None  # replace with scipy.stats.ttest_ind(before, after)

# TODO: Print the result and interpret it
# Is the improvement statistically significant at α = 0.05?
print("=== Part 1: PDCA Phase Mapping ===")
# uncomment after filling in phases

print("\n=== Part 2: Before/After t-Test ===")
