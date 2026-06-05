# Required packages
library(ggplot2)
library(dplyr)

# Scenario: A viral infection model using a Galton-Watson branching process.
# Each virion independently produces offspring according to a given offspring
# distribution. We investigate extinction probability vs. generation number.

# ============================================================
# Task 1: Set up the offspring distribution
# ============================================================
# We will use THREE different offspring distributions and compare.
# All have the same mean mu = 1.5 but different variances.

# Distribution A: Poisson(lambda=1.5)
# Distribution B: Geometric with P(X=k) = (1-p)*p^k, k=0,1,2,...
#   Mean: p/(1-p) = 1.5 → p = 0.6; P(0)=0.4, P(1)=0.24, etc.
# Distribution C: Deterministic: X = 1 always if failed, X = 2 always if ...
#   Actually use Negative Binomial(r=1.5, p=0.5) — heavier tail, same mean

# For each distribution, write its PGF G(s):
# A: G_A(s) = exp(lambda*(s-1)) = exp(1.5*(s-1))
# B: G_B(s) = (1-p)/(1-p*s) = 0.4/(1-0.6*s)  [geometric PGF]
# C: Use the simulation-based approach (draw from rnbinom)

# ============================================================
# Task 2: Find the extinction probability by iterating G(q) = q
# ============================================================
# Use the fixed-point iteration: q_{n+1} = G(q_n), q_0 = 0

# TODO: For distribution A (Poisson), iterate 100 times starting from q=0
G_A <- function(s) exp(1.5 * (s - 1))
G_B <- function(s) 0.4 / (1 - 0.6 * s)

iterate_extinction <- function(G, n_iter = 100) {
  q <- 0
  for (i in seq_len(n_iter)) q <- G(q)
  q
}

q_A <- iterate_extinction(G_A)
q_B <- iterate_extinction(G_B)

cat("Theoretical extinction probability:\n")
cat("  Poisson(1.5):", round(q_A, 5), "\n")
cat("  Geometric(p=0.6):", round(q_B, 5), "\n")

# TODO: Write a comment comparing q_A and q_B.
# Both have mean 1.5. Which has higher extinction probability?
# What does the difference tell you about the role of offspring variance?

# ============================================================
# Task 3: Simulate Galton-Watson branching processes
# ============================================================
# Function: simulate one trajectory of a branching process for n_gen generations
# Returns a vector of population sizes X_0, X_1, ..., X_{n_gen}
simulate_branching <- function(offspring_fn, n_gen = 50, X0 = 1) {
  X <- numeric(n_gen + 1)
  X[1] <- X0
  for (g in seq_len(n_gen)) {
    if (X[g] == 0) {
      X[(g+1):(n_gen+1)] <- 0
      break
    }
    # Each of the X[g] individuals produces offspring independently
    X[g+1] <- sum(offspring_fn(X[g]))
  }
  X
}

# Offspring functions (return n offspring counts drawn from the distribution)
offspring_pois <- function(n) rpois(n, lambda = 1.5)
offspring_geom <- function(n) rgeom(n, prob = 0.4)  # P(X=k) = 0.4 * 0.6^k, mean=0.6/0.4=1.5

# TODO: Simulate 1000 trajectories for each offspring distribution
set.seed(314)
n_sim  <- 1000
n_gen  <- 50

# TODO: Store all trajectories in a matrix: n_sim rows, (n_gen+1) columns
traj_pois <- matrix(NA, nrow = n_sim, ncol = n_gen + 1)
traj_geom <- matrix(NA, nrow = n_sim, ncol = n_gen + 1)

for (sim in seq_len(n_sim)) {
  traj_pois[sim, ] <- simulate_branching(offspring_pois, n_gen = n_gen)
  traj_geom[sim, ] <- simulate_branching(offspring_geom, n_gen = n_gen)
}

# ============================================================
# Task 4: Compute empirical extinction probability over generations
# ============================================================
# Extinction by generation g = proportion of simulations where X_g = 0

# TODO: Compute the fraction of simulations extinct at each generation
ext_prob_pois <- colMeans(traj_pois == 0)  # fraction extinct at each gen
ext_prob_geom <- colMeans(traj_geom == 0)

generations <- 0:n_gen

# TODO: Build a long-format data frame for plotting
ext_df <- data.frame(
  generation  = rep(generations, 2),
  ext_prob    = c(ext_prob_pois, ext_prob_geom),
  distribution = rep(c("Poisson(1.5)", "Geometric(p=0.6)"), each = n_gen + 1)
)

# TODO: Plot extinction probability vs generation for both distributions.
# Add horizontal dashed reference lines at the theoretical q values.
ggplot(ext_df, aes(x = generation, y = ext_prob, color = distribution)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = q_A, linetype = "dashed", color = "#3498db") +
  geom_hline(yintercept = q_B, linetype = "dashed", color = "#e74c3c") +
  labs(
    title    = "Empirical Extinction Probability vs Generation",
    subtitle = paste("n_sim =", n_sim, "trajectories; dashed = theoretical q*"),
    x = "Generation", y = "P(Extinct by generation g)",
    color = "Offspring distribution"
  ) +
  theme_minimal()

# ============================================================
# Task 5: Plot mean population size vs generation
# ============================================================
# The theory predicts E[X_n] = mu^n = 1.5^n (same for both since mu=1.5).

# TODO: Compute mean population size at each generation
# (including extinct trajectories with X=0)
mean_pois <- colMeans(traj_pois)
mean_geom <- colMeans(traj_geom)
theoretical_mean <- 1.5^generations

mean_df <- data.frame(
  generation   = rep(generations, 3),
  mean_pop     = c(mean_pois, mean_geom, theoretical_mean),
  source       = rep(c("Poisson(Sim)", "Geometric(Sim)", "Theoretical 1.5^n"), each=n_gen+1)
)

# TODO: Plot on a log scale (log10 y-axis). The theoretical line should be
# straight (exponential growth = linear on log scale).
ggplot(mean_df, aes(x = generation, y = mean_pop, color = source, linetype = source)) +
  geom_line(linewidth = 1.1) +
  scale_y_log10() +
  labs(
    title    = "Mean Population Size E[X_n] vs Generation (log scale)",
    subtitle = "Theoretical: 1.5^n; note simulated means may fluctuate due to n_sim=1000",
    x = "Generation", y = "E[X_n] (log scale)",
    color = "Source", linetype = "Source"
  ) +
  theme_minimal()

cat("\nFinal extinction probabilities at generation 50:\n")
cat("  Poisson:    empirical =", round(ext_prob_pois[51], 4),
    " theoretical =", round(q_A, 4), "\n")
cat("  Geometric:  empirical =", round(ext_prob_geom[51], 4),
    " theoretical =", round(q_B, 4), "\n")
