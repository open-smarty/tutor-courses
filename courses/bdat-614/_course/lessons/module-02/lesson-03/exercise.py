"""BDAT 614 — Module 2, Lesson 3
Exercise: Attribute Control Charts — p, np, c, and u Charts"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

rng = np.random.default_rng(seed=42)

# ── Simulated data ──────────────────────────────────────────────────────────
# 20 nightly ETL batches.  Each batch has a variable number of records (n_i).
# For the p chart: each record either passes or fails validation (binary).
# For the u chart: each record may carry multiple data quality defects.

k = 20  # number of batches

# Task 1: Generate variable batch sizes between 350 and 600 records
# TODO: use rng.integers(350, 601, size=k) and store in n_sizes

# Task 2: Generate defective-item counts for the p chart
# Assume true proportion defective p_true = 0.04
# Hint: use rng.binomial(n_sizes, p_true) to get defective counts D_i
# TODO: compute D_i and p_i = D_i / n_sizes

# Task 3: Generate defect counts for the u chart
# Assume mean defects per unit u_true = 0.018
# Hint: defect counts per batch ~ Poisson(u_true * n_i); use rng.poisson(u_true * n_sizes)
# TODO: compute c_i and u_i = c_i / n_sizes

# ── p Chart ─────────────────────────────────────────────────────────────────
# Task 4: Compute p-bar (overall proportion defective)
# TODO: p_bar = sum(D_i) / sum(n_sizes)

# Task 5: Compute variable UCL and LCL for each subgroup
# UCL_i = p_bar + 3 * sqrt(p_bar * (1 - p_bar) / n_i)
# LCL_i = max(0, p_bar - 3 * sqrt(p_bar * (1 - p_bar) / n_i))
# TODO: compute ucl_p and lcl_p as arrays of length k

# Task 6: Plot the p chart
# TODO:
# - Plot p_i as a line with markers
# - Plot CL (p_bar) as a dashed green line
# - Plot UCL and LCL as dashed red lines (they vary per batch)
# - Highlight out-of-control points (p_i > UCL_i or p_i < LCL_i) in red
# - Label axes and add a title

# ── u Chart ─────────────────────────────────────────────────────────────────
# Task 7: Compute u-bar (overall defects per unit)
# TODO: u_bar = sum(c_i) / sum(n_sizes)

# Task 8: Compute variable UCL and LCL for each subgroup
# UCL_i = u_bar + 3 * sqrt(u_bar / n_i)
# LCL_i = max(0, u_bar - 3 * sqrt(u_bar / n_i))
# TODO: compute ucl_u and lcl_u as arrays of length k

# Task 9: Plot the u chart
# TODO:
# - Plot u_i as a line with markers
# - Plot CL (u_bar) as a dashed green line
# - Plot variable UCL and LCL as dashed red lines
# - Highlight out-of-control points in red
# - Label axes and add a title

plt.tight_layout()
plt.show()
