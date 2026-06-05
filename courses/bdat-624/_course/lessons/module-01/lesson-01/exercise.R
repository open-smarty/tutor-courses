# Required packages
library(markovchain)
library(ggplot2)

# Scenario: A patient moves between three clinical states — Healthy (H),
# Sick (S), and Recovered (R). Each week the patient's state is recorded.
# We model this as a discrete-time, discrete-state stochastic process.

# ============================================================
# Part 1: Classify four stochastic processes
# ============================================================
# For each process below, write a comment giving:
#   (a) index set T (discrete or continuous; describe the unit)
#   (b) state space S (discrete or continuous; describe the values)
#   (c) type (one of: DT-DS, DT-CS, CT-DS, CT-CS)

# Process A: Number of new HIV diagnoses reported monthly in a district
# T: ?
# S: ?
# Type: ?

# Process B: Patient systolic blood pressure recorded every 5 minutes
# T: ?
# S: ?
# Type: ?

# Process C: Whether a patient is alive or dead — can change at any instant
# T: ?
# S: ?
# Type: ?

# Process D: Viral load (copies/mL) in a patient's blood, measured continuously
# T: ?
# S: ?
# Type: ?

# ============================================================
# Part 2: Define a 3-state health Markov chain
# ============================================================
# States: Healthy (H), Sick (S), Recovered (R)
# Transition probabilities (one-step, per week):
#   From H: stay H with prob 0.85, become S with prob 0.15, become R with prob 0
#   From S: stay S with prob 0.40, become H with prob 0.10, become R with prob 0.50
#   From R: stay R with prob 0.70, become H with prob 0.30, become S with prob 0

# TODO: Create the transition matrix as a 3x3 numeric matrix
# Rows must sum to 1; label rows and columns with state names
trans_matrix <- matrix(
  c(# H     S     R
    # TODO: fill in the probabilities from the description above
    NA,   NA,   NA,   # from H
    NA,   NA,   NA,   # from S
    NA,   NA,   NA    # from R
  ),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("H", "S", "R"), c("H", "S", "R"))
)

# TODO: Verify that each row sums to 1 (use rowSums)
rowSums(trans_matrix)

# ============================================================
# Part 3: Create a markovchain object and simulate
# ============================================================
# TODO: Use new("markovchain", ...) to create the chain object
# Hint: arguments are states, byrow, transitionMatrix, name
health_mc <- new("markovchain",
  states = c("H", "S", "R"),
  byrow  = TRUE,
  transitionMatrix = trans_matrix,
  name = "Health Chain"
)

# TODO: Print a summary of the chain
print(health_mc)

# TODO: Simulate a trajectory of 100 steps starting from state "H"
# Use markovchain::markovchainSequence() or rmarkovchain()
set.seed(42)
trajectory <- markovchainSequence(
  n     = 100,
  markovchain = health_mc,
  t0    = "H"
)

# ============================================================
# Part 4: Visualise the trajectory
# ============================================================
# TODO: Convert trajectory to a data frame with columns: step (1:100) and state
traj_df <- data.frame(
  step  = 1:100,
  state = trajectory
)

# TODO: Plot the trajectory using ggplot2 — use geom_point() and geom_line()
# Color by state. Add informative title and axis labels.
ggplot(traj_df, aes(x = step, y = state, color = state, group = 1)) +
  geom_point(size = 2) +
  geom_line(alpha = 0.4) +
  labs(
    title = "100-Step Simulation of 3-State Health Markov Chain",
    x     = "Week",
    y     = "Health State",
    color = "State"
  ) +
  theme_minimal()

# ============================================================
# Part 5: Summary statistics on the trajectory
# ============================================================
# TODO: Compute the proportion of time spent in each state
# (this is the empirical stationary distribution for this sample path)
state_counts <- table(trajectory)
state_props  <- state_counts / length(trajectory)
print(state_props)

# TODO: Write one sentence in a comment interpreting the proportion
# of time spent in state "S" (Sick). Is this consistent with the
# transition probabilities you set?
