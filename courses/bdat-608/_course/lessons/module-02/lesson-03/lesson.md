# Lesson 5: Closed-Form OLS with lm()

## Goal

Fit a linear model using `lm()`, interpret the `summary()` output, and explain why `lm()` is preferred over `optim()` for standard linear models.

## Concept

In the previous lessons you used `optim()` to find the parameters that minimise RMSE. For ordinary linear models there is a better way: the **closed-form OLS solution**.

### The normal equations

For the linear model $\mathbf{y} = \mathbf{X}\boldsymbol{\beta} + \boldsymbol{\varepsilon}$, the parameters that minimise the sum of squared residuals satisfy:

$$\hat{\boldsymbol{\beta}} = (\mathbf{X}^\top \mathbf{X})^{-1} \mathbf{X}^\top \mathbf{y}$$

This is called the **normal equations**. For simple regression ($y = a_1 + a_2 x$), this reduces to:

$$\hat{a}_2 = \frac{\sum(x_i - \bar{x})(y_i - \bar{y})}{\sum(x_i - \bar{x})^2}, \qquad \hat{a}_1 = \bar{y} - \hat{a}_2 \bar{x}$$

`lm()` computes this via **QR decomposition** — a numerically stable algorithm that avoids explicitly inverting $\mathbf{X}^\top \mathbf{X}$.

### Key `lm()` output

```r
sim1_mod <- lm(y ~ x, data = sim1)
summary(sim1_mod)
```

The `summary()` table contains:

| Output | What it means |
|--------|--------------|
| `Estimate` | The fitted $\hat{\beta}$ values |
| `Std. Error` | Standard error of each estimate |
| `t value` | Estimate / Std. Error — how many SEs from zero |
| `Pr(>|t|)` | p-value: probability of a t this extreme if $\beta = 0$ |
| `R-squared` | Fraction of variance in $y$ explained by the model |
| `F-statistic` | Overall model significance |

### `coef()` and `nobs()`

```r
coef(sim1_mod)    # named vector: (Intercept), x
nobs(sim1_mod)    # number of observations used (important if NAs were dropped)
```

### Why lm() instead of optim()?

| | `optim()` | `lm()` |
|--|-----------|--------|
| Algorithm | Iterative (Nelder-Mead) | Direct (QR decomposition) |
| Speed | Slower; may not converge | Fast; always exact |
| Output | Only parameters and loss value | Full inference table (SEs, p-values, R²) |
| Requires starting values | Yes | No |
| Use case | Custom loss functions | Standard OLS |

For standard OLS, always use `lm()`.

## Example

```r
library(modelr)
data("sim1")

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
# (Intercept)         x
#    4.220822  2.051533

summary(sim1_mod)
# R-squared: 0.8634 — 86% of variance explained
```

The slope ≈ 2.05 means: on average, a one-unit increase in `x` is associated with a 2.05-unit increase in `y`. The intercept ≈ 4.22 is the expected `y` when `x = 0`.

## Task

Open `exercise.Rmd` and complete:

1. Fit `sim1_mod <- lm(y ~ x, data = sim1)`. Extract `coef()` and print `summary()`.
2. What is the R² value? Interpret it in one sentence.
3. Compare the `lm()` coefficients with those found by `optim()` in Lesson 4. How close are they?
4. Compute a 95% confidence interval for the slope using `confint(sim1_mod)`.

## Check

```
npm run check -- bdat-608 module-02 lesson-03
```

## Reflection

`lm()` and `optim(RMSE)` give the same intercept and slope estimates. If the answers are identical, why would we ever prefer `lm()` over `optim()`? Think about what extra information `lm()` provides that `optim()` does not.
