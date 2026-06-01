# ======================================================================
# BDAT 608: Computational Statistics in Big Data II
# Model Basics in R: Families, Fitting, Visualisation & Diagnostics
# Clean Study Script based on the 144-page lecture PDF
# University of Ghana, Department of Statistics & Actuarial Science
# ======================================================================

# ----------------------------------------------------------------------
# HOW TO USE THIS SCRIPT
# ----------------------------------------------------------------------
# 1. Paste this file into a new R script in RStudio, or open this .R file.
# 2. The install.packages() line is COMMENTED OUT so packages are not
#    reinstalled every time you run the script.
# 3. Run the setup section first, then run each chapter section gradually.
# 4. Some plots will appear in the Plots panel. Some models will print
#    summaries in the Console.
# 5. This is a cleaned, runnable study version of the lecture code. A few
#    helper lines have been added where the slides use an object that was
#    introduced earlier or where extracted slide text was incomplete.


# ======================================================================
# CHAPTER 0: PACKAGE INSTALLATION AND LIBRARY SETUP
# PDF section: Prerequisites & Setup
# ======================================================================

# ----------------------------------------------------------------------
# 0.1 Install packages
# ----------------------------------------------------------------------
# Run this ONLY if the packages are not already installed.
# Keep it commented out during normal use.
#
# NOTE:
# - splines comes with base R, so we load it later but do not install it.
# - MASS is usually installed with R, but it is included here for safety.
# - glmnet, broom, and hexbin are added because later lecture sections use
#   glmnet::glmnet(), broom::tidy(), and ggplot2::geom_hex().

# install.packages(c(
#   "tidyverse",
#   "modelr",
#   "ggfortify",
#   "caret",
#   "mice",
#   "cvAUC",
#   "mgcv",
#   "rpart",
#   "rpart.plot",
#   "nycflights13",
#   "MASS",
#   "glmnet",
#   "broom",
#   "hexbin"
# ))


# ----------------------------------------------------------------------
# 0.2 Load libraries
# ----------------------------------------------------------------------
# These are the libraries used throughout the chapter.

library(tidyverse)     # Data manipulation and visualisation collection
library(modelr)        # Model helper functions: data_grid(), add_predictions(), etc.
library(splines)       # Natural spline functions such as ns(); comes with R
library(dplyr)         # Data manipulation verbs: filter(), mutate(), summarise(), etc.
library(ggplot2)       # Plotting system
library(ggfortify)     # autoplot() diagnostics for model objects
library(caret)         # Cross-validation helper functions such as createFolds()
library(mice)          # Multiple imputation for missing data
library(cvAUC)         # Contains the admissions dataset for logistic regression
library(mgcv)          # Generalised Additive Models: gam(), s(), te()
library(rpart)         # Decision tree models
library(rpart.plot)    # Better plotting for rpart trees
library(nycflights13)  # Flight data for many-model examples
library(MASS)          # Robust regression: rlm()
library(glmnet)        # Ridge and LASSO regression
library(broom)         # tidy(), augment(), glance() for model outputs


# ----------------------------------------------------------------------
# 0.3 Global modelling option
# ----------------------------------------------------------------------
# This makes R warn you when modelling functions drop rows with missing
# values. This is safer than silently losing rows.

options(na.action = na.warn)


# ----------------------------------------------------------------------
# 0.4 Quick package check
# ----------------------------------------------------------------------
# TRUE means the package is available and can be loaded.

required_packages <- c(
  "tidyverse", "modelr", "ggfortify", "caret", "mice", "cvAUC",
  "mgcv", "rpart", "rpart.plot", "nycflights13", "MASS",
  "glmnet", "broom", "hexbin"
)

package_check <- sapply(required_packages, requireNamespace, quietly = TRUE)
print(package_check)

if (any(!package_check)) {
  warning("Some packages are missing. Uncomment the install.packages() block above and install them.")
}


# ----------------------------------------------------------------------
# 0.5 Main datasets introduced in the lecture
# ----------------------------------------------------------------------
# sim1, sim2, sim3, and sim4 are built into the modelr package.
# diamonds is built into ggplot2/tidyverse.
# flights is built into nycflights13.
# admissions is built into cvAUC.

# sim1: simple linear relationship; used for linear modelling intuition.
data("sim1", package = "modelr")
sim1_base <- sim1  # Keep a clean copy for later examples.

glimpse(sim1)

ggplot(sim1, aes(x, y)) +
  geom_point(size = 3, colour = "#1B3A6B") +
  labs(title = "sim1: Response vs Predictor") +
  theme_minimal()


# ======================================================================
# CHAPTER 1: INTRODUCTION TO STATISTICAL MODELS
# PDF section: Introduction to Statistical Models
# ======================================================================

# ----------------------------------------------------------------------
# 1.1 Big idea of a statistical model
# ----------------------------------------------------------------------
# A statistical model has two parts:
# 1. A family of possible models, for example y = a1 + a2*x + error.
# 2. A fitted model, which is the specific member of the family that best
#    matches the observed data.
#
# The modelling workflow is:
# Observe Data -> Choose Model Family -> Fit Model -> Generate Predictions ->
# Inspect Residuals -> Decide whether the model is adequate -> Revise if needed.


