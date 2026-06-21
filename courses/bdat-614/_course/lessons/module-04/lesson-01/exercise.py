"""
BDAT 614 — Module 4, Lesson 1
Exercise: Simulating Process Improvement Across PDCA Cycles
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(614)

# ============================================================
# Scenario: A tablet manufacturing line reduces its defect rate
# through successive PDCA cycles.
# Baseline defect rate: 12.0% of tablets fail quality inspection.
# Target defect rate:    2.0% (after all cycles)
# Number of cycles:      8
# ============================================================

BASELINE_DEFECT_RATE = 12.0   # percent
TARGET_DEFECT_RATE   =  2.0   # percent
N_CYCLES             =  8

# ============================================================
# Task 1: Simulate defect rate across PDCA cycles
# ============================================================
# Each PDCA cycle reduces the current defect rate.
# The expected percentage reduction per cycle decreases geometrically:
#   expected_reductions = [3.5, 2.8, 2.0, 1.5, 1.0, 0.8, 0.5, 0.4]  (percentage points)
#
# Add Gaussian noise to each reduction (std = 0.3 pp) to simulate
# real-world variability in improvement outcomes.
# Clamp the defect rate to be >= 0.
#
# Build:
#   cycle_numbers   = [0, 1, 2, ..., 8]  (0 = baseline, 1..8 = after each cycle)
#   defect_rates    = numpy array of length 9 starting at BASELINE_DEFECT_RATE
#
# TODO: define expected_reductions list (8 values as above)
# TODO: initialise defect_rates[0] = BASELINE_DEFECT_RATE
# TODO: loop over 8 cycles:
#         noise = np.random.normal(0, 0.3)
#         reduction = expected_reductions[i] + noise
#         defect_rates[i+1] = max(0, defect_rates[i] - reduction)

expected_reductions = None   # replace with list
cycle_numbers = np.arange(N_CYCLES + 1)
defect_rates  = np.zeros(N_CYCLES + 1)


# ============================================================
# Task 2: Find when the process first meets the target
# ============================================================
# Find the first cycle index (1-based) where defect_rates drops
# to TARGET_DEFECT_RATE or below.
# If it never reaches the target within 8 cycles, set first_target_cycle = None.
#
# TODO: use np.where or a loop to find first_target_cycle

first_target_cycle = None


# ============================================================
# Task 3: Compute cumulative improvement
# ============================================================
# cumulative_improvement[i] = BASELINE_DEFECT_RATE - defect_rates[i]
# This is the total percentage-point reduction achieved so far after cycle i.
#
# TODO: cumulative_improvement = BASELINE_DEFECT_RATE - defect_rates

cumulative_improvement = None


# ============================================================
# Task 4: Print a cycle-by-cycle summary table
# ============================================================
# Print a table with columns: Cycle | Defect Rate (%) | Change (pp) | Cumulative Reduction (pp)
# Cycle 0 row is the baseline (Change = 0.00).
#
# TODO: print the table using a loop or pandas

# ============================================================
# Task 5: Build the two-panel figure
# ============================================================
# Panel A — Defect rate across cycles (line chart):
#   - Plot defect_rates vs cycle_numbers as a steelblue line with circle markers.
#   - Add a horizontal red dashed line at TARGET_DEFECT_RATE.
#   - Label the target line "Target = 2.0%".
#   - If first_target_cycle is not None, annotate that point with a green star marker
#     and a text annotation "Target met (Cycle N)".
#   - Title: "Defect Rate Across PDCA Cycles"
#   - x-label: "Cycle Number", y-label: "Defect Rate (%)"
#   - Add PDCA phase labels along the x-axis as text annotations below each
#     odd cycle number (Cycle 1 = "Plan 1/Do 1", Cycle 2 = "C/A 1→Plan 2", etc.)
#     — or simply annotate cycles 1-8 with small text showing the defect rate value.
#   - Grid on.
#
# Panel B — Cumulative improvement (bar chart):
#   - Bar chart of cumulative_improvement vs cycle_numbers.
#   - Skip cycle 0 (baseline, cumulative = 0) — bars for cycles 1..8.
#   - Colour bars from light green to dark green based on their value
#     (use a colourmap or a simple gradient).
#   - Add a horizontal dashed line at BASELINE_DEFECT_RATE - TARGET_DEFECT_RATE
#     (maximum possible improvement = 10 pp).
#   - Title: "Cumulative Defect Reduction Across Cycles"
#   - x-label: "Cycle Number", y-label: "Total Reduction (percentage points)"
#   - Label each bar with its value (e.g., "+3.6 pp").
#   - Grid on (y-axis only).
#
# TODO: build the two-panel figure

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# --- Panel A ---
# TODO

# --- Panel B ---
# TODO

plt.tight_layout()
plt.show()
