# Lesson 1: k-Means Clustering

## Goal

Explain how k-means assigns observations to clusters, choose the number of clusters k using the elbow and silhouette methods, run `kmeans()` on the health insurance dataset, and profile the resulting segments.

## Concept

### How k-Means Works

k-Means partitions $n$ observations into $k$ non-overlapping clusters by minimising the total within-cluster sum of squares (WCSS):

$$\text{WCSS} = \sum_{i=1}^{k} \sum_{x \in C_i} \|x - \mu_i\|^2$$

The algorithm:

1. Randomly initialise $k$ centroids
2. Assign each observation to its nearest centroid (Euclidean distance)
3. Recompute centroids as the mean of each cluster
4. Repeat steps 2–3 until assignments stop changing

k-Means converges to a **local minimum**, not necessarily the global minimum. Always run with multiple random starts (`nstart = 25`) and take the best result.

**Requirements:**
- Numeric, scaled input — variables on different scales distort distances
- No missing values — impute before clustering
- k specified in advance

---

### Choosing k

#### Elbow Method

Plot WCSS against k. The optimal k is the "elbow" — the point where adding more clusters yields diminishing returns:

```r
library(dplyr)
source("R/simulate_bdat602_data.R")
source("R/utils.R")
library(recipes)

health_small <- simulate_bdat602(n = 10000, seed = 602)

# Prepare: impute, scale numeric variables
clust_vars <- c("age", "bmi", "income", "premium",
                "num_chronic_conditions", "num_visits",
                "num_claims", "claim_amount",
                "app_logins_monthly", "support_calls")

clust_recipe <- recipe(~ ., data = health_small[, clust_vars]) |>
  step_impute_median(bmi, income) |>
  step_normalize(all_numeric_predictors())

clust_prep  <- prep(clust_recipe)
health_clust <- bake(clust_prep, new_data = NULL)

set.seed(602)
wcss <- sapply(1:10, function(k) {
  kmeans(health_clust, centers = k, nstart = 10)$tot.withinss
})

plot(1:10, wcss, type = "b", pch = 19,
     xlab = "Number of Clusters (k)", ylab = "WCSS",
     main = "Elbow Plot")
```

#### Silhouette Score

The silhouette score measures how well each observation fits its own cluster relative to neighbouring clusters. Values range from -1 to +1; higher is better.

```r
library(cluster)

sil_scores <- sapply(2:8, function(k) {
  km    <- kmeans(health_clust, centers = k, nstart = 10)
  sil   <- silhouette(km$cluster, dist(health_clust))
  mean(sil[, 3])
})

plot(2:8, sil_scores, type = "b", pch = 19,
     xlab = "k", ylab = "Average Silhouette Score",
     main = "Silhouette Scores")
```

---

### Fitting k-Means

```r
set.seed(602)
km4 <- kmeans(health_clust, centers = 4, nstart = 25)

cat("Cluster sizes:", km4$size, "\n")
cat("WCSS:", km4$tot.withinss, "\n")
```

---

### Profiling Clusters

After fitting, join the cluster labels back to the original data and compute per-cluster summaries:

```r
health_profiled <- health_small |>
  filter(!is.na(bmi) & !is.na(income)) |>
  mutate(cluster = as.factor(km4$cluster))

health_profiled |>
  group_by(cluster) |>
  summarise(
    n            = n(),
    avg_age      = round(mean(age), 1),
    avg_bmi      = round(mean(bmi), 1),
    avg_income   = round(mean(income), 0),
    avg_claim    = round(mean(claim_amount), 0),
    pct_platinum = round(mean(plan_tier == "Platinum") * 100, 1),
    fraud_rate   = round(mean(fraud_flag) * 100, 2)
  )
```

## Example

Typical cluster profiles from the health insurance dataset:

| Cluster | Profile |
|---------|---------|
| Young healthy | Low age, low BMI, few claims, Bronze plan |
| Middle-aged moderate-risk | Moderate age/BMI, some chronic conditions |
| High-utilisation | High claims, many hospital admissions, Gold/Platinum |
| Elderly high-risk | High age, smokers, multiple chronic conditions, high fraud |

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Prepare a scaled matrix of 5 clustering variables (`age`, `bmi`, `income`, `num_claims`, `claim_amount`) from `health_small` (impute NAs first). Name it `hc_mat`.
2. Run `kmeans(hc_mat, centers = 4, nstart = 25)`. Print cluster sizes.
3. Join cluster labels back to `health_small` and compute average `claim_amount` and `fraud_flag` rate per cluster.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-04 lesson-01
```

## Reflection

k-Means uses Euclidean distance, which requires scaled numeric variables. Explain what would happen to the cluster assignments if you forgot to scale `income` before clustering together with `age`. Which cluster variable would dominate, and why?
