# Lesson 13: Penalised Regression and Decision Trees

## Goal

Apply Ridge and LASSO regularisation with `glmnet` to handle high-dimensional data, and fit and visualise a regression tree with `rpart`.

## Concept

### When OLS overfits

OLS finds the exact minimum of the training loss. When $p$ (predictors) is large relative to $n$ (observations), OLS can fit the training data perfectly but generalise poorly to new data. **Penalised regression** adds a regularisation term:

$$\hat{\boldsymbol{\beta}}_\lambda = \arg\min\Bigl[\sum(y_i - \hat{y}_i)^2 + \lambda \cdot \text{Penalty}(\boldsymbol{\beta})\Bigr]$$

| Method | Penalty | Effect |
|--------|---------|--------|
| **Ridge** (`alpha = 0`) | $\lambda\sum\beta_j^2$ | Shrinks all coefficients toward zero; keeps all variables |
| **LASSO** (`alpha = 1`) | $\lambda\sum|\beta_j|$ | Sets some coefficients **exactly to zero** — automatic variable selection |
| **Elastic net** (`0 < alpha < 1`) | Mix of both | Compromise |

Larger $\lambda$ → more shrinkage → simpler model. Use cross-validation to choose $\lambda$.

```r
library(glmnet)
cv_lasso <- glmnet::cv.glmnet(X, y, alpha = 1, nfolds = 10)
best_lambda <- cv_lasso$lambda.min
coef(cv_lasso, s = "lambda.min")
```

### Decision Trees with `rpart`

Decision trees recursively split the predictor space into rectangular regions, predicting the **mean response** within each leaf.

```r
library(rpart); library(rpart.plot)
tree_mod <- rpart(y ~ x1 + x2, data = sim4,
                  control = rpart.control(maxdepth = 4, cp = 0.01))
rpart.plot(tree_mod, type = 4, extra = 101)
```

Key parameters:
- `maxdepth`: maximum tree depth (more depth = more complex)
- `cp`: complexity parameter — prune any split that does not improve $R^2$ by at least `cp`

The prediction surface of a tree is **piecewise constant** — visible as hard rectangular edges in a heatmap.

### Model comparison summary

| Model | Key strength | Key weakness |
|-------|-------------|-------------|
| Ridge | Handles correlated predictors | All variables stay; no selection |
| LASSO | Automatic variable selection | Unstable when predictors are correlated |
| Decision tree | Interpretable; handles non-linear interactions | High variance; bad extrapolation |

## Example

```r
set.seed(2024); p <- 50; n <- 200
X <- matrix(rnorm(n*p), n, p)
y <- 2*X[,1] - 1.5*X[,2] + rnorm(n)   # only 2 true predictors

cv_lasso <- cv.glmnet(X, y, alpha = 1, nfolds = 10)
plot(cv_lasso)
coef(cv_lasso, s = "lambda.min")[1:6,]
# V1 ≈ 2, V2 ≈ -1.5, V3-V6 ≈ 0 → LASSO recovered the true predictors
```

## Task

Open `exercise.Rmd` and complete:

1. Simulate the high-dimensional data (p=50, n=200, only V1 and V2 matter). Fit LASSO and Ridge.
2. Plot `cv_lasso` CV curve. Report `lambda.min`.
3. Print the first 6 coefficients at `lambda.min`. Did LASSO set noise predictors to zero?
4. Plot LASSO coefficient paths (`plot(mod_lasso, xvar = "lambda")`).
5. Fit a regression tree on `sim4` (`maxdepth=4`). Visualise with `rpart.plot()`.
6. Generate a heatmap prediction surface for the tree. Compare it to the OLS heatmap.

## Check

```
npm run check -- bdat-608 module-05 lesson-03
```

## Reflection

LASSO sets some coefficients to exactly zero while Ridge shrinks them toward zero but never to zero. For a dataset where you know that only a few out of many predictors are truly relevant, which method is more appropriate and why?
