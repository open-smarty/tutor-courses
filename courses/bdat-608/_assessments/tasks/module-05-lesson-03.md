# Task: Module 5, Lesson 3 — Elastic Net and Variable Selection

## Objective

Compare LASSO and Elastic Net for variable selection on a noisy dataset.

## Instructions

Simulate data with correlated predictors (a setting where LASSO can struggle):

```r
set.seed(123)
n <- 150; p <- 40
rho <- 0.6  # correlation between adjacent predictors
Sigma <- outer(1:p, 1:p, function(i,j) rho^abs(i-j))
X <- MASS::mvrnorm(n, mu = rep(0,p), Sigma = Sigma)
y_corr <- 3*X[,1] + 3*X[,2] - 2*X[,3] + rnorm(n)
```

Only X[,1], X[,2], X[,3] are true predictors.

1. Fit three models:
   - LASSO (`alpha = 1`)
   - Elastic net (`alpha = 0.5`)
   - Ridge (`alpha = 0`)
   
   For each, use `cv.glmnet()` with `nfolds = 10`.

2. For each model, print the coefficients at `lambda.min`. How many non-zero coefficients does each have?

3. Plot the CV curves for all three models side-by-side (use `par(mfrow=c(1,3))`).

4. Compute the test RMSE for each model on 50 new simulated observations (use the same `Sigma`). Which model generalises best?

5. Given the correlation structure, explain in 3–4 sentences why Elastic Net might outperform LASSO here.

## Submission

Submit the knitted HTML with coefficient counts, plots, and your written comparison.
