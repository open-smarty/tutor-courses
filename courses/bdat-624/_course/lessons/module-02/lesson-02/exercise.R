# BDAT 624 — Module 2, Lesson 2
# Chapman-Kolmogorov Equations and Stationary Distributions
#
# You will need: expm, markovchain
# Install if needed:
#   install.packages(c("expm", "markovchain"))

library(expm)       # provides %^% for matrix powers
library(markovchain)

# -----------------------------------------------------------------------
# The 3x3 TPM from the worked example (Dr. Asiedu's notes, p. 15-16)
# -----------------------------------------------------------------------

P <- matrix(
  c(0,   2/3, 1/3,
    3/8, 1/8, 1/2,
    1/2, 1/2, 0),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("s0", "s1", "s2"), c("s0", "s1", "s2"))
)

cat("Transition matrix P:\n")
print(fractions(P))   # display as fractions for readability

# TODO: Verify row sums using rowSums().


# -----------------------------------------------------------------------
# Part 1: Compute P^2, P^3, P^6, P^12 using the %^% operator from expm
# -----------------------------------------------------------------------

# TODO: Compute P^2, P^3, P^6, and P^12.
# Use the %^% operator: e.g., P %^% 2
P2  <- # TODO
P3  <- # TODO
P6  <- # TODO
P12 <- # TODO

# TODO: Print each matrix, rounded to 4 decimal places.
# Observe how the rows begin to look similar as n increases.


# -----------------------------------------------------------------------
# Part 2a: Find the stationary distribution by solving pi * P = pi
# -----------------------------------------------------------------------

# We solve the system: pi * (P - I) = 0  with  sum(pi) = 1
# Strategy: replace one equation from (P - I) with the normalisation
# constraint, then solve the resulting linear system A * pi = b.

m <- nrow(P)

# TODO: Construct the coefficient matrix A.
# Start with A = t(P) - diag(m)   (note: we solve pi P = pi as a column system
# by transposing: (P^T - I) %*% pi_col = 0).
# Then replace the LAST row of A with all 1s (the normalisation constraint).
A <- # TODO

# TODO: Construct the right-hand side vector b.
# It is all zeros except the last entry, which is 1 (normalisation).
b <- # TODO

# TODO: Solve for pi using solve(A, b). This gives a column vector.
pi_solve <- # TODO
names(pi_solve) <- c("s0", "s1", "s2")

cat("\nStationary distribution (solve method):\n")
print(round(pi_solve, 4))
# Expected: pi ≈ (0.3, 0.4, 0.3)

# TODO: Verify: print pi %*% P and check it equals pi (up to rounding).


# -----------------------------------------------------------------------
# Part 2b: Find the stationary distribution via eigenvalue decomposition
# -----------------------------------------------------------------------

# The stationary distribution is the LEFT eigenvector of P with eigenvalue 1.
# In R, eigen() computes RIGHT eigenvectors of a matrix.
# The LEFT eigenvectors of P are the RIGHT eigenvectors of t(P).

# TODO: Compute eigen(t(P)).
eig <- # TODO

# TODO: Find the index of the eigenvalue closest to 1.
#   eigenvalues are in eig$values; use which.min(abs(eig$values - 1)).
idx <- # TODO

# TODO: Extract the corresponding eigenvector and normalise it to sum to 1.
#   Note: eigenvectors may have small imaginary parts due to floating point;
#   use Re() to take the real part.
pi_eig <- Re(eig$vectors[, idx])
pi_eig <- pi_eig / sum(pi_eig)
names(pi_eig) <- c("s0", "s1", "s2")

cat("\nStationary distribution (eigenvalue method):\n")
print(round(pi_eig, 4))


# -----------------------------------------------------------------------
# Part 3: Verify convergence — does P^n approach the stable matrix?
# -----------------------------------------------------------------------

# TODO: Print P^50 and P^100. Check that all rows are approximately equal
#   to the stationary distribution pi_solve.
cat("\nP^50:\n")
print(round(P %^% 50, 4))

cat("\nP^100:\n")
# TODO


# -----------------------------------------------------------------------
# Part 4: Plot convergence of marginal state probabilities
# -----------------------------------------------------------------------

# For three different starting distributions, compute pi(n) = pi(0) * P^n
# and plot pi_j(n) for each state j over n = 0, 1, ..., 50.

n_max <- 50
n_seq <- 0:n_max

# Three starting distributions (row vectors)
starts <- list(
  "Start in s0" = c(1, 0, 0),
  "Start in s1" = c(0, 1, 0),
  "Start in s2" = c(0, 0, 1)
)

# State colours
state_cols <- c("steelblue", "darkorange", "forestgreen")
state_names <- c("s0", "s1", "s2")

# TODO: For each starting distribution and each n in n_seq, compute
#   pi_n = pi_0 %*% (P %^% n) and store the probability of each state.
# Then use matplot() (or plot + lines) to show the three marginal
# probabilities converging to pi_solve as n increases.
# Add horizontal dashed lines at the stationary probabilities.

par(mfrow = c(1, 3))
for (start_name in names(starts)) {
  pi_0    <- starts[[start_name]]
  pi_traj <- matrix(0, nrow = length(n_seq), ncol = 3)

  for (n in n_seq) {
    # TODO: compute pi_traj[n + 1, ] = pi_0 %*% (P %^% n)
  }

  matplot(
    x    = n_seq,
    y    = pi_traj,
    type = "l", lty = 1, lwd = 2,
    col  = state_cols,
    ylim = c(0, 1),
    xlab = "Step n", ylab = "Probability",
    main = start_name
  )
  # TODO: add horizontal dashed lines for each stationary probability
  abline(h = pi_solve, lty = 2, col = state_cols)
  legend("topright", legend = state_names,
         col = state_cols, lty = 1, lwd = 2, bty = "n", cex = 0.8)
}
par(mfrow = c(1, 1))
