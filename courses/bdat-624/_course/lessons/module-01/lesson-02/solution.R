# BDAT 624 — Module 1, Lesson 2
# Solution: Transition Probability Matrices and Patient Health Simulation

library(ggplot2)
library(dplyr)
library(tidyr)
library(markovchain)

set.seed(2024)

# ============================================================
# PART 1: Build the transition probability matrix
# ============================================================

states <- c("Healthy", "Sick", "Dead")

# Missing entries:
#   Row 1 (Healthy): 0.85 + 0.12 + ??? = 1  =>  ??? = 0.03
#   Row 2 (Sick):    0.40 + ??? + 0.10 = 1  =>  ??? = 0.50

P <- matrix(
  c(
    0.85, 0.12, 0.03,
    0.40, 0.50, 0.10,
    0.00, 0.00, 1.00
  ),
  nrow = 3, byrow = TRUE,
  dimnames = list(states, states)
)

# Verify: row sums should all be 1
cat("Row sums of P:\n")
print(rowSums(P))

# ============================================================
# PART 2: Create a markovchain object
# ============================================================

health_mc <- new(
  "markovchain",
  states           = states,
  transitionMatrix = P,
  name             = "Patient Health Model"
)

print(health_mc)

# ============================================================
# PART 3: Multi-step transition probabilities
# ============================================================

# Compute P^6 by repeated matrix multiplication
P6 <- P %*% P %*% P %*% P %*% P %*% P
# Equivalently: health_mc^6 returns the same result as a markovchain object

dimnames(P6) <- list(states, states)

cat("\n6-step transition matrix P^6:\n")
print(round(P6, 4))

cat("\nP(Dead at month 6 | Healthy at month 0) =",
    round(P6["Healthy", "Dead"], 4), "\n")

# ============================================================
# PART 4: Simulate 200 patients over 12 months
# ============================================================

n_patients <- 200
n_months   <- 12

sim <- matrix(NA, nrow = n_patients, ncol = n_months)

for (p in 1:n_patients) {
  sim[p, ] <- markovchainSequence(
    n           = n_months,
    markovchain = health_mc,
    t0          = "Healthy"
  )
}

# ============================================================
# PART 5: Compute proportion in each state over time
# ============================================================

prop_list <- vector("list", n_months)

for (t in 1:n_months) {
  tbl <- table(factor(sim[, t], levels = states))
  prop_list[[t]] <- data.frame(
    month      = t,
    state      = names(tbl),
    proportion = as.numeric(tbl) / n_patients
  )
}

prop_df <- bind_rows(prop_list)
prop_df$state <- factor(prop_df$state, levels = states)

# ============================================================
# PART 6: Stacked bar chart
# ============================================================

state_colours <- c(
  "Healthy" = "#4dac26",
  "Sick"    = "#f4a582",
  "Dead"    = "#ca0020"
)

p_stack <- ggplot(prop_df, aes(x = month, y = proportion, fill = state)) +
  geom_col(position = "stack", width = 0.8) +
  scale_fill_manual(values = state_colours, name = "State") +
  scale_x_continuous(breaks = 1:n_months) +
  labs(
    title    = "Patient State Proportions Over 12 Months (n = 200)",
    subtitle = "Starting state: all Healthy at month 0",
    x        = "Month",
    y        = "Proportion of Patients"
  ) +
  theme_minimal(base_size = 12)

print(p_stack)

# ============================================================
# PART 7: Time-to-death distribution
# ============================================================

time_to_death <- rep(NA, n_patients)

for (p in 1:n_patients) {
  first_dead <- which(sim[p, ] == "Dead")[1]
  if (!is.na(first_dead)) {
    time_to_death[p] <- first_dead
  }
}

ttd_df    <- data.frame(month = time_to_death[!is.na(time_to_death)])
ttd_median <- median(ttd_df$month, na.rm = TRUE)

n_died    <- sum(!is.na(time_to_death))
pct_died  <- round(100 * n_died / n_patients, 1)

p_hist <- ggplot(ttd_df, aes(x = month)) +
  geom_histogram(binwidth = 1, fill = "#ca0020", colour = "white", alpha = 0.8) +
  geom_vline(xintercept = ttd_median, linetype = "dashed",
             colour = "black", linewidth = 0.8) +
  annotate("text", x = ttd_median + 0.4, y = Inf,
           label = paste0("Median = ", ttd_median),
           vjust = 1.5, hjust = 0, size = 3.5) +
  scale_x_continuous(breaks = 1:n_months) +
  labs(
    title    = "Time-to-Death Distribution (patients who died within 12 months)",
    subtitle = paste0(n_died, " of ", n_patients, " patients (", pct_died, "%) died"),
    x        = "Month of Death",
    y        = "Number of Patients"
  ) +
  theme_minimal(base_size = 12)

print(p_hist)
