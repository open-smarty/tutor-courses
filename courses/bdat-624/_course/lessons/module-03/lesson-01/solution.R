# BDAT 624 — Module 3, Lesson 1: Branching Processes
# SOLUTION FILE — do not share with students before they attempt exercise.R

library(ggplot2)
library(gridExtra)

set.seed(42)

# ============================================================
# HELPER: simulate one branching process
# ============================================================

simulate_branching <- function(offspring_fn, generations = 20) {
  X <- numeric(generations + 1)
  X[1] <- 1L
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
# PART 1 — Subcritical: Poisson(0.8)
# ============================================================

N_SIM       <- 1000
GENERATIONS <- 20
lambda_sub  <- 0.8

sims_sub <- replicate(
  N_SIM,
  simulate_branching(function(n) rpois(n, lambda = lambda_sub), GENERATIONS)
)
# sims_sub is (GENERATIONS+1) x N_SIM

X20_sub <- sims_sub[GENERATIONS + 1, ]

frac_extinct_sub <- mean(X20_sub == 0)
cat(sprintf("Subcritical (lambda=0.8): fraction extinct at gen 20 = %.3f\n",
            frac_extinct_sub))

p1 <- ggplot(data.frame(X20 = X20_sub), aes(x = X20)) +
  geom_histogram(binwidth = 1, fill = "steelblue", colour = "white") +
  geom_vline(xintercept = 0, colour = "red", linewidth = 1) +
  labs(title = sprintf("Subcritical (lambda=%.1f): X_20 distribution", lambda_sub),
       subtitle = sprintf("Fraction extinct: %.1f%%", 100 * frac_extinct_sub),
       x = "X_20 (population at generation 20)", y = "Count") +
  theme_minimal()

# ============================================================
# PART 2 — Supercritical: Poisson(1.5)
# ============================================================

lambda_sup <- 1.5

sims_sup <- replicate(
  N_SIM,
  simulate_branching(function(n) rpois(n, lambda = lambda_sup), GENERATIONS)
)

X20_sup <- sims_sup[GENERATIONS + 1, ]

frac_extinct_sup <- mean(X20_sup == 0)
cat(sprintf("Supercritical (lambda=1.5): fraction extinct at gen 20 = %.3f\n",
            frac_extinct_sup))

# (a) fraction extinct
cat(sprintf("  -> %.1f%% of %d processes are extinct by generation 20\n",
            100 * frac_extinct_sup, N_SIM))

# (b) distribution among survivors
survivors_sup <- X20_sup[X20_sup > 0]
p2a <- ggplot(data.frame(X20 = survivors_sup), aes(x = X20)) +
  geom_histogram(bins = 40, fill = "darkorange", colour = "white") +
  scale_x_log10() +
  labs(title = sprintf("Supercritical (lambda=%.1f): X_20 | survived", lambda_sup),
       subtitle = sprintf("n = %d survivors (%.1f%% extinct)", length(survivors_sup),
                          100 * frac_extinct_sup),
       x = "X_20 (log scale)", y = "Count") +
  theme_minimal()

grid.arrange(p1, p2a, ncol = 2)

# ============================================================
# PART 3 — Fixed-point iteration for worked example
#   P_0 = 1/4, P_1 = 1/4, P_2 = 1/2  → analytical q = 1/2
# ============================================================

pgf_example <- function(z) (1/4) + (1/4)*z + (1/2)*z^2

q        <- 0.0
iterates <- q
tol      <- 1e-8
max_iter <- 1000

for (k in seq_len(max_iter)) {
  q_new <- pgf_example(q)
  iterates <- c(iterates, q_new)
  if (abs(q_new - q) < tol) break
  q <- q_new
}

cat("Fixed-point iteration result:", tail(iterates, 1), "\n")
cat("Analytical answer:           ", 0.5, "\n")
cat("Difference:                  ", abs(tail(iterates, 1) - 0.5), "\n")

p3 <- ggplot(data.frame(iter = seq_along(iterates) - 1, q = iterates), aes(x = iter, y = q)) +
  geom_line(colour = "purple", linewidth = 1) +
  geom_point(size = 1.5, colour = "purple") +
  geom_hline(yintercept = 0.5, linetype = "dashed", colour = "red") +
  labs(title = "Fixed-point iteration: q_{k+1} = f(q_k)",
       subtitle = "Red dashed = analytical answer q = 0.5",
       x = "Iteration k", y = expression(q[k])) +
  theme_minimal()
print(p3)

# ============================================================
# PART 4 — Theoretical vs simulated E(X_n)
# ============================================================

gen_seq <- 0:GENERATIONS

theory_mean_sub <- lambda_sub^gen_seq   # E(X_n) = m^n, m = 0.8
theory_mean_sup <- lambda_sup^gen_seq   # E(X_n) = m^n, m = 1.5

emp_mean_sub <- rowMeans(sims_sub)
emp_mean_sup <- rowMeans(sims_sup)

df_mean <- data.frame(
  gen       = rep(gen_seq, 4),
  mean      = c(theory_mean_sub, emp_mean_sub, theory_mean_sup, emp_mean_sup),
  type      = rep(c("Theoretical", "Empirical"), each = GENERATIONS + 1, times = 2),
  regime    = rep(c("Subcritical (lambda=0.8)", "Supercritical (lambda=1.5)"),
                  each = 2 * (GENERATIONS + 1))
)

p4 <- ggplot(df_mean, aes(x = gen, y = mean, colour = type, linetype = type)) +
  geom_line(linewidth = 1) +
  facet_wrap(~regime, scales = "free_y") +
  scale_colour_manual(values = c("Theoretical" = "black", "Empirical" = "steelblue")) +
  labs(title = "E(X_n) = m^n: theoretical vs simulated",
       x = "Generation n", y = "Mean population size",
       colour = NULL, linetype = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom")
print(p4)

# ============================================================
# PART 5 — Theoretical vs empirical Var(X_n)
# ============================================================

var_branching <- function(n, m, sigma2) {
  # For each element of n, compute the branching process variance formula.
  result <- numeric(length(n))
  for (i in seq_along(n)) {
    ni <- n[i]
    if (abs(m - 1) < 1e-10) {
      result[i] <- ni * sigma2
    } else {
      result[i] <- sigma2 * m^(ni - 1) * (1 - m^ni) / (1 - m)
    }
  }
  result
}

# For Poisson(lambda): mean = lambda, sigma^2 = lambda
theory_var_sub <- var_branching(gen_seq, lambda_sub, lambda_sub)
theory_var_sup <- var_branching(gen_seq, lambda_sup, lambda_sup)

# Empirical variance: row-wise over simulations
emp_var_sub <- apply(sims_sub, 1, var)
emp_var_sup <- apply(sims_sup, 1, var)

df_var <- data.frame(
  gen    = rep(gen_seq, 4),
  var    = c(theory_var_sub, emp_var_sub, theory_var_sup, emp_var_sup),
  type   = rep(c("Theoretical", "Empirical"), each = GENERATIONS + 1, times = 2),
  regime = rep(c("Subcritical (lambda=0.8)", "Supercritical (lambda=1.5)"),
               each = 2 * (GENERATIONS + 1))
)

# Use log scale for supercritical; both panels on same plot with free_y
p5 <- ggplot(df_var, aes(x = gen, y = var + 1e-6, colour = type, linetype = type)) +
  geom_line(linewidth = 1) +
  facet_wrap(~regime, scales = "free_y") +
  scale_y_log10() +
  scale_colour_manual(values = c("Theoretical" = "black", "Empirical" = "tomato")) +
  labs(title = "Var(X_n): theoretical vs simulated (log scale + 1e-6 offset)",
       x = "Generation n", y = "Variance (log scale)",
       colour = NULL, linetype = NULL) +
  theme_minimal() +
  theme(legend.position = "bottom")
print(p5)

cat("\nAll parts complete.\n")
