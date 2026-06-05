# Task: Run Chart — Identifying Special-Cause Variation

## Objective

Generate simulated server response time data, plant a special cause, and build a run chart that clearly communicates the process shift to a non-technical audience.

## Instructions

1. Open `exercise.py` in the `module-01/lesson-02/` directory.
2. Generate 50 response time observations with `np.random.normal(245, 15, 50)` using `np.random.seed(42)`.
3. Simulate a process shift at observation 35 by adding 200 ms to observations 35 through 50.
4. Build the run chart:
   - Plot all 50 observations as a connected line.
   - Mark observation 35 with a red marker.
   - Draw a horizontal dashed line at the baseline mean (245 ms) with a legend label.
   - Draw a vertical dashed line at observation 35 with a legend label describing the special cause.
5. Label both axes and add a descriptive title.
6. Add a legend and save or display the chart.
7. In a comment at the bottom of your script, perform a 6M analysis: identify which of the 6M categories the special cause (bad SQL deployment) falls into and explain why.

## Submission

- Completed `exercise.py` with the run chart code.
- The 6M analysis as a comment block at the bottom of the script.
- Console output showing the mean and standard deviation before and after the shift.
