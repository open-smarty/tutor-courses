# SOLUTION: Module 04 Lesson 02 — Pure Death Process
library(ggplot2)
library(dplyr)

N0 <- 200; mu <- 0.5
t_obs <- c(1, 3, 5, 8)

# ============================================================
# Task 1: Theoretical Binomial PMF
# ============================================================
theoretical_df <- lapply(t_obs, function(t) {
  p_t <- exp(-mu*t)
  nv  <- 0:N0
  data.frame(n=nv, t=t, prob=dbinom(nv, N0, p_t), t_label=paste0("t=",t," days"))
}) |> bind_rows()

cat("Mean and variance:\n")
for (t in t_obs) {
  p_t <- exp(-mu*t)
  cat(sprintf("  t=%d: E=%.2f Var=%.2f SD=%.2f\n",
              t, N0*p_t, N0*p_t*(1-p_t), sqrt(N0*p_t*(1-p_t))))
}

p1 <- ggplot(theoretical_df |> filter(prob > 0.001), aes(x=n, y=prob, fill=factor(t))) +
  geom_col(alpha=0.8) +
  facet_wrap(~t_label, scales="free") +
  scale_fill_brewer(palette="Reds") +
  labs(title="Pure Death: N(t) ~ Binomial(N0, exp(-mu*t))",
       subtitle=paste0("N0=",N0,", mu=",mu),
       x="Surviving cells", y="Probability", fill="Day") +
  theme_minimal(base_size=12)
print(p1)

# ============================================================
# Tasks 2 & 3: Gillespie + distribution comparison
# ============================================================
simulate_death <- function(N0, mu, T_max) {
  times <- c(0); pops <- c(N0); n <- N0; t <- 0
  while (n > 0 && t < T_max) {
    wait <- rexp(1, rate=n*mu); t <- t+wait
    if (t > T_max) break
    n <- n-1; times <- c(times,t); pops <- c(pops,n)
  }
  data.frame(time=times, pop=pops)
}

set.seed(111)
T_max <- 15
traj_all <- bind_rows(lapply(1:5, function(i) {
  sim <- simulate_death(N0, mu, T_max); sim$sim_id <- i; sim
}))

t_seq <- seq(0, T_max, by=0.05)
mean_df <- data.frame(t=t_seq, mean_pop=N0*exp(-mu*t_seq))

p2 <- ggplot(traj_all, aes(x=time, y=pop, group=sim_id, color=factor(sim_id))) +
  geom_step(linewidth=0.8, alpha=0.8) +
  geom_line(data=mean_df, aes(x=t, y=mean_pop), inherit.aes=FALSE,
            color="black", linewidth=1.5, linetype="dashed") +
  labs(title="Pure Death Process: 5 Trajectories",
       subtitle="Dashed = E[N(t)] = N0 * exp(-mu*t)",
       x="Day", y="Surviving cells", color="Simulation") +
  theme_minimal(base_size=12)
print(p2)

set.seed(222)
N_at_3 <- replicate(1000, tail(simulate_death(N0, mu, 3)$pop, 1))
p_t3   <- exp(-mu*3)
n_show <- 100:175  # focus on plausible range
comp_df <- data.frame(
  n=n_show,
  empirical   = tabulate(N_at_3+1, nbins=N0+1)[n_show+1] / 1000,
  theoretical = dbinom(n_show, N0, p_t3)
) |> tidyr::pivot_longer(c(empirical,theoretical), names_to="source", values_to="prob")

p3 <- ggplot(comp_df, aes(x=n, y=prob, fill=source)) +
  geom_col(position="dodge", alpha=0.8) +
  scale_fill_manual(values=c(empirical="#3498db", theoretical="#e74c3c")) +
  labs(title=paste0("N(t=3): Simulation vs Binomial(",N0,",",round(p_t3,3),")"),
       x="Surviving cells", y="Probability", fill="Source") +
  theme_minimal(base_size=12)
print(p3)

# ============================================================
# Task 4: Extinction time
# ============================================================
set.seed(333)
T_ext_sims <- replicate(500, tail(simulate_death(N0, mu, 100)$time, 1))

t_ext_r <- seq(min(T_ext_sims)*0.8, max(T_ext_sims)*1.1, length.out=200)
f_T <- N0*mu*exp(-mu*t_ext_r)*(1-exp(-mu*t_ext_r))^(N0-1)

p4 <- ggplot(data.frame(T_ext=T_ext_sims), aes(x=T_ext)) +
  geom_histogram(aes(y=after_stat(density)), bins=30,
                 fill="#9b59b6", alpha=0.7, color="white") +
  geom_line(data=data.frame(t=t_ext_r, f=f_T), aes(x=t, y=f),
            color="#e74c3c", linewidth=1.3) +
  labs(title="Extinction Time Distribution",
       subtitle=paste0("N0=",N0,", mu=",mu,"; red = theoretical PDF"),
       x="Days until last cell dies", y="Density") +
  theme_minimal(base_size=12)
print(p4)

H_N0 <- sum(1/(1:N0))
cat(sprintf("\nExpected extinction time: theoretical = %.3f days, simulated = %.3f days\n",
            H_N0/mu, mean(T_ext_sims)))
# Note: H_200 ≈ 5.88, so E[T_ext] ≈ 5.88/0.5 ≈ 11.76 days
# Individual expected lifetime = 1/mu = 2 days — extinction takes ~6x longer
# due to the "last survivor" needing to outlive all others.
