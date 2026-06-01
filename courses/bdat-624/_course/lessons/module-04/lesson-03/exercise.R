# BDAT 624 — Module 4, Lesson 3: Birth-Death Process — Linear Growth and Extinction
# Exercise: simulate supercritical, critical, subcritical, and immigration birth-death processes
#
# Instructions: fill in every # TODO: marker.
# Run: npm run check -- bdat-624 module-04 lesson-03
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# ---------------------------------------------------------------------------
# Birth-death simulator (handles births, deaths, and optional immigration)
# ---------------------------------------------------------------------------
# Arguments:
#   lambda  — per-individual birth rate
#   mu      — per-individual death rate
#   epsilon — immigration rate (constant, default 0)
#   i       — initial population X(0)
#   t_end   — simulation horizon
# Returns: data.frame with columns (time, population)

simulate_bd <- function(lambda, mu, i, t_end, epsilon = 0) {
  # TODO: initialise t = 0, n = i, times = c(0), pops = c(i)
  t     <- 0
  n     <- i
  times <- c(0)
  pops  <- c(i)

  while (t < t_end) {
    # TODO: compute the total event rate:
    #   rate_birth = n * lambda
    #   rate_death = n * mu
    #   rate_immig = epsilon
    #   total_rate = rate_birth + rate_death + rate_immig
    total_rate <- # TODO

    # If total rate is 0 (absorbing state and no immigration), process is stuck
    if (total_rate == 0) break

    # TODO: draw inter-event time from Exp(total_rate)
    dt <- # TODO
    t  <- t + dt
    if (t >= t_end) break

    # TODO: determine event type by drawing from the three possibilities
    # using a uniform random number u in [0, 1]:
    #   if u < rate_birth / total_rate  → birth
    #   else if u < (rate_birth + rate_death) / total_rate  → death
    #   else  → immigration
    u <- runif(1)
    rate_birth <- n * lambda
    rate_death <- n * mu
    if (u < rate_birth / total_rate) {
      # TODO: birth — increment n
      n <- # TODO
    } else if (u < (rate_birth + rate_death) / total_rate) {
      # TODO: death — decrement n (but not below 0)
      n <- # TODO
    } else {
      # TODO: immigration — increment n
      n <- # TODO
    }

    times <- c(times, t)
    pops  <- c(pops, n)
  }
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

# Step-function lookup (reused from previous lessons)
get_pop_at <- function(sim_df, t_query) {
  idx <- which(sim_df$time <= t_query)
  if (length(idx) == 0) return(sim_df$population[1])
  sim_df$population[max(idx)]
}

# Simulation settings
n_sims <- 300
t_end  <- 30

# ---------------------------------------------------------------------------
# Part 1: Supercritical birth-death (lambda > mu)
# ---------------------------------------------------------------------------

lambda_s <- 0.4; mu_s <- 0.3; i_s <- 5
# Theoretical mean: E[X(t)] = i * exp((lambda - mu) * t)

# TODO: simulate n_sims trajectories using simulate_bd
all_super <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- # TODO: call simulate_bd with lambda_s, mu_s, i_s, t_end
    df$sim <- k
    df
  })
)

t_grid      <- seq(0, t_end, length.out = 200)
theo_super  <- i_s * exp((lambda_s - mu_s) * t_grid)

# TODO: compute empirical mean at each t_grid point
pop_mat_s <- sapply(1:n_sims, function(k) {
  # TODO
})
emp_super <- rowMeans(pop_mat_s)

# TODO: plot all trajectories (grey) + empirical mean (red) + theoretical mean (blue dashed)
p1 <- ggplot() +
  # TODO
  labs(
    title    = "Supercritical Birth-Death Process",
    subtitle = paste0("lambda = ", lambda_s, ", mu = ", mu_s, ", X(0) = ", i_s,
                      " | intrinsic growth rate = ", lambda_s - mu_s),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 2: Critical birth-death (lambda = mu)
# ---------------------------------------------------------------------------

lambda_c <- 0.3; mu_c <- 0.3; i_c <- 5

# TODO: simulate n_sims trajectories
all_crit <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- # TODO
    df$sim <- k
    df
  })
)

