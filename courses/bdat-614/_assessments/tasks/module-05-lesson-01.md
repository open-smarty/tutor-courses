# Task: Acceptance Sampling Plan Design and OC Curve Analysis

## Objective

Implement and compare three single sampling plans, compute producer and consumer risks, and construct OC curves to visualise how each plan discriminates between acceptable and unacceptable lots.

## Instructions

1. Open `exercise.py` in the `module-05/lesson-01/` directory.
2. Define the quality benchmarks AQL = 0.01 and LTPD = 0.06.
3. For each of the three plans — (n=50, c=2), (n=100, c=2), (n=100, c=4) — use `scipy.stats.binom.cdf(c, n, p)` to compute P(accept) across p values from 0 to 0.20.
4. Print a formatted risk table with columns: Plan | P(acc|AQL) | α | P(acc|LTPD) | β.
5. Plot all three OC curves on the same axes with:
   - A vertical dashed line at AQL and at LTPD.
   - Horizontal reference lines at P(accept) = 0.95 (1-α target) and P(accept) = 0.10 (β target).
   - Legend, grid, and labelled axes.
6. Save the chart as `module-05-lesson-01-oc-curves.png`.
7. In comments, answer: which of the three plans best satisfies α ≤ 0.05 and β ≤ 0.10 simultaneously?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the risk table for all three plans.
- The OC curve chart (saved or displayed).
- Written answer identifying the plan that best meets both risk targets.
