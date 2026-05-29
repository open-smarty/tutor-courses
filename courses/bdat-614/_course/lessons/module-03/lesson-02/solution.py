"""
Module 3, Lesson 2 — Gauge R&R (Solution)
Uses the Average and Range method simplified for this dataset.
"""
import numpy as np

data = {
    "Op1": {"Part1": [10.1, 10.2], "Part2": [9.8, 9.9],  "Part3": [10.5, 10.4], "Part4": [9.6, 9.7]},
    "Op2": {"Part1": [10.3, 10.4], "Part2": [10.0, 10.1], "Part3": [10.6, 10.7], "Part4": [9.5, 9.6]},
    "Op3": {"Part1": [10.0, 10.1], "Part2": [9.7, 9.8],  "Part3": [10.3, 10.4], "Part4": [9.8, 9.7]},
}

operators = list(data.keys())
parts     = list(data["Op1"].keys())
n_ops, n_parts, n_reps = 3, 4, 2

measurements = np.array([[data[op][p] for p in parts] for op in operators])
# shape: (3 ops, 4 parts, 2 reps)

cell_means = measurements.mean(axis=2)  # (3, 4)

# Repeatability: average within-cell variance
cell_vars = measurements.var(axis=2, ddof=1)
repeatability_var = cell_vars.mean()

# Operator means
op_means = cell_means.mean(axis=1)  # (3,)
# Reproducibility: variance between operator means, corrected
reproducibility_var = max(0, op_means.var(ddof=1) / (n_parts * n_reps) - repeatability_var / (n_parts * n_reps))

# Part variation
part_means = cell_means.mean(axis=0)  # (4,)
part_var = max(0, part_means.var(ddof=1) - repeatability_var / (n_ops * n_reps))

grr_var   = repeatability_var + reproducibility_var
total_var = grr_var + part_var

sigma_grr   = np.sqrt(grr_var)
sigma_total = np.sqrt(total_var)
pct_grr     = (sigma_grr / sigma_total) * 100 if sigma_total > 0 else 0

interpretation = "Excellent" if pct_grr < 10 else ("Acceptable" if pct_grr < 30 else "Unacceptable")

print("=== Gauge R&R Results ===")
print(f"Repeatability variance (EV²):   {repeatability_var:.6f}")
print(f"Reproducibility variance (AV²): {reproducibility_var:.6f}")
print(f"GR&R variance:                  {grr_var:.6f}")
print(f"Part variance:                  {part_var:.6f}")
print(f"Total variance:                 {total_var:.6f}")
print(f"\n% GR&R = {pct_grr:.1f}%  → {interpretation}")
if pct_grr >= 30:
    print("Action: Improve the measurement system before using it for SPC or capability analysis.")
elif pct_grr >= 10:
    print("Action: Use with caution. Investigate if repeatability or reproducibility is the dominant source.")