# ======================================================================
# CHAPTER 2: FITTING A SIMPLE LINEAR MODEL
# PDF section: Fitting a Simple Linear Model
# ======================================================================

# ----------------------------------------------------------------------
# 2.1 Linear model family
# ----------------------------------------------------------------------
# We assume y can be described approximately by:
#   y = a1 + a2*x + error
# where:
#   a1 = intercept
#   a2 = slope
# The goal is to find the best a1 and a2.


# ----------------------------------------------------------------------
# 2.2 Define candidate model and RMSE loss function
# ----------------------------------------------------------------------
# model1() calculates predicted y values for a candidate intercept and slope.
# measure_distance() calculates RMSE: root mean squared error.
# Smaller RMSE means the candidate line fits the data better.

model1 <- function(a, data) {
  a[1] + data$x * a[2]  # intercept + slope * x
}

measure_distance <- function(mod, data) {
  resid <- data$y - model1(mod, data)  # prediction errors
  sqrt(mean(resid^2))                  # RMSE
}

# Test RMSE for a candidate model: intercept = 7, slope = 1.5
measure_distance(c(7, 1.5), sim1)


# ----------------------------------------------------------------------
# 2.3 Alternative loss: Mean Absolute Error (MAE)
# ----------------------------------------------------------------------
# MAE uses absolute residuals instead of squared residuals.
# It is less sensitive to outliers than RMSE/OLS.

measure_mae <- function(mod, data) {
  resid <- data$y - model1(mod, data)
  mean(abs(resid))
}

# Simulate data with heavy-tailed noise. Heavy tails create possible outliers.
set.seed(42)
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

# Fit using MAE via optim().
best_mae <- optim(c(0, 0), measure_mae, data = sim1a)
print(best_mae$par)

# Compare with ordinary least squares.
coef(lm(y ~ x, data = sim1a))


# ----------------------------------------------------------------------
# 2.4 Random search over the parameter space
# ----------------------------------------------------------------------
# Randomly generate many intercept/slope combinations, calculate RMSE for
# each one, and visualise the best few lines.

sim1_dist <- function(a1, a2) measure_distance(c(a1, a2), sim1)

set.seed(7)
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
) |>
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(models, rank(dist) <= 10),
    linewidth = 0.8
  ) +
  scale_colour_viridis_c(guide = "none") +
  labs(title = "Top 10 randomly sampled models")


# ----------------------------------------------------------------------
# 2.5 Grid search
# ----------------------------------------------------------------------
# Grid search tries a structured grid of intercepts and slopes.
# This is less wasteful than random search, but still expensive for many
# parameters.

grid_search <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) |>
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

# View best 5 grid models.
grid_search |> slice_min(dist, n = 5)

# Visualise top 10 grid models.
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(grid_search, rank(dist) <= 10)
  ) +
  labs(title = "Top 10 grid-search models")


# ----------------------------------------------------------------------
# 2.6 Numerical optimisation with optim()
# ----------------------------------------------------------------------
# optim() searches for the parameter values that minimise the RMSE function.

best <- optim(
  par = c(0, 0),
  fn = measure_distance,
  data = sim1
)

print(best$par)    # Best intercept and slope found by optim()
print(best$value)  # Minimum RMSE achieved

ggplot(sim1, aes(x, y)) +
  geom_point(colour = "#1B3A6B", size = 2.5) +
  geom_abline(
    intercept = best$par[1],
    slope = best$par[2],
    colour = "#C9A84C",
    linewidth = 1.2
  ) +
  labs(title = "Best model found by optim()")


# ----------------------------------------------------------------------
# 2.7 Closed-form OLS with lm()
# ----------------------------------------------------------------------
# lm() is the standard function for fitting linear models in R.
# For ordinary linear models, it is faster and more reliable than manually
# using optim().

sim1_mod <- lm(y ~ x, data = sim1)

coef(sim1_mod)
summary(sim1_mod)


# ======================================================================
# CHAPTER 3: VISUALISING MODELS
# PDF section: Visualising Models
# ======================================================================

# ----------------------------------------------------------------------
# 3.1 Generate predictions with modelr
# ----------------------------------------------------------------------
# data_grid() creates a clean grid of predictor values.
# add_predictions() adds model predictions to that grid.

grid <- sim1 |>
  data_grid(x)

grid <- grid |>
  add_predictions(sim1_mod)

print(grid)

# Plot observed data with fitted line.
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y), colour = "#1B3A6B", size = 2.5) +
  geom_line(aes(y = pred), data = grid, colour = "#C9A84C", linewidth = 1.3) +
  labs(
    title = "sim1: Data and Fitted Line",
    y = expression(y ~ "/" ~ hat(y)),
    caption = "Gold line = OLS fitted values"
  ) +
  theme_minimal(base_size = 12)


# ----------------------------------------------------------------------
# 3.2 Add and plot residuals
# ----------------------------------------------------------------------
# Residual = observed y - predicted y.
# Good residuals should be centred around 0 and should not show a clear
# pattern against the predictor.

sim1 <- sim1 |>
  add_residuals(sim1_mod)

