# Task: Robust Regression and GAMs

## Objective

Demonstrate the OLS sensitivity to outliers by comparing `lm()` and `rlm()` on a contaminated dataset, then fit a GAM on diamonds and interpret the estimated smooth functions.

## Instructions

1. Add outliers to `sim1`: add 20 to `y` for rows 5 and 15. Fit both `lm(y ~ x)` and `rlm(y ~ x, method = "M")`. Report intercepts and slopes.
2. Plot the scatter of the contaminated `sim1` with both fitted lines. Label the outlier points distinctly. Describe which line is pulled more.
3. Fit `gam(log(price) ~ s(log(carat)) + s(depth) + cut, data = diamonds, method = "REML")`.
4. Print `summary()`. For each smooth term, report the EDF and whether it is approximately linear or non-linear.
5. Produce the smooth plot with `plot(mod_gam, pages = 1, shade = TRUE)`. Describe the shape of each smooth in one sentence each.
6. Fit `lm(log(price) ~ log(carat) + depth + cut, data = diamonds)` and compare AIC with the GAM. Which wins?
7. In two sentences, explain why the GAM wins: what structure in the data does the smooth capture that the linear model cannot?

## Submission

Knit to HTML. Required: the OLS vs robust plot, the GAM smooth plot, the AIC comparison, and all written interpretations.
