# Lesson 2: Chapman-Kolmogorov Equations and Stationary Distributions

## Goal

By the end of this lesson you will be able to derive n-step transition probabilities via the Chapman-Kolmogorov equations, prove that P^(n) = P^n, compute the marginal state distribution at any time step, and find the stationary distribution of a regular Markov chain.

## Concept

### Motivation: beyond one step

The TPM **P** tells us where the process goes in *one* step. But we often want to know: "What is the probability of being in state j after 12 months, starting from state i today?" That requires n-step transition probabilities.

Here's the key insight: the clever trick is that you can get from i to j in n steps by first going from i to some intermediate state k, and then going from k to j. If you sum over all possible intermediate states k, you recover the n-step probability. This is the Chapman-Kolmogorov equation — and it turns out to be equivalent to *matrix multiplication*.

---

### N-step transition probabilities

> **Notation:** *P_{ij}^{(n)}* — the probability of moving from state i to state j in exactly n steps. Read: "n-step transition probability from i to j." The superscript is in parentheses to distinguish it from P raised to the power n (though we will soon show they are the same thing).

> **Notation:** *P^{(n)}* — the m × m matrix whose (i,j) entry is P_{ij}^{(n)}. This is the matrix of all n-step transition probabilities.

Note that $P^{(1)} = \mathbf{P}$ (the ordinary TPM) and $P^{(0)} = \mathbf{I}$ (the identity matrix — the "zero-step" probability of going from i to i is 1).

---

### The Chapman-Kolmogorov equations

Let $m < r < n$. The Chapman-Kolmogorov (CK) equation is:

$$P_{ij}^{(m,n)} = \sum_{k \in S} P_{ik}^{(m,r)} \cdot P_{kj}^{(r,n)}$$

In plain English: "To go from state i at step m to state j at step n, you must pass through *some* state k at the intermediate step r. Sum the probability of each possible path $i \to k \to j$ over all states k."

For a **time-homogeneous** chain, $P_{ij}^{(m,n)}$ depends only on $n - m$ (the number of steps, not the starting time), so we write $P_{ij}^{(n-m)}$. The CK equation becomes:

$$P_{ij}^{(m+r)} = \sum_{k \in S} P_{ik}^{(m)} \cdot P_{kj}^{(r)}$$

This is exactly the rule for multiplying two matrices. That means the left-hand side is the $(i,j)$ entry of $P^{(m)} \cdot P^{(r)}$.

---

### Key theorem: P^(n) = P^n

This is the central computational fact for Markov chains.

**Theorem.** For a time-homogeneous Markov chain, $P^{(n)} = \mathbf{P}^n$ (the ordinary matrix **P** multiplied by itself n times).

**Proof by induction.**

*Base case (n = 1).* $P^{(1)} = \mathbf{P} = \mathbf{P}^1$. ✓

*Inductive step.* Assume $P^{(r)} = \mathbf{P}^r$ for all $r = 1, 2, \ldots, n-1$. We want to show $P^{(n)} = \mathbf{P}^n$.

By the CK equation with m = n-1, r = 1:

$$P_{ij}^{(n)} = \sum_{k \in S} P_{ik}^{(n-1)} \cdot P_{kj}^{(1)}
\quad \leftarrow \text{by CK equation}$$

By the inductive hypothesis, $P^{(n-1)} = \mathbf{P}^{n-1}$, so $P_{ik}^{(n-1)}$ is the $(i,k)$ entry of $\mathbf{P}^{n-1}$. And $P_{kj}^{(1)} = P_{kj}$ is the $(k,j)$ entry of **P**.

Therefore the sum $\sum_k P_{ik}^{(n-1)} \cdot P_{kj}$ is the $(i,j)$ entry of the matrix product $\mathbf{P}^{n-1} \cdot \mathbf{P}$:

$$P_{ij}^{(n)} = \left[\mathbf{P}^{n-1} \cdot \mathbf{P}\right]_{ij} = \left[\mathbf{P}^n\right]_{ij}
\quad \leftarrow \text{by matrix multiplication}$$

