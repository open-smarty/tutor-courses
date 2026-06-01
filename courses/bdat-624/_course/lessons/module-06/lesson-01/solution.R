# BDAT 624 — Module 6, Lesson 1: Competing Risks and Multi-State Models
# SOLUTION FILE — complete working implementation
#
# Libraries -----------------------------------------------------------------
library(cmprsk)
library(msm)
library(survival)
library(ggplot2)
library(dplyr)

set.seed(42)

# ===========================================================================
# PART 1: COMPETING RISKS — Bone Marrow Transplant Data
# ===========================================================================

# Step 1: Load data ----------------------------------------------------------
data(bmt, package = "KMsurv")

str(bmt)
head(bmt)

# Define competing risks cause variable:
#   0 = censored, 1 = relapse/disease death, 2 = transplant-related mortality
bmt$cause <- with(bmt, ifelse(d3 == 0, 0,
                       ifelse(d2 == 1, 1,
                                       2)))

cat("Event counts:\n")
print(table(bmt$cause, dnn = "cause (0=censored, 1=relapse, 2=TRM)"))

# Step 2: Estimate CIF for each cause ----------------------------------------
cif_fit <- cuminc(ftime = bmt$t2, fstatus = bmt$cause)

summary(cif_fit)

# Step 3: Plot CIFs with 95% CI ----------------------------------------------
cif1 <- data.frame(
  time  = cif_fit[["1 1"]]$time,
  est   = cif_fit[["1 1"]]$est,
  lower = pmax(0, cif_fit[["1 1"]]$est - 1.96 * sqrt(cif_fit[["1 1"]]$var)),
  upper = pmin(1, cif_fit[["1 1"]]$est + 1.96 * sqrt(cif_fit[["1 1"]]$var)),
  cause = "Cause 1: Relapse/Disease"
)

cif2 <- data.frame(
  time  = cif_fit[["1 2"]]$time,
  est   = cif_fit[["1 2"]]$est,
  lower = pmax(0, cif_fit[["1 2"]]$est - 1.96 * sqrt(cif_fit[["1 2"]]$var)),
  upper = pmin(1, cif_fit[["1 2"]]$est + 1.96 * sqrt(cif_fit[["1 2"]]$var)),
  cause = "Cause 2: TRM"
)

cif_df <- rbind(cif1, cif2)

p_cif <- ggplot(cif_df, aes(x = time, y = est, colour = cause, fill = cause)) +
  geom_step(linewidth = 1.1) +
  geom_ribbon(
    aes(ymin = lower, ymax = upper),
    alpha = 0.15, colour = NA
  ) +
  labs(
    title    = "Competing Risks: Cumulative Incidence Functions",
    subtitle = "Bone marrow transplant — cause 1 = relapse, cause 2 = TRM",
    x        = "Time (days)",
    y        = "Cumulative incidence",
    colour   = NULL, fill = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_cif)

# Step 4: Compare KM (naive) vs CIF for cause 1 ------------------------------
bmt$km_event1 <- ifelse(bmt$cause == 1, 1, 0)

km_fit1 <- survfit(Surv(t2, km_event1) ~ 1, data = bmt)

km_df <- data.frame(
  time  = km_fit1$time,
  km_ci = 1 - km_fit1$surv,
  cause = "1 - KM (naive)"
)

compare_df <- rbind(
  data.frame(time = cif1$time,  cuminc = cif1$est,  method = "CIF (correct)"),
  data.frame(time = km_df$time, cuminc = km_df$km_ci, method = "1 - KM (naive)")
)

p_compare <- ggplot(compare_df, aes(x = time, y = cuminc, colour = method)) +
  geom_step(linewidth = 1.1) +
  scale_colour_manual(values = c("CIF (correct)" = "steelblue",
                                 "1 - KM (naive)" = "tomato")) +
  labs(
    title    = "CIF vs. naive 1 - KM estimator for cause 1 (relapse)",
    subtitle = "KM overestimates cumulative incidence by treating TRM as censoring",
    x        = "Time (days)", y = "Cumulative incidence",
    colour   = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_compare)

