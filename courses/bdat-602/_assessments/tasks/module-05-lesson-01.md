# Task: Decision Tree and Random Forest for Churn Prediction

## Objective

Train and tune a decision tree, train a random forest, and compare both models on ROC-AUC and F1 score for predicting policyholder churn.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Decision tree**: Split the 50,000-row dataset 80/20 into train/test (stratified or simple random). Train a `rpart` tree for `churned` using: `age`, `plan_tier`, `income`, `num_claims`, `support_calls`, `auto_pay`, `customer_rating`, `deductible`. Set `cp = 0.005`. Plot the tree with `rpart.plot()`.

3. **Task 2 — Pruning**: Call `plotcp()` to visualise cross-validation error vs. cp. Identify the best cp (minimum xerror). Prune the tree with `prune()` and plot the pruned tree.

4. **Task 3 — Random forest**: Train `randomForest()` with `ntree = 200, mtry = floor(sqrt(8)), importance = TRUE` on the same predictors. Print the OOB error. Plot variable importance with `varImpPlot()`. In a comment, name the top 3 most important variables and explain why they make business sense for predicting churn.

5. **Task 4 — Comparison**: Generate class probability predictions from both models on the test set. Compute and compare ROC-AUC and F1 (at threshold 0.5) for both models. In a comment, state which model wins on each metric and why you think the winner outperforms.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Variable importance interpretation (Task 3) and model comparison (Task 4) must be written as R comments inside their code chunks.
