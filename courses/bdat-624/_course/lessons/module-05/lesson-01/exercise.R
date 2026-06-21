# Required packages
library(survival)
library(survminer)
library(dplyr)
library(ggplot2)

# Dataset: lung cancer survival data from the survival package
# Variables: time (days), status (2=dead, 1=censored), sex (1=male, 2=female)
data(lung)
lung <- lung |> mutate(event = ifelse(status == 2, 1, 0))

cat("Dataset dimensions:", nrow(lung), "patients\n")
cat("Events observed:", sum(lung$event), "\n")
cat("Censored:", sum(1 - lung$event), "\n\n")

# ============================================================
# Task 1: Fit and plot the overall Kaplan-Meier curve
# ============================================================
# The Surv() object encodes (time, event_indicator).
# survfit() fits the KM estimator.

# TODO: Create a Surv object using time and event columns.
# Fit an overall (unstratified) KM curve with survfit(Surv(...) ~ 1, data=lung)
# and store it as km_overall.

km_overall <- survfit(Surv(time, event) ~ 1, data = lung)

# TODO: Print a summary of km_overall. Note the median survival time and
# its 95% confidence interval.
summary(km_overall, times = c(180, 365, 547, 730))

# TODO: Plot the overall KM curve using ggsurvplot() from survminer.
# Include confidence intervals (conf.int = TRUE), risk table (risk.table = TRUE),
# and label the median with surv.median.line = "hv".
ggsurvplot(
  km_overall,
  data       = lung,
  conf.int   = TRUE,
  risk.table = TRUE,
  surv.median.line = "hv",
  xlab       = "Time (days)",
  ylab       = "Survival probability S(t)",
  title      = "Overall Kaplan-Meier Curve: NCCTG Lung Cancer",
  ggtheme    = theme_minimal()
)

# ============================================================
# Task 2: Stratified KM curves by sex
# ============================================================
# Fit KM curves separately for males (sex=1) and females (sex=2).

# TODO: Fit a stratified KM model: survfit(Surv(...) ~ sex, data=lung)
# Store as km_sex.

km_sex <- survfit(Surv(time, event) ~ sex, data = lung)

# TODO: Print estimated survival probabilities at t = 365 days for each group.
cat("\nSurvival probabilities at 365 days (stratified by sex):\n")
print(summary(km_sex, times = 365)$surv)

# TODO: Plot the stratified KM curves using ggsurvplot().
# Add a legend with labels c("Male", "Female"), use distinct colours,
# include a risk table, and add p-value from log-rank test (pval = TRUE).
ggsurvplot(
  km_sex,
  data       = lung,
  conf.int   = TRUE,
  risk.table = TRUE,
  pval       = TRUE,
  legend.labs = c("Male", "Female"),
  palette     = c("#2980b9", "#e74c3c"),
  xlab        = "Time (days)",
  ylab        = "Survival probability S(t)",
  title       = "KM Curves by Sex: NCCTG Lung Cancer",
  ggtheme     = theme_minimal()
)

# ============================================================
# Task 3: Manual Greenwood variance at one time point
# ============================================================
# Greenwood's formula: Var(S_hat(t)) = S_hat(t)^2 * sum_{t_i <= t} d_i / (n_i*(n_i - d_i))

# Extract KM table details for males only (sex=1)
lung_male <- lung |> filter(sex == 1)
km_male   <- survfit(Surv(time, event) ~ 1, data = lung_male)

# TODO: Extract the KM table for males into a data frame.
# Columns needed: time, n.risk, n.event, surv.
km_male_df <- data.frame(
  t       = km_male$time,
  n_risk  = km_male$n.risk,
  n_event = km_male$n.event,
  surv    = km_male$surv
)

# Target time: 365 days
t_target <- 365

# TODO: Filter km_male_df to rows where t <= 365 and n_event > 0.
# Compute the Greenwood sum: sum(n_event / (n_risk * (n_risk - n_event)))
# over those rows. Then compute Var_hat = S_hat^2 * greenwood_sum.
# Print the KM estimate, Greenwood variance, and 95% CI at t=365.

km_at_365 <- km_male_df |> filter(t <= t_target)
s_hat_365 <- tail(km_at_365$surv, 1)

greenwood_sum <- sum(
  km_at_365$n_event / (km_at_365$n_risk * (km_at_365$n_risk - km_at_365$n_event)),
  na.rm = TRUE
)
var_hat <- s_hat_365^2 * greenwood_sum
se_hat  <- sqrt(var_hat)

cat(sprintf("\nGreenwood at t=365 (males):\n"))
cat(sprintf("  S_hat(365) = %.4f\n", s_hat_365))
cat(sprintf("  Greenwood variance = %.6f\n", var_hat))
cat(sprintf("  95%% CI: (%.4f, %.4f)\n",
            max(0, s_hat_365 - 1.96*se_hat),
            min(1, s_hat_365 + 1.96*se_hat)))

# TODO: Compare your manual 95% CI to what survminer reports.
# Hint: summary(km_male, times = 365)

# ============================================================
# Task 4: Log-rank test
# ============================================================
# The log-rank test checks H0: S_male(t) = S_female(t) for all t.

# TODO: Use survdiff(Surv(...) ~ sex, data=lung) to run the log-rank test.
# Store the result as lr_test. Print and interpret the chi-squared statistic
# and p-value. State whether you reject H0 at alpha=0.05.

lr_test <- survdiff(Surv(time, event) ~ sex, data = lung)
print(lr_test)

cat("\nLog-rank test interpretation:\n")
p_val <- 1 - pchisq(lr_test$chisq, df = 1)
cat(sprintf("  Chi-squared = %.4f, df = 1, p-value = %.4f\n", lr_test$chisq, p_val))
if (p_val < 0.05) {
  cat("  Decision: Reject H0. Survival differs significantly between males and females (alpha=0.05).\n")
} else {
  cat("  Decision: Fail to reject H0.\n")
}

# ============================================================
# Task 5: Cumulative hazard H(t) = -log(S(t))
# ============================================================
# Relationship: S(t) = exp(-H(t)), so H(t) = -log(S(t)).

# TODO: Compute the Nelson-Aalen cumulative hazard estimate for males:
#   H_hat(t) = -log(S_hat(t))  (log-transform of the KM estimate)
# Plot H_hat(t) vs time for males as a step function.
# Overlay the theoretical exponential H(t) = lambda*t for a fitted lambda
# (estimate lambda = total events / total person-time for males).

km_male_df <- km_male_df |>
  mutate(H_hat = -log(surv))

lambda_hat <- sum(lung_male$event) / sum(lung_male$time)
cat(sprintf("\nEstimated exponential hazard rate (males): lambda = %.6f/day\n", lambda_hat))

t_range <- seq(0, max(lung_male$time), length.out = 300)
exp_H_df <- data.frame(t = t_range, H = lambda_hat * t_range)

ggplot(km_male_df, aes(x = t, y = H_hat)) +
  geom_step(color = "#2980b9", linewidth = 1) +
  geom_line(data = exp_H_df, aes(x = t, y = H),
            color = "#e74c3c", linewidth = 1, linetype = "dashed") +
  labs(
    title    = "Cumulative Hazard H(t) = -log(S_hat(t)) for Males",
    subtitle = "Blue step = Nelson-Aalen; Red dashed = Exponential(lambda_hat)",
    x = "Time (days)", y = "H(t)"
  ) +
  theme_minimal()
