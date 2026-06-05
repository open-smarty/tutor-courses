# Task: Closed-Form OLS with lm()

## Objective

Fit two linear models on the `diamonds` dataset, decode every component of the `summary()` output, and explain why the log-log transformation produces a better fit than the raw-scale linear model.

## Instructions

1. Fit `lm(price ~ carat, data = diamonds)`. From `summary()`, report:
   - Intercept and slope with units.
   - Residual standard error and its degrees of freedom.
   - $R^2$ and adjusted $R^2$.
   - The $F$-statistic and its $p$-value.
2. Write a one-sentence plain-English interpretation of the slope.
3. Fit `lm(log(price) ~ log(carat), data = diamonds)`. Report the slope (price elasticity) and $R^2$.
4. Interpret the price elasticity: what does it mean that the slope exceeds 1?
5. Use `broom::tidy()` to create a clean table of coefficients for the log-log model. Use `broom::glance()` for model-level statistics.
6. Create a residual vs fitted plot for both models side by side. Describe how the residual patterns differ (fan shape? curvature?).
7. Explain in two sentences why `lm()` obtains the exact OLS solution without any iteration, while `optim()` can only approximate it.

## Submission

Knit to HTML. The submission must include both `summary()` outputs, the broom tables, and the two residual plots side by side.
