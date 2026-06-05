# Lesson 9: Hierarchical Clustering

## Goal

After this lesson you can explain agglomerative hierarchical clustering, compare linkage criteria, read a dendrogram, cut it to extract flat clusters, and articulate the practical trade-offs between hierarchical and k-means clustering.

## Concept

### The agglomerative approach

Hierarchical clustering builds a tree (dendrogram) of cluster merges. The agglomerative variant starts with $n$ singleton clusters (each data point is its own cluster) and repeatedly merges the two closest clusters until only one remains.

**Algorithm**:
1. Compute the distance matrix $D$ where $D_{ij} = d(\mathbf{x}_i, \mathbf{x}_j)$.
2. Merge the two clusters with the smallest inter-cluster distance.
3. Update $D$ using the chosen linkage criterion.
4. Repeat until all points are in one cluster.

The full merge history is stored as a dendrogram. You then "cut" the dendrogram at a chosen height to get a flat partition.

### Distance metrics

**Euclidean distance** (straight-line):
$$d(\mathbf{x}, \mathbf{y}) = \sqrt{\sum_{j=1}^{p} (x_j - y_j)^2}$$

Appropriate when variables are measured on the same scale (or after scaling) and differences in each dimension are equally meaningful.

**Manhattan distance** (city-block):
$$d(\mathbf{x}, \mathbf{y}) = \sum_{j=1}^{p} |x_j - y_j|$$

Less sensitive to large differences in a single dimension than Euclidean, making it more robust to outliers in high-dimensional data.

### Linkage criteria

The linkage criterion determines how the distance between two *clusters* is computed from pairwise point distances.

| Linkage | Distance between clusters A and B | Behaviour |
|---|---|---|
| Single | $\min_{a \in A, b \in B} d(a, b)$ | Tends to "chain" — long, stringy clusters |
| Complete | $\max_{a \in A, b \in B} d(a, b)$ | Compact, similar-sized clusters |
| Average | $\frac{1}{|A||B|} \sum_{a,b} d(a, b)$ | Compromise between single and complete |
| Ward | Minimise the increase in total WCSS after the merge | Produces compact, equal-sized clusters — usually the best default |

**Ward's method** is analogous to k-means in its objective: it merges the two clusters whose combination results in the smallest increase in the total within-cluster variance. It consistently produces the most interpretable clusters for continuous data.

### Reading the dendrogram

The y-axis of a dendrogram is the distance (or dissimilarity) at which two clusters were merged. A horizontal line cut at height $h$ separates the tree into clusters: count the number of vertical lines crossing the cut — that is the number of clusters.

```r
hc <- hclust(dist(data_scaled), method = "ward.D2")
plot(hc, labels = FALSE, main = "Ward Dendrogram — Insurance Policyholders")
abline(h = 25, col = "red", lty = 2)  # cut at height 25 → 4 clusters

clusters <- cutree(hc, k = 4)
```

### Comparison: hierarchical vs. k-means

| Property | k-means | Hierarchical |
|---|---|---|
| k specified upfront | Yes | No (choose after seeing dendrogram) |
| Deterministic | No (random init) | Yes |
| Time complexity | O(nkTd) — fast | O(n² log n) time, O(n²) memory |
| Scalability | Millions of rows | ~10,000 rows before memory limits |
| Cluster shape | Spherical | Arbitrary |

**Practical conclusion**: use k-means for large datasets, hierarchical for smaller datasets where you want to explore the full cluster structure visually before committing to k.

## Example

```r
library(tidyverse)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 5000, seed = 602)  # small for hclust

clust_data <- health_data |>
  select(age, bmi, income, num_claims, num_chronic_conditions) |>
  drop_na() |>
  scale()

# Compute distance matrix and fit
D  <- dist(clust_data, method = "euclidean")
hc <- hclust(D, method = "ward.D2")

# Plot dendrogram
plot(hc, labels = FALSE, hang = -1,
     main = "Ward.D2 Dendrogram — Insurance Policyholders",
     xlab = "", sub = "")
abline(h = 30, col = "red", lty = 2)  # cut → ~4 clusters

# Extract cluster labels
clusters <- cutree(hc, k = 4)
table(clusters)

# Profile
health_data |>
  drop_na(age, bmi, income, num_claims, num_chronic_conditions) |>
  mutate(cluster = factor(clusters)) |>
  group_by(cluster) |>
  summarise(avg_age = mean(age), avg_bmi = mean(bmi), avg_claims = mean(num_claims))
```

The dendrogram makes it visually clear where natural breaks in the data occur — without having to pre-specify k.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) prepare the data (scale 5,000 rows); (2) fit hierarchical clustering with Ward linkage and plot the dendrogram; (3) cut the tree at k = 4 and compare cluster sizes to k-means; (4) re-run with single linkage and describe how the dendrogram shape changes (chaining effect).

## Check

```
npm run check -- bdat-602 module-04 lesson-02
```

## Reflection

Hierarchical clustering is deterministic (no random initialisation), yet two analysts running it on different random samples of the same population may get different dendrograms. Why? Does this make hierarchical clustering unreliable?
