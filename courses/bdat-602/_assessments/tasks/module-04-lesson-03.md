# Task: PCA for Visualisation and Cluster Validation

## Objective

Apply PCA to the scaled insurance features, interpret the scree plot and biplot, and visualise k-means cluster assignments in the principal component space.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — PCA**: Generate 50,000 rows. Select and scale the five clustering features. Run `prcomp(clust_data, scale. = FALSE)` and print the `summary()`.

3. **Task 2 — Scree plot**: Compute PVE for each component as `pca$sdev^2 / sum(pca$sdev^2)`. Plot both the per-component PVE (bar chart) and cumulative PVE (red line) on the same axes. State how many PCs explain at least 80% of variance.

4. **Task 3 — Biplot**: Create a biplot with `biplot(pca, scale = 0, cex = 0.5)`. Print the loadings for PC1 and PC2 (`pca$rotation[, 1:2]`). In comments, identify: (a) which variables most strongly drive PC1; (b) which variables most strongly drive PC2; (c) what real-world interpretation you would give each component.

5. **Task 4 — Clusters in PCA space**: Fit k-means with k = 4 on the scaled data. Scatter-plot the PC1 vs. PC2 scores, coloured by cluster. In a comment, discuss: (a) how well-separated the clusters appear; (b) whether overlap in 2D implies the clustering has failed; (c) what additional diagnostics you would run to validate the clusters.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. All interpretations (Tasks 3 and 4) must be written as R comments inside their respective code chunks.
