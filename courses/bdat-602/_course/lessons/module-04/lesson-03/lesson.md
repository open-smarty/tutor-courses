# Lesson 10: Cluster Validation and Scaling with Spark

## Goal

After this lesson you can compute and interpret silhouette scores for individual observations and full cluster solutions, use `fviz_nbclust()` with the silhouette method to choose $k$, describe the Dunn, Davies-Bouldin, and Calinski-Harabasz indices, run k-means on 500,000 policyholders using Spark's `ml_kmeans()` with k-means‖ initialisation, and profile Spark cluster results using `collect()` and `dplyr`.

## Concept

### Why validation matters

Clustering algorithms always return a partition — even if no real structure exists in the data. Validation metrics answer: **are these clusters genuinely compact and well-separated, or are they artefacts of the algorithm?** They also provide an objective way to compare competing solutions (different $k$, different algorithms, different feature sets).

### The silhouette score

For each point $i$ in cluster $C_k$, define:

- $a(i)$ = mean distance from $i$ to all other points **in the same cluster** $C_k$ — measures how well $i$ fits its own cluster.
- $b(i)$ = mean distance from $i$ to all points in the **nearest other cluster** — measures how separated $i$ is from its closest alternative cluster.

$$s(i) = \frac{b(i) - a(i)}{\max(a(i),\, b(i))}$$

$s(i) \in [-1, 1]$:
- $s(i)$ close to **+1**: $i$ is deep inside its cluster and far from others — well classified.
- $s(i)$ close to **0**: $i$ is on the boundary between two clusters.
- $s(i)$ close to **−1**: $i$ is closer to another cluster than its own — likely misclassified.

The **mean silhouette width** $\bar{s}$ across all points is the overall cluster quality score. Choose the $k$ that maximises $\bar{s}$.

```r
library(cluster)
library(factoextra)

# Silhouette plot for a fixed k = 4
set.seed(602)
km4 <- kmeans(health_scaled[1:5000, ], centers = 4, nstart = 25)
dist_sub   <- dist(health_scaled[1:5000, ], method = "euclidean")
sil_scores <- silhouette(km4$cluster, dist_sub)
summary(sil_scores)   # mean silhouette width per cluster

fviz_silhouette(
  sil_scores,
  palette = "jco",
  ggtheme = theme_minimal(),
  main    = "Silhouette Plot: k-Means (k = 4)"
)
```

The silhouette plot shows each point as a bar sorted by cluster. Bars pointing left (negative silhouette) are candidates for reassignment.

### Choosing k with the silhouette method

```r
fviz_nbclust(
  health_scaled[1:5000, ],
  FUNcluster = kmeans,
  method     = "silhouette",
  k.max      = 10,
  nstart     = 10
) +
  labs(title = "Silhouette Method: Optimal Number of Clusters",
       x = "Number of Clusters k", y = "Average Silhouette Width") +
  theme_minimal()
```

The silhouette method and the elbow method often agree. When they disagree, prefer the silhouette method — it has a direct quality interpretation, whereas the elbow involves subjective judgement about where the curve bends.

### Other cluster validation indices

**Dunn index**: ratio of the minimum inter-cluster distance to the maximum intra-cluster diameter. Higher is better. Sensitive to noise (one outlier can inflate the maximum diameter).

$$\text{Dunn} = \frac{\min_{i \neq j} d(C_i, C_j)}{\max_k \text{diam}(C_k)}$$

**Davies-Bouldin index**: average over all clusters of the worst-case ratio of within-cluster scatter to between-cluster separation. Lower is better.

$$\text{DB} = \frac{1}{K} \sum_{k=1}^{K} \max_{j \neq k} \frac{s_k + s_j}{d(\boldsymbol{\mu}_k, \boldsymbol{\mu}_j)}$$

where $s_k$ is the average intra-cluster distance for cluster $k$.

**Calinski-Harabasz index** (Variance Ratio Criterion): ratio of between-cluster variance to within-cluster variance, scaled by degrees of freedom. Higher is better. Tends to favour compact, well-separated clusters.

$$\text{CH} = \frac{\text{SS}_B / (K - 1)}{\text{SS}_W / (n - K)}$$

Use `clValid::clValid()` or compute manually to compare indices across multiple $k$ values.

### Scaling k-means with Spark

The local `kmeans()` function loads all data into RAM and runs on a single core. For 500,000 rows and 10+ features this is feasible but slow. Spark's `ml_kmeans()` distributes the computation across multiple cores (or machines) and uses the **k-means‖** (k-means parallel) initialisation algorithm — a distributed analogue of k-means++ that is robust at scale.

**k-Means‖ initialisation**: instead of selecting one centre per round (as in k-means++), k-means‖ samples $O(k)$ candidate centres per round in parallel, runs $O(\log n)$ rounds, and then clusters the candidates to obtain the final $k$ centres. This is far more efficient than sequential k-means++ on distributed data.

