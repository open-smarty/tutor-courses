# BDAT 624 — Module 4, Lesson 2: The Pure Death Process
# SOLUTION FILE — complete working implementation
#
# Libraries -----------------------------------------------------------------
library(ggplot2)
library(dplyr)

set.seed(42)

# Parameters ----------------------------------------------------------------
mu      <- 0.1
j       <- 50
t_end   <- 30
n_sims  <- 200
t_check <- 10

# ---------------------------------------------------------------------------
# Pure death process simulator
# ---------------------------------------------------------------------------

simulate_death <- function(mu, j, t_end) {
  t     <- 0
  n     <- j
  times <- c(0)
  pops  <- c(j)

  while (t < t_end && n > 0) {
    dt <- rexp(1, rate = n * mu)   # waiting time: Exp(n*mu)
    t  <- t + dt
    if (t >= t_end) break
    n  <- n - 1                    # death event
    times <- c(times, t)
    pops  <- c(pops, n)
  }
  times <- c(times, t_end)
  pops  <- c(pops, n)
  data.frame(time = times, population = pops)
}

all_sims <- bind_rows(
  lapply(1:n_sims, function(i) {
    df      <- simulate_death(mu, j, t_end)
    df$sim  <- i
    df
  })
)

# ---------------------------------------------------------------------------
# Step-function lookup
# ---------------------------------------------------------------------------

get_pop_at <- function(sim_df, t_query) {
  idx <- which(sim_df$time <= t_query)
  if (length(idx) == 0) return(j)
  sim_df$population[max(idx)]
}

# ---------------------------------------------------------------------------
# Part 2: Trajectory plot
# ---------------------------------------------------------------------------

t_grid     <- seq(0, t_end, length.out = 200)
theo_mean  <- j * exp(-mu * t_grid)

pop_matrix <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  sapply(t_grid, function(t) get_pop_at(sim_df, t))
})
emp_mean   <- rowMeans(pop_matrix)

mean_df <- data.frame(time = t_grid, emp_mean = emp_mean, theo_mean = theo_mean)

p1 <- ggplot() +
  geom_step(
    data   = all_sims,
    aes(x = time, y = population, group = sim),
    colour = "grey70", alpha = 0.2
  ) +
  geom_line(
    data   = mean_df,
    aes(x = time, y = emp_mean),
    colour = "red", linewidth = 1.1
  ) +
  geom_line(
    data     = mean_df,
    aes(x = time, y = theo_mean),
    colour   = "blue", linetype = "dashed", linewidth = 1.1
  ) +
  labs(
    title    = "Pure Death Process: 200 Simulated Trajectories",
    subtitle = paste0("mu = ", mu, ", X(0) = ", j,
                      " | red = empirical mean, blue dashed = j*exp(-mu*t)"),
    x = "Time", y = "Population size"
  ) +
  theme_minimal()

print(p1)

# ---------------------------------------------------------------------------
# Part 3: Distribution of X(t_check) vs Binomial PMF
# ---------------------------------------------------------------------------

x_at_check <- sapply(1:n_sims, function(i) {
  get_pop_at(all_sims[all_sims$sim == i, ], t_check)
})

p_binom  <- exp(-mu * t_check)         # Binomial success probability
x_range  <- 0:j
theo_pmf <- dbinom(x_range, size = j, prob = p_binom)

dist_df  <- data.frame(x = x_at_check)
theo_df  <- data.frame(x = x_range, pmf = theo_pmf)

p2 <- ggplot(dist_df, aes(x = x)) +
  geom_bar(
    aes(y = after_stat(count) / n_sims),
    fill = "steelblue", colour = "white", alpha = 0.7, width = 0.8
  ) +
  geom_point(
    data   = theo_df[theo_df$pmf > 1e-4, ],
    aes(x = x, y = pmf),
    colour = "red", size = 2
  ) +
  geom_line(
    data   = theo_df[theo_df$pmf > 1e-4, ],
    aes(x = x, y = pmf),
    colour = "red", linewidth = 0.8
  ) +
  labs(
    title    = paste0("Distribution of X(", t_check, ") — ", n_sims, " simulations"),
    subtitle = paste0("Theoretical: Binomial(j = ", j, ", p = ", round(p_binom, 3), ")"),
    x = paste0("X(", t_check, ")"), y = "Proportion / Probability"
  ) +
  theme_minimal()

print(p2)

# ---------------------------------------------------------------------------
# Part 4: Half-life
# ---------------------------------------------------------------------------

t_half_analytical <- log(2) / mu
cat(sprintf("\nAnalytical half-life: %.4f time units\n", t_half_analytical))

half_times <- sapply(1:n_sims, function(i) {
  sim_df <- all_sims[all_sims$sim == i, ]
  hit    <- which(sim_df$population <= j / 2)
  if (length(hit) == 0) return(NA_real_)
  sim_df$time[min(hit)]
})

emp_half <- mean(half_times, na.rm = TRUE)
cat(sprintf("Empirical half-life (mean time to X <= j/2): %.4f time units\n", emp_half))
cat(sprintf("Difference: %.4f\n", abs(emp_half - t_half_analytical)))

# ---------------------------------------------------------------------------
# Part 5: Extinction time distributions for mu = 0.1, 0.2, 0.5
# ---------------------------------------------------------------------------

mu_vals <- c(0.1, 0.2, 0.5)

ext_times_all <- lapply(mu_vals, function(m) {
  sims <- lapply(1:n_sims, function(i) {
    df  <- simulate_death(m, j, t_end = 60)   # extend horizon
    hit <- which(df$population == 0)
    if (length(hit) == 0) return(NA_real_)
    df$time[min(hit)]
  })
  data.frame(
    mu       = m,
    ext_time = unlist(sims)
  )
})

ext_df <- bind_rows(ext_times_all)
ext_df <- ext_df[!is.na(ext_df$ext_time), ]
ext_df$mu <- factor(ext_df$mu)

p3 <- ggplot(ext_df, aes(x = ext_time, fill = mu)) +
  geom_density(alpha = 0.5, colour = NA) +
  labs(
    title    = "Distribution of extinction times for three death rates",
    subtitle = paste0("Pure death process, X(0) = ", j),
    x = "Time to extinction", y = "Density",
    fill = expression(mu)
  ) +
  theme_minimal()

print(p3)

# Summary statistics
cat("\n--- Extinction time summary ---\n")
for (m in mu_vals) {
  et <- ext_df$ext_time[ext_df$mu == as.character(m)]
  cat(sprintf("mu = %.1f | N extinct = %d/%d | mean = %.2f | median = %.2f\n",
              m, length(et), n_sims, mean(et), median(et)))
}
