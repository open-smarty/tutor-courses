# Lesson 9: Hierarchical Clustering and DBSCAN

## Goal

After this lesson you can apply agglomerative hierarchical clustering with Ward linkage to a sample of the insurance data, read and cut a dendrogram, articulate the scalability trade-offs between hierarchical and k-means clustering, run DBSCAN on a 2D PCA projection, choose $\varepsilon$ using a k-NN distance plot, and profile noise points as anomaly candidates.

## Concept

### Hierarchical clustering: the agglomerative approach

Agglomerative hierarchical clustering builds a full tree (dendrogram) of cluster merges without requiring $k$ to be specified in advance. It starts with $n$ singleton clusters (one per observation) and repeatedly merges the two closest clusters until all observations are in a single cluster.

**Algorithm**:
1. Compute the distance matrix $D$ where $D_{ij} = d(\mathbf{x}_i, \mathbf{x}_j)$.
2. Merge the two clusters with the smallest inter-cluster distance.
3. Update $D$ using the chosen linkage criterion.
4. Repeat until a single cluster remains.

The full merge history is stored as a dendrogram. You then "cut" it at a chosen height to extract a flat partition with any desired number of clusters.

### Linkage criteria

The linkage criterion defines how the distance between two *clusters* is computed from pairwise point distances.

| Linkage | Distance between clusters A and B | Behaviour |
|---|---|---|
| Single | $\min_{a \in A,\, b \in B} d(a, b)$ | Tends to "chain" — long, stringy clusters |
| Complete | $\max_{a \in A,\, b \in B} d(a, b)$ | Compact, similar-sized clusters |
| Average (UPGMA) | $\frac{1}{|A||B|} \sum_{a \in A, b \in B} d(a, b)$ | Compromise between single and complete |
| **Ward** | Minimise the increase in total WCSS after the merge | Produces compact, equal-sized clusters — best default for continuous data |

**Ward's method** merges the two clusters whose combination results in the smallest increase in total within-cluster variance. This is directly analogous to k-means' WCSS objective, making Ward dendrogram cuts broadly comparable to k-means solutions.

### Reading the dendrogram

The y-axis of a dendrogram is the dissimilarity at which two clusters were merged. A horizontal cut at height $h$ separates the tree into clusters: count the number of vertical lines crossing the cut — that is the number of clusters.

```r
hc_fit <- hclust(dist_matrix, method = "ward.D2")

fviz_dend(
  hc_fit, k = 4,
  cex = 0.4, palette = "jco",
  rect = TRUE, rect_fill = TRUE,
  main = "Dendrogram: Health Insurance Policyholders (Ward.D2)",
  xlab = "Policyholders", ylab = "Height (Ward Linkage Distance)"
)

# Cut at k = 4 clusters
hc_labels <- cutree(hc_fit, k = 4)
table(hc_labels)
```

### Comparison: hierarchical vs. k-means

| Property | k-Means | Hierarchical |
|---|---|---|
| $k$ specified upfront | Yes | No (choose after seeing dendrogram) |
| Deterministic | No (random init) | Yes |
| Time complexity | $O(nkTd)$ — fast | $O(n^2 \log n)$ time, $O(n^2)$ memory |
| Scalability | Millions of rows | ~10,000 rows before memory limits |
| Cluster shape | Spherical | Arbitrary |

**Practical rule**: use k-means for large datasets ($n > 10{,}000$); use hierarchical for smaller datasets where you want to explore the full cluster structure visually before committing to $k$.

```r
# Hierarchical uses a small sample — hclust() requires an n×n distance matrix
set.seed(602)
health_hc  <- health_scaled |> slice_sample(n = 2000)
dist_matrix <- dist(health_hc, method = "euclidean")
hc_fit      <- hclust(dist_matrix, method = "ward.D2")

# Compare k-means and hierarchical solutions on the same 2,000 rows
table(km_fit$cluster[1:2000], hc_labels)
```

### DBSCAN: density-based clustering

k-Means and hierarchical clustering both assume that clusters are convex or roughly spherical. **DBSCAN** (Density-Based Spatial Clustering of Applications with Noise, Ester et al. 1996) discovers clusters of **arbitrary shape** and explicitly labels outliers as **noise**.

**Core concepts**: given parameters $\varepsilon$ (radius) and MinPts (minimum neighbourhood size):
- A point $p$ is a **core point** if at least MinPts points lie within distance $\varepsilon$ of $p$ (including $p$ itself).
- A point $q$ is a **border point** if it is within $\varepsilon$ of a core point but is not itself a core point.
- A point that is neither core nor border is a **noise point** (label = 0).

**Cluster formation**: two core points are in the same cluster if they are within $\varepsilon$ of each other. Border points join the cluster of the nearest core point. Noise points belong to no cluster.

