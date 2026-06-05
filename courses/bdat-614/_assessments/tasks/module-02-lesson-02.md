# Task: Build an I-MR Chart for API Response Times

## Objective

Implement an Individuals and Moving Range control chart from scratch, simulate a process shift, and verify that the chart detects the shift.

## Instructions

1. Open `exercise.py` in the `module-02/lesson-02/` directory.
2. Generate 30 individual observations using `np.random.normal(245, 18, 30)` with `np.random.seed(13)`.
3. Apply a process shift: add 60ms to observations 22 through 30 (index 21 onwards).
4. Compute the moving range using `np.abs(np.diff(x))`. Compute MR̄ and x̄.
5. Calculate all limits using the constants d₂ = 1.128 and D₄ = 3.267. Print all values.
6. Build the two-panel chart:
   - Top panel: I chart (individual values vs observation number).
   - Bottom panel: MR chart (moving range vs observation number, starting at obs 2).
   - Both panels: UCL (red dashed), CL (green dashed), LCL (red dashed).
   - Out-of-control points highlighted in red on both panels.
7. Label axes, add titles, and add a legend.
8. In a comment at the bottom of your script, note which observation number first triggers an out-of-control signal on the I chart.

## Submission

- Completed `exercise.py`.
- Console output showing x̄, MR̄, and all control limits.
- The two-panel I-MR chart.
