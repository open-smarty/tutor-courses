# Task: Module 4, Lesson 2 — Interaction on Two Continuous Predictors

## Objective

Demonstrate the additive vs interaction distinction with two continuous predictors using `sim4`.

## Instructions

Load `sim4` from `modelr`.

1. Fit:
   - `mod1_s4 <- lm(y ~ x1 + x2, data = sim4)` (additive)
   - `mod2_s4 <- lm(y ~ x1 * x2, data = sim4)` (interaction)

2. Create a 5×5 prediction grid using `data_grid()` with `seq_range(x1, n=5)` and `seq_range(x2, n=5)`. Call `gather_predictions()` to get predictions from both models.

3. Plot the predicted surface as a tile heatmap (`geom_tile()`) faceted by model. Use `scale_fill_viridis_c()`.

4. Plot a "slice" view: `aes(x1, pred, colour = x2, group = x2)` + `geom_line()`, faceted by model.

5. Interpret the two plots in 3–4 sentences: what is the key visual difference between the additive and interaction surfaces?

6. Compare AIC. Which model is preferred for `sim4`?

## Submission

Submit the knitted HTML with both plots and your written interpretation.
