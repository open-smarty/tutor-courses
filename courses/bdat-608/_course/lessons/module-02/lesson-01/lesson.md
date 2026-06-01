# Lesson 3: Loss Functions — RMSE and MAE

## Goal

Implement Root Mean Squared Error (RMSE) and Mean Absolute Error (MAE) as R functions, evaluate them on candidate models, and explain when each is preferred.

## Concept

To "fit" a model means to find the parameter values that bring the model's predictions as close as possible to the observed data. But "close" needs a precise definition — that is what a **loss function** provides.

### RMSE — Root Mean Squared Error

$$\text{RMSE} = \sqrt{\frac{1}{n}\sum_{i=1}^n (y_i - \hat{y}_i)^2}$$

- Residuals are **squared** before averaging, so large errors are penalised much more heavily than small ones.
- Minimising RMSE is mathematically equivalent to **Ordinary Least Squares (OLS)**.
- The squaring makes OLS sensitive to outliers: a single extreme point can pull the entire fitted line toward itself.

### MAE — Mean Absolute Error

$$\text{MAE} = \frac{1}{n}\sum_{i=1}^n |y_i - \hat{y}_i|$$

- All residuals are weighted by their **absolute** magnitude — no squaring.
- No single large residual dominates.
- MAE is more resistant to outliers than RMSE.

### When to prefer each

| Criterion | Prefer when |
|-----------|------------|
| RMSE (OLS) | Noise is approximately normally distributed; outliers are rare |
| MAE | Noise has heavy tails; outliers are present or expected |

> The choice of loss function is a modelling decision that affects which line you end up with. It is worth making consciously.

## Example

```r
library(modelr)
data("sim1")

# Predicted values for a given (intercept, slope) pair
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

# RMSE: penalises large errors quadratically
measure_distance <- function(mod, data) {
  resid <- data$y - model1(mod, data)
  sqrt(mean(resid^2))
}

# MAE: penalises all errors on the absolute scale
measure_mae <- function(mod, data) {
  resid <- data$y - model1(mod, data)
  mean(abs(resid))
}

measure_distance(c(7, 1.5), sim1)   # RMSE for intercept=7, slope=1.5
measure_mae(c(7, 1.5), sim1)        # MAE for the same candidate
```

Running these reveals that `c(7, 1.5)` is a poor fit. A better line will have a lower loss value. The best line is the one where **no small change in the parameters can reduce the loss further**.

To see why MAE is more robust, simulate data with heavy-tailed noise:

```r
set.seed(42)
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)   # Student-t(df=2) = very heavy tails
)
```

Student-$t$ with $df = 2$ occasionally generates extreme values. OLS squares those extremes; MAE does not — so MAE stays closer to the true slope.

## Task

Open `exercise.Rmd` and complete the tasks:

1. Implement `model1()`, `measure_distance()`, and `measure_mae()` as shown above.
2. Evaluate both loss functions for three candidate models: `c(7,1.5)`, `c(5,2)`, and `c(4,2)` on `sim1`. Which candidate has the lowest RMSE?
3. Create `sim1a` (Student-$t$ noise) and compare RMSE vs MAE for the same three candidates. Do the two criteria agree on the best candidate?

## Check

```
npm run check -- bdat-608 module-02 lesson-01
```

## Reflection

You have two loss functions for the same dataset — RMSE and MAE — and they give different "best" candidates. What does this tell you about the relationship between the choice of loss function and the choice of model?
