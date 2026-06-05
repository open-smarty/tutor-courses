# Task: Handling Class Imbalance — SMOTE and Class Weights

## Objective

Diagnose class imbalance in the churn dataset, apply two remedies (class-weighted random forest and SMOTE), and compare both approaches using precision-recall metrics.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Accuracy paradox**: Report the churn rate in the training and test sets. Compute the accuracy of a naive "always predict No" classifier on the test set. Compute its recall. In a comment, explain why high accuracy and zero recall can coexist.

3. **Task 2 — Class-weighted RF**: Train `randomForest()` with `classwt = c("0" = 1, "1" = 5)`, `ntree = 200`. Print the OOB confusion matrix. Compute recall on the test set at a 0.5 threshold. Compare to the naive model's recall of 0.

4. **Task 3 — SMOTE**: Build a `recipes` pipeline with `step_smote(churned, over_ratio = 1)` (apply SMOTE only to the training set via `prep(training = train)`). Verify that both churn classes are approximately balanced in the baked training set. Do NOT apply SMOTE to the test set.

5. **Task 4 — Precision-recall comparison**: Train a random forest on the SMOTE-balanced training data (no class weights needed). Generate probability predictions for both the weighted and SMOTE models on the **original test set**. Compute F1 at thresholds 0.3 and 0.5 for both models. Plot precision-recall curves for both models on the same axes. In a comment, state which model achieves the better trade-off and at what threshold.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. All comparisons and conclusions (Tasks 1, 2, 4) must be written as R comments inside their respective code chunks.
