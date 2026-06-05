# SOLUTION: Module 01 Lesson 01 — What is a Stochastic Process?
library(markovchain)
library(ggplot2)

# ============================================================
# Part 1: Classify four stochastic processes
# ============================================================
# Process A: Number of new HIV diagnoses reported monthly
# T: discrete (months: 1, 2, 3, ...)
# S: discrete (counts: 0, 1, 2, ...)
# Type: Discrete Time, Discrete State (DT-DS)

# Process B: Patient systolic blood pressure every 5 minutes
# T: discrete (5, 10, 15, ... minutes)
# S: continuous (mmHg, real-valued; approx 60–200)
# Type: Discrete Time, Continuous State (DT-CS)

# Process C: Whether a patient is alive or dead — can change at any instant
# T: continuous ([0, ∞), time in days/hours since start)
# S: discrete ({Alive, Dead})
# Type: Continuous Time, Discrete State (CT-DS)

# Process D: Viral load in a patient's blood, measured continuously
# T: continuous ([0, ∞))
# S: continuous ([0, ∞), copies/mL)
# Type: Continuous Time, Continuous State (CT-CS)

# ============================================================
# Part 2: Define a 3-state health Markov chain
# ============================================================
trans_matrix <- matrix(
  c(0.85, 0.15, 0.00,   # from H: likely stays Healthy
    0.10, 0.40, 0.50,   # from S: often recovers
    0.30, 0.00, 0.70),  # from R: mostly stays Recovered, some revert to H
  nrow = 3, byrow = TRUE,
  dimnames = list(c("H", "S", "R"), c("H", "S", "R"))
)

# Verify row sums (all should equal 1)
cat("Row sums (should all be 1):\n")
print(rowSums(trans_matrix))

# ============================================================
# Part 3: Create markovchain object and simulate
# ============================================================
health_mc <- new("markovchain",
  states = c("H", "S", "R"),
  byrow  = TRUE,
  transitionMatrix = trans_matrix,
  name   = "Health Chain"
)
print(health_mc)

set.seed(42)
trajectory <- markovchainSequence(
  n           = 100,
  markovchain = health_mc,
  t0          = "H"
)

# ============================================================
# Part 4: Visualise the trajectory
# ============================================================
traj_df <- data.frame(
  step  = 1:100,
  state = factor(trajectory, levels = c("H", "S", "R"))
)

p <- ggplot(traj_df, aes(x = step, y = state, color = state, group = 1)) +
  geom_point(size = 2) +
  geom_line(alpha = 0.4) +
  scale_color_manual(values = c("H" = "#2ecc71", "S" = "#e74c3c", "R" = "#3498db")) +
  labs(
    title   = "100-Step Simulation of 3-State Health Markov Chain",
    subtitle = "Starting state: Healthy",
    x       = "Week",
    y       = "Health State",
    color   = "State"
  ) +
  theme_minimal(base_size = 13)
print(p)

# ============================================================
# Part 5: Summary statistics on the trajectory
# ============================================================
state_counts <- table(trajectory)
state_props  <- state_counts / length(trajectory)
cat("\nEmpirical proportion of time in each state (100-step trajectory):\n")
print(round(state_props, 3))

# Interpretation: The proportion of time in S (Sick) reflects the
# long-run probability of being in the Sick state. With the given TPM,
# Sick is a "transient" experience — the chain spends most time in H
# and R. If the proportion in S is roughly 5–15%, that is consistent
# with the transition probabilities (low entry from H, fast exit to R).

# Cross-check: The theoretical stationary distribution can be found by
# solving π P = π with Σπ = 1.
# For this TPM the stationary distribution is approximately:
#   π_H ≈ 0.53, π_S ≈ 0.05, π_R ≈ 0.42
# (computed in Lesson 2 — compare your empirical proportions!)
