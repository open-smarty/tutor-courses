# Course Description

**Course title:** Biostatistical Processes and Analytics (BDAT 624)

**Subject area:** Biostatistics / Stochastic Processes / Survival Analysis

**Target audience:** MSc Big Data Analytics students; assumes calculus, basic probability (random variables, expectation, variance), and introductory R. No prior exposure to stochastic processes or survival analysis required.

**Approximate duration:** 14 lessons across 6 modules (~38 hours)

**Programming language:** R (packages: `survival`, `markovchain`, `msm`, `flexsurv`, `diagram`, `ggplot2`, `dplyr`, `KMsurv`, `mstate`, `cmprsk`)

## Overview

This course provides advanced statistical tools for biological and health data analysis. It proceeds in two arcs:

**Arc 1 — Stochastic Processes (Modules 1–4):** Students build rigorous understanding of processes that evolve randomly over time — from the fundamental Markov property, through branching and counting processes, to birth-death population models. Every chapter of Dr. Asiedu's notes is covered with worked proofs, notation glossaries, and R simulations.

**Arc 2 — Survival Analysis (Modules 5–6):** Students learn non-parametric (Kaplan-Meier), semi-parametric (Cox PH), and parametric (AFT) survival methods, then connect back to Arc 1 by modelling competing risks and multi-state processes using the tools from Arc 1.

The course emphasises *two things simultaneously*:
- **Accessibility**: every formula is preceded by a plain-language explanation and a real biostatistics scenario. Notation is introduced incrementally and always decoded before use.
- **Rigour**: proofs are presented step-by-step with annotations. Students at MSc level are expected to follow and reproduce key derivations.

## Topics covered

### Arc 1 — Stochastic Processes
- What is a stochastic process? State spaces, parameter spaces, four types (discrete/continuous × state/parameter)
- Transition probabilities, time-homogeneity, transition probability matrices
- The Markov property; Markov chains; Chapman-Kolmogorov equations (proof)
- Stationary/limiting distributions; ergodicity; regular chains; πP = π
- State classification: accessibility, communication, irreducibility, periodicity, aperiodicity, recurrence, transience
- Branching processes: probability generating functions, extinction probability (Galton-Watson)
- The Poisson process: axioms, derivation of pmf via ODEs
- Renewal/counting processes: waiting time distribution, Gamma/Erlang connection
- Pure birth process (Yule model), pure death process, birth-death process (linear growth, extinction, immigration)

### Arc 2 — Survival Analysis
- Survival function S(t), hazard h(t), cumulative hazard H(t)
- Kaplan-Meier estimator, log-rank test
- Cox proportional hazards model, partial likelihood, hazard ratios
- Parametric models: Exponential, Weibull, log-normal; AFT parameterisation
- Hypothesis testing: log-rank, Wald, likelihood ratio
- Competing risks: cumulative incidence functions, Fine-Gray model
- Multi-state models: connection to continuous-time Markov chains
