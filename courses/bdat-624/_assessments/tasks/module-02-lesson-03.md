# Task: State Classification and the Ergodic Theorem

## Objective

Use the `markovchain` package to classify states in two chains — one with absorbing states and one ergodic — verify the ergodic theorem empirically, and build a convergence plot showing that different starting states all approach the same stationary distribution.

## Instructions

1. **5-state chain analysis.** The TPM is already provided. After verifying row sums, create the `markovchain` object and run `is.irreducible()`, `communicatingClasses()`, `recurrentClasses()`, and `transientClasses()`. For each function call, write a comment explaining the biological or mathematical reason for the result. In particular: why are S1, S2, S3 transient despite communicating with each other?

2. **Ergodic chain.** Build `mc_erg` from the given TPM. Confirm it is irreducible with `is.irreducible()`. Report the period using `period()` and explain in a comment why the self-loop in state A (P_AA = 0.5) guarantees aperiodicity. Compute the stationary distribution with `steadyStates()`.

3. **Ergodic theorem demonstration.** Simulate 10,000 steps from starting state A using `set.seed(777)`. Compute the empirical time-average fraction in each state (`table() / N`). Print both the empirical and theoretical stationary distributions and compute their absolute differences. Write a comment interpreting the result.

4. **Convergence plot.** Using `mat_power()`, compute distributions at steps 1 to 30 for all three starting states (A, B, C). Build a faceted ggplot2 figure (one panel per starting state) with three coloured lines (one per state A, B, C) and dashed horizontal reference lines at the stationary probabilities. The plot should clearly show convergence by about step 15.

## Submission

Submit your completed `exercise.R`. Requirements:
- All four classification calls (`is.irreducible`, `communicatingClasses`, `recurrentClasses`, `transientClasses`) present with interpretive comments
- Ergodic theorem: empirical vs theoretical absolute differences printed
- Convergence plot rendered with dashed reference lines and facet panels
- Pass `npm run check -- bdat-624 module-02 lesson-03`
