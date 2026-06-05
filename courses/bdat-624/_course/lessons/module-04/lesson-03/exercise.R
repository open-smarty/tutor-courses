# Required packages
library(ggplot2)
library(dplyr)

# Scenario: An epidemic is seeded with 1 infectious individual.
# We model spread using a birth-death process with:
#   Birth (new infections) rate lambda_n = n * lambda (each case infects others)
#   Death (recovery/isolation) rate mu_n = n * mu  (each case recovers)
# Compare outcomes for rho = mu/lambda = 0.5, 1.0, 1.5.

# ============================================================
# Task 1: Theoretical extinction probabilities
# ============================================================
# q = min(1, mu/lambda) when starting from 1 individual
# q = min(1, rho)^n0   when starting from n0 individuals

lambda_vals <- c(2, 1, 2)
mu_vals     <- c(1, 1, 3)
rho_vals    <- mu_vals / lambda_vals  # 0.5, 1.0, 1.5
labels      <- paste0("rho = ", rho_vals)

cat("Theoretical extinction probabilities (from 1 individual):\n")
for (i in seq_along(rho_vals)) {
  q_theo <- min(1, rho_vals[i])
  cat(sprintf("  lambda=%.0f, mu=%.0f, rho=%.1f: q* = %.4f\n",
              lambda_vals[i], mu_vals[i], rho_vals[i], q_theo))
}

# ============================================================
# Task 2: Simulate birth-death process (Gillespie)
# ============================================================
# Function: simulate one birth-death process trajectory
# Returns: data frame of (time, population) pairs
simulate_bd <- function(lambda, mu, T_max, n0 = 1) {
  times <- c(0); pops <- c(n0); n <- n0; t <- 0
  while (n > 0 && t < T_max) {
    # Total rate = birth rate + death rate = n*(lambda + mu)
    total_rate <- n * (lambda + mu)
    wait       <- rexp(1, rate = total_rate)
    t          <- t + wait
    if (t > T_max) break
    # Decide: birth or death?
    # P(birth) = lambda/(lambda+mu), P(death) = mu/(lambda+mu)
    if (runif(1) < lambda / (lambda + mu)) {
      n <- n + 1   # birth
    } else {
      n <- n - 1   # death
    }
    times <- c(times, t); pops <- c(pops, n)
  }
  data.frame(time = times, pop = pops)
}

# TODO: Simulate 500 trajectories for each (lambda, mu) pair
# Use T_max = 20 and record whether the process goes extinct (n=0)
set.seed(2024)
n_sim  <- 500
T_max  <- 20

results_list <- lapply(seq_along(rho_vals), function(i) {
  lam <- lambda_vals[i]; mu_i <- mu_vals[i]; rho <- rho_vals[i]
  extinct_by_t <- matrix(NA, nrow = n_sim, ncol = T_max + 1)
  final_pops <- numeric(n_sim)

  for (sim in seq_len(n_sim)) {
    traj <- simulate_bd(lam, mu_i, T_max)
    final_pops[sim] <- tail(traj$pop, 1)
    # Record whether extinct at each integer time
    for (t_int in 0:T_max) {
      # Find population just before or at time t_int
      idx <- max(which(traj$time <= t_int), na.rm=TRUE)
      if (length(idx) == 0 || is.na(idx)) {
        extinct_by_t[sim, t_int+1] <- 0
      } else {
        extinct_by_t[sim, t_int+1] <- as.integer(traj$pop[idx] == 0)
      }
    }
  }
  list(lam=lam, mu=mu_i, rho=rho, final_pops=final_pops,
       extinct_by_t=extinct_by_t, label=labels[i])
})

# ============================================================
# Task 3: Compute empirical extinction probability over time
# ============================================================
cat("\nEmpirical extinction probabilities at T_max=20:\n")
ext_df_all <- lapply(results_list, function(res) {
  ext_prob_t <- colMeans(res$extinct_by_t)
  final_ext  <- mean(res$final_pops == 0)
  cat(sprintf("  rho=%.1f: P(extinct by T=20) = %.4f (theoretical = %.4f)\n",
              res$rho, final_ext, min(1, res$rho)))
  data.frame(t     = 0:T_max,
             p_ext = ext_prob_t,
             rho   = res$rho,
             label = res$label)
}) |> bind_rows()

# TODO: Plot extinction probability over time for all three rho values
# Add horizontal dashed lines at theoretical q* = min(1, rho)
ggplot(ext_df_all, aes(x=t, y=p_ext, color=factor(rho), group=factor(rho))) +
  geom_line(linewidth=1.2) +
  geom_hline(data=data.frame(rho=rho_vals, q=pmin(1, rho_vals)),
             aes(yintercept=q, color=factor(rho)), linetype="dashed") +
  labs(
    title    = "Empirical P(Extinction by time t) for Birth-Death Process",
    subtitle = "Dashed = theoretical ultimate extinction probability",
    x = "Time t", y = "P(Extinct by t)", color = "rho = mu/lambda"
  ) +
  theme_minimal()

# ============================================================
# Task 4: Simulate sample trajectories and plot
# ============================================================
# Plot 3 example trajectories per rho value
set.seed(42)
traj_examples <- lapply(seq_along(rho_vals), function(i) {
  lapply(1:3, function(j) {
    traj <- simulate_bd(lambda_vals[i], mu_vals[i], T_max)
    traj$rho    <- rho_vals[i]
    traj$sim_id <- j
    traj$label  <- labels[i]
    traj
  }) |> bind_rows()
}) |> bind_rows()

# TODO: Plot step trajectories, faceted by rho value
ggplot(traj_examples, aes(x=time, y=pop, group=sim_id, color=factor(sim_id))) +
  geom_step(linewidth=0.8, alpha=0.9) +
  facet_wrap(~ label) +
  labs(
    title = "Birth-Death Process Trajectories for rho = 0.5, 1.0, 1.5",
    x = "Time", y = "Population size N(t)", color = "Replicate"
  ) +
  theme_minimal()

# ============================================================
# Task 5: Extinction probability as function of rho (theoretical)
# ============================================================
# Plot q* = min(1, rho) vs rho for rho in [0, 2], starting from 1, 3, 5 individuals

rho_grid <- seq(0, 2, by = 0.01)
n0_vals  <- c(1, 3, 5)

q_theory <- lapply(n0_vals, function(n0) {
  q_vals <- pmin(1, rho_grid)^n0
  data.frame(rho=rho_grid, q=q_vals, n0=paste0("n0 = ", n0))
}) |> bind_rows()

ggplot(q_theory, aes(x=rho, y=q, color=n0, group=n0)) +
  geom_line(linewidth=1.2) +
  geom_vline(xintercept=1, linetype="dashed", color="grey50") +
  annotate("text", x=1.05, y=0.5, label="rho = 1\n(threshold)", hjust=0, size=3.5) +
  labs(
    title    = "Extinction Probability q* = min(1, rho)^n0 vs Death-to-Birth Ratio",
    subtitle = "Left of rho=1: births dominate; Right: deaths dominate (certain extinction)",
    x = "rho = mu/lambda", y = "Extinction probability q*", color = "Starting size"
  ) +
  theme_minimal()
