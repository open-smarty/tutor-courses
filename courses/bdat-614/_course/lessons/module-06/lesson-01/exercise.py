"""
BDAT 614 — Module 6, Lesson 1
Exercise: Total Quality Management (TQM) and Cost of Poor Quality (COPQ)
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(614)

# ============================================================
# Baseline COPQ data (medical device manufacturer, annual £)
# ============================================================
copq_baseline = {
    "Prevention":       180_000,
    "Appraisal":        320_000,
    "Internal Failure": 540_000,
    "External Failure": 960_000,
}
annual_revenue = 20_000_000

# ============================================================
# Task 1: Compute and print COPQ summary
# ============================================================
# Compute:
#   total_copq = sum of all four categories
#   copq_pct_revenue = total_copq / annual_revenue * 100
#   For each category: share (%) = category_cost / total_copq * 100
#
# Print a table: Category | Cost (£) | Share (%)
# Print total_copq and copq_pct_revenue below the table.
#
# TODO: compute and print COPQ summary

total_copq = None


# ============================================================
# Task 2: Plot COPQ breakdown — pie chart and bar chart
# ============================================================
# Create a figure with two side-by-side subplots (1 row, 2 columns), figsize=(12, 5).
#
# Left subplot (pie chart):
#   - Explode the largest category (External Failure) slightly (0.05).
#   - Use autopct="%1.1f%%" and startangle=140.
#   - Title: "COPQ Breakdown — PAF Model"
#
# Right subplot (horizontal bar chart):
#   - Bars ordered by cost (largest at top).
#   - Use colours: Prevention=steelblue, Appraisal=mediumseagreen,
#     Internal Failure=orange, External Failure=crimson.
#   - Add cost labels (£ thousands) at the end of each bar.
#   - x-label: "Annual cost (£)", Title: "COPQ by Category"
#
# Save as "module-06-lesson-01-copq-breakdown.png".
#
# TODO: build the two-panel breakdown chart


# ============================================================
# Task 3: Model the prevention vs failure trade-off
# ============================================================
# Model assumptions:
#   - Appraisal cost stays constant at copq_baseline["Appraisal"].
#   - Baseline failure cost = Internal Failure + External Failure from copq_baseline.
#   - As prevention investment increases, failure costs decrease exponentially:
#       failure_cost(p) = baseline_failure * exp(-k * (p / max_prevention))
#       where k = 3.0 and max_prevention = 600_000.
#   - Total COPQ = prevention + appraisal + failure_cost(prevention).
#
# Sweep prevention from 50_000 to 600_000 in steps of 10_000.
# Compute total COPQ at each prevention level.
# Find the prevention level that minimises total COPQ.
#
# Plot:
#   - Total COPQ vs prevention (blue solid line)
#   - Failure cost vs prevention (red dashed)
#   - Prevention cost vs prevention (green dashed, just the diagonal)
#   - Mark the minimum total COPQ point with a star marker
#   - x-label: "Annual prevention investment (£)"
#   - y-label: "Annual cost (£)"
#   - Title: "COPQ Trade-off: Prevention vs Failure Costs"
#   - Add legend and grid.
# Save as "module-06-lesson-01-copq-tradeoff.png".
#
# TODO: model and plot the prevention vs failure trade-off

k = 3.0
max_prevention    = 600_000
baseline_failure  = None   # TODO: set to sum of internal + external failure
prevention_range  = np.arange(50_000, 610_000, 10_000)


