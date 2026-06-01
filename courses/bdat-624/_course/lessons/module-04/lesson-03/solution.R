# BDAT 624 — Module 4, Lesson 3: Birth-Death Process — Linear Growth and Extinction
# SOLUTION FILE — complete working implementation
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# ---------------------------------------------------------------------------
# Birth-death simulator with optional immigration
# ---------------------------------------------------------------------------

simulate_bd <- function(lambda, mu, i, t_end, epsilon = 0) {
  t     <- 0
  n     <- i
  times <- c(0)
  pops  <- c(i)

  while (t < t_end) {
    rate_birth <- n * lambda
    rate_death <- n * mu
    rate_immig <- epsilon
    total_rate <- rate_birth + rate_death + rate_immig

    if (total_rate == 0) break          # absorbing state, no immigration

    dt <- rexp(1, rate = total_rate)
    t  <- t + dt
    if (t >= t_end) break

    u <- runif(1)
    if (u < rate_birth / total_rate) {
      n <- n + 1                        # birth
    } else if (u < (rate_birth + rate_death) / total_rate) {
      n <- max(0L, n - 1L)             # death (guard against underflow)
    } else {
      n <- n + 1                        # immigration
    }

    times <- c(times, t)
    pops  <- c(pops, n)
  }
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

get_pop_at <- function(sim_df, t_query) {
  idx <- which(sim_df$time <= t_query)
  if (length(idx) == 0) return(sim_df$population[1])
  sim_df$population[max(idx)]
}

n_sims <- 300
t_end  <- 30
t_grid <- seq(0, t_end, length.out = 200)

# ---------------------------------------------------------------------------
# Part 1: Supercritical birth-death (lambda > mu)
# ---------------------------------------------------------------------------

lambda_s <- 0.4; mu_s <- 0.3; i_s <- 5

all_super <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- simulate_bd(lambda_s, mu_s, i_s, t_end)
    df$sim <- k
    df
  })
)

theo_super <- i_s * exp((lambda_s - mu_s) * t_grid)

pop_mat_s <- sapply(1:n_sims, function(k) {
  sim_df <- all_super[all_super$sim == k, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})
emp_super <- rowMeans(pop_mat_s)

mean_df_s <- data.frame(time = t_grid, emp = emp_super, theo = theo_super)

p1 <- ggplot() +
  geom_step(
    data   = all_super,
    aes(x = time, y = population, group = sim),
    colour = "grey70", alpha = 0.15
  ) +
  geom_line(
    data   = mean_df_s,
    aes(x = time, y = emp),
    colour = "red", linewidth = 1.1
  ) +
  geom_line(
    data     = mean_df_s,
    aes(x = time, y = theo),
    colour   = "blue", linetype = "dashed", linewidth = 1.1
  ) +
  labs(
    title    = "Supercritical Birth-Death Process (lambda=0.4, mu=0.3)",
    subtitle = paste0("X(0) = ", i_s, " | red = empirical mean, blue dashed = ",
                      i_s, "*exp(", lambda_s - mu_s, "*t)"),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 2: Critical birth-death (lambda = mu)
# ---------------------------------------------------------------------------

lambda_c <- 0.3; mu_c <- 0.3; i_c <- 5

all_crit <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- simulate_bd(lambda_c, mu_c, i_c, t_end)
    df$sim <- k
    df
  })
)

frac_extinct_crit <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_crit[all_crit$sim == k, ]
  as.integer(get_pop_at(sim_df, t_end) == 0)
}))
cat(sprintf("\nCritical (lambda=mu=%.1f): fraction extinct by t=%.0f = %.3f\n",
            lambda_c, t_end, frac_extinct_crit))
cat("Theoretical: extinction probability = 1 eventually (critical process).\n")

# ---------------------------------------------------------------------------
# Part 3: Subcritical birth-death (lambda < mu)
# ---------------------------------------------------------------------------

lambda_b <- 0.3; mu_b <- 0.4; i_b <- 5

all_sub <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- simulate_bd(lambda_b, mu_b, i_b, t_end)
    df$sim <- k
    df
  })
)

