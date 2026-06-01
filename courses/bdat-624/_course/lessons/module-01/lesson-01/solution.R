# BDAT 624 — Module 1, Lesson 1
# Solution: Simulating the Four Types of Stochastic Processes

library(ggplot2)
library(dplyr)
library(gridExtra)

set.seed(42)

# ============================================================
# TYPE I: Discrete Time, Discrete State
# Random walk with absorbing barrier at 0
# ============================================================

n_steps <- 50
start_state <- 5

rw <- rep(NA, n_steps + 1)
rw[1] <- start_state

for (i in 2:(n_steps + 1)) {
  if (rw[i - 1] == 0) {
    rw[i] <- 0  # absorbing barrier: once at 0, stay at 0
  } else {
    step <- sample(c(-1, 1), 1)
    rw[i] <- max(0, rw[i - 1] + step)
  }
}

df_rw <- data.frame(step = 0:n_steps, state = rw)

# ============================================================
# TYPE II: Continuous Time, Discrete State
# Poisson arrivals at an emergency department over 24 hours
# ============================================================

lambda_per_hour <- 6
hours <- 24

arrivals <- rpois(hours, lambda = lambda_per_hour)
cum_arrivals <- cumsum(arrivals)

df_pois <- data.frame(hour = 1:hours, cumulative = cum_arrivals)

# ============================================================
# TYPE III: Discrete Time, Continuous State
# Weekly body weight fluctuations over one year
# ============================================================

n_weeks <- 52
start_weight <- 75
sd_weekly <- 0.8

weight <- rep(NA, n_weeks + 1)
weight[1] <- start_weight

for (i in 2:(n_weeks + 1)) {
  weight[i] <- weight[i - 1] + rnorm(1, mean = 0, sd = sd_weekly)
}

df_weight <- data.frame(week = 0:n_weeks, kg = weight)

# ============================================================
# TYPE IV: Continuous Time, Continuous State
# Brownian motion approximation — continuous blood pressure trace
# ============================================================

n_points <- 1000
bm_increments <- rnorm(n_points, mean = 0, sd = 1)
bm_path <- cumsum(bm_increments)

# Shift and scale to physiologically plausible blood pressure range
bm_path <- 120 + 15 * (bm_path / sd(bm_path))

df_bm <- data.frame(
  t  = seq(0, 24, length.out = n_points),
  bp = bm_path
)

# ============================================================
# PLOTTING
# ============================================================

p1 <- ggplot(df_rw, aes(x = step, y = state)) +
  geom_step(colour = "#2166ac", linewidth = 0.7) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", alpha = 0.5) +
  labs(
    title    = "Type I: Discrete Time, Discrete State",
    subtitle = "Random walk — patient severity score (absorbed at 0)",
    x        = "Step",
    y        = "Severity Score"
  ) +
  theme_minimal()

p2 <- ggplot(df_pois, aes(x = hour, y = cumulative)) +
  geom_step(colour = "#4dac26", linewidth = 0.7) +
  labs(
    title    = "Type II: Continuous Time, Discrete State",
    subtitle = "Cumulative ED arrivals (Poisson, λ = 6/hour)",
    x        = "Hour of Day",
    y        = "Cumulative Arrivals"
  ) +
  theme_minimal()

p3 <- ggplot(df_weight, aes(x = week, y = kg)) +
  geom_line(colour = "#d7191c", linewidth = 0.7) +
  labs(
    title    = "Type III: Discrete Time, Continuous State",
    subtitle = "Weekly body weight — random walk with N(0, 0.8) steps",
    x        = "Week",
    y        = "Body Weight (kg)"
  ) +
  theme_minimal()

p4 <- ggplot(df_bm, aes(x = t, y = bp)) +
  geom_line(colour = "#762a83", linewidth = 0.5, alpha = 0.85) +
  labs(
    title    = "Type IV: Continuous Time, Continuous State",
    subtitle = "Brownian motion approximation — blood pressure (mmHg)",
    x        = "Time (hours)",
    y        = "Blood Pressure (mmHg)"
  ) +
  theme_minimal()

grid.arrange(p1, p2, p3, p4, nrow = 2)

# ============================================================
# REFLECTION ANSWER
# ============================================================
# Type II (Poisson arrivals) shows the most predictable long-run behaviour:
# the cumulative count grows almost linearly with slope λ = 6/hour.
# By the law of large numbers the empirical rate converges to λ.
#
# Type IV (Brownian motion) is hardest to model deterministically.
# Its sample paths have infinite variation and no smooth trend — the
# process wanders arbitrarily far from any fixed trajectory, so a
# single deterministic curve cannot capture its typical behaviour.