# Plot distribution of residuals.
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5, colour = "#1B3A6B", linewidth = 1) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "#C9A84C") +
  labs(
    title = "Distribution of residuals",
    x = "Residual (y - yhat)"
  )

# Plot residuals against x.
ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0, colour = "#C9A84C") +
  geom_point(colour = "#1B3A6B", size = 2.5) +
  labs(
    title = "Residuals vs x",
    y = "Residual (y - yhat)"
  )


# ----------------------------------------------------------------------
# 3.3 Standard diagnostic plots
# ----------------------------------------------------------------------
# Base R diagnostics: Residuals vs Fitted, Normal Q-Q, Scale-Location,
# and Cook's Distance.

par(mfrow = c(2, 2))
plot(sim1_mod)
par(mfrow = c(1, 1))

# ggplot2-style diagnostics.
autoplot(
  sim1_mod,
  which = 1:4,
  colour = "#1B3A6B",
  smooth.colour = "#C9A84C"
)


# ----------------------------------------------------------------------
# 3.4 Compare multiple prediction models at once
# ----------------------------------------------------------------------
# Here we compare a simple linear model and a quadratic model.

mod_a <- lm(y ~ x, data = sim1)
mod_b <- lm(y ~ x + I(x^2), data = sim1)

grid_multi <- sim1 |>
  data_grid(x) |>
  gather_predictions(mod_a, mod_b)

ggplot(sim1, aes(x, y)) +
  geom_point(colour = "grey40", size = 2) +
  geom_line(data = grid_multi, aes(y = pred, colour = model), linewidth = 1.2) +
  scale_colour_manual(
    values = c("#1B3A6B", "#C9A84C"),
    labels = c("Linear", "Quadratic")
  ) +
  labs(title = "Linear vs Quadratic model on sim1", colour = "Model") +
  theme_minimal(base_size = 12)

# Compare residual spread for the two models.
sim1 |>
  gather_residuals(mod_a, mod_b) |>
  ggplot(aes(x, resid, colour = model)) +
  geom_point() +
  geom_ref_line(h = 0) +
  facet_wrap(~ model) +
  scale_colour_manual(values = c("#1B3A6B", "#C9A84C"))


# ======================================================================
# CHAPTER 4: FORMULAS AND MODEL FAMILIES
# PDF section: Formulas and Model Families
# ======================================================================

# ----------------------------------------------------------------------
# 4.1 R formula notation and the model matrix
# ----------------------------------------------------------------------
# A formula such as y ~ x1 + x2 means:
#   y = a0 + a1*x1 + a2*x2 + error
# R automatically adds an intercept unless you remove it with -1.

# Small example dataset used to inspect formula behaviour.
df <- tribble(
  ~y, ~x1, ~x2,
  4,  2,   5,
  5,  1,   6
)

# Intercept is added automatically.
model_matrix(df, y ~ x1)

# Remove intercept.
model_matrix(df, y ~ x1 - 1)

# Add second predictor.
model_matrix(df, y ~ x1 + x2)


# ----------------------------------------------------------------------
# 4.2 Categorical predictors and dummy coding
# ----------------------------------------------------------------------
# sim2 has a categorical x variable. R automatically creates k - 1 dummy
# variables, using one category as the reference group.

data("sim2", package = "modelr")
glimpse(sim2)

mod2 <- lm(y ~ x, data = sim2)

# Inspect dummy-variable encoding.
model_matrix(sim2, y ~ x) |> head(4)

coef(mod2)

# Under OLS, the predicted value for each category equals the group mean.
sim2 |>
  data_grid(x) |>
  add_predictions(mod2)


# ----------------------------------------------------------------------
# 4.3 Interaction: continuous predictor x categorical predictor
# ----------------------------------------------------------------------
# sim3 has:
#   x1 = continuous predictor
#   x2 = categorical predictor
#   y  = response
#
# Additive model: same slope for every group, different intercepts.
# Interaction model: different slopes and intercepts for each group.

data("sim3", package = "modelr")
glimpse(sim3)

mod_add <- lm(y ~ x1 + x2, data = sim3)
mod_int <- lm(y ~ x1 * x2, data = sim3)

# x1 * x2 expands to x1 + x2 + x1:x2.
model_matrix(sim3, y ~ x1 * x2) |> names()

# Compare predictions.
grid_sim3 <- sim3 |>
  data_grid(x1, x2) |>
  gather_predictions(mod_add, mod_int)

ggplot(sim3, aes(x1, y, colour = x2)) +
  geom_point() +
  geom_line(data = grid_sim3, aes(y = pred)) +
  facet_wrap(~ model) +
  labs(title = "Additive (+) vs Interaction (*) model")


# ----------------------------------------------------------------------
# 4.4 Selecting between additive and interaction models
# ----------------------------------------------------------------------
# We inspect residuals, AIC, and R-squared.
# Lower AIC usually indicates a better fit after accounting for complexity.

sim3_resid <- sim3 |>
  gather_residuals(mod_add, mod_int)

ggplot(sim3_resid, aes(x1, resid, colour = x2)) +
  geom_point(alpha = 0.8) +
  geom_ref_line(h = 0) +
  facet_grid(model ~ x2) +
  scale_colour_brewer(palette = "Set1") +
  labs(title = "Residuals: additive vs interaction model")

