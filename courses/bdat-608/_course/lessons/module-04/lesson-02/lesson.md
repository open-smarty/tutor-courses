# Lesson 2: Interactions and Transformations

## Goal

Specify and interpret additive vs interaction models, use `poly()` and `I(log(x))` for non-linear terms, and compare models using AIC and prediction grids.

## Concept

**Additive models.** The formula `y ~ x1 + x2` assumes that the effect of `x1` on `y` is the same regardless of the value of `x2`. Geometrically, the fitted surface is a collection of parallel lines (one per level of `x2`, if `x2` is categorical) or parallel planes (if both are continuous). The model equation is:

$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \varepsilon$$

**Interaction models.** The formula `y ~ x1 * x2` expands to `y ~ x1 + x2 + x1:x2`, adding the product term $x_1 x_2$:

$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_1 x_2 + \varepsilon$$

The coefficient $\beta_3$ is the **interaction**: it measures by how much the slope of $x_1$ changes for each unit increase in $x_2$. Equivalently, the effect of $x_2$ depends on $x_1$. Geometrically, the lines are no longer parallel — they fan out or converge.

**Interpreting the interaction coefficient.** Rearrange: $y = \beta_0 + \beta_2 x_2 + (\beta_1 + \beta_3 x_2) x_1$. The term in parentheses is the effective slope of $x_1$, which varies with $x_2$. If $\beta_3 > 0$, the slope of $x_1$ increases with $x_2$ — a positive synergy.

For a continuous × categorical interaction (e.g., `log(price) ~ log(carat) * cut`), each level of `cut` gets its own intercept and slope for `log(carat)`. The interaction tells you whether the price elasticity of carat differs by cut quality.

**Polynomial terms.** `poly(x, 2)` adds $x$ and $x^2$ in orthogonalised form (numerically stable, coefficients uncorrelated). Use `poly(x, 2, raw = TRUE)` if you need the raw $x, x^2$ terms for direct interpretation. Always use `I()` to protect arithmetic inside a formula: `y ~ I(x^2)` not `y ~ x^2` (the latter is a formula operator, not arithmetic).

**Log transformation.** For a power-law relationship $y \approx c \cdot x^\gamma$, taking logs gives $\log(y) = \log(c) + \gamma\log(x)$ — linear in $\log(x)$. The slope $\gamma$ is the **elasticity**: percentage change in $y$ per 1% change in $x$.

**Comparing with prediction grids.** The clearest way to see whether an interaction matters is to plot predictions from both models on the same grid:

```r
grid <- diamonds |>
  data_grid(carat = seq_range(carat, 5), cut) |>
  gather_predictions(mod_add, mod_int)

ggplot(grid, aes(carat, pred, colour = cut)) +
  geom_line() + facet_wrap(~ model)
```

If the lines are parallel in the additive panel and non-parallel in the interaction panel, and the interaction model has lower AIC, the interaction is real.

## Example

We compare three models on `diamonds`:

1. `mod_add = lm(log(price) ~ log(carat) + cut)` — additive: one slope, different intercepts per cut.
2. `mod_int = lm(log(price) ~ log(carat) * cut)` — interaction: slope of `log(carat)` differs by cut.
3. `mod_poly = lm(log(price) ~ poly(log(carat), 2) + cut)` — quadratic in log(carat).

**Fit and compare:**

```r
AIC(mod_add, mod_int, mod_poly)
```

Hypothetical AIC: `mod_add` = −5,530; `mod_int` = −5,600; `mod_poly` = −5,540. The interaction model wins, but only by 70 units over the additive model.

**Interpret the interaction coefficient.** Suppose `log(carat):cutIdeal = −0.08`. This means: the slope of `log(carat)` is 0.08 log-units lower for Ideal-cut diamonds than for Fair-cut diamonds. In other words, Ideal diamonds have a slightly smaller price elasticity for carat — their quality premium partially offsets the carat effect.

**Numeric example for polynomial.** `poly(log(carat), 2, raw = TRUE)` gives columns $\log(\text{carat})$ and $(\log(\text{carat}))^2$. If the quadratic coefficient is −0.12, the price-carat curve is concave on the log scale — each additional unit of log-carat adds progressively less to log-price.

## Task

Open `exercise.Rmd`. Fit additive and interaction models on `diamonds`:

1. Fit `mod_add = lm(log(price) ~ log(carat) + cut)`.
2. Fit `mod_int = lm(log(price) ~ log(carat) * cut)`.
3. Compare using `AIC()`. Which wins?
4. Use `data_grid(carat = seq_range(carat, 10), cut)` and `gather_predictions(mod_add, mod_int)` to plot predictions. Are the lines parallel for `mod_add`? Do they fan out for `mod_int`?
5. Interpret the `log(carat):cutIdeal` interaction coefficient from `mod_int`.
6. Fit `mod_poly = lm(log(price) ~ poly(log(carat), 2) + cut)`. Is the quadratic term significant?

## Check

```
npm run check -- bdat-608 module-04 lesson-02
```

## Reflection

Interaction models are more flexible but harder to interpret. The coefficient on `x1:x2` describes how the slope of `x1` changes with `x2`. When is this interpretation clear to a non-statistical audience, and when does it become confusing? Can you think of a way to visualise an interaction that makes it intuitive without showing the regression equation?
