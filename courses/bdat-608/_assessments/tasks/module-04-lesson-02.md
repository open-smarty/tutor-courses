# Task: Interactions and Transformations

## Objective

Compare additive and interaction specifications for the diamonds log-log model, visualise the difference using prediction grids, and assess whether the interaction is supported by AIC and residual diagnostics.

## Instructions

1. Fit `mod_add = lm(log(price) ~ log(carat) + cut, data = diamonds)`.
2. Fit `mod_int = lm(log(price) ~ log(carat) * cut, data = diamonds)`.
3. Compare AIC. State which model is preferred and by how many AIC units.
4. Create a `data_grid()` over `carat` (10 points) × all `cut` levels. Use `gather_predictions()` to get predictions from both models. Back-transform with `exp()`. Plot `price` vs `carat` coloured by `cut`, faceted by model. Describe whether the lines are parallel.
5. Report and interpret the interaction coefficient `log(carat):cutIdeal`.
6. Fit `mod_poly = lm(log(price) ~ poly(log(carat), 2) + cut)`. Is the degree-2 term significant? How does AIC compare to `mod_add`?
7. Write a two-sentence recommendation: which model would you use for a production pricing tool, and why?

## Submission

Knit to HTML. Required: the prediction grid plot, the AIC comparison table, and the written recommendation.
