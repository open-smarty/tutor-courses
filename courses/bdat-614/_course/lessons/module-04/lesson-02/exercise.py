"""
BDAT 614 — Module 4, Lesson 2
Exercise: DMAIC Root Cause Analysis — Pareto Chart, 5 Whys, Fishbone Diagram
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

np.random.seed(614)

# ============================================================
# Scenario: A beverage bottling line records 1,200 defects
# over four weeks. The quality team is performing the Analyse
# phase of a DMAIC project.
# ============================================================

defect_data = {
    "Underfill":         510,
    "Label misalignment":240,
    "Cap seal failure":  195,
    "Foreign particle":  120,
    "Broken glass":       90,
    "Other":              45,
}

# ============================================================
# Task 1: Compute Pareto statistics
# ============================================================
# a) Sort defect_data by count descending.
#    Use sorted(defect_data.items(), key=lambda x: x[1], reverse=True)
#    Store as two lists: categories (str) and counts (int).
#
# b) Total defects: n_total = sum(counts)
#
# c) Cumulative percentages:
#    cumulative_pct[i] = (sum of counts[0..i]) / n_total * 100
#    Build this with a loop or np.cumsum.
#
# d) Print a formatted Pareto table:
#    Rank | Defect Type | Count | % of Total | Cumulative %
#
# TODO: implement a–d

categories      = None   # list of category names, sorted by count desc
counts          = None   # list of counts (same order)
n_total         = None
cumulative_pct  = None   # numpy array, length = len(categories)


# ============================================================
# Task 2: Build the Pareto chart
# ============================================================
# Use a single Axes with a secondary y-axis (ax.twinx()).
#
# Primary y-axis (left): bar chart of counts, colour "steelblue".
# Secondary y-axis (right): line chart of cumulative_pct, colour "darkorange",
#   markers "o", linewidth=2.
#
# Add a horizontal dashed red line at 80 on the right y-axis.
# Label it "80% threshold".
#
# Find the index where cumulative_pct first crosses 80%. Draw a vertical
# dashed grey line at that x position (x = index + 0.5) to visually
# separate "vital few" from "trivial many".
#
# Annotate each bar with its count value above the bar.
#
# Labels:
#   x-axis: defect category names (rotate 20 degrees, right-aligned)
#   left y-axis: "Frequency (count)"
#   right y-axis: "Cumulative Percentage (%)"
#   title: "Pareto Chart — Bottling Line Defects"
#   legend for bar (Defect Count) and line (Cumulative %).
#
# TODO: build the Pareto chart in a figure of size (10, 6)

fig1, ax1 = plt.subplots(figsize=(10, 6))
ax1_right = ax1.twinx()   # secondary axis for cumulative line

# TODO

plt.tight_layout()
plt.show()


# ============================================================
# Task 3: 5 Whys tree for Underfill defect
# ============================================================
# Represent the 5 Whys causal chain as an ordered list of tuples:
# (why_number, symptom_or_question, answer)
#
# Use the causal chain from the lesson:
# Why 1 → Why did the line produce underfill defects?
#          Answer: The fill-level sensor reported incorrect readings.
# Why 2 → Why did the sensor report incorrect readings?
#          Answer: The sensor calibration had drifted from its reference value.
# Why 3 → Why had the calibration drifted?
#          Answer: Sensor recalibration was overdue by six weeks.
# Why 4 → Why was recalibration overdue?
#          Answer: The sensor was not on the preventive maintenance schedule.
# Why 5 → Why was the sensor absent from the schedule?
#          Answer: The schedule was created before the sensor was installed and never updated.
# Root cause: Maintenance SOP not updated after equipment installation.
#
# TODO: create the list and print a formatted 5 Whys chain with clear arrows
#       (e.g., "Why 1: ... → ...")

five_whys = None   # replace with a list of tuples

# TODO: print the chain


# ============================================================
# Task 4: Fishbone (Ishikawa) diagram in matplotlib
# ============================================================
# Draw a fishbone diagram for the problem: "Underfill Defects on Bottling Line"
#
# Structure:
#   - A horizontal arrow (spine) from left (x=0.1) to right (x=0.9) at y=0.5.
#   - Problem box at the arrow head (x=0.92, y=0.5).
#   - Four main bones at angles (~45°) above and below the spine:
#       Above (left to right):  "Machine", "Method"
#       Below (left to right):  "Material", "Man"
#   - Each main bone has 2–3 sub-cause text labels branching off it.
#
# Suggested bone anchor points along the spine (x values): 0.30, 0.55
# Bone length: ~0.20 units in x, 0.15 units in y.
#
# Use ax.annotate with arrowprops=dict(arrowstyle='->', color='black')
# or ax.plot lines to draw bones.
#
# Sub-causes: use ax.text at appropriate coordinates.
#
# Cause categories and example sub-causes:
#   Machine:  "Sensor drift", "Worn fill nozzle", "Pressure fluctuation"
#   Method:   "No calibration SOP", "Inconsistent fill speed"
#   Material: "Viscosity variation", "Supplier batch inconsistency"
#   Man:      "Inadequate training", "Operator skip checks"
#
# Title: "Fishbone Diagram — Underfill Defects"
# Turn off axis labels and ticks (ax.axis('off')).
#
# TODO: draw the fishbone diagram in a figure of size (13, 7)

fig2, ax2 = plt.subplots(figsize=(13, 7))

# TODO

plt.tight_layout()
plt.show()
