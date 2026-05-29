"""
Module 2, Lesson 3 — Attribute Control Charts
Exercise: Build a p-chart and a u-chart.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

# ----- Dataset 1: p-chart -----
# A call centre monitors the proportion of calls with a complaint.
# Sample sizes and number of complaints per day (20 days):
sample_sizes_p = [150, 160, 145, 155, 150, 165, 148, 152, 158, 150,
                  153, 147, 161, 156, 149, 154, 160, 151, 157, 155]
complaints =     [6,   8,   5,   10,  7,   9,   4,   11,  8,   6,
                  7,   5,   9,   12,  6,   8,   10,  7,   9,   6]

# TODO: Step 1 — compute p̄ (overall proportion)
p_bar = None

# TODO: Step 2 — compute per-day proportions pᵢ = complaints[i] / sample_sizes_p[i]
p_values = None

# TODO: Step 3 — compute per-day UCL and LCL (variable limits)
p_ucl = None  # list of UCLs, one per day
p_lcl = None  # list of LCLs, one per day (max with 0)

# TODO: Step 4 — plot the p-chart


# ----- Dataset 2: u-chart -----
# A data pipeline is monitored for validation errors (defects).
# Each day a different number of data batches is processed.
batches_per_day = [50, 60, 55, 70, 45, 65, 58, 52, 67, 53]
total_errors =    [12, 14,  8, 21,  9, 16, 13, 10, 20, 11]

# TODO: Step 5 — compute ū (overall defects per unit)
u_bar = None

# TODO: Step 6 — compute per-day u values and variable limits
u_values = None
u_ucl = None
u_lcl = None

# TODO: Step 7 — plot the u-chart
