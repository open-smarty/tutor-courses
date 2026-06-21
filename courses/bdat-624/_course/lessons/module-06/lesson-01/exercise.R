# Required packages
library(survival)
library(cmprsk)
library(mstate)
library(ggplot2)
library(dplyr)

# We use a simulated bone marrow transplant-like competing risks dataset.
# Event types: 1 = relapse, 2 = transplant-related mortality (TRM).
# Group: 0 = standard conditioning, 1 = reduced-intensity conditioning.

set.seed(2024)
n <- 300

# Simulate time to relapse (cause 1) and time to TRM (cause 2)
# Standard conditioning (group=0): relapse rate 0.05/day, TRM rate 0.03/day
# Reduced intensity (group=1):      relapse rate 0.08/day, TRM rate 0.015/day
group       <- rbinom(n, 1, 0.5)
rate_rel    <- ifelse(group == 0, 0.005, 0.008)   # per day
rate_trm    <- ifelse(group == 0, 0.003, 0.0015)
time_rel    <- rexp(n, rate = rate_rel)
time_trm    <- rexp(n, rate = rate_trm)

# Observed time and cause (competing risks)
time_obs    <- pmin(time_rel, time_trm)
cause       <- ifelse(time_rel < time_trm, 1, 2)

# Add administrative censoring at day 600
censored_at <- 600
time_obs[time_obs > censored_at] <- censored_at
cause[time_obs == censored_at]   <- 0   # 0 = censored

cr_data <- data.frame(
  id     = 1:n,
  time   = time_obs,
  cause  = cause,
  group  = group
)

cat("Competing risks dataset:\n")
cat("  Total n:", n, "\n")
cat("  Cause 1 (relapse):", sum(cause==1), "\n")
cat("  Cause 2 (TRM):", sum(cause==2), "\n")
cat("  Censored:", sum(cause==0), "\n\n")

# ============================================================
# Task 1: Naive KM vs CIF — show the bias from ignoring competing risks
# ============================================================
# Step A: KM estimate treating competing events as censored (WRONG for cause 1)
# Step B: CIF from cmprsk::cuminc() (CORRECT)

# TODO: Fit a KM curve for cause 1, censoring cause 2.
# event_naive = 1 if cause==1, else 0 (treats cause 2 as censoring)
cr_data <- cr_data |>
  mutate(event_naive = ifelse(cause == 1, 1, 0))

km_naive <- survfit(Surv(time, event_naive) ~ 1, data = cr_data)

# TODO: Estimate CIFs using cuminc(ftime=, fstatus=).
# cuminc handles both causes simultaneously.
ci_all <- cuminc(ftime = cr_data$time, fstatus = cr_data$cause)

# TODO: Extract the CIF for cause 1 at time points matching the KM estimate.
# Plot KM (1 - surv) and the CIF side-by-side on the same axes.
# Label clearly why KM overestimates the probability of relapse.
km_df <- data.frame(
  t     = km_naive$time,
  km_1  = 1 - km_naive$surv,  # "1 - KM" as an estimate of F_1(t) -- biased
  type  = "1-KM (naive)"
)

# Extract cause-1 CIF from the cuminc object
ci1_obj <- ci_all[["1 1"]]  # naming: "<group_label> <cause_label>"
cif_df  <- data.frame(
  t    = ci1_obj$time,
  km_1 = ci1_obj$est,
  type = "CIF (correct)"
)

compare_df <- bind_rows(km_df, cif_df)

ggplot(compare_df, aes(x = t, y = km_1, color = type)) +
  geom_step(linewidth = 1) +
  scale_color_manual(values = c("1-KM (naive)" = "#e74c3c",
                                "CIF (correct)" = "#2980b9")) +
  labs(
    title    = "Naive KM vs Cumulative Incidence Function for Relapse",
    subtitle = "KM over-estimates P(relapse) by ignoring competing TRM",
    x = "Days", y = "Probability of relapse", color = ""
  ) +
  theme_minimal()

# ============================================================
# Task 2: Gray's test — compare CIFs between groups
# ============================================================
# Gray's test is the competing-risks analogue of the log-rank test.
# H0: CIF_group0(t) = CIF_group1(t) for all t (for each cause).

# TODO: Run cuminc(ftime=, fstatus=, group=) to stratify by group.
ci_by_group <- cuminc(ftime = cr_data$time, fstatus = cr_data$cause,
                      group = cr_data$group)

# TODO: Print Gray's test results from ci_by_group$Tests.
cat("Gray's test (comparing CIFs by group):\n")
print(ci_by_group$Tests)

# TODO: Plot the stratified CIFs for each cause using ggplot.
# Extract the four CIF curves: group 0 cause 1, group 0 cause 2,
#                               group 1 cause 1, group 1 cause 2.
extract_cif <- function(ci_obj, key, label) {
  data.frame(t = ci_obj[[key]]$time,
             cif = ci_obj[[key]]$est,
             group_cause = label)
}

