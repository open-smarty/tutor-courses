# Lesson 6: Predictions and Residuals with modelr

## Goal

Use `data_grid()`, `add_predictions()`, and `add_residuals()` from the `modelr` package to visualise a fitted model and inspect its residuals.

## Concept

After fitting a model with `lm()`, you need to see what it predicts and what it missed. The `modelr` package provides three helper functions that work with **any** model that has a `predict()` method:

### `data_grid()` — create a prediction grid

```r
grid <- sim1 |> data_grid(x)
```

`data_grid()` creates a clean data frame spanning the range of each predictor, with evenly spaced values. This is the input to your prediction step.

### `add_predictions()` — overlay fitted values

```r
grid <- grid |> add_predictions(sim1_mod)
# adds a column named `pred`
```

`add_predictions()` calls `predict()` internally for you. The result is a tidy data frame with a `pred` column ready for `ggplot2`.

### `add_residuals()` — compute residuals on the original data

```r
sim1 <- sim1 |> add_residuals(sim1_mod)
# adds a column named `resid`
```

`add_residuals()` computes $y - \hat{y}$ for each row of the original data.

### What to look for in residual plots

A well-specified model produces residuals that:

1. **Centre at zero** — no systematic over- or under-prediction
2. **Show no pattern against predictors** — all structure has been captured
3. **Have roughly constant spread** — no fan-shaped heteroscedasticity

If you see a curved band, a fan shape, or a non-zero mean, the model is misspecified or assumptions are violated.

## Example

```r
library(modelr)
data("sim1")
sim1_mod <- lm(y ~ x, data = sim1)

# Prediction grid + fitted line
grid <- sim1 |>
  data_grid(x) |>
  add_predictions(sim1_mod)

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y), colour = "#1B3A6B", size = 2.5) +
  geom_line(aes(y = pred), data = grid, colour = "#C9A84C", linewidth = 1.3) +
  labs(title = "sim1: Data and Fitted Line") +
  theme_minimal()

# Residuals
sim1 <- sim1 |> add_residuals(sim1_mod)

ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0, colour = "#C9A84C") +
  geom_point(colour = "#1B3A6B", size = 2.5) +
  labs(title = "Residuals vs x") +
  theme_minimal()
```

The residuals plot shows random scatter around zero with no visible curve — confirming that the linear model is correctly specified for `sim1`.

## Task

Open `exercise.Rmd` and complete:

1. Fit `sim1_mod <- lm(y ~ x, data = sim1)`.
2. Build a prediction grid and plot observed data + fitted line.
3. Add residuals to `sim1` and plot a frequency polygon of the residuals.
4. Plot residuals vs `x`. Is the linear model well-specified?

## Check

```
npm run check -- bdat-608 module-03 lesson-01
```

## Reflection

If a residuals-vs-predictor plot showed an upward-curving band (positive residuals for low and high x, negative residuals in the middle), what would this tell you about the model? What would you do next?
