# BDAT 624 — Module 4, Lesson 1: The Pure Birth Process (Yule Model)
# Exercise: simulate the Yule process and verify the negative binomial distribution
#
# Instructions: fill in every # TODO: marker.
# Run: npm run check -- bdat-624 module-04 lesson-01
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# Parameters ----------------------------------------------------------------
lambda  <- 0.5    # per-individual birth rate
j       <- 1      # initial population X(0)
t_end   <- 10     # simulation horizon (time units)
n_sims  <- 100    # number of independent trajectories
t_check <- 6      # time point for distribution check

# ---------------------------------------------------------------------------
# Part 1: Simulate n_sims Yule process trajectories
# Algorithm:
#   While current time < t_end:
#     Draw next inter-event time: Exp(rate = n * lambda)  (n = current population)
#     Advance time and increment population by 1
# Store each trajectory as a data frame with columns: sim, time, population
# ---------------------------------------------------------------------------

simulate_yule <- function(lambda, j, t_end) {
  # TODO: initialise t = 0, n = j, and two vectors: times = c(0), pops = c(j)
  t   <- 0
  n   <- j
  times <- c(0)
  pops  <- c(j)

  while (t < t_end) {
    # TODO: draw the waiting time until the next birth
    #   Hint: rexp(1, rate = n * lambda)
    dt <- # TODO

    t <- t + dt
    if (t >= t_end) break

    # TODO: a birth occurs — increment the population
    n <- # TODO

    times <- c(times, t)
    pops  <- c(pops, n)
  }
  # Append a final record at t_end so all trajectories end at the same time
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

# Run all simulations and combine into one data frame
all_sims <- bind_rows(
  lapply(1:n_sims, function(i) {
    df <- simulate_yule(lambda, j, t_end)
    df$sim <- i
    df
  })
)

# ---------------------------------------------------------------------------
# Part 2: Plot trajectories with mean and theoretical E[X(t)] = j * exp(lambda * t)
# ---------------------------------------------------------------------------

# Compute the empirical mean at a fine grid of time points
t_grid  <- seq(0, t_end, length.out = 200)

# For each t in t_grid, find the population for each simulation at that time.
# Use a step-function lookup: for sim i, the population at time t is the
# value just before the next recorded event.
get_pop_at <- function(sim_df, t_query) {
  # TODO: return the population at time t_query for this simulation
  #   Hint: use max(sim_df$population[sim_df$time <= t_query])
  #         but be careful when t_query < the first event time
  # TODO
}

# Build a matrix: rows = t_grid points, cols = simulations
pop_matrix <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  # TODO: call get_pop_at for each t in t_grid
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})

emp_mean <- rowMeans(pop_matrix)          # empirical mean at each t_grid point
theo_mean <- j * exp(lambda * t_grid)     # theoretical E[X(t)]

# Build data frames for ggplot
traj_df  <- all_sims
mean_df  <- data.frame(time = t_grid, emp_mean = emp_mean, theo_mean = theo_mean)

# TODO: produce the trajectory plot
# - grey lines for each simulation trajectory (use geom_step)
# - red line for empirical mean
# - blue dashed line for theoretical E[X(t)]
# - label axes and add a title
p1 <- ggplot() +
  # TODO: add grey trajectories (alpha = 0.2)
  # TODO: add red empirical mean line
  # TODO: add blue dashed theoretical mean line
  labs(
    title = "Yule Process: 100 Simulated Trajectories",
    subtitle = paste0("lambda = ", lambda, ", X(0) = ", j),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 3: Distribution of X(t_check) vs theoretical NegBin PMF
# ---------------------------------------------------------------------------

# Extract population at t = t_check for each simulation
x_at_check <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  # TODO: use get_pop_at to find the population at t_check
  # TODO
})

# Theoretical: X(t) | X(0) = j ~ NegBin(j, p) where p = exp(-lambda * t_check)
p_negbin <- exp(-lambda * t_check)

# Compute theoretical PMF over the observed range
x_range  <- min(x_at_check):max(x_at_check)
# TODO: compute theo_pmf using dnbinom(x_range - j, size = j, prob = p_negbin)
#   Note: in R's dnbinom, 'x' is the number of failures before the j-th success.
#   Our X(t) = j + failures, so failures = X(t) - j = x_range - j.
theo_pmf <- # TODO

dist_df  <- data.frame(x = x_at_check)
theo_df  <- data.frame(x = x_range, pmf = theo_pmf)

# TODO: produce the distribution plot
# - histogram (or bar chart) of simulated X(t_check)
# - overlay the theoretical NegBin PMF as red points/line
p2 <- ggplot(dist_df, aes(x = x)) +
  # TODO: geom_bar with frequency / n_sims to get proportions
  # TODO: overlay theo_df PMF
  labs(
    title = paste0("Distribution of X(", t_check, ") across ", n_sims, " simulations"),
    subtitle = paste0("Theoretical: NegBin(j=", j, ", p=", round(p_negbin, 3), ")"),
    x = paste0("X(", t_check, ")"), y = "Proportion"
  ) +
  theme_minimal()

print(p2)

# ---------------------------------------------------------------------------
# Part 4: Verify E[X(t)] ≈ j * exp(lambda * t) at several time points
# ---------------------------------------------------------------------------

check_times <- c(2, 4, 6, 8)

for (tc in check_times) {
  # TODO: compute the empirical mean of X(tc) across all simulations
  emp  <- mean(sapply(1:n_sims, function(i) {
    sim_df <- all_sims[all_sims$sim == i, ]
    get_pop_at(sim_df, tc)
  }))
  theo <- j * exp(lambda * tc)
  cat(sprintf("t = %2d | E[X(t)] empirical = %6.2f | theoretical = %6.2f\n",
              tc, emp, theo))
}

# ---------------------------------------------------------------------------
# Part 5: Effect of doubling lambda
# ---------------------------------------------------------------------------

lambda2 <- 2 * lambda   # doubled birth rate

# TODO: simulate n_sims trajectories with lambda2 (reuse simulate_yule)
all_sims2 <- # TODO

# TODO: compute the empirical mean for lambda2 simulations at t_grid
pop_matrix2 <- # TODO
emp_mean2   <- # TODO
theo_mean2  <- j * exp(lambda2 * t_grid)

# TODO: plot both mean trajectories on one graph
#   - label which is lambda and which is lambda2
p3 <- ggplot() +
  # TODO: add lines for both lambda and lambda2 means (empirical and theoretical)
  labs(
    title = "Effect of doubling lambda on mean Yule trajectory",
    x = "Time", y = "E[X(t)]"
  ) +
  theme_minimal()

print(p3)
