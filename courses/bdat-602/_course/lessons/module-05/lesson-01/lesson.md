# Lesson 11: Decision Trees and Random Forests

## Goal

After this lesson you can build and prune a decision tree, construct a random forest, evaluate both with confusion matrices and ROC-AUC, and interpret variable importance plots.

## Concept

### Decision trees

A decision tree recursively partitions the feature space into rectangular regions. At each internal node, the algorithm chooses the split (variable + threshold) that maximises the reduction in node impurity.

**Gini impurity** at node $t$ with class proportions $p_1, p_2, \ldots, p_C$:

$$G(t) = 1 - \sum_{c=1}^{C} p_c^2$$

For a binary problem, $G(t)$ ranges from 0 (pure: all one class) to 0.5 (50/50 split). The **information gain** from a split at node $t$ into left child $L$ and right child $R$ is:

$$\Delta G = G(t) - \frac{n_L}{n} G(L) - \frac{n_R}{n} G(R)$$

The algorithm tries every variable and every threshold, and greedily selects the split with the largest $\Delta G$.

**Numeric example**: at a node with 100 observations, 60 non-churners and 40 churners:
- $G(\text{parent}) = 1 - (0.6^2 + 0.4^2) = 1 - (0.36 + 0.16) = 0.48$
- Split on `plan_tier = "Bronze"` sends 55 non-churners + 20 churners to left (n=75), 5 + 20 to right (n=25).
- $G(L) = 1 - (55/75)^2 - (20/75)^2 = 1 - 0.537 - 0.071 = 0.392$
- $G(R) = 1 - (5/25)^2 - (20/25)^2 = 1 - 0.04 - 0.64 = 0.32$
- $\Delta G = 0.48 - (75/100)(0.392) - (25/100)(0.32) = 0.48 - 0.294 - 0.08 = 0.106$

**Pruning with cp**: trees that grow too deep overfit. In `rpart`, the complexity parameter `cp` penalises model size. The tree is pruned back if adding a split increases complexity cost by more than `cp × root RSS`. Use cross-validation (`plotcp()`) to select the optimal `cp`.

```r
library(rpart)
library(rpart.plot)
tree <- rpart(churned ~ age + plan_tier + income + num_claims + support_calls,
              data = train, method = "class", cp = 0.005)
rpart.plot(tree, type = 4, extra = 104)
```

### Random forests

A single decision tree is high-variance: small changes in the training data produce very different trees. Random forests reduce variance by averaging many de-correlated trees.

**Algorithm**:
1. Draw $B$ bootstrap samples (sampling with replacement) from the training data. Each sample is about $n$ rows, but ~37% of observations are omitted (the out-of-bag or OOB sample).
2. On each bootstrap sample, grow a decision tree. **At each node**, consider only $m = \lfloor\sqrt{p}\rfloor$ randomly chosen features (for classification).
3. To predict, average the $B$ tree predictions (or take the majority vote for classification).

**Why do two tricks help?**
- *Bagging* (bootstrap aggregation): averaging $B$ unbiased predictors reduces variance by $1/B$.
- *Random feature selection*: if one feature dominates, all trees would use it at the first split — making them highly correlated. Randomly restricting the feature set decorrelates the trees, so averaging them provides more variance reduction than averaging correlated trees.

**Variable importance**: for each variable, measure the total reduction in node impurity across all splits on that variable, averaged over all $B$ trees. Higher = more important.

**OOB error**: for each tree, the ~37% of observations not in the bootstrap sample (OOB observations) can be used to evaluate the tree without a separate validation set. Average the OOB predictions across all trees to get the OOB error rate — a nearly unbiased estimate of test error.

### Evaluation metrics

