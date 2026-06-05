"""
BDAT 614 — Module 2, Lesson 1
Exercise: Xbar-R Control Charts for Fill Weight Data
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(7)

# Control chart constants for subgroup size n=5
A2 = 0.577
D3 = 0.0
D4 = 2.114

# ============================================================
# Task 1: Generate subgroup data
# ============================================================
# Simulate 25 subgroups of n=5 fill weight measurements.
# Use np.random.normal(loc=500, scale=1.5, size=(25, 5)).
# This gives a 25×5 array where each row is one subgroup.
#
# TODO: create the `data` array (shape 25×5)
data = None


# ============================================================
# Task 2: Compute subgroup statistics
# ============================================================
# For each of the 25 subgroups:
#   - subgroup_means[i] = mean of row i (use np.mean with axis=1)
#   - subgroup_ranges[i] = max - min of row i
#     (use np.max(..., axis=1) - np.min(..., axis=1))
#
# Then compute:
#   - xbar_bar = mean of subgroup_means
#   - R_bar    = mean of subgroup_ranges
#
# TODO: compute subgroup_means, subgroup_ranges, xbar_bar, R_bar
subgroup_means  = None
subgroup_ranges = None
xbar_bar = None
R_bar    = None


# ============================================================
# Task 3: Compute control limits
# ============================================================
# Xbar chart limits:
#   UCL_xbar = xbar_bar + A2 * R_bar
#   LCL_xbar = xbar_bar - A2 * R_bar
#
# R chart limits:
#   UCL_R = D4 * R_bar
#   LCL_R = D3 * R_bar
#
# TODO: compute and print all six limit values
UCL_xbar = None
LCL_xbar = None
UCL_R    = None
LCL_R    = None


# ============================================================
# Task 4: Plot Xbar chart and R chart side by side
# ============================================================
# Use plt.subplots(2, 1, figsize=(12, 8)) to create two vertically
# stacked subplots — top for Xbar, bottom for R.
#
# For each chart:
#   a) Plot the statistic (subgroup_means or subgroup_ranges) as a line
#      with circular markers.
#   b) Draw UCL as a red dashed horizontal line, labeled "UCL".
#   c) Draw CL (xbar_bar or R_bar) as a green dashed line, labeled "CL".
#   d) Draw LCL as a red dashed horizontal line, labeled "LCL".
#   e) Find out-of-control points (where the statistic > UCL or < LCL).
#      Plot those points in red with a larger marker (s=80 or markersize=8).
#   f) Label axes and add a title for each subplot.
#   g) Add a legend to each subplot.
#
# TODO: build the two-panel control chart


