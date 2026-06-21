"""
BDAT 614 — Module 5, Lesson 3
Exercise: Lean Six Sigma — Waste Elimination and Quality Tools
"""
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict

np.random.seed(614)

# ============================================================
# Process step definitions
# ============================================================
# Each step is a dict with keys:
#   "name"     : str — short description
#   "va"       : bool — True if value-added, False if non-value-added
#   "waste"    : str — TIMWOODS category (or "VA" for value-adding steps)
#   "duration" : float — nominal duration in minutes
#
# The hospital triage example (5 steps) is provided. Add at least 3 more steps
# to extend the process (e.g. documentation, discharge paperwork, billing).

steps = [
    {"name": "Wait in queue",           "va": False, "waste": "Waiting",         "duration": 18.0},
    {"name": "Triage assessment",        "va": True,  "waste": "VA",              "duration":  7.0},
    {"name": "Move to exam room",        "va": False, "waste": "Transport",       "duration":  4.0},
    {"name": "Wait for physician",       "va": False, "waste": "Waiting",         "duration": 25.0},
    {"name": "Physician examination",    "va": True,  "waste": "VA",              "duration": 12.0},
    # TODO: add at least 3 more steps below
    # Examples: documentation, lab test wait, prescription writing, discharge wait
]


# ============================================================
# Task 1: Compute and print process efficiency metrics
# ============================================================
# Compute:
#   - total_time  = sum of all step durations
#   - va_time     = sum of durations where step["va"] is True
#   - nva_time    = sum of durations where step["va"] is False
#   - efficiency  = (va_time / total_time) * 100
#
# Print a summary table (step name, VA/NVA, waste category, duration).
# Print the overall metrics: total lead time, VA time, NVA time, efficiency %.
#
# TODO: compute and print metrics

total_time = None
va_time    = None
nva_time   = None
efficiency = None


# ============================================================
# Task 2: Stacked horizontal bar chart (VA vs NVA by step)
# ============================================================
# Create a horizontal bar chart where each row is one process step.
# Show the VA portion in green and the NVA portion in red.
# Since each step is entirely VA or NVA, each bar is a single colour.
# Order steps chronologically (top = first step).
# Add value labels (duration in min) on each bar.
# Title: "Value Stream: VA vs NVA Time by Step"
# x-label: "Duration (minutes)"
#
# TODO: build the horizontal stacked bar chart


# ============================================================
# Task 3: NVA time by waste category (bar chart)
# ============================================================
# Aggregate total NVA time for each waste category across all steps.
# Plot as a vertical bar chart, sorted descending by total time.
# Colour bars orange. Title: "NVA Time by Waste Category (TIMWOODS)"
# y-label: "Total NVA time (minutes)"
#
# TODO: aggregate by waste category and plot

waste_totals = defaultdict(float)   # fill this in Task 3


# ============================================================
# Task 4: Simulate 100 production cycles
# ============================================================
# For each of 100 simulated cycles:
#   - Sample each step's duration from Normal(mean=step["duration"], sd=0.2*step["duration"]).
#   - Clip each sampled duration to be >= 0.
#   - Compute the total lead time for that cycle as the sum of all step durations.
#
# Store the 100 total lead times in a numpy array `simulated_totals`.
# Plot a histogram (20 bins, colour "steelblue") of simulated_totals.
# Mark the nominal (deterministic) total as a vertical red dashed line.
# Add mean and std to the title.
# x-label: "Total lead time (minutes)", y-label: "Frequency"
# Title: "Simulated Lead Time Distribution (100 cycles)"
#
# TODO: simulate 100 cycles and plot histogram

simulated_totals = None


plt.tight_layout()
plt.show()