AIC(mod_add, mod_int)
summary(mod_add)$r.squared
summary(mod_int)$r.squared


# ----------------------------------------------------------------------
# 4.5 Interaction: two continuous predictors
# ----------------------------------------------------------------------
# sim4 has two continuous predictors, x1 and x2.
# The interaction model allows the slope of x1 to depend on x2.

data("sim4", package = "modelr")
glimpse(sim4)

# The lecture later refers to mod1_s4, so we define it clearly here.
mod1_s4 <- lm(y ~ x1 + x2, data = sim4)       # additive model
mod2_s4 <- lm(y ~ x1 * x2, data = sim4)       # interaction model

# Create a 5 x 5 prediction grid.
grid4 <- sim4 |>
  data_grid(
    x1 = seq_range(x1, n = 5),
    x2 = seq_range(x2, n = 5)
  ) |>
  gather_predictions(mod1_s4, mod2_s4)

# Heatmap/top-down view of the predicted surface.
ggplot(grid4, aes(x1, x2, fill = pred)) +
  geom_tile() +
  facet_wrap(~ model) +
  scale_fill_viridis_c() +
  labs(title = "Predicted surface: additive vs interaction")

# Slice view of the predicted surface.
ggplot(grid4, aes(x1, pred, colour = x2, group = x2)) +
  geom_line() +
  facet_wrap(~ model) +
  scale_colour_viridis_c() +
  labs(title = "Slices of the predicted surface")


# ----------------------------------------------------------------------
# 4.6 Extended example: three-way interaction
# ----------------------------------------------------------------------
# This simulates data where the x1:x2 interaction differs by group.

set.seed(99)
n <- 200

df3 <- tibble(
  x1 = rnorm(n),
  x2 = rnorm(n),
  group = sample(c("A", "B"), n, replace = TRUE),
  y = 2 * x1 + 1.5 * x2 +
    ifelse(group == "B", 3 * x1 * x2, 0) +
    rnorm(n, sd = 0.8)
)

m0 <- lm(y ~ x1 + x2 + group, data = df3)
m1 <- lm(y ~ x1 * x2 + group, data = df3)
m2 <- lm(y ~ x1 * x2 * group, data = df3)

anova(m0, m1, m2)


# ----------------------------------------------------------------------
# 4.7 Transformations inside formulas
# ----------------------------------------------------------------------
# In R formulas, ^ has special formula meaning. Use I() when you want
# literal arithmetic such as x^2.

# WRONG for literal x squared: R formula parsing collapses this to x.
model_matrix(sim1_base, y ~ x^2 + x)

# CORRECT: I() protects arithmetic.
model_matrix(sim1_base, y ~ I(x^2) + x)

# Log transformation of response.
lm(log(y) ~ x, data = sim1_base)

# Square-root transformation of predictor.
lm(y ~ sqrt(x), data = sim1_base)

# Multiple transformations.
lm(log(y) ~ I(x^2) + x, data = sim1_base)


# ----------------------------------------------------------------------
# 4.8 Polynomial models with poly()
# ----------------------------------------------------------------------
# raw = TRUE gives ordinary polynomial terms.
# The default poly() uses orthogonal polynomials, which are more numerically
# stable but harder to interpret directly.

mod_p2 <- lm(y ~ poly(x, 2, raw = TRUE), data = sim1_base)
coef(mod_p2)

mod_p2o <- lm(y ~ poly(x, 2), data = sim1_base)

mods <- list(
  p1 = lm(y ~ poly(x, 1), data = sim1_base),
  p2 = lm(y ~ poly(x, 2), data = sim1_base),
  p3 = lm(y ~ poly(x, 3), data = sim1_base),
  p5 = lm(y ~ poly(x, 5), data = sim1_base)
)

sim1_base |>
  data_grid(x = seq_range(x, 50)) |>
  gather_predictions(!!!mods) |>
  ggplot(aes(x, pred, colour = model)) +
  geom_line() +
  geom_point(data = sim1_base, aes(x, y), colour = "grey40") +
  labs(title = "Polynomial fits of increasing degree")


# ----------------------------------------------------------------------
# 4.9 Natural splines with ns()
# ----------------------------------------------------------------------
# Natural splines model flexible non-linear patterns while behaving more
# safely than high-degree polynomials at the edges.

set.seed(1)
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(50)
)

sp_mods <- list(
  df1 = lm(y ~ ns(x, 1), data = sim5),
  df3 = lm(y ~ ns(x, 3), data = sim5),
  df5 = lm(y ~ ns(x, 5), data = sim5)
)

# Predict on a fine grid including slight extrapolation.
grid5 <- sim5 |>
  data_grid(x = seq_range(x, n = 60, expand = 0.1)) |>
  gather_predictions(!!!sp_mods, .pred = "y")

ggplot(sim5, aes(x, y)) +
  geom_point(colour = "grey40") +
  geom_line(data = grid5, colour = "#C9A84C", linewidth = 1) +
  facet_wrap(~ model, labeller = label_both) +
  labs(title = "Natural splines: df = 1, 3, 5")