# Step 5: Fine-Gray model for cause 1 ----------------------------------------
fg_fit <- crr(
  ftime    = bmt$t2,
  fstatus  = bmt$cause,
  cov1     = cbind(group = bmt$group, age = bmt$z1),
  failcode = 1
)

summary(fg_fit)

cat("\nSubdistribution Hazard Ratios (exp(coef)) for cause 1:\n")
print(exp(fg_fit$coef))

# ===========================================================================
# PART 2: MULTI-STATE MODELS — CAV Data
# ===========================================================================

# Step 6: Load and explore cav data ------------------------------------------
data(cav)

cat("\n--- cav dataset structure ---\n")
str(cav)
head(cav)

cat("\nState distribution in cav:\n")
print(table(cav$state))

# Step 7: Fit the multi-state model ------------------------------------------
Q_init <- rbind(
  c(0,   0.1, 0,   0.1),
  c(0.1, 0,   0.1, 0.1),
  c(0,   0.1, 0,   0.2),
  c(0,   0,   0,   0  )
)

fit_msm <- msm(
  state   ~ years,
  subject = PTNUM,
  data    = cav,
  qmatrix = Q_init,
  deathexact = 4
)

# Step 8: Examine and interpret the fitted Q matrix --------------------------
cat("\n--- Estimated intensity matrix Q ---\n")
q_est <- qmatrix.msm(fit_msm)
print(round(q_est$estimates, 4))

# Mean sojourn times: -1 / diagonal of Q (for transient states 1–3)
q_diag <- diag(q_est$estimates)[1:3]
sojourn_times <- -1 / q_diag
cat("\nMean sojourn times (years) in states 1, 2, 3:\n")
print(round(sojourn_times, 2))

# Interpretation:
# A patient stays in State 1 (no CAV) an average of sojourn_times[1] years
# before transitioning to another state; etc.

# Step 9: Transition probability matrix P(t) = exp(Q * t) --------------------
cat("\n--- Transition probabilities starting from state 1 ---\n")
for (t_val in c(1, 5, 10)) {
  Pt <- pmatrix.msm(fit_msm, t = t_val)
  cat(sprintf("\nP(t = %2d years), row 1 (starting from no CAV):\n", t_val))
  print(round(Pt$estimates[1, ], 4))
}

# Specific question: P(in state 3 at year 5 | start in state 1)
Pt5 <- pmatrix.msm(fit_msm, t = 5)
cat(sprintf(
  "\nP(moderate/severe CAV at year 5 | no CAV at baseline) = %.4f\n",
  Pt5$estimates[1, 3]
))

# Step 10: Plot P_{1,j}(t) for j = 1, 2, 3, 4 over time --------------------
t_seq   <- seq(0, 15, by = 0.5)
n_times <- length(t_seq)

prob_matrix <- matrix(NA, nrow = n_times, ncol = 4)

for (i in seq_along(t_seq)) {
  prob_matrix[i, ] <- pmatrix.msm(fit_msm, t = t_seq[i])$estimates[1, ]
}

prob_df <- data.frame(
  time  = rep(t_seq, times = 4),
  prob  = c(prob_matrix[, 1], prob_matrix[, 2],
            prob_matrix[, 3], prob_matrix[, 4]),
  state = rep(c("State 1: No CAV", "State 2: Mild CAV",
                "State 3: Moderate/Severe CAV", "State 4: Dead"),
              each = n_times)
)

p_msm <- ggplot(prob_df, aes(x = time, y = prob, colour = state)) +
  geom_line(linewidth = 1.1) +
  scale_colour_manual(
    values = c(
      "State 1: No CAV"             = "steelblue",
      "State 2: Mild CAV"           = "goldenrod",
      "State 3: Moderate/Severe CAV"= "tomato",
      "State 4: Dead"               = "grey30"
    )
  ) +
  labs(
    title    = "Multi-State Model: Transition Probabilities from State 1 (No CAV)",
    subtitle = "P(in state j at time t | state 1 at time 0) — CAV dataset",
    x        = "Years since transplant",
    y        = "Probability",
    colour   = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_msm)

cat("\n--- Solution complete ---\n")
