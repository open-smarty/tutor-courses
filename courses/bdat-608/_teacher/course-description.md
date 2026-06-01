# Course Description

**Course title:** BDAT 608: Computational Statistics in Big Data II — Model Basics in R

**Subject area:** Statistics / Data Science / R Programming

**Target audience:** MSc Big Data Analytics students (University of Ghana, Legon); assumes prior R literacy and basic regression concepts

**Approximate duration:** ~7.5 hours across 14 lessons (6 modules)

**Instructors:** Richard Minkah, PhD and E. Somua-Wiafe, PhD  
**Department:** Statistics & Actuarial Science, University of Ghana, Legon  
**Academic Year:** 2025/2026

## Overview

This course teaches the complete statistical modelling workflow in R. Starting from first principles, students learn to define a model family, choose a fitting criterion, fit the model using base R and tidyverse tools, visualise fitted values and residuals, diagnose model adequacy, and extend to non-linear, robust, and penalised model families when the linear assumption is insufficient.

The unifying theme — borrowed from Wickham & Grolemund's *R for Data Science* — is that **a model separates signal from noise**: fitted values capture the structural pattern, while residuals contain everything the model missed. Learning to inspect residuals is the central diagnostic skill that runs through every lesson.

The course moves from manual implementation (writing loss functions by hand, using `optim()`) to the standard `lm()` workflow, then broadens to generalised linear models, robust regression, GAMs, penalised regression, and decision trees. Two extended case studies anchor the theory in real data: the `diamonds` dataset (progressive model building) and `nycflights13` (many-models pipeline with `purrr`).

## Topics covered

- What is a statistical model? Signal vs noise, model family vs fitted model
- Fitting criterion: RMSE and MAE; random search, grid search, `optim()`
- Closed-form OLS: `lm()`, `coef()`, `summary()`, QR decomposition
- Visualising models: `data_grid()`, `add_predictions()`, `add_residuals()`, four-panel diagnostics
- R formula language: `+`, `*`, `:`, `I()`, `-1`; `model_matrix()`; dummy coding
- Categorical predictors and interactions (additive vs interaction models)
- Polynomial regression with `poly()`; natural splines with `ns()`; 10-fold cross-validation
- Missing values: `na.exclude`, mean imputation, multiple imputation with `mice`
- Generalised Linear Models: logistic regression, Poisson regression
- Robust regression with `MASS::rlm()` and Huber's M-estimator
- Generalised Additive Models: `mgcv::gam()`, `s()`, `te()`, effective degrees of freedom
- Penalised regression: Ridge and LASSO via `glmnet`; cross-validation for lambda
- Decision trees: `rpart`, `rpart.plot`, `maxdepth`, pruning
- Many models at scale: `nest()` + `purrr::map()` + `broom::tidy()`; `nls()` for non-linear growth
