# Task: Yule Process — Theoretical Distribution and Gillespie Simulation

## Objective

Compute the theoretical Geometric PMF of the Yule process at multiple time points, implement a Gillespie algorithm to simulate trajectories, compare simulated population distributions to theory, and track mean/variance over time.

## Instructions

1. **Theoretical PMF.** For λ=0.3 and t ∈ {1, 2, 5, 10}, compute P_n(t) = e^{-λt}(1-e^{-λt})^{n-1} for n = 1,...,30. Create a faceted bar chart (one panel per t). Verify that the weighted mean Σn·P_n(t) matches e^{λt} for each t.

2. **Gillespie simulation.** Implement `simulate_yule(lambda, T_max)`. The function should draw waiting times from Exp(n×λ) when the population is n, increment n, and record (time, population) pairs. Simulate 5 independent trajectories up to T_max=15 hours with `set.seed(123)` and plot as step functions. Overlay the theoretical mean curve E[N(t)] = exp(λt) as a dashed black line.

3. **Distribution comparison at t=5.** Simulate 2000 realisations of N(5) with `set.seed(456)`. Plot side-by-side bars comparing the empirical frequency distribution to the theoretical Geometric(p=e^{-0.3×5}) PMF. Limit x-axis to n=1..30.

4. **Mean and variance over time.** For t = 0, 1, ..., 10 hours, simulate 1000 trajectories with `set.seed(789)` and compute the empirical mean and variance of N(t). Print a table comparing to theoretical E[N(t)] = e^{λt} and Var[N(t)] = e^{λt}(e^{λt}-1). Plot the simulated and theoretical means on a log-scale y-axis.

## Submission

Submit your completed `exercise.R`. Requirements:
- Theoretical PMF plot (faceted, 4 panels)
- Gillespie trajectory plot with mean overlay
- Distribution comparison plot at t=5
- Mean/variance table printed
- Log-scale mean plot rendered
- Pass `npm run check -- bdat-624 module-04 lesson-01`
