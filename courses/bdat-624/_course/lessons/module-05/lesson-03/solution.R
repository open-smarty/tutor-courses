# SOLUTION: Module 05 Lesson 03 — Parametric Survival Models and AFT
library(survival)
library(flexsurv)
library(survminer)
library(ggplot2)
library(dplyr)

data(lung)
lung_cc <- lung |>
  mutate(event = ifelse(status == 2, 1, 0)) |>
  filter(!is.na(ph.ecog))

cat("Complete cases: n =", nrow(lung_cc), "| events =", sum(lung_cc$event), "\n\n")

# ============================================================
# Task 1: Exponential AFT model
# ============================================================
aft_exp <- survreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                   dist = "exponential")
cat("=== Exponential AFT ===\n")
print(summary(aft_exp))

coef_sex_exp <- coef(aft_exp)["sex"]
cat(sprintf("exp(beta_sex) = %.3f => females' median survival is %.1f%% longer than males\n\n",
            exp(coef_sex_exp), (exp(coef_sex_exp) - 1)*100))

# ============================================================
# Task 2: Weibull AFT model
# ============================================================
aft_weib <- survreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                    dist = "weibull")
cat("=== Weibull AFT ===\n")
print(summary(aft_weib))

sigma_est  <- aft_weib$scale          # sigma = 1/alpha in survreg convention
alpha_est  <- 1 / sigma_est
beta_AFT_sex <- coef(aft_weib)["sex"]
beta_PH_sex_approx <- -beta_AFT_sex * alpha_est

cat(sprintf("sigma = %.4f => Weibull shape alpha = 1/sigma = %.4f\n", sigma_est, alpha_est))
cat(sprintf("alpha > 1 => hazard is increasing over time\n"))
cat(sprintf("AFT beta_sex = %.4f\n", beta_AFT_sex))
cat(sprintf("Implied PH log-HR (sex) ≈ -beta_AFT * alpha = %.4f\n\n", beta_PH_sex_approx))
# Compare: Cox model lesson-02 gave beta_sex ≈ -0.53 — consistent.

# ============================================================
# Task 3: AIC/BIC comparison with flexsurv
# ============================================================
fs_exp    <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc, dist = "exp")
fs_weib   <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc, dist = "weibull")
fs_lnorm  <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc, dist = "lnorm")
fs_llogis <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc, dist = "llogis")

aic_df <- data.frame(
  distribution = c("Exponential", "Weibull", "Log-normal", "Log-logistic"),
  AIC          = c(AIC(fs_exp), AIC(fs_weib), AIC(fs_lnorm), AIC(fs_llogis)),
  BIC          = c(BIC(fs_exp), BIC(fs_weib), BIC(fs_lnorm), BIC(fs_llogis))
) |> arrange(AIC)

cat("Model comparison (sorted by AIC):\n")
print(round(aic_df, 2))
cat(sprintf("\nBest model (lowest AIC): %s\n", aic_df$distribution[1]))
cat("Interpretation: Log-normal/log-logistic often outperform Weibull for lung cancer\n")
cat("because the hazard rises then falls (non-monotone), which Weibull cannot capture.\n\n")

# ============================================================
# Task 4: Goodness-of-fit — all four models vs KM
# ============================================================
fs_exp0    <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "exp")
fs_weib0   <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "weibull")
fs_lnorm0  <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "lnorm")
fs_llogis0 <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "llogis")

# Quick built-in plot for Weibull
plot(fs_weib0, ci = FALSE, col = "#2980b9", lwd = 2,
     main = "Weibull vs KM (intercept-only)", xlab = "Time (days)", ylab = "S(t)")

# Full ggplot comparison
km_all <- survfit(Surv(time, event) ~ 1, data = lung_cc)
km_df  <- data.frame(t = km_all$time, surv = km_all$surv, dist = "KM")

t_grid <- seq(1, max(lung_cc$time), by = 2)
make_pred_df <- function(fs_obj, label) {
  S_vals <- summary(fs_obj, t = t_grid, type = "survival")[[1]]$est
  data.frame(t = t_grid, surv = S_vals, dist = label)
}

pred_df <- bind_rows(
  make_pred_df(fs_exp0,    "Exponential"),
  make_pred_df(fs_weib0,   "Weibull"),
  make_pred_df(fs_lnorm0,  "Log-normal"),
  make_pred_df(fs_llogis0, "Log-logistic")
)

p_gof <- ggplot() +
  geom_step(data = km_df, aes(x = t, y = surv, color = dist), linewidth = 1.3) +
  geom_line(data = pred_df, aes(x = t, y = surv, color = dist),
            linewidth = 0.9, linetype = "dashed") +
  scale_color_manual(values = c("KM" = "black", "Exponential" = "#e74c3c",
                                "Weibull" = "#2980b9", "Log-normal" = "#27ae60",
                                "Log-logistic" = "#8e44ad")) +
  labs(
    title   = "Parametric Survival Models vs KM (Intercept-only)",
    subtitle = "Dashed = parametric fit; Solid = Kaplan-Meier",
    x = "Time (days)", y = "S(t)", color = "Model"
  ) +
  theme_minimal(base_size = 12)
print(p_gof)

# ============================================================
# Task 5: Weibull hazard function plot
# ============================================================
weib_shape <- fs_weib0$res["shape", "est"]
weib_scale <- fs_weib0$res["scale", "est"]
cat(sprintf("Intercept-only Weibull: shape = %.4f, scale = %.1f\n",
            weib_shape, weib_scale))

t_plot <- seq(1, max(lung_cc$time), by = 2)
h_weib  <- (weib_shape / weib_scale) * (t_plot / weib_scale)^(weib_shape - 1)

p_haz <- ggplot(data.frame(t = t_plot, h = h_weib), aes(x = t, y = h)) +
  geom_line(color = "#2980b9", linewidth = 1.2) +
  labs(
    title    = "Weibull Hazard Function h(t) — Lung Cancer",
    subtitle = paste0("shape = ", round(weib_shape, 3),
                      ", scale = ", round(weib_scale, 1),
                      "; shape > 1 => increasing hazard"),
    x = "Time (days)", y = "h(t)"
  ) +
  theme_minimal(base_size = 12)
print(p_haz)

cat("\nSummary: The Weibull shape > 1 indicates hazard increases over time,\n")
cat("consistent with lung cancer becoming more lethal as disease progresses.\n")
cat("However, the log-normal/log-logistic model (with non-monotone hazard) may\n")
cat("provide a better fit — the initial diagnostic period often carries high risk.\n")
