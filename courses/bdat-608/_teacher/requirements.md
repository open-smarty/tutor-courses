# Learning Requirements

## Learning outcomes

After completing this course, students will be able to:

1. Explain the signal/noise decomposition that underlies statistical modelling and describe the iterative modelling cycle
2. Define RMSE and MAE, implement them as R functions, and use `optim()` to minimise a custom loss
3. Fit a linear model with `lm()`, interpret `summary()` output, and extract coefficients
4. Generate a prediction grid with `data_grid()` and visualise fitted values and residuals
5. Interpret the four standard diagnostic plots for a linear model and identify violations of assumptions
6. Write R formulas using `+`, `*`, `I()`, `poly()`, and `ns()` correctly and verify the model matrix
7. Distinguish additive from interaction models and choose between them using AIC and residual plots
8. Choose natural spline degrees of freedom by 10-fold cross-validation
9. Handle missing values appropriately using `na.exclude` and multiple imputation with `mice`
10. Fit logistic and Poisson regression using `glm()` and interpret exponentiated coefficients
11. Apply robust regression with `MASS::rlm()` and explain when it is preferred over OLS
12. Fit a GAM with `mgcv::gam()` and interpret effective degrees of freedom (EDF)
13. Apply Ridge and LASSO regularisation with `glmnet` and select lambda by cross-validation
14. Use `nest()` + `purrr::map()` + `broom::tidy()` to fit and compare models across many groups

## Prerequisites

- R and RStudio installed; basic R literacy (vectors, data frames, `|>` pipe)
- `ggplot2` familiarity (scatter plots, `aes()`, `geom_point()`, `geom_line()`)
- First-statistics course: regression concepts (slope, intercept, residuals, R²)
- Completed BDAT 607 or equivalent

## Constraints

- All code must be written in R. Python is not acceptable.
- Students must knit each exercise Rmd to confirm it runs without errors before submission.
- Exercises use specific built-in datasets — students must not substitute different data.
- Each lesson introduces at most two new functions or concepts in depth.
- Solutions must include the ggplot2 visualisation specified — coefficient tables alone are insufficient.

## Structure

- Modules: 6
- Lessons per module: 2–3 (total 14 lessons)
- Exercise files: .Rmd (knittable R Markdown)
- Solution files: .Rmd (complete, with output)
