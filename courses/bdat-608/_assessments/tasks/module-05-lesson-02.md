# Task: Module 5, Lesson 2 — GAM vs Linear Model Comparison

## Objective

Compare a GAM with a linear model and decide which is more appropriate.

## Instructions

The `airquality` dataset has a non-linear relationship between `Ozone` and `Temp`.

```r
air <- na.omit(airquality)
```

1. Fit two models:
   - `mod_lin <- lm(Ozone ~ Temp + Wind, data = air)`
   - `mod_gam <- gam(Ozone ~ s(Temp) + s(Wind), data = air, method = "REML")`

2. Print `summary(mod_gam)`. Report the edf for each smooth. Is either relationship approximately linear?

3. Plot the two smooth effects with `plot(mod_gam, shade = TRUE)`.

4. Create a prediction grid with `data_grid(Temp = seq_range(Temp, 30), Wind = median(air$Wind))`. Generate predictions from both models and plot both curves on the same scatter plot.

5. Compare the AIC of `mod_lin` and `mod_gam`. Which is preferred?

6. Write a 3–4 sentence interpretation: what do the smooth effects tell you about how Temp and Wind relate to Ozone levels?

## Submission

Submit the knitted HTML with all plots and your written interpretation.
