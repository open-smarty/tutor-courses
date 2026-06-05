# Lesson 2: Probability Distributions and Transition Probabilities

## Goal

Define joint distributions of stochastic processes, introduce one-step and n-step transition probabilities, construct the Transition Probability Matrix (TPM), and verify the two fundamental properties a TPM must satisfy.

## Concept

### Joint Distributions: The Full Probability Story

A stochastic process {X(t) : t ∈ T} is fully characterised by specifying the joint distribution of any finite collection of its values.

> **Notation block:**
> - t₁ < t₂ < ... < tₖ — a finite ordered sequence of time points from T
> - X(t₁), X(t₂), ..., X(tₖ) — the random variables at those times
> - P(X(t₁) = i₁, X(t₂) = i₂, ..., X(tₖ) = iₖ) — the joint probability that the process takes value i₁ at t₁, value i₂ at t₂, ..., and value iₖ at tₖ

For a discrete-state process, specifying these joint probabilities for *every* finite collection of times and *every* combination of states completely determines the stochastic process. In practice we work with simpler building blocks — conditional probabilities between successive time points.

### One-Step Transition Probability

For a discrete-time process with steps n = 0, 1, 2, ..., the **one-step transition probability** from state i to state j is:

> **Notation block:**
> - n — the current time step (non-negative integer)
> - i — the **current state**: X(n) = i; read "the process is in state i at step n"
> - j — the **next state**: X(n+1) = j; read "the process moves to state j at step n+1"
> - P(X(n+1) = j | X(n) = i) — the **conditional probability** of being in state j at step n+1, given that we are in state i at step n

This probability may in general depend on both i, j, and the current time n.

### Time-Homogeneity

A process is **time-homogeneous** (or **stationary**) if the one-step transition probability does not depend on the absolute time n — only on which states we are moving between.

> **Notation block:**
> - Pᵢⱼ — the time-homogeneous transition probability from state i to state j; read "P sub i j"
> - The subscripts i, j are the row and column indices respectively

Formally: the process is time-homogeneous if, for all n ≥ 0,
$$P(X(n+1) = j \mid X(n) = i) = P_{ij}$$
where Pᵢⱼ does not depend on n.

Here's the key insight: time-homogeneity means the rules of the game are the same at every step. A disease's probability of progressing from Mild to Severe does not depend on whether it is Monday or Friday — only on the current severity. This is a strong assumption worth checking in practice.

### The Transition Probability Matrix (TPM)

Collect all one-step transition probabilities into a single matrix P, where the entry in row i and column j is Pᵢⱼ.

> **Notation block:**
> - P — the **Transition Probability Matrix** (TPM); a square matrix with |S| rows and |S| columns
> - Pᵢⱼ — element in row i, column j; read "probability of transition from state i to state j"
> - Row i — gives the full probability distribution over next states, given you are currently in state i

For a state space S = {1, 2, 3} (three states), the TPM looks like:

$$P = \begin{pmatrix} P_{11} & P_{12} & P_{13} \\ P_{21} & P_{22} & P_{23} \\ P_{31} & P_{32} & P_{33} \end{pmatrix}$$

Row i lists the probabilities of moving from state i to each possible next state. This is the probability distribution "given you are in state i, where do you go next?"

### Two Essential Properties of a TPM

A matrix P is a valid TPM (called a **stochastic matrix**) if and only if it satisfies:

**Property 1 — Non-negativity:** Pᵢⱼ ≥ 0 for all i, j.

> A probability cannot be negative. Each entry is a probability of transitioning between two states.

**Property 2 — Row sums equal 1:** For every row i, Σⱼ Pᵢⱼ = 1.

> Starting from state i, the process must go *somewhere* in the next step — the probabilities over all possible destinations must sum to 1. This is the law of total probability.

If Pᵢᵢ > 0 for some i, the process can "stay" in state i (a self-loop). This is perfectly valid — a patient may remain Healthy from one week to the next.

### n-Step Transition Probabilities

What is the probability of moving from state i to state j in exactly n steps (not just one)?

> **Notation block:**
> - P⁽ⁿ⁾ᵢⱼ — the **n-step transition probability** from state i to state j; read "P superscript n, sub i j"
> - n — the number of steps taken; n ≥ 1

Here's the key insight: P⁽ⁿ⁾ = Pⁿ — the n-step TPM equals the n-th matrix power of the one-step TPM. We will prove this formally in Lesson 2 of Module 2 (the Chapman-Kolmogorov theorem). For now, treat it as a computational fact: to find the probability distribution n steps ahead, multiply P by itself n times.

**Computing P²:** The 2-step transition probability from i to j is:

> **Notation block:**
> - k — an intermediate state; the process passes through k at step 1 on its way from i (at step 0) to j (at step 2)
> - Σₖ — sum over all possible intermediate states k ∈ S

$$P^{(2)}_{ij} = \sum_{k \in S} P_{ik} \cdot P_{kj}$$

This is just standard matrix multiplication: P² = P × P. The entry (i,j) of P² sums over all one-step paths from i to k and then from k to j.

### Initial Distribution and State Probabilities

