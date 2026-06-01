# Task: Module 2, Lesson 1 — Loss Function Experiment

## Objective

Empirically verify that OLS (RMSE) and MAE differ under heavy-tailed noise.

## Instructions

1. Create 20 different simulated datasets, each with the same structure as `sim1a` (Student-t noise, df=2), but each using a different random seed (1 through 20).

2. For each dataset, use `optim()` to find the MAE-optimal slope and the OLS slope from `lm()`.

   ```r
   set.seed(seed_i)
   temp_data <- tibble(x = rep(1:10, each = 3), y = x * 1.5 + 6 + rt(30, df = 2))
   mae_par  <- optim(c(0,0), measure_mae, data = temp_data)$par
   ols_coef <- coef(lm(y ~ x, data = temp_data))
   ```

3. Collect results into a tibble with columns: `seed`, `mae_slope`, `ols_slope`.

4. Compute the standard deviation of `mae_slope` and `ols_slope` across the 20 seeds. Which is smaller?

5. Plot both slopes against seed number (two lines on one plot), with a horizontal dashed line at the true slope = 1.5. Describe what you see.

## Submission

Submit your Rmd and the knitted HTML. The plot and the SD comparison must be present.
