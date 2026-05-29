"""
Module 2, Lesson 1 — Xbar-R Control Charts
Exercise: Compute control limits and plot an Xbar-R chart.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

# Subgroup data: each row is one subgroup of n=5 measurements (bolt diameter in mm)
subgroups = [
    [10.02, 10.05, 9.98, 10.01, 10.03],
    [10.04, 10.00, 10.06, 9.99, 10.02],
    [9.97, 10.03, 10.01, 10.00, 9.99],
    [10.05, 10.02, 10.04, 10.01, 10.03],
    [10.00, 9.98, 10.02, 10.05, 10.01],
    [10.03, 10.01, 9.99, 10.04, 10.02],
    [10.08, 10.06, 10.07, 10.09, 10.05],  # possible out-of-control
    [10.01, 10.03, 10.00, 10.02, 10.04],
    [9.99, 10.00, 10.01, 9.98, 10.02],
    [10.02, 10.04, 10.01, 10.03, 10.00],
]

# Control chart constants for n=5
A2 = 0.577
D3 = 0.0
D4 = 2.114

# TODO: Step 1 — compute subgroup means and ranges
xbar_values = None  # replace with a list of subgroup means
r_values = None     # replace with a list of subgroup ranges

# TODO: Step 2 — compute grand mean (xbar_bar) and average range (r_bar)
xbar_bar = None
r_bar = None

# TODO: Step 3 — compute control limits
xbar_ucl = None
xbar_lcl = None
r_ucl = None
r_lcl = None

# TODO: Step 4 — print the limits
print("=== Xbar-R Control Chart Limits ===")
# print(f"Grand Mean (x̄̄):  {xbar_bar:.4f}")
# print(f"Average Range (R̄): {r_bar:.4f}")
# print(f"Xbar UCL: {xbar_ucl:.4f}  CL: {xbar_bar:.4f}  LCL: {xbar_lcl:.4f}")
# print(f"R    UCL: {r_ucl:.4f}   CL: {r_bar:.4f}  LCL: {r_lcl:.4f}")

# TODO: Step 5 — plot both charts
# Create a figure with two subplots (Xbar on top, R on bottom)
# Draw the data points, CL, UCL, LCL lines
# Highlight any out-of-control points in red
