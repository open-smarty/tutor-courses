# Task: Branching Process Simulation and Extinction Analysis

## Objective

Implement and simulate Galton-Watson branching processes for two offspring distributions (Poisson and Geometric, both with mean 1.5), numerically find extinction probabilities by fixed-point iteration, and verify the theory against simulation.

## Instructions

1. **Fixed-point iteration.** For both the Poisson(1.5) and Geometric(p=0.4) offspring distributions, implement the PGF functions `G_A(s)` and `G_B(s)`. Use `iterate_extinction()` with 200 iterations to find the extinction probability q*. Print both values and write a comment comparing them — which is larger and why? (Hint: consider the role of offspring variance.)

2. **Simulate branching processes.** Use `simulate_branching()` and `set.seed(314)` to simulate 1000 independent trajectories of 50 generations for each offspring distribution. Store results in matrices `traj_pois` and `traj_geom` (1000 rows × 51 columns).

3. **Extinction probability plot.** For each distribution, compute the fraction of simulations extinct at each generation (0 to 50). Plot both curves on the same graph. Add horizontal dashed reference lines at the theoretical q* values with annotation labels. The empirical curves should converge to the theoretical values by generation 50.

4. **Mean population size plot.** Compute `colMeans()` of each trajectory matrix. Plot the simulated mean population sizes alongside the theoretical 1.5^n curve on a log-scale y-axis. Confirm that the theoretical line is linear on the log scale (exponential growth = linear on log scale).

5. **Final comparison.** Print the empirical extinction probability at generation 50 for both distributions and compare to theoretical q*. Write a sentence interpreting the difference between Poisson and Geometric extinction probabilities in terms of their offspring variances.

## Submission

Submit your completed `exercise.R`. Requirements:
- `G_A` and `G_B` defined; theoretical q* printed for both
- 1000 trajectory simulations with `set.seed(314)`
- Both plots rendered (extinction probability and mean population size)
- Interpretive comment on variance and extinction probability
- Pass `npm run check -- bdat-624 module-03 lesson-01`
