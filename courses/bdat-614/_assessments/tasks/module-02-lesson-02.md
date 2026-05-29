# Task: Module 2, Lesson 2 — Real-Time I-MR Chart Simulation

## Objective

Simulate a real-time streaming I-MR chart that updates as new data arrives.

## Instructions

1. Generate 50 observations of a process using `numpy.random.normal(mean=200, std=5, size=50)`.

2. At observation 35, inject a **special cause**: add 20 to observations 35–40 to simulate a process shift.

3. In a Python file called `task_imr_realtime.py`, implement a function `update_imr(data_so_far)` that:
   - Recomputes x̄, MR̄, and the control limits using all observations seen so far.
   - Returns whether the latest observation is in control or out of control.

4. Run the function for each new observation (simulating a real-time stream) and print a message whenever an out-of-control point is detected.

5. At the end, plot the full I-MR chart showing all 50 observations with the final limits.

## Criteria

- Correct I-MR formulas: 35%
- Special cause correctly injected and detected: 35%
- Real-time update loop works: 15%
- Chart is correctly plotted: 15%
