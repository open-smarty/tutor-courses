# Task: Splines, Cross-Validation, and Missing Values

## Objective

Select the optimal spline complexity by cross-validation, understand how R handles missing values in regression, and apply multiple imputation to propagate missingness uncertainty into model estimates.

## Instructions

1. Load `sim5` from `modelr`. Fit `lm(y ~ ns(x, df))` for `df = 1, 3, 5`. Plot all three fitted curves on a scatter of `sim5` coloured by `df`.
2. Run 10-fold CV (`set.seed(42)`) for `df = 1:8` on `sim5`. Plot CV-RMSE vs `df`. Report the optimal `df`.
3. Apply the **one-SE rule**: identify the smallest `df` whose CV-RMSE is within one standard error of the minimum. Is it different from the minimum-RMSE `df`?
4. Create `diam_miss` by setting 10% of `carat` values to `NA` (use `set.seed(99)` before the `runif` call).
5. Fit `lm(log(price) ~ log(carat), data = diam_miss)` with the default `na.action`. Report `nobs()` and `length(residuals())`.
6. Re-fit with `na.action = na.exclude`. Report `nobs()` and `length(residuals())`. Explain the difference.
7. Apply `mice(m = 5, method = "pmm")` to a subset of `diam_miss` containing `price`, `carat`, and `cut`. Fit and pool `lm(log(price) ~ log(carat) + cut)`. Compare the SE for `log(carat)` to the complete-case SE.
8. In two sentences, explain why MI standard errors are larger than complete-case standard errors.

## Submission

Knit to HTML. Required: the spline comparison plot, the CV-RMSE plot, the `nobs()` comparison, and the MI vs complete-case SE comparison.
