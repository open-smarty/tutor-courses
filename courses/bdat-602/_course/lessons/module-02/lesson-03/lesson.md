# Lesson 5: Scaling, Encoding, PCA, and the recipes Pipeline

## Goal

After this lesson you can choose and implement the right scaling method for a given variable, encode categorical variables without introducing data leakage, apply PCA to reduce dimensionality and visualise high-dimensional data, and assemble a complete `recipes` preprocessing pipeline.

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
  step_normalize(all_numeric_predictors()) |>       # 3. scale
  step_pca(all_numeric_predictors(), num_comp = 5)  # 4. reduce (optional)
```

**Rule**: impute before encoding, encode before scaling, scale before PCA. PCA requires all inputs to be numeric and on comparable scales — doing it before `step_normalize()` would give equal weight to income (range ~$200,000) and age (range ~70), completely distorting the principal components.

`prep(rec, training = train)` fits every step on the training data and records the learned statistics (means, standard deviations, quantiles, dummy levels, PCA rotation matrix). `bake(rec_prepped, new_data = test)` applies those *training-set statistics* to the test set. This is what prevents data leakage.

### Principal Component Analysis (PCA)

The insurance dataset has 40 variables. After encoding, you may have 50+ numeric features. Many are correlated (e.g., `num_claims` and `claim_amount`). **PCA** creates a smaller set of uncorrelated variables called **principal components** that capture as much of the original variance as possible.

**The geometric idea**: PCA finds the directions (vectors) in the feature space along which the data varies most. The first principal component (PC1) points in the direction of greatest variance. PC2 points in the direction of second-greatest variance, constrained to be perpendicular (orthogonal) to PC1. And so on.

**Formal definition**: given a scaled data matrix $\mathbf{X} \in \mathbb{R}^{n \times p}$, PCA computes the eigendecomposition of the covariance matrix $\mathbf{C} = \frac{1}{n-1}\mathbf{X}^\top \mathbf{X}$:

$$\mathbf{C} = \mathbf{V} \mathbf{\Lambda} \mathbf{V}^\top$$

where $\mathbf{V} \in \mathbb{R}^{p \times p}$ contains the eigenvectors (principal component directions, also called **loadings**) and $\mathbf{\Lambda} = \text{diag}(\lambda_1, \lambda_2, \ldots, \lambda_p)$ contains the eigenvalues in descending order. The **scores** (coordinates of each observation on the new axes) are $\mathbf{Z} = \mathbf{X}\mathbf{V}$.

The proportion of total variance explained by component $k$ is $\lambda_k / \sum_j \lambda_j$.

**How to choose the number of components**: two rules commonly used:
1. **Elbow (scree plot)**: plot variance explained per component; keep components up to the "elbow" where the curve flattens.
2. **Kaiser rule**: keep all components with eigenvalue $> 1$ (i.e., explains more than one variable's worth of variance).
3. **Cumulative threshold**: keep the minimum number of components that together explain ≥ 80% of total variance.

**Interpreting loadings**: a loading is the correlation between the original variable and the principal component. A high positive loading means the variable strongly drives scores upward on that component; a high negative loading drives them down.

```r
library(tidymodels)
library(broom)

pca_vars <- c("age", "bmi", "income", "premium", "deductible",
              "num_chronic_conditions", "num_visits",
              "num_prescriptions", "num_hospital_admissions",
              "num_claims", "avg_past_claim", "claim_amount",
              "app_logins_monthly", "support_calls", "policy_age_months")

pca_rec <- recipe(~ ., data = health_small[, pca_vars]) |>
  step_normalize(all_numeric_predictors()) |>
  step_pca(all_numeric_predictors(), num_comp = 5)

pca_prep   <- prep(pca_rec)
pca_scores <- bake(pca_prep, new_data = NULL)   # PC1–PC5 for every row

# Scree plot
tidy(pca_prep, number = 2, type = "variance") |>
  filter(terms == "percent variance") |>
  ggplot(aes(x = component, y = value)) +
  geom_col(fill = "steelblue") + geom_line(group = 1, colour = "red") +
  labs(title = "Scree Plot: Variance Explained by Each PC",
       x = "Principal Component", y = "% Variance Explained") +
  theme_minimal()

# Loadings plot (PC1 and PC2)
tidy(pca_prep, number = 2, type = "coef") |>
  filter(component %in% c("PC1", "PC2")) |>
  ggplot(aes(x = reorder(terms, value), y = value, fill = value > 0)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ component) + coord_flip() +
  scale_fill_manual(values = c("steelblue", "darkorange")) +
  labs(title = "PCA Loadings: PC1 and PC2", x = NULL, y = "Loading") +
  theme_minimal()
```

**Insurance interpretation**: in practice, PC1 for the health insurance data is dominated by claims-related variables (`num_claims`, `claim_amount`, `num_hospital_admissions`) — it is a **utilisation intensity** axis. PC2 is dominated by premium, deductible, and plan-level features — a **product tier** axis. Together, PC1 and PC2 often explain 35–50% of total variance and separate policyholders meaningfully in a 2D scatter plot.

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

Open `exercise.Rmd` and complete the five tasks: (1) manually compute Z-score and Min-Max scaled versions of `age`; (2) create dummy variables for `plan_tier` using `step_dummy()` and verify the number of new columns; (3) build a full pipeline with imputation, encoding, and normalisation; (4) confirm the baked training set has no missing values and all numeric predictors are scaled; (5) add `step_pca()` to the pipeline, produce a scree plot, and identify which two original variables load most strongly on PC1.

## Check

```
npm run check -- bdat-602 module-02 lesson-03
```

## Reflection

PCA creates uncorrelated components and reduces the feature space, but the components are linear combinations of the original variables — a coefficient in a regression on PC1 cannot be directly interpreted as "the effect of age". When is this loss of interpretability an acceptable trade-off, and when is it not?
