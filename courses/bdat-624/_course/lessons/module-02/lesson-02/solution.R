# SOLUTION: Module 02 Lesson 02 — Chapman-Kolmogorov and Stationary Distributions
library(markovchain)
library(ggplot2)
library(dplyr)

# ============================================================
# Task 1: Setup
# ============================================================
P <- matrix(
  c(0.85, 0.15, 0.00,
    0.10, 0.40, 0.50,
    0.30, 0.00, 0.70),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("H","S","R"), c("H","S","R"))
)

mat_power <- function(M, n) {
  result <- diag(nrow(M))
  for (i in seq_len(n)) result <- result %*% M
  result
}

# ============================================================
# Task 2: Matrix powers
# ============================================================
P1  <- mat_power(P, 1)
P5  <- mat_power(P, 5)
P50 <- mat_power(P, 50)

cat("P^1:\n");  print(round(P1, 5))
cat("\nP^5:\n"); print(round(P5, 5))
cat("\nP^50:\n"); print(round(P50, 5))

# Convergence comment: As n increases, all rows of P^n approach the same
# vector (approximately 0.60, 0.15, 0.25 for H, S, R). By P^50, each row
# is virtually identical — the process has "forgotten" its starting state.
# This common row vector is the stationary distribution π.

# ============================================================
# Task 3: C-K verification
# ============================================================
m <- 3; n_step <- 7
Pm    <- mat_power(P, m)
Pn    <- mat_power(P, n_step)
Pm_pn <- mat_power(P, m + n_step)
CK_product <- Pm %*% Pn

cat("\nC-K verification: P^3 %*% P^7 == P^10?\n")
cat("max absolute difference:", max(abs(CK_product - Pm_pn)), "\n")
# Should be ~1e-16 (floating point precision only)

# ============================================================
# Task 4: Stationary distribution
# ============================================================
A <- t(P - diag(3))
A[3, ] <- 1
b <- c(0, 0, 1)
pi_stationary <- solve(A, b)
names(pi_stationary) <- c("H", "S", "R")

cat("\nStationary distribution (algebraic):\n")
print(round(pi_stationary, 5))
cat("Sum:", sum(pi_stationary), "\n")
# Expected: H=0.60, S=0.15, R=0.25 (matches manual derivation in lesson)

# ============================================================
# Task 5: Row convergence check
# ============================================================
cat("\nFirst row of P^50:\n")
print(round(P50[1, ], 5))

cat("\nDifference (P^50 row 1 - algebraic pi):\n")
print(round(abs(P50[1, ] - pi_stationary), 8))
# Near-zero difference confirms convergence

cat("\npi %*% P (should equal pi):\n")
pi_check <- pi_stationary %*% P
print(round(as.numeric(pi_check), 5))
cat("Max deviation:", max(abs(pi_check - pi_stationary)), "\n")

# ============================================================
# Task 6: markovchain package
# ============================================================
mc3 <- new("markovchain",
  states = c("H","S","R"), byrow = TRUE,
  transitionMatrix = P, name = "3-State Health"
)
cat("\nSteady states (markovchain package):\n")
print(steadyStates(mc3))

cat("\nMean return times (1/pi_i):\n")
print(round(1 / pi_stationary, 3))
# H: 1/0.60 ≈ 1.67 weeks — return to Healthy every ~1.67 weeks on average
# S: 1/0.15 ≈ 6.67 weeks — return to Sick about once every 6.67 weeks
# R: 1/0.25 = 4.00 weeks — return to Recovered every 4 weeks on average

# ============================================================
# Task 7: Convergence plot
# ============================================================
e_S <- c(H = 0, S = 1, R = 0)
ns  <- c(1, 2, 3, 5, 10, 20, 50, 100)

evo <- lapply(ns, function(n) {
  dist_n <- e_S %*% mat_power(P, n)
  data.frame(n = n, state = c("H","S","R"), prob = as.numeric(dist_n))
}) |> bind_rows()

evo$state <- factor(evo$state, levels = c("H","S","R"))

pi_df <- data.frame(state  = factor(names(pi_stationary), levels = c("H","S","R")),
                    pi_val = as.numeric(pi_stationary))
evo <- left_join(evo, pi_df, by = "state")

p <- ggplot(evo, aes(x = n, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5) +
  geom_hline(aes(yintercept = pi_val, color = state), linetype = "dashed", linewidth = 0.8) +
  scale_x_log10() +
  scale_color_manual(values = c("H" = "#2ecc71", "S" = "#e74c3c", "R" = "#3498db")) +
  labs(
    title    = "Convergence of State Distribution to Stationary π",
    subtitle = "Dashed lines = stationary distribution; starting from Sick state; log-x scale",
    x = "Number of steps (log scale)", y = "Probability", color = "State"
  ) +
  theme_minimal(base_size = 13)
print(p)