**Why noise points matter for insurance**: DBSCAN noise points are observations that lie outside every dense cluster — they are genuinely unusual. In the insurance dataset, noise points from DBSCAN applied to a PCA projection of 10 numeric features tend to have a significantly higher fraud rate than cluster members.

### Choosing $\varepsilon$ via the k-NN distance plot

Plot the distance from each point to its $k$-th nearest neighbour (where $k$ = MinPts $- 1$), sorted in ascending order. The "elbow" of this curve is the candidate $\varepsilon$: below this value almost all points are core points (too lenient); above it, almost all points are noise.

```r
library(dbscan)

# Apply PCA first to get a 2D projection
pca_result <- prcomp(health_scaled, scale. = FALSE)
pca_2d     <- pca_result$x[, 1:2]

# k-NN distance plot (k = MinPts - 1 = 4)
kNNdistplot(pca_2d, k = 4,
            main = "k-NN Distance Plot: Choosing epsilon")
abline(h = 0.5, col = "red", lty = 2)
```

### Running DBSCAN in R

```r
db_fit <- dbscan(pca_2d, eps = 0.5, minPts = 5)
table(db_fit$cluster)  # 0 = noise

fviz_cluster(
  db_fit, data = pca_2d,
  geom = "point", palette = "Set2",
  ggtheme = theme_minimal(),
  main = "DBSCAN Clusters (eps = 0.5, MinPts = 5)"
)
```

### DBSCAN for anomaly detection

Noise points flagged by DBSCAN are anomaly candidates:

```r
noise_idx <- which(db_fit$cluster == 0)
cat("Noise points:", length(noise_idx),
    "(", round(100 * length(noise_idx) / nrow(pca_2d), 1), "%)\n")

# Profile noise points vs. cluster members
health_sub[noise_idx, ] |>
  summarise(
    n          = n(),
    avg_age    = mean(age),
    avg_claim  = mean(claim_amount),
    pct_fraud  = mean(fraud_flag) * 100,
    pct_unemp  = mean(employment_type == "Unemployed") * 100
  )

cat("Fraud rate — noise points:", round(mean(health_sub$fraud_flag[noise_idx]) * 100, 1), "%\n")
cat("Fraud rate — cluster members:", round(mean(health_sub$fraud_flag[-noise_idx]) * 100, 1), "%\n")
```

In practice, noise points from DBSCAN on numeric insurance features exhibit a fraud rate several times the portfolio average — making DBSCAN a useful **unsupervised anomaly detector** that requires no labelled fraud cases.

## Example

```r
library(tidyverse)
library(factoextra)
library(dbscan)

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

# --- Hierarchical clustering on 2,000 rows ---
set.seed(602)
health_hc   <- health_scaled |> slice_sample(n = 2000)
dist_matrix <- dist(health_hc, method = "euclidean")
hc_fit      <- hclust(dist_matrix, method = "ward.D2")

fviz_dend(hc_fit, k = 4, cex = 0.4, palette = "jco",
          rect = TRUE, rect_fill = TRUE,
          main = "Ward Dendrogram — Insurance Policyholders")

hc_labels <- cutree(hc_fit, k = 4)
table(hc_labels)

# --- DBSCAN on PCA projection of 50,000 rows ---
pca_result <- prcomp(health_scaled, scale. = FALSE)
pca_2d     <- pca_result$x[, 1:2]

kNNdistplot(pca_2d, k = 4, main = "k-NN Distance Plot")
abline(h = 0.5, col = "red", lty = 2)

db_fit    <- dbscan(pca_2d, eps = 0.5, minPts = 5)
noise_idx <- which(db_fit$cluster == 0)
cat("Noise:", length(noise_idx), " Fraud rate in noise:",
    round(mean(health_sub$fraud_flag[noise_idx]) * 100, 1), "%\n")

fviz_cluster(db_fit, data = pca_2d, geom = "point",
             palette = "Set2", ggtheme = theme_minimal())
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) fit hierarchical clustering with Ward linkage on 2,000 scaled rows; plot the dendrogram and cut at $k = 4$; (2) compare the hierarchical cluster sizes with k-means results from Lesson 8 using a cross-tabulation; (3) produce a k-NN distance plot on the PCA-projected 50,000-row dataset and choose a candidate $\varepsilon$; (4) run DBSCAN with your chosen $\varepsilon$ and MinPts = 5, profile the noise points, and report the fraud rate difference between noise and cluster members.

## Check

```
npm run check -- bdat-602 module-04 lesson-02
```

## Reflection

DBSCAN requires two parameters ($\varepsilon$ and MinPts) and is sensitive to both. Consider what would happen if $\varepsilon$ were set too small on the 500,000-row dataset: most points would be classified as noise. What practical strategy would you use to confirm that your chosen $\varepsilon$ produces meaningful clusters rather than artefacts of the parameter choice?
