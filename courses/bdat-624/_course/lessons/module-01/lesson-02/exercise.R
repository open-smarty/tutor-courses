# Required packages
library(markovchain)
library(ggplot2)
library(dplyr)

# Scenario: A cohort of 1000 patients with a chronic condition is tracked
# weekly. Each patient is classified as: Mild (M), Moderate (Mod), or
# Severe (Sev). Transitions between states happen each week.

# ============================================================
# Task 1: Construct the Transition Probability Matrix
# ============================================================
# Use the following clinically-derived weekly transition probabilities:
#   From Mild:     70% stay Mild, 25% progress to Moderate, 5% progress to Severe
#   From Moderate: 20% improve to Mild, 50% stay Moderate, 30% progress to Severe
#   From Severe:   5% improve to Mild, 15% improve to Moderate, 80% stay Severe

# TODO: Build the 3x3 TPM as a numeric matrix.
# Rows = current state, Columns = next state. States in order: M, Mod, Sev

P <- matrix(
  c(# M      Mod    Sev
    NA,     NA,    NA,   # from M
    NA,     NA,    NA,   # from Mod
    NA,     NA,    NA    # from Sev
  ),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("M", "Mod", "Sev"), c("M", "Mod", "Sev"))
)

# TODO: Verify that every row sums to 1.
rowSums(P)

# TODO: Write a comment identifying which state (if any) has the highest
# probability of self-transition (staying in the same state).

# ============================================================
# Task 2: Compute matrix powers P^1, P^5, P^10
# ============================================================
# We want to see how the probability distribution evolves over steps.

# Helper function: raise a matrix to an integer power
mat_power <- function(M, n) {
  result <- diag(nrow(M))  # identity matrix (M^0)
  for (i in seq_len(n)) result <- result %*% M
  result
}

# TODO: Compute P^1 (trivially P itself), P^5, and P^10 using mat_power
P1  <- mat_power(P, 1)
P5  <- mat_power(P, 5)
P10 <- mat_power(P, 10)

# TODO: Print P^5 rounded to 4 decimal places
cat("P^5:\n")
print(round(P5, 4))

# TODO: Print P^10 rounded to 4 decimal places
cat("\nP^10:\n")
print(round(P10, 4))

# TODO: Comment on what you observe as n increases. Do the rows of P^n
# appear to be converging to the same distribution?

# ============================================================
# Task 3: Compute state distributions over time
# ============================================================
# Suppose at week 0: 60% of patients are Mild, 30% Moderate, 10% Severe
pi0 <- c(M = 0.60, Mod = 0.30, Sev = 0.10)

# TODO: Compute the distribution at weeks 1, 5, 10, 20 using:
#   pi_n = pi0 %*% P^n
# Store results in a list or matrix.
weeks_to_check <- c(1, 5, 10, 20)

distributions <- lapply(weeks_to_check, function(n) {
  dist_n <- pi0 %*% mat_power(P, n)
  data.frame(week = n,
             M    = dist_n[1],
             Mod  = dist_n[2],
             Sev  = dist_n[3])
})

dist_df <- bind_rows(distributions)
cat("\nState distributions over time:\n")
print(round(dist_df, 4))

# ============================================================
# Task 4: Visualise the evolution of state probabilities
# ============================================================
# TODO: Create a long-format data frame for plotting:
#   columns: week, state, probability
# Compute distributions at weeks 0, 1, 2, 3, 5, 7, 10, 15, 20

all_weeks <- c(0, 1, 2, 3, 5, 7, 10, 15, 20)

# TODO: Fill in this lapply to build a long-format data frame
plot_data <- lapply(all_weeks, function(n) {
  dist_n <- pi0 %*% mat_power(P, n)
  data.frame(
    week  = n,
    state = c("M", "Mod", "Sev"),
    prob  = as.numeric(dist_n)
  )
}) |> bind_rows()

# TODO: Plot using ggplot2: week on x-axis, probability on y-axis,
# one line per state (colour by state). Add geom_point().
ggplot(plot_data, aes(x = week, y = prob, color = state, group = state)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  labs(
    title  = "Evolution of Disease State Distribution Over Weeks",
    x      = "Week",
    y      = "Probability",
    color  = "State"
  ) +
  theme_minimal()

# ============================================================
# Task 5: Verify the stochastic matrix property at P^10
# ============================================================
# TODO: Confirm that each row of P^10 still sums to 1.
# (This should always be true for a valid TPM raised to any power.)
cat("\nRow sums of P^10 (should all equal 1):\n")
print(rowSums(P10))

# TODO: Write one sentence interpreting what the rows of P^10 represent
# biologically. (Hint: what does P^10[1, ] tell you about a patient
# currently in Mild state?)
