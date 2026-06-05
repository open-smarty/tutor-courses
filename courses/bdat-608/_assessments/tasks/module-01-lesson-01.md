# Task: What Is a Statistical Model?

## Objective

Apply the signal/noise decomposition to the `diamonds` dataset: fit a simple linear model, compute and visualise residuals, and draw a conclusion about model adequacy.

## Instructions

1. Load the `diamonds` dataset from `ggplot2` and the `modelr` package.
2. Create a scatter plot of `price` vs `carat` coloured by `cut`. Describe in one sentence what the plot tells you about the relationship.
3. Fit `lm(price ~ carat, data = diamonds)` and record:
   - The intercept and slope.
   - The R² value.
   - The meaning of the slope in plain English (no jargon).
4. Use `add_residuals()` to attach residuals to the dataset.
5. Plot residuals on the y-axis vs `carat` on the x-axis. Add a horizontal line at zero.
6. Write two to three sentences describing any pattern you see in the residuals. Is the model correctly specified? What would you do next?

## Submission

Knit your `exercise.Rmd` to HTML and submit the `.html` file together with the `.Rmd` source. Your submission must include all four plots and the written interpretations for steps 2 and 6.
