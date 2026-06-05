"""
BDAT 614 — Module 1, Lesson 2
Exercise: Process Variation — Common Cause vs Special Cause
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(42)

# ============================================================
# Task 1: Generate baseline data with common-cause variation
# ============================================================
# Generate 50 server response times (ms).
# Baseline: mean = 245 ms, standard deviation = 15 ms.
# Use np.random.normal(mean, sd, n_observations).
#
# TODO: create an array called `response_times` with 50 observations
baseline_mean = 245 # ms
baseline_sd = 15 # ms
n = 50
response_times = np.random.normal(baseline_mean, baseline_sd, n)


# ============================================================
# Task 2: Insert a special cause at observation 35
# ============================================================
# A bad SQL query was deployed at observation 35.
# Simulate a process shift: add 200 ms to observations 35 through 50
# (Python index 34 onwards — remember 0-based indexing).
#
# TODO: modify response_times so that observations 35-50 are shifted up by 200 ms
# Hint: response_times[34:] += 200
special_casuse_start = 34
response_times[special_casuse_start:] += 200


# ============================================================
# Task 3: Create a run chart
# ============================================================
# A run chart is simply a line plot of measurements in time order.
#
# Steps:
#   a) Create observation numbers 1 to 50.
#   b) Plot all observations as a connected line (use plt.plot).
#   c) Mark observation 35 with a large red marker (use plt.scatter or plt.plot
#      with a single point, color='red', marker='o', s=100 or markersize=10).
#   d) Draw a horizontal dashed line at the BASELINE mean (245 ms).
#      Label it "Baseline mean = 245 ms".
#   e) Add a vertical dashed line at observation 35 to mark the deployment.
#      Label it "Special cause: bad deployment".
#   f) Label axes: x = "Observation number", y = "Response time (ms)".
#   g) Add a title: "Server Response Times — Run Chart".
#   h) Add a legend and call plt.tight_layout() and plt.show().
#
# TODO: build the run chart
obs_numbers = np.arrange(1, n + 1)

