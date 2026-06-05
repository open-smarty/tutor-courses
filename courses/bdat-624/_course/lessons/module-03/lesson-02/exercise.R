# Required packages
library(ggplot2)
library(dplyr)

# Scenario: Emergency department patient arrivals modelled as a Poisson process.
# Lambda = 5 patients/hour. We simulate the process, verify its properties,
# and examine inter-arrival and waiting time distributions.

lambda <- 5   # patients per hour
T_max  <- 10  # observe for 10 hours
set.seed(42)

# ============================================================
# Task 1: Simulate a Poisson process via exponential inter-arrivals
# ============================================================
# The Poisson process can be simulated by drawing inter-arrival times
# from Exp(lambda) and accumulating them to get event times.

# TODO: Draw exponential inter-arrival times until the cumulative time
# exceeds T_max. Store ALL inter-arrival times in 'inter_arrivals'.
# Then compute event times as cumulative sums.

inter_arrivals <- rexp(1000, rate = lambda)  # draw more than enough
event_times    <- cumsum(inter_arrivals)
event_times    <- event_times[event_times <= T_max]  # keep only those ≤ T_max
n_events       <- length(event_times)

cat("Total events in [0,", T_max, "]:", n_events, "\n")
cat("Expected events:", lambda * T_max, "\n")

# ============================================================
# Task 2: Verify inter-arrival times are Exponential(lambda)
# ============================================================
# We use the first n_events inter-arrival times (those that correspond to
# events within [0, T_max]).
iats <- inter_arrivals[seq_len(n_events)]  # inter-arrival times used

# TODO: Plot a histogram of inter-arrival times with the theoretical
# Exp(lambda) density overlaid.
hist_df <- data.frame(iat = iats)
iat_range <- seq(0, max(iats) * 1.1, length.out = 200)
exp_density_df <- data.frame(x = iat_range, y = dexp(iat_range, rate = lambda))

ggplot(hist_df, aes(x = iat)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30,
                 fill = "#3498db", alpha = 0.7, color = "white") +
  geom_line(data = exp_density_df, aes(x = x, y = y),
            color = "#e74c3c", linewidth = 1.3) +
  labs(
    title    = "Inter-Arrival Times: Observed vs Theoretical Exp(lambda)",
    subtitle = paste("lambda =", lambda, "; red line = Exp(lambda) density"),
    x = "Inter-arrival time (hours)", y = "Density"
  ) +
  theme_minimal()

# TODO: Print mean and SD of observed inter-arrival times.
# Theoretical: mean = 1/lambda, SD = 1/lambda (Exp distribution).
cat("\nInter-arrival times:\n")
cat("  Observed mean:", round(mean(iats), 4), "\n")
cat("  Theoretical mean (1/lambda):", round(1/lambda, 4), "\n")
cat("  Observed SD:", round(sd(iats), 4), "\n")
cat("  Theoretical SD (1/lambda):", round(1/lambda, 4), "\n")

# ============================================================
# Task 3: Verify N(t) ~ Poisson(lambda*t) using simulation
# ============================================================
# Simulate many independent replications and count events in [0, t]
# for several values of t; compare to Poisson(lambda*t).

n_reps  <- 2000
t_vals  <- c(0.5, 1, 2, 5)  # time points to check

# TODO: For each t in t_vals, simulate n_reps Poisson processes and record
# the count of events in [0, t]. Compare the empirical distribution
# to Poisson(lambda * t).

verify_poisson <- function(t, n_reps, lambda) {
  counts <- replicate(n_reps, {
    # Simulate inter-arrivals until cumulative time > t
    iat  <- rexp(ceiling(lambda * t * 5), rate = lambda)  # enough draws
    et   <- cumsum(iat)
    sum(et <= t)
  })
  list(t=t, counts=counts, lambda_t=lambda*t)
}

set.seed(100)
results <- lapply(t_vals, verify_poisson, n_reps = n_reps, lambda = lambda)

# TODO: For each t, print: observed mean & variance vs Poisson(lambda*t)
# (For Poisson: mean = variance = lambda*t)
cat("\nPoisson verification (mean and variance should both equal lambda*t):\n")
for (res in results) {
  cat(sprintf("  t=%.1f: obs mean=%.3f, obs var=%.3f, theoretical=%.3f\n",
              res$t, mean(res$counts), var(res$counts), res$lambda_t))
}

