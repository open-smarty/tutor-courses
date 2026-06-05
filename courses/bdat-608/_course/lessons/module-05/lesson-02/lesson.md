# Lesson 2: Robust Regression and Generalised Additive Models

## Goal

Explain the Huber loss and fit robust regression with `MASS::rlm()`, and fit a GAM with smooth terms using `mgcv::gam()` — interpreting effective degrees of freedom and comparing to the linear model.

## Concept

**The fragility of OLS.** OLS minimises the sum of squared residuals. Squaring means that one observation with a residual of 100 contributes 10,000 to the loss — the same as 100 observations each with a residual of 10. A single outlier can therefore dominate the entire fit, pulling the estimated line dramatically toward itself. This is not a statistical failure; it is an arithmetic consequence of the squared loss.

**Huber's loss function.** Huber (1964) proposed a loss that behaves like the squared loss for small residuals but like the absolute loss for large residuals:

$$\rho(r) = \begin{cases} r^2 / 2 & |r| \leq c \\ c|r| - c^2/2 & |r| > c \end{cases}$$

The threshold $c$ (default $c = 1.345 \hat{\sigma}$ in `rlm()`) is chosen to give 95% efficiency under normal errors. For small residuals, this is quadratic — same as OLS. For large residuals, it grows only linearly — capping the influence of extreme observations.

**`MASS::rlm()`** fits a linear model by iteratively reweighted least squares (IRLS): start with OLS, downweight observations with large residuals, refit, repeat until convergence. The resulting estimates are much less sensitive to outliers than OLS.

**When to use robust regression:** (1) when you suspect contaminated data (entry errors, outliers from a different process), (2) when the noise distribution is heavy-tailed, (3) as a diagnostic — if `lm()` and `rlm()` give very different estimates, influential outliers are present.

**Generalised Additive Models (GAMs).** A linear model says: $y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \varepsilon$. A GAM replaces the linear terms with smooth functions:

$$y = \alpha + f_1(x_1) + f_2(x_2) + \varepsilon$$

where each $f_j$ is estimated as a smooth curve (typically a penalised regression spline). The penalty controls smoothness: heavier penalty → smoother curve (lower EDF); lighter penalty → wigglier curve (higher EDF). `mgcv::gam()` selects the penalty automatically using REML.

**Effective degrees of freedom (EDF).** Each smooth $f_j$ has an associated EDF. EDF = 1 means the smooth is a straight line (equivalent to a linear term). EDF = 3 means it bends about as much as a cubic polynomial. EDF = 8+ means a very flexible curve. You can read EDF from `summary(gam_fit)` under "Approximate significance of smooth terms."

**Formula syntax for GAMs:**

- `s(x)` — a single-variable smooth (thin plate spline by default).
- `s(x, k = 20)` — with up to 20 basis functions (max flexibility).
- `te(x1, x2)` — a tensor product smooth for a 2D interaction surface.
- `s(x, by = group)` — different smooth per level of `group`.

## Example

**Demonstrating OLS fragility with a planted outlier.**

```r
library(MASS)
library(tidyverse)
library(modelr)

data("sim1", package = "modelr")
sim1_out <- sim1 |>
  mutate(y = ifelse(row_number() %in% c(5, 15), y + 20, y))

mod_ols <- lm(y ~ x,                     data = sim1_out)
mod_rob <- rlm(y ~ x, method = "M",      data = sim1_out)

cat("OLS:    intercept =", round(coef(mod_ols)[1], 2),
    " slope =", round(coef(mod_ols)[2], 2), "\n")
cat("Robust: intercept =", round(coef(mod_rob)[1], 2),
    " slope =", round(coef(mod_rob)[2], 2), "\n")
# True values ≈ 4.22, 2.05
# OLS slope is pulled upward by the two outliers.
# Robust slope stays close to the true value.
```

**Fitting a GAM on diamonds.**

```r
library(mgcv)
mod_gam <- gam(
  log(price) ~ s(carat) + s(depth) + s(table) + cut + color + clarity,
  data   = diamonds,
  method = "REML"
)
summary(mod_gam)
# EDF for s(carat): e.g. 8.9 — highly non-linear
# EDF for s(depth): e.g. 2.1 — mildly non-linear
plot(mod_gam, pages = 1, shade = TRUE)
```

The `plot()` shows each smooth with 95% confidence bands. If the band for a smooth covers a flat horizontal line, that smooth is not significant — drop it and use a linear term instead.

**Comparing GAM to LM:**

```r
mod_lm <- lm(log(price) ~ carat + depth + table + cut + color + clarity,
             data = diamonds)
AIC(mod_lm, mod_gam)
```

The GAM will have lower AIC — the smooth for `carat` captures non-linearity in the carat-price relationship that the linear term cannot.

**Numeric example.** For `s(carat)` with EDF = 8.9: the smooth has 8.9 effective parameters. A linear term `carat` uses 1 parameter. The additional 7.9 parameters are "spent" capturing the non-linear shape of the carat effect — the GAM learns the shape directly from data rather than imposing linearity.

## Task

Open `exercise.Rmd`. Complete the following:

1. Add two large outliers to `sim1`: add 20 to `y` for rows 5 and 15. Fit `lm()` and `rlm()`. Plot both lines. Compare the slopes and intercepts.
2. Fit `gam(log(price) ~ s(log(carat)) + s(depth) + cut, data = diamonds, method = "REML")`. Print `summary()`.
3. Read the EDF for each smooth. Is `s(depth)` approximately linear (EDF ≈ 1) or strongly non-linear (EDF >> 1)?
4. Use `plot(mod_gam, pages = 1, shade = TRUE)` to visualise the smooths.
5. Compare `AIC(mod_lm_simple, mod_gam)` where `mod_lm_simple` uses linear terms. Which wins?

## Check

```
npm run check -- bdat-608 module-05 lesson-02
```

## Reflection

The GAM learns the shape of each smooth from the data, without the modeller specifying the functional form in advance. This is an advantage (flexibility) but also a risk (the smooth may overfit to noise). The penalty controls this trade-off. What happens if the penalty is set too high (towards zero EDF)? What happens if it is set too low (very high EDF)? How does REML automatic selection balance these two extremes?
