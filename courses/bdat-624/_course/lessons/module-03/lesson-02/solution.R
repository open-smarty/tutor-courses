# BDAT 624 — Module 3, Lesson 2: The Poisson Process and Renewal Counting
# SOLUTION FILE — do not share with students before they attempt exercise.R

library(ggplot2)
library(gridExtra)

set.seed(123)

# Parameters
lambda     <- 3
T_total    <- 24
N_SIM      <- 1000

# ============================================================
# HELPER: simulate one Poisson process; return arrival times <= T_total
# ============================================================

simulate_poisson <- function(lambda, T_total) {
  # Draw a safe upper bound on arrivals: mean + 5 sd
  n_max       <- ceiling(lambda * T_total + 5 * sqrt(lambda * T_total))
  interarr    <- rexp(n_max, rate = lambda)
  arrivals    <- cumsum(interarr)
  arrivals[arrivals <= T_total]
}

# ============================================================
# PART 1 — Single Poisson process, hourly counts
# ============================================================

arrival_times  <- simulate_poisson(lambda, T_total)
hours          <- 1:24
count_per_hour <- sapply(hours, function(t) sum(arrival_times <= t))

cat("Total arrivals in 24 hours:", length(arrival_times), "\n")
cat("Expected (lambda*T):       ", lambda * T_total, "\n")

# ============================================================
# PART 2 — Step function plot + histogram with PMF overlay
# ============================================================

# Step function: X(t) as a function of t
x_step <- c(0, arrival_times, T_total)
y_step <- c(0, seq_along(arrival_times), length(arrival_times))

df_step <- data.frame(t = x_step, X = y_step)
p_step <- ggplot(df_step, aes(x = t, y = X)) +
  geom_step(colour = "steelblue", linewidth = 0.8) +
  labs(title = "Poisson Process X(t): single realisation",
       subtitle = sprintf("lambda = %.0f arrivals/hr, T = %d hrs", lambda, T_total),
       x = "Time (hours)", y = "X(t) = cumulative arrivals") +
  theme_minimal()
print(p_step)

# Histogram of hourly counts with Poisson(3) PMF overlaid
k_vals   <- 0:12
pmf_vals <- dpois(k_vals, lambda = lambda)
df_pmf   <- data.frame(k = k_vals, pmf = pmf_vals)

p_hist <- ggplot(data.frame(count = count_per_hour), aes(x = count)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 1,
                 fill = "steelblue", alpha = 0.6, colour = "white") +
  geom_point(data = df_pmf, aes(x = k, y = pmf), colour = "red", size = 3) +
  geom_line(data = df_pmf, aes(x = k, y = pmf), colour = "red", linewidth = 0.8) +
  labs(title = "Hourly arrival counts vs Poisson(3) PMF",
       subtitle = "Bars = empirical; red points = theoretical PMF",
       x = "Arrivals in one hour", y = "Density") +
  theme_minimal()
print(p_hist)

# ============================================================
# PART 3 — Memoryless property
# ============================================================

# Use all interarrival times from a large simulation for stability
big_arrivals  <- simulate_poisson(lambda, T_total * 10)
interarrivals <- c(big_arrivals[1], diff(big_arrivals))

threshold         <- 0.2
conditional_times <- interarrivals[interarrivals > threshold] - threshold

t_grid       <- seq(0, 2, length.out = 300)
exp_density  <- dexp(t_grid, rate = lambda)

df_mem <- rbind(
  data.frame(t = interarrivals, group = "Unconditional T"),
  data.frame(t = conditional_times, group = sprintf("T - %.1f | T > %.1f", threshold, threshold))
)

p_mem <- ggplot(df_mem, aes(x = t, fill = group)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.05,
                 alpha = 0.5, position = "identity", colour = "white") +
  geom_line(data = data.frame(t = t_grid, d = exp_density),
            aes(x = t, y = d), colour = "black", linewidth = 1, inherit.aes = FALSE) +
  coord_cartesian(xlim = c(0, 2)) +
  scale_fill_manual(values = c("steelblue", "darkorange")) +
  labs(title = "Memoryless property: unconditional vs conditional interarrivals",
       subtitle = "Black line = Exp(lambda) density; both distributions match",
       x = "Time", y = "Density", fill = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom")
print(p_mem)

# ============================================================
# PART 4 — Waiting times T_n ~ Gamma(n, lambda)
# ============================================================

ns <- c(1, 2, 5, 10)

plots_part4 <- lapply(ns, function(n_evt) {
  # Simulate N_SIM processes; take the n_evt-th arrival time from each
  waiting_times_n <- replicate(N_SIM, {
    arrivals <- rexp(n_evt + 5, rate = lambda)   # small buffer
    cumsum(arrivals)[n_evt]
  })

  t_max        <- quantile(waiting_times_n, 0.99)
  t_grid       <- seq(0, t_max, length.out = 300)
  gamma_density <- dgamma(t_grid, shape = n_evt, rate = lambda)

  ggplot(data.frame(t = waiting_times_n), aes(x = t)) +
    geom_histogram(aes(y = after_stat(density)), bins = 40,
                   fill = "steelblue", alpha = 0.6, colour = "white") +
    geom_line(data = data.frame(t = t_grid, d = gamma_density),
              aes(x = t, y = d), colour = "red", linewidth = 1) +
    labs(title = sprintf("T_%d ~ Gamma(%d, %d)", n_evt, n_evt, lambda),
         subtitle = sprintf("Mean = %.2f, Theoretical = %.2f",
                            mean(waiting_times_n), n_evt / lambda),
         x = sprintf("Time to %d-th event (hrs)", n_evt), y = "Density") +
    theme_minimal()
})

grid.arrange(grobs = plots_part4, ncol = 2,
             top = "Waiting times to n-th event: simulation vs Gamma density")

# ============================================================
# PART 5 — E[X(t)] = lambda*t vs sample mean from N_SIM processes
# ============================================================

# Simulate N_SIM processes and record hourly counts
sim_counts <- replicate(N_SIM, {
  at <- simulate_poisson(lambda, T_total)
  sapply(hours, function(t) sum(at <= t))
})
# sim_counts is 24 x N_SIM

sample_mean      <- rowMeans(sim_counts)
theoretical_mean <- lambda * hours

df_compare <- data.frame(
  t     = rep(hours, 2),
  mean  = c(sample_mean, theoretical_mean),
  type  = rep(c("Sample mean (N=1000)", sprintf("Theoretical E[X(t)] = %.0f·t", lambda)),
               each = length(hours))
)

p_mean <- ggplot(df_compare, aes(x = t, y = mean, colour = type, linetype = type)) +
  geom_line(linewidth = 1.2) +
  scale_colour_manual(values = c("Sample mean (N=1000)" = "steelblue",
                                  sprintf("Theoretical E[X(t)] = %.0f·t", lambda) = "black")) +
  labs(title = "E[X(t)] = lambda*t: theoretical vs simulated",
       subtitle = sprintf("lambda = %.0f, N_SIM = %d processes", lambda, N_SIM),
       x = "Time t (hours)", y = "Mean number of arrivals",
       colour = NULL, linetype = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom")
print(p_mean)

cat("\nAll parts complete.\n")