Since this holds for all i and j, $P^{(n)} = \mathbf{P}^n$. $\blacksquare$

**What this means practically:** to find the probability of being in state j after 12 steps starting from state i, compute the (i, j) entry of $\mathbf{P}^{12}$ in R using matrix exponentiation.

---

### The marginal (unconditional) state distribution

We often want to know the probability of being in each state at time n, *without conditioning on a specific starting state* — especially when we have a population of patients with different starting conditions.

> **Notation:** *π(n)* — the row vector $[\pi_1(n), \pi_2(n), \ldots, \pi_m(n)]$ where $\pi_j(n) = P(X_n = j)$. This is the **marginal distribution** at time n: the probability of being in state j at step n, integrated over the starting distribution.

> **Notation:** *π(0)* — the **initial distribution**: a row vector giving the probability of starting in each state. If you know the process starts in state i with certainty, then $\pi(0) = e_i$ (a unit vector with a 1 in position i).

The marginal distribution at step n is:

$$\pi(n) = \pi(0) \cdot \mathbf{P}^n$$

This is a simple matrix-vector product. To get $\pi_j(n)$, take the dot product of the initial distribution $\pi(0)$ with the j-th column of $\mathbf{P}^n$.

---

### The stationary distribution

As n → ∞, does the marginal distribution settle down? For many chains it does.

> **Notation:** *π = (π₁, π₂, ..., πₘ)* — the **stationary (long-run) distribution**. $\pi_j = \lim_{n \to \infty} P(X_n = j)$ when this limit exists. Also called the **steady-state distribution** or **equilibrium distribution**.

A distribution π is stationary if and only if it satisfies two conditions simultaneously:

1. $\pi \mathbf{P} = \pi$ &nbsp;&nbsp;&nbsp;&nbsp;(matrix equation — the distribution is unchanged by one step of the chain)
2. $\sum_j \pi_j = 1$ &nbsp;&nbsp;&nbsp;&nbsp;(it is a valid probability distribution)

Let's unpack condition 1. If the chain is currently in steady state (each state j occupied with probability $\pi_j$), then after one step the probability of being in state j is $\sum_i \pi_i P_{ij}$ — which must equal $\pi_j$ again. This is precisely $\pi \mathbf{P} = \pi$.

**How to solve for π.** Rearranging condition 1:

$$\pi \mathbf{P} = \pi \;\Longrightarrow\; \pi (\mathbf{P} - \mathbf{I}) = \mathbf{0}$$

This is a homogeneous linear system. We solve it together with $\sum_j \pi_j = 1$ (to pin down the unique solution). In practice:

- Replace one equation in $\pi(\mathbf{P} - \mathbf{I}) = \mathbf{0}$ with $\sum_j \pi_j = 1$.
- Solve the resulting square linear system using `solve()` in R.
- Alternatively, use the left eigenvector corresponding to eigenvalue 1 of **P**.

---

### Worked example: finding the stationary distribution

