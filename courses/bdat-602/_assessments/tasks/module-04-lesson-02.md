# Task: Hierarchical Clustering and Dendrogram Analysis

## Objective

Apply agglomerative hierarchical clustering to insurance policyholder data, read and interpret a dendrogram, compare Ward and single linkage, and contrast the results with k-means.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Prepare**: Generate 5,000 rows from `simulate_bdat602()`. Select `age`, `bmi`, `income`, `num_claims`, `num_chronic_conditions`. Drop NAs and apply `scale()`.

3. **Task 2 — Ward dendrogram**: Compute the Euclidean distance matrix with `dist()`. Fit `hclust(D, method = "ward.D2")`. Plot the dendrogram with `labels = FALSE, hang = -1`. Add a red dashed `abline()` at the height that gives approximately 4 clusters. In a comment, describe the major branches visible in the dendrogram.

4. **Task 3 — cutree() and comparison**: Extract 4 clusters with `cutree(hc, k = 4)` and print the cluster sizes. Also run `kmeans()` with k = 4 on the same scaled data. Compare cluster sizes between methods. In a comment, state which method produces more balanced clusters and why.

5. **Task 4 — Single linkage**: Re-fit `hclust(D, method = "single")` and plot the dendrogram. Extract 4 clusters with `cutree()` and print their sizes. In a comment, describe the chaining effect and explain why it occurs (refer to the linkage definition).

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. All interpretations (Tasks 2, 3, 4) must be written as R comments inside their respective code chunks.