| Metric | Formula | When to use |
|---|---|---|
| Accuracy | $(TP+TN)/(TP+TN+FP+FN)$ | Balanced classes |
| Precision | $TP/(TP+FP)$ | Cost of false alarms is high |
| Recall (Sensitivity) | $TP/(TP+FN)$ | Cost of missed positives is high |
| F1 | $2 \times P \times R / (P + R)$ | Imbalanced classes |
| ROC-AUC | Area under sensitivity vs. 1-specificity | Overall discriminative ability |

```r
library(randomForest)
library(pROC)

rf <- randomForest(factor(churned) ~ age + plan_tier + income + num_claims + support_calls,
                   data = train, ntree = 200, mtry = 2, importance = TRUE)
varImpPlot(rf)
pred_prob <- predict(rf, test, type = "prob")[, 2]
roc(test$churned, pred_prob, plot = TRUE)
```

### Scaling classification to 500,000 rows with Spark

`rpart` and `randomForest` both run on a single core and load all data into RAM. For the full 500,000-row insurance dataset, `sparklyr` exposes Spark MLlib's distributed implementations:

| R function | Spark MLlib equivalent |
|---|---|
| `rpart(..., method = "class")` | `ml_decision_tree_classifier()` |
| `randomForest(factor(y) ~ ...)` | `ml_random_forest_classifier()` |
| `predict(model, test)` | `ml_predict(model, test_tbl)` |

```{r spark-classify, eval=FALSE}
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

health_tbl <- copy_to(sc,
  simulate_bdat602(n = 500000, seed = 602),
  name = "health_ins", overwrite = TRUE
)

# Spark requires all predictors to be numeric; factors are handled via formula
health_tbl <- health_tbl |>
  mutate(
    plan_tier_num = case_when(
      plan_tier == "Bronze"   ~ 1L,
      plan_tier == "Silver"   ~ 2L,
      plan_tier == "Gold"     ~ 3L,
      plan_tier == "Platinum" ~ 4L
    )
  )

# Split in Spark (80/20 stratification not directly available — use sdf_random_split)
splits     <- sdf_random_split(health_tbl, training = 0.80, test = 0.20, seed = 602)
train_spark <- splits$training
test_spark  <- splits$test

# Distributed random forest classifier
rf_spark <- train_spark |>
  ml_random_forest_classifier(
    formula      = churned ~ age + plan_tier_num + income + num_claims +
                             support_calls + auto_pay + customer_rating + deductible,
    num_trees    = 100,
    feature_subset_strategy = "sqrt",
    seed         = 602
  )

# Predictions
preds <- ml_predict(rf_spark, test_spark)

# Evaluate with ml_binary_classification_evaluator
auc <- ml_binary_classification_evaluator(
  preds,
  label_col      = "churned",
  raw_prediction_col = "rawPrediction",
  metric_name    = "areaUnderROC"
)
cat("Spark RF ROC-AUC:", round(auc, 3), "\n")

spark_disconnect(sc)
```

**Key difference from local RF**: Spark builds trees in parallel across partitions. The `feature_subset_strategy = "sqrt"` mirrors `mtry = floor(sqrt(p))` in `randomForest`. The model object lives in Spark memory — you never bring all 500,000 rows into R.

## Example

Full worked example in `solution.Rmd` trains both a decision tree and a random forest on the insurance dataset, tunes the tree with `plotcp()`, evaluates both with confusion matrix and ROC-AUC, plots variable importance, and compares against the Spark random forest.

## Task

Open `exercise.Rmd` and complete the five tasks: (1) train a decision tree on `churned` and plot it; (2) tune `cp` using `plotcp()`; (3) train a random forest with `ntree = 200`, plot variable importance; (4) compare decision tree vs. random forest on ROC-AUC and F1 score; (5) run `ml_random_forest_classifier()` on the full 500,000-row dataset in Spark and compare its AUC against the local random forest.

## Check

```
npm run check -- bdat-602 module-05 lesson-01
```

## Reflection

Random forests cannot be directly visualised as trees. How would you explain a random forest prediction to a non-technical insurance underwriter who needs to understand *why* a customer was flagged as high-risk?
