# Task: Production-Ready Preprocessing Pipeline

## Objective

Build a complete, leak-proof preprocessing pipeline that could be deployed to score new policyholders in production.

## Instructions

1. **Split** — Use `initial_split(health_small, prop = 0.75, strata = plan_tier)` to create training and test sets.

2. **Pipeline** — Build a `recipes` pipeline on the training set with all of the following steps in order:
   - `step_impute_median(bmi, income)`
   - `step_mutate()` to add `bmi_missing` and `income_missing` indicators
   - `step_mutate()` to winsorise `bmi` to [10, 60]
   - `step_log(claim_amount, base = 10, offset = 1)`
   - `step_dummy(sex, region, payment_method, employment_type, one_hot = FALSE)`
   - `step_mutate()` to make `plan_tier` an ordered factor (Bronze < Silver < Gold < Platinum)
   - `step_integer(plan_tier)`
   - `step_normalize(all_numeric_predictors())`
   - `step_nzv(all_predictors())`

3. **Apply** — `prep()` on training data only. `bake()` on both training and test sets.

4. **Verify** — Report: (a) number of columns in each output; (b) NAs in each output; (c) mean and SD of `age` in the training output (should be ≈ 0 and ≈ 1).

5. **Leakage check** — The pipeline learned the `bmi` median from training data only. Print `tidy(prep_fit, number = 1)` to show the stored median. Compare it to `median(health_small$bmi, na.rm = TRUE)` — they should be slightly different because the pipeline only saw 75% of the data.

## Submission

Knit your Rmd to HTML with all five sections visible.
