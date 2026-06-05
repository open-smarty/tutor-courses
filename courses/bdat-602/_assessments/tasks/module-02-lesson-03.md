# Task: Building a Full Preprocessing Pipeline

## Objective

Implement Z-score and Min-Max scaling manually, create dummy variables for a multi-level categorical variable, and assemble a complete `recipes` preprocessing pipeline with imputation, encoding, and normalisation.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Manual scaling**: Compute Z-score scaled `age` and Min-Max scaled `age` without using `recipes`. Verify that Z-score gives mean ≈ 0 and sd ≈ 1, and Min-Max gives min = 0 and max = 1.

3. **Task 2 — Dummy encoding**: Build a minimal recipe with `step_dummy(plan_tier)`. After baking, print the column names. State which level is the reference (dropped) level and explain why it is dropped.

4. **Task 3 — Full pipeline**: Using an 80/20 train/test split (stratified on `churned`), build a recipe with:
   - `step_impute_median()` on `income` and `bmi`
   - `step_impute_mode()` on `plan_tier` and `education`
   - `step_dummy(all_nominal_predictors())`
   - `step_normalize(all_numeric_predictors())`
   
   Prep on the training set, then bake both training and test sets.

5. **Task 4 — Verification**: Confirm that the baked training set has zero missing values. Compute and print the mean and standard deviation of `age` and `income` after baking (both should be ≈ 0 and ≈ 1). List the `plan_tier` dummy column names created.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Your explanation of the dropped reference level (Task 2) must be written as an R comment inside the code chunk.
