# BDAT 624 — Module 2, Lesson 3
# State Classification — Recurrence, Transience, and Ergodicity
#
# You will need: markovchain, expm
# Install if needed:
#   install.packages(c("markovchain", "expm"))

library(markovchain)
library(expm)

# -----------------------------------------------------------------------
# Chain A: the alternating chain  P = [[0,1],[1,0]]
# -----------------------------------------------------------------------

P_alt <- matrix(
  c(0, 1,
    1, 0),
  nrow = 2, byrow = TRUE,
  dimnames = list(c("s0", "s1"), c("s0", "s1"))
)

# TODO: Create a markovchain object for P_alt called alt_mc.


# -----------------------------------------------------------------------
# Chain B: the 3-state regular chain from Lesson 2
# -----------------------------------------------------------------------

P_reg <- matrix(
  c(0,   2/3, 1/3,
    3/8, 1/8, 1/2,
    1/2, 1/2, 0),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("s0", "s1", "s2"), c("s0", "s1", "s2"))
)

# TODO: Create a markovchain object for P_reg called reg_mc.


# -----------------------------------------------------------------------
# Part 1: Irreducibility and period
# -----------------------------------------------------------------------

# TODO: For each chain, test irreducibility using is.irreducible().
#   Print TRUE/FALSE for alt_mc and reg_mc.
cat("Alternating chain irreducible?", is.irreducible(alt_mc), "\n")
cat("Regular chain irreducible?    ", is.irreducible(reg_mc), "\n")

# TODO: Compute the period of each chain using period().
#   (This returns the period of the chain — all states share the same
#    period if the chain is irreducible.)
cat("Alternating chain period:", period(alt_mc), "\n")
cat("Regular chain period:    ", period(reg_mc), "\n")


# -----------------------------------------------------------------------
# Part 2: Non-convergence of the alternating chain
# -----------------------------------------------------------------------

# TODO: Compute P_alt^n for n = 2, 4, 6, 8 using %^%.
#   Print each. Verify that even powers equal I and odd powers equal P_alt.

for (n in c(2, 4, 6, 8)) {
  cat("\nP_alt ^", n, ":\n")
  # TODO: print P_alt %^% n
}

# TODO: Compute and print P_alt^3 and P_alt^5 to show odd powers = P_alt.


# -----------------------------------------------------------------------
# Part 3: Convergence of the regular chain
# -----------------------------------------------------------------------

# TODO: Use steadyStates() on reg_mc to find the stationary distribution.
cat("\nStationary distribution of regular chain:\n")
# TODO

# TODO: Print P_reg^50 and verify all rows equal the stationary distribution.
cat("\nP_reg^50:\n")
# TODO


# -----------------------------------------------------------------------
# Part 4: Reflecting random walk on {0, 1, ..., 10}
# -----------------------------------------------------------------------

# Build the TPM for a simple random walk on states {0, 1, ..., 10}
# with reflecting boundaries:
#   - At state 0: always move to state 1 (reflect)
#   - At state 10: always move to state 9 (reflect)
#   - At interior states i (1..9): move to i-1 or i+1 with prob 0.5 each

n_states <- 11
states_rw <- as.character(0:10)

P_rw <- matrix(0, nrow = n_states, ncol = n_states,
               dimnames = list(states_rw, states_rw))

# TODO: Fill in the TPM P_rw row by row.
# Row 0 (reflecting boundary): P_rw["0", "1"] = 1
# Row 10 (reflecting boundary): P_rw["10", "9"] = 1
# Rows 1..9 (interior): P_rw[i, i-1] = 0.5, P_rw[i, i+1] = 0.5


# TODO: Verify row sums.
cat("\nRow sums of P_rw (should all be 1):\n")
# TODO

# TODO: Create a markovchain object rw_mc from P_rw.


# TODO: Simulate 1000 steps of the random walk starting at state "5".
#   Use rmarkovchain(n = 1000, object = rw_mc, t0 = "5").
set.seed(99)
rw_sim <- # TODO

# TODO: Compute the empirical state visit frequency from rw_sim.
#   Use table(rw_sim) / length(rw_sim) and sort by state name.


# TODO: Find the theoretical stationary distribution using steadyStates() on rw_mc.


# TODO: Plot a bar chart comparing the empirical visit frequencies (grey bars)
#   to the theoretical stationary probabilities (red dots or line).
#   Hint: use barplot() for the empirical frequencies, then points() for theory.

# For a symmetric random walk with reflecting boundaries on {0,...,N},
# the stationary distribution is: pi_0 = pi_N = 1/(2N), pi_i = 1/N for i=1..N-1.
# Compute this analytically for N=10 and compare.
N <- 10
pi_theory <- c(1/(2*N), rep(1/N, N-1), 1/(2*N))
names(pi_theory) <- states_rw

cat("\nTheoretical stationary distribution (analytic):\n")
print(round(pi_theory, 4))
