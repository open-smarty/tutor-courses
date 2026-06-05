"""
BDAT 614 — Module 2, Lesson 2
Exercise: Individuals and Moving Range (I-MR) Charts
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(13)

# Control chart constants for n=2 (individual moving range)
d2 = 1.128
D4 = 3.267

# ============================================================
# Task 1: Generate individual measurement data
# ============================================================
# Generate 30 individual API response times using
# np.random.normal(245, 18, 30).
# Then simulate a process shift at observation 22 (index 21):
# add 60 ms to observations 22 through 30 (indices 21 to 29).
#
# TODO: create `x` array and apply the shift
x = None


# ============================================================
# Task 2: Compute the Moving Range
# ============================================================
# The moving range between consecutive observations:
#   MR[i] = abs(x[i] - x[i-1])  for i = 1, 2, ..., n-1
#
# Use np.abs(np.diff(x)) to compute all n-1 moving ranges in one step.
# Then compute MR_bar = mean of the moving ranges.
#
# TODO: compute `MR` and `MR_bar`
MR     = None
MR_bar = None


# ============================================================
# Task 3: Compute I chart and MR chart limits
# ============================================================
# x_bar = mean of all observations
# I chart:  UCL = x_bar + 3 * (MR_bar / d2)
#           LCL = x_bar - 3 * (MR_bar / d2)
# MR chart: UCL = D4 * MR_bar
#           LCL = 0
#
# Print all limits formatted to 2 decimal places.
#
# TODO: compute x_bar, UCL_I, LCL_I, UCL_MR, LCL_MR
x_bar  = None
UCL_I  = None
LCL_I  = None
UCL_MR = None
LCL_MR = 0.0


# ============================================================
# Task 4: Plot I chart and MR chart
# ============================================================
# Create two vertically stacked subplots: top = I chart, bottom = MR chart.
#
# For the I chart (top):
#   - x-axis: observation numbers 1 to 30
#   - y-axis: individual values x
#   - Draw UCL (red dashed), CL (green dashed), LCL (red dashed)
#   - Mark out-of-control points (x > UCL or x < LCL) with red markers
#
# For the MR chart (bottom):
#   - x-axis: observation numbers 2 to 30 (MR has n-1 values)
#   - y-axis: MR values
#   - Draw UCL (red dashed), CL (green dashed), LCL=0 (red dashed)
#   - Mark out-of-control points (MR > UCL_MR) with red markers
#
# Add labels, titles, and legends to both panels.
#
# TODO: build the I-MR chart


