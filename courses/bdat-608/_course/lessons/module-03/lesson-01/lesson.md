# Lesson 1: Predictions and Residuals with modelr

## Goal

Use `data_grid()`, `add_predictions()`, and `add_residuals()` from the `modelr` package to visualise the fitted curve and residuals of a log-log diamond model, and diagnose remaining structure in the residuals.

## Concept

After fitting a model, you need to see two things: (1) how well the fitted curve follows the data, and (2) what the model missed. The `modelr` package provides three functions that work with any model that has a `predict()` method — `lm()`, `glm()`, `gam()`, `nls()`, etc.

**`data_grid(data, var)`** creates a regular grid of values for the specified variable(s), spanning the observed range. Think of it as a clean x-axis for drawing a smooth fitted curve — instead of using the original (possibly irregularly spaced) $x$ values, you create, say, 100 evenly spaced values. This ensures the fitted line looks smooth in the plot.

```r
grid <- diamonds |>
  data_grid(carat = seq_range(carat, n = 100))
# Creates a tibble with 100 evenly spaced carat values
```

**`add_predictions(model, var = "pred")`** calls `predict(model, newdata = grid)` internally and appends the result as a new column. The `var` argument sets the column name (default: `"pred"`).

```r
grid <- grid |> add_predictions(mod_loglog, var = "pred")
# adds log(price) predictions for each carat value in the grid
```

**`add_residuals(model, var = "resid")`** computes $e_i = y_i - \hat{y}_i$ for each *observed* row in the original dataset. Note the distinction: predictions go on the grid (new x values); residuals go on the original data (observed x values, because you need $y_i$ to compute $e_i = y_i - \hat{y}_i$).

**Reading a residual plot.** Plot `resid` (y-axis) vs fitted values or the predictor (x-axis). A well-specified model shows:

- Residuals scattered randomly around zero (no curvature).
- Roughly constant spread (no fan shape).
- No clustering by groups or categories.

Any systematic pattern is a signal. In the diamonds log-log model, after removing the carat effect, residuals cluster by `cut` — lower-quality cuts have negative residuals and higher-quality cuts have positive residuals. This tells us `cut` belongs in the model.

## Example

**Step 1: Fit the log-log model.**

```r
mod_loglog <- lm(log(price) ~ log(carat), data = diamonds)
```

**Step 2: Create a prediction grid and overlay on the scatter.**

```r
grid <- diamonds |>
  data_grid(carat = seq_range(carat, n = 100)) |>
  add_predictions(mod_loglog, var = "log_pred") |>
  mutate(pred = exp(log_pred))   # back-transform to price scale

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(alpha = 0.05, colour = "steelblue") +
  geom_line(data = grid, aes(y = pred), colour = "darkorange", linewidth = 1.3) +
  labs(title = "Fitted log-log model on diamonds (price scale)")
```

**Step 3: Attach and plot residuals.**

```r
diamonds_r <- diamonds |>
  add_residuals(mod_loglog, var = "resid")

ggplot(diamonds_r, aes(x = log(carat), y = resid)) +
  geom_point(alpha = 0.1, colour = "steelblue") +
  geom_ref_line(h = 0, colour = "darkorange") +
  labs(title = "Residuals vs log(carat) — log-log model")
```

**Step 4: Colour by cut to reveal the pattern.**

```r
ggplot(diamonds_r, aes(x = log(carat), y = resid, colour = cut)) +
  geom_point(alpha = 0.15) +
  geom_ref_line(h = 0) +
  labs(title = "Residuals coloured by cut — cut effects remain unexplained")
```

**What you see.** The residuals form bands by cut: `Fair` diamonds cluster below zero (overpriced by the carat-only model) and `Ideal` diamonds cluster above zero (underpriced by the carat-only model relative to their true quality-adjusted value). This is the diagnostic signal telling us to add `cut` — and `color` and `clarity` — to the model.

**Numeric example.** A 1-carat Fair diamond: $\log(\text{price})$ predicted by the log-log model = $8.449 + 1.676 \times \log(1) = 8.449$, so $\hat{\text{price}} = e^{8.449} \approx \$4{,}680$. If its actual price is \$3,600, residual = $\log(3600) - 8.449 = 8.189 - 8.449 = -0.260$. Negative — the model overestimated for this Fair diamond.

## Task

Open `exercise.Rmd`. Fit `lm(log(price) ~ log(carat), data = diamonds)` and complete:

1. Create a 200-point `data_grid()` over `carat`. Attach predictions with `add_predictions()`. Back-transform to price scale and overlay on a scatter of the data.
2. Attach residuals to `diamonds` using `add_residuals()`. Plot residuals vs `log(carat)`.
3. Colour the residual plot by `cut`. Describe the pattern you see.
4. Compute the mean residual per cut level using `group_by()` and `summarise()`. Which cut has the most positive mean residual? What does that mean?

## Check

```
npm run check -- bdat-608 module-03 lesson-01
```

## Reflection

`data_grid()` creates a grid for prediction; `add_residuals()` works on observed data. Why can't you compute residuals on the `data_grid()` output? What information is missing from the grid that is present in the original data?
