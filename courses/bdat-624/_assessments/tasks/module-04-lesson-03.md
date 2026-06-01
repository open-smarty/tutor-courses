# Task: Birth-Death Process — Linear Growth and Extinction

## Scenario

An HIV infection begins with i = 5 infected cells. Each infected cell produces new virions at rate λ = 2 per day (birth) and is killed by the immune response at rate μ = 1.5 per day (death). You will analyse this infection using the linear birth-death process.

---

## Part (a) — Intrinsic growth rate

Compute the intrinsic growth rate (λ − μ). Classify the process as supercritical, critical, or subcritical. What does this classification predict about the long-run behaviour of the infection on average?

---

## Part (b) — Expected infected cells at day 3

Use E[X(t) | X(0) = i] = ie^{(λ−μ)t}.

1. Compute E[X(3) | X(0) = 5].
2. How does this compare to the initial count? By what factor has the infection grown in expectation?

---

## Part (c) — Probability of natural extinction

Use the extinction probability formula:
$$q_i = (\mu/\lambda)^i \quad \text{if } \lambda > \mu$$

1. Compute the probability that the infection dies out naturally (the immune system eliminates all 5 infected cells before a stable viral population is established).
2. Interpret this probability: is it large or small? What does it imply for early intervention?

---

## Part (d) — Antiretroviral therapy

An antiretroviral drug doubles the immune-mediated death rate to μ = 3 per day (while λ = 2 remains unchanged).

1. Compute ρ = μ/λ under treatment. Is the process now subcritical?
2. What is the extinction probability under treatment? Justify your answer using the formula.
3. Explain in one sentence what treatment achieves in probabilistic terms.

---

## Part (e) — Simulation comparison (with and without treatment)

In R, simulate 1000 realisations of each scenario (untreated and treated) for t = 0 to 30 days. Use the exact next-event algorithm (as in `exercise.R`).

For each scenario:
- Plot the fraction of realisations still active (population > 0) over time. This is the empirical **persistence probability** 1 − (extinction fraction).
- Report the fraction extinct by t = 30.
- Report the fraction extinct by t = 100.

For the untreated scenario:
- Compute the theoretical extinction probability (μ/λ)^5.
- Compare to the simulated fraction extinct at t = 100.

Plot both persistence curves on the same graph and comment on what treatment achieves.

---

## Submission

Submit your R code (as a `.R` file) and written answers for parts (a)–(d). Include the persistence plot from part (e) with clear axis labels and a legend distinguishing the two scenarios.
