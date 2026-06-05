# Task: Formula Notation, Model Matrix, and Categorical Predictors

## Objective

Inspect the design matrix for a categorical predictor, interpret dummy-coded coefficients, demonstrate that reference-level changes do not affect model fit, and observe the confounding effect of carat on the cut-price relationship.

## Instructions

1. Use `model.matrix(~ cut, data = diamonds |> slice_head(n = 10))` to inspect the dummy coding for `cut`. State which level is the reference and what each dummy column represents.
2. Fit `lm(log(price) ~ cut, data = diamonds)`. Report all coefficients and their exponentiated values. Write one sentence interpreting the intercept and one sentence interpreting the `cutIdeal` coefficient.
3. Re-fit with `Ideal` as the reference level using `relevel()`. Confirm that R² is unchanged and explain why in one sentence.
4. Fit `lm(log(price) ~ log(carat) + cut, data = diamonds)`. Compare the cut coefficients (sign and magnitude) to the cut-only model from step 2.
5. Explain in two sentences why the cut coefficients change sign once carat is controlled for. What statistical phenomenon is at work?
6. Use `model.matrix()` to inspect the design matrix for `log(price) ~ log(carat) + cut` (first 10 rows). Verify that it has 1 intercept column, 1 continuous column, and 4 dummy columns.

## Submission

Knit to HTML. Required: the model matrix printout, the coefficient tables for both cut models, the R² comparison, and the written explanations for steps 2 and 5.
