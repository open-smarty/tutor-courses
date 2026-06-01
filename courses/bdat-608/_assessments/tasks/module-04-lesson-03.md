# Task: Module 4, Lesson 3 — Spline Selection on a New Dataset

## Objective

Apply spline modelling and cross-validation to a dataset with genuine non-linearity.

## Instructions

Load `airquality` (built into R).

```r
data("airquality")
air <- na.omit(airquality)
```

1. Create a scatter plot of `Ozone` vs `Temp`. Does the relationship look linear or curved?

2. Fit three models:
   - `mod_lin  <- lm(Ozone ~ Temp,       data = air)` (linear)
   - `mod_sq   <- lm(Ozone ~ I(Temp^2) + Temp, data = air)` (quadratic)
   - `mod_sp5  <- lm(Ozone ~ ns(Temp, 5),data = air)` (spline, df=5)

3. Plot all three fitted curves on the scatter plot using `gather_predictions()`.

4. Run 10-fold CV for spline df = 1 to 8. Plot the CV curve and report the optimal df.

5. Produce the four diagnostic plots for the spline model with the optimal df. Does the model look well-specified?

6. Write a 3–4 sentence summary: which model would you recommend for this data and why?

## Submission

Submit the knitted HTML with all plots and your written recommendation.
