# Task: Lean Value Stream Analysis and Simulation

## Objective

Model a multi-step process as a value stream, quantify VA vs NVA time, visualise waste by category, and simulate lead-time variability across 100 production cycles.

## Instructions

1. Open `exercise.py` in the `module-05/lesson-03/` directory.
2. Extend the provided 5-step hospital triage process with at least 3 additional steps (e.g. documentation, lab result waiting, discharge paperwork). Assign each a realistic duration, VA/NVA flag, and TIMWOODS waste category.
3. Compute total lead time, VA time, NVA time, and process efficiency. Print a formatted table.
4. Build a horizontal bar chart showing each step's duration, coloured green (VA) or red (NVA).
5. Aggregate NVA time by waste category and plot a vertical bar chart sorted by descending total time.
6. Simulate 100 production cycles: sample each step's duration from Normal(mean, sd = 0.2 × mean), clip at zero, and sum across steps. Plot a histogram of the 100 total lead times with a vertical line at the nominal (deterministic) total.
7. Save the combined figure as `module-05-lesson-03-lean-analysis.png`.

## Submission

- Completed `exercise.py` with all tasks implemented and at least 3 added steps.
- Console output showing the step summary table and process efficiency metrics.
- The three-panel chart (value stream bar, waste category bar, simulation histogram).
- A comment answering: which waste category accounts for the most NVA time, and which lean tool would you use first to reduce it?
