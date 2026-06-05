# Task: Predictions and Residuals with modelr

## Objective

Use `data_grid()`, `add_predictions()`, and `add_residuals()` to visualise the fitted log-log diamond model and diagnose what systematic structure remains in the residuals.

## Instructions

1. Fit `lm(log(price) ~ log(carat), data = diamonds)`.
2. Create a 200-point `data_grid()` over `carat`. Add predictions (log scale) and back-transform to price scale.
3. Create a scatter plot of `price` vs `carat` (raw data, `alpha = 0.05`) overlaid with the back-transformed fitted curve (`geom_line()`).
4. Attach residuals to `diamonds` using `add_residuals()`. Plot residuals vs `log(carat)` with a horizontal reference line at zero.
5. Colour the residual plot by `cut`. Describe in two sentences what pattern you see.
6. Compute the mean residual per `cut` level with `group_by()` and `summarise()`. Arrange in descending order.
7. Write one sentence interpreting the positive mean residual for Ideal-cut diamonds.
8. Based on the residual plots, name at least two variables you would add to the model next and explain why.

## Submission

Knit to HTML. Required: the price-scale fitted curve overlay plot, the plain residual plot, the coloured residual plot, and the mean-residual table.
