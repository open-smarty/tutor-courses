# Lesson 2: Search Strategies and Numerical Optimisation

## Goal

Compare grid search, gradient descent intuition, and `optim()` as strategies for minimising the loss function, and understand why the closed-form OLS solution dominates all of them for standard linear models.

## Concept

In lesson 1 we used random search: sample many parameter pairs and pick the best. This is simple but wasteful. Here we introduce more systematic approaches.

**Grid search.** Instead of random sampling, lay down a structured rectangular grid over the parameter space and evaluate the loss at every grid point. For two parameters with $n$ grid points each, this requires $n^2$ evaluations. That is already slow: if you want $n = 100$ points per parameter for precision, you need $100^2 = 10{,}000$ evaluations. With ten parameters, grid search is completely infeasible — this is why we need smarter methods.

**Gradient descent (the intuition).** Imagine the loss surface as a hilly landscape. You are standing somewhere on the hill and want to get to the lowest point. The gradient $\nabla L(\boldsymbol{\beta})$ at your current position tells you the direction of steepest ascent — the slope pointing uphill. To go downhill, step in the opposite direction:

$$\boldsymbol{\beta} \leftarrow \boldsymbol{\beta} - \alpha \, \nabla L(\boldsymbol{\beta})$$

Here $\alpha > 0$ is the **learning rate** (step size). Large $\alpha$: you take big steps — fast but might overshoot the minimum. Small $\alpha$: slow but precise. The gradient of RMSE is a sum of partial derivatives, one per parameter. We do not implement gradient descent manually in R for standard linear models — but understanding it is essential for neural networks, LASSO, and any non-standard loss.

**`optim()` in R.** R's `optim()` function accepts any user-defined objective function and minimises it numerically. The default method is Nelder-Mead (a simplex algorithm that does not require derivatives). The BFGS method approximates the Hessian (second derivative matrix) to take Newton-like steps — faster convergence for smooth, differentiable losses.

```r
best <- optim(
  par  = c(0, 0),            # starting values for (b0, b1)
  fn   = my_loss_function,   # function to minimise
  data = my_data,            # extra argument passed to fn
  method = "BFGS"
)
best$par   # estimated (b0, b1)
best$value # minimum loss
```

**Convergence check.** `best$convergence == 0` means `optim()` thinks it found a local minimum. Always check this. If `convergence != 0`, try different starting values.

**Why closed-form beats all.** For the standard linear model, the OLS solution has an exact formula:

$$\hat{\boldsymbol{\beta}} = (\mathbf{X}^\top\mathbf{X})^{-1}\mathbf{X}^\top\mathbf{y}$$

This is not an approximation — it is the exact global minimum of RSS, computed in a single matrix operation. `lm()` implements this via QR decomposition (numerically more stable than computing the inverse directly). No iteration needed, no learning rate to tune, no convergence to worry about.

The hierarchy: random search → grid search → gradient descent → `optim()` → closed-form OLS. Each step is more efficient. For linear models, jump straight to `lm()`. The other methods become necessary when the loss is non-standard or the model is non-linear.

## Example

We use the `sim1` dataset from `modelr` to compare all three approaches.

**Grid search** over $\beta_0 \in [-5, 20]$ and $\beta_1 \in [1, 3]$ with 25 points each (625 evaluations):

```r
grid <- expand.grid(
  b0 = seq(-5, 20, length = 25),
  b1 = seq(1, 3, length = 25)
) |>
  mutate(rmse = map2_dbl(b0, b1, ~ rmse_sim1(.x, .y)))

grid |> slice_min(rmse, n = 1)
# b0 ≈ 4.17, b1 ≈ 2.08, RMSE ≈ 2.14
```

**`optim()` with BFGS:**

```r
res <- optim(c(0, 0), fn = rmse_sim1_vec, method = "BFGS")
res$par    # b0 ≈ 4.22, b1 ≈ 2.05
res$value  # RMSE ≈ 2.13
```

**`lm()` (closed-form):**

```r
lm(y ~ x, data = sim1) |> coef()
# (Intercept): 4.221, x: 2.052
```

Grid search is close but coarse. `optim()` is very close. `lm()` is exact and runs in milliseconds regardless of data size. The message: understanding optimisation builds intuition; in practice, use `lm()`.

## Task

Open `exercise.Rmd`. Using `sim1` from `modelr`:

1. Implement `rmse_sim1(b0, b1)` that computes RMSE for `y ~ b0 + b1*x` on `sim1`.
2. Run a grid search over $\beta_0 \in [-5, 20]$ (25 points) and $\beta_1 \in [1, 3]$ (25 points). Report the best pair.
3. Use `optim(c(0, 0), fn, method = "BFGS")` to minimise `rmse_sim1`. Report the result and check `convergence`.
4. Fit `lm(y ~ x, data = sim1)`. Compare all three estimates.
5. Plot the grid-search results as a coloured scatter of `b0` vs `b1`, coloured by `rmse`. Mark the `optim()` result with a red dot.

## Check

```
npm run check -- bdat-608 module-02 lesson-02
```

## Reflection

Grid search has complexity $O(n^k)$ where $n$ is points per dimension and $k$ is the number of parameters. With 10 parameters and 100 points each, how many evaluations would be needed? At 1 microsecond per evaluation, how long would that take? What does this tell you about why practitioners use gradient-based methods for neural networks with millions of parameters?
