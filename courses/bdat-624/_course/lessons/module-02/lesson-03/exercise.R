# Required packages
library(markovchain)
library(ggplot2)
library(dplyr)

# Scenario: We analyse two Markov chains — one with an absorbing state
# (the clinical chain from Lesson 1) and one fully ergodic — classifying
# states, identifying communicating classes, and checking ergodicity.

# ============================================================
# Task 1: Build a 5-state chain and determine communicating classes
# ============================================================
# States: S1, S2, S3, S4, S5
# Transition matrix (row sums = 1):
#   S1 → S2: 0.6, S1 → S3: 0.4
#   S2 → S1: 0.3, S2 → S4: 0.7
#   S3 → S1: 0.5, S3 → S5: 0.5
#   S4 → S4: 1.0  (absorbing)
#   S5 → S5: 1.0  (absorbing)

# TODO: Build the 5×5 TPM and verify row sums
states_5 <- c("S1","S2","S3","S4","S5")
P5 <- matrix(
  c(0.0, 0.6, 0.4, 0.0, 0.0,   # from S1
    0.3, 0.0, 0.0, 0.7, 0.0,   # from S2
    0.5, 0.0, 0.0, 0.0, 0.5,   # from S3
    0.0, 0.0, 0.0, 1.0, 0.0,   # from S4 (absorbing)
    0.0, 0.0, 0.0, 0.0, 1.0),  # from S5 (absorbing)
  nrow = 5, byrow = TRUE,
  dimnames = list(states_5, states_5)
)

cat("Row sums of P5:\n"); print(rowSums(P5))

# TODO: Create a markovchain object
mc5 <- new("markovchain",
  states = states_5, byrow = TRUE,
  transitionMatrix = P5, name = "5-State Chain"
)

# TODO: Check irreducibility — is the chain irreducible?
cat("\nIs irreducible:", is.irreducible(mc5), "\n")
# Write a comment explaining why (or why not).

# TODO: Get the communicating classes using communicatingClasses(mc5)
cat("\nCommunicating classes:\n")
print(communicatingClasses(mc5))

# TODO: Identify which classes are recurrent (closed) and which are transient
# Hint: use recurrentClasses(mc5) and transientClasses(mc5)
cat("\nRecurrent classes:\n"); print(recurrentClasses(mc5))
cat("\nTransient classes:\n");  print(transientClasses(mc5))

# ============================================================
# Task 2: Analyse a fully ergodic 3-state chain
# ============================================================
# States: A, B, C (all communicate, no absorbing state, aperiodic)
# Transition matrix:
#   A → A=0.5, A → B=0.3, A → C=0.2
#   B → A=0.4, B → B=0.2, B → C=0.4
#   C → A=0.1, C → B=0.6, C → C=0.3

P_erg <- matrix(
  c(0.5, 0.3, 0.2,
    0.4, 0.2, 0.4,
    0.1, 0.6, 0.3),
  nrow = 3, byrow = TRUE,
  dimnames = list(c("A","B","C"), c("A","B","C"))
)

mc_erg <- new("markovchain",
  states = c("A","B","C"), byrow = TRUE,
  transitionMatrix = P_erg, name = "Ergodic Chain"
)

# TODO: Check irreducibility
cat("\nErgodic chain — is irreducible:", is.irreducible(mc_erg), "\n")

# TODO: Check period of each state.
# Hint: period(mc_erg) from markovchain package
cat("Period:", period(mc_erg), "\n")
# Write a comment: is the chain aperiodic? How does a non-zero self-loop
# (like P_AA = 0.5) guarantee aperiodicity?

# TODO: Compute the stationary distribution
cat("\nStationary distribution of ergodic chain:\n")
print(steadyStates(mc_erg))

# ============================================================
# Task 3: Demonstrate the ergodic theorem empirically
# ============================================================
# Simulate a long trajectory (N=10000 steps) from the ergodic chain.
# Compare the empirical time-average to the stationary distribution.

set.seed(777)
N <- 10000

# TODO: Simulate N steps starting from "A"
long_traj <- markovchainSequence(n = N, markovchain = mc_erg, t0 = "A")

# TODO: Compute time-averages (fraction of time in each state)
time_avg <- table(long_traj) / N
cat("\nEmpirical time-averages (N=10000):\n")
print(round(time_avg, 4))

cat("Theoretical stationary distribution:\n")
pi_erg <- steadyStates(mc_erg)
print(round(pi_erg, 4))

# TODO: Compute the absolute difference between empirical and theoretical
cat("\nAbsolute differences:\n")
print(round(abs(time_avg - pi_erg), 5))

# TODO: Write a comment interpreting the result in terms of the ergodic theorem.

# ============================================================
# Task 4: Visualise convergence for different starting states
# ============================================================
mat_power <- function(M, n) {
  r <- diag(nrow(M)); for(i in seq_len(n)) r <- r %*% M; r
}

# For each starting state (A, B, C), compute distribution at steps 1..30
starting_states <- list(A=c(1,0,0), B=c(0,1,0), C=c(0,0,1))
ns <- 1:30

evo_all <- lapply(names(starting_states), function(s0) {
  pi0 <- starting_states[[s0]]
  lapply(ns, function(n) {
    dist_n <- pi0 %*% mat_power(P_erg, n)
    data.frame(n=n, start=s0, state=c("A","B","C"), prob=as.numeric(dist_n))
  }) |> bind_rows()
}) |> bind_rows()

evo_all$state <- factor(evo_all$state, levels=c("A","B","C"))

# TODO: Get stationary distribution for reference lines
pi_vals <- as.numeric(steadyStates(mc_erg))
pi_ref  <- data.frame(state=factor(c("A","B","C")), pi_val=pi_vals)
evo_all <- left_join(evo_all, pi_ref, by="state")

# TODO: Plot — facet by starting state, all three state probabilities on y-axis
# Include dashed horizontal lines at stationary probabilities
ggplot(evo_all, aes(x=n, y=prob, color=state, group=state)) +
  geom_line(linewidth=1.0) +
  geom_hline(aes(yintercept=pi_val, color=state), linetype="dashed") +
  facet_wrap(~ start, labeller=label_both) +
  labs(
    title    = "Ergodic Theorem: Convergence to π from Three Starting States",
    subtitle = "Dashed = stationary distribution π",
    x="Step n", y="Probability", color="State"
  ) +
  theme_minimal()
