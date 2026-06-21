# SOLUTION: Module 05 Lesson 01 — Survival Functions and Kaplan-Meier Estimation
library(survival)
library(survminer)
library(dplyr)
library(ggplot2)

data(lung)
lung <- lung |> mutate(event = ifelse(status == 2, 1, 0))

cat("Dataset:", nrow(lung), "patients;", sum(lung$event), "events;",
    sum(1 - lung$event), "censored\n\n")

# ============================================================
# Task 1: Overall KM curve
# ============================================================
km_overall <- survfit(Surv(time, event) ~ 1, data = lung)

cat("Summary at key time points:\n")
print(summary(km_overall, times = c(180, 365, 547, 730)))

p1 <- ggsurvplot(
  km_overall,
  data             = lung,
  conf.int         = TRUE,
  risk.table       = TRUE,
  surv.median.line = "hv",
  xlab             = "Time (days)",
  ylab             = "Survival probability S(t)",
  title            = "Overall KM Curve: NCCTG Lung Cancer",
  ggtheme          = theme_minimal(base_size = 12)
)
print(p1)

# ============================================================
# Task 2: Stratified KM by sex
# ============================================================
km_sex <- survfit(Surv(time, event) ~ sex, data = lung)

cat("\nSurvival at 365 days (males, females):\n")
s365 <- summary(km_sex, times = 365)
print(data.frame(sex = c("Male", "Female"), surv_365 = round(s365$surv, 3)))

p2 <- ggsurvplot(
  km_sex,
  data        = lung,
  conf.int    = TRUE,
  risk.table  = TRUE,
  pval        = TRUE,
  legend.labs = c("Male", "Female"),
  palette     = c("#2980b9", "#e74c3c"),
  xlab        = "Time (days)",
  ylab        = "Survival probability S(t)",
  title       = "KM Curves by Sex: NCCTG Lung Cancer",
  ggtheme     = theme_minimal(base_size = 12)
)
print(p2)

# ============================================================
# Task 3: Greenwood variance — manual calculation
# ============================================================
lung_male <- lung |> filter(sex == 1)
km_male   <- survfit(Surv(time, event) ~ 1, data = lung_male)

km_male_df <- data.frame(
  t       = km_male$time,
  n_risk  = km_male$n.risk,
  n_event = km_male$n.event,
  surv    = km_male$surv
)

t_target  <- 365
rows_365  <- km_male_df |> filter(t <= t_target, n_event > 0)
s_hat_365 <- tail(km_male_df |> filter(t <= t_target) |> pull(surv), 1)

greenwood_sum <- sum(rows_365$n_event /
                     (rows_365$n_risk * (rows_365$n_risk - rows_365$n_event)),
                     na.rm = TRUE)
var_hat <- s_hat_365^2 * greenwood_sum
se_hat  <- sqrt(var_hat)

cat(sprintf("\nGreenwood at t=365 (males):\n"))
cat(sprintf("  S_hat(365)         = %.4f\n",   s_hat_365))
cat(sprintf("  Greenwood variance = %.6f\n",   var_hat))
cat(sprintf("  SE                 = %.4f\n",   se_hat))
cat(sprintf("  95%% CI manual: (%.4f, %.4f)\n",
            max(0, s_hat_365 - 1.96*se_hat),
            min(1, s_hat_365 + 1.96*se_hat)))

cat("\nsummary(km_male, times=365) for cross-check:\n")
print(summary(km_male, times = 365)[c("time","surv","lower","upper")])

# ============================================================
# Task 4: Log-rank test
# ============================================================
lr_test <- survdiff(Surv(time, event) ~ sex, data = lung)
print(lr_test)

p_val <- 1 - pchisq(lr_test$chisq, df = 1)
cat(sprintf("\nLog-rank: chi-sq = %.4f, p = %.4f\n", lr_test$chisq, p_val))
cat("Conclusion: Female patients have significantly better survival than males (p < 0.05).\n")

# ============================================================
# Task 5: Cumulative hazard H(t) = -log(S_hat(t))
# ============================================================
km_male_df <- km_male_df |> mutate(H_hat = -log(surv))

lambda_hat <- sum(lung_male$event) / sum(lung_male$time)
cat(sprintf("\nExponential lambda estimate (males): %.6f/day\n", lambda_hat))

t_range  <- seq(0, max(lung_male$time), length.out = 300)
exp_H_df <- data.frame(t = t_range, H = lambda_hat * t_range)

p5 <- ggplot(km_male_df, aes(x = t, y = H_hat)) +
  geom_step(color = "#2980b9", linewidth = 1) +
  geom_line(data = exp_H_df, aes(x = t, y = H),
            color = "#e74c3c", linewidth = 1, linetype = "dashed") +
  labs(
    title    = "Cumulative Hazard for Males: Nelson-Aalen vs Exponential",
    subtitle = "Blue = -log(KM); Red dashed = lambda_hat * t (exponential)",
    x = "Time (days)", y = "H(t) = -log S(t)"
  ) +
  theme_minimal(base_size = 12)
print(p5)
# Interpretation: If the step function is approximately linear, the exponential
# model is plausible. Upward curvature suggests increasing hazard (Weibull with
# shape > 1); downward curvature suggests decreasing hazard.
