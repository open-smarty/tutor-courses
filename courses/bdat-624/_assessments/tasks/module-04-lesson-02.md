# Task: Pure Death Process — Binomial Distribution and Extinction

## Objective

Compute the Binomial PMF for the pure death process at multiple time points, implement a Gillespie simulation, compare simulated distributions to theory, and estimate the extinction time distribution.

## Instructions

1. **Theoretical PMF.** For N0=200, μ=0.5, and t ∈ {1, 3, 5, 8} days, use `dbinom()` to compute P_n(t) = Binomial(N0, e^{-μt}) PMF. For each t, print E[N(t)]=N0×e^{-μt} and Var[N(t)]=N0×e^{-μt}×(1-e^{-μt}). Create a faceted bar chart (filter to `prob > 0.001` to reduce clutter).

2. **Gillespie simulation.** Implement `simulate_death(N0, mu, T_max)`. At each step, draw wait ~ Exp(n×μ), decrement n. Simulate 5 trajectories up to T_max=15 days with `set.seed(111)`. Plot as step functions with the theoretical mean N0×e^{-μt} overlaid as a dashed line.

3. **Distribution comparison.** Simulate 1000 processes with `set.seed(222)` and record N(3). Build a comparison bar chart (empirical frequency vs theoretical `dbinom(..., prob=e^{-0.5×3})`). Focus the x-axis on the plausible range (where theoretical probability > 0.001).

4. **Extinction time.** Simulate 500 complete processes with `set.seed(333)` and record when the last cell dies. Plot a histogram with the theoretical PDF f(t) = N0×μ×e^{-μt}×(1-e^{-μt})^{N0-1} overlaid. Compute and print: theoretical E[T_ext] = H_{N0}/μ versus simulated mean. Write a sentence comparing the expected extinction time to the individual expected lifetime 1/μ.

## Submission

Submit your completed `exercise.R`. Requirements:
- Theoretical PMF bar chart (faceted)
- Trajectory plot with mean overlay
- Distribution comparison plot at t=3
- Extinction time histogram with theoretical PDF
- Theoretical vs simulated E[T_ext] printed with interpretation
- Pass `npm run check -- bdat-624 module-04 lesson-02`
