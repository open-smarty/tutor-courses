# Lesson 3: Splines, Cross-Validation, and Missing Values

## Goal

Fit natural splines with `ns()`, choose the number of degrees of freedom by 10-fold cross-validation, and handle missing values with `na.exclude` and multiple imputation using `mice`.

## Concept

**Natural splines.** A polynomial regression curve such as `y ~ poly(x, 5)` can oscillate wildly outside the training data range. A **natural spline** (`ns(x, df)`) is a piecewise cubic polynomial that is smooth at the join points (knots) and **linear in the tails** — it cannot oscillate beyond the data range. The `df` argument controls the number of degrees of freedom (roughly, the number of internal knots + 1). Key relationships:

- `df = 1` → the spline is a straight line (like `lm(y ~ x)`).
- `df = 3` → one internal knot, can bend once.
- `df = 10` → very flexible, many bends.

The natural spline is fitted as part of `lm()`: `lm(y ~ ns(x, df = 5), data = d)`. The `ns()` function generates the spline basis matrix as columns of the design matrix.

**Choosing `df` by K-fold cross-validation.** We want the `df` that minimises out-of-sample prediction error — not training error. Overfitting gives perfect training fit but poor generalisation.

**10-fold CV procedure:**

1. Randomly split the data into $K = 10$ equally sized folds.
2. For each fold $k = 1, \ldots, K$:
   - Train on folds $1, \ldots, k-1, k+1, \ldots, K$ (9 folds).
   - Predict on fold $k$ (the held-out fold).
   - Compute RMSE on the held-out fold.
3. CV-RMSE for a given `df` = $\frac{1}{K}\sum_{k=1}^{K} \text{RMSE}_k$.
4. Repeat for `df = 1, 2, ..., 10`.
5. Choose the `df` at the minimum CV-RMSE. Apply the **one-SE rule**: choose the smallest `df` whose CV-RMSE is within one standard error of the minimum (more parsimonious model, nearly as good).

In R, `caret::createFolds(y, k = 10)` creates the fold indices.

**Missing values.** `lm()` uses `na.omit` by default: rows with any `NA` are dropped silently. This can cause problems:

- **Information loss**: fewer rows means less statistical power.
- **Selection bias**: if missingness is related to the response (not Missing Completely At Random), dropping rows biases estimates.
- **Index misalignment**: `na.omit` changes the row count, so `predict()` and `residuals()` vectors have different lengths than the original data frame.

**`na.action = na.exclude`** is often better: it drops NA rows for fitting but preserves their positions in the residuals and predictions vectors (filling them with `NA`). This makes it easier to merge fitted values back into the original data frame.

**Multiple imputation with `mice`.** When missingness is substantial (> 5%), **multiple imputation** is the gold standard:

1. `mice(data, m = 5, method = "pmm")` creates $m = 5$ complete datasets by imputing each missing value from a predictive model using **predictive mean matching** (PMM).
2. `with(imp, lm(y ~ x))` fits the model on each of the 5 complete datasets.
3. `pool(fit)` combines the 5 sets of estimates using **Rubin's rules**:

$$\bar{\beta} = \frac{1}{m}\sum_{j=1}^{m}\hat{\beta}_j, \quad \text{Var}(\bar{\beta}) = \underbrace{\frac{1}{m}\sum_{j=1}^{m}\hat{V}_j}_{\text{within}} + \underbrace{\left(1+\frac{1}{m}\right)\frac{1}{m-1}\sum_{j=1}^{m}(\hat{\beta}_j - \bar{\beta})^2}_{\text{between}}$$

The between-imputation variance captures the uncertainty due to not knowing the true values of the missing data. Standard errors from MI are always at least as large as from complete-case analysis.

## Example

**Spline fit on `sim5` (a sinusoidal dataset from `modelr`).**

```r
library(splines)
data("sim5", package = "modelr")

# Try df = 1, 3, 5
for (df in c(1, 3, 5)) {
  mod <- lm(y ~ ns(x, df), data = sim5)
  cat("df =", df, " R² =", round(summary(mod)$r.squared, 3), "\n")
}
# df = 1: R² = 0.07 (underfits the sine curve)
# df = 3: R² = 0.64 (captures one bend)
# df = 5: R² = 0.92 (captures the full sinusoidal pattern)
```

**10-fold CV to choose df on `sim5`.**

```r
library(caret)
set.seed(42)
cv_rmse <- sapply(1:8, function(df) {
  folds <- createFolds(sim5$y, k = 10)
  mean(sapply(folds, function(idx) {
    train <- sim5[-idx, ]
    test  <- sim5[ idx, ]
    pred  <- predict(lm(y ~ ns(x, df), data = train), newdata = test)
    sqrt(mean((test$y - pred)^2))
  }))
})
which.min(cv_rmse)  # optimal df
```

**Multiple imputation on diamonds.** Introduce 10% missingness into `carat`:

```r
library(mice)
set.seed(1)
diam_miss <- diamonds |>
  mutate(carat = ifelse(runif(n()) < 0.10, NA, carat))

imp <- mice(diam_miss |> select(price, carat, cut),
            m = 5, method = "pmm", printFlag = FALSE)
fit <- with(imp, lm(log(price) ~ log(carat) + cut))
pool(fit) |> summary()
```

**Numeric illustration.** With 10% missing `carat` (about 5,394 rows missing), `na.omit` uses only 48,546 rows. MI uses all 53,940 rows, with uncertainty about the imputed values reflected in the wider standard errors for the `carat` coefficient.

## Task

Open `exercise.Rmd`. Complete the following:

1. Load `sim5` from `modelr`. Fit `lm(y ~ ns(x, df))` for `df = 1, 3, 5`. Plot all three fits on the same scatter plot.
2. Run 10-fold CV (with `set.seed(42)`) for `df = 1` to `8` on `sim5`. Plot CV-RMSE vs `df`. Report the optimal `df`.
3. Create `diam_miss` by setting 10% of `carat` values to `NA` in `diamonds`. Compare `na.omit` and `na.exclude` behaviour: run `lm(log(price) ~ log(carat), data = diam_miss)` with each. How many rows does each use?
4. Apply `mice()` with `m = 5` and `method = "pmm"`. Fit the model on each imputed dataset and pool. Compare the standard error of `log(carat)` from MI to the complete-case analysis.

## Check

```
npm run check -- bdat-608 module-04 lesson-03
```

## Reflection

Multiple imputation with `mice` creates $m$ plausible complete datasets, each consistent with the observed data. But the imputed values are not the "true" missing values — they are random draws from a predictive distribution. If $m$ is too small (e.g., $m = 2$), the between-imputation variance estimate is unreliable. How large should $m$ be in practice, and does the answer depend on the fraction of missing data?
