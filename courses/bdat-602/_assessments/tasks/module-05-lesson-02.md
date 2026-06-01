# Task: Fraud Detection with Class Imbalance Correction

## Objective

Evaluate multiple class imbalance correction strategies for fraud detection and recommend the best operational approach.

## Instructions

Target: `fraud_flag`. Predictors: `age`, `income`, `num_claims`, `claim_amount`, `plan_tier`, `employment_type`, `support_calls`.

1. **Preprocessing** — Impute `income` with median, remove remaining NAs.

2. **Fit three models** on the same training set:
   - **Baseline**: random forest, no correction
   - **Weighted**: random forest, `classwt = c("0" = 1, "1" = 20)`
   - **Threshold-adjusted**: use the weighted model but predict at threshold = 0.15 instead of 0.5

3. **Evaluate** all three on the test set. Fill in:

| Model | Recall | Precision | F1 | AUC-ROC |
|-------|--------|-----------|-----|---------|
| Baseline | ? | ? | ? | ? |
| Class-weighted | ? | ? | ? | ? |
| Threshold 0.15 | ? | ? | ? | ? |

For AUC-ROC, use `pROC::auc(roc(actual, prob_predictions))`.

4. **Operational analysis** — The fraud team can investigate 150 cases per week. The insurer processes 40,000 new claims per week. At each model's recall and precision:
   - How many actual frauds are caught per week?
   - How many false alarms does the team receive?

5. **Recommendation** — Which model/threshold would you deploy? Justify in 3–4 sentences, considering both the fraud team's capacity and the cost of missed frauds.

## Submission

Knit your Rmd with the evaluation table and operational analysis visible.
