# BDAT 624 — Module 3, Lesson 2: The Poisson Process and Renewal Counting
# Exercise: Simulation, PMF verification, memorylessness, Gamma waiting times
#
# Prerequisites: base R + ggplot2 (install with: install.packages("ggplot2"))
# Run: npm run check -- bdat-624 module-03 lesson-02

library(ggplot2)
library(gridExtra)

set.seed(123)  # reproducibility

# Parameters
lambda     <- 3       # arrivals per hour
T_total    <- 24      # total observation window (hours)
N_SIM      <- 1000    # number of replicated processes for Part 5

# ============================================================
# PART 1 — Simulate a Poisson process with rate lambda=3/hr for 24 hours
#
#   Strategy: generate interarrival times from Exp(lambda) one by one,
#   accumulating arrival times until they exceed T_total.
#   Then compute N(t) = number of arrivals in (0, t] for each hour t = 1..24.
# ============================================================

# TODO: generate interarrival times using rexp().
#   Keep drawing until the cumulative sum exceeds T_total.
#   Store cumulative arrival times in a vector `arrival_times`
#   (only include those <= T_total).
#   Hint: use a while loop or generate a large batch and trim.
arrival_times <- # TODO

# TODO: compute N(t) for each integer hour t = 1, 2, ..., 24.
#   N(t) = number of arrival_times <= t.
#   Store as vector `count_per_hour` of length 24.
hours         <- 1:24
count_per_hour <- # TODO

cat("Total arrivals in 24 hours:", length(arrival_times), "\n")
cat("Expected:", lambda * T_total, "\n")

# ============================================================
# PART 2 — Plot the count process X(t) as a step function,
#           and a histogram of hourly counts with Poisson(3) PMF overlaid.
# ============================================================

# TODO: plot the step function of X(t) = cumulative arrivals vs time.
#   The x-axis is time (0 to 24), the y-axis is X(t).
#   Use a step plot (geom_step in ggplot2, or plot(..., type="s") in base R).


# TODO: plot a histogram of `count_per_hour` (24 hourly counts).
#   Overlay the Poisson(3) PMF as points or a line.
#   Hint: dpois(0:10, lambda = lambda) gives the PMF values.


# ============================================================
# PART 3 — Verify the memoryless property
#
#   From the simulated interarrival times (differences between consecutive
#   arrivals), compare:
#   (a) the full distribution of interarrival times T
#   (b) the conditional distribution of T given T > threshold (e.g., threshold = 0.2)
#   They should look the same (both Exp(lambda)).
# ============================================================

# TODO: compute interarrival times from arrival_times (differences between
#   consecutive arrivals; the first interarrival is arrival_times[1] - 0).
#   Store as `interarrivals`.
interarrivals <- # TODO

# TODO: choose a threshold, e.g. threshold = 0.2.
#   Define conditional_times = interarrivals[interarrivals > threshold] - threshold
#   (shift by threshold so we look at REMAINING time after threshold).
threshold <- 0.2
conditional_times <- # TODO

# TODO: plot two overlaid density histograms (or two ggplot density plots):
#   one for `interarrivals`, one for `conditional_times`.
#   Overlay the Exp(lambda) density curve on both.
#   They should look essentially identical — this is the memoryless property.


# ============================================================
# PART 4 — Waiting times to the n-th event: T_n ~ Gamma(n, lambda)
#
#   For n = 1, 2, 5, 10: collect the waiting time to the n-th arrival
#   from the simulated arrival_times. Plot a histogram and overlay
#   the Gamma(n, rate = lambda) density.
# ============================================================

ns <- c(1, 2, 5, 10)

plots_part4 <- list()

for (n_evt in ns) {
  # TODO: extract the waiting time to the n_evt-th event.
  #   If there are fewer than n_evt arrivals in your single simulation,
  #   simulate more arrivals or note this edge case.
  #   For a proper comparison, simulate N_SIM processes and collect
  #   the n_evt-th arrival time from each.

  # TODO: simulate N_SIM independent sets of interarrivals and extract T_n.
  #   Hint: replicate() + cumsum() + rexp()
  waiting_times_n <- # TODO: vector of N_SIM waiting times to the n_evt-th event

  t_grid <- seq(0, quantile(waiting_times_n, 0.99), length.out = 300)
  gamma_density <- dgamma(t_grid, shape = n_evt, rate = lambda)

  df_n <- data.frame(t = waiting_times_n)
  p_n <- ggplot(df_n, aes(x = t)) +
    geom_histogram(aes(y = after_stat(density)), bins = 40,
                   fill = "steelblue", alpha = 0.6, colour = "white") +
    geom_line(data = data.frame(t = t_grid, d = gamma_density),
              aes(x = t, y = d), colour = "red", linewidth = 1) +
    labs(title = sprintf("T_%d ~ Gamma(%d, %.0f)", n_evt, n_evt, lambda),
         subtitle = "Red = theoretical Gamma density",
         x = sprintf("Time to %d-th event", n_evt), y = "Density") +
    theme_minimal()

  plots_part4[[as.character(n_evt)]] <- p_n
}

# TODO: arrange the 4 plots in a 2x2 grid using grid.arrange().


# ============================================================
# PART 5 — E[X(t)] = lambda*t vs sample mean from 1000 simulations
#
#   Simulate 1000 independent Poisson processes, each for T_total = 24 hours.
#   At each integer hour t = 1..24, compute the sample mean of X(t).
#   Plot the sample mean vs the theoretical E[X(t)] = lambda*t.
# ============================================================

# TODO: simulate N_SIM Poisson processes, each of length T_total hours.
#   For each process, compute count_per_hour (length-24 vector as in Part 1).
#   Store all as a matrix `sim_counts` of dimension 24 x N_SIM.
#   Hint: use replicate() with the same logic as Part 1.
sim_counts <- # TODO

# TODO: compute the sample mean at each hour (rowMeans of sim_counts).
sample_mean <- # TODO

# TODO: compute the theoretical mean E[X(t)] = lambda * t for t = 1..24.
theoretical_mean <- # TODO

# TODO: plot sample_mean and theoretical_mean vs hours (1..24) on the same axes.
#   Use different colours and add a legend.
#   The sample mean should track lambda*t very closely.
