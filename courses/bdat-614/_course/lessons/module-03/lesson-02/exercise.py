"""
Module 3, Lesson 2 — Measurement System Analysis (Gauge R&R)
Exercise: Compute variance components and % GR&R from a crossed study.

Requirements: numpy
"""
import numpy as np

# Gauge R&R Data: 4 parts, 3 operators, 2 replicates
# data[operator][part] = [replicate1, replicate2]
data = {
    "Op1": {
        "Part1": [10.1, 10.2],
        "Part2": [9.8,  9.9],
        "Part3": [10.5, 10.4],
        "Part4": [9.6,  9.7],
    },
    "Op2": {
        "Part1": [10.3, 10.4],
        "Part2": [10.0, 10.1],
        "Part3": [10.6, 10.7],
        "Part4": [9.5,  9.6],
    },
    "Op3": {
        "Part1": [10.0, 10.1],
        "Part2": [9.7,  9.8],
        "Part3": [10.3, 10.4],
        "Part4": [9.8,  9.7],
    },
}

operators = list(data.keys())
parts     = list(data["Op1"].keys())
n_ops     = len(operators)       # 3
n_parts   = len(parts)           # 4
n_reps    = 2                    # replicates per cell

# TODO: Step 1 — build a 3D numpy array: measurements[op, part, rep]
measurements = None  # shape: (3, 4, 2)

# TODO: Step 2 — compute cell means (one per operator×part combination)
cell_means = None  # shape: (3, 4)

# TODO: Step 3 — compute repeatability variance (EV²)
# Repeatability = within-cell variance = mean of (variance within each cell)
repeatability_var = None

# TODO: Step 4 — compute reproducibility variance (AV²)
# Operator means: mean over parts and reps for each operator
# AV² = variance between operator means (corrected for sample size)
reproducibility_var = None

# TODO: Step 5 — compute total GR&R variance and process part variance
grr_var     = None  # repeatability_var + reproducibility_var
part_var    = None  # variance between part means (corrected for sample size)
total_var   = None  # sqrt(grr_var + part_var) gives total std dev

# TODO: Step 6 — compute % GR&R
pct_grr = None  # (sqrt(grr_var) / sqrt(total_var)) * 100

# TODO: Step 7 — interpret and print
print("=== Gauge R&R Results ===")
# print(f"Repeatability variance (EV²): {repeatability_var:.6f}")
# print(f"Reproducibility variance (AV²): {reproducibility_var:.6f}")
# print(f"GR&R variance: {grr_var:.6f}")
# print(f"% GR&R: {pct_grr:.1f}%")
# print(f"Interpretation: {'Excellent' if pct_grr < 10 else 'Acceptable' if pct_grr < 30 else 'Unacceptable'}")