frac_extinct_sub <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_sub[all_sub$sim == k, ]
  as.integer(get_pop_at(sim_df, t_end) == 0)
}))
cat(sprintf("\nSubcritical (lambda=%.1f, mu=%.1f): fraction extinct by t=%.0f = %.3f\n",
            lambda_b, mu_b, t_end, frac_extinct_sub))
cat("Theoretical: extinction probability = 1 (subcritical, rho > 1).\n")

# ---------------------------------------------------------------------------
# Part 4: Verify theoretical extinction probability for supercritical
# ---------------------------------------------------------------------------

rho           <- mu_s / lambda_s
ext_prob_theo <- rho^i_s
cat(sprintf("\nSupercritical extinction probability: theoretical = (%.2f)^%d = %.5f\n",
            rho, i_s, ext_prob_theo))

n_long   <- 1000
all_long <- bind_rows(
  lapply(1:n_long, function(k) {
    df     <- simulate_bd(lambda_s, mu_s, i_s, t_end = 100)
    df$sim <- k
    df
  })
)

frac_ext_super <- mean(sapply(1:n_long, function(k) {
  sim_df <- all_long[all_long$sim == k, ]
  as.integer(get_pop_at(sim_df, 100) == 0)
}))

cat(sprintf("Empirical (t=100, n=%d): %.5f\n", n_long, frac_ext_super))
cat(sprintf("Difference: %.5f\n", abs(frac_ext_super - ext_prob_theo)))

# ---------------------------------------------------------------------------
# Part 5: Immigration rescues the subcritical process
# ---------------------------------------------------------------------------

epsilon <- 0.5

all_immig <- bind_rows(
  lapply(1:n_sims, function(k) {
    df     <- simulate_bd(lambda_b, mu_b, i_b, t_end, epsilon = epsilon)
    df$sim <- k
    df
  })
)

frac_ext_immig <- mean(sapply(1:n_sims, function(k) {
  sim_df <- all_immig[all_immig$sim == k, ]
  as.integer(get_pop_at(sim_df, t_end) == 0)
}))
cat(sprintf(
  "\nSubcritical + immigration (epsilon=%.1f): fraction extinct by t=%.0f = %.4f\n",
  epsilon, t_end, frac_ext_immig
))

# Comparison plot
pop_mat_sub <- sapply(1:n_sims, function(k) {
  sim_df <- all_sub[all_sub$sim == k, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})
emp_sub <- rowMeans(pop_mat_sub)

pop_mat_imm <- sapply(1:n_sims, function(k) {
  sim_df <- all_immig[all_immig$sim == k, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})
emp_imm <- rowMeans(pop_mat_imm)

cmp_df <- data.frame(
  time  = rep(t_grid, 2),
  mean  = c(emp_sub, emp_imm),
  model = rep(
    c("Subcritical (no immigration)", paste0("Subcritical + immigration (epsilon=", epsilon, ")")),
    each = length(t_grid)
  )
)

p5 <- ggplot(cmp_df, aes(x = time, y = mean, colour = model)) +
  geom_line(linewidth = 1.1) +
  scale_colour_manual(values = c("steelblue", "tomato")) +
  labs(
    title    = "Effect of immigration on a subcritical birth-death process",
    subtitle = paste0("lambda = ", lambda_b, ", mu = ", mu_b, ", epsilon = ", epsilon,
                      " | X(0) = ", i_b),
    x = "Time", y = "Mean population size",
    colour = ""
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p5)

# Comparison table
cat("\n--- Summary ---\n")
cat(sprintf("Supercritical (L=0.4, M=0.3)  : extinction fraction by t=30  = %.3f (theo = %.5f)\n",
            frac_extinct_crit, ext_prob_theo))
cat(sprintf("Critical      (L=M=0.3)       : extinction fraction by t=30  = %.3f\n",
            frac_extinct_crit))
cat(sprintf("Subcritical   (L=0.3, M=0.4)  : extinction fraction by t=30  = %.3f\n",
            frac_extinct_sub))
cat(sprintf("Subcritical + immigration     : extinction fraction by t=30  = %.4f\n",
            frac_ext_immig))
