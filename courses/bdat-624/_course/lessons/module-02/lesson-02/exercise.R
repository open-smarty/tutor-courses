# Required packages
library(markovchain)
library(ggplot2)
library(dplyr)

# Scenario: A 3-state health chain (Healthy=H, Sick=S, Recovered=R).
# We investigate the n-step TPM, observe convergence to the stationary
# distribution, and verify the Chapman-Kolmogorov equations numerically.

# ============================================================
# Task 1: Set up the TPM
# ============================================================
# From the lesson example:
#   From H:  stay H=0.85, go S=0.15, go R=0.00
#   From S:  go H=0.10, stay S=0.40, go R=0.50
#   From R:  go H=0.30, go S=0.00, stay R=0.70

# TODO: Build the transition matrix P
P <- matrix(
  c(0.85, 0.15, 0.00,
    0.10, 0.40, 0.50,
    0.30, 0.00, 0.70),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("H","S","R"), c("H","S","R"))
)

# Helper: raise matrix to integer power
mat_power <- function(M, n) {
  result <- diag(nrow(M))
  for (i in seq_len(n)) result <- result %*% M
  result
}

# ============================================================
# Task 2: Compute P^1, P^5, P^50 and observe convergence
# ============================================================
# TODO: Compute and print P^1, P^5, P^50 (rounded to 5 decimal places)
P1  <- mat_power(P, 1)
P5  <- mat_power(P, 5)
P50 <- mat_power(P, 50)

cat("P^1:\n");  print(round(P1, 5))
cat("\nP^5:\n"); print(round(P5, 5))
cat("\nP^50:\n"); print(round(P50, 5))

# TODO: Write a comment describing what happens to the rows of P^n as n grows.
# Do the rows converge? What does each row converge to?

# ============================================================
# Task 3: Verify Chapman-Kolmogorov numerically
# ============================================================
# The C-K equation says: P^(m+n) = P^m %*% P^n
# Choose m=3, n=7 (so we check P^10 = P^3 %*% P^7)

m <- 3; n_step <- 7

# TODO: Compute P^m, P^n_step, P^(m+n) separately
Pm     <- mat_power(P, m)
Pn     <- mat_power(P, n_step)
Pm_pn  <- mat_power(P, m + n_step)

# TODO: Compute Pm %*% Pn and compare to Pm_pn using all.equal
CK_product  <- Pm %*% Pn
cat("\nC-K verification: P^3 %*% P^7 == P^10?\n")
cat("max absolute difference:", max(abs(CK_product - Pm_pn)), "\n")
# Should be ~0 (only floating point rounding error)

# ============================================================
# Task 4: Find the stationary distribution algebraically
# ============================================================
# The stationary distribution pi satisfies: pi %*% P = pi, sum(pi)=1.
# Equivalently: pi %*% (P - I) = 0, plus sum(pi)=1.
#
# Method: solve the linear system A^T x = b where we replace the last
# equation with the normalisation constraint.

# TODO: Form the system matrix A for pi (P - I) = 0 plus normalisation
# Approach: take (P - I), transpose it (to get a column system),
# then replace the last row with (1,1,...,1) and set rhs b=(0,...,0,1)

A <- t(P - diag(3))            # (P - I)^T; system: A %*% pi^T = 0
A[3, ] <- 1                    # replace last equation with normalisation
b <- c(0, 0, 1)                # rhs: last element is 1 (sum = 1)

# TODO: Solve for pi_stationary using solve(A, b)
pi_stationary <- solve(A, b)
names(pi_stationary) <- c("H", "S", "R")

cat("\nStationary distribution (algebraic):\n")
print(round(pi_stationary, 5))
cat("Sum:", sum(pi_stationary), "\n")

# ============================================================
# Task 5: Compare to the row-convergence estimate
# ============================================================
# The rows of P^50 should approximate pi.

# TODO: Print the first row of P^50 and compare to pi_stationary
cat("\nFirst row of P^50 (empirical stationary):\n")
print(round(P50[1, ], 5))

cat("\nAbsolute difference (P^50 row 1 vs algebraic pi):\n")
print(round(abs(P50[1, ] - pi_stationary), 8))

# TODO: Also verify pi satisfies pi %*% P = pi (check error)
pi_check <- pi_stationary %*% P
cat("\npi %*% P:\n"); print(round(as.numeric(pi_check), 5))
cat("max deviation from pi:", max(abs(pi_check - pi_stationary)), "\n")

# ============================================================
# Task 6: Use markovchain package to find stationary distribution
# ============================================================
# The markovchain package computes it via steadyStates()

# TODO: Create a markovchain object and call steadyStates()
mc3 <- new("markovchain",
  states = c("H", "S", "R"), byrow = TRUE,
  transitionMatrix = P, name = "3-State Health"
)

cat("\nSteady state via markovchain package:\n")
print(steadyStates(mc3))

# TODO: Write a comment on the mean return times:
# mean return time to state i = 1 / pi_i
cat("\nMean return times (1/pi_i):\n")
print(round(1 / pi_stationary, 2))
# Interpret: on average, how many steps between visits to each state?

# ============================================================
# Task 7: Plot the evolution of a row of P^n as n increases
# ============================================================
# Observe convergence of the distribution from a single starting state

start_state <- "S"  # start in Sick
e_S <- c(H = 0, S = 1, R = 0)  # initial distribution: all in S

ns <- c(1, 2, 3, 5, 10, 20, 50, 100)
evo <- lapply(ns, function(n) {
  dist_n <- e_S %*% mat_power(P, n)
  data.frame(n = n, state = c("H","S","R"), prob = as.numeric(dist_n))
}) |> bind_rows()

evo$state <- factor(evo$state, levels = c("H","S","R"))

# TODO: Add a horizontal reference line at the stationary probability
# for each state. Use geom_hline() with linetype="dashed".
pi_df <- data.frame(state = names(pi_stationary),
                    pi    = as.numeric(pi_stationary))
evo <- left_join(evo, pi_df, by = "state")

ggplot(evo, aes(x = n, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5) +
  geom_hline(aes(yintercept = pi, color = state), linetype = "dashed") +
  scale_x_log10() +
  labs(
    title    = "Convergence of State Distribution to Stationary π",
    subtitle = "Dashed lines = stationary distribution π; log scale on x-axis",
    x = "Number of steps (log scale)", y = "Probability", color = "State"
  ) +
  theme_minimal()
