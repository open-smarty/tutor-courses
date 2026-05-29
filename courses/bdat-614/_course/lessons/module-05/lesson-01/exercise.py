"""
Module 5, Lesson 1 — Acceptance Sampling and OC Curves
Exercise: Compute and plot the OC curve for a single sampling plan.

Requirements: numpy, matplotlib, scipy
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom

# Sampling plan parameters
n = 100   # sample size
c = 2     # acceptance number
AQL  = 0.02   # Acceptable Quality Level (2%)
LTPD = 0.08   # Lot Tolerance Percent Defective (8%)

# TODO: Step 1 — compute Pa(p) for p values from 0 to 0.15 in steps of 0.001
p_values = np.arange(0, 0.151, 0.001)
pa_values = None  # P(X <= c) where X ~ Binomial(n, p)
# Hint: use binom.cdf(c, n, p) for each p

# TODO: Step 2 — find Pa at AQL and LTPD
pa_at_aql  = None
pa_at_ltpd = None

# TODO: Step 3 — compute producer's risk (alpha) and consumer's risk (beta)
alpha = None  # 1 - Pa at AQL
beta  = None  # Pa at LTPD

# TODO: Step 4 — print results
print("=== Single Sampling Plan OC Curve ===")
print(f"n={n}, c={c}")
# print(f"Pa at AQL={AQL*100:.0f}%:  {pa_at_aql:.4f}")
# print(f"Pa at LTPD={LTPD*100:.0f}%: {pa_at_ltpd:.4f}")
# print(f"Producer's risk (α): {alpha:.4f}")
# print(f"Consumer's risk (β): {beta:.4f}")

# TODO: Step 5 — plot the OC curve
# x-axis: p (proportion defective)
# y-axis: Pa (probability of acceptance)
# Mark AQL and LTPD with vertical dashed lines
# Mark Pa(AQL) and Pa(LTPD) with horizontal dashed lines
# Title: "OC Curve — Single Sampling Plan (n=100, c=2)"
