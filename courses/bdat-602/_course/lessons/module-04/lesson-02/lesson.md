# Lesson 2: Hierarchical Clustering

## Goal

Explain how hierarchical clustering builds a dendrogram, compare linkage methods, cut the dendrogram to obtain a flat partition, and compare hierarchical clusters to k-means clusters on the same data.

## Concept

### How Hierarchical Clustering Works

Hierarchical clustering (agglomerative) starts with every observation in its own cluster and merges pairs bottom-up:

1. Compute pairwise distances between all observations
2. Merge the two closest clusters
3. Recompute distances (based on linkage rule)
4. Repeat until one cluster remains

The result is a **dendrogram** — a tree diagram showing the merge sequence and heights.

---

### Linkage Methods

The linkage rule determines how the distance between two clusters is computed after a merge:

| Linkage | Distance = | Shape bias | Use when |
|---------|-----------|-----------|---------|
| **Single** | Minimum pairwise | Long chains | Detecting outliers |
| **Complete** | Maximum pairwise | Compact, equal-radius | General purpose |
| **Average** | Mean pairwise | Balanced | General purpose |
| **Ward.D2** | Minimises within-cluster variance | Compact, equal-size | Most clustering tasks |

Ward.D2 tends to produce the most interpretable, equal-sized clusters and is the default recommendation.

---

### Running Hierarchical Clustering

```r
library(dplyr)
source("R/simulate_bdat602_data.R")

health_small  <- simulate_bdat602(n = 10000, seed = 602)

# Use a 1,000-row subsample for speed (full 10k × 10k distance matrix is large)
set.seed(602)
hc_sub <- health_small |>
  slice_sample(n = 1000) |>
  select(age, bmi, income, num_claims, claim_amount) |>
  mutate(bmi    = if_else(is.na(bmi),    median(bmi,    na.rm=TRUE), bmi),
         income = if_else(is.na(income), median(income, na.rm=TRUE), income)) |>
  na.omit()

hc_scaled <- scale(hc_sub)
dist_mat  <- dist(hc_scaled, method = "euclidean")

hc_ward    <- hclust(dist_mat, method = "ward.D2")
hc_complete <- hclust(dist_mat, method = "complete")
```

---

### Plotting the Dendrogram

```r
plot(hc_ward, labels = FALSE, hang = -1,
     main = "Dendrogram: Ward.D2 Linkage",
     xlab = "", ylab = "Height")

# Add a horizontal cut line at height h
abline(h = 8, col = "red", lty = 2)
```

Cut at a specified number of clusters:

```r
clusters_hc <- cutree(hc_ward, k = 4)
table(clusters_hc)
```

---

### Comparing to k-Means

```r
library(cluster)

# Silhouette for hierarchical (Ward, k=4)
sil_hc <- silhouette(clusters_hc, dist_mat)
cat("HC silhouette:", round(mean(sil_hc[, 3]), 3), "\n")

# k-Means on same subsample
set.seed(602)
km_sub <- kmeans(hc_scaled, centers = 4, nstart = 25)
sil_km <- silhouette(km_sub$cluster, dist_mat)
cat("KM silhouette:", round(mean(sil_km[, 3]), 3), "\n")
```

On compact, well-separated clusters k-means and Ward linkage typically agree closely. Hierarchical clustering has the advantage of producing a dendrogram that reveals the cluster merge history.

---

### When to Use Hierarchical vs k-Means

| Aspect | k-Means | Hierarchical |
|--------|---------|-------------|
| k required up front | Yes | No (cut after) |
| Scalability | Fast on large datasets | Slow for $n > 10,000$ |
| Dendrogram | No | Yes |
| Cluster shape | Convex | Any |
| Reproducibility | Depends on seed | Deterministic |

## Example

```r
# Compare cluster labels
table(KMeans = km_sub$cluster, HC = clusters_hc)
```

This contingency table shows how much the two methods agree. High off-diagonal counts indicate the methods disagree on some observations.

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Take a 500-row sample of `health_small`, prepare a 3-variable scaled matrix (`age`, `bmi`, `num_claims`), and compute the Euclidean distance matrix.
2. Fit hierarchical clustering with Ward.D2 linkage. Plot the dendrogram with `labels = FALSE`.
3. Cut the dendrogram at `k = 3`. Print the cluster sizes.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-04 lesson-02
```

## Reflection

Why is it impractical to apply hierarchical clustering directly to the full 500,000-row health insurance dataset? Describe a practical strategy that uses hierarchical clustering's insights while remaining computationally feasible.
