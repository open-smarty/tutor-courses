# Module 5, Lesson 1: Survival Functions and Kaplan-Meier Estimation
# Exercise: Kaplan-Meier curves with the lung dataset
#
# Instructions:
#   Fill in every # TODO: section.
#   Run: npm run check -- bdat-624 module-05 lesson-01

library(survival)
library(ggplot2)
library(ggsurvfit)   # optional but recommended for ggplot2-based KM plots

# ── Data ─────────────────────────────────────────────────────────────────────
data(lung)
# lung columns used here:
#   time    : survival time in days
#   status  : 1 = censored, 2 = dead
#   sex     : 1 = male, 2 = female

# ── Part 1: Create a Surv object ──────────────────────────────────────────────
# A Surv object encodes both the observed time and the event indicator.
# status == 2 means the event (death) was observed.

# TODO: Create a Surv object named `surv_obj` using lung$time and lung$status.
#       The event indicator should be 1 when status == 2, 0 otherwise.
surv_obj <- NULL  # TODO: replace NULL

# ── Part 2: Overall KM curve ──────────────────────────────────────────────────
# Fit a KM curve for all patients combined (no stratification).
# The formula ~ 1 means no grouping variable.

# TODO: Fit the overall KM model using survfit().
fit_overall <- NULL  # TODO: replace NULL

# TODO: Print a summary of fit_overall.
#       Check: what is the median survival time (in days)?

# TODO: Plot the KM curve with 95% confidence bands.
#       Label the x-axis "Days" and y-axis "Survival probability".
#       Add a title "Overall KM Curve — NCCTG Lung Cancer".
#       (Hint: use plot(fit_overall, conf.int = TRUE, ...) or ggsurvfit())


# ── Part 3: KM curves stratified by sex ──────────────────────────────────────
# Fit separate KM curves for males (sex=1) and females (sex=2).

# TODO: Fit a stratified KM model using survfit() with sex as a factor.
fit_sex <- NULL  # TODO: replace NULL

# TODO: Print a summary of fit_sex.
#       Check: what are the median survival times for each sex?

# TODO: Plot both KM curves on the same graph.
#       Use different colours for males and females.
#       Add a legend, x-axis label "Days", y-axis label "Survival probability".
#       Add a title "KM Curves by Sex — NCCTG Lung Cancer".


# ── Part 4: Log-rank test ─────────────────────────────────────────────────────
# Test H₀: S_male(t) = S_female(t) for all t.

# TODO: Perform a log-rank test using survdiff() comparing survival by sex.
lr_test <- NULL  # TODO: replace NULL

# TODO: Print lr_test.
#       Extract and print the p-value (it is stored in lr_test$pvalue).
p_value <- NULL  # TODO: replace NULL
cat("Log-rank p-value:", p_value, "\n")

# ── Part 5: Interpretation ────────────────────────────────────────────────────
# TODO: Fill in the values below based on your output.
median_male   <- NULL  # median survival in days for males
median_female <- NULL  # median survival in days for females

cat("Median survival (male):  ", median_male,   "days\n")
cat("Median survival (female):", median_female, "days\n")

# TODO: Write a one-sentence interpretation of the log-rank test result as a
#       comment. Does the evidence support a difference in survival between
#       males and females?

# ── Exploration (optional, ungraded) ─────────────────────────────────────────
# Fit KM curves stratified by ph.ecog (performance status 0–3).
# Do patients with better performance status (lower ph.ecog) survive longer?
