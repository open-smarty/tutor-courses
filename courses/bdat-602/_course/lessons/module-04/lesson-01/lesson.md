# Lesson 8: k-Means Clustering

## Goal

After this lesson you can state the k-means objective function, trace Lloyd's algorithm step by step, choose k using the elbow and silhouette methods, and profile the resulting clusters in business terms.

## Concept

### What k-means does

k-means partitions $n$ observations into $k$ non-overlapping clusters so that points within a cluster are as similar as possible. "Similar" is measured by squared Euclidean distance to the cluster centroid.

**Objective** — minimise the Within-Cluster Sum of Squares (WCSS):

$$\text{WCSS} = \sum_{k=1}^{K} \sum_{i \in C_k} \|\mathbf{x}_i - \boldsymbol{\mu}_k\|^2$$

where $\boldsymbol{\mu}_k = \frac{1}{|C_k|} \sum_{i \in C_k} \mathbf{x}_i$ is the centroid of cluster $k$.

**Why squared distances?** The centroid (mean) is the point that minimises the sum of squared distances. Using squared distances makes the optimisation tractable — you can update centroids by a simple mean, with no iterative inner loop.

### Lloyd's algorithm (the standard k-means procedure)

1. **Initialise**: randomly choose $k$ data points as initial centroids $\boldsymbol{\mu}_1, \ldots, \boldsymbol{\mu}_k$.
2. **Assignment step**: assign each point $\mathbf{x}_i$ to the nearest centroid:
$$c_i = \arg\min_{k} \|\mathbf{x}_i - \boldsymbol{\mu}_k\|^2$$
3. **Update step**: recompute each centroid as the mean of its assigned points:
$$\boldsymbol{\mu}_k \leftarrow \frac{1}{|C_k|} \sum_{i: c_i = k} \mathbf{x}_i$$
4. **Repeat** steps 2–3 until no assignments change (convergence).

**Convergence is guaranteed** because WCSS decreases (or stays the same) at every step. However, Lloyd's algorithm only finds a **local minimum** — the result depends on the initial centroids. Use `nstart = 25` to run the algorithm 25 times with different random starts and keep the solution with the lowest WCSS.

### Choosing k: the elbow method

Plot WCSS against $k$ for $k = 1, 2, \ldots, 10$. WCSS always decreases as $k$ increases (in the extreme, $k = n$ gives WCSS = 0). The "elbow" is the value of $k$ where the rate of decrease sharply slows — adding one more cluster beyond this point yields diminishing returns.

```r
wcss <- sapply(1:10, function(k) {
  kmeans(data_scaled, centers = k, nstart = 25)$tot.withinss
})
plot(1:10, wcss, type = "b", pch = 19, xlab = "k", ylab = "WCSS")
```

### Choosing k: the silhouette score

For each point $i$:
- $a(i)$ = mean distance to all other points **in the same cluster**.
- $b(i)$ = mean distance to all points in the **nearest other cluster**.

$$s(i) = \frac{b(i) - a(i)}{\max(a(i), b(i))}$$

$s(i) \in [-1, 1]$. A value close to +1 means $i$ is well inside its cluster and far from others (good). A value close to 0 means $i$ is on the boundary. A value close to −1 means $i$ is closer to another cluster than to its own (misclassified).

The **mean silhouette score** across all points is a quality measure: choose $k$ that maximises it.

### Cluster profiling

After fitting, describe each cluster by summarising the variables that distinguish it:

```r
health_data |>
  mutate(cluster = factor(km$cluster)) |>
  group_by(cluster) |>
  summarise(across(c(age, bmi, income, num_claims, claim_amount), mean, na.rm = TRUE))
```

Then give each cluster a business label: "Young low-risk", "Elderly high-utilisation", etc.

## Example

```r
library(tidyverse)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 50000, seed = 602)  # use 50k for speed

# Select and scale features
clust_data <- health_data |>
  select(age, bmi, income, num_claims, num_chronic_conditions) |>
  drop_na() |>
  scale()  # Z-score standardise all columns

# Elbow plot
wcss <- sapply(1:10, function(k) kmeans(clust_data, centers = k, nstart = 25)$tot.withinss)

tibble(k = 1:10, wcss = wcss) |>
  ggplot(aes(x = k, y = wcss)) +
  geom_line() + geom_point() +
  labs(title = "Elbow Method", x = "Number of clusters (k)", y = "WCSS") +
  theme_minimal()

# Fit with k = 4 (assume elbow at k = 4)
set.seed(602)
km <- kmeans(clust_data, centers = 4, nstart = 25)

# Profile clusters
health_data |>
  drop_na(age, bmi, income, num_claims, num_chronic_conditions) |>
  mutate(cluster = factor(km$cluster)) |>
  group_by(cluster) |>
  summarise(
    n          = n(),
    avg_age    = round(mean(age), 1),
    avg_bmi    = round(mean(bmi), 1),
    avg_income = round(mean(income), 0),
    avg_claims = round(mean(num_claims), 2)
  )
```

A typical output might show: Cluster 1 (young, low BMI, low claims — "healthy young"), Cluster 2 (middle-aged, higher income, moderate claims), Cluster 3 (elderly, high chronic conditions, high claims), Cluster 4 (all ages, high BMI, smokers).

## Task

Open `exercise.Rmd` and complete the four tasks: (1) prepare and scale the clustering features; (2) produce the elbow plot and identify the optimal k; (3) fit k-means with your chosen k and nstart = 25; (4) profile each cluster and assign a descriptive business label.

## Check

```
npm run check -- bdat-602 module-04 lesson-01
```

## Reflection

k-means assumes that clusters are spherical (equal variance in all directions) and of similar size. What would happen if you applied k-means to a dataset where one cluster contains 95% of the data and another contains only 5%?
