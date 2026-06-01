# Module 5, Lesson 2: Cox Proportional Hazards Model
# Exercise: Cox regression with the lung dataset
#
# Instructions:
#   Fill in every # TODO: section.
#   Run: npm run check -- bdat-624 module-05 lesson-02

library(survival)
library(ggplot2)

data(lung)
# lung columns used here:
#   time     : survival time in days
#   status   : 1 = censored, 2 = dead
#   sex      : 1 = male, 2 = female
#   age      : age in years
#   ph.karno : Karnofsky performance score rated by physician (0–100)

# ── Part 1: Fit the Cox model ─────────────────────────────────────────────────
# Fit a Cox proportional hazards model with three predictors:
#   sex, age, ph.karno
# Use the formula interface: coxph(Surv(...) ~ ..., data = lung)

# TODO: Fit the Cox model. Name it `cox_fit`.
cox_fit <- NULL  # TODO: replace NULL

# TODO: Print a summary of cox_fit using summary().
#       The output will show: coef (β̂), exp(coef) (HR), se(coef), z, p.

# ── Part 2: Extract and interpret hazard ratios ───────────────────────────────
# Extract HRs and 95% CIs from the model summary.
# summary(cox_fit)$conf.int gives a matrix with columns:
#   "exp(coef)", "exp(-coef)", "lower .95", "upper .95"

# TODO: Extract the HR table and store it as `hr_table`.
hr_table <- NULL  # TODO: replace NULL

# TODO: Print hr_table.

# TODO: Fill in the blanks in the interpretation comments below.
# HR for sex:
#   Female patients (sex=2) have a hazard _____ times that of male patients
#   (holding age and ph.karno constant). This represents a ____% (increase/decrease)
#   in hazard. Is this statistically significant (p < 0.05)?

# HR for age:
#   Each additional year of age is associated with a ____% (increase/decrease)
#   in the hazard. Is this statistically significant?

# HR for ph.karno:
#   Each 1-point improvement in Karnofsky score is associated with a ____%
#   (increase/decrease) in the hazard. Is this statistically significant?

# ── Part 3: Check the PH assumption ──────────────────────────────────────────
# cox.zph() tests whether Schoenfeld residuals are correlated with log(time).
# A significant p-value suggests the HR changes over time → PH violated.

# TODO: Run cox.zph() on cox_fit. Name the result `ph_test`.
ph_test <- NULL  # TODO: replace NULL

# TODO: Print ph_test. Examine the p-value for each covariate and the GLOBAL test.
#       Which (if any) covariates violate the PH assumption?

# TODO: Plot the Schoenfeld residuals using plot(ph_test).
#       R produces one plot per covariate showing the smoothed residuals over time.
#       A flat line (no trend) is consistent with PH.


# ── Part 4: Predicted survival curves ────────────────────────────────────────
# Use survfit() applied to a coxph object with a newdata argument to obtain
# predicted survival curves for specific covariate profiles.

# (a) Predicted curves for males vs females of average age and ph.karno.
# TODO: Compute mean_age and mean_karno from the lung dataset (remove NAs).
mean_age   <- NULL  # TODO: replace NULL
mean_karno <- NULL  # TODO: replace NULL

# TODO: Create a newdata data frame with two rows:
#       Row 1: sex=1 (male),   age=mean_age, ph.karno=mean_karno
#       Row 2: sex=2 (female), age=mean_age, ph.karno=mean_karno
newdata_sex <- NULL  # TODO: replace NULL

# TODO: Compute predicted survival using survfit(cox_fit, newdata=newdata_sex).
pred_sex <- NULL  # TODO: replace NULL

# TODO: Plot pred_sex with two curves (male = blue, female = red).
#       Add a legend, axis labels, and title
#       "Predicted Survival by Sex (Average Age and ph.karno)".


# (b) Predicted curves for high vs low Karnofsky score in males.
# TODO: Create a newdata data frame with two rows:
#       Row 1: sex=1, age=mean_age, ph.karno=75  (high)
#       Row 2: sex=1, age=mean_age, ph.karno=50  (low)
newdata_karno <- NULL  # TODO: replace NULL

# TODO: Compute predicted survival for these two profiles.
pred_karno <- NULL  # TODO: replace NULL

# TODO: Plot pred_karno with two curves.
#       Add a legend labelling "ph.karno=75" and "ph.karno=50".


# ── Exploration (optional, ungraded) ─────────────────────────────────────────
# Add an interaction term sex:ph.karno to the Cox model.
# Does the effect of ph.karno differ by sex?
# Compare model fit using AIC: AIC(cox_fit) vs AIC of the model with interaction.
