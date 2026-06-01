# Task: Module 4, Lesson 1 — Dummy Coding Verification

## Objective

Verify that OLS dummy coefficients equal group mean differences.

## Instructions

Load `sim2` from `modelr`.

1. Compute the sample mean of `y` for each level of `x` using `group_by()` + `summarise()`. Call this `group_means`.

2. Fit `mod2 <- lm(y ~ x, data = sim2)`. Extract `coef(mod2)`.

3. Verify that:
   - `coef["(Intercept)"]` equals the mean of the reference group (group `a`)
   - Each `coef["xb"]`, `coef["xc"]`, `coef["xd"]` equals (mean of that group) − (mean of group `a`)

   Build a comparison table that shows group name, raw mean, lm prediction, and their difference. The difference column should be all zeros (or near-zero due to floating point).

4. Explain in 3–4 sentences why this equivalence holds mathematically.

## Submission

Submit the knitted HTML with the comparison table and your explanation.
