# Lesson 2: Chapman-Kolmogorov Equations and Stationary Distributions

## Goal

Prove the Chapman-Kolmogorov equations step by step, use them to compute n-step transition probabilities via matrix powers, derive the stationary distribution, and find it numerically for a biological chain.

## Concept

### Setting the Stage

In Lesson 1 we established that the n-step transition probability P⁽ⁿ⁾ᵢⱼ tells us the probability of moving from state i to state j in exactly n steps. A natural question: can we build P⁽ᵐ⁺ⁿ⁾ from P⁽ᵐ⁾ and P⁽ⁿ⁾ without computing the full matrix power directly? Yes — this is the Chapman-Kolmogorov equation.

> **Notation block:**
> - P⁽ⁿ⁾ᵢⱼ — n-step transition probability from state i to j; read "P superscript n, subscript i j"
> - P⁽ᵐ⁺ⁿ⁾ᵢⱼ — (m+n)-step transition probability from state i to j
> - Σₖ — sum over all states k in the state space S; k is the "relay" state at the intermediate time m
> - [P^m × P^n]ᵢⱼ — entry (i,j) of the matrix product P^m times P^n

### Theorem: Chapman-Kolmogorov Equations

**Statement.** For any m, n ≥ 0 and all states i, j ∈ S:

$$P^{(m+n)}_{ij} = \sum_{k \in S} P^{(m)}_{ik} \cdot P^{(n)}_{kj}$$

Equivalently, in matrix form: P⁽ᵐ⁺ⁿ⁾ = P^m × P^n (matrix multiplication).

**Proof (annotated step by step).**

**Step 1. Expand the definition.**

> **Notation:** P(X_{m+n} = j | X_0 = i) — the probability of being in state j at time m+n, given the process starts in state i at time 0.

$$P^{(m+n)}_{ij} = P(X_{m+n} = j \mid X_0 = i)$$

This is simply the definition of the (m+n)-step transition probability.

**Step 2. Condition on the intermediate state at time m.**

We use the **law of total probability**: partition the event {X_{m+n} = j} according to which state the process is in at the intermediate time m.

> **Notation:** k — a generic state in S; we sum over all possible values of Xₘ.

$$P(X_{m+n} = j \mid X_0 = i) = \sum_{k \in S} P(X_{m+n} = j, \; X_m = k \mid X_0 = i)$$

Here we've split the single event into cases: the process is in some state k at time m, and then reaches j by time m+n.

**Step 3. Factorise using conditional probability.**

For each term in the sum, apply the definition of conditional probability:

$$P(X_{m+n} = j, \; X_m = k \mid X_0 = i) = P(X_{m+n} = j \mid X_m = k, \; X_0 = i) \cdot P(X_m = k \mid X_0 = i)$$

This is the chain rule of probability: P(A,B|C) = P(A|B,C)·P(B|C).

**Step 4. Apply the Markov property to the first factor.**

> **Notation:** X_0 = i is the "old history" that becomes irrelevant once we know X_m = k. The Markov property says: given the present (X_m = k), the past (X_0 = i) is irrelevant for the future.

$$P(X_{m+n} = j \mid X_m = k, \; X_0 = i) = P(X_{m+n} = j \mid X_m = k)$$

The condition X_0 = i drops out completely — this is precisely the Markov property in action.

**Step 5. Apply time-homogeneity.**

Because the chain is time-homogeneous, the n-step transition probability from k to j does not depend on the starting time m:

$$P(X_{m+n} = j \mid X_m = k) = P(X_n = j \mid X_0 = k) = P^{(n)}_{kj}$$

> **Notation:** P⁽ⁿ⁾ₖⱼ — the n-step probability from k to j, starting from time 0 (time-homogeneity lets us shift the origin to 0).

**Step 6. Identify the second factor.**

$$P(X_m = k \mid X_0 = i) = P^{(m)}_{ik}$$

This is simply the m-step probability from i to k.

**Step 7. Assemble the result.**

Substituting Steps 4–6 back into the sum from Step 2:

$$P^{(m+n)}_{ij} = \sum_{k \in S} P^{(m)}_{ik} \cdot P^{(n)}_{kj}$$

But this is exactly the definition of matrix multiplication! The (i,j) entry of the product P^m × P^n is Σₖ [P^m]ᵢₖ × [P^n]ₖⱼ. Therefore:

$$P^{(m+n)} = P^m \times P^n \quad \blacksquare$$

Here's the key insight: the Chapman-Kolmogorov equations say that "going m+n steps is the same as going m steps, then going n steps — regardless of how we split the journey." This lets us compute any P^n by repeated squaring, which is computationally efficient. It also means P⁽ⁿ⁾ = Pⁿ (n-th matrix power of the one-step TPM).

### Corollary: P^n by Induction

Setting m=1 and applying C-K repeatedly: P^(1+1) = P^1 × P^1 = P², P^(2+1) = P² × P = P³, ..., by induction P^n = Pⁿ for all n ≥ 1. The n-step TPM is the n-th matrix power of the one-step TPM.

### Stationary Distribution

As we compute Pⁿ for larger and larger n, something remarkable happens: the rows often converge to a common vector π = (π₁, π₂, ..., π|S|), independent of the starting state i. This vector π is called the **stationary distribution** (or **invariant distribution** or **equilibrium distribution**).

