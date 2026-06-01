# Lesson 2: Handling Class Imbalance

## Goal

Explain why class imbalance degrades standard classifiers, apply SMOTE and class-weight adjustment to the fraud detection problem, and evaluate models with precision-recall AUC instead of accuracy.

## Concept

### The Imbalance Problem

The `fraud_flag` target has ~3% positive cases. A classifier that predicts "no fraud" for every record achieves 97% accuracy — but has zero recall on fraud. This is the **accuracy paradox**.

Metrics that matter for imbalanced problems:

| Metric | Formula | What it measures |
|--------|---------|----------------|
| **Precision** | $\frac{TP}{TP + FP}$ | Of flagged cases, how many are truly fraud? |
| **Recall** | $\frac{TP}{TP + FN}$ | Of actual frauds, how many did we catch? |
| **F1** | $\frac{2 \cdot P \cdot R}{P + R}$ | Harmonic mean of precision and recall |
| **AUC-ROC** | Area under ROC curve | Discrimination ability across all thresholds |
| **AUC-PR** | Area under precision-recall curve | Better than AUC-ROC for rare events |

---

### Remedies for Class Imbalance

| Remedy | Mechanism | When to use |
|--------|----------|------------|
| **SMOTE** | Synthetic oversampling of minority class | Moderate imbalance (<10:1) |
| **Random oversampling** | Duplicate minority records | Simple baseline |
| **Random undersampling** | Remove majority records | Large datasets where you can afford data loss |
| **Class weights** | Penalise minority misclassification more | Works directly in many algorithms |
| **Threshold adjustment** | Lower classification threshold below 0.5 | Post-hoc, does not require retraining |

**Critical rule:** apply all sampling remedies on the **training set only** — never on the test set.

---

### SMOTE with themis

`themis` extends `recipes` with sampling steps:

```r
library(recipes)
library(themis)
library(dplyr)
source("R/simulate_bdat602_data.R")

health_small <- simulate_bdat602(n = 10000, seed = 602)

set.seed(602)
idx   <- sample(nrow(health_small), 0.75 * nrow(health_small))
train <- health_small[idx, ]
test  <- health_small[-idx, ]

fraud_vars <- c("age", "employment_type", "claim_amount",
                "num_claims", "weekend_claim", "income",
                "plan_tier", "fraud_flag")

train_sub <- train |>
  select(all_of(fraud_vars)) |>
  mutate(
    income       = if_else(is.na(income), median(income, na.rm=TRUE), income),
    weekend_claim = if_else(is.na(weekend_claim), FALSE, weekend_claim),
    fraud_flag   = as.factor(fraud_flag)
  )

smote_rec <- recipe(fraud_flag ~ ., data = train_sub) |>
  step_dummy(employment_type, plan_tier) |>
  step_normalize(all_numeric_predictors()) |>
  step_smote(fraud_flag, over_ratio = 0.5)  # bring minority to 50% of majority

smote_prep    <- prep(smote_rec, training = train_sub)
train_smoted  <- bake(smote_prep, new_data = NULL)

table(train_smoted$fraud_flag)
```

---

### Class Weights in randomForest

```r
library(randomForest)

n_total  <- sum(!is.na(train$fraud_flag))
n_fraud  <- sum(train$fraud_flag == 1, na.rm = TRUE)
n_normal <- n_total - n_fraud

# Weight: inverse of class frequency
class_wts <- c("0" = 1, "1" = n_normal / n_fraud)

set.seed(602)
rf_weighted <- randomForest(
  as.factor(fraud_flag) ~ age + income + num_claims +
    claim_amount + plan_tier,
  data       = train |> filter(!is.na(income)),
  ntree      = 300,
  classwt    = class_wts,
  importance = TRUE
)
```

---

### Evaluating with Precision-Recall

```r
library(pROC)

# Probability predictions
prob_pred <- predict(rf_weighted,
                     test |> filter(!is.na(income)),
                     type = "prob")[, "1"]

actual <- as.numeric(as.character(
  test$fraud_flag[!is.na(test$income)]
))

# ROC curve
roc_obj <- roc(actual, prob_pred)
cat("AUC-ROC:", round(auc(roc_obj), 3), "\n")
plot(roc_obj, main = "ROC Curve: Fraud Detection")
```

---

### Threshold Adjustment

```r
# Default threshold = 0.5 (optimised for accuracy, not recall)
# Lower it to catch more fraud at the cost of more false positives
threshold <- 0.20
pred_adj  <- as.integer(prob_pred >= threshold)

conf_adj <- table(Predicted = pred_adj, Actual = actual)
recall_adj <- conf_adj["1", "1"] / sum(conf_adj[, "1"])
prec_adj   <- conf_adj["1", "1"] / sum(conf_adj["1", ])

cat("Recall at threshold", threshold, ":", round(recall_adj, 3), "\n")
cat("Precision:                         ", round(prec_adj,   3), "\n")
```

## Example

```r
# Before and after SMOTE: class distribution in training set
cat("Before SMOTE — fraud rate:", round(mean(train$fraud_flag)*100, 2), "%\n")
cat("After SMOTE  — fraud rate:", round(mean(train_smoted$fraud_flag == "1")*100, 2), "%\n")
```

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Report the fraud rate in `health_small`. Fit a random forest to predict `fraud_flag` **without** any imbalance correction. Report the recall on the test set.
2. Refit with `classwt = c("0" = 1, "1" = 30)`. Report the new recall and precision. Has recall improved?
3. Adjust the classification threshold to 0.15. Report the precision-recall trade-off.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-05 lesson-02
```

## Reflection

You lower the threshold to 0.10 and achieve 85% recall on fraud but precision falls to 12%. An operations team can investigate 200 cases per week. The insurer processes 50,000 new claims per week. Calculate how many false alarms the team would receive and explain why precision matters in this operational context.