Let (from Dr. Asiedu's notes, p. 15–16):

$$\mathbf{P} = \begin{pmatrix} 0 & 2/3 & 1/3 \\ 3/8 & 1/8 & 1/2 \\ 1/2 & 1/2 & 0 \end{pmatrix}$$

First, verify it's a stochastic matrix:

- Row 0: $0 + 2/3 + 1/3 = 1$ ✓
- Row 1: $3/8 + 1/8 + 4/8 = 1$ ✓
- Row 2: $1/2 + 1/2 + 0 = 1$ ✓

Now solve $(\pi_0, \pi_1, \pi_2) \mathbf{P} = (\pi_0, \pi_1, \pi_2)$ with $\pi_0 + \pi_1 + \pi_2 = 1$.

Writing out the three equations from $\pi \mathbf{P} = \pi$:

$$\pi_0 = 0\cdot\pi_0 + \frac{3}{8}\pi_1 + \frac{1}{2}\pi_2 \quad \cdots (1)$$
$$\pi_1 = \frac{2}{3}\pi_0 + \frac{1}{8}\pi_1 + \frac{1}{2}\pi_2 \quad \cdots (2)$$
$$\pi_2 = \frac{1}{3}\pi_0 + \frac{1}{2}\pi_1 + 0\cdot\pi_2 \quad \cdots (3)$$

Plus the normalisation constraint: $\pi_0 + \pi_1 + \pi_2 = 1$.

After solving this system (see `solution.R` for the full R calculation):

$$\boxed{\pi = (0.3,\; 0.4,\; 0.3)}$$

You can verify: $(0.3, 0.4, 0.3) \cdot \mathbf{P} = (0.3, 0.4, 0.3)$ ✓

---

### Stationary vs. limiting distribution — an important distinction

A **stationary distribution** is one where *if you start there, you stay there* (in distribution). It is defined by $\pi \mathbf{P} = \pi$.

A **limiting distribution** is the distribution the chain *converges to* as $n \to \infty$, regardless of starting state.

These are not always the same! A chain can have a stationary distribution but no limiting distribution (we will see an example in Lesson 3 — the alternating chain). However:

**Key theorem.** If a finite Markov chain is *irreducible* (all states communicate) and *aperiodic* (no periodic oscillations), the stationary and limiting distributions coincide. Every such chain has a unique stationary distribution, and $\pi(n) \to \pi$ from any starting distribution $\pi(0)$.

---

### The stable matrix

When $P^n$ converges, it converges to a matrix $\tilde{\pi}$ called the **stable matrix**, where every row is identical and equal to the stationary distribution:

$$\lim_{n \to \infty} \mathbf{P}^n = \tilde{\pi} = \begin{pmatrix} \pi_0 & \pi_1 & \cdots & \pi_{m-1} \\ \pi_0 & \pi_1 & \cdots & \pi_{m-1} \\ \vdots & \vdots & \ddots & \vdots \\ \pi_0 & \pi_1 & \cdots & \pi_{m-1} \end{pmatrix}$$

Here's the key insight: the rows all being identical means that after a long time, it does not matter where you started. The long-run fraction of time spent in state j is $\pi_j$, regardless of initial state.

---

## Example

### Computing the probability of being sick after 12 months

Using the 3-state health model from Lesson 1 (states: 0 = Healthy, 1 = Sick, 2 = Dead) with

$$\mathbf{P} = \begin{pmatrix} 0.7 & 0.2 & 0.1 \\ 0.1 & 0.5 & 0.4 \\ 0 & 0 & 1 \end{pmatrix}$$

Suppose a patient starts healthy (state 0). What is the probability they are sick (state 1) after 12 months?

We need $\left[\mathbf{P}^{12}\right]_{01}$ — the (0, 1) entry of $\mathbf{P}^{12}$.

In R: `P %^% 12` (using the `expm` package) gives us the matrix. Reading off the (row 1, column 2) entry (1-indexed) gives approximately 0.012.

Interpretation: a patient who starts healthy has only about a 1.2% chance of being alive and sick at month 12. Most paths have led to death by that point (the absorbing state absorbs them over time).

Notice: because state 2 (Dead) is absorbing, the chain does *not* have a proper limiting distribution in the sense of all states. The long-run probability of being in state 2 is 1. This is characteristic of chains with absorbing states.

---

## Task

Open `exercise.R`. You will define the 3×3 TPM from the worked example, compute matrix powers, find the stationary distribution by two methods (linear solve and eigenvalues), verify convergence, and plot the evolution of state probabilities from different starting distributions.

Run the check when done:

```
npm run check -- bdat-624 module-02 lesson-02
```

## Check

```
npm run check -- bdat-624 module-02 lesson-02
```

## Reflection

The stationary distribution satisfies $\pi \mathbf{P} = \pi$. A student says: "This means if I start in the stationary distribution, nothing changes — so the stationary distribution is boring and uninformative." Explain why this is wrong. What does the stationary distribution actually tell you about a chain's long-run behaviour? And why does the *starting* distribution become irrelevant after many steps (for a regular chain)?
