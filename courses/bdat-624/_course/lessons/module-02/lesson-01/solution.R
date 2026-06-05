# SOLUTION: Module 02 Lesson 01 — The Markov Property and Transition Matrices
library(markovchain)
library(ggplot2)
library(dplyr)

# ============================================================
# Task 1: Four-state TPM
# ============================================================
states_4 <- c("H", "MI", "SI", "D")

P4 <- matrix(
  c(0.90, 0.09, 0.01, 0.00,   # from H
    0.30, 0.50, 0.18, 0.02,   # from MI
    0.05, 0.30, 0.50, 0.15,   # from SI
    0.00, 0.00, 0.00, 1.00),  # from D (absorbing)
  nrow = 4, byrow = TRUE,
  dimnames = list(states_4, states_4)
)

cat("Row sums (must all be 1):\n")
print(rowSums(P4))

cat("\nDead row (absorbing state check):\n")
print(P4["D", ])
# Output should be: H=0, MI=0, SI=0, D=1

# ============================================================
# Task 2: markovchain object
# ============================================================
health_mc4 <- new("markovchain",
  states           = states_4,
  byrow            = TRUE,
  transitionMatrix = P4,
  name             = "4-State Health Chain"
)
print(health_mc4)

cat("\nIs irreducible:", is.irreducible(health_mc4), "\n")
# Result: FALSE — the chain is NOT irreducible because state D (Dead) is
# absorbing. You cannot get from D to H, MI, or SI, so D does not
# communicate with the other states. An irreducible chain requires every
# state to be reachable from every other state in a finite number of steps.

# ============================================================
# Task 3: Simulate trajectories
# ============================================================
set.seed(2024)
traj_H  <- markovchainSequence(n = 100, markovchain = health_mc4, t0 = "H")
traj_MI <- markovchainSequence(n = 100, markovchain = health_mc4, t0 = "MI")

# ============================================================
# Task 4: Plot trajectories
# ============================================================
traj_df <- data.frame(
  step  = rep(1:100, 2),
  state = factor(c(traj_H, traj_MI), levels = states_4),
  start = rep(c("Start: H", "Start: MI"), each = 100)
)

p_traj <- ggplot(traj_df, aes(x = step, y = state, color = state)) +
  geom_point(size = 1.5) +
  facet_wrap(~ start, ncol = 1) +
  scale_color_manual(values = c(
    "H"  = "#2ecc71",
    "MI" = "#f39c12",
    "SI" = "#e74c3c",
    "D"  = "#2c3e50"
  )) +
  labs(
    title    = "100-Step Patient Trajectories: 4-State Health Markov Chain",
    subtitle = "Once the process enters D (Dead), it stays there forever",
    x = "Week", y = "State", color = "State"
  ) +
  theme_minimal(base_size = 12)
print(p_traj)

# ============================================================
# Task 5: 10-week distribution
# ============================================================
pi0_H <- c(H = 1, MI = 0, SI = 0, D = 0)

mat_power <- function(M, n) {
  result <- diag(nrow(M))
  for (i in seq_len(n)) result <- result %*% M
  result
}

weeks <- 0:20
plot_data <- lapply(weeks, function(n) {
  dist_n <- pi0_H %*% mat_power(P4, n)
  data.frame(
    week  = n,
    state = states_4,
    prob  = as.numeric(dist_n)
  )
}) |> bind_rows()

plot_data$state <- factor(plot_data$state, levels = states_4)

p_dist <- ggplot(plot_data, aes(x = week, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "H"  = "#2ecc71",
    "MI" = "#f39c12",
    "SI" = "#e74c3c",
    "D"  = "#2c3e50"
  )) +
  labs(
    title    = "Distribution of 4-State Health Model Over 20 Weeks",
    subtitle = "Starting condition: all patients Healthy",
    x = "Week", y = "Probability", color = "State"
  ) +
  theme_minimal(base_size = 12)
print(p_dist)

# Probability of death by week 10 for a patient starting Healthy
prob_dead_10 <- as.numeric((pi0_H %*% mat_power(P4, 10))["D"])
cat("\nP(Dead at week 10 | Healthy at week 0):", round(prob_dead_10, 4), "\n")
# Interpretation: Even from a Healthy starting state, there is a small but
# meaningful cumulative probability of death by week 10. This demonstrates
# how the model captures long-run disease risk through repeated transitions.
# As week → ∞, all probability mass moves into D (the only absorbing state),
# so P(Dead) → 1 as n → ∞.
