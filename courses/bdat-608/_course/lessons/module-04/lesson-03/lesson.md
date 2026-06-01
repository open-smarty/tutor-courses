# Lesson 10: Splines, Cross-Validation, and Missing Values

## Goal

Fit natural spline models with `ns()`, select the optimal degrees of freedom by 10-fold cross-validation, and handle missing values correctly using `na.exclude` and multiple imputation with `mice`.

## Concept

### Natural splines with `ns()`

`poly()` polynomials capture non-linearity but extrapolate wildly outside the data range. **Natural splines** are a better-behaved alternative:

- They divide the predictor range into segments at **knots** and fit smooth low-degree polynomials within each segment.
- The key constraint: **linear in the tails** — no wild extrapolation.
- `df` controls the complexity: more degrees of freedom → more knots → more flexibility.

```r
library(splines)
set.seed(1)
sim5 <- tibble(x = seq(0, 3.5 * pi, length = 50), y = 4 * sin(x) + rnorm(50))

sp_mods <- list(
  df1 = lm(y ~ ns(x, 1), data = sim5),
  df3 = lm(y ~ ns(x, 3), data = sim5),
  df5 = lm(y ~ ns(x, 5), data = sim5)
)
```

### Choosing `df` by 10-fold cross-validation

Cross-validation estimates out-of-sample performance to prevent overfitting:

1. Split data into 10 folds.
2. For each fold: train on 9, test on 1, compute RMSE.
3. Average across the 10 held-out RMSEs.
4. Choose the `df` at the **minimum CV-RMSE** (or the one-SE rule: smallest `df` within 1 SE of the minimum).

```r
library(caret)
set.seed(42)
cv_rmse <- sapply(1:8, function(df) {
  folds <- createFolds(sim5$y, k = 10)
  mean(sapply(folds, function(idx) {
    train <- sim5[-idx, ]; test <- sim5[idx, ]
    sqrt(mean((test$y - predict(lm(y ~ ns(x, df), data = train), test))^2))
  }))
})
```

The CV curve is **U-shaped**: too few df = underfit (high bias); too many = overfit (high variance on new data).

### Missing values

`lm()` silently drops rows with `NA` values. Two important options:

| Option | Behaviour |
|--------|----------|
| `na.omit` (default) | Drops NA rows; output vectors are shorter than the input |
| `na.exclude` | Drops NA rows but **preserves row positions** in output vectors |

Use `na.exclude` when you need to merge predictions or residuals back to the original data frame — it inserts `NA` in the output at the positions of dropped rows.

#### Multiple imputation with `mice`

When missingness is substantial (> 5–10%), dropping rows wastes information and can introduce bias. Multiple imputation generates $m$ complete datasets, fits the model on each, and pools results using **Rubin's rules**:

```r
library(mice)
imp <- mice(df_miss, m = 5, method = "pmm", printFlag = FALSE)
fit_imp <- with(imp, lm(y ~ x))
pool(fit_imp) |> summary()
```

The pooled standard errors are always at least as large as complete-case standard errors because they account for uncertainty due to missing data.

## Example

```r
# Cross-validation for ns() on sim5
tibble(df = 1:8, cv_rmse) |>
  ggplot(aes(df, cv_rmse)) +
  geom_line(colour = "#1B3A6B") + geom_point(colour = "#C9A84C", size = 3) +
  labs(title = "10-fold CV RMSE vs spline df") + theme_minimal()
```

The minimum is typically at df = 4 or 5 for `sim5`, matching the sinusoidal pattern that spans ~1.75 wavelengths.

## Task

Open `exercise.Rmd` and complete:

1. Fit spline models with df = 1, 3, 5 on `sim5`. Plot all three fits faceted by model.
2. Run 10-fold CV for df = 1 to 8. Plot the CV curve and identify the optimal df.
3. Demonstrate `na.exclude` vs `na.omit` on a small data frame with two NA rows. Check that `na.exclude` preserves row positions.
4. Apply multiple imputation to `sim1_base` with 10% of `y` values artificially set to `NA`. Compare pooled estimates to complete-case `lm()`.

## Check

```
npm run check -- bdat-608 module-04 lesson-03
```

## Reflection

Cross-validation involves withholding observations from model fitting. Explain the trade-off between using few folds (e.g., 3-fold) versus many folds (e.g., leave-one-out CV) in terms of bias and variance of the CV estimate.
