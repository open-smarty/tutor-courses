# Task: Model Building in Practice — Diamonds, Flights, and Growth Models

## Objective

Demonstrate the three pillars of advanced modelling practice: progressive residual-driven model building on the diamonds dataset, the nest/map/unnest many-models pipeline on nycflights13 flights, and non-linear least squares fitting of logistic growth.

## Instructions

1. **Progressive diamonds model.** Fit three models in sequence:
   - `mod1`: `lm(price ~ carat, data = diamonds)`
   - `mod2`: `lm(log(price) ~ log(carat), data = diamonds)`
   - `mod3`: `lm(log(price) ~ log(carat) + cut + colour + clarity, data = diamonds)`

   For each model, add residuals with `modelr::add_residuals()` and produce a residuals-vs-predictor scatter plot (colour points by `cut`). For each plot, write one sentence identifying the dominant residual pattern (or confirming that residuals look random).

2. **R² trajectory.** Report R² for all three models. In two sentences, explain why R² alone is an insufficient stopping criterion and how the residual plots complement it.

3. **Many-models pipeline.** Starting from the `flights` dataset (drop rows with missing `arr_delay` or `dep_delay`), use `group_by(carrier) |> nest() |> mutate(model = map(...), coefs = map(model, broom::tidy)) |> unnest(coefs)` to fit `lm(arr_delay ~ dep_delay)` for each carrier. Filter to the `dep_delay` term. Print the table sorted by slope (ascending).

4. **Carrier slope bar chart.** Plot the `dep_delay` slope for each carrier as a bar chart with carriers reordered by slope. Add a horizontal dashed line at slope = 1. Identify the carrier with the lowest slope and the one with the highest slope by name.

5. **Logistic growth with nls().** Use `set.seed(602)` and the simulation parameters `K = 1000, r = 0.4, Y0 = 50, t = 0:20, noise sd = 20`. Fit:
   ```r
   nls(Y ~ K / (1 + ((K - Y0) / Y0) * exp(-r * t)),
       data = growth_df,
       start = list(K = 900, r = 0.5, Y0 = 60))
   ```
   Print `summary(mod_nls)`. Report the estimated K, r, and Y0. Overlay the fitted curve on the observed data using `add_predictions()`.

6. **Residual comparison.** Produce a residuals-vs-fitted plot for `mod1` and `mod3` side by side (or sequentially). In two sentences, contrast the two plots and explain what the improvement tells you about the progressive modelling decisions.

## Submission

Knit to HTML. Required outputs: three residual plots from Step 1, the carrier slope bar chart from Step 4, the fitted logistic curve from Step 5, and all written interpretations.
