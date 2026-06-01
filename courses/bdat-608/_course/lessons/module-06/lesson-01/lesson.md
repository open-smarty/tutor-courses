# Lesson 14: Model Building in Practice — Diamonds, Flights, and Growth Models

## Goal

Apply the full modelling workflow to three real-data case studies: progressive model building on `diamonds`, the many-models pipeline with `purrr` on `nycflights13`, and non-linear growth fitting with `nls()`.

## Concept

This extended lesson integrates everything from the course into three connected case studies. Each study practises a different skill:

### Case Study 1 — Diamonds: Progressive Model Building

The `diamonds` dataset (53,940 rows) from `ggplot2` records diamond prices, carat weights, and quality attributes.

**Step 1:** Identify the need for transformation via EDA.
```r
ggplot(diamonds, aes(carat, price)) + geom_bin2d(bins=60)
ggplot(diamonds, aes(log(carat), log(price))) + geom_bin2d(bins=60)
```
The raw scale is curved and heteroscedastic; the log-log scale is linear and homoscedastic.

**Step 2:** Fit a log-log model and inspect residuals.
```r
mod_d1 <- lm(log(price) ~ log(carat), data = diamonds)
```
R² ≈ 0.93, but residuals show systematic patterns by `cut`, `color`, `clarity` — these quality attributes add price premiums that carat alone cannot capture.

**Step 3:** Peel back layers — add quality attributes.
```r
mod_d2 <- lm(log(price) ~ log(carat) + cut + color + clarity, data = diamonds)
```
AIC drops dramatically. The residuals by cut are now nearly pattern-free.

**Key insight:** Large residuals from a simple model signal a missing predictor. Inspecting the characteristics of high-residual observations guides model improvement.

### Case Study 2 — Flights: Many Models with `purrr`

`nycflights13::flights` (336,776 rows) records NYC departures in 2013. We ask: how well do time-of-day and month predict departure delays **per carrier**?

```r
carrier_models <- flights |>
  filter(!is.na(dep_delay)) |>
  group_by(carrier) |>
  nest() |>
  mutate(
    mod  = map(data, ~ lm(dep_delay ~ hour + month, data = .x)),
    rsq  = map_dbl(mod, ~ summary(.x)$r.squared),
    rmse = map_dbl(mod, ~ sqrt(mean(residuals(.x)^2)))
  )
```

`broom::tidy()` then extracts coefficients from all models into a single tidy data frame for plotting.

**Key insight:** R² < 0.05 for all carriers — time and month explain very little delay variance. Delays are primarily driven by unpredictable factors (weather, knock-on delays). But: **statistical significance ≠ practical importance** — the hour coefficient can be significant even when R² is near zero.

### Case Study 3 — Non-Linear Growth with `nls()`

`nls()` fits non-linear models by iterative least squares. It requires **sensible starting values** — unlike `lm()`, there is no closed form.

**Logistic growth model:**
$$y = \frac{K}{1 + e^{-r(t-t_0)}} + \varepsilon$$

- $K$: carrying capacity (asymptote)
- $r$: growth rate
- $t_0$: inflection point

```r
mod_nls <- nls(y ~ K / (1 + exp(-r * (t - t0))),
               data  = logistic_growth,
               start = list(K = 100, r = 0.5, t0 = 10))
coef(mod_nls)
```

**Key insight:** Always use domain knowledge or a coarse grid search to choose starting values for `nls()`. Poor starting values cause failure to converge.

## Task

Open `exercise.Rmd` and complete all three case studies:

1. **Diamonds:** EDA, log-log model, add quality attributes, compare AIC, inspect residuals by cut.
2. **Flights:** Many-models pipeline by carrier. Extract hour coefficient for each carrier using `broom::tidy()`. Plot with confidence intervals.
3. **NLS:** Simulate logistic growth data, fit `nls()`, plot the fitted S-curve.
4. **E6 Extension:** Use `broom::augment()` to find the 5 diamonds with the largest residuals from `mod_d1`. What do they have in common?

## Check

```
npm run check -- bdat-608 module-06 lesson-01
```

## Reflection

Across the three case studies, what is the common thread linking the modelling cycle? How did inspecting residuals guide each next step?
