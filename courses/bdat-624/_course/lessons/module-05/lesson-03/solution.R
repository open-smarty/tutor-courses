# Module 5, Lesson 3: Parametric Survival Models and AFT
# SOLUTION

library(survival)
library(flexsurv)
library(ggplot2)

data(lung)

# ── Part 1: Fit four parametric models ───────────────────────────────────────
fit_exp <- flexsurvreg(Surv(time, status == 2) ~ sex, data = lung, dist = "exp")
fit_wb  <- flexsurvreg(Surv(time, status == 2) ~ sex, data = lung, dist = "weibull")
fit_ln  <- flexsurvreg(Surv(time, status == 2) ~ sex, data = lung, dist = "lnorm")
fit_ll  <- flexsurvreg(Surv(time, status == 2) ~ sex, data = lung, dist = "llogis")

cat("Exponential:\n"); print(fit_exp)
cat("\nWeibull:\n");    print(fit_wb)
cat("\nLog-normal:\n"); print(fit_ln)
cat("\nLog-logistic:\n"); print(fit_ll)

# ── Part 2: Compare AIC and BIC ───────────────────────────────────────────────
# flexsurv stores log-likelihood in fit$logLik; AIC in fit$AIC
get_bic <- function(fit) {
  n <- nrow(fit$data$Y)
  k <- length(fit$coefficients)
  -2 * fit$logLik + k * log(n)
}

model_comparison <- data.frame(
  Model = c("Exponential", "Weibull", "Log-normal", "Log-logistic"),
  AIC   = c(fit_exp$AIC, fit_wb$AIC, fit_ln$AIC, fit_ll$AIC),
  BIC   = c(get_bic(fit_exp), get_bic(fit_wb), get_bic(fit_ln), get_bic(fit_ll))
)
model_comparison <- model_comparison[order(model_comparison$AIC), ]
cat("\nModel comparison (sorted by AIC):\n")
print(model_comparison)

# Typically: log-normal or Weibull has the lowest AIC for the lung dataset.
best_dist <- model_comparison$Model[1]
cat("\nBest-fitting distribution:", best_dist, "\n")

# ── Part 3: Interpret the time ratio for sex ─────────────────────────────────
# Use whichever model had the lowest AIC (here we show Weibull as a representative).
# The coefficient 'sex' in the flexsurv AFT parameterisation is on the log scale.
best_fit <- fit_wb  # swap for fit_ln if log-normal wins

cat("\nSummary of best-fitting model:\n")
print(best_fit)

# Extract the AFT coefficient for sex and compute the time ratio.
# In flexsurv, coefficients are accessible via best_fit$coefficients.
# For Weibull: parameter names are "shape", "scale", "sex"
#              but for flexsurvreg the location coefficients include "sex".
coef_sex   <- best_fit$coefficients["sex"]
time_ratio <- exp(coef_sex)
ci         <- exp(best_fit$res["sex", c("L95%", "U95%")])

cat("\nAFT coefficient for sex:", round(coef_sex, 4), "\n")
cat("Time ratio (female vs male): ", round(time_ratio, 3), "\n")
cat("95% CI: (", round(ci[1], 3), ",", round(ci[2], 3), ")\n")

# Interpretation:
# Under the Weibull AFT model, female patients (sex=2) have a time ratio of
# approximately 1.55. This means female patients survive about 55% longer than
# male patients on average, after accounting for the parametric time structure.

# ── Part 4: Overlay predicted and KM curves ───────────────────────────────────
# flexsurv's plot() automatically overlays parametric curves on KM curves.
plot(
  best_fit,
  main = paste("Parametric (", best_dist, ") vs KM Curves by Sex"),
  xlab = "Days",
  ylab = "Survival probability",
  col  = c("steelblue", "tomato"),
  ci   = FALSE,
  lwd  = 2
)
legend(
  "topright",
  legend = c("Male (parametric)", "Female (parametric)", "KM (dashed)"),
  col    = c("steelblue", "tomato", "grey40"),
  lwd    = 2,
  lty    = c(1, 1, 2),
  bty    = "n"
)
# If the parametric curve tracks the KM step function closely, the distribution
# assumption is a reasonable fit. Departures suggest a misspecified distribution.

# ── Part 5: LRT — exponential vs Weibull ─────────────────────────────────────
logL_exp <- fit_exp$logLik
logL_wb  <- fit_wb$logLik

lrt_stat   <- 2 * (logL_wb - logL_exp)
lrt_pvalue <- pchisq(lrt_stat, df = 1, lower.tail = FALSE)

cat("\nLRT: Weibull vs Exponential\n")
cat("  logL(Exponential):", round(logL_exp, 3), "\n")
cat("  logL(Weibull):    ", round(logL_wb, 3), "\n")
cat("  LRT statistic:    ", round(lrt_stat, 3), "\n")
cat("  p-value (df=1):   ", round(lrt_pvalue, 4), "\n")

# If p < 0.05: reject H₀: k=1 → Weibull fits significantly better.
# The Weibull shape parameter k ≠ 1 implies a non-constant hazard.

# ── Exploration: add age and ph.karno ────────────────────────────────────────
fit_wb_full <- flexsurvreg(
  Surv(time, status == 2) ~ sex + age + ph.karno,
  data = lung, dist = "weibull"
)
cat("\nAIC (Weibull, sex only):  ", fit_wb$AIC, "\n")
cat("AIC (Weibull, sex+age+karno):", fit_wb_full$AIC, "\n")

# Time ratio for ph.karno (10-point improvement):
coef_karno <- fit_wb_full$coefficients["ph.karno"]
tr_karno10 <- exp(10 * coef_karno)
cat("Time ratio for +10 ph.karno:", round(tr_karno10, 3), "\n")
# TR > 1: higher Karnofsky score → longer survival.
