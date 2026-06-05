"""BDAT 614 — Module 3, Lesson 1
Exercise: Process Capability Analysis — Cp and Cpk"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

rng = np.random.default_rng(seed=7)

# Specification limits (set by the customer)
LSL = 496.0   # Lower Specification Limit (grams)
USL = 504.0   # Upper Specification Limit (grams)

# ── Scenario A: Centred process ──────────────────────────────────────────────
mu_A = 500.0
sigma_A = 0.9

# Task 1: Generate 200 fill-weight observations from N(mu_A, sigma_A)
# TODO: data_A = rng.normal(mu_A, sigma_A, 200)

# Task 2: Compute Cp for Scenario A
# Cp = (USL - LSL) / (6 * sigma)
# TODO: cp_A = ...

# Task 3: Compute Cpk for Scenario A
# Cpk = min((USL - mu) / (3*sigma), (mu - LSL) / (3*sigma))
# TODO: cpu_A = ...  (upper half)
# TODO: cpl_A = ...  (lower half)
# TODO: cpk_A = min(cpu_A, cpl_A)

# ── Scenario B: Off-centre process (mean shifted to 501) ──────────────────────
mu_B = 501.0
sigma_B = 0.9

# Task 4: Generate 200 observations from N(mu_B, sigma_B)
# TODO: data_B = rng.normal(mu_B, sigma_B, 200)

# Task 5: Compute Cp and Cpk for Scenario B
# Cp does not depend on mu, so cp_B = cp_A
# TODO: cpk_B = min((USL - mu_B) / (3*sigma_B), (mu_B - LSL) / (3*sigma_B))

# Task 6: Print a summary table
# TODO: print Cp and Cpk for both scenarios

# ── Task 7: Plot — two histograms side by side ─────────────────────────────
fig, axes = plt.subplots(1, 2, figsize=(13, 5))

for ax, data, mu, sigma, cp, cpk, label in [
    (axes[0], None, mu_A, sigma_A, None, None, "Scenario A: Centred"),
    (axes[1], None, mu_B, sigma_B, None, None, "Scenario B: Off-centre"),
]:
    # TODO:
    # - Plot histogram of data (use bins=25, density=True)
    # - Overlay fitted normal curve using stats.norm.pdf
    # - Add vertical lines for LSL, USL (red dashed), and mu (blue dotted)
    # - Annotate with Cp and Cpk values using ax.text(...)
    # - Add title, x-label (Fill Weight g), y-label (Density)
    pass

plt.tight_layout()
plt.show()
