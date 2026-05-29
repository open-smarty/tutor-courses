"""
Module 4, Lesson 2 — DMAIC and Root Cause Analysis Tools
Exercise: Build a Pareto chart and map causes to a Fishbone diagram.

Requirements: numpy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt

# ----- Part 1: Pareto Chart -----
# Software defects found during QA testing of a data application:
defects = {
    "Null handling errors":       120,
    "Schema mismatch":             85,
    "Timeout failures":            60,
    "Duplicate records":           40,
    "Authentication errors":       25,
    "Encoding issues":             15,
    "Configuration errors":         5,
}

# TODO: Step 1 — sort defects from highest to lowest count
sorted_defects = None  # list of (name, count) tuples sorted descending

# TODO: Step 2 — compute cumulative percentages
total = None
cumulative_pct = None  # list of cumulative percentages at each defect category

# TODO: Step 3 — plot the Pareto chart
# Left y-axis: bar chart of counts
# Right y-axis: line chart of cumulative percentage
# Add a horizontal dashed line at 80%
# Title: "Pareto Chart — Software Defects by Type"


# ----- Part 2: Fishbone Diagram (textual) -----
# A data pipeline has "High Rate of Invalid Output Records" as the effect.
# Assign each cause below to the correct 6M bone.
# Choose from: "Man", "Machine", "Material", "Method", "Measurement", "Environment"

causes = [
    {"cause": "Analysts use different data aggregation formulas", "bone": ""},      # TODO
    {"cause": "Input data files contain unexpected special characters", "bone": ""},  # TODO
    {"cause": "The ETL scheduler crashes when server CPU > 90%", "bone": ""},        # TODO
    {"cause": "Data quality checks were not run before loading", "bone": ""},         # TODO
    {"cause": "A new data engineer was not trained on the schema conventions", "bone": ""},  # TODO
    {"cause": "The validation script counts nulls incorrectly", "bone": ""},          # TODO
]

print("=== Part 2: Fishbone Causes ===")
for c in causes:
    print(f"  [{c['bone']:12s}] {c['cause']}")
