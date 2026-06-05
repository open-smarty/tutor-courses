# Task: Loss Functions — RMSE and MAE

## Objective

Implement RMSE and MAE as R functions from scratch, conduct a random search over the parameter space, and visualise the loss surface — building intuition for what "fitting a model" means before using closed-form solutions.

## Instructions

1. Take a 100-row random sample of `diamonds` with `set.seed(42)`.
2. Write a function `rmse_fn(b0, b1, data)` that computes RMSE for `price ~ b0 + b1*carat`.
3. Write a function `mae_fn(b0, b1, data)` that computes MAE for the same model.
4. Evaluate both at three candidate parameter pairs of your choice. Report the results in a small table.
5. Generate 250 random parameter pairs: `b0` uniformly in $[-5000, 0]$ and `b1` uniformly in $[5000, 12000]`. Compute RMSE for each pair. Use `set.seed(7)`.
6. Report the pair with the lowest RMSE.
7. Plot `b0` vs `b1` coloured by RMSE. Describe the shape of the low-RMSE region.
8. Fit `lm(price ~ carat, data = d100)` and compare its RMSE to the best random-search RMSE. Write one sentence explaining why OLS wins.

## Submission

Knit to HTML and submit the `.html` and `.Rmd` files. The document must include the loss-surface plot with axis labels and a colour legend.