```r
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

health_tbl <- copy_to(sc, health_data, name = "health_ins", overwrite = TRUE)

health_spark_scaled <- health_tbl |>
  mutate(
    log_income = log1p(income),
    log_claim  = log1p(claim_amount)
  ) |>
  select(age, bmi, log_income, premium,
         num_chronic_conditions, num_claims,
         log_claim, support_calls,
         customer_rating, app_logins_monthly)

set.seed(602)
spark_km <- health_spark_scaled |>
  ml_kmeans(
    formula   = ~ .,
    k         = 4,
    max_iter  = 100,
    init_mode = "k-means||",
    seed      = 602
  )

spark_km$centers   # cluster centre coordinates
```

### Profiling and collecting Spark clusters

Cluster assignments live in Spark memory. Use `ml_predict()` to add them and `collect()` to pull the summary into R:

```r
health_with_id <- health_tbl |>
  mutate(log_income = log1p(income), log_claim = log1p(claim_amount)) |>
  select(record_id, age, bmi, log_income, premium,
         num_chronic_conditions, num_claims, log_claim,
         support_calls, customer_rating, app_logins_monthly,
         smoker, fraud_flag, churned, plan_tier)

cluster_results <- ml_predict(spark_km, health_with_id)

cluster_results |>
  group_by(prediction) |>
  summarise(
    n           = n(),
    avg_age     = mean(age,        na.rm = TRUE),
    avg_bmi     = mean(bmi,        na.rm = TRUE),
    avg_claims  = mean(num_claims, na.rm = TRUE),
    pct_fraud   = mean(fraud_flag, na.rm = TRUE) * 100,
    pct_churned = mean(churned,    na.rm = TRUE) * 100,
    avg_support = mean(support_calls, na.rm = TRUE)
  ) |>
  collect() |>
  arrange(desc(avg_claims))
```

### Elbow method in Spark

Run `ml_kmeans()` for $k = 2, \ldots, 8$ and collect the within-cluster sum of squares (`trainingCost`) for each:

```r
wcss_results <- purrr::map_dfr(2:8, function(k) {
  model <- health_spark_scaled |>
    ml_kmeans(formula = ~ ., k = k, max_iter = 50,
              init_mode = "k-means||", seed = 602)
  tibble(k = k, wcss = model$summary$trainingCost)
})

ggplot(wcss_results, aes(x = k, y = wcss)) +
  geom_line(colour = "steelblue", linewidth = 1) +
  geom_point(colour = "steelblue", size = 3) +
  labs(title = "Elbow Method: Spark k-Means (n = 500,000)",
       x = "Number of Clusters k",
       y = "Within-Cluster Sum of Squares (WCSS)") +
  theme_minimal()
```

Running the elbow loop on 500,000 rows in Spark takes the same wall-clock time as running it on ~5,000 rows locally — the key advantage of distributed computing.

### Choosing a validation strategy in practice

No single index is universally best. A robust workflow:

1. Use the **elbow method** to identify a range of plausible $k$ values.
2. Use the **silhouette method** to choose among that range.
3. Check that the cluster **profiles** (mean age, claims, fraud rate per cluster) make business sense.
4. If using Spark, validate a sample locally with `silhouette()` from the `cluster` package before committing to the full run.

## Example

```r
library(tidyverse)
library(cluster)
library(factoextra)

source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

cluster_vars <- c("age", "bmi", "income", "premium",
                  "num_chronic_conditions", "num_claims",
                  "claim_amount", "support_calls",
                  "customer_rating", "app_logins_monthly")

set.seed(602)
health_sub <- health_data |>
  filter(!is.na(bmi), !is.na(income)) |>
  slice_sample(n = 50000)

signed_log <- function(x) sign(x) * log1p(abs(x))
health_scaled <- health_sub |>
  select(all_of(cluster_vars)) |>
  mutate(income = signed_log(income), claim_amount = log1p(claim_amount)) |>
  scale() |>
  as.data.frame()

# Silhouette method to choose k (on 5,000-row subset for speed)
fviz_nbclust(health_scaled[1:5000, ], kmeans,
             method = "silhouette", k.max = 8, nstart = 10) +
  theme_minimal()

# Silhouette plot for k = 4
set.seed(602)
km4      <- kmeans(health_scaled[1:5000, ], centers = 4, nstart = 25)
dist_sub <- dist(health_scaled[1:5000, ])
sil      <- silhouette(km4$cluster, dist_sub)
cat("Mean silhouette width:", round(mean(sil[, 3]), 3), "\n")
fviz_silhouette(sil, palette = "jco", ggtheme = theme_minimal())
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) use `fviz_nbclust()` with the silhouette method on a 5,000-row subset to identify the optimal $k$; (2) fit k-means with your optimal $k$, compute a silhouette plot, and report the mean silhouette width; (3) identify the cluster with the lowest mean silhouette width and describe which policyholders it contains; (4) connect to a local Spark session, run `ml_kmeans()` for $k = 2, \ldots, 6$ on the full 500,000-row dataset, plot the elbow curve, and profile the best-$k$ solution.

## Check

```
npm run check -- bdat-602 module-04 lesson-03
```

## Reflection

The Calinski-Harabasz index tends to favour a larger number of clusters as $n$ grows, while the silhouette score is more stable. Given that the insurance dataset has 500,000 rows, which index would you trust more for selecting $k$, and why? What does this imply about running validation on a sample versus the full dataset?
