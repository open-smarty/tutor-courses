# Task: Birth-Death Process — Extinction Probability and Threshold Behaviour

## Objective

Simulate linear birth-death processes for three values of ρ = μ/λ (subcritical, critical, supercritical), estimate extinction probabilities empirically, compare to the theoretical formula q* = min(1, ρ), and visualise the threshold behaviour.

## Instructions

1. **Theoretical values.** For each (λ, μ) pair: (2,1), (1,1), (2,3), compute ρ = μ/λ and q* = min(1, ρ). Print a table.

2. **Gillespie simulation.** Implement `simulate_bd(lambda, mu, T_max, n0=1)`. At each step: draw waiting time from Exp(n×(λ+μ)); decide birth (probability λ/(λ+μ)) or death (probability μ/(λ+μ)); update n. Run 500 replicates per (λ, μ) pair with `set.seed(2024)` and T_max=20.

3. **Extinction probability over time.** For each ρ value, compute the fraction of simulations extinct at each integer time t ∈ {0,...,20}. Plot all three curves on the same graph with dashed reference lines at the theoretical q*. Print the empirical extinction fraction at T=20 and compare to theoretical q*.

4. **Trajectory plot.** Simulate 3 trajectories per ρ value and plot as step functions using `facet_wrap`. The ρ=0.5 panel should show growth with occasional extinction; the ρ=1.0 panel should show wandering; the ρ=1.5 panel should show rapid extinction.

5. **Threshold plot.** For n₀ = 1, 3, 5, plot q* = min(1, ρ)^n₀ as a function of ρ ∈ [0, 2] on the same graph. Add a vertical dashed line at ρ=1 (the threshold). Write a sentence describing how increasing the initial number of cases n₀ changes the extinction probability.

## Submission

Submit your completed `exercise.R`. Requirements:
- Extinction probability plot with reference lines
- Trajectory faceted plot
- Threshold plot for n₀ = 1, 3, 5
- Theoretical vs empirical extinction probabilities printed
- Interpretive comment on ρ=1 (critical case)
- Pass `npm run check -- bdat-624 module-04 lesson-03`
