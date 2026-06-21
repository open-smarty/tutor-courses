"""
BDAT 614 — Module 5, Lesson 1
Exercise: Acceptance Sampling Plans and OC Curves
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom

np.random.seed(614)

# Quality benchmarks
AQL  = 0.01   # Acceptable Quality Level
LTPD = 0.06   # Lot Tolerance Percent Defective

# Range of incoming defect rates to evaluate
p_values = np.linspace(0, 0.20, 200)

# Three sampling plans to compare: (n, c)
plans = [
    (50,  2, "n=50, c=2"),
    (100, 2, "n=100, c=2"),
    (100, 4, "n=100, c=4"),
]

# ============================================================
# Task 1: Compute the OC curve for each plan
# ============================================================
# For each plan (n, c), compute P(accept | p) for every p in p_values.
# Use scipy.stats.binom.cdf(c, n, p) — this gives P(D <= c) where D ~ Bin(n, p).
#
# Store results in a list of arrays, one per plan.
#
# TODO: compute oc_curves — a list where oc_curves[i] is a numpy array
#       of P(accept) values for plans[i], computed over p_values.
oc_curves = None


# ============================================================
# Task 2: Print risk table
# ============================================================
# For each plan, compute and print:
#   - P(accept) at p = AQL    → P_accept_AQL
#   - Producer risk α = 1 - P_accept_AQL
#   - P(accept) at p = LTPD   → P_accept_LTPD
#   - Consumer risk β = P_accept_LTPD
#
# Use binom.cdf(c, n, AQL) and binom.cdf(c, n, LTPD).
#
# Print a formatted table with columns: Plan | P(acc|AQL) | α | P(acc|LTPD) | β
#
# TODO: print the risk table for all three plans


# ============================================================
# Task 3: Plot the OC curves
# ============================================================
# Create a single figure (figsize=(10, 6)).
# For each plan, plot P(accept) vs p_values as a line with a distinct colour.
# Label each line with the plan description string from the plans list.
#
# Add:
#   a) A vertical dashed line at p = AQL (red, label "AQL = 0.01")
#   b) A vertical dashed line at p = LTPD (orange, label "LTPD = 0.06")
#   c) A horizontal dashed line at P(accept) = 0.10 (grey, label="β = 0.10 target")
#   d) A horizontal dashed line at P(accept) = 0.95 (grey, label="1-α = 0.95 target")
#
# Label axes: x = "Incoming defect rate p", y = "P(accept)"
# Title: "Operating Characteristic (OC) Curves — Single Sampling Plans"
# Add legend and grid (alpha=0.3).
# Save as "module-05-lesson-01-oc-curves.png" and show.
#
# TODO: build the OC curve plot