cif_plot_df <- bind_rows(
  extract_cif(ci_by_group, "0 1", "Group 0, Cause 1 (relapse)"),
  extract_cif(ci_by_group, "0 2", "Group 0, Cause 2 (TRM)"),
  extract_cif(ci_by_group, "1 1", "Group 1, Cause 1 (relapse)"),
  extract_cif(ci_by_group, "1 2", "Group 1, Cause 2 (TRM)")
)

ggplot(cif_plot_df, aes(x = t, y = cif, color = group_cause)) +
  geom_step(linewidth = 1) +
  labs(
    title   = "Cumulative Incidence Functions by Group and Cause",
    subtitle = "Group 0 = standard conditioning; Group 1 = reduced intensity",
    x = "Days", y = "Cumulative incidence", color = "Group / Cause"
  ) +
  theme_minimal()

# ============================================================
# Task 3: Fine-Gray model for cause 1 (relapse)
# ============================================================
# cmprsk::crr() fits the subdistribution hazard model.
# A positive gamma implies higher CIF (worse prognosis for that cause).

# TODO: Fit a Fine-Gray model for cause 1 with group as covariate.
# crr(ftime=, fstatus=, cov1=, failcode=1, cencode=0)

cov_matrix <- as.matrix(cr_data[, "group", drop = FALSE])

fg_fit <- crr(
  ftime    = cr_data$time,
  fstatus  = cr_data$cause,
  cov1     = cov_matrix,
  failcode = 1,
  cencode  = 0
)

cat("\nFine-Gray model for relapse (cause 1):\n")
print(summary(fg_fit))

# TODO: Extract the subdistribution hazard ratio exp(gamma) for group.
# Print and interpret: does reduced-intensity conditioning increase or
# decrease the cumulative incidence of relapse?
gamma_group <- fg_fit$coef["group"]
shr_group   <- exp(gamma_group)
cat(sprintf("\nSubdistribution HR for group (cause 1 = relapse): exp(gamma) = %.3f\n",
            shr_group))
cat("Interpretation: Group 1 (reduced intensity) has a",
    ifelse(shr_group > 1, "HIGHER", "LOWER"),
    "subdistribution hazard of relapse.\n")

# ============================================================
# Task 4: Simple 3-state multi-state model
# ============================================================
# States: 1 = healthy (post-transplant), 2 = relapse, 3 = dead
# Allowed transitions: 1->2 (relapse), 1->3 (death without relapse), 2->3 (death after relapse)
# This uses mstate; we build a simple Markov model.

# Build transition matrix
tmat <- transMat(x = list(c(2, 3), c(3), c()),
                 names = c("Healthy", "Relapse", "Dead"))
cat("\nTransition matrix:\n")
print(tmat)

# Create multi-state data from our simulated dataset
# For simplicity, we assume patients who relapse (cause=1) transit 1->2->3
# and patients who die first (cause=2) transit 1->3.
# All event times are the final observed time.

# Build the long-format data manually for this simple 3-state model
ms_rows <- lapply(1:nrow(cr_data), function(i) {
  row <- cr_data[i, ]
  if (row$cause == 0) {
    # Censored: 1->2 and 1->3, both censored at row$time
    data.frame(id=row$id, from=c(1,1), to=c(2,3),
               trans=c(1,2), Tstart=0, Tstop=row$time,
               status=c(0,0), group=row$group)
  } else if (row$cause == 1) {
    # Relapse at row$time (transition 1->2); then dead (censored at obs end, transition 2->3)
    data.frame(id=row$id, from=c(1,1,2), to=c(2,3,3),
               trans=c(1,2,3), Tstart=c(0,0,row$time),
               Tstop=c(row$time, row$time, row$time + 1),
               status=c(1,0,0), group=row$group)
  } else {
    # TRM: transition 1->3 at row$time; 1->2 censored
    data.frame(id=row$id, from=c(1,1), to=c(2,3),
               trans=c(1,2), Tstart=0, Tstop=row$time,
               status=c(0,1), group=row$group)
  }
}) |> bind_rows()

# TODO: Fit a Cox model on the multi-state data (one model per transition,
# using strata(trans) to allow different baseline hazards).
cox_ms <- coxph(Surv(Tstart, Tstop, status) ~ group + strata(trans),
                data = ms_rows, id = id)
cat("\nMulti-state Cox model (stratified by transition):\n")
print(summary(cox_ms))

# TODO: Print the transition-specific baseline cumulative hazards
# from basehaz(cox_ms) and discuss which transition is most affected by group.
bh_ms <- basehaz(cox_ms, centered = FALSE)
cat("\nBaseline cumulative hazard by transition:\n")
print(head(bh_ms, 10))