# ----------------------------------------------------------------------
# 4.10 Choosing spline degrees of freedom with cross-validation
# ----------------------------------------------------------------------
# Too few degrees of freedom underfits. Too many degrees of freedom overfits.
# Cross-validation estimates how well the model performs on unseen data.

set.seed(42)
cv_rmse <- sapply(1:8, function(df) {
  folds <- createFolds(sim5$y, k = 10)

  fold_rmse <- sapply(folds, function(idx) {
    train <- sim5[-idx, ]
    test <- sim5[idx, ]
    mod <- lm(y ~ ns(x, df), data = train)
    pred <- predict(mod, newdata = test)
    sqrt(mean((test$y - pred)^2))
  })

  mean(fold_rmse)
})

# Plot CV-RMSE against degrees of freedom.
tibble(df = 1:8, cv_rmse) |>
  ggplot(aes(df, cv_rmse)) +
  geom_line(colour = "#1B3A6B", linewidth = 1) +
  geom_point(colour = "#C9A84C", size = 3) +
  labs(
    title = "10-fold CV RMSE for ns(x, df)",
    x = "Degrees of freedom",
    y = "CV RMSE"
  )


# ----------------------------------------------------------------------
# 4.11 seq_range(): controlling prediction grids
# ----------------------------------------------------------------------
# seq_range() creates evenly spaced values over the range of a variable.
# It is useful inside data_grid().

set.seed(123)
x_var <- runif(100)

# Default: n evenly spaced values.
seq_range(x_var, n = 5)

# pretty = TRUE: round to nice numbers.
seq_range(x_var, n = 5, pretty = TRUE)

# trim = 0.1: drop extreme 10% before spacing.
x_skew <- rcauchy(100)
seq_range(x_skew, n = 5, trim = 0.10)

# expand = 0.1: extend range by 10%.
seq_range(c(0, 1), n = 5, expand = 0.1)

# Practical use inside data_grid().
grid_seq <- sim4 |>
  data_grid(
    x1 = seq_range(x1, n = 20, pretty = TRUE),
    x2 = seq_range(x2, n = 20, pretty = TRUE)
  )

glimpse(grid_seq)


# ======================================================================
# CHAPTER 5: MISSING VALUES
# PDF section: Missing Values
# ======================================================================

# ----------------------------------------------------------------------
# 5.1 How lm() handles NAs
# ----------------------------------------------------------------------
# lm() drops rows with missing values. Setting options(na.action = na.warn)
# makes R warn us when this happens.

df_na <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,   # missing response
  3, 3.5,
  4, 8.3,
  NA, 10   # missing predictor
)

options(na.action = na.warn)

mod_na <- lm(y ~ x, data = df_na)
nobs(mod_na)  # Number of observations actually used

# na.exclude drops NAs but preserves row positions in residuals/predictions.
mod_ex <- lm(y ~ x, data = df_na, na.action = na.exclude)
residuals(mod_ex)


# ----------------------------------------------------------------------
# 5.2 Imputation before modelling
# ----------------------------------------------------------------------
# Mean imputation is quick but underestimates uncertainty.
# Multiple imputation uses several plausible completed datasets and pools
# results using Rubin's rules.

set.seed(10)
df_miss <- sim1_base |>
  mutate(y = ifelse(runif(n()) < 0.1, NA, y))

# Simple mean imputation.
df_mean <- df_miss |>
  mutate(y = ifelse(is.na(y), mean(y, na.rm = TRUE), y))

# Multiple imputation.
imp <- mice(df_miss, m = 5, method = "pmm", printFlag = FALSE)

fit_imp <- with(imp, lm(y ~ x))
pool(fit_imp) |> summary()


# ======================================================================
# CHAPTER 6: BEYOND LINEAR MODELS
# PDF section: Beyond Linear Models
# ======================================================================

# ----------------------------------------------------------------------
# 6.1 Overview of model families in R
# ----------------------------------------------------------------------
# Linear Model:            lm()              continuous response
# Generalised LM:          glm()             binary/count/proportion response
# Robust Linear Model:     MASS::rlm()       outlier-resistant fitting
# Generalised Additive:    mgcv::gam()       flexible smooth curves
# Penalised Regression:    glmnet::glmnet()  ridge/LASSO regularisation
# Decision Tree:           rpart::rpart()    interpretable non-linear splits
# Random Forest:           randomForest      ensemble of trees
# Gradient Boosting:       xgboost           strong tabular performance


# ----------------------------------------------------------------------
# 6.2 Logistic regression for binary response
# ----------------------------------------------------------------------
# Logistic regression is a GLM for binary outcomes.
# family = binomial(link = "logit") fits log-odds; type = "response"
# returns predicted probabilities.

data("admissions", package = "cvAUC")
admit <- as_tibble(admissions)

glimpse(admit)

mod_logit <- glm(
  Y ~ quant + verbal + gpa + toptier,
  data = admit,
  family = binomial(link = "logit")
)

summary(mod_logit)

admit |>
  data_grid(verbal = seq_range(verbal, 20), quant, gpa, toptier) |>
  add_predictions(mod_logit, type = "response") |>
  ggplot(aes(verbal, pred, colour = factor(toptier))) +
  geom_line() +
  labs(
    y = "P(Admit)",
    title = "Admission probability vs verbal",
    colour = "Top-tier school"
  )


