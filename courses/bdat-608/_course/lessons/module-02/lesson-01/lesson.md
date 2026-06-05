# Lesson 1: Loss Functions — RMSE and MAE

## Goal

Define and implement RMSE and MAE as R functions, explain when each is preferred, and use a random search to find approximate model parameters before closed-form methods are introduced.

## Concept

Every fitting procedure needs a way to measure how wrong a model is. That measure is called a **loss function**. It takes the model's predictions $\hat{y}_i$ and the observed values $y_i$ and returns a single number — the total cost of being wrong. Lower is better.

**Root Mean Squared Error (RMSE).** We define:

$$\text{RMSE} = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y}_i)^2}$$

Step by step: (1) compute each residual $e_i = y_i - \hat{y}_i$; (2) square each residual $e_i^2$ — this penalises large errors more than small ones and removes the sign; (3) average the squared residuals; (4) take the square root to put the result back in the original units.

**Why squaring matters.** Squaring has two effects. First, it makes errors positive (so they do not cancel). Second, it penalises large errors disproportionately — an error of 10 contributes 100 to the sum, while an error of 1 contributes only 1. This means RMSE is sensitive to outliers: a single very large residual can dominate the entire loss.

**Mean Absolute Error (MAE).** The alternative is:

$$\text{MAE} = \frac{1}{n}\sum_{i=1}^{n}|y_i - \hat{y}_i|$$

MAE treats all errors on the same scale — an error of 10 is ten times worse than an error of 1, no more. This makes MAE more **robust** to outliers. The trade-off: MAE is not differentiable at zero, which makes calculus-based optimisation trickier.

**Which to use?** RMSE if you believe errors are roughly normally distributed and outliers are genuine data. MAE if you expect contaminated data or outliers that should not dominate the fit.

**Random search.** Before using any smart optimiser, we can understand model fitting by brute force: generate many random parameter pairs $(\beta_0, \beta_1)$, evaluate the RMSE for each, and pick the pair with the smallest RMSE. This is slow but illuminating — it shows that "fitting" is just searching for the point in parameter space that minimises the loss.

## Example

We work on a 100-row sample of `diamonds`, predicting `price` from `carat`.

**Implement RMSE and MAE as R functions.**

```r
rmse_fn <- function(b0, b1, data) {
  pred  <- b0 + b1 * data$carat
  resid <- data$price - pred
  sqrt(mean(resid^2))
}

mae_fn <- function(b0, b1, data) {
  pred  <- b0 + b1 * data$carat
  resid <- data$price - pred
  mean(abs(resid))
}
```

**Numeric example.** For $\beta_0 = -2000$ and $\beta_1 = 7000$ on a sample of 100 diamonds:

$$\text{RMSE} = \sqrt{\frac{1}{100}\sum_{i=1}^{100}(\text{price}_i - (-2000 + 7000 \times \text{carat}_i))^2} \approx 1{,}450 \text{ USD}$$

This means the model's average prediction error is about \$1,450 per diamond. By contrast, $\beta_0 = -2{,}256$, $\beta_1 = 7{,}756$ (the OLS solution) gives RMSE $\approx 1{,}330$ — lower, confirming it is a better fit.

**Random search over 250 parameter pairs.**

```r
set.seed(7)
d100 <- diamonds |> slice_sample(n = 100)

search <- tibble(
  b0 = runif(250, -5000, 0),
  b1 = runif(250,  5000, 12000)
) |>
  mutate(rmse = map2_dbl(b0, b1, rmse_fn, data = d100))

search |> slice_min(rmse, n = 1)
```

The best random pair will have an RMSE close to, but slightly above, the OLS optimum — demonstrating that random search finds good-but-not-perfect solutions.

**Heatmap of RMSE over parameter space.** Plot `ggplot(search, aes(b0, b1, colour = rmse)) + geom_point()`. The low-RMSE region (dark blue) forms a narrow valley — the true OLS solution sits at the bottom of this bowl.

## Task

Open `exercise.Rmd`. Using a 100-row sample of `diamonds`:

1. Implement `rmse_fn(b0, b1, data)` and `mae_fn(b0, b1, data)` as R functions.
2. Evaluate both at $\beta_0 = -2{,}000$, $\beta_1 = 7{,}000$.
3. Generate 250 random $(\beta_0, \beta_1)$ pairs with `b0` in $[-5000, 0]$ and `b1` in $[5000, 12000]$. Compute RMSE for each.
4. Report the best $(\beta_0, \beta_1)$ from random search.
5. Plot a scatter of `b0` vs `b1` coloured by `rmse`. Describe where the low-RMSE region is.

## Check

```
npm run check -- bdat-608 module-02 lesson-01
```

## Reflection

RMSE penalises large errors more than MAE. Does that mean RMSE is always the better loss function? Think of a real-world scenario (not diamonds) where a large prediction error is catastrophic — does that make RMSE more appropriate or less? What does "appropriate" mean here: better for estimation, or better for decision-making?