# ============================================================
# Task 4: Verify n-th event time ~ Gamma(n, lambda)
# ============================================================
# The n-th event time T_n = sum of n i.i.d. Exp(lambda).
# T_n ~ Gamma(n, rate=lambda).

# TODO: For n = 3, 8, 15 simulate 5000 realisations of T_n
# by summing n exponentials. Plot histograms with Gamma density overlaid.

set.seed(200)
n_sim_gamma <- 5000
ns_to_check <- c(3, 8, 15)

gamma_df <- lapply(ns_to_check, function(n) {
  # T_n = sum of n Exp(lambda) = Gamma(shape=n, rate=lambda)
  T_n_sim <- replicate(n_sim_gamma, sum(rexp(n, rate = lambda)))
  data.frame(n = n, T_n = T_n_sim)
}) |> bind_rows()

gamma_df$n_label <- paste0("n = ", gamma_df$n)

# TODO: Plot histogram with Gamma(n, rate=lambda) density overlaid.
# Facet by n.
ggplot(gamma_df, aes(x = T_n)) +
  geom_histogram(aes(y = after_stat(density)), bins = 40,
                 fill = "#2ecc71", alpha = 0.7, color = "white") +
  stat_function(
    fun = function(x) dgamma(x, shape = 3, rate = lambda),
    aes(color = "n=3"), linewidth = 1.0, data = filter(gamma_df, n == 3)
  ) +
  facet_wrap(~ n_label, scales = "free") +
  labs(
    title    = "n-th Event Time T_n vs Gamma(n, lambda) Distribution",
    subtitle = paste("lambda =", lambda, "; green bars = simulation; curve = Gamma density"),
    x = "Time to n-th event (hours)", y = "Density"
  ) +
  theme_minimal()

# A cleaner approach: add a separate density curve per facet
ggplot(gamma_df, aes(x = T_n)) +
  geom_histogram(aes(y = after_stat(density)), bins = 40,
                 fill = "#2ecc71", alpha = 0.7, color = "white") +
  geom_line(
    data = gamma_df |>
      group_by(n, n_label) |>
      reframe(x = seq(min(T_n), max(T_n), length.out=300),
              y = dgamma(x, shape=unique(n), rate=lambda)),
    aes(x=x, y=y), color="#e74c3c", linewidth=1.2
  ) +
  facet_wrap(~ n_label, scales="free") +
  labs(title="n-th Event Waiting Time: Simulation vs Gamma(n, lambda)",
       x="Time (hours)", y="Density") +
  theme_minimal()

# TODO: Print mean and variance of T_n for each n.
# Theoretical: E[T_n] = n/lambda, Var[T_n] = n/lambda^2.
cat("\nGamma verification:\n")
for (n in ns_to_check) {
  sims <- filter(gamma_df, n == !!n)$T_n
  cat(sprintf("  n=%2d: obs mean=%.4f (theo=%.4f); obs var=%.4f (theo=%.4f)\n",
              n, mean(sims), n/lambda, var(sims), n/lambda^2))
}

# ============================================================
# Task 5: Memoryless property demonstration
# ============================================================
# The exponential distribution is memoryless: P(W > s+t | W > s) = P(W > t)
# Demonstrate: condition on W > 1 (waited more than 1 hour) and check
# that the remaining wait is still Exp(lambda).

set.seed(999)
W_sims <- rexp(100000, rate = lambda)

# TODO: Given W > 1, compute the residual waiting time W - 1
# and compare its distribution to Exp(lambda).
s_val      <- 1.0          # conditioning on W > s_val
residuals  <- (W_sims[W_sims > s_val] - s_val)

cat("\nMemoryless property check (conditioning on W > 1):\n")
cat("  Mean of residual W-1 | W>1:", round(mean(residuals), 4),
    "(should be ~", round(1/lambda, 4), ")\n")
cat("  Mean of unconditioned W:   ", round(mean(W_sims), 4), "\n")
# Both should be ~0.2 = 1/lambda
