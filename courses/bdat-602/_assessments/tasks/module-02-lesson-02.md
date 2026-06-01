# Task: Outlier Analysis and Treatment Report

## Objective

Detect, classify, and treat outliers in the health insurance dataset, then document your treatment decisions.

## Instructions

In your exercise Rmd, complete the following:

1. **Detection** — Apply the IQR rule to `bmi`, `income`, and `claim_amount`. For each variable, count and report the number of outliers flagged. Produce side-by-side box plots using `patchwork` (or base R `par(mfrow)`).

2. **Treatment decisions** — For each variable, choose and justify one treatment:
   - `bmi`: biological plausibility range [10, 60] — use `pmax(10, pmin(60, bmi))`
   - `income`: winsorise to the 1st–99th percentile
   - `claim_amount`: do NOT remove — these are potential fraud signals; add a `high_claim_flag` column for claims above the 99th percentile

3. **Transformation** — Apply `log1p()` to `claim_amount` (for rows where `claim_amount > 0`). Produce a side-by-side histogram (raw vs log1p). Comment on the shape change.

4. **Summary table** — Create a data frame summarising your treatment decisions:

| Variable | Outliers flagged | Treatment chosen | Reason |
|---|---|---|---|
| bmi | ... | Winsorise [10, 60] | ... |
| income | ... | Winsorise 1–99 pct | ... |
| claim_amount | ... | Flag + log-transform | ... |

## Submission

Knit your Rmd to HTML. The summary table must appear as a formatted markdown table.
