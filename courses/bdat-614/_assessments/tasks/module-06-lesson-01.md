# Task: COPQ Analysis and Prevention Investment Modelling

## Objective

Quantify the Cost of Poor Quality using the PAF model, visualise the cost breakdown, and model how increasing prevention investment reduces total quality costs.

## Instructions

1. Open `exercise.py` in the `module-06/lesson-01/` directory.
2. Using the provided `copq_baseline` dictionary (Prevention £180k, Appraisal £320k, Internal Failure £540k, External Failure £960k, revenue £20M):
   - Compute total COPQ and each category's percentage share.
   - Print a formatted table: Category | Cost (£) | Share (%).
   - Print total COPQ and COPQ as % of revenue.
3. Build a two-panel figure:
   - Left: pie chart of the four PAF categories, with the External Failure slice exploded slightly.
   - Right: horizontal bar chart sorted by cost, coloured by category (Prevention=steelblue, Appraisal=mediumseagreen, Internal Failure=orange, External Failure=crimson).
   - Save as `module-06-lesson-01-copq-breakdown.png`.
4. Model the prevention vs failure trade-off:
   - Sweep prevention investment from £50k to £600k in steps of £10k.
   - Failure cost = `baseline_failure × exp(−3 × (prevention / 600_000))` where baseline_failure = Internal + External Failure.
   - Appraisal stays constant.
   - Plot total COPQ, failure cost, and prevention cost vs prevention investment on one axes.
   - Mark the minimum total COPQ with a star marker and annotate the optimal prevention level.
   - Save as `module-06-lesson-01-copq-tradeoff.png`.

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the COPQ summary table and the optimal prevention investment level.
- Both charts (breakdown and trade-off) saved or displayed.
- A comment comparing the optimal prevention level to the current baseline prevention spend.
