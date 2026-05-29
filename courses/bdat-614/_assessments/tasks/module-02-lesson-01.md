# Task: Module 2, Lesson 1 — Build an Xbar-R Chart for a Real Dataset

## Objective

Apply Xbar-R charting to a dataset of your choice and interpret the results.

## Instructions

1. Find or create a dataset of at least 15 subgroups with n = 4 or n = 5 measurements per subgroup. This can be:
   - A manufacturing dataset (part dimensions, fill weights, etc.)
   - A server performance metric (response times sampled every hour in groups of 5)
   - A generated dataset using `numpy.random.normal()`

2. In a Python file called `task_xbar_r.py`:
   - Compute subgroup means and ranges.
   - Compute and print x̄̄, R̄, UCL, LCL for both the Xbar and R charts.
   - Plot both charts with proper labels.
   - Apply **at least one** Western Electric run rule and highlight any signals.

3. Write a short interpretation (as comments or a printed paragraph) answering:
   - Is the process in control?
   - Which subgroups, if any, triggered an out-of-control signal?
   - What action would you recommend?

## Criteria

- Correct computation of control limits: 40%
- Correct chart with labeled UCL, CL, LCL: 30%
- At least one run rule applied: 15%
- Written interpretation is correct and clear: 15%
