# Task: Module 2, Lesson 3 — State Classification and Ergodicity of a Reflecting Random Walk

## Overview

You will analyse a simple random walk on integers {0, 1, 2, ..., 10} with reflecting boundaries, classifying every property from this lesson — irreducibility, periodicity, recurrence, and ergodicity — and connecting the theoretical results to simulation.

---

## The model

Consider a discrete-time process on states {0, 1, 2, ..., 10} governed by the following rules:

- **At state 0:** move to state 1 with probability 1 (reflect upward)
- **At state 10:** move to state 9 with probability 1 (reflect downward)
- **At any interior state i ∈ {1, 2, ..., 9}:** move to i − 1 with probability 1/2, or to i + 1 with probability 1/2 (symmetric random walk)

---

## Questions

### Part (a): Irreducibility

Show that this chain is irreducible. That is, demonstrate that every state can reach every other state.

You do not need to construct the full TPM (though you may). Instead, give a short argument: starting from any state i, describe a path of transitions that reaches any other state j, using only the rules above.

---

### Part (b): Periodicity

What is the period d of each state? Justify your answer.

Hint: Consider state 5 (an interior state). After how many steps can it return to state 5? List the possible return times and compute their gcd.

Then consider state 0 (a boundary state). After how many steps can it return to state 0? How does the reflecting boundary affect the return time structure compared to an absorbing boundary?

---

### Part (c): Ergodicity

Is this chain ergodic? State clearly which of the three conditions (irreducibility, positive recurrence, aperiodicity) hold, and why each does or does not hold.

For the positive recurrence condition: in a finite irreducible chain, all states are positive recurrent. Explain briefly why finiteness guarantees this.

---

### Part (d): Stationary distribution — analytic derivation

For a symmetric reflecting random walk on {0, 1, ..., N} with N = 10, the stationary distribution can be derived from the balance equations.

For an interior state i, the detailed balance equation is:

$$\pi_i \cdot \frac{1}{2} = \pi_{i-1} \cdot \frac{1}{2} \quad \text{(flow from i to i-1 = flow from i-1 to i)}$$

This gives $\pi_i = \pi_{i-1}$ for all interior i. For boundary states 0 and 10, the flow equations give $\pi_0 = \pi_1 / 2$ and $\pi_{10} = \pi_9 / 2$.

Using the normalisation $\sum_{i=0}^{10} \pi_i = 1$, derive the stationary distribution in closed form. Express each $\pi_i$ as a fraction.

Verify your answer in R: compute `steadyStates()` on the markovchain object and confirm it matches your analytic formula.

---

### Part (e): Mean recurrence time and simulation

By the ergodic theorem, the mean recurrence time for state i is $\mu_i = 1 / \pi_i$.

Compute $\mu_i$ for i = 0, 1, 2, 3, 4, 5 using your analytic stationary distribution.

What happens to $\mu_i$ as i moves from 5 toward 0? Explain this result intuitively: does it take longer or shorter to return to the boundary than to the centre, and why?

In your R simulation (1000 steps from the exercise), estimate the mean return time to state 0 empirically by recording every time the walk visits state 0 and computing the average gap between consecutive visits. Compare to the theoretical $\mu_0 = 1 / \pi_0$.

---

## Submission format

Submit a report (approx. 500–700 words) plus R code as an appendix, containing:

- Answers to Parts (a) through (e) as clearly labelled sections
- Your analytic derivation of the stationary distribution (Part d), showing the balance equations
- The R verification and simulation output (Part d and e)
- Plots of the reflecting random walk trajectory and empirical visit frequencies (from the exercise)

---

## Grading criteria

| Criterion | Marks |
|---|---|
| Irreducibility argument is correct and clearly stated | 15% |
| Period derivation is correct with gcd calculation shown | 20% |
| Ergodicity conditions correctly addressed for all three criteria | 15% |
| Stationary distribution derivation from balance equations is complete | 25% |
| Mean recurrence time analysis and simulation comparison | 25% |
