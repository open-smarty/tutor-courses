# Required packages
library(survival)
library(flexsurv)
library(survminer)
library(ggplot2)
library(dplyr)

# Dataset: NCCTG lung cancer
data(lung)
lung_cc <- lung |>
  mutate(event = ifelse(status == 2, 1, 0)) |>
  filter(!is.na(ph.ecog))

cat("Complete cases: n =", nrow(lung_cc), "| events =", sum(lung_cc$event), "\n\n")

# ============================================================
# Task 1: Exponential model — constant hazard as a baseline
# ============================================================
# The exponential model constrains the Weibull shape to alpha=1.
# In survreg(), dist="exponential"; in flexsurv, dist="exp".
# AFT form: log(T) = mu + beta*X + Extreme_value_error, with scale=1 fixed.

# TODO: Fit an Exponential AFT model with sex and ph.ecog as covariates.
# Use survreg(... dist="exponential") and print the summary.
aft_exp <- survreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                   dist = "exponential")
summary(aft_exp)

# TODO: Interpret the sex coefficient: exp(coef_sex) is the ratio of median
# survival times (female/male). Print and interpret.
coef_sex_exp <- coef(aft_exp)["sex"]
cat(sprintf("Exponential AFT: exp(beta_sex) = %.3f => females survive %.1f%% longer\n\n",
            exp(coef_sex_exp), (exp(coef_sex_exp) - 1)*100))

# ============================================================
# Task 2: Fit Weibull AFT model and interpret shape
# ============================================================
# survreg() default is dist="weibull".
# Output: coef = AFT log-time coefficients; Log(scale) = log(sigma).
# Weibull shape alpha = 1/sigma (= 1/exp(Log(scale))).

# TODO: Fit the Weibull AFT model with sex and ph.ecog.
aft_weib <- survreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                    dist = "weibull")
summary(aft_weib)

# TODO: Extract sigma (scale) and compute alpha = 1/sigma.
sigma_est <- aft_weib$scale
alpha_est <- 1 / sigma_est
cat(sprintf("Weibull: sigma = %.4f, alpha (shape) = %.4f\n", sigma_est, alpha_est))
cat(sprintf("  alpha > 1 => increasing hazard (ageing/disease progression)\n\n"))

# TODO: Verify the AFT <-> PH relationship:
# beta_PH_sex ≈ -beta_AFT_sex * alpha
beta_AFT_sex <- coef(aft_weib)["sex"]
beta_PH_sex_approx <- -beta_AFT_sex * alpha_est
cat(sprintf("AFT beta_sex = %.4f\n", beta_AFT_sex))
cat(sprintf("Implied PH log-HR for sex ≈ %.4f (compare to Cox result from lesson-02)\n\n",
            beta_PH_sex_approx))

# ============================================================
# Task 3: Compare four distributional families with flexsurv
# ============================================================
# flexsurvreg() fits fully parametric models; AIC() allows direct comparison.
# Distributions: "exp", "weibull", "lnorm", "llogis"

# TODO: Fit all four models with sex and ph.ecog.
# (flexsurv uses the Surv() notation and dist = "...")
fs_exp    <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                         dist = "exp")
fs_weib   <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                         dist = "weibull")
fs_lnorm  <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                         dist = "lnorm")
fs_llogis <- flexsurvreg(Surv(time, event) ~ sex + ph.ecog, data = lung_cc,
                         dist = "llogis")

# TODO: Compare AIC values. Lower AIC = better fit.
aic_df <- data.frame(
  distribution = c("Exponential", "Weibull", "Log-normal", "Log-logistic"),
  AIC          = c(AIC(fs_exp), AIC(fs_weib), AIC(fs_lnorm), AIC(fs_llogis)),
  BIC          = c(BIC(fs_exp), BIC(fs_weib), BIC(fs_lnorm), BIC(fs_llogis))
)
aic_df <- aic_df |> arrange(AIC)
cat("Model comparison by AIC and BIC:\n")
print(round(aic_df, 2))
cat(sprintf("\nBest model (lowest AIC): %s\n\n", aic_df$distribution[1]))

# ============================================================
# Task 4: Goodness-of-fit — fitted survival curves vs KM
# ============================================================
# For the overall population (no covariate stratification), compare each
# parametric model's fitted S(t) against the Kaplan-Meier estimate.

# TODO: Fit each model without covariates (intercept only).
fs_exp0    <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "exp")
fs_weib0   <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "weibull")
fs_lnorm0  <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "lnorm")
fs_llogis0 <- flexsurvreg(Surv(time, event) ~ 1, data = lung_cc, dist = "llogis")

# TODO: Use plot() on one of the flexsurv objects to get a visual GOF check.
# Or manually build a comparison plot.
# We'll use plot() for the Weibull as a quick check, then ggplot for all.

# Quick GOF via built-in flexsurv plot:
plot(fs_weib0, main = "Weibull fit vs KM (overall lung cancer)",
     xlab = "Time (days)", ylab = "S(t)", col = c("#2980b9", "#2980b9"),
     lty = c(1, 2), conf.int = FALSE)
legend("topright", c("KM estimate", "Weibull fit"), lty = c(1,2),
       col = c("black", "#2980b9"))

# TODO: Compute predicted survival curves for all four models manually and
# plot them together with the KM estimate using ggplot.
km_all <- survfit(Surv(time, event) ~ 1, data = lung_cc)
km_df  <- data.frame(
  t    = km_all$time,
  surv = km_all$surv,
  dist = "KM"
)

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

ggplot() +
  geom_step(data = km_df, aes(x = t, y = surv, color = dist), linewidth = 1.2) +
  geom_line(data = pred_df, aes(x = t, y = surv, color = dist),
            linewidth = 0.9, linetype = "dashed") +
  scale_color_manual(values = c("KM" = "black", "Exponential" = "#e74c3c",
                                "Weibull" = "#2980b9", "Log-normal" = "#27ae60",
                                "Log-logistic" = "#8e44ad")) +
  labs(
    title   = "Parametric Survival Models vs KM Estimate",
    subtitle = "Dashed lines = parametric fits; solid = KM",
    x = "Time (days)", y = "S(t)", color = "Model"
  ) +
  theme_minimal()

# ============================================================
# Task 5: Weibull hazard function shape
# ============================================================
# h(t) = (alpha/lambda) * (t/lambda)^(alpha-1)
# Use the intercept-only Weibull to extract lambda and alpha for plotting.

# TODO: Extract the Weibull shape and scale from fs_weib0.
# flexsurv Weibull parameterisation: shape = alpha, scale = lambda.
weib_shape <- fs_weib0$res["shape", "est"]
weib_scale <- fs_weib0$res["scale", "est"]

cat(sprintf("Intercept-only Weibull: shape (alpha) = %.4f, scale (lambda) = %.4f\n",
            weib_shape, weib_scale))

t_plot <- seq(1, max(lung_cc$time), by = 2)
h_weib  <- (weib_shape / weib_scale) * (t_plot / weib_scale)^(weib_shape - 1)

hazard_df <- data.frame(t = t_plot, h = h_weib)
ggplot(hazard_df, aes(x = t, y = h)) +
  geom_line(color = "#2980b9", linewidth = 1.2) +
  labs(
    title    = "Estimated Weibull Hazard Function h(t)",
    subtitle = paste0("shape = ", round(weib_shape, 3),
                      ", scale = ", round(weib_scale, 1)),
    x = "Time (days)", y = "h(t)"
  ) +
  theme_minimal()
# TODO: Describe the shape: is h(t) increasing, decreasing, or approximately constant?