> **Notation block:**
> - π — the stationary distribution; a row vector with |S| entries; read "pi"
> - πⱼ — the j-th entry of π; the long-run probability of being in state j; read "pi sub j"
> - πP — matrix-vector multiplication: a row vector π multiplied on the right by the TPM P; the result is a new row vector

**Definition.** A probability row vector π = (π₁, ..., π|S|) is a **stationary distribution** for the Markov chain with TPM P if:

$$\pi P = \pi \quad \text{with} \quad \sum_{j \in S} \pi_j = 1 \quad \text{and} \quad \pi_j \geq 0 \; \forall j$$

**Interpretation.** If the chain starts in distribution π₀ = π, then after one step the distribution is still π. The chain is in equilibrium — applying P doesn't change the distribution. π gives the **long-run fraction of time** spent in each state.

Let's unpack this notation: "πP = π" means that if you take the row vector π and multiply it by the matrix P (on the right), you get π back. It is analogous to an eigenvector equation: π is a left eigenvector of P with eigenvalue 1.

### How to Find the Stationary Distribution

**Method.** The equation πP = π can be rewritten as:

$$\pi (P - I) = 0$$

where I is the identity matrix. This is a homogeneous linear system. Combined with the normalisation constraint Σⱼ πⱼ = 1, we get a uniquely solvable system (for irreducible, aperiodic chains).

**Practical approach in R:**
1. Form the matrix (P - I)
2. Add the constraint row [1, 1, 1, ..., 1] = 1 (or equivalently, solve the augmented system)
3. Solve for π using `solve()` or by finding the left null vector of (P - I)

Alternatively, compute Pⁿ for large n and read off any row (they converge to π).

### Ergodic Theorem

> **Notation block:**
> - T_i(n) — number of visits to state i in n steps; T_i(n)/n — long-run fraction of time in state i
> - E[return time to i] — expected number of steps to first return to state i, starting from i

**Ergodic theorem.** For an **ergodic** (irreducible + aperiodic + positive recurrent) Markov chain:

$$\pi_i = \frac{1}{E[\text{return time to state } i]}$$

The stationary probability of state i equals the reciprocal of the mean return time to i. Intuitively: if you return to state i on average every 10 steps, you're "in state i" about 1/10 of the time in the long run.

## Example

**Stationary distribution of a 3-state health chain.**

Consider the chain with states {Healthy (H), Sick (S), Recovered (R)} and TPM:

$$P = \begin{pmatrix} 0.85 & 0.15 & 0.00 \\ 0.10 & 0.40 & 0.50 \\ 0.30 & 0.00 & 0.70 \end{pmatrix}$$

**Step 1: Write out the system πP = π.**

> **Notation:** π = (π_H, π_S, π_R); each equation comes from one column of πP = π.

Column H: 0.85π_H + 0.10π_S + 0.30π_R = π_H → -0.15π_H + 0.10π_S + 0.30π_R = 0

Column S: 0.15π_H + 0.40π_S + 0.00π_R = π_S → 0.15π_H - 0.60π_S + 0.00π_R = 0

Column R: 0.00π_H + 0.50π_S + 0.70π_R = π_R → 0.00π_H + 0.50π_S - 0.30π_R = 0

Normalisation: π_H + π_S + π_R = 1

**Step 2: Solve the system.** From equation (3): 0.50π_S = 0.30π_R → π_R = (5/3)π_S.

From equation (2): 0.15π_H = 0.60π_S → π_H = 4π_S.

Normalisation: 4π_S + π_S + (5/3)π_S = 1 → π_S(4 + 1 + 5/3) = 1 → π_S(12/3 + 3/3 + 5/3) = 1 → π_S(20/3) = 1 → π_S = 3/20 = 0.15.

Then π_H = 4 × 0.15 = 0.60, π_R = (5/3) × 0.15 = 0.25.

**Step 3: Verify.** π_H + π_S + π_R = 0.60 + 0.15 + 0.25 = 1.00. ✓

Check πP row: 0.60×0.85 + 0.15×0.10 + 0.25×0.30 = 0.510 + 0.015 + 0.075 = 0.600 = π_H. ✓

**Interpretation:** In the long run, a patient following this chain spends 60% of their time Healthy, 15% Sick, and 25% Recovered. These are the long-run population fractions. The average return time to Healthy is 1/0.60 ≈ 1.67 weeks.

## Task

See `exercise.R`. You will compute P¹, P⁵, P⁵⁰ for a 3-state health chain, observe convergence to π, and verify the stationary distribution by solving the linear system πP = π.

## Check

```
npm run check -- bdat-624 module-02 lesson-02
```

## Reflection

The Chapman-Kolmogorov equations assume time-homogeneity — the same TPM applies at every step. In a longitudinal clinical study, is this realistic? Consider a patient's probability of moving from Mild to Severe illness: might this depend on the time of year (flu season), the patient's age as the study progresses, or treatment protocols that change over the study period? Design a simple extension of the framework — a **time-inhomogeneous Markov chain** — where the TPM changes over time: Pₙ ≠ Pₘ for n ≠ m. In this case, is P^n still valid? What replaces it?
