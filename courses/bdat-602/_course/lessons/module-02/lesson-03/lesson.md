# Lesson 5: Scaling, Encoding, and the recipes Pipeline

## Goal

After this lesson you can choose and implement the right scaling method for a given variable, encode categorical variables without introducing data leakage, and assemble a complete `recipes` preprocessing pipeline.

## Concept

### Why scaling matters

Many algorithms — k-means clustering, kNN, PCA, regularised regression — compute distances or inner products between feature vectors. If `income` ranges from 0 to 200,000 while `age` ranges from 18 to 85, the income dimension will dominate the distance calculation simply because its scale is larger. Scaling puts variables on a common footing.

### Three scaling methods

**Z-score standardisation** (most common):

$$z = \frac{x - \mu}{\sigma}$$

After this transformation every variable has mean 0 and standard deviation 1. It preserves the shape of the distribution (skew, outliers) but changes the location and scale. In `recipes`: `step_normalize()`.

**Numeric example**: suppose `income` has $\mu = 42{,}000$ and $\sigma = 28{,}000$. An income of $70{,}000$ becomes $z = (70000 - 42000) / 28000 = 1.0$. An income of $14{,}000$ becomes $z = (14000 - 42000) / 28000 = -1.0$.

**Min-Max scaling**:

$$x' = \frac{x - x_{\min}}{x_{\max} - x_{\min}}$$

Result is always in $[0, 1]$. Preserves the relative distances between points. *Sensitive to outliers*: if one BMI value is 200 (a data entry error), $x_{\max} = 200$ and all genuine BMI values get compressed into a narrow band near 0. In `recipes`: `step_range()`.

**Robust scaling**:

$$x' = \frac{x - \text{median}}{\text{IQR}}$$

Uses the median (not the mean) and the IQR (not the standard deviation), so it is resistant to outliers. Good default when you have not yet cleaned outliers. No direct step in `recipes`; implement with `step_mutate()`.

### Encoding categorical variables

**One-hot / dummy encoding**: convert a categorical variable with $k$ categories into $k-1$ binary columns (drop one to avoid perfect multicollinearity — the "dummy variable trap"). Example: `plan_tier` has 4 levels (Bronze, Silver, Gold, Platinum) → 3 binary columns: `plan_tier_Silver`, `plan_tier_Gold`, `plan_tier_Platinum`. "Bronze" is the reference level, coded as all zeros. In `recipes`: `step_dummy(all_nominal_predictors())`.

**Why $k-1$ and not $k$?** If you include all $k$ columns, they sum to 1 in every row (exactly one category is active). This introduces perfect multicollinearity (the rank of the design matrix drops by 1), making OLS coefficients non-unique. Dropping one column breaks this linear dependence.

**Ordinal encoding**: when a categorical variable has a natural order — e.g., `education` = None < Primary < Secondary < Tertiary < Postgraduate — you can map it to integers 1, 2, 3, 4, 5. Use `step_ordinalscore()` or `step_mutate()`. Do not use this for unordered variables like `region` (it implies Europe > Africa, which is meaningless).

### The recipe workflow: why order matters

```
recipe(outcome ~ predictors, data = training_data) |>
  step_impute_median(all_numeric_predictors()) |>   # 1. fix NAs first
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |>           # 2. encode (now all numeric)
  step_normalize(all_numeric_predictors())          # 3. scale
```

**Rule**: impute before encoding, encode before scaling. If you scale before encoding, your new dummy variables get incorrectly scaled (they are 0/1 — do not need scaling, but `step_normalize()` would change them).

`prep(rec, training = train)` fits every step on the training data and records the learned statistics (means, standard deviations, quantiles, dummy levels). `bake(rec_prepped, new_data = test)` applies those *training-set statistics* to the test set. This is what prevents data leakage.

## Example

```r
library(tidyverse)
library(tidymodels)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

set.seed(602)
split <- initial_split(health_data, prop = 0.80, strata = churned)
train <- training(split)
test  <- testing(split)

rec <- recipe(churned ~ age + bmi + income + plan_tier + education + num_claims, data = train) |>
  step_impute_median(income, bmi) |>
  step_impute_mode(plan_tier, education) |>
  step_dummy(all_nominal_predictors()) |>
  step_normalize(all_numeric_predictors())

rec_prepped  <- prep(rec, training = train)
train_baked  <- bake(rec_prepped, new_data = train)
test_baked   <- bake(rec_prepped, new_data = test)

# Inspect: all numeric, no NAs, dummy columns present
glimpse(train_baked)
```

After baking, `plan_tier` is gone and replaced by `plan_tier_Silver`, `plan_tier_Gold`, `plan_tier_Platinum`. All numeric predictors have mean ≈ 0 and sd ≈ 1.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) manually compute Z-score and Min-Max scaled versions of `age`; (2) create dummy variables for `plan_tier` using `step_dummy()` and verify the number of new columns; (3) build a full pipeline with imputation, encoding, and normalisation; (4) confirm the baked training set has no missing values and all numeric predictors are scaled.

## Check

```
npm run check -- bdat-602 module-02 lesson-03
```

## Reflection

The `recipes` framework separates *specification* (the recipe) from *fitting* (prep) and *application* (bake). Why is this three-step separation important for cross-validation, where the same preprocessing must be applied independently across each fold?
