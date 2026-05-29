"""
Module 5, Lesson 3 — Lean Six Sigma: Waste Elimination
Exercise: Classify process steps, compute cycle efficiency, and identify wastes.

Requirements: (no external libraries needed)
"""

# ----- Part 1: Value Stream Analysis -----
# Each step has a name, time in minutes, and a classification to fill in.
# VA = Value-Adding, NVA = Non-Value-Adding, NNVA = Non-Value-Adding but Necessary

process_steps = [
    {"step": "Receive raw data files from vendor", "time_min": 2,   "classification": ""},  # TODO
    {"step": "Data sits in landing zone waiting for batch job", "time_min": 90, "classification": ""},  # TODO
    {"step": "Run schema validation checks", "time_min": 5,  "classification": ""},  # TODO
    {"step": "Manual data quality review by analyst", "time_min": 45, "classification": ""},  # TODO
    {"step": "Transform and normalise data", "time_min": 10, "classification": ""},  # TODO
    {"step": "Load into staging database", "time_min": 3,  "classification": ""},  # TODO
    {"step": "Generate intermediate report nobody uses", "time_min": 20, "classification": ""},  # TODO
    {"step": "Load into production warehouse", "time_min": 4,  "classification": ""},  # TODO
    {"step": "Wait for approval before publishing dashboard", "time_min": 60, "classification": ""},  # TODO
    {"step": "Publish dashboard to stakeholders", "time_min": 2,  "classification": ""},  # TODO
]

# TODO: Compute process cycle efficiency = VA time / total time * 100
total_time = None
va_time    = None
pce        = None

# ----- Part 2: 8 Lean Wastes -----
# For each NVA step above, identify which Lean waste category it belongs to.
# Choose from: "Transportation", "Inventory", "Motion", "Waiting",
#              "Overproduction", "Overprocessing", "Defects", "Unused Talent"

nva_waste_mapping = {
    "Data sits in landing zone waiting for batch job": "",   # TODO
    "Manual data quality review by analyst":           "",   # TODO
    "Generate intermediate report nobody uses":        "",   # TODO
    "Wait for approval before publishing dashboard":   "",   # TODO
}

# TODO: Print results
print("=== Value Stream Analysis ===")
# print each step with its classification and time
# print total time, VA time, and PCE%

print("\n=== Lean Waste Classification ===")
# print each NVA step with its waste category
