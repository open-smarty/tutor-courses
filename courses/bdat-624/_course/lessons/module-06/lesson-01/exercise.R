# BDAT 624 — Module 6, Lesson 1: Competing Risks and Multi-State Models
# Exercise: CIF estimation, Fine-Gray model, and msm multi-state model
#
# Instructions: fill in every # TODO: marker.
# Run: npm run check -- bdat-624 module-06 lesson-01
#
# Libraries -----------------------------------------------------------------
library(cmprsk)      # cuminc(), crr()
library(msm)         # msm(), pmatrix.msm(), cav dataset
library(survival)    # Surv(), survfit()
library(ggplot2)
library(dplyr)

set.seed(42)

# ===========================================================================
# PART 1: COMPETING RISKS — Bone Marrow Transplant Data
# ===========================================================================
#
# The bmt dataset contains bone marrow transplant patients.
# We use:
#   t2          = time to event (days)
#   d3          = overall event indicator (1 = event occurred)
#   da, db, dc  = cause-specific indicators for three groups
#                 We define cause 1 = relapse/disease death, cause 2 = TRM
# ---------------------------------------------------------------------------

# Step 1: Load data ----------------------------------------------------------
data(bmt, package = "KMsurv")

# Examine the dataset structure
# TODO: run str(bmt) and head(bmt) to understand the variables
# TODO

# We define a competing-risks event indicator:
#   cause = 0  if censored (d3 == 0)
#   cause = 1  if relapse / disease failure (d2 == 1 in the original coding)
#   cause = 2  if transplant-related mortality without relapse (d1 == 1)
# In the KMsurv::bmt dataset: d2 = 1 means relapse or disease death,
# d1 = 1 means transplant-related mortality without relapse.
# Time variable: t2 (time to relapse or death, days).
bmt$cause <- with(bmt, ifelse(d3 == 0, 0,   # censored
                       ifelse(d2 == 1, 1,    # cause 1: relapse/disease death
                                       2)))  # cause 2: TRM

cat("Event counts:\n")
print(table(bmt$cause, dnn = "cause (0=censored, 1=relapse, 2=TRM)"))

# Step 2: Estimate CIF for each cause ----------------------------------------
# Use cmprsk::cuminc(ftime, fstatus)
# ftime   = event time
# fstatus = cause indicator (0 = censored)

# TODO: fit the CIF using cuminc()
cif_fit <- # TODO

# Inspect the result
summary(cif_fit)

# Step 3: Plot CIFs for cause 1 and cause 2 with 95% CI ----------------------
# cuminc returns a list; each element named "group cause" contains:
#   $time  $est  $var
# We extract and reshape for ggplot.

# TODO: extract CIF estimates and 95% CIs for cause 1 and cause 2
# Hint: the list element names look like "1 1" (group 1, cause 1) and "1 2"
#       but when there is no group variable they are simply "1" and "2"
#       Check: names(cif_fit)

cif1 <- data.frame(
  time  = cif_fit[["1 1"]]$time,
  est   = cif_fit[["1 1"]]$est,
  lower = cif_fit[["1 1"]]$est - 1.96 * sqrt(cif_fit[["1 1"]]$var),
  upper = cif_fit[["1 1"]]$est + 1.96 * sqrt(cif_fit[["1 1"]]$var),
  cause = "Cause 1: Relapse/Disease"
)

# TODO: build cif2 in the same way for cause 2 (key "1 2")
cif2 <- # TODO

cif_df <- rbind(cif1, cif2)

# TODO: create a ggplot showing both CIF curves with shaded 95% CI bands
#   Use geom_step for the estimates and geom_ribbon or geom_stepribbon for CIs
#   Colour by cause, label axes (time in days), add a title
p_cif <- ggplot(cif_df, aes(x = time, y = est, colour = cause, fill = cause)) +
  # TODO: add step lines
  # TODO: add CI ribbons (alpha = 0.15)
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
# The KM estimator for cause 1, treating cause-2 events as censored, OVERESTIMATES
# the cumulative incidence of cause 1.

# KM estimate: treat cause-2 events as censored for cause 1
bmt$km_event1 <- ifelse(bmt$cause == 1, 1, 0)  # cause 1 events only

# TODO: fit a KM curve for cause 1 using survfit(Surv(t2, km_event1) ~ 1, data = bmt)
km_fit1 <- # TODO

# Extract KM estimates
km_df <- data.frame(
  time  = km_fit1$time,
  km_ci = 1 - km_fit1$surv,   # 1 - KM = naive cumulative incidence
  cause = "1 - KM (naive)"
)

# Combine with CIF for cause 1
compare_df <- rbind(
  data.frame(time = cif1$time, cuminc = cif1$est, method = "CIF (correct)"),
  data.frame(time = km_df$time,  cuminc = km_df$km_ci, method = "1 - KM (naive)")
)

# TODO: plot both curves on the same graph to show overestimation
p_compare <- ggplot(compare_df, aes(x = time, y = cuminc, colour = method)) +
  # TODO: add step lines
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
# Use cmprsk::crr(ftime, fstatus, cov1) for Fine-Gray regression.
# Predictors: group (disease group, bmt$group) and age at transplant (bmt$z1)

