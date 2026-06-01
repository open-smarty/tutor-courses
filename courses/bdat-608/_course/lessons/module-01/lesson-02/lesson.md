# Lesson 2: Setting Up the R Modelling Environment

## Goal

Install and load the R packages used throughout BDAT 608, verify that key datasets are available, and produce your first diagnostic scatter plot of the `sim1` data.

## Concept

Before fitting any model, you need a reproducible environment: the right packages loaded, global options set, and an understanding of the datasets you will use.

### Core packages

| Package | Key functions | Why we use it |
|---------|--------------|---------------|
| `tidyverse` | `ggplot2`, `dplyr`, `purrr`, `tidyr` | Data manipulation and visualisation |
| `modelr` | `data_grid()`, `add_predictions()`, `add_residuals()` | Model-centric helpers for tidy workflows |
| `splines` | `ns()` | Natural spline basis (ships with base R) |
| `ggfortify` | `autoplot()` | ggplot2-style diagnostics for `lm` objects |
| `caret` | `createFolds()` | Cross-validation helpers |
| `mice` | `mice()`, `pool()` | Multiple imputation for missing data |
| `mgcv` | `gam()`, `s()`, `te()` | Generalised Additive Models |
| `rpart` | `rpart()` | Decision trees |
| `MASS` | `rlm()` | Robust linear regression |
| `glmnet` | `glmnet()`, `cv.glmnet()` | Ridge and LASSO regularisation |
| `broom` | `tidy()`, `augment()`, `glance()` | Tidy model outputs |

### One important global option

```r
options(na.action = na.warn)
```

This makes R warn you whenever a modelling function silently drops rows with missing values. Without it, you can lose data without realising it.

### The `sim1`–`sim4` datasets

All four are built into `modelr`. Each is a small teaching dataset designed to illustrate a different modelling scenario:

| Dataset | Predictors | Purpose |
|---------|-----------|---------|
| `sim1` | 1 continuous | Simple linear relationship |
| `sim2` | 1 categorical | Categorical predictors |
| `sim3` | 1 continuous + 1 categorical | Interactions |
| `sim4` | 2 continuous | Two-predictor interaction surfaces |

### MASS masks dplyr

**Important:** `MASS` exports a function also called `select()`. When loaded after `tidyverse`, it will overwrite `dplyr::select()`, breaking many pipelines. Always restore the tidyverse versions:

```r
library(MASS)
select <- dplyr::select   # restore after MASS masks it
filter <- dplyr::filter
```

## Example

```r
library(tidyverse)
library(modelr)

options(na.action = na.warn)

data("sim1", package = "modelr")
glimpse(sim1)

ggplot(sim1, aes(x, y)) +
  geom_point(size = 3, colour = "#1B3A6B") +
  labs(
    title    = "sim1: Response vs Predictor",
    subtitle = "There is a clear linear trend with random scatter around it."
  ) +
  theme_minimal(base_size = 13)
```

A quick `glimpse()` confirms `sim1` has 30 rows and 2 columns. The scatter plot shows a clear upward linear trend: each unit increase in `x` is associated with an increase in `y`.

## Task

Open `exercise.Rmd` and complete the tasks:

1. Install any missing packages (use the `eval=FALSE` chunk so it does not run on every knit).
2. Load all required packages and restore `dplyr::select` and `dplyr::filter`.
3. Set `options(na.action = na.warn)`.
4. Run the package check and confirm all packages return `TRUE`.
5. Produce a `glimpse()` of `sim1` and a scatter plot with title "sim1: Ready to model".

Knit the document. It must produce HTML with no errors.

## Check

```
npm run check -- bdat-608 module-01 lesson-02
```

## Reflection

Why do we set `options(na.action = na.warn)` at the start of every modelling session, rather than relying on R's default behaviour? Give a concrete example of the kind of mistake this option helps prevent.
