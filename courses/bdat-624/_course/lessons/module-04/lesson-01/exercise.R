# Required packages
library(ggplot2)
library(dplyr)

# Scenario: Bacterial cell division modelled as a Yule (pure birth) process.
# Each cell divides independently at rate lambda per hour. Starting from 1 cell.

lambda <- 0.3   # birth rate per cell per hour
t_obs  <- c(1, 2, 5, 10)  # observation times of interest

# ============================================================
# Task 1: Compute the theoretical Geometric distribution at each time
# ============================================================
# P_n(t) = exp(-lambda*t) * (1 - exp(-lambda*t))^(n-1), n >= 1

# TODO: For each t in t_obs, compute P_n(t) for n = 1, 2, ..., 30
# and store in a long-format data frame: columns n, t, prob

max_n <- 30

theoretical_df <- lapply(t_obs, function(t) {
  p_t  <- exp(-lambda * t)
  n_vals <- 1:max_n
  prob <- p_t * (1 - p_t)^(n_vals - 1)
  data.frame(n = n_vals, t = t, prob = prob,
             t_label = paste0("t = ", t, " hr"))
}) |> bind_rows()

# TODO: Print E[N(t)] = exp(lambda*t) for each t and compare to
# the weighted mean of the theoretical distribution
cat("Theoretical mean E[N(t)] = exp(lambda*t):\n")
for (t in t_obs) {
  p_t    <- exp(-lambda * t)
  n_vals <- 1:max_n
  emp_mean <- sum(n_vals * p_t * (1 - p_t)^(n_vals - 1))
  cat(sprintf("  t=%.0f: exp(lambda*t)=%.4f, weighted_mean=%.4f\n",
              t, exp(lambda * t), emp_mean))
}

# TODO: Plot the theoretical PMF at each time point (bar chart)
# Facet by t. Colour bars by t for visual distinction.
ggplot(theoretical_df, aes(x = n, y = prob, fill = factor(t))) +
  geom_col(alpha = 0.8) +
  facet_wrap(~ t_label, scales = "free_y") +
  labs(
    title  = "Yule Process: Theoretical PMF P_n(t) = Geometric(e^{-lambda*t})",
    subtitle = paste("lambda =", lambda, "per cell per hour; starting from 1 cell"),
    x = "Population size n", y = "Probability P_n(t)", fill = "Time (hr)"
  ) +
  theme_minimal()

# ============================================================
# Task 2: Gillespie algorithm simulation of the Yule process
# ============================================================
# Function: simulate one Yule process trajectory up to time T_max
# Returns: a data frame with columns time and population

simulate_yule <- function(lambda, T_max, n0 = 1) {
  times <- c(0)
  pops  <- c(n0)
  n     <- n0
  t     <- 0
  while (t < T_max) {
    # Rate of next birth = n * lambda (all n individuals contribute)
    rate     <- n * lambda
    # Wait time until next birth ~ Exp(rate)
    wait     <- rexp(1, rate = rate)
    t        <- t + wait
    if (t > T_max) break
    n        <- n + 1
    times    <- c(times, t)
    pops     <- c(pops, n)
  }
  data.frame(time = times, pop = pops)
}

# TODO: Simulate 5 independent trajectories up to T_max = 15 hours
set.seed(123)
T_max <- 15
n_traj <- 5

traj_list <- lapply(seq_len(n_traj), function(i) {
  sim <- simulate_yule(lambda, T_max)
  sim$sim_id <- i
  sim
})
traj_all <- bind_rows(traj_list)

# TODO: Plot all 5 trajectories as step functions (geom_step).
# Overlay the theoretical mean E[N(t)] = exp(lambda*t) as a smooth red curve.
t_seq <- seq(0, T_max, length.out = 300)
mean_df <- data.frame(t = t_seq, mean_pop = exp(lambda * t_seq))

ggplot(traj_all, aes(x = time, y = pop, group = sim_id, color = factor(sim_id))) +
  geom_step(linewidth = 0.8, alpha = 0.8) +
  geom_line(data = mean_df, aes(x = t, y = mean_pop),
            inherit.aes = FALSE, color = "black", linewidth = 1.5, linetype = "dashed") +
  labs(
    title    = "Yule Process: 5 Simulated Trajectories",
    subtitle = "Dashed black = theoretical mean E[N(t)] = exp(lambda*t)",
    x = "Time (hours)", y = "Population size N(t)", color = "Simulation"
  ) +
  theme_minimal()

# ============================================================
# Task 3: Compare simulated distribution to theory at t=5
# ============================================================
# Simulate n_sim replicates; record N(5) for each

set.seed(456)
n_sim <- 2000
t_check <- 5

# TODO: Simulate n_sim Yule processes and record the population at t=t_check
N_at_t <- replicate(n_sim, {
  sim <- simulate_yule(lambda, t_check)
  tail(sim$pop, 1)
})

# Theoretical distribution at t=t_check
p_t5 <- exp(-lambda * t_check)
n_range <- 1:50
theo_probs <- p_t5 * (1 - p_t5)^(n_range - 1)

# TODO: Create a comparison data frame and plot side-by-side bars
# (empirical frequency vs theoretical probability)
emp_freq <- tabulate(N_at_t, nbins = max(n_range)) / n_sim

comparison_df <- data.frame(
  n          = n_range,
  empirical  = emp_freq[n_range],
  theoretical = theo_probs
) |>
  tidyr::pivot_longer(cols = c(empirical, theoretical),
                      names_to = "source", values_to = "prob")

ggplot(comparison_df, aes(x = n, y = prob, fill = source)) +
  geom_col(position = "dodge", alpha = 0.8) +
  xlim(0, 30) +
  labs(
    title    = paste0("N(t=", t_check, ") Distribution: Simulation vs Geometric Theory"),
    subtitle = paste0("p(t) = exp(-lambda*t) = ", round(p_t5, 4),
                      "; n_sim = ", n_sim),
    x = "Population size", y = "Probability", fill = "Source"
  ) +
  theme_minimal()

# ============================================================
# Task 4: Mean and variance over time
# ============================================================
# Simulate many trajectories and compute E[N(t)] and Var[N(t)] at each t
set.seed(789)
n_sim_mv <- 1000
t_check_seq <- seq(0, 10, by = 1)

# TODO: For each t in t_check_seq, simulate n_sim_mv trajectories
# and compute the empirical mean and variance of N(t)
mv_df <- lapply(t_check_seq, function(t) {
  if (t == 0) return(data.frame(t=0, sim_mean=1, sim_var=0,
                                 theo_mean=1, theo_var=0))
  N_t <- replicate(n_sim_mv, tail(simulate_yule(lambda, t)$pop, 1))
  data.frame(
    t         = t,
    sim_mean  = mean(N_t),
    sim_var   = var(N_t),
    theo_mean = exp(lambda * t),
    theo_var  = exp(lambda*t) * (exp(lambda*t) - 1)
  )
}) |> bind_rows()

cat("\nMean and Variance comparison (simulated vs theoretical):\n")
print(round(mv_df, 3))

# TODO: Plot simulated vs theoretical mean on log scale
ggplot(mv_df) +
  geom_point(aes(x=t, y=sim_mean, color="Simulated mean"), size=3) +
  geom_line(aes(x=t, y=theo_mean, color="Theoretical exp(lambda*t)"), linewidth=1.2) +
  scale_y_log10() +
  labs(title="E[N(t)]: Simulated vs Theoretical (log scale)",
       x="Time (hours)", y="E[N(t)] (log scale)", color="") +
  theme_minimal()
