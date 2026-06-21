"""
BDAT 614 — Module 5, Lesson 2
Exercise: Six Sigma — DPMO, Performance Levels, and DMAIC Roadmap
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

np.random.seed(614)

# ============================================================
# Task 1: Define helper functions
# ============================================================
# Write a function dpmo(defects, units, opportunities) that computes:
#   DPMO = (defects / (units * opportunities)) * 1_000_000
#
# Write a function sigma_level(dpmo_val) that computes the sigma level:
#   sigma = norm.ppf(1 - dpmo_val / 1_000_000) + 1.5
# Handle the edge case where dpmo_val == 0 by returning a large value (e.g. 6.0).
#
# TODO: implement both functions

def dpmo(defects, units, opportunities):
    pass  # TODO

def sigma_level(dpmo_val):
    pass  # TODO


# ============================================================
# Task 2: Reproduce the Six Sigma performance table
# ============================================================
# For sigma levels [1, 2, 3, 4, 5, 6]:
#   - Compute the expected DPMO by reversing the sigma_level formula:
#       dpmo_from_sigma = (1 - norm.cdf(sigma_val - 1.5)) * 1_000_000
#   - Compute yield (%) = (1 - dpmo_from_sigma / 1_000_000) * 100
#   - Verify round-trip: sigma_level(dpmo_from_sigma) should equal sigma_val
#
# Print a table with columns: Sigma | DPMO | Yield (%) | Round-trip sigma
#
# TODO: build and print the performance table

target_sigmas = [1, 2, 3, 4, 5, 6]


# ============================================================
# Task 3: Compute DPMO and sigma level for 5 processes
# ============================================================
# Process data (defects, units, opportunities_per_unit):
process_data = [
    ("Assembly line A",   342, 10000, 5),
    ("Call centre",      1080, 12000, 4),
    ("Invoice processing", 45,  8000, 3),
    ("Surgical unit",       8,  5000, 7),
    ("Software releases",  150,  2000, 10),
]
#
# For each process, compute DPMO using your dpmo() function, then compute
# sigma level using your sigma_level() function.
#
# Print a table with columns: Process | Defects | Units | Opps | DPMO | Sigma Level
#
# TODO: print the process performance table

process_results = []  # store (name, dpmo_val, sigma_val) for plotting below


# ============================================================
# Task 4: Plot sigma level vs DPMO reference curve with process overlays
# ============================================================
# a) Generate a smooth reference curve:
#    - Create dpmo_range = np.logspace(0, 6, 500) (1 to 1,000,000 on log scale)
#    - Compute sigma_curve = [sigma_level(d) for d in dpmo_range]
#    - Clip sigma values to the range [0, 6.5] so the plot stays readable.
#
# b) Plot the reference curve as a blue line on a semi-log x-axis (use ax.set_xscale("log")).
#
# c) Overlay the 5 processes as red scatter points.
#    Label each point with the process name (use ax.annotate or ax.text).
#
# d) Add a horizontal dashed line at sigma = 6.0 labelled "Six Sigma target".
# e) Label axes: x = "DPMO (log scale)", y = "Sigma Level"
# f) Title: "Six Sigma Performance Curve"
# g) Add grid (alpha=0.3) and save as "module-05-lesson-02-sigma-curve.png".
#
# TODO: build the sigma vs DPMO plot


