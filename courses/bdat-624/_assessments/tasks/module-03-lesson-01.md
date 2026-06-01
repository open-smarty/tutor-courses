# Task: Module 3, Lesson 1 — Branching Processes

## Context

A disease is transmitted such that each infected individual independently infects a Poisson(λ) number of others before recovering. The infected individuals form a Galton-Watson branching process with offspring distribution Poisson(λ).

The probability generating function of a Poisson(λ) random variable X is:

$$f(z) = E(z^X) = e^{\lambda(z - 1)}$$

---

## Questions

### Part (a) — Mean population size

What is E(X_n) after n transmission generations, expressed in terms of λ? Show your reasoning, referencing the general result E(X_n) = m^n.

### Part (b) — Extinction threshold

For what values of λ is ultimate extinction certain (probability 1)? For what values of λ is there a positive probability of the epidemic persisting indefinitely? Justify your answer using the extinction criterion.

### Part (c) — Extinction probability for λ = 1.5

For λ = 1.5, the extinction probability q satisfies f(q) = q, i.e.:

$$e^{1.5(q - 1)} = q$$

This equation has no closed-form solution, but you can find q numerically in R. Write R code that:

1. Defines the Poisson(1.5) p.g.f. as a function `pgf_poisson <- function(z, lambda) exp(lambda * (z - 1))`.
2. Iterates q_{k+1} = pgf_poisson(q_k, 1.5) starting from q_0 = 0 until convergence (|q_{k+1} - q_k| < 1e-8).
3. Reports the converged value of q.
4. Plots the iterates to show convergence.

### Part (d) — Simulation validation

Simulate 2000 epidemics for 50 generations with λ = 1.5. Each epidemic starts with a single infected individual (X_0 = 1) and uses Poisson(1.5) offspring.

In your R code:
- Generate all 2000 trajectories.
- Report the fraction of epidemics that are extinct by generation 50 (X_50 = 0).
- Compare this empirical fraction to your numerical answer from Part (c).
- Plot the distribution of X_50 for surviving epidemics on a log scale.

---

## Submission checklist

- [ ] Written answers for Parts (a) and (b) (clearly stated, not just R output)
- [ ] R code for Parts (c) and (d) with comments explaining each step
- [ ] The numerical extinction probability from Part (c)
- [ ] The empirical extinction fraction from Part (d) and a comparison to Part (c)
- [ ] The convergence plot from Part (c)
- [ ] The X_50 distribution plot from Part (d)

---

## Marking notes

| Part | Marks | Key criteria |
|------|-------|--------------|
| (a)  | 2     | Correct formula E(X_n) = λ^n, with m = λ stated explicitly |
| (b)  | 2     | Threshold at λ = 1 correctly identified; m ≤ 1 → q = 1 stated |
| (c)  | 3     | Correct fixed-point iteration; convergence to q ≈ 0.4170 (Poisson(1.5)) |
| (d)  | 3     | Correct simulation; empirical fraction close to c(q) from (c); appropriate plot |

**Total: 10 marks**
