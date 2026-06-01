# Task: Comprehensive Missing Value Audit

## Objective

Perform a full missing value audit on `health_small` and implement appropriate imputation strategies for all affected columns.

## Instructions

In your exercise Rmd, complete the following:

1. **Audit** — Use `colSums(is.na(health_small))` to list all columns with missing values. For each column, state whether the mechanism is likely MCAR, MAR, or MNAR, and justify your answer in a comment (one sentence per column).

2. **Implement imputation** — Construct a single `recipes` pipeline that:
   - Imputes `bmi` with kNN (k = 5, using `age`, `sex`, `plan_tier` as predictor variables)
   - Imputes `income` with the median and adds an `income_missing` indicator
   - For `complaint_notes`: do not impute the text, but add a binary `has_complaint` column (1 if not NA, 0 if NA)

3. **Verify** — After `prep()` and `bake()`, confirm that `bmi` and `income` have 0 NAs.

4. **Comparison** — Compare `summary(health_small$bmi)` to `summary(baked$bmi)`. Has the mean or median changed? Why or why not?

## Submission

Knit your Rmd to HTML. All four sections must appear with code and output.
