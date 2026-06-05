# Lesson 1: The Markov Property and Transition Matrices

## Goal

State and understand the Markov property precisely, explain why it is a powerful simplification, and build a clinically realistic Transition Probability Matrix for a four-state patient health model.

## Concept

### The Full Conditional and Why It Is Intractable

Imagine tracking a patient's health status — Healthy, Mildly Ill, Severely Ill, or Dead — each day over a two-year hospital stay (about 730 days). To predict tomorrow's state using the full history, we would in principle need to know:
- The state on day 1, day 2, ..., day 729 (today)
- And compute a conditional probability given all 729 observations

This is computationally and statistically impossible for long histories. The data requirement grows exponentially with the history length.

### The Markov Postulate

The **Markov property** (or **Markov postulate**) is the simplifying assumption that slashes this complexity:

> **"The future depends ONLY on the present, not on the past."**

Formally:

> **Notation block:**
> - X₀, X₁, ..., Xₙ — the history of the process up to step n; read "the states at steps 0, 1, ..., n"
> - i₀, i₁, ..., iₙ — specific values the process takes at each step; each is an element of S
> - j — the state at step n+1 (the future)
> - P(Xₙ₊₁ = j | X₀ = i₀, X₁ = i₁, ..., Xₙ = iₙ) — the conditional probability of the future state given the *entire* past history

**Markov property:** For all n ≥ 0 and all states i₀, i₁, ..., iₙ, j ∈ S:

$$P(X_{n+1} = j \mid X_0 = i_0, X_1 = i_1, \ldots, X_n = i_n) = P(X_{n+1} = j \mid X_n = i_n)$$

The right-hand side conditions only on the current state Xₙ = iₙ — the entire history X₀, ..., Xₙ₋₁ drops out.

Here's the key insight: instead of tracking 729 days of history, we only need to know where the patient is *today*. The current state is a **sufficient statistic** for predicting the future — it captures all past information that is relevant to tomorrow.

### What "Markov Chain" Means

A stochastic process {Xₙ : n = 0, 1, 2, ...} with discrete time, discrete state space S, and the Markov property is called a **Markov chain** (abbreviated MC). Adding time-homogeneity (Lesson 2 of Module 1) means the transition probabilities are captured by a single fixed matrix.

> **Notation block:**
> - Pᵢⱼ — the (i,j) entry of the TPM; the probability of moving from state i to state j in one step
> - P — the **Transition Probability Matrix** (TPM); a |S| × |S| matrix where P[i,j] = Pᵢⱼ

For a time-homogeneous Markov chain:

$$P_{ij} = P(X_{n+1} = j \mid X_n = i) \quad \text{for all } n \geq 0$$

### Why the Markov Property Is a Strong Assumption

In a biological context, the Markov property says that *knowing a patient is Severely Ill today is enough* — you get no additional predictive power from knowing that they were Mildly Ill yesterday and Healthy the day before. This may be approximately true for some diseases but not for others (e.g., diseases with long incubation periods or where prior treatment history matters). Always validate the Markov assumption in real data.

### Constructing a Realistic TPM: Four Clinical States

Consider a patient health model with states:
- **0 = Healthy (H):** No signs of disease
- **1 = Mildly Ill (MI):** Symptomatic but not hospitalised
- **2 = Severely Ill (SI):** Hospitalised
- **3 = Dead (D):** Absorbing state

> **Notation block:**
> - S = {H, MI, SI, D} — the four states, numbered 0, 1, 2, 3
> - An absorbing state is one from which escape is impossible: Pᴅᴅ = 1, Pᴅⱼ = 0 for j ≠ D

We construct the TPM based on clinical reasoning:

From **Healthy (H)**:
- P(H→H) = 0.90: Most healthy patients remain healthy each week
- P(H→MI) = 0.09: A small fraction become mildly ill
- P(H→SI) = 0.01: A very small fraction are suddenly severely ill (acute event)
- P(H→D) = 0.00: Direct death from health is negligible in this model