# ----------------------------------------------------------------------
# 6.3 Poisson regression for count data
# ----------------------------------------------------------------------
# Poisson regression is used when the response is a count.
# Exponentiated coefficients are rate ratios.

set.seed(77)
claims <- tibble(
  age = runif(300, 18, 70),
  veh_age = runif(300, 0, 15),
  n_claims = rpois(300, lambda = exp(0.02 * age - 0.05 * veh_age - 0.5))
)

mod_pois <- glm(
  n_claims ~ age + veh_age,
  data = claims,
  family = poisson(link = "log")
)

coef(mod_pois) |> exp()

claims |>
  data_grid(age = seq_range(age, 10), veh_age = c(2, 8)) |>
  add_predictions(mod_pois, type = "response") |>
  ggplot(aes(age, pred, colour = factor(veh_age))) +
  geom_line() +
  labs(
    y = "Expected claims",
    title = "Poisson GLM predictions",
    colour = "Vehicle age"
  )


# ----------------------------------------------------------------------
# 6.4 Robust linear models with MASS::rlm()
# ----------------------------------------------------------------------
# OLS can be pulled strongly by outliers because it squares residuals.
# Robust regression down-weights large residuals.

sim1_out <- sim1_base |>
  mutate(y = ifelse(row_number() %in% c(3, 17), y + 15, y))

mod_ols <- lm(y ~ x, data = sim1_out)
mod_rob <- MASS::rlm(y ~ x, method = "M", data = sim1_out)

coef(mod_ols)
coef(mod_rob)

ggplot(sim1_out, aes(x, y)) +
  geom_point() +
  geom_abline(
    aes(intercept = coef(mod_ols)[1], slope = coef(mod_ols)[2], colour = "OLS"),
    linewidth = 1
  ) +
  geom_abline(
    aes(intercept = coef(mod_rob)[1], slope = coef(mod_rob)[2], colour = "Robust"),
    linewidth = 1
  ) +
  scale_colour_manual(values = c("OLS" = "#C9A84C", "Robust" = "#1B3A6B")) +
  labs(title = "OLS vs Robust regression with outliers")


# ----------------------------------------------------------------------
# 6.5 Generalised Additive Models with mgcv::gam()
# ----------------------------------------------------------------------
# GAMs estimate smooth functions from the data.
# edf = effective degrees of freedom. edf near 1 means nearly linear.
# method = "REML" is preferred for smoothness selection.

mod_gam <- gam(
  y ~ s(x1) + s(x2),
  data = sim4,
  method = "REML"
)

summary(mod_gam)

plot(
  mod_gam,
  pages = 1,
  shade = TRUE,
  col = "#1B3A6B",
  shade.col = "#C9A84C40"
)

# GAM with interaction surface using a tensor-product smooth.
mod_gam2 <- gam(
  y ~ te(x1, x2),
  data = sim4,
  method = "REML"
)

# Predict over a grid and draw heatmap.
grid4 |>
  filter(model == "mod1_s4") |>
  add_predictions(mod_gam, var = "gam_pred") |>
  ggplot(aes(x1, x2, fill = gam_pred)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "GAM predicted surface")

# Optional: prediction surface for tensor-product GAM.
sim4 |>
  data_grid(
    x1 = seq_range(x1, n = 40),
    x2 = seq_range(x2, n = 40)
  ) |>
  add_predictions(mod_gam2, var = "gam2_pred") |>
  ggplot(aes(x1, x2, fill = gam2_pred)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "Tensor-product GAM predicted surface")


# ----------------------------------------------------------------------
# 6.6 Penalised regression: Ridge and LASSO
# ----------------------------------------------------------------------
# Ridge regression: alpha = 0, shrinks coefficients but keeps variables.
# LASSO regression: alpha = 1, can shrink some coefficients exactly to 0.

set.seed(2024)
p <- 50
n <- 200

X <- matrix(rnorm(n * p), n, p)
y <- 2 * X[, 1] - 1.5 * X[, 2] + rnorm(n)

mod_ridge <- glmnet::glmnet(X, y, alpha = 0)
mod_lasso <- glmnet::glmnet(X, y, alpha = 1)

# Cross-validate to choose lambda for LASSO.
cv_lasso <- glmnet::cv.glmnet(X, y, alpha = 1, nfolds = 10)
plot(cv_lasso)

best_lambda <- cv_lasso$lambda.min
best_lambda

# Coefficients at best lambda. The first few show intercept, V1, V2, etc.
coef(cv_lasso, s = "lambda.min")[1:5, ]


# ----------------------------------------------------------------------
# 6.7 Decision trees with rpart
# ----------------------------------------------------------------------
# Trees split the predictor space into rectangular regions and predict the
# mean response inside each region.

tree_mod <- rpart(
  y ~ x1 + x2,
  data = sim4,
  control = rpart.control(maxdepth = 4, cp = 0.01)
)

rpart.plot(
  tree_mod,
  type = 4,
  extra = 101,
  col = "#1B3A6B",
  main = "Regression tree: y ~ x1 + x2"
)

