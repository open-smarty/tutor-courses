# Task: Six Sigma DPMO Calculator and Performance Curve

## Objective

Implement reusable DPMO and sigma-level functions, reproduce the standard Six Sigma performance table, analyse five real-world processes, and plot the sigma-level vs DPMO reference curve.

## Instructions

1. Open `exercise.py` in the `module-05/lesson-02/` directory.
2. Implement `dpmo(defects, units, opportunities)` returning DPMO as a float.
3. Implement `sigma_level(dpmo_val)` using `scipy.stats.norm.ppf(1 - dpmo_val / 1_000_000) + 1.5`. Handle DPMO = 0 (return 6.0) and DPMO ≥ 1,000,000 (return 0.0).
4. Reproduce the Six Sigma performance table for sigma levels 1 through 6:
   - Compute DPMO from sigma using `(1 - norm.cdf(sigma - 1.5)) × 1,000,000`.
   - Compute yield (%).
   - Verify the round-trip: `sigma_level(dpmo_from_sigma)` ≈ original sigma.
5. Compute DPMO and sigma level for the five processes defined in the exercise, and print a formatted table.
6. Plot the sigma-level vs DPMO reference curve (log x-axis) and overlay the five process points with labels.
7. Add a dashed horizontal line at sigma = 6.0 and save the chart as `module-05-lesson-02-sigma-curve.png`.

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the Six Sigma performance table and the process performance table.
- The sigma vs DPMO chart (saved or displayed).
- A comment identifying which of the five processes is closest to Six Sigma performance and why.
