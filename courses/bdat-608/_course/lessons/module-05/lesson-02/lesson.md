# Lesson 12: Robust Regression and Generalised Additive Models

## Goal

Apply `MASS::rlm()` to fit regression models that resist outlier influence, and use `mgcv::gam()` to estimate flexible smooth relationships from data.

## Concept

### Robust Regression with `MASS::rlm()`

OLS **squares** each residual, so a single large outlier can pull the fitted line dramatically toward itself. Robust regression replaces the squared loss with a loss that grows more slowly for large residuals.

**Huber M-estimator** (`method = "M"`):

$$\text{loss}(r) = \begin{cases} r^2/2 & |r| \leq k \\ k|r| - k^2/2 & |r| > k \end{cases}$$

Large residuals (beyond threshold $k$) are down-weighted — they contribute linearly, not quadratically, to the loss.

```r
library(MASS)
mod_ols <- lm(y ~ x,                      data = sim1_out)
mod_rob <- MASS::rlm(y ~ x, method = "M", data = sim1_out)
```

Use `rlm()` when:
- Residual plots show a few extreme points.
- The Normal Q-Q plot has heavy tails.
- Domain knowledge suggests outliers are errors, not real data.

### Generalised Additive Models with `mgcv::gam()`

GAMs replace each linear term $\beta_j x_j$ with a **smooth function** $f_j(x_j)$ estimated from the data:

$$y = \beta_0 + f_1(x_1) + f_2(x_2) + \varepsilon$$

Key functions:
- `s(x)` — a smooth for a single variable (default: thin plate regression spline)
- `te(x1, x2)` — a 2D tensor-product smooth (full interaction surface)
- `method = "REML"` — preferred criterion for smoothness selection
- **edf** (effective degrees of freedom): edf ≈ 1 → nearly linear; edf > 3 → substantial curvature

```r
library(mgcv)
mod_gam <- gam(y ~ s(x1) + s(x2), data = sim4, method = "REML")
summary(mod_gam)  # shows edf for each smooth
plot(mod_gam, shade = TRUE)  # plots estimated smooth effects
```

### Comparing OLS, robust, and GAM

All three use the same `modelr` workflow (`add_predictions()`, `add_residuals()`). The choice depends on data properties:

| Model | Use when |
|-------|---------|
| OLS `lm()` | Normal errors, no outliers, linear mean |
| Robust `rlm()` | Heavy-tailed errors or contaminated data |
| GAM `gam()` | Non-linear smooth effects, complex surfaces |

## Example

```r
# Inject two outliers into sim1
sim1_out <- sim1_base |> mutate(y = ifelse(row_number() %in% c(3,17), y+15, y))

mod_ols <- lm(y ~ x,                      data = sim1_out)
mod_rob <- MASS::rlm(y ~ x, method = "M", data = sim1_out)

cat("OLS slope:    ", coef(mod_ols)[2])   # pulled toward outliers
cat("Robust slope: ", coef(mod_rob)[2])   # close to true ~2.05
```

## Task

Open `exercise.Rmd` and complete:

1. Create `sim1_out` by injecting outliers at rows 3 and 17. Fit OLS and robust. Plot both lines.
2. Print both coefficient tables and compare slopes.
3. Fit a GAM on `sim4`: `gam(y ~ s(x1) + s(x2), method="REML")`. Print `summary()`.
4. Plot the smooth effects using `plot(mod_gam, shade=TRUE)`. Interpret the edf values.
5. Generate a heatmap prediction surface for the GAM.

## Check

```
npm run check -- bdat-608 module-05 lesson-02
```

## Reflection

A GAM with `s(x1)` returns edf = 1.02 for the smooth. What does this tell you about the relationship between `x1` and the response? Would you simplify the model?
