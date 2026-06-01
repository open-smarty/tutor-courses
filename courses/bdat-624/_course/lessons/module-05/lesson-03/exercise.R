# Module 5, Lesson 3: Parametric Survival Models and AFT
# Exercise: Parametric models with the lung dataset
#
# Instructions:
#   Fill in every # TODO: section.
#   Run: npm run check -- bdat-624 module-05 lesson-03

library(survival)
library(flexsurv)   # install.packages("flexsurv") if needed
library(ggplot2)

data(lung)
# lung columns used here:
#   time   : survival time in days
#   status : 1 = censored, 2 = dead
#   sex    : 1 = male, 2 = female

# ── Part 1: Fit four parametric models ───────────────────────────────────────
# Use flexsurvreg() with dist = "exp", "weibull", "lnorm", "llogis"
# Fit sex as the only predictor in each model.
# Formula: Surv(time, status == 2) ~ sex

# TODO: Fit the exponential model. Name it fit_exp.
fit_exp <- NULL  # TODO: replace NULL

# TODO: Fit the Weibull model. Name it fit_wb.
fit_wb  <- NULL  # TODO: replace NULL

# TODO: Fit the log-normal model. Name it fit_ln.
fit_ln  <- NULL  # TODO: replace NULL

# TODO: Fit the log-logistic model. Name it fit_ll.
fit_ll  <- NULL  # TODO: replace NULL

# Print each model summary (optional — for exploration).
# print(fit_exp)
# print(fit_wb)

# ── Part 2: Compare AIC and BIC ───────────────────────────────────────────────
# Extract AIC and BIC from each model and build a comparison table.
# AIC and BIC are stored in fit$AIC and fit$logLik (or use AIC(), BIC()).

# TODO: Create a data frame named `model_comparison` with columns:
#   Model: names of the four distributions
#   AIC:   AIC value for each model
#   BIC:   BIC value for each model
model_comparison <- NULL  # TODO: replace NULL

# TODO: Print model_comparison, sorted by AIC (ascending).
#       Which distribution fits best?

# TODO: Record the name of the best distribution.
best_dist <- NULL  # TODO: e.g., "weibull", "lnorm", "llogis", "exp"
cat("Best-fitting distribution:", best_dist, "\n")

# ── Part 3: Interpret the time ratio for sex ─────────────────────────────────
# From the best-fitting model, extract the AFT coefficient for sex.
# The time ratio (TR) is exp(coefficient).

# TODO: Print the summary of the best-fitting model.

# TODO: Extract the time ratio for sex and its 95% CI.
#       In flexsurv, coefficients are on the log scale; exp() gives the TR.
time_ratio <- NULL  # TODO: replace NULL
cat("Time ratio for sex (female vs male):", round(time_ratio, 3), "\n")

# TODO: Write a one-sentence interpretation of the time ratio as a comment.
# Example skeleton: "Female patients survive ____× longer than male patients
# on average, under the [distribution] AFT model."

# ── Part 4: Overlay predicted curves and KM curves ───────────────────────────
# Visually assess how well the best parametric model fits compared to the KM.

# TODO: Fit the KM curve stratified by sex (as in Lesson 1).
fit_km_sex <- NULL  # TODO: replace NULL

# TODO: Plot the KM curves for males and females (base R or ggplot2).
#       Then overlay the parametric model's predicted survival curves.
#
# Hint: use plot(fit_best) or lines(fit_best) for flexsurv objects.
# flexsurv's plot() method automatically overlays the parametric fit on a KM.
#
# The simplest approach:
#   plot(fit_best)
# which shows the parametric curve and the KM curve on the same graph.
# For a stratified version:
#   plot(fit_best, ci = FALSE, col = c("blue", "red"))

# TODO: Comment on whether the parametric model appears to fit well.
#       Does the parametric curve track the KM curve closely?


# ── Part 5: Likelihood ratio test — exponential vs Weibull ───────────────────
# The exponential model is nested within the Weibull (exponential = Weibull with k=1).
# H₀: k = 1 (exponential is sufficient)
# H₁: k ≠ 1 (Weibull fits significantly better)
# Test statistic: Λ = 2 * (logL_weibull - logL_exp) ~ χ²(1)

# TODO: Extract log-likelihoods from fit_exp and fit_wb.
logL_exp <- NULL  # TODO: replace NULL
logL_wb  <- NULL  # TODO: replace NULL

# TODO: Compute the LRT statistic.
lrt_stat <- NULL  # TODO: replace NULL

# TODO: Compute the p-value (degrees of freedom = 1).
lrt_pvalue <- NULL  # TODO: replace NULL

cat("\nLRT: Weibull vs Exponential\n")
cat("  Statistic:", round(lrt_stat, 3), "\n")
cat("  p-value:  ", round(lrt_pvalue, 4), "\n")

# TODO: Interpret the LRT result as a comment.
# Does the Weibull model fit significantly better than the exponential?

# ── Exploration (optional, ungraded) ─────────────────────────────────────────
# Add age and ph.karno to the best-fitting model.
# Does model fit (AIC) improve substantially?
# Report the time ratio for a 10-point increase in ph.karno.
