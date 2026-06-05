# SOLUTION: Module 04 Lesson 01 — Pure Birth Process (Yule Model)
library(ggplot2)
library(dplyr)

lambda <- 0.3
t_obs  <- c(1, 2, 5, 10)
max_n  <- 30

# ============================================================
# Task 1: Theoretical PMF
# ============================================================
theoretical_df <- lapply(t_obs, function(t) {
  p_t  <- exp(-lambda * t)
  n_v  <- 1:max_n
  data.frame(n = n_v, t = t,
             prob = p_t * (1-p_t)^(n_v-1),
             t_label = paste0("t = ", t, " hr"))
}) |> bind_rows()

cat("Mean verification E[N(t)] = exp(lambda*t):\n")
for (t in t_obs) {
  p_t    <- exp(-lambda*t)
  n_v    <- 1:max_n
  em     <- sum(n_v * p_t * (1-p_t)^(n_v-1))
  cat(sprintf("  t=%2.0f: theoretical=%.4f, computed=%.4f\n", t, exp(lambda*t), em))
}

p1 <- ggplot(theoretical_df, aes(x=n, y=prob, fill=factor(t))) +
  geom_col(alpha=0.8, color="white", linewidth=0.2) +
  facet_wrap(~t_label, scales="free_y") +
  scale_fill_brewer(palette="Blues") +
  labs(title="Yule Process: P_n(t) = Geometric(exp(-lambda*t))",
       subtitle=paste("lambda =", lambda, "per cell per hour; n0=1"),
       x="Population size n", y="P_n(t)", fill="Time (hr)") +
  theme_minimal(base_size=12)
print(p1)

# ============================================================
# Tasks 2 & 3: Gillespie simulation
# ============================================================
simulate_yule <- function(lambda, T_max, n0=1) {
  times <- c(0); pops <- c(n0); n <- n0; t <- 0
  while (t < T_max) {
    wait <- rexp(1, rate=n*lambda)
    t    <- t + wait
    if (t > T_max) break
    n <- n + 1
    times <- c(times, t); pops <- c(pops, n)
  }
  data.frame(time=times, pop=pops)
}

set.seed(123)
T_max  <- 15
traj_all <- bind_rows(lapply(1:5, function(i) {
  sim <- simulate_yule(lambda, T_max); sim$sim_id <- i; sim
}))

t_seq   <- seq(0, T_max, length.out=300)
mean_df <- data.frame(t=t_seq, mean_pop=exp(lambda*t_seq))

p2 <- ggplot(traj_all, aes(x=time, y=pop, group=sim_id, color=factor(sim_id))) +
  geom_step(linewidth=0.8, alpha=0.8) +
  geom_line(data=mean_df, aes(x=t, y=mean_pop),
            inherit.aes=FALSE, color="black", linewidth=1.5, linetype="dashed") +
  labs(title="Yule Process: 5 Trajectories (Gillespie Algorithm)",
       subtitle="Dashed = E[N(t)] = exp(lambda*t)",
       x="Time (hours)", y="N(t)", color="Simulation") +
  theme_minimal(base_size=12)
print(p2)

# Distribution at t=5
set.seed(456)
n_sim   <- 2000; t_check <- 5
N_at_t5 <- replicate(n_sim, tail(simulate_yule(lambda, t_check)$pop, 1))

p_t5     <- exp(-lambda*t_check)
n_range  <- 1:50
theo_pr  <- p_t5*(1-p_t5)^(n_range-1)
emp_fr   <- tabulate(N_at_t5, nbins=max(n_range))/n_sim

comp_df <- data.frame(n=n_range, empirical=emp_fr[n_range], theoretical=theo_pr) |>
  tidyr::pivot_longer(c(empirical,theoretical), names_to="source", values_to="prob")

p3 <- ggplot(comp_df, aes(x=n, y=prob, fill=source)) +
  geom_col(position="dodge", alpha=0.8) +
  xlim(0, 30) +
  scale_fill_manual(values=c(empirical="#3498db", theoretical="#e74c3c")) +
  labs(title=paste0("N(t=",t_check,"): Simulation vs Geometric(p=",round(p_t5,3),")"),
       x="Population size", y="Probability", fill="Source") +
  theme_minimal(base_size=12)
print(p3)

# ============================================================
# Task 4: Mean/variance over time
# ============================================================
set.seed(789)
n_sim_mv <- 1000
t_seq2   <- seq(0, 10, by=1)

mv_df <- lapply(t_seq2, function(t) {
  if (t==0) return(data.frame(t=0,sim_mean=1,sim_var=0,theo_mean=1,theo_var=0))
  N_t <- replicate(n_sim_mv, tail(simulate_yule(lambda, t)$pop, 1))
  data.frame(t=t, sim_mean=mean(N_t), sim_var=var(N_t),
             theo_mean=exp(lambda*t), theo_var=exp(lambda*t)*(exp(lambda*t)-1))
}) |> bind_rows()

cat("\nMean/Variance (simulated vs theoretical):\n")
print(round(mv_df, 3))

p4 <- ggplot(mv_df) +
  geom_point(aes(x=t, y=sim_mean, color="Simulated"), size=3) +
  geom_line(aes(x=t, y=theo_mean, color="Theoretical"), linewidth=1.2) +
  scale_y_log10() +
  scale_color_manual(values=c("Simulated"="#3498db","Theoretical"="#e74c3c")) +
  labs(title="E[N(t)]: Simulated vs exp(lambda*t) (log scale)",
       x="Time (hours)", y="E[N(t)] log scale", color="") +
  theme_minimal(base_size=12)
print(p4)
