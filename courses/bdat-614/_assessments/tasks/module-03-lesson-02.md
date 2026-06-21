# Task: Measurement System Analysis — Gauge R&R

## Objective

Conduct a full ANOVA-based Gauge R&R analysis on a simulated calliper measurement dataset, estimate variance components, compute %Gauge R&R, and assess whether the measurement system is fit for purpose.

## Instructions

1. Open `exercise.py` in the `module-03/lesson-02/` directory.
2. Simulate the Gauge R&R dataset: 10 parts × 3 operators × 2 replications using the additive model y = 20 + part_effect + operator_effect + error. Use `np.random.seed(614)`, true variances sigma2_part = 0.0120, sigma2_op = 0.0009, sigma2_repeat = 0.0016.
3. Reshape the measurement vector to a (10 × 3 × 2) array and compute part means, operator means, and cell means.
4. Compute the four ANOVA sums of squares: SS_Part, SS_Op, SS_PO (Part × Operator interaction), and SS_Error. Compute degrees of freedom and mean squares. Print a formatted ANOVA table.
5. Estimate variance components using the EMS equations. Apply the max(0, …) floor to prevent negative variance estimates. Print each component alongside the known true value.
6. Compute study variation (5.15 × sigma) for each component. Compute %GRR, %EV, %AV, and %PV as percentages of the 2 mm tolerance. Compute ndc = int(√2 × sigma_PV / sigma_GRR). Print a Gauge R&R summary report with an assessment label (Acceptable / Marginal / Unacceptable).
7. Build a two-panel figure:
   - Panel A: bar chart with four bars (EV, AV, PV, Total GRR) showing study variation in mm. Add a horizontal red dashed line at the tolerance. Label each bar with its percentage.
   - Panel B: scatter plot of all 60 measurements with x-axis = operator (1, 2, 3) with random jitter, y-axis = measurement value, points coloured by part number. Add horizontal lines at LSL and USL.
8. In a comment, explain: if sigma2_AV >> sigma2_EV, what practical steps would you recommend to reduce the measurement system error?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the ANOVA table, variance component estimates, and summary report.
- Two-panel Gauge R&R figure (saved or displayed).
