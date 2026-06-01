# Task: Policyholder Segmentation with k-Means

## Objective

Segment policyholders into meaningful risk groups and describe each segment in business-ready language.

## Instructions

1. **Prepare** — Use the 7 clustering variables: `age`, `bmi`, `income`, `num_chronic_conditions`, `num_claims`, `claim_amount`, `support_calls`. Impute `bmi` and `income` with medians. Scale with `scale()`. Remove NA rows.

2. **Choose k** — Plot the elbow plot for k = 2 to 8. Choose the optimal k (your choice — justify it in one sentence).

3. **Fit** — Fit k-means with your chosen k, `nstart = 25`, `set.seed(602)`.

4. **Profile** — Join cluster labels back to the original (unscaled) data. For each cluster, report:
   - n (cluster size)
   - Mean age, BMI, income, num_claims, claim_amount
   - % Platinum or Gold plan
   - Fraud rate (%)
   - Churn rate (%)

5. **Name your segments** — Give each cluster a descriptive business label (e.g. "Young Healthy Bronze", "High-Utilisation Platinum") and write 1–2 sentences explaining what makes each segment distinctive.

6. **Visualisation** — Fit a 2-component PCA on the same scaled data. Plot PC1 vs PC2 coloured by cluster label.

## Submission

Knit your Rmd to HTML with the profile table, segment names, and PC scatter plot visible.
