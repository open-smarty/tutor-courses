# Task: Search Strategies and Numerical Optimisation

## Objective

Implement and compare three strategies for minimising RMSE — grid search, `optim()` with BFGS, and `lm()` — to build a concrete understanding of what fitting a model means computationally.

## Instructions

1. Load `sim1` from the `modelr` package.
2. Write a scalar-argument wrapper `rmse_sim1(b0, b1)` that computes RMSE for the model `y = b0 + b1*x` on `sim1`.
3. Run a 25×25 grid search over $\beta_0 \in [-5, 20]$ and $\beta_1 \in [1, 3]$. Report the best pair and its RMSE.
4. Use `optim(c(0, 0), fn, method = "BFGS")` to minimise the same function. Report `par`, `value`, and `convergence`.
5. Fit `lm(y ~ x, data = sim1)`. Report `coef()` and compute RMSE from `residuals()`.
6. Create a comparison table showing $\hat{\beta}_0$, $\hat{\beta}_1$, and RMSE for all three methods.
7. Plot the grid-search loss surface (scatter of $\beta_0$ vs $\beta_1$ coloured by RMSE). Mark the `optim()` solution with a distinct point.
8. In two sentences, explain why `lm()` finds the exact minimum while grid search does not.

## Submission

Knit to HTML and submit the `.html` and `.Rmd`. The comparison table and the loss-surface plot are both required.