# Predictions on a grid using the same modelr workflow.
grid4_tree <- sim4 |>
  data_grid(
    x1 = seq_range(x1, 30),
    x2 = seq_range(x2, 30)
  ) |>
  add_predictions(tree_mod)

ggplot(grid4_tree, aes(x1, x2, fill = pred)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "Tree: piecewise-constant prediction surface")


# ======================================================================
# CHAPTER 7: EXTENDED CASE STUDIES
# PDF section: Extended Case Studies
# ======================================================================

# ----------------------------------------------------------------------
# 7.1 Case Study 1: Model building on diamonds
# ----------------------------------------------------------------------
# diamonds is a real dataset from ggplot2. The lecture shows that price vs
# carat is strongly non-linear on the raw scale but much more linear after
# log transformation.

data("diamonds", package = "ggplot2")

glimpse(diamonds)

# Initial EDA: raw scale.
ggplot(diamonds, aes(carat, price)) +
  geom_hex(bins = 60) +
  scale_fill_viridis_c() +
  labs(title = "Price vs Carat (raw scale)")

# Log-log scale.
ggplot(diamonds, aes(log(carat), log(price))) +
  geom_hex(bins = 60) +
  scale_fill_viridis_c() +
  labs(title = "log(price) vs log(carat) -- much more linear!")

# Fit log-log model.
mod_d1 <- lm(log(price) ~ log(carat), data = diamonds)
summary(mod_d1)$r.squared
coef(mod_d1)


# ----------------------------------------------------------------------
# 7.2 Case Study 1 continued: peeling back layers
# ----------------------------------------------------------------------
# Add cut, color, and clarity to the model. These quality attributes improve
# the fit after controlling for carat.

mod_d2 <- lm(
  log(price) ~ log(carat) + cut + color + clarity,
  data = diamonds
)

summary(mod_d2)$r.squared

# Inspect residuals.
diamonds_modelled <- diamonds |>
  add_residuals(mod_d2, var = "resid2")

ggplot(diamonds_modelled, aes(log(carat), resid2)) +
  geom_hex(bins = 50) +
  scale_fill_viridis_c() +
  geom_ref_line(h = 0) +
  facet_wrap(~ cut) +
  labs(title = "Residuals by cut -- after controlling for carat")

# Compare models using AIC. Lower AIC is better.
AIC(mod_d1, mod_d2)


# ----------------------------------------------------------------------
# 7.3 Case Study 2: Flights -- many models with purrr
# ----------------------------------------------------------------------
# Here we fit one linear model per airline carrier.
# nest() creates a list-column of data frames, and map() applies lm() to
# each nested data frame.

carrier_models <- flights |>
  filter(!is.na(dep_delay)) |>
  group_by(carrier) |>
  nest() |>
  mutate(
    mod = map(data, ~ lm(dep_delay ~ hour + month, data = .x)),
    rsq = map_dbl(mod, ~ summary(.x)$r.squared),
    rmse = map_dbl(mod, ~ sqrt(mean(residuals(.x)^2)))
  ) |>
  arrange(desc(rsq))

carrier_models |>
  select(carrier, rsq, rmse)


# ----------------------------------------------------------------------
# 7.4 Case Study 2 continued: extracting coefficients at scale
# ----------------------------------------------------------------------
# broom::tidy() converts model output into a tidy data frame.
# This makes it easy to compare coefficients across many models.

carrier_coefs <- carrier_models |>
  mutate(tidy = map(mod, broom::tidy)) |>
  unnest(tidy) |>
  filter(term == "hour")

ggplot(
  carrier_coefs,
  aes(
    x = reorder(carrier, estimate),
    y = estimate,
    ymin = estimate - 2 * std.error,
    ymax = estimate + 2 * std.error
  )
) +
  geom_pointrange(colour = "#1B3A6B") +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "#C9A84C") +
  coord_flip() +
  labs(
    title = "Effect of hour on departure delay, by carrier",
    x = "Carrier",
    y = "Estimated slope (minutes per hour)"
  )


# ----------------------------------------------------------------------
# 7.5 Case Study 3: Non-linear growth models with nls()
# ----------------------------------------------------------------------
# nls() fits non-linear models by iterative least squares.
# It needs sensible starting values.

set.seed(5)
t_seq <- seq(0, 20, by = 0.5)

logistic_growth <- tibble(
  t = t_seq,
  y = 100 / (1 + exp(-0.5 * (t - 10))) + rnorm(length(t_seq), sd = 3)
)

mod_nls <- nls(
  y ~ K / (1 + exp(-r * (t - t0))),
  data = logistic_growth,
  start = list(K = 100, r = 0.5, t0 = 10)
)

coef(mod_nls)

# Predictions.
logistic_growth |>
  data_grid(t = seq_range(t, 60)) |>
  add_predictions(mod_nls) |>
  ggplot(aes(t, pred)) +
  geom_line(colour = "#C9A84C", linewidth = 1.2) +
  geom_point(data = logistic_growth, aes(y = y), colour = "#1B3A6B", alpha = 0.6) +
  labs(title = "Logistic growth: nls() fit")


# ======================================================================
# CHAPTER 8: SUMMARY AND EXERCISES
# PDF section: Summary and Exercises
# ======================================================================

