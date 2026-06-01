# Module 5, Lesson 2: Cox Proportional Hazards Model
# SOLUTION

library(survival)
library(ggplot2)

data(lung)

# ── Part 1: Fit the Cox model ─────────────────────────────────────────────────
cox_fit <- coxph(
  Surv(time, status == 2) ~ sex + age + ph.karno,
  data = lung
)
print(summary(cox_fit))

# ── Part 2: Extract and interpret hazard ratios ───────────────────────────────
hr_table <- summary(cox_fit)$conf.int
colnames(hr_table) <- c("HR", "1/HR", "95% CI lower", "95% CI upper")
print(round(hr_table, 4))

# Interpretation:
# sex: HR ≈ 0.597 → female patients have a hazard 0.60× that of males
#      (a ~40% reduction in hazard), adjusting for age and ph.karno.
#      p ≈ 0.002: statistically significant.
#
# age: HR ≈ 1.017 → each additional year of age increases the hazard by ~1.7%.
#      p ≈ 0.066: marginal (not significant at α=0.05 in this dataset).
#
# ph.karno: HR ≈ 0.980 → each 1-point improvement in Karnofsky score decreases
#           the hazard by ~2%.  p < 0.001: strongly significant.
#           A 10-point improvement ≈ 0.980^10 ≈ 18% reduction in hazard.

# ── Part 3: Check the PH assumption ──────────────────────────────────────────
ph_test <- cox.zph(cox_fit)
print(ph_test)
# If p > 0.05 for each covariate: no strong evidence of PH violation.

par(mfrow = c(2, 2))
plot(ph_test)
par(mfrow = c(1, 1))
# A flat smoothed line = consistent with PH.
# An upward or downward trend = PH violation for that covariate.

# ── Part 4: Predicted survival curves ────────────────────────────────────────
mean_age   <- mean(lung$age,      na.rm = TRUE)
mean_karno <- mean(lung$ph.karno, na.rm = TRUE)

# (a) Male vs female at average age and ph.karno
newdata_sex <- data.frame(
  sex      = c(1, 2),
  age      = c(mean_age, mean_age),
  ph.karno = c(mean_karno, mean_karno)
)
pred_sex <- survfit(cox_fit, newdata = newdata_sex)

plot(
  pred_sex,
  col   = c("steelblue", "tomato"),
  lwd   = 2,
  xlab  = "Days",
  ylab  = "Predicted survival probability",
  main  = "Predicted Survival by Sex (Average Age and ph.karno)"
)
legend(
  "topright",
  legend = c("Male", "Female"),
  col    = c("steelblue", "tomato"),
  lwd    = 2,
  bty    = "n"
)

# (b) High vs low Karnofsky score in males
newdata_karno <- data.frame(
  sex      = c(1, 1),
  age      = c(mean_age, mean_age),
  ph.karno = c(75, 50)
)
pred_karno <- survfit(cox_fit, newdata = newdata_karno)

plot(
  pred_karno,
  col   = c("darkgreen", "orange"),
  lwd   = 2,
  xlab  = "Days",
  ylab  = "Predicted survival probability",
  main  = "Predicted Survival by Karnofsky Score (Males)"
)
legend(
  "topright",
  legend = c("ph.karno = 75", "ph.karno = 50"),
  col    = c("darkgreen", "orange"),
  lwd    = 2,
  bty    = "n"
)

# ── Exploration: interaction model ───────────────────────────────────────────
cox_int <- coxph(
  Surv(time, status == 2) ~ sex + age + ph.karno + sex:ph.karno,
  data = lung
)
cat("\nAIC without interaction:", AIC(cox_fit), "\n")
cat("AIC with interaction:    ", AIC(cox_int),  "\n")
# If AIC decreases with the interaction, the sex×ph.karno interaction improves fit.
