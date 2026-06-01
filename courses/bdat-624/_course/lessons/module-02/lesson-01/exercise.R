# BDAT 624 — Module 2, Lesson 1
# The Markov Property and Transition Matrices
#
# You will need: markovchain, diagram
# Install if needed:
#   install.packages(c("markovchain", "diagram"))

library(markovchain)
library(diagram)

# -----------------------------------------------------------------------
# Part 1: Build the 3-state health Markov chain
# States: "Healthy" (0), "Sick" (1), "Dead" (2)
# -----------------------------------------------------------------------

# TODO: Define the 3x3 transition probability matrix P.
# Row order: Healthy, Sick, Dead
# Values:
#   Healthy -> Healthy: 0.7, Healthy -> Sick: 0.2, Healthy -> Dead: 0.1
#   Sick    -> Healthy: 0.1, Sick    -> Sick: 0.5, Sick    -> Dead: 0.4
#   Dead    -> Healthy: 0.0, Dead    -> Sick: 0.0, Dead    -> Dead: 1.0
P_matrix <- matrix(
  # TODO: fill in the 9 values, row by row
  data = c(NA, NA, NA,
           NA, NA, NA,
           NA, NA, NA),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("Healthy", "Sick", "Dead"),
                  c("Healthy", "Sick", "Dead"))
)

# TODO: Verify that each row sums to 1. Use rowSums().
# Print the result so you can check visually.


# TODO: Create a markovchain object using the matrix you defined above.
# Hint: use new("markovchain", transitionMatrix = P_matrix, name = "Health Model")
health_mc <- # TODO


# -----------------------------------------------------------------------
# Part 2: Plot the transition diagram
# -----------------------------------------------------------------------

# TODO: Plot the transition diagram of health_mc.
# Simply call plot() on the markovchain object.


# -----------------------------------------------------------------------
# Part 3: Multi-step probabilities — P^3
# -----------------------------------------------------------------------

# To compute P^n (matrix raised to the power n), we can use repeated
# matrix multiplication in a loop.

# TODO: Write a function mat_power(M, n) that returns M %*% M %*% ... (n times).
# Hint: start with result <- diag(nrow(M)) and loop n times multiplying by M.
mat_power <- function(M, n) {
  # TODO
}

# TODO: Compute P^3 using your function.
P3 <- # TODO

# TODO: Print P^3 and extract the entry [row "Healthy", col "Dead"].
# This is P(Dead after 3 months | start Healthy).
p_dead_3 <- # TODO
cat("P(Dead at month 3 | start Healthy) =", p_dead_3, "\n")


# -----------------------------------------------------------------------
# Part 4: Simulate 500 patient trajectories for 24 months
# -----------------------------------------------------------------------

set.seed(42)
n_patients  <- 500
n_months    <- 24
states      <- c("Healthy", "Sick", "Dead")

# TODO: Simulate trajectories using rmarkovchain().
# For each patient, simulate n_months steps starting from "Healthy".
# Store results in a matrix `trajectories` with
#   rows = patients (500), columns = months 0..24 (25 columns).
# Hint: loop over patients, use rmarkovchain(n = n_months, object = health_mc,
#         t0 = "Healthy")
trajectories <- matrix(NA, nrow = n_patients, ncol = n_months + 1)
trajectories[, 1] <- "Healthy"  # all start healthy

for (i in seq_len(n_patients)) {
  # TODO: simulate one trajectory and store in trajectories[i, 2:(n_months+1)]
}

# TODO: At each month t (columns 1 to 25), compute the proportion of
#   patients in each of the three states. Store as a data.frame or matrix.
proportions <- matrix(0, nrow = n_months + 1, ncol = 3,
                      dimnames = list(0:n_months, states))

for (t in seq_len(n_months + 1)) {
  for (s in states) {
    # TODO: fill in proportions[t, s]
  }
}

# TODO: Plot the proportions over time using matplot().
# x-axis: months 0 to 24; y-axis: proportion; three lines (one per state)
# Add a legend and axis labels.
matplot(
  x    = 0:n_months,
  y    = proportions,
  type = "l", lty = 1, lwd = 2,
  col  = c("steelblue", "darkorange", "firebrick"),
  xlab = "Month", ylab = "Proportion of patients",
  main = "Patient state proportions over 24 months (n = 500)"
)
legend("topright", legend = states,
       col = c("steelblue", "darkorange", "firebrick"), lty = 1, lwd = 2)


# -----------------------------------------------------------------------
# Part 5: Identify absorbing states
# -----------------------------------------------------------------------

# TODO: Use the markovchain package function absorbingStates() to find
#   the absorbing states of health_mc. Print the result.