# Fraction extinct by t_end
frac_extinct_crit <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_crit[all_crit$sim == k, ]
  # TODO: return 1 if the population at t_end is 0, else 0
  # TODO
}))
cat(sprintf("\nCritical (lambda=mu=%.1f): fraction extinct by t=%.0f = %.3f\n",
            lambda_c, t_end, frac_extinct_crit))
cat("Theoretical: extinction is certain (probability 1) eventually.\n")

# ---------------------------------------------------------------------------
# Part 3: Subcritical birth-death (lambda < mu)
# ---------------------------------------------------------------------------

lambda_b <- 0.3; mu_b <- 0.4; i_b <- 5

# TODO: simulate n_sims trajectories
all_sub <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- # TODO
    df$sim <- k
    df
  })
)

frac_extinct_sub <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_sub[all_sub$sim == k, ]
  # TODO: return 1 if extinct at t_end, else 0
  # TODO
}))
cat(sprintf("\nSubcritical (lambda=%.1f, mu=%.1f): fraction extinct by t=%.0f = %.3f\n",
            lambda_b, mu_b, t_end, frac_extinct_sub))
cat("Theoretical: extinction is certain (probability 1).\n")

# ---------------------------------------------------------------------------
# Part 4: Verify theoretical extinction probability for supercritical case
# ---------------------------------------------------------------------------

# Theoretical extinction probability for supercritical case starting at i_s
rho      <- mu_s / lambda_s
ext_prob_theo <- rho^i_s
cat(sprintf("\nSupercritical extinction probability: theoretical = (%.2f)^%d = %.5f\n",
            rho, i_s, ext_prob_theo))

# Empirical: run n_sims = 1000 trajectories to t = 100 (long enough)
n_long <- 1000
all_long <- bind_rows(
  lapply(1:n_long, function(k) {
    df     <- simulate_bd(lambda_s, mu_s, i_s, t_end = 100)
    df$sim <- k
    df
  })
)

# TODO: compute empirical extinction fraction by t = 100
frac_ext_super <- # TODO: mean of (pop at t=100 == 0) across all_long

cat(sprintf("Empirical (t=100): %.5f\n", frac_ext_super))
cat(sprintf("Difference: %.5f\n", abs(frac_ext_super - ext_prob_theo)))

# ---------------------------------------------------------------------------
# Part 5: Immigration rescues the subcritical process
# ---------------------------------------------------------------------------

epsilon <- 0.5   # immigration rate

# TODO: simulate n_sims subcritical + immigration trajectories
all_immig <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- # TODO: use simulate_bd with epsilon = epsilon
    df$sim <- k
    df
  })
)

frac_ext_immig <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_immig[all_immig$sim == k, ]
  # TODO: return 1 if extinct at t_end
  # TODO
}))
cat(sprintf(
  "\nSubcritical + immigration (epsilon=%.1f): fraction extinct by t=%.0f = %.4f\n",
  epsilon, t_end, frac_ext_immig
))
cat("Expected: near 0 (immigration prevents absorption at state 0).\n")

# TODO: compare mean trajectories of subcritical (no immigration) vs subcritical + immigration
# Plot both mean trajectories on one graph
t_grid_b     <- seq(0, t_end, length.out = 200)

pop_mat_sub  <- sapply(1:n_sims, function(k) {
  sim_df <- all_sub[all_sub$sim == k, ]
  # TODO
})
emp_sub <- rowMeans(pop_mat_sub)

pop_mat_imm  <- sapply(1:n_sims, function(k) {
  sim_df <- all_immig[all_immig$sim == k, ]
  # TODO
})
emp_imm <- rowMeans(pop_mat_imm)

cmp_df <- data.frame(
  time  = rep(t_grid_b, 2),
  mean  = c(emp_sub, emp_imm),
  model = rep(c("Subcritical (no immigration)", "Subcritical + immigration"), each = length(t_grid_b))
)

p5 <- ggplot(cmp_df, aes(x = time, y = mean, colour = model)) +
  geom_line(linewidth = 1.1) +
  labs(
    title    = "Effect of immigration on subcritical birth-death process",
    subtitle = paste0("lambda = ", lambda_b, ", mu = ", mu_b, ", epsilon = ", epsilon),
    x = "Time", y = "Mean population size",
    colour = ""
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p5)
