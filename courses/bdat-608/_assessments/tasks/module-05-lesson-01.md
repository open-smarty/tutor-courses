# Task: GLMs — Logistic and Poisson Regression

## Objective

Fit a logistic regression model to predict long departure delays, interpret the results as odds ratios, and visualise the predicted probability curve over the day.

## Instructions

1. Load `flights` from `nycflights13`. Create `long_delay = as.integer(dep_delay > 30)`. Remove rows with `NA` in `dep_delay`.
2. Compute and plot the proportion of long delays by hour of day. Describe the trend.
3. Fit a null model `glm(long_delay ~ 1, family = binomial())` and a logistic model `glm(long_delay ~ hour + month, family = binomial())`.
4. Print `summary(mod_logit)`. Report: the coefficient for `hour`, its standard error, and its $p$-value.
5. Exponentiate all coefficients to get odds ratios. Interpret the `hour` OR: "each additional hour of the day multiplies the odds of a long delay by \_\_\_."
6. Calculate the predicted probability of a long delay at hour = 6 and hour = 20 in July. Show the calculation.
7. Plot predicted probability vs hour (for July, `month = 7`) as a line plot.
8. Compare `AIC(mod_null, mod_logit)`. Interpret the result.

## Submission

Knit to HTML. Required: the hourly delay plot, the `summary()` output, the odds ratio table, the predicted probability curve, and the AIC comparison.
