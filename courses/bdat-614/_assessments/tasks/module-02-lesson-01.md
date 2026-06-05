# Task: Construct an Xbar-R Control Chart

## Objective

Build a complete Xbar-R control chart from simulated subgroup data and identify any out-of-control signals.

## Instructions

1. Open `exercise.py` in the `module-02/lesson-01/` directory.
2. Generate the 25×5 data array using `np.random.normal(500, 1.5, (25, 5))` with `np.random.seed(7)`.
3. Compute subgroup means and ranges using vectorised NumPy operations (`axis=1`).
4. Compute the grand mean x̄̄ and average range R̄.
5. Calculate all six control limits (UCL and LCL for both charts) using the n=5 constants A₂=0.577, D₃=0, D₄=2.114. Print all values.
6. Build the two-panel chart:
   - Top panel: Xbar chart with UCL (red dashed), CL (green dashed), LCL (red dashed).
   - Bottom panel: R chart with UCL, CL, LCL.
   - Out-of-control points (above UCL or below LCL) marked in red on both panels.
7. Label all axes, add titles, and add a legend to each panel.
8. In comments, answer: which panel should you check first, and why?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing x̄̄, R̄, and all six control limit values.
- The two-panel chart (saved or displayed).
