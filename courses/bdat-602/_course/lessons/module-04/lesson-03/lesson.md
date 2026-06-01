# Lesson 3: PCA for Dimensionality Reduction and Cluster Visualisation

## Goal

Explain what PCA does geometrically, interpret the scree plot and PC loadings, build a PCA pipeline with `recipes`, and use PC1–PC2 score plots to visualise k-means clusters in two dimensions.

## Concept

### Why Dimensionality Reduction?

With 40 variables, visualisation is impossible — human perception tops out at 3 dimensions. PCA creates a smaller set of new variables (principal components) that capture most of the variance:

- **PC1** — direction of greatest variance in the data
- **PC2** — direction of second-greatest variance, perpendicular to PC1
- Each subsequent PC captures less variance
- PCs are **uncorrelated** — no multicollinearity

**Requirements:** numeric, scaled input only. PCA cannot be applied to raw categorical variables.

> **In BDAT 602** PCA serves two purposes: (1) dimensionality reduction before clustering or classification, and (2) visualising cluster assignments in 2D.

---

### Fitting PCA with recipes

```r
library(recipes)
library(dplyr)
library(broom)
source("R/simulate_bdat602_data.R")

health_small <- simulate_bdat602(n = 10000, seed = 602)

pca_vars <- c("age", "bmi", "income", "premium", "deductible",
              "num_chronic_conditions", "num_visits",
              "num_prescriptions", "num_hospital_admissions",
              "num_claims", "avg_past_claim", "claim_amount",
              "app_logins_monthly", "support_calls",
              "policy_age_months")

pca_recipe <- recipe(~ ., data = health_small[, pca_vars]) |>
  step_impute_median(bmi, income) |>
  step_normalize(all_numeric_predictors()) |>
  step_pca(all_numeric_predictors(), num_comp = 5)

pca_prep   <- prep(pca_recipe)
pca_scores <- bake(pca_prep, new_data = NULL)

head(pca_scores)
```

---

### Scree Plot

The **scree plot** shows variance explained per PC. Look for the "elbow" — the point where adding PCs yields diminishing returns. A common rule: keep enough PCs to explain ≥ 80% of total variance.

```r
library(ggplot2)

tidy(pca_prep, number = 3, type = "variance") |>
  filter(terms == "percent variance") |>
  ggplot(aes(x = component, y = value)) +
  geom_col(fill = "steelblue") +
  geom_line(group = 1, colour = "red") +
  geom_point(colour = "red") +
  labs(title = "Scree Plot: Variance Explained by Each PC",
       x = "Principal Component", y = "% Variance Explained") +
  theme_minimal()
```

---

### PC Loadings

Loadings show how much each original variable contributes to each PC:

```r
tidy(pca_prep, number = 3, type = "coef") |>
  filter(component %in% c("PC1", "PC2")) |>
  ggplot(aes(x = reorder(terms, value), y = value,
             fill = value > 0)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ component) +
  coord_flip() +
  scale_fill_manual(values = c("steelblue", "darkorange")) +
  labs(title = "PCA Loadings: PC1 and PC2",
       x = NULL, y = "Loading") +
  theme_minimal()
```

Interpret: if `num_claims`, `claim_amount`, and `num_chronic_conditions` all have large positive loadings on PC1, then PC1 represents a "medical utilisation / cost" dimension.

---

### Score Plot Coloured by Cluster

After fitting k-means (k = 4) on the PCA scores, visualise cluster separation in 2D:

```r
# Fit k-means on the 5 PCA components
set.seed(602)
km_pca <- kmeans(pca_scores, centers = 4, nstart = 25)

pca_scores |>
  mutate(cluster = as.factor(km_pca$cluster)) |>
  ggplot(aes(x = PC1, y = PC2, colour = cluster)) +
  geom_point(alpha = 0.15, size = 0.6) +
  labs(title = "PCA Score Plot: Clusters (k=4)",
       colour = "Cluster") +
  theme_minimal()
```

## Example

```r
# Cumulative variance explained
tidy(pca_prep, number = 3, type = "variance") |>
  filter(terms == "cumulative percent variance") |>
  print(n = 10)
```

Typically 2–3 PCs explain ~50–60% of variance in this dataset; ~5 PCs explain ~70–80%.

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Fit a PCA `recipes` pipeline on the 6 numeric variables: `age`, `bmi`, `income`, `num_claims`, `claim_amount`, `num_chronic_conditions`. Set `num_comp = 3`.
2. Plot the scree plot showing % variance explained per PC.
3. Plot PC1 vs PC2 coloured by `plan_tier` (join from the original data).

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-04 lesson-03
```

## Reflection

PC1 has large positive loadings on `num_claims`, `claim_amount`, and `num_chronic_conditions`, and a large negative loading on `customer_rating`. Describe in plain English what PC1 represents, and predict what kind of policyholder would score high on PC1.
