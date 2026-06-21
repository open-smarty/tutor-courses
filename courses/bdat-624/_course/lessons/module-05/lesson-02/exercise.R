# Required packages
library(survival)
library(survminer)
library(dplyr)
library(ggplot2)

# Dataset: NCCTG lung cancer survival data
# Variables: time (days), status (2=dead, 1=censored), sex (1=M, 2=F),
#            age, ph.ecog (performance status 0-4), ph.karno, meal.cal, wt.loss
data(lung)
lung <- lung |> mutate(event = ifelse(status == 2, 1, 0))

cat("Lung dataset: n =", nrow(lung), "| events =", sum(lung$event), "\n\n")

# ============================================================
# Task 1: Fit a Cox PH model with sex, age, and ph.ecog
# ============================================================
# Cox model syntax: coxph(Surv(time, event) ~ X1 + X2 + ..., data=...)
# ph.ecog = 0 (asymptomatic) to 4 (bedbound); use only 0-3 (exclude 4 for
# sample size reasons — or just leave it in).

# TODO: Fit the Cox PH model. Store as cox_fit.
# Remove rows with missing ph.ecog before fitting.
lung_cc <- lung |> filter(!is.na(ph.ecog))

cox_fit <- coxph(Surv(time, event) ~ sex + age + ph.ecog, data = lung_cc)

# TODO: Print the model summary and identify:
#   (a) the log-hazard ratio (coef) and hazard ratio (exp(coef)) for sex
#   (b) the 95% CI for each hazard ratio
#   (c) which covariates are significant at alpha=0.05
summary(cox_fit)

# TODO: Print the concordance statistic (C-index) from the summary output.
# The C-index ranges from 0.5 (no discrimination) to 1.0 (perfect).
cat("\nConcordance (C-index):", summary(cox_fit)$concordance[1], "\n\n")

# ============================================================
# Task 2: Hazard ratio forest plot
# ============================================================
# ggforest() from survminer creates a publication-quality forest plot.

# TODO: Create a forest plot of the hazard ratios with 95% CIs.
# Use ggforest(cox_fit, data = lung_cc, main = "Hazard Ratios: Cox PH Model")
ggforest(cox_fit, data = lung_cc,
         main = "Hazard Ratios: Cox PH Model (Lung Cancer Data)")

# TODO: Interpret the forest plot:
#   - Which covariate has the largest effect on survival?
#   - Is age a significant predictor after adjusting for sex and performance status?

# ============================================================
# Task 3: Check proportional hazards — Schoenfeld residuals
# ============================================================
# cox.zph() tests whether the scaled Schoenfeld residuals are correlated with
# time. A significant p-value (< 0.05) indicates non-proportional hazards.

# TODO: Run cox.zph(cox_fit) and print the result.
# Then plot the Schoenfeld residuals vs time with ggcoxzph().
zph_test <- cox.zph(cox_fit)
print(zph_test)

# TODO: Plot Schoenfeld residuals for all covariates.
# A smooth trend line (red) near zero at all times supports PH.
ggcoxzph(zph_test)

# ============================================================
# Task 4: Check proportional hazards — log-log plot
# ============================================================
# Under PH, log(-log(S_k(t))) vs log(t) should yield parallel curves for
# different groups. We check sex, since it is a discrete covariate.

# TODO: Fit a stratified KM model for sex.
# Plot log(-log(KM)) vs log(time) using ggsurvplot with fun="cloglog".
km_sex <- survfit(Surv(time, event) ~ sex, data = lung_cc)

ggsurvplot(
  km_sex,
  data   = lung_cc,
  fun    = "cloglog",
  xlab   = "log(Time)",
  ylab   = "log(-log(S(t)))",
  title  = "Log-Log Plot: Check Proportional Hazards by Sex",
  legend.labs = c("Male", "Female"),
  palette = c("#2980b9", "#e74c3c"),
  ggtheme = theme_minimal()
)
# TODO: Describe whether the curves are approximately parallel.
# Parallel curves support the PH assumption for sex.

# ============================================================
# Task 5: Likelihood ratio test — compare nested models
# ============================================================
# Compare two nested Cox models:
#   Model A (reduced): sex only
#   Model B (full):    sex + age + ph.ecog
# LR statistic = 2 * (loglik_full - loglik_reduced) ~ chi^2(df = 2)

# TODO: Fit model A (sex only). Extract log-partial-likelihood from $loglik[2].
cox_sex <- coxph(Surv(time, event) ~ sex, data = lung_cc)
loglik_A <- cox_sex$loglik[2]
loglik_B <- cox_fit$loglik[2]

LR_stat <- 2 * (loglik_B - loglik_A)
df_diff  <- length(coef(cox_fit)) - length(coef(cox_sex))
p_LR     <- 1 - pchisq(LR_stat, df = df_diff)

cat(sprintf("Likelihood ratio test (Model B vs A):\n"))
cat(sprintf("  LR statistic = %.4f, df = %d, p-value = %.4f\n",
            LR_stat, df_diff, p_LR))
cat("Conclusion: Does adding age and ph.ecog significantly improve the model?\n\n")

# TODO: Use anova(cox_sex, cox_fit) as a cross-check.
print(anova(cox_sex, cox_fit))

# ============================================================
# Task 6: Survival prediction with basehaz()
# ============================================================
# basehaz() returns the Breslow estimate of H0(t) — the cumulative baseline hazard.
# S(t|X) = exp(-H0(t) * exp(beta^T X))

# TODO: Extract the baseline cumulative hazard with basehaz(cox_fit).
# For a 60-year-old male (sex=1) with ph.ecog=1, compute the predicted
# survival curve S(t|X) at the times in basehaz and plot it.

bh        <- basehaz(cox_fit, centered = FALSE)
X_new     <- c(sex = 1, age = 60, ph.ecog = 1)
lp_new    <- sum(coef(cox_fit) * X_new)    # linear predictor beta^T X
S_pred_df <- data.frame(
  t      = bh$time,
  S_pred = exp(-bh$hazard * exp(lp_new))
)

ggplot(S_pred_df, aes(x = t, y = S_pred)) +
  geom_step(color = "#27ae60", linewidth = 1) +
  ylim(0, 1) +
  labs(
    title    = "Predicted Survival: 60-year-old Male, ECOG=1",
    subtitle = "S(t|X) = exp(-H0(t) * exp(beta^T X)); Breslow baseline hazard",
    x = "Time (days)", y = "Estimated S(t)"
  ) +
  theme_minimal()
