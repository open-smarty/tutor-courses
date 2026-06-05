# Task: Penalised Regression and Decision Trees

## Objective

Apply Ridge and LASSO regression to a high-dimensional dataset to observe variable selection, and fit a decision tree to diamonds to understand piecewise-constant modelling.

## Instructions

1. Generate the synthetic dataset: `set.seed(2024)`, $n = 200$, $p = 50$ predictors, true signal only in `V1` (coefficient +2) and `V2` (coefficient −1.5).
2. Fit `cv.glmnet(X, y, alpha = 1, nfolds = 10)` for LASSO. Plot the CV curve. Report `lambda.min` and `lambda.1se`.
3. Extract and print coefficients at `lambda.1se`. Count how many are non-zero. Does LASSO correctly identify `V1` and `V2`?
4. Fit `cv.glmnet(X, y, alpha = 0, nfolds = 10)` for Ridge. Extract coefficients at `lambda.1se`. Are any exactly zero?
5. Plot the LASSO coefficient path using `glmnet(X, y, alpha = 1)`. Add a vertical dashed line at `log(lambda.1se)`.
6. Fit `rpart(price ~ carat + cut + color + clarity, data = diamonds, control = rpart.control(maxdepth = 4, cp = 0.001))`. Visualise with `rpart.plot()`. Report the first split.
7. Compute tree RMSE and compare to OLS log-log model RMSE. Which is lower and why?
8. In two sentences, describe a business scenario where a decision tree is preferable to the OLS log-log model despite its higher RMSE.

## Submission

Knit to HTML. Required: the LASSO CV curve, the coefficient table (non-zero coefficients only), the LASSO path plot, the decision tree plot, and the RMSE comparison.
