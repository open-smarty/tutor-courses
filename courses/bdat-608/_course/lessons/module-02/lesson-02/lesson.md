# Lesson 4: Search Strategies and Numerical Optimisation

## Goal

Use random search, grid search, and `optim()` to find the parameter values that minimise a loss function, and understand the relationship between these methods and the RMSE landscape.

## Concept

Once you have a loss function, fitting a model means finding the parameter values at the **minimum** of that function. There are three strategies, ordered from least to most efficient:

### 1. Random Search

Generate many random parameter pairs, evaluate the loss for each, and keep the best ones.

```r
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
) |>
  mutate(dist = map2_dbl(a1, a2, sim1_dist))
```

**Pro:** Simple to implement.  
**Con:** Wastes evaluations in poor regions; unlikely to find the true minimum precisely.

### 2. Grid Search

Evaluate the loss on a structured, evenly spaced grid of parameter values.

```r
grid_search <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) |>
  mutate(dist = map2_dbl(a1, a2, sim1_dist))
```

**Pro:** Systematic; explores the space evenly.  
**Con:** Exponentially expensive as the number of parameters grows (the *curse of dimensionality*). With 50 parameters and 10 grid points each, you need $10^{50}$ evaluations.

### 3. `optim()` — Numerical Optimisation

`optim()` starts at a given point and iteratively moves toward lower loss values using an algorithm (default: Nelder-Mead simplex).

```r
best <- optim(par = c(0, 0), fn = measure_distance, data = sim1)
best$par    # optimal (intercept, slope)
best$value  # minimum RMSE achieved
```

**Pro:** Scales to many parameters; converges to the minimum far more efficiently than search.  
**Con:** Requires sensible starting values; can get trapped in local minima for non-convex loss surfaces.

### The RMSE landscape

It helps to visualise the loss as a surface over the parameter space:

```r
ggplot(models, aes(a1, a2, colour = dist)) +
  geom_point(size = 2) +
  scale_colour_viridis_c(name = "RMSE") +
  labs(title = "RMSE landscape over (intercept, slope)")
```

The low-RMSE region (yellow in viridis) is a narrow valley. `optim()` walks down into that valley; random and grid search just sample from it.

## Example

```r
library(modelr); library(tidyverse)
data("sim1")

model1 <- function(a, data) a[1] + data$x * a[2]
measure_distance <- function(mod, data) {
  sqrt(mean((data$y - model1(mod, data))^2))
}
sim1_dist <- function(a1, a2) measure_distance(c(a1, a2), sim1)

# optim() finds the minimum
best <- optim(c(0, 0), measure_distance, data = sim1)
cat("Intercept:", round(best$par[1], 4), "  Slope:", round(best$par[2], 4))
cat("Min RMSE:", round(best$value, 4))
```

Running this gives approximately intercept = 4.22, slope = 2.05 — the same as `lm()`. The difference is that `optim()` uses an iterative algorithm while `lm()` has a closed-form solution (more on that in Lesson 5).

## Task

Open `exercise.Rmd` and complete:

1. Run a random search with 500 candidate models on `sim1`. Plot the top 10 lines (ranked by RMSE) overlaid on the scatter plot.
2. Plot the RMSE landscape — a scatter plot of `a1` vs `a2` coloured by `dist`.
3. Run `optim()` to find the best (intercept, slope) for RMSE. Print the result.
4. Compare: which search method came closest to `optim()`'s answer?

## Check

```
npm run check -- bdat-608 module-02 lesson-02
```

## Reflection

Grid search is systematic but impractical for many parameters. `optim()` is efficient but needs starting values. What is the risk of providing poor starting values to `optim()`, and how would you mitigate it?
