# Module 5, Lesson 1: Survival Functions and Kaplan-Meier Estimation
# SOLUTION

library(survival)
library(ggplot2)

data(lung)

# ── Part 1: Surv object ───────────────────────────────────────────────────────
surv_obj <- Surv(lung$time, lung$status == 2)
cat("First 10 Surv values:\n")
print(surv_obj[1:10])
# Output: values followed by + are censored (status = 1 in lung, i.e. not dead)

# ── Part 2: Overall KM curve ──────────────────────────────────────────────────
fit_overall <- survfit(Surv(time, status == 2) ~ 1, data = lung)
print(summary(fit_overall)$table)

# Base R plot with confidence bands
plot(
  fit_overall,
  conf.int  = TRUE,
  xlab      = "Days",
  ylab      = "Survival probability",
  main      = "Overall KM Curve — NCCTG Lung Cancer",
  col       = "steelblue",
  lwd       = 2,
  mark.time = TRUE   # tick marks for censored observations
)

# ── Part 3: KM curves stratified by sex ──────────────────────────────────────
lung$sex_label <- factor(lung$sex, levels = c(1, 2), labels = c("Male", "Female"))
fit_sex <- survfit(Surv(time, status == 2) ~ sex_label, data = lung)
print(summary(fit_sex)$table)

# Extract medians
cat("\nMedian survival (days):\n")
print(surv_median(fit_sex))   # from survminer; fall back to summary() if unavailable

# Base R stratified plot
plot(
  fit_sex,
  conf.int  = FALSE,
  col       = c("steelblue", "tomato"),
  lwd       = 2,
  lty       = 1,
  xlab      = "Days",
  ylab      = "Survival probability",
  main      = "KM Curves by Sex — NCCTG Lung Cancer",
  mark.time = TRUE
)
legend(
  "topright",
  legend = c("Male", "Female"),
  col    = c("steelblue", "tomato"),
  lwd    = 2,
  bty    = "n"
)

# ── Part 4: Log-rank test ─────────────────────────────────────────────────────
lr_test <- survdiff(Surv(time, status == 2) ~ sex_label, data = lung)
print(lr_test)

p_value <- 1 - pchisq(lr_test$chisq, df = length(lr_test$n) - 1)
cat("\nLog-rank p-value:", round(p_value, 4), "\n")

# ── Part 5: Report ────────────────────────────────────────────────────────────
km_summary    <- summary(fit_sex)$table
median_male   <- km_summary["sex_label=Male",   "median"]
median_female <- km_summary["sex_label=Female", "median"]

cat("\nMedian survival (male):  ", median_male,   "days\n")
cat("Median survival (female):", median_female, "days\n")

# Interpretation:
# The log-rank test yields a p-value < 0.05, providing statistically significant
# evidence that female patients in the NCCTG lung cancer trial have longer
# survival than male patients (median ~426 days vs ~270 days for males).

# ── Exploration: stratify by ph.ecog ─────────────────────────────────────────
fit_ecog <- survfit(
  Surv(time, status == 2) ~ ph.ecog,
  data = lung[!is.na(lung$ph.ecog), ]
)
plot(
  fit_ecog,
  col  = 1:4,
  lwd  = 2,
  xlab = "Days",
  ylab = "Survival probability",
  main = "KM Curves by ECOG Performance Status"
)
legend(
  "topright",
  legend = paste("ECOG", 0:3),
  col    = 1:4,
  lwd    = 2,
  bty    = "n"
)
# As expected: ECOG 0 (fully active) has the best survival;
# ECOG 3 (limited self-care) has the worst.
