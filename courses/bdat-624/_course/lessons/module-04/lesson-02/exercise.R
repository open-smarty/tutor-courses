# Required packages
library(ggplot2)
library(dplyr)

# Scenario: Chemotherapy-induced cancer cell death modelled as a pure death process.
# N0 = 200 cancer cells; individual death rate mu = 0.5 per cell per day.
# The pure death process gives N(t) ~ Binomial(N0, exp(-mu*t)).

N0  <- 200     # initial number of cancer cells
mu  <- 0.5     # individual death rate per day

# ============================================================
# Task 1: Theoretical Binomial distribution at specified times
# ============================================================
t_obs <- c(1, 3, 5, 8)

# TODO: For each t in t_obs, compute P_n(t) = C(N0,n)*p^n*(1-p)^(N0-n)
# where p = exp(-mu*t). Use dbinom() in R.
# Store in a long-format data frame: columns n, t, prob

theoretical_df <- lapply(t_obs, function(t) {
  p_t <- exp(-mu * t)
  n_range <- 0:N0
  data.frame(
    n       = n_range,
    t       = t,
    prob    = dbinom(n_range, size = N0, prob = p_t),
    t_label = paste0("t = ", t, " days")
  )
}) |> bind_rows()

# TODO: For each t, print: E[N(t)] = N0*p_t and Var[N(t)] = N0*p_t*(1-p_t)
cat("Theoretical mean and variance:\n")
for (t in t_obs) {
  p_t <- exp(-mu * t)
  cat(sprintf("  t=%d: E[N(t)]=%.2f, Var[N(t)]=%.2f, SD=%.2f\n",
              t, N0*p_t, N0*p_t*(1-p_t), sqrt(N0*p_t*(1-p_t))))
}

# TODO: Plot bar charts of the Binomial PMF at each time
# Facet by t. Only show n-values near the mean (focus: n from 0 to N0).
ggplot(theoretical_df |> filter(prob > 0.001), aes(x = n, y = prob, fill = factor(t))) +
  geom_col(alpha = 0.8) +
  facet_wrap(~ t_label, scales = "free") +
  labs(
    title   = "Pure Death Process: N(t) ~ Binomial(N0, exp(-mu*t))",
    subtitle = paste0("N0 = ", N0, ", mu = ", mu, " per day"),
    x = "Surviving cells n", y = "Probability", fill = "Day"
  ) +
  theme_minimal()

# ============================================================
# Task 2: Gillespie simulation of the pure death process
# ============================================================
simulate_death <- function(N0, mu, T_max) {
  times <- c(0)
  pops  <- c(N0)
  n     <- N0
  t     <- 0
  while (n > 0 && t < T_max) {
    # Rate of next death = n * mu
    rate <- n * mu
    wait <- rexp(1, rate = rate)
    t    <- t + wait
    if (t > T_max) break
    n    <- n - 1
    times <- c(times, t)
    pops  <- c(pops,  n)
  }
  data.frame(time = times, pop = pops)
}

# TODO: Simulate 5 trajectories up to T_max = 15 days
set.seed(111)
T_max  <- 15
n_traj <- 5

traj_list <- lapply(seq_len(n_traj), function(i) {
  sim <- simulate_death(N0, mu, T_max)
  sim$sim_id <- i
  sim
})
traj_all <- bind_rows(traj_list)

# Theoretical mean decay curve
t_seq   <- seq(0, T_max, by = 0.05)
mean_df <- data.frame(t = t_seq, mean_pop = N0 * exp(-mu * t_seq))

