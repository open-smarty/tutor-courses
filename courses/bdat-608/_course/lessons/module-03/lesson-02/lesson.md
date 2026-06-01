# Lesson 7: Diagnostic Plots and Model Comparison

## Goal

Read and interpret the four standard OLS diagnostic plots, use `ggfortify::autoplot()` as a ggplot2 alternative, and compare two competing models by overlaying their predictions and residuals.

## Concept

### The four standard OLS diagnostics

Calling `plot(lm_object)` produces a 2×2 grid:

| Plot | What it shows | Ideal appearance |
|------|--------------|-----------------|
| **Residuals vs Fitted** | Non-linearity; heteroscedasticity | Random horizontal band around 0 |
| **Normal Q-Q** | Normality of residuals | Points lying on the 45° diagonal |
| **Scale-Location** | Homoscedasticity (constant variance) | Flat red loess line |
| **Cook's Distance** | Influential observations | No point much greater than 1 |

```r
par(mfrow = c(2, 2))
plot(sim1_mod)
par(mfrow = c(1, 1))
```

### ggplot2-style diagnostics with `ggfortify`

```r
library(ggfortify)
autoplot(sim1_mod, which = 1:4, colour = "#1B3A6B", smooth.colour = "#C9A84C")
```

`autoplot()` produces the same four diagnostics but as ggplot2 objects — easier to customise and embed in Rmd reports.

### Comparing multiple models

`gather_predictions()` stacks predictions from multiple models into one long data frame for faceted comparison:

```r
mod_a <- lm(y ~ x,          data = sim1)
mod_b <- lm(y ~ x + I(x^2), data = sim1)

grid_multi <- sim1 |>
  data_grid(x) |>
  gather_predictions(mod_a, mod_b)

ggplot(sim1, aes(x, y)) +
  geom_point(colour = "grey40") +
  geom_line(data = grid_multi, aes(y = pred, colour = model)) +
  facet_wrap(~ model) +
  theme_minimal()
```

Similarly, `gather_residuals()` stacks residuals for side-by-side comparison.

### Cook's Distance

Cook's Distance measures how much each observation influences the fitted coefficients. A value > 1 (or > 4/n as a stricter rule) indicates a potentially influential point. Large Cook's D combined with a large residual is the most concerning combination.

## Example

For `sim1`, all four diagnostic plots look clean:
- Residuals vs Fitted: random scatter around 0, flat red line.
- Q-Q: points track the diagonal well.
- Scale-Location: flat line — constant variance.
- Cook's Distance: all values small — no single point dominates.

Adding a quadratic term (`mod_b`) makes negligible difference for `sim1` because the relationship is already linear:

```r
AIC(mod_a, mod_b)   # mod_a has lower AIC despite fewer parameters
```

## Task

Open `exercise.Rmd` and complete:

1. Produce the base R 2×2 diagnostic panel for `sim1_mod`.
2. Produce the same diagnostics using `autoplot()`.
3. Fit a quadratic model `mod_b <- lm(y ~ x + I(x^2), data = sim1)`.
4. Use `gather_predictions()` to overlay both models' fitted lines on `sim1`.
5. Use `gather_residuals()` to compare residuals side-by-side with `facet_wrap`.
6. Compare AIC for both models. Which is preferred and why?

## Check

```
npm run check -- bdat-608 module-03 lesson-02
```

## Reflection

A colleague looks at the Normal Q-Q plot for their model and sees that the points deviate strongly from the diagonal at both ends (heavy tails). They say: "The residuals are not normal, so the model is wrong." Is this conclusion correct? What can you say about when normality of residuals matters and when it does not?
