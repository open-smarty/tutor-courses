# Task: Hierarchical vs k-Means Comparison

## Objective

Compare hierarchical clustering and k-means on the same data subsample and report which produces better-quality clusters.

## Instructions

Use a random sample of 800 rows from `health_small` (`set.seed(602)`):

1. **Prepare** — Select `age`, `bmi`, `income`, `num_claims`. Impute medians. Scale. `na.omit()`.

2. **k-Means** — Fit k = 3, `nstart = 25`. Record WCSS and average silhouette score.

3. **Hierarchical (Ward.D2)** — Compute Euclidean distance matrix. Fit `hclust(., method = "ward.D2")`. Cut at k = 3. Record average silhouette score.

4. **Hierarchical (Complete)** — Fit `hclust(., method = "complete")`. Cut at k = 3. Record average silhouette score.

5. **Comparison table**:

| Method | k | Avg Silhouette | Cluster sizes | Notes |
|--------|---|----------------|---------------|-------|
| k-Means | 3 | ? | ? | ? |
| Ward.D2 | 3 | ? | ? | ? |
| Complete | 3 | ? | ? | ? |

6. **Recommendation** — Which method produced better-separated clusters? When would you prefer hierarchical over k-means for this dataset?

## Submission

Knit your Rmd with the comparison table and dendrogram (Ward.D2) visible.
