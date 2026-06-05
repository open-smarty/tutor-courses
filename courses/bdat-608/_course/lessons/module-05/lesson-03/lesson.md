# Lesson 3: Penalised Regression and Decision Trees

## Goal

Derive Ridge and LASSO as constrained optimisation problems, fit both with `glmnet`, select $\lambda$ by cross-validation, and fit a decision tree with `rpart` — understanding when each approach is preferred.

## Concept

**The overfitting problem.** When $p$ (number of predictors) is large relative to $n$ (number of observations), OLS overfits: it fits the training noise as well as the signal, producing coefficients that are large and unstable. Adding a penalty on coefficient size forces the model to be more parsimonious.

**Ridge regression.** Minimise:

$$\text{RSS} + \lambda \sum_{j=1}^{p}\beta_j^2$$

The penalty $\lambda\|\boldsymbol{\beta}\|_2^2$ is the squared L2 norm of $\boldsymbol{\beta}$ (excluding the intercept). As $\lambda$ increases, all coefficients are shrunk toward zero. They never reach exactly zero (because the L2 ball is smooth with no corners). Ridge is ideal when all predictors are truly relevant but their coefficients should be small.

**LASSO regression.** Minimise:

$$\text{RSS} + \lambda \sum_{j=1}^{p}|\beta_j|$$

The penalty $\lambda\|\boldsymbol{\beta}\|_1$ is the L1 norm. As $\lambda$ increases, some coefficients reach **exactly zero** — LASSO performs automatic variable selection. Why? Geometrically, the L1 ball has corners on the coordinate axes; the RSS contours tend to "touch" the ball at a corner where one coordinate is zero.

**Elastic Net** combines both penalties: $\lambda[\alpha\|\boldsymbol{\beta}\|_1 + (1-\alpha)\|\boldsymbol{\beta}\|_2^2]$. `alpha = 0` is pure Ridge, `alpha = 1` is pure LASSO, $0 < \alpha < 1$ is intermediate.

**`glmnet` in R.** `glmnet(X, y, alpha)` fits the model along a path of 100 $\lambda$ values (from very large → all coefficients zero, to very small → close to OLS). `X` must be a numeric matrix (no factors — use `model.matrix()`). `cv.glmnet(X, y, alpha, nfolds = 10)` runs K-fold CV along the $\lambda$ path and returns:

- `lambda.min`: the $\lambda$ that minimises CV-RMSE (maximum complexity within the chosen path).
- `lambda.1se`: the largest $\lambda$ whose CV-RMSE is within 1 standard error of the minimum — a more parsimonious model, often preferred for prediction.

**Decision trees.** A regression tree recursively partitions the predictor space into rectangles. At each node, it searches for the split $(x_j, t)$ that maximally reduces the residual variance (Gini impurity for classification, variance for regression). The prediction in each leaf is the mean response in that region.

**Key tuning parameters:**

- `maxdepth`: maximum number of splits from root to leaf.
- `cp` (complexity parameter): a split is only made if it reduces relative error by at least `cp`. Setting `cp = 0` gives the largest tree.

**When trees beat regression.** Trees naturally handle: (1) non-linear relationships without transformation, (2) high-order interactions (a split at one variable automatically interacts with all subsequent splits), (3) decision rules interpretable by business users ("if carat > 1.5 and cut = Ideal, predict $8,000"). Trees are highly variable individually (high variance estimators) — random forests and gradient boosting fix this by averaging many trees.

## Example

**Ridge and LASSO on a high-dimensional synthetic dataset.**

We generate a dataset with 200 observations and 50 predictors, of which only the first 2 are truly relevant:

```r
set.seed(2024)
n <- 200; p <- 50
X <- matrix(rnorm(n * p), n, p)
colnames(X) <- paste0("V", 1:p)
y <- 2 * X[, 1] - 1.5 * X[, 2] + rnorm(n)

library(glmnet)
mod_lasso <- cv.glmnet(X, y, alpha = 1, nfolds = 10)
plot(mod_lasso)

coef(mod_lasso, s = "lambda.1se")
# V1: ≈ 1.9, V2: ≈ -1.4, all others: 0
# LASSO correctly identifies the two true predictors.
```

**Compare to Ridge:**

```r
mod_ridge <- cv.glmnet(X, y, alpha = 0, nfolds = 10)
coef(mod_ridge, s = "lambda.1se")
# All 50 coefficients are non-zero but shrunk toward zero.
# Ridge does not set any coefficient to exactly zero.
```

**Decision tree on diamonds.**

```r
library(rpart)
library(rpart.plot)

tree_mod <- rpart(
  price ~ carat + cut + color + clarity,
  data    = diamonds,
  control = rpart.control(maxdepth = 4, cp = 0.001)
)
rpart.plot(tree_mod, type = 4, extra = 101)
```

The tree's first split is always `carat <= some threshold` — confirming that carat is the dominant predictor. Each subsequent split refines the prediction by cut, color, or clarity.

**RMSE comparison:**

```r
# Tree RMSE on training data
tree_pred  <- predict(tree_mod, diamonds)
tree_rmse  <- sqrt(mean((diamonds$price - tree_pred)^2))

# OLS RMSE (log-log model, back-transformed)
mod_lm     <- lm(log(price) ~ log(carat) + cut + color + clarity, data = diamonds)
lm_pred    <- exp(predict(mod_lm, diamonds))
lm_rmse    <- sqrt(mean((diamonds$price - lm_pred)^2))

cat("Tree RMSE:", round(tree_rmse, 0), "\n")
cat("OLS RMSE:", round(lm_rmse, 0), "\n")
```

Trees have higher RMSE here because they are piecewise constant — they cannot extrapolate smoothly within a leaf. The log-log OLS model captures the smooth price-carat relationship much better.

## Task

Open `exercise.Rmd`. Complete the following:

1. Generate the synthetic dataset above (`set.seed(2024)`). Fit Ridge and LASSO using `cv.glmnet()`. Plot the CV curve for LASSO.
2. Extract coefficients at `lambda.1se` for both models. Which predictors does LASSO zero out? Does Ridge zero any?
3. Fit a regression tree on `diamonds` with `maxdepth = 4` and `cp = 0.001`. Use `rpart.plot()` to visualise.
4. What is the first split? What does it tell you about the most important predictor?
5. Compare tree RMSE vs OLS log-log RMSE on the training data.

## Check

```
npm run check -- bdat-608 module-05 lesson-03
```

## Reflection

LASSO performs variable selection by setting coefficients exactly to zero. In practice, this means the selected model depends on the particular random sample — small changes in the data can change which variables are selected. This is called "instability" of LASSO. Ridge, by contrast, never sets coefficients to zero but is more stable across data perturbations. How would you use the bootstrap to quantify the instability of LASSO variable selection?
