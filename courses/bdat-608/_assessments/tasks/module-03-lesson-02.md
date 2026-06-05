# Task: Diagnostic Plots and Model Comparison

## Objective

Interpret the four standard diagnostic plots for a linear model and use AIC and the F-test to formally compare two nested diamond models.

## Instructions

1. Fit `mod1 = lm(log(price) ~ log(carat))` and `mod2 = lm(log(price) ~ log(carat) + cut + color + clarity)` on the full `diamonds` dataset.
2. Produce the four diagnostic plots for `mod1` using `plot(mod1)` in a 2×2 grid. For each plot, write one sentence describing what you see and what it implies:
   - Residuals vs Fitted
   - Normal Q-Q
   - Scale-Location
   - Residuals vs Leverage
3. Compute `AIC(mod1, mod2)`. State which model wins and by how many AIC units.
4. Run `anova(mod1, mod2)`. Report the F-statistic, degrees of freedom, and $p$-value. Does the F-test agree with the AIC result?
5. Use `broom::augment(mod2)` to produce a Residuals vs Fitted plot for `mod2`. Overlay a LOESS smoother. How does the pattern compare to `mod1`?
6. In three sentences, summarise what you learned from the diagnostics about `mod1`'s weaknesses and how `mod2` addressed them.

## Submission

Knit to HTML. Required: the 2×2 diagnostic panel, the AIC table, the `anova()` output, and the `mod2` residuals plot.
