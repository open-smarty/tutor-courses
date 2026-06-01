# Task: Module 3, Lesson 2 — The Poisson Process and Renewal Counting

## Context

Mutations in a DNA strand occur according to a Poisson process with rate λ = 2 mutations per kilobase pair (kb). Let X(t) denote the number of mutations in a stretch of length t kb, so X(t) ~ Poisson(λt) = Poisson(2t). Let T_n denote the waiting distance (in kb) until the n-th mutation.

---

## Questions

### Part (a) — Probability of exactly 3 mutations in a 1 kb region

Use the Poisson PMF to compute P(X(1) = 3). Show your calculation explicitly:

$$P(X(1) = 3) = \frac{e^{-\lambda} \lambda^3}{3!}$$

Evaluate this both by hand (leaving e^{-2} in your answer) and numerically in R using `dpois()`.

### Part (b) — Expected mutations in a 5 kb region

State and compute E(X(5)). Recall that X(5) ~ Poisson(λ × 5). What is the variance of X(5)?

### Part (c) — Waiting distance for the first mutation

What is the probability of waiting more than 2 kb for the first mutation? That is, compute P(T_1 > 2) where T_1 ~ Exponential(λ = 2).

Recall P(T_1 > t) = e^{−λt}. Evaluate numerically and in R using `pexp()`.

### Part (d) — Simulation study

Simulate 10,000 independent 1 kb regions and compute the fraction with 0, 1, 2, 3, and ≥4 mutations. Compare to the theoretical Poisson(2) probabilities.

Your R code must:

1. Set a random seed (`set.seed(2024)`) for reproducibility.
2. Simulate mutation counts per region using `rpois(10000, lambda = 2)`.
3. Compute the empirical proportions for counts 0, 1, 2, 3, ≥4 using `table()` and normalisation.
4. Compute theoretical probabilities using `dpois(0:3, lambda = 2)` and `ppois(3, lambda = 2, lower.tail = FALSE)`.
5. Display both sets of probabilities side by side in a well-formatted table.
6. Produce a bar chart overlaying the empirical and theoretical proportions.

---

## Submission checklist

- [ ] Written calculation for Part (a) — exact expression and numerical value
- [ ] Written answer for Part (b) — state the distribution, mean, and variance
- [ ] Written calculation for Part (c) — formula and numerical value
- [ ] R code for Part (d) with comments
- [ ] A formatted comparison table (empirical vs theoretical proportions)
- [ ] A bar chart from Part (d)

---

## Marking notes

| Part | Marks | Key criteria |
|------|-------|--------------|
| (a)  | 2     | Correct PMF formula applied; numerical value ≈ 0.1804 |
| (b)  | 2     | E(X(5)) = 10; Var(X(5)) = 10; correct reasoning |
| (c)  | 2     | P(T_1 > 2) = e^{-4} ≈ 0.0183; correct use of Exp(λ) survival function |
| (d)  | 4     | Correct simulation (seed set); accurate empirical fractions; comparison table present; plot |

**Total: 10 marks**

---

## Reference values

| k | P(X(1) = k) — Poisson(2) | Approximate value |
|---|---|---|
| 0 | e^{-2} | 0.1353 |
| 1 | 2e^{-2} | 0.2707 |
| 2 | 2e^{-2} | 0.2707 |
| 3 | (4/3)e^{-2} | 0.1804 |
| ≥4 | 1 − Σ_{k=0}^3 | 0.1429 |
