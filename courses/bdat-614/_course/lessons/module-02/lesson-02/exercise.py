"""
Module 2, Lesson 2 — I-MR Charts
Exercise: Build an Individuals and Moving Range chart for server response times.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

# Hourly server response times (ms) — 24 observations (one per hour)
response_times = [
    245, 238, 252, 241, 260, 255, 248, 272,
    250, 243, 258, 247, 265, 253, 246, 270,
    242, 251, 310, 249, 257, 244, 263, 250  # hour 19 is suspect
]

# Constants for n=1 (I-MR chart)
E2 = 2.66   # for I-Chart limits
D4 = 3.267  # for MR-Chart UCL
D3 = 0.0    # for MR-Chart LCL

# TODO: Step 1 — compute x̄ (mean of all observations)
x_bar = None

# TODO: Step 2 — compute moving ranges MR_i = |x_i - x_{i-1}| for i = 2 to n
mr_values = None  # should have len(response_times) - 1 values

# TODO: Step 3 — compute MR̄ (average of moving ranges)
mr_bar = None

# TODO: Step 4 — compute control limits
i_ucl = None
i_lcl = None
mr_ucl = None
mr_lcl = 0.0

# TODO: Step 5 — print the limits
print("=== I-MR Chart Limits ===")

# TODO: Step 6 — plot both charts (I-Chart on top, MR-Chart on bottom)
# Highlight out-of-control points in red
