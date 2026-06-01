# Lesson 9: Interactions and Transformations

## Goal

Use `*` and `:` to model interactions between predictors, interpret the resulting coefficients, and apply `I()` to protect arithmetic expressions inside formulas.

## Concept

### Interactions

An **interaction** means the effect of one predictor on the response depends on the value of another predictor.

| Formula | Meaning |
|---------|---------|
| `y ~ x1 + x2` | **Additive**: one slope for `x1` in all groups |
| `y ~ x1 * x2` | **Interaction**: slope of `x1` differs by group (`x1 + x2 + x1:x2`) |
| `y ~ x1:x2` | Interaction term only (no main effects) — rarely used alone |

When `x2` is categorical, `x1 * x2` fits a **separate regression line** for each group (different intercepts and slopes):
- Group `a`: $\hat{y} = \beta_0 + \beta_1 x_1$
- Group `b`: $\hat{y} = (\beta_0 + \beta_2) + (\beta_1 + \beta_5) x_1$

**How to choose between additive and interaction:**
1. Plot residuals by group — if the additive model leaves colour-graded patterns, slopes differ.
2. Compare AIC — lower AIC is preferred (penalises extra parameters).

### Transformations with `I()`

In R formulas, `^` is a **formula operator** (crossing), not arithmetic exponentiation. Use `I()` to shield literal arithmetic:

```r
# WRONG — collapses to y ~ x
model_matrix(sim1, y ~ x^2 + x)

# CORRECT — two distinct columns: x and x²
model_matrix(sim1, y ~ I(x^2) + x)

# Log transformation on the response
lm(log(y) ~ x, data = sim1_base)
```

### Two continuous predictors

With two continuous predictors and an interaction:
- **Additive model** (`x1 + x2`): parallel planes — same slope for `x1` regardless of `x2`.
- **Interaction model** (`x1 * x2`): twisted plane — the slope of `x1` increases or decreases with `x2`.

The signature in residual plots: if the additive model residuals show a colour gradient (coloured by `x2`), the interaction is missing.

## Example

```r
library(modelr)
data("sim3")

mod_add <- lm(y ~ x1 + x2, data = sim3)   # parallel lines
mod_int <- lm(y ~ x1 * x2, data = sim3)   # different slopes per group

AIC(mod_add, mod_int)
```

The interaction model has lower AIC because the slopes genuinely differ by group in `sim3`.

## Task

Open `exercise.Rmd` and complete:

1. Fit additive and interaction models on `sim3`. Plot predictions for both side by side.
2. Compare residuals: `gather_residuals(mod_add, mod_int)` faceted by model and group.
3. Compare AIC. Which model is preferred?
4. Verify that `model_matrix(sim1_base, y ~ x^2 + x)` and `model_matrix(sim1_base, y ~ I(x^2) + x)` give different results.

## Check

```
npm run check -- bdat-608 module-04 lesson-02
```

## Reflection

Your additive model on `sim3` has a lower AIC than the interaction model on another dataset where the slopes are genuinely identical. Explain what principle this illustrates about model selection.
