# BDAT 624 — Module 2, Lesson 3 — SOLUTION
# State Classification — Recurrence, Transience, and Ergodicity

library(markovchain)
library(expm)

# -----------------------------------------------------------------------
# Chain A: alternating chain
# -----------------------------------------------------------------------

P_alt <- matrix(
  c(0, 1,
    1, 0),
  nrow = 2, byrow = TRUE,
  dimnames = list(c("s0", "s1"), c("s0", "s1"))
)

alt_mc <- new("markovchain",
              transitionMatrix = P_alt,
              name = "Alternating Chain")

# -----------------------------------------------------------------------
# Chain B: 3-state regular chain from Lesson 2
# -----------------------------------------------------------------------

P_reg <- matrix(
  c(0,   2/3, 1/3,
    3/8, 1/8, 1/2,
    1/2, 1/2, 0),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("s0", "s1", "s2"), c("s0", "s1", "s2"))
)

reg_mc <- new("markovchain",
              transitionMatrix = P_reg,
              name = "3-State Regular Chain")

# -----------------------------------------------------------------------
# Part 1: Irreducibility and period
# -----------------------------------------------------------------------

cat("Alternating chain irreducible?", is.irreducible(alt_mc), "\n")  # TRUE
cat("Regular chain irreducible?    ", is.irreducible(reg_mc), "\n")  # TRUE

cat("Alternating chain period:", period(alt_mc), "\n")  # 2
cat("Regular chain period:    ", period(reg_mc), "\n")  # 1

# -----------------------------------------------------------------------
# Part 2: Non-convergence of the alternating chain
# -----------------------------------------------------------------------

cat("\n--- Powers of the alternating chain ---\n")
for (n in c(2, 4, 6, 8)) {
  cat("\nP_alt ^", n, ":\n")
  print(P_alt %^% n)
}
# Even powers: identity matrix I
# Odd powers: P_alt itself

cat("\nP_alt^3:\n"); print(P_alt %^% 3)   # = P_alt
cat("\nP_alt^5:\n"); print(P_alt %^% 5)   # = P_alt

# Conclusion: P_alt^n alternates between I and P_alt — no convergence.

# -----------------------------------------------------------------------
# Part 3: Convergence of the regular chain
# -----------------------------------------------------------------------

cat("\nStationary distribution of regular chain:\n")
pi_reg <- steadyStates(reg_mc)
print(round(pi_reg, 4))
# Expected: s0=0.3, s1=0.4, s2=0.3

cat("\nP_reg^50:\n")
P50 <- P_reg %^% 50
print(round(P50, 4))
# All rows ≈ (0.3, 0.4, 0.3)

cat("\nMax row deviation from stationary dist at n=50:",
    max(abs(P50 - rep(1, 3) %o% pi_reg)), "\n")

# -----------------------------------------------------------------------
# Part 4: Reflecting random walk on {0, 1, ..., 10}
# -----------------------------------------------------------------------

n_states <- 11
states_rw <- as.character(0:10)

P_rw <- matrix(0, nrow = n_states, ncol = n_states,
               dimnames = list(states_rw, states_rw))

# Reflecting boundaries
P_rw["0",  "1"]  <- 1.0
P_rw["10", "9"]  <- 1.0

# Interior states
for (i in 1:9) {
  s <- as.character(i)
  P_rw[s, as.character(i - 1)] <- 0.5
  P_rw[s, as.character(i + 1)] <- 0.5
}

cat("\nRow sums of P_rw:\n")
print(rowSums(P_rw))   # all 1

rw_mc <- new("markovchain",
             transitionMatrix = P_rw,
             name = "Reflecting Random Walk")

# Simulate 1000 steps starting from state "5"
set.seed(99)
rw_sim <- rmarkovchain(n = 1000, object = rw_mc, t0 = "5")

# Empirical visit frequency
emp_freq <- table(rw_sim) / length(rw_sim)
emp_freq_vec <- as.numeric(emp_freq[states_rw])
emp_freq_vec[is.na(emp_freq_vec)] <- 0
names(emp_freq_vec) <- states_rw

cat("\nEmpirical visit frequency (1000 steps):\n")
print(round(emp_freq_vec, 4))

# Theoretical stationary distribution from steadyStates()
pi_rw_mc <- steadyStates(rw_mc)[1, ]   # single row
cat("\nStationary distribution (steadyStates):\n")
print(round(pi_rw_mc, 4))

# Analytic formula: pi_0 = pi_10 = 1/20; pi_i = 1/10 for i=1..9
N <- 10
pi_theory <- c(1/(2*N), rep(1/N, N-1), 1/(2*N))
names(pi_theory) <- states_rw
cat("\nStationary distribution (analytic formula):\n")
print(round(pi_theory, 4))

# Plot comparison
bp <- barplot(
  emp_freq_vec,
  col   = "grey75",
  names.arg = states_rw,
  xlab  = "State",
  ylab  = "Probability / Frequency",
  main  = "Reflecting random walk: empirical vs. theoretical stationary distribution",
  ylim  = c(0, max(emp_freq_vec, pi_theory) * 1.3),
  border = NA
)
points(bp, pi_theory, col = "firebrick", pch = 19, cex = 1.4)
lines(bp,  pi_theory, col = "firebrick", lwd = 2, lty = 2)
legend("top",
       legend = c("Empirical (1000 steps)", "Theoretical (analytic)"),
       col    = c("grey60", "firebrick"),
       pch    = c(15, 19), lty = c(NA, 2), lwd = c(NA, 2),
       bty    = "n", horiz = TRUE)

# Note: boundary states 0 and 10 have half the stationary probability of
# interior states, because the walk bounces back immediately from the boundary.
cat("\nNote: pi(0) = pi(10) =", round(pi_theory["0"], 4),
    "= half of interior pi =", round(pi_theory["1"], 4), "\n")
