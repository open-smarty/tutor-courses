# SOLUTION: Module 01 Lesson 02 — Probability Distributions and Transition Probabilities
library(markovchain)
library(ggplot2)
library(dplyr)

# ============================================================
# Task 1: Transition Probability Matrix
# ============================================================
P <- matrix(
  c(0.70, 0.25, 0.05,   # from Mild
    0.20, 0.50, 0.30,   # from Moderate
    0.05, 0.15, 0.80),  # from Severe
  nrow = 3, byrow = TRUE,
  dimnames = list(c("M", "Mod", "Sev"), c("M", "Mod", "Sev"))
)

cat("Transition Probability Matrix P:\n")
print(P)

cat("\nRow sums (must all equal 1):\n")
print(rowSums(P))

# Comment: The Severe state has the highest self-transition probability
# (0.80), meaning once a patient is severely ill, they are most likely
# to remain severely ill the following week. Mild has the second highest
# (0.70). This reflects the chronic nature of the condition.

# ============================================================
# Task 2: Matrix powers
# ============================================================
mat_power <- function(M, n) {
  result <- diag(nrow(M))
  for (i in seq_len(n)) result <- result %*% M
  result
}

P1  <- mat_power(P, 1)
P5  <- mat_power(P, 5)
P10 <- mat_power(P, 10)

cat("\nP^5:\n")
print(round(P5, 4))
cat("\nP^10:\n")
print(round(P10, 4))

# Observation: As n increases, the rows of P^n converge toward the same
# vector — the stationary distribution π. By P^10, the rows are nearly
# identical, regardless of starting state. This confirms ergodicity.

# ============================================================
# Task 3: State distributions over time
# ============================================================
pi0 <- c(M = 0.60, Mod = 0.30, Sev = 0.10)

weeks_to_check <- c(1, 5, 10, 20)
distributions <- lapply(weeks_to_check, function(n) {
  dist_n <- pi0 %*% mat_power(P, n)
  data.frame(week = n, M = dist_n[1], Mod = dist_n[2], Sev = dist_n[3])
})
dist_df <- bind_rows(distributions)

cat("\nState distributions (rounded):\n")
print(round(dist_df, 4))

# By week 20, the distribution is approaching the stationary distribution.
# Note the Severe fraction grows significantly from the initial 10% —
# this reflects the asymptotic pull toward the equilibrium.

# ============================================================
# Task 4: Plot
# ============================================================
all_weeks <- c(0, 1, 2, 3, 5, 7, 10, 15, 20)
plot_data <- lapply(all_weeks, function(n) {
  dist_n <- pi0 %*% mat_power(P, n)
  data.frame(
    week  = n,
    state = c("M", "Mod", "Sev"),
    prob  = as.numeric(dist_n)
  )
}) |> bind_rows()

p <- ggplot(plot_data, aes(x = week, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_color_manual(
    values = c("M" = "#2ecc71", "Mod" = "#f39c12", "Sev" = "#e74c3c"),
    labels = c("M" = "Mild", "Mod" = "Moderate", "Sev" = "Severe")
  ) +
  labs(
    title    = "Evolution of Disease State Distribution Over Weeks",
    subtitle = "Initial distribution: 60% Mild, 30% Moderate, 10% Severe",
    x        = "Week",
    y        = "Probability",
    color    = "State"
  ) +
  theme_minimal(base_size = 13)
print(p)

# ============================================================
# Task 5: Verify stochastic property
# ============================================================
cat("\nRow sums of P^10:\n")
print(rowSums(P10))

# Biological interpretation of P^10[1, ]:
# Row 1 of P^10 gives the probability distribution over states for a
# patient who is currently Mild (state M), after 10 weeks. For example,
# P^10[1, "Sev"] is the probability that a currently-Mild patient will
# be in the Severe state 10 weeks from now. This is a 10-step forecast.
cat("\nFor a Mild patient: probability distribution 10 weeks from now:\n")
print(round(P10["M", ], 4))