# ----------------------------------------------------------------------
# 8.1 Main summary from the lecture
# ----------------------------------------------------------------------
# 1. Define the model family and fitting criterion.
# 2. Fit with lm() for standard linear models; use optim() for custom loss.
# 3. Visualise fitted values and residuals.
# 4. Use * for interactions, I() for literal arithmetic, and ns() for splines.
# 5. Scale up with nest(), map(), and broom::tidy().
# 6. Match the model family to the response type.


# ----------------------------------------------------------------------
# 8.2 Exercise starter code: E1
# ----------------------------------------------------------------------
# Fit a linear model to sim1a multiple times with Student-t noise.
# Compare OLS and MAE-based fitting via optim().

# set.seed(1)
# exercise_results <- map_dfr(1:10, function(seed_value) {
#   set.seed(seed_value)
#   temp_data <- tibble(
#     x = rep(1:10, each = 3),
#     y = x * 1.5 + 6 + rt(length(x), df = 2)
#   )
#
#   mae_fit <- optim(c(0, 0), measure_mae, data = temp_data)
#   ols_fit <- lm(y ~ x, data = temp_data)
#
#   tibble(
#     seed = seed_value,
#     mae_intercept = mae_fit$par[1],
#     mae_slope = mae_fit$par[2],
#     ols_intercept = coef(ols_fit)[1],
#     ols_slope = coef(ols_fit)[2]
#   )
# })
# exercise_results


# ----------------------------------------------------------------------
# 8.3 Exercise starter code: E2
# ----------------------------------------------------------------------
# Inspect y ~ x1 * x2 for sim3 and write out the full equation.

# model_matrix(sim3, y ~ x1 * x2) |> head()
# coef(mod_int)


# ----------------------------------------------------------------------
# 8.4 Exercise starter code: E3
# ----------------------------------------------------------------------
# Fit loess(y ~ x) to sim1 and compare with lm().

# loess_mod <- loess(y ~ x, data = sim1_base)
# loess_grid <- sim1_base |>
#   data_grid(x = seq_range(x, 50)) |>
#   add_predictions(loess_mod, var = "loess_pred") |>
#   add_predictions(sim1_mod, var = "lm_pred")
#
# ggplot(sim1_base, aes(x, y)) +
#   geom_point() +
#   geom_line(data = loess_grid, aes(y = loess_pred), colour = "#1B3A6B") +
#   geom_line(data = loess_grid, aes(y = lm_pred), colour = "#C9A84C") +
#   labs(title = "LOESS vs LM predictions")


# ----------------------------------------------------------------------
# 8.5 Exercise starter code: E4
# ----------------------------------------------------------------------
# Fit natural splines for df = 1, 2, 3, 4, 5 and choose df by 10-fold CV.

# set.seed(42)
# cv_rmse_1_to_5 <- sapply(1:5, function(df) {
#   folds <- createFolds(sim5$y, k = 10)
#   mean(sapply(folds, function(idx) {
#     train <- sim5[-idx, ]
#     test <- sim5[idx, ]
#     mod <- lm(y ~ ns(x, df), data = train)
#     pred <- predict(mod, newdata = test)
#     sqrt(mean((test$y - pred)^2))
#   }))
# })
# tibble(df = 1:5, cv_rmse = cv_rmse_1_to_5)


# ----------------------------------------------------------------------
# 8.6 Exercise starter code: E5
# ----------------------------------------------------------------------
# Use sim4 to show that interaction model fits better than additive model.

# AIC(mod1_s4, mod2_s4)
# sim4 |>
#   gather_residuals(mod1_s4, mod2_s4) |>
#   ggplot(aes(x1, resid, colour = x2)) +
#   geom_point() +
#   geom_ref_line(h = 0) +
#   facet_wrap(~ model)


# ----------------------------------------------------------------------
# 8.7 Exercise starter code: E6
# ----------------------------------------------------------------------
# Apply the diamonds log-log model to first 500 rows and find the five
# largest absolute residuals using broom::augment().

# diamonds_500 <- diamonds |> slice_head(n = 500)
# mod_diamonds_500 <- lm(log(price) ~ log(carat), data = diamonds_500)
# broom::augment(mod_diamonds_500, data = diamonds_500) |>
#   mutate(abs_resid = abs(.resid)) |>
#   arrange(desc(abs_resid)) |>
#   slice_head(n = 5)


# ----------------------------------------------------------------------
# 8.8 Exercise starter code: E7
# ----------------------------------------------------------------------
# Replicate the many-models flights analysis using origin instead of carrier.

# origin_models <- flights |>
#   filter(!is.na(dep_delay)) |>
#   group_by(origin) |>
#   nest() |>
#   mutate(
#     mod = map(data, ~ lm(dep_delay ~ hour + month, data = .x)),
#     rsq = map_dbl(mod, ~ summary(.x)$r.squared),
#     rmse = map_dbl(mod, ~ sqrt(mean(residuals(.x)^2)))
#   ) |>
#   arrange(desc(rsq))
#
# origin_models |> select(origin, rsq, rmse)


# ======================================================================
# END OF SCRIPT
# ======================================================================
