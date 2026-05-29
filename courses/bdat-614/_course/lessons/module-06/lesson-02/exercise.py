"""
Module 6, Lesson 2 — Big Data SQC: EWMA and CUSUM Charts
Exercise: Implement EWMA and CUSUM and compare detection speed.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(42)

# Process parameters
mu0   = 100.0   # target mean
sigma = 5.0     # known process std dev
n_obs = 150     # total observations
shift_at = 50   # shift begins at observation 50
shift_size = 3.0  # mean shifts from 100 to 103 (a 0.6σ shift)

# Simulate observations: in-control, then a small upward shift
in_control = np.random.normal(mu0, sigma, shift_at)
shifted    = np.random.normal(mu0 + shift_size, sigma, n_obs - shift_at)
data = np.concatenate([in_control, shifted])

# ----- EWMA Chart -----
lam = 0.2    # smoothing parameter
L   = 3.0    # control limit multiplier

# TODO: Compute EWMA values
ewma = np.zeros(n_obs)
ewma[0] = data[0]
# for i in range(1, n_obs):
#     ewma[i] = lam * data[i] + (1 - lam) * ewma[i-1]

# TODO: Compute asymptotic UCL and LCL
ewma_ucl = None
ewma_lcl = None

# ----- CUSUM Chart -----
K = shift_size / (2 * sigma)   # reference value (K = δ/2 in sigma units, scaled)
H = 4.0 * sigma                # decision interval

# TODO: Compute upper (C_plus) and lower (C_minus) CUSUM statistics
c_plus  = np.zeros(n_obs)
c_minus = np.zeros(n_obs)
# for i in range(1, n_obs):
#     c_plus[i]  = max(0, c_plus[i-1]  + (data[i] - mu0 - K))
#     c_minus[i] = max(0, c_minus[i-1] - (data[i] - mu0 - K))

# TODO: Find detection times
ewma_detection   = None  # first obs where ewma exceeds ewma_ucl or drops below ewma_lcl
cusum_detection  = None  # first obs where c_plus > H or c_minus > H

# TODO: Print detection results
print("=== Detection Comparison ===")
print(f"Shift injected at observation: {shift_at}")
# print(f"EWMA detected shift at observation: {ewma_detection}")
# print(f"CUSUM detected shift at observation: {cusum_detection}")

# TODO: Plot both charts in two subplots
