# Lesson 3: Scaling, Encoding, and the recipes Pipeline

## Goal

Apply Z-score, Min-Max, and Robust scaling to numeric variables, encode categorical variables as dummy or ordinal integers, and assemble all preprocessing steps into a single leak-proof `recipes` pipeline.

## Concept

### Why Scaling Matters

Distance-based algorithms (k-means, kNN, PCA, SVM, Ridge/LASSO) are sensitive to variable scale. Age ranges from 18 to 85; income from a few thousand to millions. Without scaling, income completely dominates any Euclidean distance calculation and age becomes irrelevant.

Algorithms **not** affected by scale: decision trees, random forests, naïve Bayes, association rules.

| Method | Formula | Range | Robust to outliers? |
|--------|---------|-------|-------------------|
| **Z-score** | $(x - \bar{x}) / s$ | $(-\infty, +\infty)$ | No |
| **Min-Max** | $(x - x_{\min}) / (x_{\max} - x_{\min})$ | $[0, 1]$ | No |
| **Robust** | $(x - \text{median}) / \text{IQR}$ | $(-\infty, +\infty)$ | Yes |

Use Robust scaling when the variable has not been winsorised.

```r
library(recipes)

num_vars <- c("age", "bmi", "income", "premium", "deductible",
              "coverage_amount", "policy_age_months",
              "num_chronic_conditions", "num_visits",
              "num_prescriptions", "num_hospital_admissions",
              "num_claims", "avg_past_claim", "claim_amount",
              "app_logins_monthly", "support_calls")

scale_rec   <- recipe(~ ., data = health_small) |>
  step_normalize(all_of(num_vars))  # Z-score

scale_prep   <- prep(scale_rec, training = health_small)
health_scaled <- bake(scale_prep, new_data = health_small)

# Verify: mean ≈ 0, sd ≈ 1
health_scaled |>
  select(age, bmi, income) |>
  summarise(across(everything(), list(mean = mean, sd = sd)))
```

---

### Encoding Categorical Variables

Most algorithms require numeric input. Assigning integers (1, 2, 3, …) to nominal variables implies a false ordering.

| Variable type | Encoding | `recipes` step |
|--------------|---------|---------------|
| Nominal (sex, region) | One-hot / dummy (k-1 columns) | `step_dummy()` |
| Ordinal (education, plan_tier) | Integer preserving order | `step_integer()` |
| High-cardinality nominal | Target encoding | `step_lencode_*()` |

```r
encode_rec <- recipe(claim_amount ~ ., data = health_small) |>
  step_dummy(sex, region, payment_method, employment_type,
             one_hot = FALSE) |>    # k-1 columns (avoids dummy trap)
  step_mutate(
    education = factor(education,
                       levels = c("None", "Primary", "Secondary",
                                   "Tertiary", "Postgraduate"),
                       ordered = TRUE),
    plan_tier = factor(plan_tier,
                       levels = c("Bronze", "Silver", "Gold", "Platinum"),
                       ordered = TRUE)
  ) |>
  step_integer(education, plan_tier) |>
  step_nzv(all_predictors())   # drop near-zero variance columns
```

---

### The Complete Preprocessing Pipeline

Ad-hoc preprocessing causes **data leakage** (imputing using whole-dataset mean before splitting), is hard to reproduce, and cannot be applied to new data. The `recipes` pipeline solves all three problems.

```r
library(tidymodels)

set.seed(602)
split      <- initial_split(health_small, prop = 0.75, strata = plan_tier)
train_data <- training(split)
test_data  <- testing(split)

prep_recipe <- recipe(claim_amount ~ ., data = train_data) |>
  # 1. Imputation
  step_impute_median(bmi, income) |>
  step_mutate(bmi_missing    = as.integer(is.na(bmi)),
              income_missing = as.integer(is.na(income))) |>
  # 2. Outlier treatment
  step_mutate(
    bmi    = pmax(10, pmin(60, bmi)),
    income = pmax(quantile(income, 0.01, na.rm = TRUE),
                  pmin(quantile(income, 0.99, na.rm = TRUE), income))
  ) |>
  # 3. Log-transform skewed variables
  step_log(income, claim_amount, base = 10, offset = 1) |>
  # 4. Encode categoricals
  step_dummy(sex, region, payment_method, employment_type) |>
  step_mutate(
    education = factor(education,
                       levels = c("None","Primary","Secondary",
                                   "Tertiary","Postgraduate"),
                       ordered = TRUE),
    plan_tier = factor(plan_tier,
                       levels = c("Bronze","Silver","Gold","Platinum"),
                       ordered = TRUE)
  ) |>
  step_integer(education, plan_tier) |>
  # 5. Scale
  step_normalize(all_numeric_predictors()) |>
  # 6. Remove redundancy
  step_nzv(all_predictors()) |>
  step_corr(all_numeric_predictors(), threshold = 0.95)

prep_fit        <- prep(prep_recipe, training = train_data)
train_processed <- bake(prep_fit, new_data = NULL)
test_processed  <- bake(prep_fit, new_data = test_data)
```

The `test_processed` object uses the exact same transformations as `train_processed` (same medians, same dummy levels, same scale factors) — derived only from training data.

## Example

```r
cat("Columns after pipeline:", ncol(train_processed), "\n")
cat("NAs remaining:", sum(colSums(is.na(train_processed))), "\n")

# Means ≈ 0, SDs ≈ 1 for scaled columns
train_processed |>
  select(where(is.numeric)) |>
  select(1:3) |>
  summarise(across(everything(), list(mean = mean, sd = sd)))
```

## Task

Open `exercise.Rmd` and complete the two marked chunks:

1. Build a `recipes` pipeline on `health_small` that: (a) imputes `bmi` and `income` with their medians, (b) dummy-encodes `sex` and `region`, (c) Z-score normalises all numeric predictors. `prep()` and `bake()` it. Confirm the result has no NAs and that `mean(bmi) ≈ 0`.
2. Check how many columns the pipeline produces. Report any columns dropped by `step_nzv()` if you add it.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-02 lesson-03
```

## Reflection

Why must `step_normalize()` come *after* `step_impute_median()` in the pipeline — not before? What would happen to the imputed values if the order were reversed?
