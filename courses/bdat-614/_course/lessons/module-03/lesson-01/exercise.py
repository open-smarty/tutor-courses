"""
Module 3, Lesson 1 — Process Capability Analysis
Exercise: Compute Cp and Cpk, and plot a capability histogram.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

# Shaft diameters (mm) from 80 parts
np.random.seed(42)
diameters = np.random.normal(loc=20.15, scale=0.18, size=80)

# Specification limits
LSL = 19.5
USL = 20.5

# TODO: Step 1 — compute the sample mean and standard deviation
mu = None
sigma = None

# TODO: Step 2 — compute Cp
Cp = None

# TODO: Step 3 — compute Cpk
Cpk = None

# TODO: Step 4 — interpret Cpk
def interpret_capability(cpk_value):
    """Return a string interpretation of the Cpk value."""
    pass  # TODO: return "Excellent", "Marginal", or "Not capable"

# TODO: Step 5 — print results
print("=== Process Capability Analysis ===")
# print(f"Mean (μ): {mu:.4f} mm")
# print(f"Std Dev (σ): {sigma:.4f} mm")
# print(f"Cp:  {Cp:.3f}")
# print(f"Cpk: {Cpk:.3f}  → {interpret_capability(Cpk)}")

# TODO: Step 6 — plot a histogram with LSL, USL, and mean marked
# Add vertical lines for LSL, USL, and mean
# Title the plot "Capability Histogram — Shaft Diameter"
