# Task: Module 2, Lesson 3 — Interpreting lm() Output

## Objective

Fit a linear model to a new dataset and write a complete statistical interpretation.

## Instructions

The `cabbages` dataset from the `MASS` package contains `VitC` (vitamin C content) and `HeadWt` (head weight in kg) measurements for cabbages.

1. Load `cabbages` from `MASS` and explore it with `glimpse()` and a scatter plot of `VitC ~ HeadWt`.

2. Fit `mod_cab <- lm(VitC ~ HeadWt, data = cabbages)`. Print the full `summary()`.

3. Answer the following in your Rmd:
   - a. What is the estimated slope? Interpret it in context (include units).
   - b. What is R²? How much variation in vitamin C is explained by head weight?
   - c. Is the slope statistically significant at the 5% level? Quote the p-value.
   - d. Compute `confint(mod_cab)`. Interpret the 95% CI for the slope.

4. Create a scatter plot of the data with the fitted regression line (`geom_abline()`) overlaid.

## Submission

Submit the knitted HTML with the scatter plot, summary table, and your written answers.
