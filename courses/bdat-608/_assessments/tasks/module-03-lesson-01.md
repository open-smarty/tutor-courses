# Task: Module 3, Lesson 1 — Residual Diagnosis

## Objective

Apply the prediction/residual workflow to a new dataset and diagnose the model.

## Instructions

The `sim5` dataset (create it yourself) has a sinusoidal relationship:

```r
set.seed(1)
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(50)
)
```

1. Fit a **linear** model: `mod_lin <- lm(y ~ x, data = sim5)`.

2. Build a prediction grid with `data_grid(x = seq_range(x, 60))` and plot the observed data + fitted line.

3. Add residuals to `sim5` and plot residuals vs `x`.

4. Describe in 3–4 sentences what you see in the residual plot. Is the linear model adequate for this data?

5. Suggest what type of model would be more appropriate (you do not need to fit it yet — we will do that in Module 4).

## Submission

Submit the knitted HTML with both plots and your written diagnosis.
