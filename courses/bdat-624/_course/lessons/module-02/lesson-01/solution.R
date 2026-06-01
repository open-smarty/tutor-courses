# BDAT 624 — Module 2, Lesson 1 — SOLUTION
# The Markov Property and Transition Matrices

library(markovchain)
library(diagram)

# -----------------------------------------------------------------------
# Part 1: Build the 3-state health Markov chain
# -----------------------------------------------------------------------

P_matrix <- matrix(
  data = c(0.7, 0.2, 0.1,
           0.1, 0.5, 0.4,
           0.0, 0.0, 1.0),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("Healthy", "Sick", "Dead"),
                  c("Healthy", "Sick", "Dead"))
)

# Verify row sums
cat("Row sums of P:\n")
print(rowSums(P_matrix))
# Expected: Healthy=1, Sick=1, Dead=1

# Create the markovchain object
health_mc <- new("markovchain",
                 transitionMatrix = P_matrix,
                 name = "3-State Health Model")
print(health_mc)

# -----------------------------------------------------------------------
# Part 2: Transition diagram
# -----------------------------------------------------------------------

plot(health_mc, main = "3-State Health Model — Transition Diagram",
     vertex.color = c("lightblue", "lightyellow", "lightcoral"),
     edge.label.cex = 0.9)

# -----------------------------------------------------------------------
# Part 3: Multi-step probabilities — P^3
# -----------------------------------------------------------------------

mat_power <- function(M, n) {
  result <- diag(nrow(M))
  for (i in seq_len(n)) {
    result <- result %*% M
  }
  result
}

P3 <- mat_power(P_matrix, 3)
cat("\nP^3 (3-step transition matrix):\n")
print(round(P3, 4))

p_dead_3 <- P3["Healthy", "Dead"]
cat("\nP(Dead at month 3 | start Healthy) =", round(p_dead_3, 4), "\n")
# Interpretation: ~27% probability of being dead by month 3 starting healthy.

# -----------------------------------------------------------------------
# Part 4: Simulate 500 patient trajectories for 24 months
# -----------------------------------------------------------------------

set.seed(42)
n_patients <- 500
n_months   <- 24
states     <- c("Healthy", "Sick", "Dead")

trajectories <- matrix(NA_character_, nrow = n_patients, ncol = n_months + 1)
trajectories[, 1] <- "Healthy"

for (i in seq_len(n_patients)) {
  path <- rmarkovchain(n = n_months, object = health_mc, t0 = "Healthy")
  trajectories[i, 2:(n_months + 1)] <- path
}

# Compute proportions at each time point
proportions <- matrix(0, nrow = n_months + 1, ncol = 3,
                      dimnames = list(0:n_months, states))

for (t in seq_len(n_months + 1)) {
  for (s in states) {
    proportions[t, s] <- mean(trajectories[, t] == s)
  }
}

# Plot
matplot(
  x    = 0:n_months,
  y    = proportions,
  type = "l", lty = 1, lwd = 2,
  col  = c("steelblue", "darkorange", "firebrick"),
  ylim = c(0, 1),
  xlab = "Month",
  ylab = "Proportion of patients",
  main = "Patient state proportions over 24 months (n = 500)"
)
legend("topright",
       legend = states,
       col    = c("steelblue", "darkorange", "firebrick"),
       lty = 1, lwd = 2, bty = "n")

# Compare simulation at month 3 to P^3
cat("\nSimulated P(Dead at month 3 | start Healthy) =",
    round(proportions["3", "Dead"], 4), "\n")
cat("Theoretical P^3[Healthy, Dead]              =",
    round(p_dead_3, 4), "\n")

# -----------------------------------------------------------------------
# Part 5: Absorbing states
# -----------------------------------------------------------------------

abs_states <- absorbingStates(health_mc)
cat("\nAbsorbing states:", abs_states, "\n")
# Expected: "Dead"

# Bonus: verify by checking which rows have P_ii = 1
diag_vals <- diag(P_matrix)
cat("Diagonal entries of P:", diag_vals, "\n")
cat("States with P_ii = 1:", names(diag_vals)[diag_vals == 1], "\n")
