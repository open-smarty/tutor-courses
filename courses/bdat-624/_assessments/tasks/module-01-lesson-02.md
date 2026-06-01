# Task: Build Your Own Markov Chain

## Instructions

Using the `markovchain` package in R, design and analyse a **3-state Markov chain** for a biological or public health system of your choice. You must:

1. Choose a system with at least three meaningful discrete states.
2. Specify the transition probability matrix and justify each entry.
3. Simulate 100 individuals for 24 steps.
4. Report and compare the empirical proportions at step 24 with the theoretical stationary distribution.

Submit your work as a single commented R file.

---

## Requirements

### 1. Choose your system and states (comment, no code)

Describe your biological or public health system. What does each state represent? Examples you might consider:

- HIV treatment: Suppressed / Failing / Lost-to-follow-up
- Cancer screening: Unscreened / Screen-negative / Screen-positive / Diagnosed
- Smoking cessation: Never-smoker / Current-smoker / Former-smoker
- Malaria transmission: Susceptible / Infected / Recovered

You are not limited to these — any three-state biological system with plausible transition dynamics is acceptable.

### 2. Specify and justify your TPM

Write down your 3×3 transition probability matrix **P**. For each non-obvious entry, include a brief comment explaining the biological rationale. For example:

```r
# P[1,2] = 0.15: probability a suppressed patient relapses in one month,
# estimated from literature (e.g., Muyindike et al., 2014)
```

You do not need real citations — reasonable assumptions grounded in biological logic are sufficient. Make sure every row sums to 1.

### 3. Simulate 100 individuals for 24 steps

Use `markovchainSequence()` to simulate each individual's trajectory. All individuals should start in the same initial state (your choice — justify it).

### 4. Report empirical state proportions at step 24

Compute and print the proportion of individuals in each state at step 24.

### 5. Compute and compare the theoretical stationary distribution

The stationary distribution **π** satisfies **πP = π** and **Σπᵢ = 1**.

In R, one way to find it is:

```r
# Hint: the stationary distribution is the left eigenvector of P
# corresponding to eigenvalue 1.
# Alternatively, for a well-behaved chain:
steady <- steadyStates(your_mc_object)
```

Compare the theoretical stationary distribution to the empirical proportions from step 4. Are they close? Comment on whether your chain appears to have converged by step 24.

---

## Grading guidance

A strong submission will:

- Have a clear, biologically coherent system with states that are mutually exclusive and exhaustive
- Justify transition probabilities with reference to plausible biological mechanisms or orders of magnitude
- Note whether any states are absorbing and what this implies for the stationary distribution
- Compare the empirical and theoretical stationary distributions quantitatively (e.g., absolute difference per state)
- Comment on whether 24 steps is long enough for the chain to mix — if the convergence is slow, explain why (e.g., near-absorbing state, very small off-diagonal entries)
