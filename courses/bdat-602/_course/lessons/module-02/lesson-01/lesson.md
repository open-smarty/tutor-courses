# Lesson 3: Diagnosing and Handling Missing Values

## Goal

After this lesson you can classify missing data as MCAR, MAR, or MNAR, choose the right imputation strategy for each mechanism, and implement median, mode, and kNN imputation inside a `recipes` pipeline.

## Concept

### Why missingness matters

Ignoring missing values or handling them carelessly can silently bias your model. Before you impute, you must understand *why* the data is missing — the mechanism determines which imputation method is safe.

### Three missing data mechanisms

Think of a GP who doesn't always record a patient's BMI. The reason could be:

1. **MCAR — Missing Completely At Random**
   The probability that a value is missing is the same for every record, regardless of any observed or unobserved variable:

   $$P(\text{missing} \mid X_{\text{obs}}, X_{\text{miss}}) = P(\text{missing})$$

   Example: a software bug randomly drops 2% of `income` values. Missing rows are a random sample of all rows. *Safe to impute with the mean/median* — the imputed dataset is still an unbiased representation of the full dataset.

2. **MAR — Missing At Random**
   The probability of missingness depends on *observed* variables but not on the missing value itself:

   $$P(\text{missing} \mid X_{\text{obs}}, X_{\text{miss}}) = P(\text{missing} \mid X_{\text{obs}})$$

   Example: patients under 30 are less likely to have BMI recorded because they skip routine check-ups. BMI is missing more often for young people, but for a given age the missingness is random. *Imputation conditioned on observed variables* (e.g., kNN using age and sex) is appropriate.

3. **MNAR — Missing Not At Random**
   The probability of missingness depends on the missing value itself:

   $$P(\text{missing} \mid X_{\text{obs}}, X_{\text{miss}}) \neq P(\text{missing} \mid X_{\text{obs}})$$

   Example: very high earners refuse to disclose income. The higher the income, the more likely it is missing. *Simple imputation is biased* — you will systematically underestimate average income because the highest incomes are absent. Correcting for MNAR requires domain knowledge or specialised models.

### Imputation methods

| Method | Function (recipes) | Best for |
|---|---|---|
| Median imputation | `step_impute_median()` | Numeric, MCAR/MAR, skewed data |
| Mode imputation | `step_impute_mode()` | Categorical, MCAR/MAR |
| kNN imputation | `step_impute_knn(neighbors=5)` | MAR — uses k=5 nearest complete cases as donors |

**kNN imputation step-by-step**: for a record with missing BMI, (1) find the 5 records with the smallest Euclidean distance in the space of *complete* features (age, sex, region); (2) compute the mean BMI of those 5 donors; (3) assign that mean as the imputed value. This preserves correlations between variables — if young males tend to have lower BMI, the imputation respects that.

### Visualising missingness with naniar

```r
library(naniar)
vis_miss(health_data |> select(bmi, income, complaint_notes, days_since_last_claim))
```

`vis_miss()` draws a grid where each cell is coloured black if missing and grey if observed. It also shows the overall proportion missing for each column. `gg_miss_upset()` shows co-occurrence patterns: which columns tend to be missing together.

## Example

```r
library(tidyverse)
library(naniar)
library(tidymodels)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

# Step 1: visualise missingness
vis_miss(health_data |> select(bmi, income, complaint_notes, days_since_last_claim))

# Step 2: what proportion of records have at least one missing value?
n_miss(health_data)           # total missing cells
pct_miss(health_data)         # overall % missing

# Step 3: build an imputation recipe
rec <- recipe(churned ~ age + bmi + income + plan_tier + num_claims, data = health_data) |>
  step_impute_median(income) |>          # income: MCAR/MAR, numeric
  step_impute_knn(bmi, neighbors = 5)    # bmi: MAR (younger policyholders)

rec_prepped <- prep(rec, training = health_data)  # fit imputers on training data only
health_imputed <- bake(rec_prepped, new_data = health_data)

# Verify: no missing values in bmi or income
health_imputed |> summarise(miss_bmi = sum(is.na(bmi)), miss_income = sum(is.na(income)))
```

After imputation, `miss_bmi` and `miss_income` are both 0. Note: `complaint_notes` is not imputed here — text imputation is handled in Module 6 by simply excluding NA rows.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) generate the dataset and visualise missingness with `naniar`, (2) classify each missing variable as MCAR, MAR, or MNAR and justify your reasoning, (3) build a `recipes` pipeline that applies appropriate imputation to `bmi` and `income`, (4) verify imputation success and report remaining missingness.

## Check

```
npm run check -- bdat-602 module-02 lesson-01
```

## Reflection

kNN imputation preserves correlations between variables and is appropriate for MAR data, but it is computationally expensive for 500,000 rows. What practical strategies would you use to make kNN imputation feasible at this scale?
