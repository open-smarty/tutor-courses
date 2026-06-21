# SOLUTION: Module 06 Lesson 01 — Competing Risks and Multi-State Models
library(survival)
library(cmprsk)
library(mstate)
library(ggplot2)
library(dplyr)

# ============================================================
# Simulate competing risks dataset
# ============================================================
set.seed(2024)
n           <- 300
group       <- rbinom(n, 1, 0.5)
rate_rel    <- ifelse(group == 0, 0.005, 0.008)
rate_trm    <- ifelse(group == 0, 0.003, 0.0015)
time_rel    <- rexp(n, rate = rate_rel)
time_trm    <- rexp(n, rate = rate_trm)
time_obs    <- pmin(time_rel, time_trm)
cause       <- ifelse(time_rel < time_trm, 1, 2)
censored_at <- 600
cause[time_obs > censored_at]   <- 0
time_obs[time_obs > censored_at] <- censored_at

cr_data <- data.frame(id=1:n, time=time_obs, cause=cause, group=group)
cat("Events: cause1=", sum(cause==1), " cause2=", sum(cause==2),
    " censored=", sum(cause==0), "\n\n")

# ============================================================
# Task 1: Naive KM vs CIF
# ============================================================
cr_data <- cr_data |> mutate(event_naive = ifelse(cause == 1, 1, 0))
km_naive <- survfit(Surv(time, event_naive) ~ 1, data = cr_data)
ci_all   <- cuminc(ftime = cr_data$time, fstatus = cr_data$cause)

km_df  <- data.frame(t=km_naive$time, prob=1-km_naive$surv, type="1-KM (naive)")
ci1    <- ci_all[["1 1"]]
cif_df <- data.frame(t=ci1$time, prob=ci1$est, type="CIF (correct)")

p1 <- ggplot(bind_rows(km_df, cif_df), aes(x=t, y=prob, color=type)) +
  geom_step(linewidth=1) +
  scale_color_manual(values=c("1-KM (naive)"="#e74c3c","CIF (correct)"="#2980b9")) +
  labs(title="Naive KM vs CIF for Relapse",
       subtitle="KM over-estimates P(relapse) by treating TRM as censoring",
       x="Days", y="P(relapse)", color="") +
  theme_minimal(base_size=12)
print(p1)

# At t=400 days, compare the two:
km_400  <- approx(km_naive$time, 1-km_naive$surv, xout=400)$y
cif_400 <- approx(ci1$time, ci1$est, xout=400)$y
cat(sprintf("At t=400: 1-KM = %.3f vs CIF = %.3f (KM overestimates by %.3f)\n\n",
            km_400, cif_400, km_400 - cif_400))

# ============================================================
# Task 2: Gray's test
# ============================================================
ci_by_group <- cuminc(ftime=cr_data$time, fstatus=cr_data$cause,
                      group=cr_data$group)
cat("Gray's test results:\n")
print(ci_by_group$Tests)

extract_cif <- function(ci_obj, key, label) {
  data.frame(t=ci_obj[[key]]$time, cif=ci_obj[[key]]$est, group_cause=label)
}

cif_plot_df <- bind_rows(
  extract_cif(ci_by_group, "0 1", "Group 0, Relapse"),
  extract_cif(ci_by_group, "0 2", "Group 0, TRM"),
  extract_cif(ci_by_group, "1 1", "Group 1, Relapse"),
  extract_cif(ci_by_group, "1 2", "Group 1, TRM")
)

p2 <- ggplot(cif_plot_df, aes(x=t, y=cif, color=group_cause)) +
  geom_step(linewidth=1) +
  labs(title="CIFs by Group and Cause",
       subtitle="Group 0=standard; Group 1=reduced-intensity conditioning",
       x="Days", y="Cumulative incidence", color="Group/Cause") +
  theme_minimal(base_size=12)
print(p2)

# ============================================================
# Task 3: Fine-Gray model for relapse
# ============================================================
cov_matrix <- as.matrix(cr_data[, "group", drop=FALSE])
fg_fit <- crr(ftime=cr_data$time, fstatus=cr_data$cause,
              cov1=cov_matrix, failcode=1, cencode=0)

cat("\nFine-Gray model (cause 1 = relapse):\n")
print(summary(fg_fit))

gamma_group <- fg_fit$coef["group"]
shr         <- exp(gamma_group)
cat(sprintf("\nSub-distribution HR (group, cause 1): exp(gamma) = %.3f\n", shr))
cat(sprintf("Group 1 has %.0f%% %s subdistribution hazard of relapse vs group 0.\n",
            abs((shr-1)*100), ifelse(shr>1,"higher","lower")))
# Interpretation: reduced-intensity conditioning lowers TRM (cause 2), so more
# patients remain in the risk set to potentially relapse — this can raise the
# CIF for relapse even if the cause-specific hazard for relapse is similar.
# The Fine-Gray model captures this net effect on the CIF directly.

# ============================================================
# Task 4: 3-state multi-state model
# ============================================================
tmat <- transMat(x=list(c(2,3), c(3), c()),
                 names=c("Healthy","Relapse","Dead"))
cat("\nTransition matrix:\n")
print(tmat)

ms_rows <- lapply(1:nrow(cr_data), function(i) {
  row <- cr_data[i,]
  if (row$cause == 0) {
    data.frame(id=row$id, from=c(1,1), to=c(2,3), trans=c(1,2),
               Tstart=0, Tstop=row$time, status=c(0,0), group=row$group)
  } else if (row$cause == 1) {
    data.frame(id=row$id, from=c(1,1,2), to=c(2,3,3), trans=c(1,2,3),
               Tstart=c(0,0,row$time), Tstop=c(row$time, row$time, row$time+1),
               status=c(1,0,0), group=row$group)
  } else {
    data.frame(id=row$id, from=c(1,1), to=c(2,3), trans=c(1,2),
               Tstart=0, Tstop=row$time, status=c(0,1), group=row$group)
  }
}) |> bind_rows()

cox_ms <- coxph(Surv(Tstart, Tstop, status) ~ group + strata(trans),
                data=ms_rows, id=id)
cat("\nMulti-state Cox (stratified by transition):\n")
print(summary(cox_ms))

bh_ms <- basehaz(cox_ms, centered=FALSE)
cat("\nBaseline cumulative hazard (first 12 rows):\n")
print(head(bh_ms, 12))

cat("\n--- Summary ---\n")
cat("The multi-state model Q matrix is the generator matrix from Module 2.\n")
cat("Transition intensities (q_sr) correspond to cause-specific hazards.\n")
cat("The Kolmogorov forward equations dP/dt = P*Q give transition probabilities.\n")
cat("This closes the loop between Arc 1 (stochastic processes) and Arc 2 (survival).\n")
