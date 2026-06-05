# Lesson 1: Formula Notation, Model Matrix, and Categorical Predictors

## Goal

Read and write R model formulas, inspect the design matrix with `model.matrix()`, and correctly interpret dummy-coded coefficients for the `cut` variable in the `diamonds` dataset.

## Concept

**R formula notation.** The formula `y ~ x1 + x2` tells R: "model $y$ as a linear function of $x_1$ and $x_2$, with an intercept." R converts this formula into a **design matrix** $\mathbf{X}$ automatically — a column of ones (intercept), then one column per predictor term. The formula operators are:

| Operator | Meaning | Example |
|---|---|---|
| `+` | Add a predictor | `y ~ x1 + x2` |
| `-1` | Remove the intercept | `y ~ x - 1` |
| `*` | Interaction + main effects | `y ~ x1 * x2` (expands to `y ~ x1 + x2 + x1:x2`) |
| `:` | Interaction only | `y ~ x1 + x2 + x1:x2` |
| `I()` | Protect arithmetic | `y ~ I(x^2)` (without `I()`, `x^2` means crossing, not squaring) |
| `.` | All remaining columns | `y ~ .` |

**Inspecting the design matrix.** Before fitting, always call `model.matrix(formula, data)` to see exactly what matrix R will use. This is especially important for categorical predictors.

```r
model.matrix(price ~ cut, data = diamonds |> slice(1:5))
```

**Dummy coding for categorical predictors.** When a predictor is a factor with $k$ levels, R creates $k-1$ binary (0/1) columns called **dummy variables**. One level is dropped — the **reference level** (by default, the first level alphabetically or the first factor level). Why $k-1$ and not $k$? Because including all $k$ columns would cause **perfect multicollinearity** (the $k$ dummies always sum to 1, which equals the intercept column): $\mathbf{X}^\top\mathbf{X}$ would be singular.

For `cut` with levels `Fair < Good < Very Good < Premium < Ideal`, `Fair` is the reference. The design matrix contains four dummies: `cutGood`, `cutVery Good`, `cutPremium`, `cutIdeal`. Each dummy = 1 for that level, 0 otherwise.

**Interpreting dummy coefficients.** In `lm(log(price) ~ cut, data = diamonds)`:

- The intercept $\hat{\beta}_0$ is the predicted log-price for a **Fair**-cut diamond (the reference).
- $\hat{\beta}_{\text{Good}}$ is the **difference** in mean log-price between Good and Fair, all else equal.
- $e^{\hat{\beta}_{\text{Good}}}$ is the price **ratio**: Good costs $e^{\hat{\beta}_{\text{Good}}}$ times as much as Fair on the price scale.

**Changing the reference level.** Use `relevel(factor, ref = "Ideal")` to make `Ideal` the reference. Every other coefficient then measures the price penalty relative to `Ideal`. This does not change model fit — only the parameterisation.

## Example

**Inspect the model matrix for cut.**

```r
diamonds_small <- diamonds |> slice_head(n = 6)
model.matrix(~ cut, data = diamonds_small)
```

Output: column 1 = `(Intercept)` = all ones. Columns 2–5 = `cutGood`, `cutVery Good`, `cutPremium`, `cutIdeal`. A row for an Ideal diamond has: `(Intercept)=1`, `cutIdeal=1`, all others=0.

**Fit cut-only model and interpret:**

```r
mod_cut <- lm(log(price) ~ cut, data = diamonds)
coef(mod_cut)
exp(coef(mod_cut))
```

Hypothetical output:
- Intercept = 8.29 → $e^{8.29} = \$3{,}980$ for Fair-cut diamonds.
- `cutGood` = −0.04 → Good diamonds cost $e^{-0.04} \approx 0.96$ times Fair, i.e., about 4% less on average.

This seems counterintuitive — but recall that cut is confounded with carat: Fair-cut diamonds tend to be heavier. Without controlling for carat, the raw cut effect is distorted. Once we add `log(carat)` to the model, the cut coefficients reverse and Ideal becomes the most expensive.

**Numeric example.** For the model `log(price) ~ log(carat) + cut`:

- Intercept (Fair, reference) → baseline log-price at log(carat) = 0.
- `cutIdeal` = +0.40 → Ideal diamonds cost $e^{0.40} \approx 1.49$ times as much as Fair-cut diamonds of the same carat weight. A 49% quality premium.

## Task

Open `exercise.Rmd`. Complete the following:

1. Run `model.matrix(~ cut, data = diamonds |> slice_head(n = 10))`. Identify which level is the reference and what each column represents.
2. Fit `lm(log(price) ~ cut, data = diamonds)`. Report the coefficients and their exponentiated values.
3. Change the reference level to `"Ideal"` using `relevel()`. Re-fit and compare coefficients. Does R² change?
4. Fit `lm(log(price) ~ log(carat) + cut, data = diamonds)`. Compare the cut coefficients to step 2. Explain the difference.

## Check

```
npm run check -- bdat-608 module-04 lesson-01
```

## Reflection

Dummy coding with $k-1$ dummies avoids the "dummy variable trap" — perfect multicollinearity. But some software packages use "effects coding" (contrast coding) instead, where each dummy is −1/1 rather than 0/1. What is the advantage of effects coding for interpreting main effects in the presence of interactions? Is the model fit (RSS) affected by the choice of coding scheme?
