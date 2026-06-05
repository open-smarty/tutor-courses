# SOLUTION: Module 02 Lesson 03 — State Classification, Recurrence, Ergodicity
library(markovchain)
library(ggplot2)
library(dplyr)

# ============================================================
# Task 1: 5-state chain with two absorbing states
# ============================================================
states_5 <- c("S1","S2","S3","S4","S5")
P5 <- matrix(
  c(0.0, 0.6, 0.4, 0.0, 0.0,
    0.3, 0.0, 0.0, 0.7, 0.0,
    0.5, 0.0, 0.0, 0.0, 0.5,
    0.0, 0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 0.0, 1.0),
  nrow = 5, byrow = TRUE,
  dimnames = list(states_5, states_5)
)

cat("Row sums:\n"); print(rowSums(P5))

mc5 <- new("markovchain",
  states = states_5, byrow = TRUE,
  transitionMatrix = P5, name = "5-State Chain"
)

cat("\nIs irreducible:", is.irreducible(mc5), "\n")
# Not irreducible: S4 and S5 are absorbing states that cannot reach S1, S2, S3.
# Multiple communicating classes exist.

cat("\nCommunicating classes:\n")
print(communicatingClasses(mc5))
# Expected: {S1, S2, S3} (all communicate via 2-step paths) + {S4} + {S5}
# Note: S1↔S2 (S1→S2 direct; S2→S1 direct); S1↔S3 similarly; S2↔S3 via S1.

cat("\nRecurrent classes:\n"); print(recurrentClasses(mc5))
# {S4} and {S5} are recurrent (absorbing = trivially recurrent)

cat("\nTransient classes:\n"); print(transientClasses(mc5))
# {S1, S2, S3}: transient because from S2 and S3 you can reach S4 or S5,
# but S4 and S5 cannot return to S1/S2/S3. Once absorbed, no return.

# ============================================================
# Task 2: Ergodic chain
# ============================================================
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

cat("\nErgodic chain — is irreducible:", is.irreducible(mc_erg), "\n")
# TRUE: all states communicate (non-zero entries allow any pair to reach each other)

cat("Period:", period(mc_erg), "\n")
# Period 1 (aperiodic). Reason: state A has a self-loop (P_AA = 0.5 > 0),
# which means A can return to itself in 1 step. gcd{1, 2, 3,...} = 1.
# A self-loop guarantees aperiodicity for any state that has one.

cat("\nStationary distribution:\n")
pi_erg <- steadyStates(mc_erg)
print(round(pi_erg, 4))

# ============================================================
# Task 3: Ergodic theorem empirically
# ============================================================
set.seed(777)
N <- 10000
long_traj <- markovchainSequence(n = N, markovchain = mc_erg, t0 = "A")

time_avg <- table(long_traj) / N
cat("\nEmpirical time-averages (N=10000):\n")
print(round(time_avg, 4))

cat("Theoretical stationary distribution:\n")
print(round(pi_erg, 4))

cat("\nAbsolute differences:\n")
print(round(abs(time_avg - pi_erg), 5))
# Should be very small (~0.002 or less for N=10000)
# This is the ergodic theorem: the empirical time-average converges to
# the stationary distribution as N → ∞, regardless of starting state.

# ============================================================
# Task 4: Convergence plot
# ============================================================
mat_power <- function(M, n) {
  r <- diag(nrow(M)); for(i in seq_len(n)) r <- r %*% M; r
}

starting_states <- list(A = c(1,0,0), B = c(0,1,0), C = c(0,0,1))
ns <- 1:30

evo_all <- lapply(names(starting_states), function(s0) {
  pi0 <- starting_states[[s0]]
  lapply(ns, function(n) {
    dist_n <- pi0 %*% mat_power(P_erg, n)
    data.frame(n=n, start=s0, state=c("A","B","C"), prob=as.numeric(dist_n))
  }) |> bind_rows()
}) |> bind_rows()

evo_all$state <- factor(evo_all$state, levels=c("A","B","C"))

pi_vals <- as.numeric(pi_erg)
pi_ref  <- data.frame(state=factor(c("A","B","C")), pi_val=pi_vals)
evo_all <- left_join(evo_all, pi_ref, by="state")

p <- ggplot(evo_all, aes(x=n, y=prob, color=state, group=state)) +
  geom_line(linewidth=1.0) +
  geom_hline(aes(yintercept=pi_val, color=state), linetype="dashed", linewidth=0.8) +
  facet_wrap(~ start, labeller=label_both) +
  scale_color_manual(values=c("A"="#2ecc71","B"="#e74c3c","C"="#3498db")) +
  labs(
    title    = "Ergodic Theorem: Convergence to π from Three Starting States",
    subtitle = "Dashed lines = stationary π; all three starting states converge to same π",
    x="Step n", y="Probability", color="State"
  ) +
  theme_minimal(base_size=12)
print(p)
# Key insight: regardless of starting state (A, B, or C), by ~step 15
# all state distributions have converged to the same stationary vector π.
# This is the hallmark of ergodicity.