From **Mildly Ill (MI)**:
- P(MI→H) = 0.30: Recovery to healthy is common with treatment
- P(MI→MI) = 0.50: Many stay in mild illness
- P(MI→SI) = 0.18: Some progress to severe illness
- P(MI→D) = 0.02: Small but non-zero mortality

From **Severely Ill (SI)**:
- P(SI→H) = 0.05: Some complete recovery (ICU discharge to home)
- P(SI→MI) = 0.30: Partial improvement is the most common good outcome
- P(SI→SI) = 0.50: Half remain severely ill each week
- P(SI→D) = 0.15: 15% mortality rate from severe illness

From **Dead (D)**:
- P(D→D) = 1.00: Death is absorbing — there is no exit

The TPM is therefore:

$$P = \begin{pmatrix} 0.90 & 0.09 & 0.01 & 0.00 \\ 0.30 & 0.50 & 0.18 & 0.02 \\ 0.05 & 0.30 & 0.50 & 0.15 \\ 0.00 & 0.00 & 0.00 & 1.00 \end{pmatrix}$$

Rows: H, MI, SI, D. Columns: H, MI, SI, D.

**Verify the absorbing state.** Row 4 (Dead): (0, 0, 0, 1). The row sums to 1 with all probability on D. Once dead, the process stays in D forever. This is the mathematical definition of an absorbing state.

**Verify row sums:**
- Row H: 0.90 + 0.09 + 0.01 + 0.00 = 1.00 ✓
- Row MI: 0.30 + 0.50 + 0.18 + 0.02 = 1.00 ✓
- Row SI: 0.05 + 0.30 + 0.50 + 0.15 = 1.00 ✓
- Row D: 0.00 + 0.00 + 0.00 + 1.00 = 1.00 ✓

### The markovchain Package

In R, the `markovchain` package provides the `markovchain` S4 class to represent and manipulate Markov chains. Key functions:

- `new("markovchain", states=..., byrow=TRUE, transitionMatrix=..., name=...)` — create a chain
- `markovchainSequence(n, markovchain, t0)` — simulate a trajectory of n steps starting from state t0
- `steadyStates(mc)` — compute the stationary distribution (we prove this in Lesson 2)
- `is.irreducible(mc)` — check if all states communicate (Lesson 3)

## Example

**Simulating a patient trajectory under the four-state model.**

We use the TPM P above. Start with a cohort of patients, all initially Healthy. We want to know: what is the probability distribution over states after 10 weeks?

Using matrix multiplication:

$$\pi_{10} = \pi_0 \cdot P^{10}$$

where π₀ = (1, 0, 0, 0) (all Healthy at week 0).

The result P^10 can be computed in R. Here's the key insight about the Dead absorbing state: P^10[H, D] tells us the probability that a patient who was Healthy at week 0 is Dead by week 10. Even with only 0.01 probability of H→SI and 0.15 probability of SI→D, over 10 weeks the cumulative probability of death is non-trivial — this is why chronic disease models must be run over long time horizons.

**Checking for the absorbing state structure.** An absorbing state satisfies Pᵢᵢ = 1. In R:
```r
diag(P)["D"]  # should equal 1
```

And all off-diagonal entries in row D should be 0:
```r
P["D", c("H", "MI", "SI")]  # should be (0, 0, 0)
```

## Task

See `exercise.R`. You will define the four-state clinical Markov chain using the `markovchain` package, simulate a 100-step trajectory starting from Healthy, plot the trajectory, and verify the absorbing state structure.

## Check

```
npm run check -- bdat-624 module-02 lesson-01
```

## Reflection

The Markov property assumes the current state is all you need to predict the future. In the four-state clinical model, the "Mildly Ill" state aggregates patients who have been mildly ill for 1 day versus those mildly ill for 6 months. In practice, duration of illness often predicts outcome better than the current severity category alone. This is called **duration dependence**. How could you modify the state space to partially capture duration without abandoning the Markov structure? (Hint: consider expanding MI into MI-short and MI-long.) What is the trade-off of this expansion in terms of data requirements for estimating the TPM?
