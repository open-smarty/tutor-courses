# Task: Churn Prediction with Tree-Based Models

## Objective

Build, tune, and evaluate decision tree and random forest classifiers for churn prediction.

## Instructions

Target variable: `churned`. Predictors: `age`, `bmi`, `income`, `plan_tier`, `deductible`, `num_claims`, `claim_amount`, `support_calls`, `customer_rating`, `auto_pay`, `policy_age_months`.

1. **Preprocessing** — Impute `bmi` and `income` with medians. Remove NA rows.

2. **Decision tree** — Fit `rpart` with `maxdepth = 6`. Plot with `rpart.plot`. Print the variable importance using `tree_fit$variable.importance`.

3. **Pruning** — Use `plotcp()` to identify the optimal `cp`. Prune and re-plot the pruned tree.

4. **Random forest** — Fit with `ntree = 300`, `mtry = 4`. Print OOB error. Plot variable importance.

5. **Evaluation table** — On the test set, compute for both models:

| Model | Accuracy | Precision | Recall | F1 |
|-------|----------|-----------|--------|----|
| Decision tree (pruned) | ? | ? | ? | ? |
| Random forest | ? | ? | ? | ? |

6. **Discussion** — In 2–3 sentences: which model would you recommend for production? What is the trade-off between interpretability and accuracy?

## Submission

Knit your Rmd with the evaluation table, both tree plots, and the variable importance plot visible.