# TODO: Plot trajectories as step functions with theoretical mean overlaid
ggplot(traj_all, aes(x = time, y = pop, group = sim_id, color = factor(sim_id))) +
  geom_step(linewidth = 0.8, alpha = 0.8) +
  geom_line(data = mean_df, aes(x = t, y = mean_pop),
            inherit.aes = FALSE, color = "black", linewidth = 1.5, linetype = "dashed") +
  labs(
    title    = "Pure Death Process: 5 Trajectories (Gillespie Algorithm)",
    subtitle = "Dashed black = theoretical mean E[N(t)] = N0 * exp(-mu*t)",
    x = "Day", y = "Surviving cells N(t)", color = "Simulation"
  ) +
  theme_minimal()

# ============================================================
# Task 3: Compare simulated distribution to Binomial at t=3
# ============================================================
set.seed(222)
n_sim   <- 1000
t_check <- 3

# TODO: Simulate n_sim death processes and record N(t_check)
N_at_3 <- replicate(n_sim, tail(simulate_death(N0, mu, t_check)$pop, 1))

# Theoretical Binomial
p_t3    <- exp(-mu * t_check)
n_range <- 0:N0

# TODO: Compare empirical frequency vs dbinom()
emp_freq   <- tabulate(N_at_3 + 1, nbins = N0 + 1) / n_sim  # +1 for 0-indexing
theo_probs <- dbinom(n_range, size = N0, prob = p_t3)

# Focus on the plausible range
n_show <- which(theo_probs > 0.001) - 1  # back to 0-indexed
comp_df <- data.frame(
  n           = n_show,
  empirical   = emp_freq[n_show + 1],
  theoretical = theo_probs[n_show + 1]
) |>
  tidyr::pivot_longer(c(empirical, theoretical), names_to = "source", values_to = "prob")

ggplot(comp_df, aes(x = n, y = prob, fill = source)) +
  geom_col(position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c(empirical = "#3498db", theoretical = "#e74c3c")) +
  labs(
    title  = paste0("N(t=", t_check, "): Simulation vs Binomial(", N0, ", ", round(p_t3,3), ")"),
    x = "Surviving cells", y = "Probability", fill = "Source"
  ) +
  theme_minimal()

# ============================================================
# Task 4: Extinction time distribution
# ============================================================
# Extinction time = time when last cell dies = max of N0 Exp(mu) lifetimes
# CDF: P(T_ext <= t) = (1 - exp(-mu*t))^N0

# TODO: Simulate 500 complete death processes (run until N=0) and
# record the extinction time (the last event time before N=0).
set.seed(333)
T_ext_sims <- replicate(500, {
  sim <- simulate_death(N0, mu, T_max = 100)
  # The extinction time is the last event before N=0
  tail(sim$time, 1)
})

# TODO: Plot histogram of extinction times with the theoretical
# PDF f_T(t) = N0 * mu * exp(-mu*t) * (1-exp(-mu*t))^(N0-1) overlaid
t_ext_range <- seq(min(T_ext_sims)*0.8, max(T_ext_sims)*1.1, length.out=200)
f_T_ext <- N0 * mu * exp(-mu * t_ext_range) * (1 - exp(-mu * t_ext_range))^(N0-1)
f_df    <- data.frame(t=t_ext_range, f=f_T_ext)

ggplot(data.frame(T_ext=T_ext_sims), aes(x=T_ext)) +
  geom_histogram(aes(y=after_stat(density)), bins=30,
                 fill="#9b59b6", alpha=0.7, color="white") +
  geom_line(data=f_df, aes(x=t, y=f), color="#e74c3c", linewidth=1.3) +
  labs(
    title    = "Extinction Time Distribution: Simulation vs Theory",
    subtitle = paste0("N0=", N0, ", mu=", mu, "; red = theoretical PDF"),
    x = "Extinction time (days)", y = "Density"
  ) +
  theme_minimal()

# Theoretical expected extinction time: (1/mu) * H_{N0}
H_N0 <- sum(1 / (1:N0))
E_T_ext_theo <- H_N0 / mu
cat(sprintf("\nExpected extinction time: theoretical = %.4f days, simulated = %.4f days\n",
            E_T_ext_theo, mean(T_ext_sims)))