> **Notation block:**
> - π₀ — the **initial distribution** (row vector); π₀(i) = P(X(0) = i); read "pi sub zero of i"
> - πₙ — the distribution at step n (row vector); πₙ(j) = P(Xₙ = j)

The distribution at step n is obtained by multiplying the initial distribution by Pⁿ:

$$\pi_n = \pi_0 \cdot P^n$$

In matrix-vector form, this is a left multiplication. Each entry πₙ(j) gives the probability of being in state j at step n.

## Example

**Three-state SIR disease model on a discrete weekly schedule.**

Consider a population where individuals are classified each week as:
- State S (Susceptible): healthy but at risk
- State I (Infected): currently infected
- State R (Recovered): recovered and immune (for simplicity, permanently)

A public health team estimates the following weekly transition probabilities from surveillance data:

- From S: 90% stay Susceptible (S→S), 10% become Infected (S→I), 0% go to Recovered (S→R)
- From I: 0% go to Susceptible (I→S), 50% stay Infected (I→I), 50% Recover (I→R)
- From R: 0% become Susceptible again (R→S), 0% get Infected (R→I), 100% stay Recovered (R→R)

**Step 1: Construct the TPM.**

$$P = \begin{pmatrix} 0.90 & 0.10 & 0.00 \\ 0.00 & 0.50 & 0.50 \\ 0.00 & 0.00 & 1.00 \end{pmatrix}$$

Row labels: S, I, R (current state). Column labels: S, I, R (next state).

**Verify Property 1:** All entries are in [0,1]. ✓

**Verify Property 2:** Row sums: 0.90+0.10+0.00=1.00; 0.00+0.50+0.50=1.00; 0.00+0.00+1.00=1.00. ✓

Notice: R is an **absorbing state** — once recovered, the individual stays recovered forever (row R is (0, 0, 1)). Notice also that S→R directly is impossible (probability 0) — you must pass through I first.

**Step 2: Initial distribution.** Suppose at week 0, a new patient cohort has 80% Susceptible, 20% Infected, 0% Recovered.

$$\pi_0 = (0.80, \; 0.20, \; 0.00)$$

**Step 3: Distribution at week 2 using matrix multiplication.**

First compute P²: P × P

Row S of P² = (0.90, 0.10, 0.00) × P:
- P²(S,S) = 0.90×0.90 + 0.10×0.00 + 0.00×0.00 = 0.81
- P²(S,I) = 0.90×0.10 + 0.10×0.50 + 0.00×0.00 = 0.09 + 0.05 = 0.14  (Wait — let me redo: 0.90×0.10 + 0.10×0.50 + 0.00×0.00 = 0.090 + 0.050 = 0.140... but 0.81+0.14 = 0.95, need the rest)
- P²(S,R) = 0.90×0.00 + 0.10×0.50 + 0.00×1.00 = 0.05

Check: 0.81 + 0.14 + 0.05 = 1.00. ✓

Row I of P²:
- P²(I,S) = 0.00, P²(I,I) = 0.50×0.50 = 0.25, P²(I,R) = 0.50×0.50 + 0.50×1.00 = 0.25 + 0.50 = 0.75

Check: 0+0.25+0.75 = 1.00. ✓

Row R of P²: (0, 0, 1) (absorbing, unchanged).

$$P^2 = \begin{pmatrix} 0.81 & 0.14 & 0.05 \\ 0.00 & 0.25 & 0.75 \\ 0.00 & 0.00 & 1.00 \end{pmatrix}$$

**Distribution at week 2:**

$$\pi_2 = \pi_0 \cdot P^2 = (0.80, \, 0.20, \, 0.00) \cdot P^2$$

- P(S at week 2) = 0.80×0.81 + 0.20×0.00 + 0.00×0.00 = 0.648
- P(I at week 2) = 0.80×0.14 + 0.20×0.25 + 0.00×0.00 = 0.112 + 0.050 = 0.162  (Let me verify: 0.80×0.14=0.112, 0.20×0.25=0.050, sum=0.162)
- P(R at week 2) = 0.80×0.05 + 0.20×0.75 = 0.040 + 0.150 = 0.190

Check: 0.648 + 0.162 + 0.190 = 1.000. ✓

**Interpretation:** After 2 weeks, despite 20% starting infected, 64.8% of the cohort is still Susceptible, 16.2% are currently Infected, and 19.0% have Recovered. The epidemic is progressing — the Infected fraction has dropped (many recovered) but the Susceptible pool is depleting.

## Task

See `exercise.R`. You will construct a TPM for a 3-state disease model, verify row sums, compute P^5 using matrix multiplication, and compare the 5-step distribution to the 1-step distribution to observe how the cohort evolves.

## Check

```
npm run check -- bdat-624 module-01 lesson-02
```

## Reflection

In the SIR example, state R is absorbing: once you enter it, you stay forever. From a mathematical perspective, this makes R a **recurrent** state. But biologically, immunity can wane — some diseases (like influenza) allow recovered individuals to become susceptible again. How would you modify the TPM to allow for 5% of recovered individuals to lose immunity each week and return to Susceptible? What happens to the row sums when you make this change, and what does it imply about the long-run behaviour of the chain?
