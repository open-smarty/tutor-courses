# BDAT 624 — Module 3, Lesson 1: Branching Processes
# Exercise: Simulation, Fixed-Point Iteration, and Moment Verification
#
# Prerequisites: base R only (no external packages required for core exercises;
# ggplot2 is used for plotting — install if needed).
#
# Run: npm run check -- bdat-624 module-03 lesson-01

library(ggplot2)
library(gridExtra)

set.seed(42)  # reproducibility

# ============================================================
# HELPER: simulate one branching process
#   offspring_fn : a function that takes (n) and returns n i.i.d. offspring counts
#   generations  : number of generations to simulate
#   Returns a numeric vector of length (generations + 1): X_0, X_1, ..., X_G
# ============================================================

simulate_branching <- function(offspring_fn, generations = 20) {
  X <- numeric(generations + 1)
  X[1] <- 1L  # X_0 = 1
  for (g in seq_len(generations)) {
    current_size <- X[g]
    if (current_size == 0L) {
      X[(g + 1):(generations + 1)] <- 0
      break
    }
    X[g + 1] <- sum(offspring_fn(current_size))
  }
  X
}

# ============================================================
# PART 1 — Subcritical: offspring ~ Poisson(lambda = 0.8), m = 0.8 < 1
# ============================================================

N_SIM       <- 1000
GENERATIONS <- 20
lambda_sub  <- 0.8   # subcritical

# TODO: simulate N_SIM branching processes for GENERATIONS generations
#   with offspring ~ Poisson(lambda_sub).
#   Store results in a matrix `sims_sub` of dimension (GENERATIONS+1) x N_SIM,
#   where column j is the j-th simulated trajectory X_0, X_1, ..., X_20.
#   Hint: use replicate() with simulate_branching() and rpois().
sims_sub <- # TODO

# TODO: extract the final generation X_20 for all N_SIM simulations.
#   Store as vector `X20_sub`.
X20_sub <- # TODO

# TODO: plot a histogram of X20_sub. Add a vertical line at x = 0 in red,
#   and annotate the fraction of processes that are extinct (X_20 == 0).
#   (Use base R hist() or ggplot2 — your choice.)


# ============================================================
# PART 2 — Supercritical: offspring ~ Poisson(lambda = 1.5), m = 1.5 > 1
# ============================================================

lambda_sup <- 1.5   # supercritical

# TODO: simulate N_SIM branching processes for GENERATIONS generations
#   with offspring ~ Poisson(lambda_sup).
#   Store results in matrix `sims_sup`.
sims_sup <- # TODO

# TODO: extract X_20 for all simulations. Store as `X20_sup`.
X20_sup <- # TODO

# TODO: create two separate plots for supercritical X_20:
#   Plot (a): distribution of X_20 among processes that are EXTINCT (X_20 == 0).
#             Just report the count / fraction extinct.
#   Plot (b): distribution of X_20 among processes that SURVIVE (X_20 > 0).
#             Use a histogram; note the long right tail.


# ============================================================
# PART 3 — Fixed-point iteration for the worked example
#   P_0 = 1/4, P_1 = 1/4, P_2 = 1/2
#   Expected analytical answer: q = 1/2
# ============================================================

# The p.g.f. of the offspring distribution
pgf_example <- function(z) {
  (1/4) + (1/4)*z + (1/2)*z^2
}

# TODO: implement fixed-point iteration.
#   Start from q_0 = 0. Iterate q_{k+1} = pgf_example(q_k) until
#   |q_{k+1} - q_k| < 1e-8 or 1000 iterations are reached.
#   Store each iterate in a vector `iterates` and print the final value.
#   Compare to the analytical value 0.5.
q <- 0.0
iterates <- q
# TODO: write the iteration loop here


cat("Fixed-point iteration result:", tail(iterates, 1), "\n")
cat("Analytical answer:           ", 0.5, "\n")

# TODO: plot `iterates` vs iteration number to visualise convergence.


# ============================================================
# PART 4 — Theoretical vs simulated E(X_n) = m^n
# ============================================================

gen_seq <- 0:GENERATIONS

# TODO: compute the theoretical mean E(X_n) = m^n for n = 0, ..., 20
#   for BOTH lambda values (0.8 and 1.5). Store as vectors `theory_mean_sub`
#   and `theory_mean_sup`.
theory_mean_sub <- # TODO
theory_mean_sup <- # TODO

# TODO: compute the empirical (row-wise) mean across N_SIM simulations
#   for each generation. Store as `emp_mean_sub` and `emp_mean_sup`.
#   Hint: rowMeans() on the simulation matrices.
emp_mean_sub <- # TODO
emp_mean_sup <- # TODO

# TODO: create a plot with two panels (or two overlaid lines per panel):
#   For each lambda, plot theory_mean vs emp_mean across generations 0..20.
#   Use log scale on the y-axis for the supercritical case.


# ============================================================
# PART 5 — Theoretical vs empirical Var(X_n)
# ============================================================

# For Poisson(lambda) offspring: m = lambda, sigma^2 = lambda (since Poisson mean = variance).

var_branching <- function(n, m, sigma2) {
  # TODO: implement the branching process variance formula:
  #   Var(X_n) = sigma^2 * m^(n-1) * (1 - m^n) / (1 - m)   if m != 1
  #   Var(X_n) = n * sigma^2                                  if m == 1
  # Return a numeric vector of length length(n).
  # TODO
}

# TODO: compute theoretical Var(X_n) for both lambda values across gen_seq.
theory_var_sub <- var_branching(gen_seq, lambda_sub, lambda_sub)
theory_var_sup <- var_branching(gen_seq, lambda_sup, lambda_sup)

# TODO: compute empirical variance across simulations using apply() or rowSums().
emp_var_sub <- # TODO
emp_var_sup <- # TODO

# TODO: plot theoretical vs empirical variance for both cases (two panels).
#   Note: for the supercritical case, variance grows very fast — use log scale.
