# BDAT 624 — Module 4, Lesson 2: The Pure Death Process
# Exercise: simulate pure death processes, verify Binomial distribution
#
# Instructions: fill in every # TODO: marker.
# Run: npm run check -- bdat-624 module-04 lesson-02
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# Parameters ----------------------------------------------------------------
mu     <- 0.1    # per-individual death rate
j      <- 50     # initial population X(0)
t_end  <- 30     # simulation horizon
n_sims <- 200    # number of independent trajectories
t_check <- 10    # time point for distribution check

# ---------------------------------------------------------------------------
# Part 1: Simulate n_sims pure death process trajectories
# Algorithm:
#   While current time < t_end AND population n > 0:
#     Next event time: Exp(rate = n * mu)
#     Advance time, decrease population by 1
# ---------------------------------------------------------------------------

simulate_death <- function(mu, j, t_end) {
  # TODO: initialise t = 0, n = j, and vectors times = c(0), pops = c(j)
  t     <- 0
  n     <- j
  times <- c(0)
  pops  <- c(j)

  while (t < t_end && n > 0) {
    # TODO: draw inter-event time from Exp(n * mu)
    dt <- # TODO

    t <- t + dt
    if (t >= t_end) break

    # TODO: a death occurs — decrement population
    n <- # TODO

    times <- c(times, t)
    pops  <- c(pops, n)
  }
  # Append final record at t_end
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

# Run all simulations
all_sims <- bind_rows(
  lapply(1:n_sims, function(i) {
    df     <- simulate_death(mu, j, t_end)
    df$sim <- i
    df
  })
)

# ---------------------------------------------------------------------------
# Step-function lookup helper (same pattern as Lesson 1)
# ---------------------------------------------------------------------------

get_pop_at <- function(sim_df, t_query) {
  # TODO: return the population at time t_query using a step-function lookup
  # TODO
}

# ---------------------------------------------------------------------------
# Part 2: Trajectory plot with theoretical mean
# ---------------------------------------------------------------------------

t_grid     <- seq(0, t_end, length.out = 200)
theo_mean  <- j * exp(-mu * t_grid)       # E[X(t)] = j * exp(-mu * t)

# TODO: compute the empirical mean at each t_grid point using get_pop_at
pop_matrix <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  # TODO: apply get_pop_at over t_grid
  # TODO
})
emp_mean   <- rowMeans(pop_matrix)

mean_df <- data.frame(time = t_grid, emp_mean = emp_mean, theo_mean = theo_mean)

# TODO: produce the trajectory plot
# - grey step-function lines for all trajectories
# - red line for empirical mean
# - blue dashed line for theoretical mean
p1 <- ggplot() +
  # TODO: grey trajectories
  # TODO: red empirical mean
  # TODO: blue dashed theoretical mean
  labs(
    title    = "Pure Death Process: 200 Simulated Trajectories",
    subtitle = paste0("mu = ", mu, ", X(0) = ", j),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 3: Distribution of X(t_check) vs Binomial(j, e^{-mu*t_check})
# ---------------------------------------------------------------------------

x_at_check <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  # TODO: call get_pop_at for t_check
  # TODO
})

# Theoretical: X(t_check) ~ Binomial(j, p) where p = exp(-mu * t_check)
p_binom  <- exp(-mu * t_check)
x_range  <- 0:j
# TODO: compute theo_pmf using dbinom(x_range, size = j, prob = p_binom)
theo_pmf <- # TODO

dist_df  <- data.frame(x = x_at_check)
theo_df  <- data.frame(x = x_range, pmf = theo_pmf)

# TODO: produce the distribution plot
# - bar chart of simulated X(t_check) (as proportions)
# - overlay theoretical Binomial PMF as red points/line
p2 <- ggplot(dist_df, aes(x = x)) +
  # TODO: geom_bar (proportions)
  # TODO: overlay theo_df PMF
  labs(
    title    = paste0("Distribution of X(", t_check, ") — ", n_sims, " simulations"),
    subtitle = paste0("Theoretical: Binomial(j = ", j, ", p = ", round(p_binom, 3), ")"),
    x = paste0("X(", t_check, ")"), y = "Proportion / Probability"
  ) +
  theme_minimal()

print(p2)

# ---------------------------------------------------------------------------
# Part 4: Half-life — empirical vs analytical
# ---------------------------------------------------------------------------

# Analytical half-life
t_half_analytical <- log(2) / mu
cat(sprintf("\nAnalytical half-life: %.4f time units\n", t_half_analytical))

# Empirical: find the average time at which X(t) first falls to j/2 or below
half_times <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  # TODO: find the first time that sim_df$population <= j / 2
  #   Hint: use which() and min(sim_df$time[...])
  # TODO
})

# TODO: compute the mean empirical half-life (excluding NA if population never reaches j/2)
emp_half <- # TODO
cat(sprintf("Empirical half-life (mean time to X <= j/2): %.4f time units\n", emp_half))

# ---------------------------------------------------------------------------
# Part 5: Distribution of extinction times for three values of mu
# ---------------------------------------------------------------------------

mu_vals <- c(0.1, 0.2, 0.5)

ext_times_all <- lapply(mu_vals, function(m) {
  # TODO: simulate n_sims trajectories with death rate m and t_end = 60
  # For each simulation, find the time of extinction (first time population = 0)
  # If extinction does not occur within t_end, record as NA
  sims <- lapply(1:n_sims, function(i) {
    # TODO: simulate and extract extinction time
    # TODO
  })
  data.frame(
    mu      = m,
    ext_time = unlist(sims)
  )
})

ext_df <- bind_rows(ext_times_all)
ext_df <- ext_df[!is.na(ext_df$ext_time), ]   # remove non-extinct trajectories

# TODO: produce a density/histogram plot of extinction times, faceted or coloured by mu
p3 <- ggplot(ext_df, aes(x = ext_time, fill = factor(mu))) +
  # TODO: geom_density or geom_histogram
  labs(
    title = "Distribution of extinction times for three death rates",
    x = "Time to extinction", y = "Density",
    fill = "mu"
  ) +
  theme_minimal()

print(p3)
