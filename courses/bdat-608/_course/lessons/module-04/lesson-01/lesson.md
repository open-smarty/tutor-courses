# Lesson 8: Formula Notation, Model Matrix, and Categorical Predictors

## Goal

Write R formulas using the `+`, `-`, and `*` operators, inspect the resulting design matrix with `model_matrix()`, and correctly fit and interpret a model with a categorical predictor.

## Concept

R uses a compact **formula notation** to specify model structure. Every modelling function (`lm`, `glm`, `gam`, ...) interprets the same formula language.

### Formula operators

| Syntax | Meaning | Example |
|--------|---------|---------|
| `y ~ x1 + x2` | Add predictors | Two main effects |
| `y ~ x1 - 1` | Remove intercept | No intercept column |
| `y ~ x1 * x2` | Main effects + interaction | `x1 + x2 + x1:x2` |
| `y ~ x1:x2` | Interaction only | Cross-product term |
| `y ~ I(x^2)` | Literal arithmetic | `I()` shields `^` from formula parsing |
| `y ~ poly(x, 3)` | Polynomial basis | Degrees 1, 2, 3 |
| `y ~ ns(x, 5)` | Natural spline | 5 degrees of freedom |

### The model matrix

`model_matrix()` shows exactly which columns `lm()` will create — no surprises:

```r
df <- tribble(~y, ~x1, ~x2,  4, 2, 5,  5, 1, 6)
model_matrix(df, y ~ x1)         # intercept added automatically
model_matrix(df, y ~ x1 - 1)     # no intercept
model_matrix(df, y ~ x1 + x2)    # two predictors
```

### Categorical predictors — dummy coding

When a predictor is a `factor`, R automatically creates **dummy variables**: one binary column per level, minus one for the reference level.

```r
data("sim2", package = "modelr")
mod2 <- lm(y ~ x, data = sim2)
model_matrix(sim2, y ~ x) |> head(8)
coef(mod2)
```

- The intercept is the mean of the **reference level** (the first alphabetical category).
- Each dummy coefficient is the **difference** from the reference level mean.
- Under OLS, the predicted value for each category equals the **sample mean** of that group.

> This is why linear regression with a categorical predictor and OLS is equivalent to a one-way ANOVA.

## Example

```r
library(modelr)
data("sim2")

mod2 <- lm(y ~ x, data = sim2)
coef(mod2)
# (Intercept)    xb    xc    xd
#        1.15  6.15  7.72  4.58

# Predicted values = group means
sim2 |>
  data_grid(x) |>
  add_predictions(mod2)
```

The predicted value for group `a` is 1.15 (the intercept = mean of `a`). For group `b`, it is 1.15 + 6.15 = 7.30 (= mean of `b`).

## Task

Open `exercise.Rmd` and complete:

1. Use `model_matrix()` to inspect `y ~ x1`, `y ~ x1 - 1`, and `y ~ x1 + x2` on the small `df` example.
2. Fit `mod2 <- lm(y ~ x, data = sim2)`. Print the model matrix (first 8 rows) and `coef()`.
3. Generate predictions for each level of `x` using `data_grid(x)` + `add_predictions()`.
4. Plot: jittered points + gold diamond at each group's predicted value.

## Check

```
npm run check -- bdat-608 module-04 lesson-01
```

## Reflection

In the `sim2` model, the coefficient for `xb` is 6.15. A student says: "This means that group b has a mean of 6.15." Is this correct? What does the coefficient actually represent?
