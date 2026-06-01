# Task: Module 2, Lesson 2 — Stationary Distribution of Your Biological System

## Overview

Using the 4-state biological system you designed in Module 2, Lesson 1, you will compute its stationary distribution in R, interpret the results biologically, and investigate whether the starting distribution affects the long-run behaviour.

---

## Instructions

### Step 1: Compute the stationary distribution in R

Using the TPM you designed in the Lesson 1 task, solve for the stationary distribution π in R.

Use **both** methods covered in Lesson 2:

**Method A — linear system:**
Set up the system π(P − I) = 0 together with Σ π_j = 1, and solve using `solve()`.

**Method B — eigenvalue decomposition:**
Find the left eigenvector of P corresponding to eigenvalue 1 using `eigen(t(P))`.

Confirm the two methods give the same result (up to numerical precision).

---

### Step 2: Verify the result

Check that your stationary vector satisfies:

1. π **P** = π &nbsp;&nbsp;&nbsp;&nbsp;(print the result of `pi_hat %*% P` and compare to `pi_hat`)
2. All entries are non-negative and sum to 1

Show R output for both checks.

---

### Step 3: Biological interpretation

For each state j in your system, write 2–3 sentences interpreting the stationary probability π_j. Address:

- What does it mean that, in the long run, approximately 100·π_j% of the population will be in state j?
- Does this fraction make biological sense for your chosen system? (You may compare to literature values if you have them, or simply reason from first principles.)
- Which state has the largest stationary probability, and why is that expected given the structure of your TPM?

---

### Step 4: Effect of starting distribution

Choose two very different initial distributions π(0):

- **π(0) = e_j** (the chain starts with certainty in some state j of your choosing)
- **π(0) = (0.25, 0.25, 0.25, 0.25)** (uniform start — equally likely to be in any state)

For each starting distribution, compute π(0) · P^n for n = 1, 5, 10, 25, 50 steps.

Plot the evolution of each marginal probability π_j(n) over n (use `matplot()` or `ggplot2`). Add horizontal dashed lines at the stationary probabilities.

Answer: does the stationary distribution depend on the starting state? Explain in one paragraph why or why not, connecting your answer to the concepts of irreducibility and the ergodic theorem.

---

### Step 5: Biological interpretation of convergence speed

From your plots in Step 4, approximately how many time steps does the chain need before the marginal distribution is within 0.01 of the stationary distribution?

Give a biological interpretation: if one time step represents one month, how long does it take for the disease/ecological system to "forget" its initial state? Is this a fast or slow convergence, and what features of the TPM drive the speed?

---

## Submission format

Submit a report (approx. 400–600 words) plus R code as an appendix, containing:

- Your R code for both methods of finding π
- A table of the stationary distribution with biological interpretation
- Your convergence plots
- Written answers to Steps 3, 4, and 5

---

## Grading criteria

| Criterion | Marks |
|---|---|
| Both methods implemented correctly and agree | 20% |
| Verification (πP = π and sum = 1) shown | 10% |
| Biological interpretation of each π_j is specific and reasoned | 30% |
| Convergence plots are correct and clearly labelled | 20% |
| Reflection on starting-state independence is connected to theory | 20% |
