# Lesson 1: Decision Trees and Random Forests

## Goal

Build a decision tree classifier with `rpart`, interpret splitting rules and variable importance, reduce overfitting by pruning, and upgrade to a random forest for improved accuracy.

## Concept

### Decision Trees

A decision tree partitions the feature space by recursively splitting on the variable and threshold that best separates the classes. Each internal node asks a yes/no question; each leaf predicts a class.

**Splitting criterion:** Gini impurity (default in `rpart`):

$$\text{Gini}(t) = 1 - \sum_{k} p_k^2$$

where $p_k$ is the proportion of class $k$ in node $t$. A pure node has Gini = 0.

**Advantages:** interpretable, handles mixed types, no scaling needed.
**Disadvantage:** high variance — small data changes produce very different trees (overfitting).

---

### Fitting a Decision Tree

```r
library(rpart)
library(rpart.plot)
library(dplyr)
source("R/simulate_bdat602_data.R")

health_small <- simulate_bdat602(n = 10000, seed = 602)

# Train/test split
set.seed(602)
idx   <- sample(nrow(health_small), 0.75 * nrow(health_small))
train <- health_small[idx, ]
test  <- health_small[-idx, ]

# Fit tree to predict churn
tree_fit <- rpart(
  churned ~ age + bmi + income + plan_tier + num_claims +
    claim_amount + support_calls + customer_rating + auto_pay,
  data    = train,
  method  = "class",
  control = rpart.control(maxdepth = 5, minsplit = 50)
)

rpart.plot(tree_fit, type = 4, extra = 104,
           main = "Decision Tree: Churn Prediction")
```

---

### Model Evaluation

```r
# Predictions on test set
pred_class <- predict(tree_fit, test, type = "class")
pred_prob  <- predict(tree_fit, test, type = "prob")[, "1"]

# Confusion matrix
conf_mat <- table(Predicted = pred_class, Actual = test$churned)
print(conf_mat)

# Accuracy, precision, recall
TP  <- conf_mat["1", "1"];  FP <- conf_mat["1", "0"]
TN  <- conf_mat["0", "0"];  FN <- conf_mat["0", "1"]
acc <- (TP + TN) / sum(conf_mat)
pre <- TP / (TP + FP)
rec <- TP / (TP + FN)

cat("Accuracy: ", round(acc, 3), "\n")
cat("Precision:", round(pre, 3), "\n")
cat("Recall:   ", round(rec, 3), "\n")
```

---

### Pruning to Reduce Overfitting

The `cp` (complexity parameter) penalises large trees. Find the optimal `cp` using the 1-SE rule on the cross-validation error:

```r
printcp(tree_fit)
plotcp(tree_fit)

# Prune to the cp with lowest cross-validated error + 1 SE
opt_cp  <- tree_fit$cptable[which.min(tree_fit$cptable[, "xerror"]), "CP"]
tree_pruned <- prune(tree_fit, cp = opt_cp)
rpart.plot(tree_pruned, type = 4, extra = 104,
           main = "Pruned Tree: Churn Prediction")
```

---

### Random Forests

A random forest trains many trees on bootstrap samples, each using a random subset of variables at each split. Predictions are aggregated by majority vote. This reduces variance dramatically.

```r
library(randomForest)

set.seed(602)
rf_fit <- randomForest(
  as.factor(churned) ~ age + bmi + income + plan_tier +
    num_claims + claim_amount + support_calls +
    customer_rating + auto_pay,
  data       = train,
  ntree      = 300,
  mtry       = 3,     # variables per split ≈ √p
  importance = TRUE
)

print(rf_fit)

# Variable importance
varImpPlot(rf_fit, main = "Random Forest Variable Importance")
```

OOB (out-of-bag) error is an unbiased estimate of test error — no separate validation set needed.

## Example

```r
# Test-set accuracy for random forest
rf_pred <- predict(rf_fit, test)
mean(rf_pred == as.factor(test$churned))
```

Random forests typically achieve 5–10 percentage points higher accuracy than a single pruned tree.

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Fit a decision tree (`rpart`) to predict `high_risk` using `age`, `bmi`, `smoker`, `num_chronic_conditions`, and `plan_tier`. Plot it with `rpart.plot()`.
2. Compute the confusion matrix on the test set and report accuracy.
3. Fit a random forest with `ntree = 200`, `mtry = 2`. Plot variable importance.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-05 lesson-01
```

## Reflection

A random forest achieves 94% accuracy on the `high_risk` target. Is this a meaningful performance result? Examine how `high_risk` is defined in `simulate_bdat602_data.R` and explain why accuracy alone may be misleading here.
