# Lesson 1: Diagnosing and Handling Missing Values

## Goal

Classify missing values by mechanism (MCAR, MAR, MNAR), count and visualise NAs in the health insurance dataset, and apply three imputation strategies — median, mode, and kNN — using base R and the `recipes` package.

## Concept

### Why Missingness Matters

Before deciding *how* to handle missing data you must understand *why* it is missing. The mechanism determines the safe remedy:

| Mechanism | Definition | Safe remedy |
|-----------|-----------|-------------|
| **MCAR** — Missing Completely At Random | Missingness is unrelated to any variable | Deletion or imputation both acceptable |
| **MAR** — Missing At Random | Missingness depends on *observed* variables | Imputation (kNN, model-based) |
| **MNAR** — Missing Not At Random | Missingness depends on the *missing value itself* | Flag + domain knowledge required |

In our dataset:
- `bmi` (~5 % missing) — likely **MAR**: patients who never visit a GP may not have a recorded BMI
- `income` (~4 % missing) — likely **MNAR**: people who refuse to disclose income tend to have unusual incomes
- `complaint_notes` (~10 % missing) — **MNAR by design**: only policyholders who complained have a value

---

### Counting and Visualising NAs

```r
# Count NAs per column, sorted
colSums(is.na(health_small)) |>
  sort(decreasing = TRUE) |>
  (\(x) x[x > 0])()

# As a percentage
round(colMeans(is.na(health_small)) * 100, 2) |>
  sort(decreasing = TRUE) |>
  (\(x) x[x > 0])()

# Visual map
library(DataExplorer)
plot_missing(health_small)
```

---

### Simple Imputation — Median, Mode, and Flags

Always add a **binary missingness indicator** alongside any imputed numeric variable so downstream models can learn from the pattern of missingness:

```r
library(dplyr)

bmi_median    <- median(health_small$bmi,    na.rm = TRUE)
income_median <- median(health_small$income, na.rm = TRUE)

health_clean <- health_small |>
  mutate(
    bmi_missing    = as.integer(is.na(bmi)),
    income_missing = as.integer(is.na(income)),
    bmi            = if_else(is.na(bmi),    bmi_median,    bmi),
    income         = if_else(is.na(income), income_median, income)
  )

# Categorical → mode (helper from R/utils.R)
source("R/utils.R")
health_clean <- health_clean |>
  mutate(
    employment_type = if_else(
      is.na(employment_type),
      get_mode(employment_type),
      employment_type
    )
  )
```

Why median (not mean) for numeric variables? Median is robust to skew and outliers. Income is right-skewed — the mean is pulled upward by a few very large values.

---

### kNN Imputation with recipes

Median imputation gives every missing value the *same* number regardless of context. **kNN imputation** finds the *k* most similar complete records and averages their values — far more accurate when data is MAR.

**Critical rule:** always use `recipes` so the *k* neighbours are identified from training data only. Fitting on the whole dataset causes data leakage.

```r
library(recipes)

impute_recipe <- recipe(claim_amount ~ ., data = health_small) |>
  step_impute_knn(
    bmi,
    neighbors   = 5,
    impute_with = imp_vars(age, sex, region, employment_type, plan_tier)
  ) |>
  step_impute_median(income)

impute_prep    <- prep(impute_recipe, training = health_small)
health_imputed <- bake(impute_prep, new_data = health_small)

summary(health_imputed$bmi)
```

The `recipe()` → `prep()` → `bake()` workflow:
- `recipe()` — define the blueprint (no computation yet)
- `prep()` — learn parameters from training data (e.g. the 5 nearest neighbours for each NA)
- `bake()` — apply to training set, test set, or new data

## Example

```r
library(dplyr)

# Verify imputation succeeded
colSums(is.na(health_clean[, c("bmi", "income")]))
# bmi    income
#   0         0
```

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Count the number of NAs in `bmi`, `income`, and `complaint_notes` using `colSums(is.na(...))`.
2. Impute `bmi` with the median and add a `bmi_missing` indicator column. Verify with `colSums(is.na(...))`.
3. Build a `recipes` pipeline that applies `step_impute_median()` to `income`. `prep()` and `bake()` it on `health_small`. Confirm no NAs remain in `income`.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-02 lesson-01
```

## Reflection

Your colleague proposes to impute missing income values with the mean income across all policyholders. Identify two problems with this approach and explain which alternative you would recommend.
