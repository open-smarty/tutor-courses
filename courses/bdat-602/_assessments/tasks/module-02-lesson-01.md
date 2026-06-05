# Task: Missing Value Diagnosis and Imputation Pipeline

## Objective

Diagnose the missing data mechanisms in the health insurance dataset and build a leak-proof imputation pipeline using `recipes`.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Visualise**: Use `naniar::vis_miss()` on at least four columns with known missingness (`bmi`, `income`, `complaint_notes`, `days_since_last_claim`). Report total missing cells and overall percentage using `n_miss()` and `pct_miss()`.

3. **Task 2 — Classify**: For each of the four variables above, state whether the mechanism is MCAR, MAR, or MNAR and write a one-sentence justification grounded in the data-generating process (i.e., *why* would data be missing in that way in a real insurance context?).

4. **Task 3 — Imputation pipeline**:
   - Split `health_data` into 80% training / 20% test using `initial_split(strata = churned)`.
   - Build a `recipe()` with `churned` as the outcome and `age`, `bmi`, `income`, `plan_tier`, `num_claims` as predictors.
   - Apply `step_impute_median(income)` and `step_impute_knn(bmi, neighbors = 5)`.
   - `prep()` on the training set; `bake()` on both training and test sets.

5. **Task 4 — Verify**: Confirm that `bmi` and `income` have zero missing values in both imputed sets. Compare the BMI median before and after imputation and comment on any difference.

## Submission

Submit the knitted `exercise.html` and the source `exercise.Rmd`. Task 2 justifications must be written as R comments inside the code chunk, not as free text in the markdown narrative.
