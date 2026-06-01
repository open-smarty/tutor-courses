# BDAT 624 — Module 4, Lesson 1: The Pure Birth Process (Yule Model)
# SOLUTION FILE — complete working implementation
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# Parameters ----------------------------------------------------------------
lambda  <- 0.5
j       <- 1
t_end   <- 10
n_sims  <- 100
t_check <- 6

# ---------------------------------------------------------------------------
# Yule process simulator
# ---------------------------------------------------------------------------

simulate_yule <- function(lambda, j, t_end) {
  t     <- 0
  n     <- j
  times <- c(0)
  pops  <- c(j)

  while (t < t_end) {
    dt <- rexp(1, rate = n * lambda)   # waiting time: Exp(n*lambda)
    t  <- t + dt
    if (t >= t_end) break
    n  <- n + 1                        # birth event
    times <- c(times, t)
    pops  <- c(pops, n)
  }
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

all_sims <- bind_rows(
  lapply(1:n_sims, function(i) {
    df      <- simulate_yule(lambda, j, t_end)
    df$sim  <- i
    df
  })
)

# ---------------------------------------------------------------------------
# Step-function lookup: population for simulation sim_df at query time t_query
# ---------------------------------------------------------------------------

get_pop_at <- function(sim_df, t_query) {
  idx <- which(sim_df$time <= t_query)
  if (length(idx) == 0) return(j)
  sim_df$population[max(idx)]
}

# ---------------------------------------------------------------------------
# Part 2: Trajectory plot
# ---------------------------------------------------------------------------

t_grid    <- seq(0, t_end, length.out = 200)
pop_matrix <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})

emp_mean  <- rowMeans(pop_matrix)
theo_mean <- j * exp(lambda * t_grid)

mean_df  <- data.frame(time = t_grid, emp_mean = emp_mean, theo_mean = theo_mean)

p1 <- ggplot() +
  geom_step(
    data    = all_sims,
    aes(x = time, y = population, group = sim),
    colour  = "grey70", alpha = 0.2
  ) +
  geom_line(
    data    = mean_df,
    aes(x = time, y = emp_mean),
    colour  = "red", linewidth = 1.1
  ) +
  geom_line(
    data    = mean_df,
    aes(x = time, y = theo_mean),
    colour  = "blue", linetype = "dashed", linewidth = 1.1
  ) +
  labs(
    title    = "Yule Process: 100 Simulated Trajectories",
    subtitle = paste0("lambda = ", lambda, ", X(0) = ", j,
                      " | red = empirical mean, blue dashed = j*exp(lambda*t)"),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 3: Distribution of X(t_check) vs NegBin PMF
# ---------------------------------------------------------------------------

x_at_check <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  get_pop_at(sim_df, t_check)
})

p_negbin <- exp(-lambda * t_check)       # success probability for NegBin
x_range  <- min(x_at_check):max(x_at_check)
# R's dnbinom: number of failures before size-th success.
# Our X(t) = j + failures, so failures = x_range - j.
theo_pmf <- dnbinom(x_range - j, size = j, prob = p_negbin)

dist_df  <- data.frame(x = x_at_check)
theo_df  <- data.frame(x = x_range, pmf = theo_pmf)

p2 <- ggplot(dist_df, aes(x = x)) +
  geom_bar(
    aes(y = after_stat(count) / n_sims),
    fill = "steelblue", colour = "white", alpha = 0.7
  ) +
  geom_point(
    data    = theo_df,
    aes(x = x, y = pmf),
    colour  = "red", size = 2
  ) +
  geom_line(
    data   = theo_df,
    aes(x = x, y = pmf),
    colour = "red", linewidth = 0.8
  ) +
  labs(
    title    = paste0("Distribution of X(", t_check, ") — ", n_sims, " simulations"),
    subtitle = paste0("Theoretical: NegBin(j = ", j, ", p = ", round(p_negbin, 3), ")"),
    x = paste0("X(", t_check, ")"), y = "Proportion / Probability"
  ) +
  theme_minimal()

print(p2)

# ---------------------------------------------------------------------------
# Part 4: Verify E[X(t)] ≈ j * exp(lambda * t)
# ---------------------------------------------------------------------------

check_times <- c(2, 4, 6, 8)
cat("\n--- Verification of E[X(t)] ---\n")
for (tc in check_times) {
  emp  <- mean(sapply(1:n_sims, function(i) {
    get_pop_at(all_sims[all_sims$sim == i, ], tc)
  }))
  theo <- j * exp(lambda * tc)
  cat(sprintf("t = %2d | empirical = %7.2f | theoretical = %7.2f | ratio = %.3f\n",
              tc, emp, theo, emp / theo))
}

# ---------------------------------------------------------------------------
# Part 5: Effect of doubling lambda
# ---------------------------------------------------------------------------

lambda2   <- 2 * lambda
set.seed(123)

all_sims2 <- bind_rows(
  lapply(1:n_sims, function(i) {
    df      <- simulate_yule(lambda2, j, t_end)
    df$sim  <- i
    df
  })
)

pop_matrix2 <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims2[all_sims2$sim == i, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})

emp_mean2  <- rowMeans(pop_matrix2)
theo_mean2 <- j * exp(lambda2 * t_grid)

combined_df <- data.frame(
  time     = rep(t_grid, 4),
  mean_val = c(emp_mean, theo_mean, emp_mean2, theo_mean2),
  type     = rep(
    c(paste0("Empirical (lambda=", lambda, ")"),
      paste0("Theoretical (lambda=", lambda, ")"),
      paste0("Empirical (lambda=", lambda2, ")"),
      paste0("Theoretical (lambda=", lambda2, ")")),
    each = length(t_grid)
  )
)

p3 <- ggplot(combined_df, aes(x = time, y = mean_val, colour = type, linetype = type)) +
  geom_line(linewidth = 1.1) +
  scale_colour_manual(
    values = c("steelblue", "steelblue", "tomato", "tomato")
  ) +
  scale_linetype_manual(
    values = c("solid", "dashed", "solid", "dashed")
  ) +
  labs(
    title    = "Effect of doubling lambda on E[X(t)]",
    subtitle = paste0("lambda = ", lambda, " vs lambda = ", lambda2),
    x = "Time", y = "Mean population size",
    colour = "", linetype = ""
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p3)
