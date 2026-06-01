# Task: The Pure Death Process

## Scenario

A petri dish contains j = 200 bacteria. An antibiotic is added at time t = 0. Each bacterium dies independently at rate μ = 0.3 per hour (pure death process, μₙ = nμ). You will use the exact theory and simulation to assess antibiotic effectiveness.

---

## Part (a) — Expected surviving fraction at t = 4 hours

Use E[X(t) | X(0) = j] = je^{−μt}.

1. Compute the expected number of survivors at t = 4 hours.
2. Express this as a fraction of the original 200. Show your working.

---

## Part (b) — Expected surviving fraction at t = 8 hours

Repeat the calculation for t = 8 hours.

Show that the expected surviving count at t = 8 is approximately the square of e^{−μ×4} times the original count — and explain why this makes sense in terms of the survival probability for each bacterium.

---

## Part (c) — Variance of the surviving count at t = 4 hours

Use Var[X(t) | X(0) = j] = je^{−μt}(1 − e^{−μt}).

1. Compute the variance at t = 4 hours.
2. Compute the standard deviation.
3. Interpret: is the variability large or small relative to the mean surviving count? What does this say about the predictability of antibiotic effectiveness across replicate experiments?

---

## Part (d) — Simulation: empirical 5th percentile of X(4)

In R, simulate 500 independent pure death process realisations with j = 200 and μ = 0.3 for t = 0 to 10 hours. Use the exact next-event algorithm.

1. Extract the population at t = 4 for each realisation.
2. Compute the empirical 5th percentile of this distribution.
3. Interpret the result: with 95% probability, how few bacteria survive by t = 4 hours? (i.e., there is a 5% chance the count is at or below this value.)
4. Compare the 5th percentile to the theoretical 5th percentile of Binomial(200, e^{−0.3 × 4}). Use R's `qbinom()` function.

---

## Submission

Submit your R code (as a `.R` file) and written answers for parts (a), (b), (c), and (d). Ensure your code produces clearly labelled output for the simulation in part (d).
