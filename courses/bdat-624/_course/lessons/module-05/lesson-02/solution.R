# SOLUTION: Module 05 Lesson 02 — Cox Proportional Hazards Model
library(survival)
library(survminer)
library(dplyr)
library(ggplot2)

data(lung)
lung <- lung |> mutate(event = ifelse(status == 2, 1, 0))
lung_cc <- lung |> filter(!is.na(ph.ecog))

cat("Complete cases: n =", nrow(lung_cc), "| events =", sum(lung_cc$event), "\n\n")

# ============================================================
# Task 1: Cox PH model — sex, age, ph.ecog
# ============================================================
cox_fit <- coxph(Surv(time, event) ~ sex + age + ph.ecog, data = lung_cc)
print(summary(cox_fit))

# Interpretation of key results:
# sex:     coef ~ -0.53, exp(coef) ~ 0.59 => females have ~41% lower hazard than males
# age:     coef ~  0.017, HR ~ 1.02 per year; modest effect, may not be significant
# ph.ecog: coef ~  0.48, HR ~ 1.62 per unit; worse performance status => 62% higher hazard
cat("\nConcordance (C-index):", round(summary(cox_fit)$concordance[1], 3), "\n")

# ============================================================
# Task 2: Forest plot of hazard ratios
# ============================================================
p_forest <- ggforest(cox_fit, data = lung_cc,
                     main = "Hazard Ratios: Cox PH Model (Lung Cancer Data)")
print(p_forest)
# ph.ecog has the strongest effect (HR ~1.6); sex is significant; age is borderline.

# ============================================================
# Task 3: Schoenfeld residuals — cox.zph()
# ============================================================
zph_test <- cox.zph(cox_fit)
cat("\nSchoenfeld residual test (PH assumption):\n")
print(zph_test)
# Interpretation: if p > 0.05 for each covariate and globally, PH holds.
# In lung data, sex typically satisfies PH; ph.ecog may show mild time variation.

p_zph <- ggcoxzph(zph_test)
print(p_zph)

# ============================================================
# Task 4: Log-log plot
# ============================================================
km_sex <- survfit(Surv(time, event) ~ sex, data = lung_cc)
p_loglog <- ggsurvplot(
  km_sex,
  data        = lung_cc,
  fun         = "cloglog",
  xlab        = "log(Time)",
  ylab        = "log(-log(S(t)))",
  title       = "Log-Log Plot: Proportional Hazards Check by Sex",
  legend.labs = c("Male", "Female"),
  palette     = c("#2980b9", "#e74c3c"),
  ggtheme     = theme_minimal(base_size = 12)
)
print(p_loglog)
# Approximately parallel curves => PH assumption holds for sex.
# If curves cross, stratified Cox or time-varying coefficient would be needed.

# ============================================================
# Task 5: Likelihood ratio test — nested model comparison
# ============================================================
cox_sex <- coxph(Surv(time, event) ~ sex, data = lung_cc)

loglik_A <- cox_sex$loglik[2]   # log PL for reduced model (sex only)
loglik_B <- cox_fit$loglik[2]   # log PL for full model

LR_stat <- 2 * (loglik_B - loglik_A)
df_diff  <- length(coef(cox_fit)) - length(coef(cox_sex))
p_LR     <- 1 - pchisq(LR_stat, df = df_diff)

cat(sprintf("\nLikelihood Ratio Test (full vs. sex-only model):\n"))
cat(sprintf("  LR statistic = %.4f, df = %d, p-value = %.4f\n", LR_stat, df_diff, p_LR))
cat("Conclusion: Adding age and ph.ecog significantly improves the model (p < 0.05).\n")

cat("\nanova() cross-check:\n")
print(anova(cox_sex, cox_fit))

# ============================================================
# Task 6: Survival prediction via Breslow baseline hazard
# ============================================================
bh     <- basehaz(cox_fit, centered = FALSE)
X_new  <- c(sex = 1, age = 60, ph.ecog = 1)
lp_new <- sum(coef(cox_fit) * X_new)

S_pred_df <- data.frame(
  t      = bh$time,
  S_pred = exp(-bh$hazard * exp(lp_new))
)

cat(sprintf("\nLinear predictor for 60-yr male ECOG=1: %.4f\n", lp_new))
cat(sprintf("Estimated 1-year survival: %.3f\n",
            approx(S_pred_df$t, S_pred_df$S_pred, xout = 365)$y))

p_pred <- ggplot(S_pred_df, aes(x = t, y = S_pred)) +
  geom_step(color = "#27ae60", linewidth = 1.2) +
  ylim(0, 1) +
  labs(
    title    = "Predicted Survival: 60-year-old Male, ECOG=1",
    subtitle = "S(t|X) = exp(-H0(t) * exp(beta^T X)); Breslow baseline hazard",
    x = "Time (days)", y = "Estimated S(t)"
  ) +
  theme_minimal(base_size = 12)
print(p_pred)
