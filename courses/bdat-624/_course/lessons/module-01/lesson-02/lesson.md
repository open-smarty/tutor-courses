# Lesson 2: Probability Distributions and Transition Probabilities

## Goal

By the end of this lesson you will be able to write down the joint distribution of a stochastic process at multiple time points, define a time-homogeneous process, construct a transition probability matrix (TPM), verify it is a stochastic matrix, and compute multi-step transition probabilities by matrix multiplication.

## Concept

### Describing a process at multiple time points

A single stochastic process generates a *family* of random variables — one at each time point. To fully describe such a family we need the **joint distribution**.

> **Notation:** *F(x₁, x₂, ..., xₙ; t₁, t₂, ..., tₙ)* — the joint cumulative distribution function of the process at times t₁ < t₂ < ... < tₙ. This is the probability that X(t₁) ≤ x₁ and X(t₂) ≤ x₂ and ... and X(tₙ) ≤ xₙ simultaneously.

In general, specifying the complete joint distribution for all possible finite collections of time points is what fully characterises a stochastic process — this is called the **finite-dimensional distributions** of the process.

For most of this course we work with a far simpler object: the **conditional transition distribution**.

> **Notation:** *F(x₀, x; t₀, t)* — the probability that X(t) ≤ x, given that X(t₀) = x₀. Read it as: "starting from value x₀ at time t₀, what is the probability the process is at or below x at time t?"

This captures the one-step (or finite-horizon) conditional behaviour and is the building block of everything that follows.

---

### Time-homogeneity

> **Notation:** A process is **time-homogeneous** if F(x₀, x; t₀, t) = F(x₀, x; 0, t − t₀) for all t₀. In words: the transition distribution depends only on the *elapsed* time (t − t₀), not on the *absolute* starting time t₀.

Think of it this way: if you shuffle a patient through the same sequence of health states, the probability of moving from Healthy to Sick in the next month doesn't change depending on whether it's January or July — only the length of time elapsed matters.

Here's the key insight: time-homogeneity is a huge simplification. Instead of specifying a different transition distribution for every possible starting time t₀, we only need to specify it once as a function of the elapsed time gap. This is why most introductory texts assume time-homogeneity by default.

For discrete-time chains, time-homogeneity means the transition probabilities are the same at every step:

$$P_{ij}^{(t)} = P_{ij} \quad \text{for all } t \in T$$

That is, the probability of going from state *i* to state *j* in one step is a single number P_{ij}, not a function of *t*.

---

### Transition probability notation

> **Notation:** *P_{ij}^{(m,n)}* = P(X_n = j | X_m = i) — the probability of being in state *j* at step *n*, given the process was in state *i* at step *m*. This is called the **(m,n)-step transition probability** from state i to state j.

For a **time-homogeneous** chain, this simplifies beautifully:

> **Notation:** *P_{ij}^{(n)}* = P(X_n = j | X_0 = i) — the probability of reaching state *j* after *exactly n steps*, starting from state *i*. The absolute starting time has dropped out; only the number of steps *n* matters.

When n = 1, we write P_{ij} (no superscript) for the **one-step transition probability**.

---

### The transition probability matrix

Suppose the state space is finite: S = {1, 2, ..., k}. We can collect all one-step transition probabilities into a k × k matrix.

> **Notation:** The **transition probability matrix** (TPM), written **P**, has (i, j) entry equal to P_{ij} = P(X_{n+1} = j | X_n = i). Row *i* gives the probability distribution over *next* states, starting from current state *i*.

Two properties define a valid TPM:

1. **Non-negativity:** 0 ≤ P_{ij} ≤ 1 for all i, j.
2. **Row sums equal 1:** For every row i, $\sum_{j=1}^{k} P_{ij} = 1$.

A matrix satisfying these two properties is called a **stochastic matrix**.

Here's the intuition for why rows must sum to 1: row *i* is a probability distribution — given you are in state *i* right now, you *must* move to *some* state (including possibly staying in *i*). The total probability of all possible destinations is 1.

**Important:** It is rows that sum to 1, not columns. A stochastic matrix is not generally symmetric.

---

### Multi-step transition probabilities via matrix multiplication

Here's one of the most elegant results in the theory:

> **The n-step transition matrix** equals the *n*-th power of the one-step matrix **P**:
> $$P^{(n)} = P^n$$
> where P^{(n)}_{ij} = P(X_n = j | X_0 = i).

We will prove this properly in Module 2 (Chapman-Kolmogorov equations). For now, accept it as a tool and use it.

**Practical consequence:** To find the probability of being in state *j* after 6 months, starting in state *i*, compute the (i, j) entry of **P**⁶. In R: `P_6 <- solve(P) %*% ... ` — or more simply: use the `%^%` operator from the `expm` package, or multiply **P** by itself 6 times.

---

## Example

### A 3-state patient health model

Consider a simple model of patient health with three states:

| State | Label |
|---|---|
| 1 | Healthy (H) |
| 2 | Sick (S) |
| 3 | Dead (D) |

Suppose the one-month transition probabilities are:

$$P = \begin{pmatrix} 0.85 & 0.12 & 0.03 \\ 0.40 & 0.50 & 0.10 \\ 0.00 & 0.00 & 1.00 \end{pmatrix}$$

**Reading the matrix:**
- Row 1 (Healthy): P(stay Healthy) = 0.85, P(become Sick) = 0.12, P(die) = 0.03.
- Row 2 (Sick): P(recover to Healthy) = 0.40, P(stay Sick) = 0.50, P(die) = 0.10.
- Row 3 (Dead): P(stay Dead) = 1.00 — death is an **absorbing state**. Once you're there, you stay.

**Verify it is a stochastic matrix:**
- Row 1: 0.85 + 0.12 + 0.03 = 1.00 ✓
- Row 2: 0.40 + 0.50 + 0.10 = 1.00 ✓
- Row 3: 0.00 + 0.00 + 1.00 = 1.00 ✓
- All entries between 0 and 1 ✓

**Computing the 2-step probability:**

P(Healthy after 2 months | starts Healthy) = P^2[1,1].

In R:
```r
P <- matrix(c(0.85, 0.12, 0.03,
              0.40, 0.50, 0.10,
              0.00, 0.00, 1.00),
            nrow = 3, byrow = TRUE)
P2 <- P %*% P
P2[1, 1]  # P(Healthy at month 2 | Healthy at month 0)
```

Working this out: P^2[1,1] = 0.85×0.85 + 0.12×0.40 + 0.03×0.00 = 0.7225 + 0.048 + 0 = **0.7705**.

So a patient who is Healthy today has about a 77% chance of still being Healthy in two months.

Here's the key insight: matrix multiplication does all the accounting automatically. Each path from H to H via intermediate states (H→H→H, H→S→H, H→D→H) is summed up in a single matrix product.

---

## Task

Open `exercise.R`. You will build the 3-state patient chain using the `markovchain` package, simulate 200 patients over 12 months, and visualise how the population distributes across states over time.

Run the check when done:

```
npm run check -- bdat-624 module-01 lesson-02
```

## Check

```
npm run check -- bdat-624 module-01 lesson-02
```

## Reflection

In the patient model above, state 3 (Dead) is an absorbing state — once entered, it is never left. What does this imply about the long-run (stationary) distribution of the chain? Without doing any calculations, reason through what proportion of patients you expect to be in each state after a very large number of months. Does the concept of a "stationary distribution" in the usual sense even apply here? How might you modify the model to make the chain non-absorbing (i.e., ergodic), and what biological scenario would that correspond to?
