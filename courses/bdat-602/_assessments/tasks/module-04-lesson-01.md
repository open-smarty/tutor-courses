# Task: k-Means Clustering of Insurance Policyholders

## Objective

Segment 50,000 insurance policyholders into meaningful clusters using k-means, choose the optimal number of clusters with the elbow and silhouette methods, and produce a business-interpretable cluster profile.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Prepare features**: Select `age`, `bmi`, `income`, `num_claims`, `num_chronic_conditions`. Drop rows with any NA using `drop_na()`. Apply `scale()` to Z-score standardise all five columns. Verify that every column has mean ≈ 0 and sd ≈ 1.

3. **Task 2 — Elbow plot**: Compute WCSS for k = 1 to 10 (use `nstart = 25` for each). Plot WCSS vs k with `ggplot2`. Identify and state your chosen k in a comment, giving a one-sentence justification based on the elbow shape.

4. **Task 3 — Fit and evaluate**: Fit `kmeans()` with your chosen k and `nstart = 25`. Report the total WCSS and cluster sizes. Compute the mean silhouette score (sample 5,000 rows for `dist()` if needed for speed).

5. **Task 4 — Profile and label**: Add the cluster assignments back to the dataset. Summarise each cluster by: n, mean age, mean BMI, mean income, mean num\_claims, mean num\_chronic\_conditions, and proportion who smoke. Assign a descriptive business label to each cluster (e.g., "Young Healthy Low-Risk"). Your labels must be justified by the statistics in the profile table.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Cluster labels and justifications must appear as R comments inside the Task 4 code chunk.
