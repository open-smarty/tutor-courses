# Lesson 14: Model Building in Practice — Diamonds, Flights, and Growth Models

## Goal

Apply the full statistical modelling workflow — iterative building, many-models pipelines, and non-linear fitting — to three real datasets.

## Concept

Everything we have learned comes together in this lesson. A statistical model is only as good as the iterative process that built it. We follow three case studies that each illustrate a different dimension of advanced modelling practice.

**Case 1 — Progressive model building (diamonds)**

The goal is not to find the "right" model in one shot — it is to improve the model until the residuals look like noise. We start simple, inspect what the model misses, and add complexity only where the data demands it.

Start with a naive model: `price ~ carat`. R² ≈ 0.85 looks impressive, but a residual plot reveals two problems: (1) the relationship is non-linear (variance fans out with carat), and (2) residuals cluster strongly by `cut` and `colour`. Log-transforming both sides fixes the non-linearity — `log(price) ~ log(carat)` models a power-law relationship. Adding `cut`, `colour`, and `clarity` absorbs the remaining structure. Final model R² ≈ 0.98 and residuals are essentially noise. The decision rule: **stop when residuals are random**.

**Case 2 — Many-models pipeline (nycflights13)**

When you need to fit the same model to dozens of groups, doing it by hand is impractical. The `nest()` + `purrr::map()` + `broom::tidy()` pipeline automates this:

1. `group_by(carrier) |> nest()` — creates a list-column where each element is that carrier's data frame.
2. `map(data, ~lm(arr_delay ~ dep_delay, .))` — fits a linear model to each carrier's data.
3. `map(model, broom::tidy)` — extracts tidy coefficient tables.
4. `unnest(coefs)` — flattens back to a regular data frame.

The `dep_delay` slope tells you: "For each extra minute of departure delay, how many minutes of arrival delay does this carrier accumulate?" Carriers with slopes < 1 make up time in the air; slopes > 1 get worse. This comparison is impossible without the many-models approach.

**Case 3 — Non-linear growth models (nls)**

Not every relationship is linear, even after transformation. Logistic growth describes a population that grows rapidly at first, then saturates at a carrying capacity K:

$$Y(t) = \frac{K}{1 + \frac{K - Y_0}{Y_0} \cdot e^{-rt}}$$

**Notation:** K = carrying capacity (maximum population); Y₀ = population at t=0; r = intrinsic growth rate; t = time.

`nls()` fits this by non-linear least squares. It requires starting values — good starting values come from domain knowledge (e.g., K ≈ maximum observed value, r ≈ 0.5, Y₀ ≈ first observed value). Unlike `lm()`, `nls()` has no closed-form solution and can fail to converge if starting values are poor.

## Example

**Progressive diamonds modelling — summary of gains:**

| Model | R² | Key residual pattern |
|---|---|---|
| `price ~ carat` | 0.85 | Fan shape (heteroscedasticity) + colour/cut clusters |
| `log(price) ~ log(carat)` | 0.93 | Colour/cut clusters remain |
| `log(price) ~ log(carat) + cut + colour + clarity` | 0.98 | Random scatter — done |

Each step was motivated by inspecting the previous model's residuals.

## Task

Open `exercise.Rmd`. You will:

1. Build the three-step progressive diamond model, checking residuals at each step with `add_residuals()` and `ggplot2`.
2. Implement the many-models pipeline for `nycflights13` by carrier, extract and plot the `dep_delay` slopes.
3. Fit a logistic growth model with `nls()` to simulated population data, plot fitted vs observed.

## Check

`npm run check -- bdat-608 module-06 lesson-01`

## Reflection

In the many-models pipeline, two carriers have `dep_delay` slopes near 0.9 while one has a slope of 1.4. Before concluding the high-slope carrier is "worse", what other information would you need to examine?
