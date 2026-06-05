# Task: Chapman-Kolmogorov Verification and Stationary Distribution

## Objective

Numerically verify the Chapman-Kolmogorov equations, compute the stationary distribution both algebraically and via matrix-power convergence, and visualise how the distribution evolves over time toward equilibrium.

## Instructions

1. **Set up the chain.** Build the TPM from the lesson (H, S, R states). Compute P^1, P^5, and P^50 using `mat_power()`. Print each rounded to 5 decimal places. In a comment, describe what you observe about the rows of P^50.

2. **Verify C-K numerically.** Choose m=3, n=7. Compute P^3, P^7, and P^10 separately. Check that `P^3 %*% P^7` equals `P^10` (up to floating-point rounding). Print the maximum absolute difference — it should be on the order of 1e-16.

3. **Find the stationary distribution.** Solve the linear system (P - I)^T π = 0 with Σπᵢ = 1 using `solve()`. Print π rounded to 5 decimal places. Verify that π sums to 1 and that `π %*% P` returns π (print the maximum deviation).

4. **Cross-check with markovchain.** Use `steadyStates(mc3)` and confirm it matches your algebraic result. Compute and print the mean return times 1/πᵢ for each state; interpret what the mean return time to state S (Sick) means biologically.

5. **Convergence plot.** Build a long-format data frame of state probabilities at steps 1, 2, 3, 5, 10, 20, 50, 100 (starting from S). Plot with a log-scale x-axis. Overlay dashed horizontal reference lines at the stationary probabilities for each state. The plot should show the distribution "pulling in" to the stationary values.

## Submission

Submit your completed `exercise.R`. Requirements:
- C-K max difference printed (should be < 1e-14)
- Stationary distribution printed; deviation from πP = π < 1e-14
- Convergence plot rendered with dashed reference lines
- At least one interpretive comment on mean return times
- Pass `npm run check -- bdat-624 module-02 lesson-02`
