"""
BDAT 614 — Module 6, Lesson 2
Exercise: Big Data Applications in SQC — EWMA, CUSUM, and ML Integration
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(614)

# ============================================================
# Process parameters
# ============================================================
mu_0  = 10.0   # in-control process mean
sigma = 1.0    # known process standard deviation
n_obs = 200    # total observations
shift_point = 100  # shift begins at observation index 100 (0-indexed)
shift_size  = 1.5  # shift magnitude in sigma units (added to mean)

# EWMA parameters
lam = 0.2    # smoothing parameter lambda
L   = 3.0    # control limit width (multiples of EWMA std dev)

# CUSUM parameters
K = 0.5 * sigma   # allowance (reference value)
H = 5.0 * sigma   # decision interval


# ============================================================
# Task 1: Generate process data with injected shift
# ============================================================
# Generate n_obs = 200 observations:
#   - Observations 0 to shift_point-1: Normal(mu_0, sigma)
#   - Observations shift_point to 199: Normal(mu_0 + shift_size*sigma, sigma)
#
# Combine into a single array `data` of length 200.
#
# TODO: generate the `data` array

data = None


# ============================================================
# Task 2: Implement EWMA chart
# ============================================================
# z[0] = mu_0 (starting value)
# For t = 1 to 199:
#   z[t] = lam * data[t] + (1 - lam) * z[t-1]
#
# Time-varying EWMA limits (L=3):
#   spread_t = L * sigma * sqrt((lam / (2 - lam)) * (1 - (1 - lam)**(2*(t+1))))
#   UCL_ewma[t] = mu_0 + spread_t
#   LCL_ewma[t] = mu_0 - spread_t
# (use t+1 because t is 0-indexed here)
#
# Find ewma_detect: the first index where z[t] > UCL_ewma[t] or z[t] < LCL_ewma[t]
#                   with t > shift_point (don't count in-control false alarms).
# Print: "EWMA detected shift at observation: <index>"
#
# TODO: implement EWMA

z        = np.zeros(n_obs)
UCL_ewma = np.zeros(n_obs)
LCL_ewma = np.zeros(n_obs)
ewma_detect = None


# ============================================================
# Task 3: Implement tabular CUSUM chart
# ============================================================
# C_plus[0]  = 0, C_minus[0] = 0
# For t = 1 to 199:
#   C_plus[t]  = max(0, data[t] - (mu_0 + K) + C_plus[t-1])
#   C_minus[t] = max(0, (mu_0 - K) - data[t] + C_minus[t-1])
#
# Find cusum_detect: first index > shift_point where C_plus[t] > H or C_minus[t] > H.
# Print: "CUSUM detected shift at observation: <index>"
#
# TODO: implement CUSUM

C_plus  = np.zeros(n_obs)
C_minus = np.zeros(n_obs)
cusum_detect = None


# ============================================================
# Task 4: Individuals (Xbar) chart for comparison
# ============================================================
# Since n=1 (individuals), the control limits are:
#   UCL_xbar = mu_0 + 3 * sigma
#   LCL_xbar = mu_0 - 3 * sigma
#
# Find xbar_detect: first index > shift_point where data[t] > UCL_xbar or data[t] < LCL_xbar.
# Print: "Xbar chart detected shift at observation: <index>"
#
# TODO: compute individuals chart limits and detection time

UCL_xbar = None
LCL_xbar = None
xbar_detect = None


# ============================================================
# Task 5: Three-panel comparison plot
# ============================================================
# Create a figure with 3 stacked subplots (figsize=(13, 12)).
# For each chart:
#   a) Plot the relevant statistic vs observation index (1 to 200).
#   b) Draw UCL (red dashed), CL (green dashed), LCL (red dashed).
#      For CUSUM: draw H (red dashed) at +H and 0 as the reference; no LCL needed for C+.
#   c) Mark the true shift point with a vertical blue dotted line labelled "Shift injected".
#   d) Mark out-of-control points (beyond limits, after shift) with red scatter markers.
#   e) Annotate the detection observation with a vertical orange line.
#
# Panel 1: Individuals (Xbar) chart — statistic = data
# Panel 2: EWMA chart — statistic = z, limits = UCL_ewma / LCL_ewma
# Panel 3: CUSUM chart — plot C_plus (upward statistic), H = decision interval
#
# Label axes and add titles. Save as "module-06-lesson-02-ewma-cusum.png".
#
# After plotting, print an ARL comparison table:
#   Chart | Detection observation | Observations after shift
#
# TODO: build the three-panel chart and print ARL comparison table


