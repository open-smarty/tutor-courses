# Learning Requirements

## Learning outcomes

After completing this course, students will be able to:

1. Define a stochastic process, identify its state space and parameter space, and classify it into one of four types.
2. Construct a transition probability matrix for a Markov chain and verify the stochastic matrix properties.
3. Apply the Chapman-Kolmogorov equations to compute n-step transition probabilities; follow and reproduce the proof.
4. Find the stationary distribution of an ergodic Markov chain using πP = π and the normalisation constraint.
5. Classify states as recurrent/transient, aperiodic/periodic, and determine whether a chain is irreducible or regular.
6. Model a Galton-Watson branching process, compute the p.g.f., derive E(Xₙ) = μⁿ by induction, and find the extinction probability.
7. Derive the Poisson pmf from first principles using the differential-equation approach.
8. Derive the waiting-time distribution of the n-th Poisson event and identify it as Gamma(n, λ).
9. Derive the probability distribution of the Yule (pure birth) process and compute its mean and variance.
10. Set up the birth-death differential equations and interpret extinction probability in terms of ρ = μ/λ.
11. Estimate and plot Kaplan-Meier survival curves in R; perform and interpret log-rank tests.
12. Fit and interpret a Cox PH model in R; assess proportional hazards assumption with Schoenfeld residuals.
13. Fit parametric AFT models in R; compare models using AIC/BIC; interpret AFT vs PH parameterisations.
14. Construct cumulative incidence functions for competing risks; fit a Fine-Gray model in R.
15. Connect competing risks to multi-state Markov models and set up a transition intensity matrix.

## Prerequisites

- Calculus: differentiation, integration, ODEs (first order, separable, integrating factor)
- Probability: random variables, PMF/PDF, expectation, variance, conditional probability, total probability rule
- Distributions: Binomial, Poisson, Exponential, Normal, Gamma — know the PDF and basic properties
- Linear algebra: matrix multiplication, matrix powers Pⁿ
- Introductory R: data frames, basic plotting — OR willingness to learn from in-lesson walkthroughs

## Constraints

- All exercises are R-based (.R files). Students must have R ≥ 4.1 with packages: `survival`, `markovchain`, `msm`, `flexsurv`, `diagram`, `ggplot2`, `dplyr`, `KMsurv`, `mstate`, `cmprsk`
- Exercises use real R datasets: `survival::lung`, `survival::veteran`, `KMsurv::bmt`, `markovchain` package examples
- Solutions visible after passing the quiz
- Every new notation symbol must be decoded in plain English before first use (see generation notes for format)
- Do not skip modules — Arc 1 feeds Arc 2

## Structure

- Modules: 6
- Lessons per module: 2–3 (Module 6 has 1 extended lesson)
- Total lessons: 14
