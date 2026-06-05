# Lesson 1: What Is a Statistical Model?

## Goal

Explain what a statistical model is, decompose observed data into signal and noise, and describe the iterative modelling cycle that drives every analysis in this course.

## Concept

Imagine you are trying to predict the price of a diamond from its weight. You look at the data and notice a clear upward trend — heavier diamonds cost more. But not every diamond follows the trend perfectly. Some are priced higher than you would expect; others are cheaper. That gap between "what we expect" and "what we observe" is the central idea of statistical modelling.

**The signal/noise decomposition.** Every statistical model says:

$$y_i = f(x_i) + \varepsilon_i$$

where $y_i$ is the observed response for observation $i$, $f(x_i)$ is the **signal** — the systematic pattern we want to learn — and $\varepsilon_i$ is the **noise** — random variation that no model can explain. Our job is to estimate $f$ as accurately as possible.

**Model family vs fitted model.** These are two distinct objects, and confusing them is a common source of errors.

- A **model family** is the *shape* of the equation: "we believe the relationship is a straight line," i.e. $f(x) = \beta_0 + \beta_1 x$. This is the collection of *all possible* straight lines — infinitely many of them.
- A **fitted model** is the *specific* member of that family that best matches our data: "after fitting, $\hat{f}(x) = 0.25 + 0.77x$." The numbers $0.25$ and $0.77$ are estimated from data.

Choosing the family is a modelling assumption. You cannot prove it from the data alone, but you *can* diagnose whether it was reasonable — by inspecting the residuals.

**What is a residual?** The residual for observation $i$ is:

$$e_i = y_i - \hat{y}_i$$

where $\hat{y}_i = \hat{f}(x_i)$ is the model's prediction. A residual tells you exactly what the model missed for that observation. If $e_i > 0$, the true value was above the model's prediction; if $e_i < 0$, it was below.

**Why residuals matter.** If the model is correctly specified, residuals should look like random noise: no pattern, centred at zero, roughly the same spread across all fitted values. Any systematic pattern in the residuals means the model is missing something. A fan shape means the variance is non-constant (the noise is bigger for larger predictions). A curve means the relationship is not linear. Clusters by group mean a grouping variable is relevant. Residual inspection is how you discover what the model got wrong.

**The iterative modelling cycle.** Modelling is not a one-shot procedure. We follow this loop:

1. Observe the data and form a hypothesis about the shape of $f$.
2. Choose a model family.
3. Fit the model (estimate the parameters).
4. Inspect the residuals — look for patterns.
5. Refine the model based on what the residuals revealed.
6. Repeat until the residuals look like random noise.

The cycle stops when no further systematic pattern can be extracted from the residuals.

## Example

We use the `diamonds` dataset (53,940 rows, from `ggplot2`). Each row is one diamond; we will predict `price` from `carat` (weight in carats).

**Step 1.** Plot `price` vs `carat`. We see a clear upward trend, but the points form a fan — the spread in price grows with carat size.

**Step 2.** Choose a model family: straight line, $\text{price} = \beta_0 + \beta_1 \cdot \text{carat}$.

**Step 3.** Fit using `lm(price ~ carat, data = diamonds)`. R returns $\hat{\beta}_0 = -2{,}256$ and $\hat{\beta}_1 = 7{,}756$, so the fitted model is $\widehat{\text{price}} = -2{,}256 + 7{,}756 \times \text{carat}$.

**Step 4.** Compute residuals and plot them against `carat`. The residuals fan outward — a classic sign that the variance is non-constant (heteroscedastic). The model is systematically wrong for large diamonds.

**Step 5.** Refinement: take $\log$ of both sides. The `log(price) ~ log(carat)` model shrinks the fan. We will explore this in later lessons.

**Numeric check.** For a 1-carat diamond: $\widehat{\text{price}} = -2{,}256 + 7{,}756 \times 1 = 5{,}500$. Suppose the actual price is $\$6{,}200$. Then $e = 6{,}200 - 5{,}500 = +700$. The model underestimated by $\$700$ for this diamond.

## Task

Open `exercise.Rmd`. Load the `diamonds` dataset and complete the following:

1. Create a scatter plot of `price` vs `carat` coloured by `cut`.
2. Fit a simple linear model: `lm(price ~ carat, data = diamonds)`.
3. Use `add_residuals()` from the `modelr` package to attach residuals to the dataset.
4. Plot residuals vs `carat`. Describe the pattern you see and what it tells you about the model.

## Check

```
npm run check -- bdat-608 module-01 lesson-01
```

## Reflection

A residual is defined as $e_i = y_i - \hat{y}_i$. If you computed the mean of all residuals from an OLS fit, you would always get exactly zero. Does that mean the model is unbiased? What does "unbiased" mean in this context, and could a model have zero mean residuals yet still be systematically wrong?
