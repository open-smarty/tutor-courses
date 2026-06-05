# Task: Outlier Detection and Treatment

## Objective

Identify outliers in the health insurance dataset using two methods, visualise them, and apply appropriate treatment strategies.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Detection**:
   - Apply the **IQR rule** to `claim_amount` and `bmi`. Compute Q1, Q3, IQR, and both fences. Count and report the number of outliers for each variable.
   - Apply the **Z-score method** (flag `|z| > 3`) to `claim_amount`. Compare the count with the IQR rule result. In a comment, explain which method gives more outliers and why.

3. **Task 2 — Box plots**: Create a `geom_boxplot()` for both `claim_amount` (non-zero values only) and `bmi`. The injected extreme values in `bmi` (values like 120, 150, 200) should appear as individual points beyond the whiskers.

4. **Task 3 — Winsorisation**: Winsorise `claim_amount` at the 1st and 99th percentile by creating a new column `claim_amount_win`. Verify that `max(claim_amount_win)` equals p99.

5. **Task 4 — Log transformation**: Create `log_claim = log(claim_amount + 1)`. Plot side-by-side histograms of the raw and log-transformed claim amounts. Describe the change in distribution shape in a comment.

## Submission

Submit the knitted `exercise.html` and `exercise.Rmd`. Your comparison of IQR vs. Z-score (Task 1) and distribution description (Task 4) must be written as R comments inside their respective code chunks.
