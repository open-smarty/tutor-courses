# Task: Module 3, Lesson 2 — Full Diagnostic Analysis

## Objective

Apply the complete diagnostic workflow to a real dataset and write a model adequacy report.

## Instructions

Load `cabbages` from `MASS` and fit:

```r
library(MASS)
select <- dplyr::select
mod_cab <- lm(VitC ~ HeadWt, data = cabbages)
```

1. Produce the 2×2 diagnostic panel (either base R or `autoplot()`).

2. For each of the four panels, write one sentence describing what you see and whether it indicates a problem.

3. Fit a second model that adds `Cult` (cultivar) as a predictor:
   ```r
   mod_cab2 <- lm(VitC ~ HeadWt + Cult, data = cabbages)
   ```
   Compare the AIC of both models.

4. Use `gather_residuals()` to plot residuals vs `HeadWt` for both models side-by-side. Does adding `Cult` remove any residual patterns?

5. Based on your analysis, write a 2–3 sentence recommendation: which model should be used, and why?

## Submission

Submit the knitted HTML with all plots and your written model adequacy report.
