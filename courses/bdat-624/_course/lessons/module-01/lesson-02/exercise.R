# BDAT 624 — Module 1, Lesson 2
# Exercise: Transition Probability Matrices and Patient Health Simulation
#
# Instructions: Complete each TODO section below.
# After finishing, run: npm run check -- bdat-624 module-01 lesson-02

library(ggplot2)
library(dplyr)
library(tidyr)
library(markovchain)

set.seed(2024)  # do not change

# ============================================================
# PART 1: Build the transition probability matrix
# ============================================================

# States: 1 = Healthy, 2 = Sick, 3 = Dead
# One-month transition probabilities (partially filled — you complete it):
#
#           To:  H     S     D
# From H:       0.85  0.12  ???    <- row must sum to 1
# From S:       0.40  ???   0.10   <- row must sum to 1
# From D:       0.00  0.00  1.00   <- absorbing state (already complete)

# TODO 1: Fill in the two missing entries (marked ???) so that each row sums to 1.
# Then construct the matrix P using matrix(), nrow=3, byrow=TRUE.
# Use the state labels: states <- c("Healthy", "Sick", "Dead")

states <- c("Healthy", "Sick", "Dead")

P <- matrix(
  c(
    0.85, 0.12, ???,   # row 1: Healthy -> Healthy, Sick, Dead
    0.40, ???,  0.10,  # row 2: Sick -> Healthy, Sick, Dead
    0.00, 0.00, 1.00   # row 3: Dead -> Healthy, Sick, Dead (absorbing)
  ),
  nrow = 3, byrow = TRUE,
  dimnames = list(states, states)
)

# TODO 2: Verify that P is a stochastic matrix.
# Print the row sums of P. They should all equal 1.
# Hint: rowSums(P)

# --- your code here ---

# ============================================================
# PART 2: Create a markovchain object
# ============================================================

# TODO 3: Create a markovchain object called `health_mc`.
# Use: health_mc <- new("markovchain", states = states, transitionMatrix = P,
#                        name = "Patient Health Model")
# Then print it to see its summary.

health_mc <- NULL  # replace NULL
# --- your code here ---

# ============================================================
# PART 3: Compute multi-step transition probabilities
# ============================================================

# TODO 4: Compute the 6-step transition matrix (P^6) using matrix multiplication.
# Name the result P6.
# Hint: in R, matrix multiplication uses %*%. Multiply P by itself 6 times,
#       OR use the markovchain method: health_mc^6

P6 <- NULL  # replace NULL
# --- your code here ---

# Print P6 and answer: what is P(Dead at month 6 | Healthy at month 0)?
# (That is the [1, 3] entry of P6)
cat("P(Dead at month 6 | Healthy at month 0) =",
    round(P6["Healthy", "Dead"], 4), "\n")

# ============================================================
# PART 4: Simulate 200 patients over 12 months
# ============================================================

n_patients <- 200
n_months   <- 12

# All patients start Healthy
# TODO 5: Simulate each patient's trajectory using markovchainSequence().
# - For each patient p in 1:n_patients:
#     Use markovchainSequence(n = n_months, markovchain = health_mc, t0 = "Healthy")
#     This returns a character vector of length n_months (states visited AFTER t0).
#     Store results in a matrix `sim` of size n_patients x n_months.
#     Each row is one patient's trajectory (months 1 through 12).
#
# Hint: sim <- matrix(NA, nrow=n_patients, ncol=n_months)
#       for(p in 1:n_patients) { sim[p, ] <- markovchainSequence(...) }

sim <- matrix(NA, nrow = n_patients, ncol = n_months)
# --- your code here ---

# ============================================================
# PART 5: Compute proportion in each state over time
# ============================================================

# TODO 6: For each month t in 1:n_months, compute the proportion of patients
# in each state. Store results in a data frame `prop_df` with columns:
#   month, state, proportion
#
# Hint: use table(sim[, t]) / n_patients to get the proportions at month t.
# You will need to combine results across all months.
# Consider building a list of data frames, one per month, then using bind_rows().

prop_df <- NULL  # replace NULL
# --- your code here ---

# ============================================================
# PART 6: Plot — stacked bar chart of state proportions over time
# ============================================================

# TODO 7: Create a stacked bar chart using ggplot2.
# - x-axis: month (1 to 12)
# - y-axis: proportion (0 to 1)
# - fill: state (Healthy, Sick, Dead)
# - Use geom_col() with position = "stack"
# - Colour manually: Healthy = "#4dac26", Sick = "#f4a582", Dead = "#ca0020"
# - Add a title: "Patient State Proportions Over 12 Months (n=200)"
# - x-label: "Month", y-label: "Proportion of Patients"
# - theme_minimal()

# --- your code here ---

# ============================================================
# PART 7: Time-to-death distribution
# ============================================================

# TODO 8: For each patient, find the first month they entered the Dead state.
# - Create a vector `time_to_death` of length n_patients.
# - For patient p, find the minimum t such that sim[p, t] == "Dead".
#   If the patient never died within 12 months, record NA.
# Hint: use which(sim[p, ] == "Dead")[1]

time_to_death <- rep(NA, n_patients)
# --- your code here ---

# Plot: histogram of time-to-death (exclude NAs)
# Add a vertical dashed line at the median (ignoring NAs)
# Title: "Time-to-Death Distribution (patients who died within 12 months)"

# --- your code here ---