# TODO: fit the Fine-Gray model for cause 1
# Hint: crr(ftime = bmt$t2, fstatus = bmt$cause,
#            cov1  = cbind(group = bmt$group, age = bmt$z1),
#            failcode = 1)
fg_fit <- # TODO

# TODO: print a summary of the Fine-Gray fit
# TODO

# TODO: interpret: exponentiate the coefficients to get subdistribution HRs
cat("\nSubdistribution Hazard Ratios (exp(coef)) for cause 1:\n")
# TODO: print exp(fg_fit$coef) with names


# ===========================================================================
# PART 2: MULTI-STATE MODELS — CAV Data
# ===========================================================================
#
# The cav dataset (from msm) contains repeated measurements of cardiac
# allograft vasculopathy (CAV) state in heart transplant patients.
# States: 1 = no CAV, 2 = mild CAV, 3 = moderate/severe CAV, 4 = dead
# ---------------------------------------------------------------------------

# Step 6: Load and explore cav data ------------------------------------------
data(cav)

cat("\n--- cav dataset structure ---\n")
# TODO: run str(cav) and examine the first few rows
# TODO

cat("\nState distribution in cav:\n")
print(table(cav$state))

# Step 7: Define the initial Q matrix and fit the msm model ------------------
# Allowed transitions (set to non-zero in Q):
#   1->2, 1->4  (no direct 1->3 jump; patients progress through states)
#   2->1, 2->3, 2->4
#   3->2, 3->4
#   4 is absorbing
#
# The initial Q matrix provides starting values for the optimiser.
# Off-diagonal entries: 0.1 = "some positive rate"; 0 = "transition not allowed".

Q_init <- rbind(
  c(0,   0.1, 0,   0.1),
  c(0.1, 0,   0.1, 0.1),
  c(0,   0.1, 0,   0.2),
  c(0,   0,   0,   0  )
)

# TODO: fit the multi-state model
# Hint: msm(state ~ years, subject = PTNUM, data = cav,
#            qmatrix = Q_init, deathexact = 4)
fit_msm <- # TODO

# Step 8: Examine and interpret the fitted Q matrix --------------------------
cat("\n--- Estimated intensity matrix Q ---\n")
# TODO: print the fitted Q matrix using qmatrix.msm(fit_msm)
# TODO

# TODO: compute and print the mean sojourn times in each transient state
# Mean sojourn time in state i = 1 / |q_ii| = 1 / sum of rates out of state i
# Hint: -1 / diag(qmatrix.msm(fit_msm)$estimates)[1:3]
cat("\nMean sojourn times (years) in states 1, 2, 3:\n")
# TODO

# Step 9: Compute transition probability matrix P(t) = exp(Q * t) -----------
# Use pmatrix.msm(fit_msm, t) to compute P(t) for several values of t.

cat("\n--- Transition probabilities starting from state 1 ---\n")
for (t_val in c(1, 5, 10)) {
  # TODO: compute P(t_val) and print row 1 (starting from state 1=no CAV)
  Pt <- # TODO: pmatrix.msm(fit_msm, t = t_val)
  cat(sprintf("\nP(t = %2d years), row 1 (starting from no CAV):\n", t_val))
  # TODO: print round(Pt$estimates[1, ], 4)
}

# Step 10: Plot P_{1,j}(t) for j = 1, 2, 3, 4 over time --------------------
# Show how the probability of being in each state evolves over time for a
# patient starting in state 1 (no CAV).

t_seq   <- seq(0, 15, by = 0.5)
n_times <- length(t_seq)

# Pre-allocate a matrix: rows = time points, cols = destination states 1..4
prob_matrix <- matrix(NA, nrow = n_times, ncol = 4)

for (i in seq_along(t_seq)) {
  # TODO: compute P(t_seq[i]) and store row 1 in prob_matrix[i, ]
  # Hint: pmatrix.msm(fit_msm, t = t_seq[i])$estimates[1, ]
  prob_matrix[i, ] <- # TODO
}

prob_df <- data.frame(
  time  = rep(t_seq, times = 4),
  prob  = c(prob_matrix[, 1], prob_matrix[, 2],
            prob_matrix[, 3], prob_matrix[, 4]),
  state = rep(c("State 1: No CAV", "State 2: Mild CAV",
                "State 3: Moderate/Severe CAV", "State 4: Dead"),
              each = n_times)
)

# TODO: plot all four state-occupation probabilities over time as smooth lines
p_msm <- ggplot(prob_df, aes(x = time, y = prob, colour = state)) +
  # TODO: add geom_line
  labs(
    title    = "Multi-State Model: Transition Probabilities from State 1 (No CAV)",
    subtitle = "P(in state j at time t | state 1 at time 0)",
    x        = "Years since transplant",
    y        = "Probability",
    colour   = NULL
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_msm)

cat("\n--- Exercise complete ---\n")
cat("Run: npm run check -- bdat-624 module-06 lesson-01\n")
