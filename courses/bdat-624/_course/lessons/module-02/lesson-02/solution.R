# BDAT 624 — Module 2, Lesson 2 — SOLUTION
# Chapman-Kolmogorov Equations and Stationary Distributions

library(expm)
library(markovchain)
library(MASS)   # for fractions()

P <- matrix(
  c(0,   2/3, 1/3,
    3/8, 1/8, 1/2,
    1/2, 1/2, 0),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("s0", "s1", "s2"), c("s0", "s1", "s2"))
)

cat("Transition matrix P (exact fractions):\n")
print(fractions(P))

cat("\nRow sums:\n")
print(rowSums(P))   # all 1

# -----------------------------------------------------------------------
# Part 1: Matrix powers
# -----------------------------------------------------------------------

P2  <- P %^% 2
P3  <- P %^% 3
P6  <- P %^% 6
P12 <- P %^% 12

for (nm in c("P^2", "P^3", "P^6", "P^12")) {
  pow <- switch(nm, "P^2" = P2, "P^3" = P3, "P^6" = P6, "P^12" = P12)
  cat("\n", nm, ":\n", sep = "")
  print(round(pow, 4))
}
# Observation: rows become increasingly similar, converging to ~(0.3, 0.4, 0.3).

# -----------------------------------------------------------------------
# Part 2a: Stationary distribution via linear system
# -----------------------------------------------------------------------

m <- nrow(P)

# Set up (P^T - I) * pi = 0 system, then replace last row with sum = 1
A <- t(P) - diag(m)
A[m, ] <- 1      # replace last row with normalisation constraint

b <- c(rep(0, m - 1), 1)  # RHS: zeros, then 1

pi_solve <- solve(A, b)
names(pi_solve) <- c("s0", "s1", "s2")

cat("\nStationary distribution (solve method):\n")
print(round(pi_solve, 4))
# pi = (0.3, 0.4, 0.3)

# Verify pi * P = pi
cat("\nVerification pi * P:\n")
print(round(pi_solve %*% P, 4))
# Should reproduce pi_solve

# -----------------------------------------------------------------------
# Part 2b: Eigenvalue method
# -----------------------------------------------------------------------

eig <- eigen(t(P))
idx <- which.min(abs(eig$values - 1))   # eigenvector for eigenvalue = 1

pi_eig <- Re(eig$vectors[, idx])
pi_eig <- pi_eig / sum(pi_eig)          # normalise to sum = 1
names(pi_eig) <- c("s0", "s1", "s2")

cat("\nStationary distribution (eigenvalue method):\n")
print(round(pi_eig, 4))
# Should match pi_solve

cat("\nMax difference between methods:", max(abs(pi_solve - pi_eig)), "\n")

# -----------------------------------------------------------------------
# Part 3: Convergence of P^n
# -----------------------------------------------------------------------

cat("\nP^50:\n")
print(round(P %^% 50, 4))

cat("\nP^100:\n")
print(round(P %^% 100, 4))
# All rows equal to ~(0.3, 0.4, 0.3)

# -----------------------------------------------------------------------
# Part 4: Convergence plots
# -----------------------------------------------------------------------

n_max <- 50
n_seq <- 0:n_max

starts <- list(
  "Start in s0" = c(1, 0, 0),
  "Start in s1" = c(0, 1, 0),
  "Start in s2" = c(0, 0, 1)
)

state_cols  <- c("steelblue", "darkorange", "forestgreen")
state_names <- c("s0", "s1", "s2")

par(mfrow = c(1, 3))
for (start_name in names(starts)) {
  pi_0    <- starts[[start_name]]
  pi_traj <- matrix(0, nrow = length(n_seq), ncol = 3)

  for (n in n_seq) {
    pi_traj[n + 1, ] <- pi_0 %*% (P %^% n)
  }

  matplot(
    x    = n_seq,
    y    = pi_traj,
    type = "l", lty = 1, lwd = 2,
    col  = state_cols,
    ylim = c(0, 1),
    xlab = "Step n",
    ylab = expression(pi[j](n)),
    main = start_name
  )
  abline(h = pi_solve, lty = 2, col = state_cols, lwd = 1.2)
  legend("topright", legend = state_names,
         col = state_cols, lty = 1, lwd = 2, bty = "n", cex = 0.8)
}
par(mfrow = c(1, 1))

# Key observation: regardless of starting distribution, all three panels
# converge to the same stationary distribution (dashed lines) by ~n=30.
