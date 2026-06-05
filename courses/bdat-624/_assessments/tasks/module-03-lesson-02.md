# Task: Poisson Process Simulation and Verification

## Objective

Simulate a Poisson process using exponential inter-arrival times, verify the Poisson count distribution at multiple time points, confirm the Gamma distribution of n-th event waiting times, and demonstrate the memoryless property empirically.

## Instructions

1. **Simulate the process.** Using `lambda = 5` and `T_max = 10`, draw exponential inter-arrival times and accumulate to get event times (keep only those ≤ T_max). Report the total number of events and compare to the theoretical expectation λ×T_max.

2. **Verify inter-arrivals are Exponential.** Plot a histogram of the inter-arrival times with the theoretical Exp(λ) density overlaid. Print observed mean and SD and compare to theoretical values (both = 1/λ for the exponential distribution).

3. **Verify Poisson count distribution.** For t = 0.5, 1, 2, 5 hours, simulate 2000 independent realisations of N(t). For each t, print the observed mean and variance and compare to the theoretical value λt. (For a Poisson distribution, mean = variance = λt.)

4. **Verify Gamma waiting times.** For n = 3, 8, 15, simulate 5000 realisations of the n-th event time by summing n i.i.d. Exp(λ) draws. Create a faceted histogram plot with the Gamma(n, rate=λ) density overlaid in red. Print observed mean and variance versus theoretical E[Tₙ] = n/λ and Var[Tₙ] = n/λ².

5. **Memoryless property.** Simulate 100,000 Exp(λ) inter-arrivals. Condition on W > 1 (the patient has not arrived in the first hour) and compute the residual W - 1. Show that the residual has mean ≈ 1/λ (same as unconditioned). Optionally run a Kolmogorov-Smirnov test against Exp(λ).

## Submission

Submit your completed `exercise.R`. Requirements:
- All three plots rendered (inter-arrival histogram, Gamma faceted histograms)
- Poisson count table printed with observed mean and variance
- Memoryless property demonstrated numerically
- Pass `npm run check -- bdat-624 module-03 lesson-02`
