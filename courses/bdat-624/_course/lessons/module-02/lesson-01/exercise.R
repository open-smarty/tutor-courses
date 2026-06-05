# Required packages
library(markovchain)
library(ggplot2)
library(dplyr)

# Scenario: A four-state patient health model tracking weekly transitions
# among: Healthy (H), Mildly Ill (MI), Severely Ill (SI), Dead (D).
# Dataset: simulated cohort based on the lesson's clinical TPM.

# ============================================================
# Task 1: Build the four-state Markov chain
# ============================================================
# Use the TPM from the lesson:
#   From H:   H=0.90, MI=0.09, SI=0.01, D=0.00
#   From MI:  H=0.30, MI=0.50, SI=0.18, D=0.02
#   From SI:  H=0.05, MI=0.30, SI=0.50, D=0.15
#   From D:   H=0.00, MI=0.00, SI=0.00, D=1.00

# TODO: Create the transition matrix (states in order: H, MI, SI, D)
states_4 <- c("H", "MI", "SI", "D")

P4 <- matrix(
  c(# H      MI     SI     D
    NA,    NA,    NA,    NA,   # from H
    NA,    NA,    NA,    NA,   # from MI
    NA,    NA,    NA,    NA,   # from SI
    NA,    NA,    NA,    NA    # from D
  ),
  nrow = 4, byrow = TRUE,
  dimnames = list(states_4, states_4)
)

# TODO: Verify row sums
cat("Row sums:\n"); print(rowSums(P4))

# TODO: Verify that state D is absorbing:
#   P4["D", "D"] should equal 1
#   P4["D", c("H","MI","SI")] should all equal 0
cat("\nDead row (should be 0 0 0 1):\n"); print(P4["D", ])

# ============================================================
# Task 2: Create a markovchain object
# ============================================================
# TODO: Use new("markovchain") to create the health_mc4 object
health_mc4 <- new("markovchain",
  states           = states_4,
  byrow            = TRUE,
  transitionMatrix = P4,
  name             = "4-State Health Chain"
)

# TODO: Print the chain summary
print(health_mc4)

# TODO: Use is.irreducible(health_mc4) to check if the chain is irreducible.
# Write a comment: is it irreducible? Why or why not?
# (Hint: can you get from Dead to Healthy? What does that imply?)
cat("\nIs irreducible:", is.irreducible(health_mc4), "\n")

# ============================================================
# Task 3: Simulate two 100-step trajectories
# ============================================================
# Simulate a patient starting Healthy and another starting Mildly Ill.
set.seed(2024)

# TODO: Simulate 100-step trajectory starting from "H"
traj_H  <- markovchainSequence(n = 100, markovchain = health_mc4, t0 = "H")

# TODO: Simulate 100-step trajectory starting from "MI"
traj_MI <- markovchainSequence(n = 100, markovchain = health_mc4, t0 = "MI")

# ============================================================
# Task 4: Create a combined data frame and plot
# ============================================================
# TODO: Build a data frame with columns: step, state, start
# (two rows per step — one for each starting state)
traj_df <- data.frame(
  step  = rep(1:100, 2),
  state = c(traj_H, traj_MI),
  start = rep(c("Start: H", "Start: MI"), each = 100)
)

# TODO: Convert state to an ordered factor for correct y-axis ordering
traj_df$state <- factor(traj_df$state, levels = c("H", "MI", "SI", "D"))

# TODO: Plot both trajectories side-by-side using facet_wrap(~ start)
# Use geom_point() coloured by state.
ggplot(traj_df, aes(x = step, y = state, color = state)) +
  geom_point(size = 1.5) +
  facet_wrap(~ start, ncol = 1) +
  labs(
    title = "100-Step Patient Trajectories: 4-State Health Markov Chain",
    x = "Week", y = "State", color = "State"
  ) +
  theme_minimal()

# ============================================================
# Task 5: Compute and plot 10-week state distribution
# ============================================================
# Starting from "all patients Healthy" (pi0 = c(1,0,0,0)):
pi0_H <- c(H = 1, MI = 0, SI = 0, D = 0)

mat_power <- function(M, n) {
  result <- diag(nrow(M)); for(i in seq_len(n)) result <- result %*% M; result
}

# TODO: Compute pi_n = pi0 %*% P^n for n = 0,1,...,20
# Build a long-format data frame: columns week, state, prob
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

# TODO: Plot: week on x-axis, probability on y-axis, coloured by state
# Pay particular attention to how the Dead state probability grows.
ggplot(plot_data, aes(x = week, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title  = "Distribution of 4-State Health Model Over 20 Weeks",
    subtitle = "Starting condition: all patients Healthy",
    x = "Week", y = "Probability", color = "State"
  ) +
  theme_minimal()

# TODO: What is P(Dead at week 10 | Healthy at week 0)?
# Extract this value from your computation and print it with a comment.
prob_dead_10 <- (pi0_H %*% mat_power(P4, 10))["D"]
cat("\nP(Dead at week 10 | Healthy at week 0):", round(prob_dead_10, 4), "\n")
