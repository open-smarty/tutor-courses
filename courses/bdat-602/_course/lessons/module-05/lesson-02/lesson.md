# Lesson 12: Handling Class Imbalance

## Goal

After this lesson you can diagnose class imbalance, apply SMOTE oversampling and class-weight adjustment, evaluate imbalanced classifiers with the precision-recall curve, and make an informed choice between threshold adjustment and resampling.

## Concept

### The accuracy paradox

Consider predicting `churned` where only 18% of policyholders churn. A model that predicts "No churn" for every record achieves 82% accuracy with zero false negatives and zero true positives. This is the **accuracy paradox**: accuracy is a misleading metric when the positive class is rare.

**Why?** Accuracy = $(TP + TN) / N$. When $TN$ is huge and $TP = 0$, accuracy looks good but the model is useless for the business objective (identifying churners).

**Better metric**: the Precision-Recall curve. Precision = $TP/(TP+FP)$ (what fraction of your alerts are real?), Recall = $TP/(TP+FN)$ (what fraction of real cases do you catch?). Plot Precision vs. Recall at all classification thresholds. A good model has high area under the PR curve (PR-AUC).

### SMOTE: Synthetic Minority Over-sampling Technique

SMOTE creates synthetic observations in the minority class (churners) rather than duplicating existing ones (which just creates exact copies).

**Step-by-step** for one minority-class point $\mathbf{x}_i$:
1. Find the $k = 5$ nearest neighbours of $\mathbf{x}_i$ among all minority-class points. Call them $\mathbf{x}_{n_1}, \ldots, \mathbf{x}_{n_5}$.
2. Pick one neighbour $\mathbf{x}_n$ at random.
3. Generate a synthetic point:
$$\mathbf{x}' = \mathbf{x}_i + \delta \cdot (\mathbf{x}_n - \mathbf{x}_i), \quad \delta \sim \text{Uniform}(0, 1)$$
The synthetic point lies somewhere on the line segment between $\mathbf{x}_i$ and its chosen neighbour — not an exact copy, but a plausible interpolation.

4. Repeat until the minority class has the desired size.

In the `recipes` package: `themis::step_smote(outcome_column, over_ratio = 1)` (over\_ratio = 1 means balance classes 1:1). **Apply SMOTE only to the training set** — never to the test set.

```r
library(recipes)
library(themis)

rec_smote <- recipe(churned ~ ., data = train) |>
  step_impute_median(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors()) |>
  step_smote(churned, over_ratio = 1) |>
  step_normalize(all_numeric_predictors())

train_smote <- rec_smote |> prep(training = train) |> bake(new_data = NULL)
# Check new class balance:
table(train_smote$churned)
```

### Class weights in randomForest

An alternative to resampling is to penalise misclassification of the minority class more heavily during training:

```r
rf_weighted <- randomForest(
  factor(churned) ~ age + plan_tier + income + num_claims + support_calls,
  data     = train,
  ntree    = 200,
  classwt  = c("0" = 1, "1" = 5),  # penalise missing churners 5×
  importance = TRUE
)
```

The class weight ratio should reflect the inverse of the class frequency: if 18% are churners, a weight of ~5:1 (non-churn:churn) approximately balances the effective cost.

### Threshold adjustment

Both SMOTE and class weights produce a model that assigns higher probabilities to the minority class. But you can also simply lower the classification threshold. Instead of predicting "churn" when $P(\text{churn}) > 0.5$, predict "churn" when $P(\text{churn}) > 0.2$. This increases recall (catches more real churners) at the cost of lower precision (more false alarms).

**Precision-recall curve**: sweep the threshold from 0 to 1, compute precision and recall at each value, and plot. Choose the threshold that maximises the F1 score (or whichever trade-off the business requires).

```r
library(pROC)
pr_curve <- pr.curve(
  scores.class0 = prob_rf_imbalanced,
  weights.class0 = as.integer(test$churned) - 1  # convert to 0/1
)
plot(pr_curve)
```

## Example

```r
library(tidyverse)
library(randomForest)
library(themis)
library(tidymodels)
library(pROC)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 50000, seed = 602)

# Split
set.seed(602)
idx   <- sample(nrow(health_data), 0.80 * nrow(health_data))
train <- health_data[idx, ]
test  <- health_data[-idx, ]

# Show class imbalance
cat("Churn rate in training set:", mean(train$churned), "\n")

# Class-weighted random forest
rf_wt <- randomForest(
  factor(churned) ~ age + plan_tier + income + num_claims + support_calls +
                    auto_pay + customer_rating + deductible,
  data     = train,
  ntree    = 200,
  classwt  = c("0" = 1, "1" = 5),
  importance = TRUE
)

# Evaluate at threshold 0.3
prob_wt <- predict(rf_wt, test, type = "prob")[, "1"]
pred_wt <- factor(ifelse(prob_wt > 0.3, 1, 0), levels = c(0, 1))
cm <- table(Predicted = pred_wt, Actual = test$churned)
print(cm)
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) document the churn rate and show that a naive "always No" model achieves high accuracy; (2) train a class-weighted random forest and compare recall to the unweighted version; (3) apply SMOTE via `themis::step_smote()` in a `recipes` pipeline; (4) compare models with precision-recall curves and F1 scores at multiple thresholds.

## Check

```
npm run check -- bdat-602 module-05 lesson-02
```

## Reflection

SMOTE generates synthetic minority-class observations by interpolating between existing ones. This assumes the minority class forms connected, convex regions in feature space. When might this assumption fail for insurance data, and what could go wrong?
