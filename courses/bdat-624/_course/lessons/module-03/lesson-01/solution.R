# SOLUTION: Module 03 Lesson 01 — Branching Processes: Extinction and Growth
library(ggplot2)
library(dplyr)

# ============================================================
# Task 2: Theoretical extinction probabilities
# ============================================================
G_A <- function(s) exp(1.5 * (s - 1))    # Poisson(1.5) PGF
G_B <- function(s) 0.4 / (1 - 0.6 * s)  # Geometric(p=0.4) PGF, mean=1.5

iterate_extinction <- function(G, n_iter = 200) {
  q <- 0
  for (i in seq_len(n_iter)) q <- G(q)
  q
}

q_A <- iterate_extinction(G_A)
q_B <- iterate_extinction(G_B)

cat("Theoretical extinction probabilities (mu=1.5 for both):\n")
cat("  Poisson(1.5):    q* =", round(q_A, 5), "\n")
cat("  Geometric(p=0.4): q* =", round(q_B, 5), "\n")

# Comment: Both distributions have mean mu=1.5, but the geometric distribution
# has much higher variance (Var = p/(1-p)^2 = 0.6/0.16 = 3.75 >> Var=1.5 for Poisson).
# Despite identical means, the geometric has HIGHER extinction probability than Poisson.
# Higher variance means more "all-or-nothing" outcomes — many zeroes (extinction)
# but also occasional explosive growth. For extinction, what matters is the shape
# of the offspring distribution near 0, not just the mean. This explains why
# targeting superspreader events (reducing the high-offspring tail) and reducing
# the probability of zero offspring both matter for epidemic control.

# ============================================================
# Task 3: Simulate branching processes
# ============================================================
simulate_branching <- function(offspring_fn, n_gen = 50, X0 = 1) {
  X <- numeric(n_gen + 1)
  X[1] <- X0
  for (g in seq_len(n_gen)) {
    if (X[g] == 0) {
      X[(g+1):(n_gen+1)] <- 0
      break
    }
    X[g+1] <- sum(offspring_fn(X[g]))
  }
  X
}

offspring_pois <- function(n) rpois(n, lambda = 1.5)
offspring_geom <- function(n) rgeom(n, prob = 0.4)

set.seed(314)
n_sim <- 1000
n_gen <- 50

traj_pois <- matrix(NA, nrow = n_sim, ncol = n_gen + 1)
traj_geom <- matrix(NA, nrow = n_sim, ncol = n_gen + 1)

for (sim in seq_len(n_sim)) {
  traj_pois[sim, ] <- simulate_branching(offspring_pois, n_gen)
  traj_geom[sim, ] <- simulate_branching(offspring_geom, n_gen)
}

# ============================================================
# Task 4: Extinction probability plot
# ============================================================
ext_prob_pois <- colMeans(traj_pois == 0)
ext_prob_geom <- colMeans(traj_geom == 0)
generations <- 0:n_gen

ext_df <- data.frame(
  generation   = rep(generations, 2),
  ext_prob     = c(ext_prob_pois, ext_prob_geom),
  distribution = rep(c("Poisson(1.5)", "Geometric(p=0.4)"), each = n_gen + 1)
)

p1 <- ggplot(ext_df, aes(x = generation, y = ext_prob, color = distribution)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = q_A, linetype = "dashed", color = "#3498db", linewidth = 0.8) +
  geom_hline(yintercept = q_B, linetype = "dashed", color = "#e74c3c", linewidth = 0.8) +
  annotate("text", x = 40, y = q_A + 0.03, label = paste("q*_A =", round(q_A,3)),
           color = "#3498db", size = 3.5) +
  annotate("text", x = 40, y = q_B - 0.03, label = paste("q*_B =", round(q_B,3)),
           color = "#e74c3c", size = 3.5) +
  scale_color_manual(values = c("Poisson(1.5)" = "#3498db", "Geometric(p=0.4)" = "#e74c3c")) +
  labs(
    title    = "Empirical Extinction Probability vs Generation",
    subtitle = paste("n_sim =", n_sim, "trajectories per distribution; dashed = theoretical q*"),
    x = "Generation", y = "P(Extinct by generation g)", color = "Offspring distribution"
  ) +
  theme_minimal(base_size = 12)
print(p1)

# ============================================================
# Task 5: Mean population size
# ============================================================
mean_pois        <- colMeans(traj_pois)
mean_geom        <- colMeans(traj_geom)
theoretical_mean <- 1.5^generations

mean_df <- data.frame(
  generation = rep(generations, 3),
  mean_pop   = c(mean_pois, mean_geom, theoretical_mean),
  source     = rep(c("Poisson(Sim)", "Geometric(Sim)", "Theoretical 1.5^n"), each = n_gen+1)
)

p2 <- ggplot(mean_df, aes(x = generation, y = mean_pop, color = source, linetype = source)) +
  geom_line(linewidth = 1.1) +
  scale_y_log10(labels = scales::comma) +
  scale_color_manual(values = c(
    "Poisson(Sim)"     = "#3498db",
    "Geometric(Sim)"   = "#e74c3c",
    "Theoretical 1.5^n" = "#2c3e50"
  )) +
  labs(
    title    = "Mean Population Size E[X_n] vs Generation (log scale)",
    subtitle = "All should track 1.5^n; geometric shows more variance (wider fluctuations)",
    x = "Generation", y = "E[X_n] (log₁₀ scale)", color = "Source", linetype = "Source"
  ) +
  theme_minimal(base_size = 12)
print(p2)

cat("\nFinal results at generation 50:\n")
cat(sprintf("  Poisson:   empirical q = %.4f, theoretical q* = %.4f\n",
            ext_prob_pois[51], q_A))
cat(sprintf("  Geometric: empirical q = %.4f, theoretical q* = %.4f\n",
            ext_prob_geom[51], q_B))
