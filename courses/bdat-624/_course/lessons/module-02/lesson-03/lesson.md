# Lesson 3: State Classification — Recurrence, Transience, and Ergodicity

## Goal

By the end of this lesson you will be able to classify every state in a Markov chain as accessible, communicating, periodic, or aperiodic; determine whether a chain is irreducible and/or regular; and distinguish recurrent, null-recurrent, and transient states — culminating in the definition of ergodicity and its convergence guarantee.

## Concept

### Motivation: not all chains converge

In Lesson 2 we found that some chains converge to a stationary distribution. But not all chains do. Some oscillate forever. Some states are visited only finitely many times before the chain moves on permanently. Others are visited infinitely often.

Here's the key insight: understanding *why* a chain converges (or fails to) requires classifying each state individually. The vocabulary we build in this lesson — accessibility, communication, periodicity, recurrence — is the toolkit for that diagnosis.

---

### Accessibility and communication

> **Notation:** *i → j* (read: "state j is accessible from state i") — there exists n > 0 such that $P_{ij}^{(n)} > 0$. You can eventually reach j if you start at i, in some finite number of steps.

> **Notation:** *i ↔ j* (read: "states i and j communicate") — both $i \to j$ AND $j \to i$. Each state can reach the other.

Note the direction matters. $i \to j$ does not imply $j \to i$. For example, in the health model from Lesson 1, state 0 (Healthy) can reach state 2 (Dead) — but not the reverse.

**Communication is an equivalence relation:**

- *Reflexive:* $i \leftrightarrow i$ (trivially, since $P_{ii}^{(0)} = 1$)
- *Symmetric:* if $i \leftrightarrow j$ then $j \leftrightarrow i$
- *Transitive:* if $i \leftrightarrow j$ and $j \leftrightarrow k$ then $i \leftrightarrow k$

Because it is an equivalence relation, communication partitions the state space into **equivalence classes** (sometimes called communication classes). States in the same class all communicate with each other; states in different classes do not communicate in both directions.

---

### Irreducibility

**Definition.** A Markov chain is called **irreducible** if all states form a single equivalence class — that is, every state can reach every other state.

In the 3-state health model, states {0, 1} communicate (0 → 1 → 0 is possible via $P_{10} = 0.1 > 0$), but state 2 (Dead) is absorbing: you can reach it from 0 and 1, but you cannot escape. So {0, 1} and {2} are different equivalence classes, and the chain is **not** irreducible.

Biological meaning: a chain is irreducible if "from any health state, it is theoretically possible to reach any other health state." In many disease models, this is not true (death is irreversible), so we work with non-irreducible chains and focus our analysis on the transient states.

---

### Periodicity

> **Notation:** *d(i)* — the **period** of state i, defined as the greatest common divisor (gcd) of all return times: $d(i) = \gcd\{n \geq 1 : P_{ii}^{(n)} > 0\}$. If no return is possible, d(i) = 0 by convention.

Let's unpack this notation before we go further. $P_{ii}^{(n)} > 0$ means the process *can* return to state i after exactly n steps. The period d(i) is the gcd of all such n — intuitively, it is the "rhythm" of the chain's returns to state i.

- **Aperiodic state:** $d(i) = 1$. The process can return at irregular times — no fixed rhythm.
- **Periodic state:** $d(i) = d > 1$. Returns are only possible at multiples of d.

**Key theorem.** If $i \leftrightarrow j$ (states communicate), then $d(i) = d(j)$. Communicating states share the same period.

This means periodicity is a property of *communication classes*, not individual states. All states in an irreducible chain have the same period.

---

### The alternating chain: a chain with no limiting distribution

Consider the 2-state chain (from Dr. Asiedu's notes, p. 13–14):

$$\mathbf{P} = \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$$

This chain alternates: from state 0 you go to state 1, from state 1 you go to state 0. No staying.

Check the period:
- From state 0, you can return after $n = 2, 4, 6, \ldots$ steps. So $d(0) = \gcd\{2, 4, 6, \ldots\} = 2$.
- By the theorem, $d(1) = 2$ as well.

Both states have period 2. Powers of **P** alternate:

$$\mathbf{P}^2 = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix} = \mathbf{I}, \quad \mathbf{P}^3 = \mathbf{P}, \quad \mathbf{P}^4 = \mathbf{I}, \quad \ldots$$

So $\mathbf{P}^n$ alternates between $\mathbf{I}$ and $\mathbf{P}$ for even/odd n — it never converges.

Yet this chain *does* have a stationary distribution: $\pi = (1/2, 1/2)$. You can verify $\pi \mathbf{P} = (1/2, 1/2) = \pi$.

This is the key example showing that **stationary distribution ≠ limiting distribution**. The chain has a well-defined stationary distribution, but because it is periodic (d = 2), $P^n$ does not converge.

---

### Regularity

**Definition.** A stochastic matrix **P** is **regular** if there exists $n \geq 1$ such that all entries of $\mathbf{P}^n$ are strictly positive.

Equivalently, a finite chain is regular if and only if it is **irreducible** (all states communicate) and **aperiodic** (all states have period 1).

**Key theorem (convergence for regular chains).** If **P** is a regular TPM for a finite, time-homogeneous chain, then:

$$\lim_{n \to \infty} \mathbf{P}^n = \tilde{\pi}$$

where $\tilde{\pi}$ is a matrix with every row equal to $(\pi_1, \pi_2, \ldots, \pi_m)$, and $\pi_j > 0$ for all j, $\sum_j \pi_j = 1$.

The alternating chain fails regularity because $P^n$ alternates and never has all strictly positive entries simultaneously.

---

### Recurrence and transience

Let's unpack this notation before we go further.

> **Notation:** *f_{ij}^{(n)}* — the **first passage time probability**: $f_{ij}^{(n)} = P(X_n = j,\; X_r \neq j \text{ for } r = 1, \ldots, n-1 \mid X_0 = i)$. The probability of visiting state j for the *first time* at exactly step n, starting from state i.

> **Notation:** *f_{ii}^{(*)}* — the **total first return probability** to state i: $f_{ii}^{(*)} = \sum_{n=1}^{\infty} f_{ii}^{(n)}$. This is the probability of ever returning to state i, starting from i.

> **Notation:** *μᵢ* — the **mean recurrence time** (expected return time): $\mu_i = \sum_{n=1}^{\infty} n \cdot f_{ii}^{(n)}$. The expected number of steps to return to state i, starting from i.

Using these, we classify states into three types:

| Type | Condition | Meaning |
|---|---|---|
| **Transient** | $f_{ii}^{(*)} < 1$ | Starting from i, there is positive probability of never returning |
| **Null recurrent** | $f_{ii}^{(*)} = 1$ and $\mu_i = \infty$ | Certain to return, but expected return time is infinite |
| **Positive recurrent** | $f_{ii}^{(*)} = 1$ and $\mu_i < \infty$ | Certain to return, and expected return time is finite |

Here's the key insight: **recurrent** states ($f_{ii}^{(*)} = 1$) are visited infinitely often (almost surely) in the long run. **Transient** states are eventually abandoned — the chain visits them finitely many times and moves on.

**Important fact for finite chains.** In any *finite* irreducible Markov chain, all states are **positive recurrent**. Null recurrence and transience only arise for infinite-state-space chains (like simple random walk on all integers).

---

### Ergodicity

**Definition.** A Markov chain is called **ergodic** if it is:

1. **Irreducible** — all states communicate
2. **Positive recurrent** — every state has finite mean recurrence time
3. **Aperiodic** — every state has period 1

Ergodic chains have the strongest convergence guarantee:

**Ergodic theorem.** An ergodic chain has a *unique* stationary distribution π, and for any starting state i and any state j:

$$\lim_{n \to \infty} P_{ij}^{(n)} = \pi_j > 0$$

Moreover, the long-run proportion of time the chain spends in state j equals $\pi_j$, regardless of starting state.

For finite chains, ergodic = irreducible + aperiodic (positive recurrence is automatic in finite irreducible chains).

---

### Summary: the classification hierarchy

```
Markov chain
├── Irreducible?
│   ├── No  → multiple communication classes
│   │         (some states may be transient or absorbing)
│   └── Yes → all states share the same period d
│             ├── d > 1 (periodic): stationary dist. exists,
│             │          but no limiting dist.
│             └── d = 1 (aperiodic): regular chain
│                        → ERGODIC → unique stationary = limiting dist.
└── (Finite chains: if irreducible, all states are positive recurrent)
```

---

## Example

### Classifying the 3×3 chain from Lesson 2

$$\mathbf{P} = \begin{pmatrix} 0 & 2/3 & 1/3 \\ 3/8 & 1/8 & 1/2 \\ 1/2 & 1/2 & 0 \end{pmatrix}$$

**Step 1: irreducibility.** Can every state reach every other?
- $0 \to 1$: $P_{01} = 2/3 > 0$ ✓
- $1 \to 0$: $P_{10} = 3/8 > 0$ ✓
- $0 \to 2$: $P_{02} = 1/3 > 0$ ✓
- $2 \to 0$: $P_{20} = 1/2 > 0$ ✓

All pairs communicate. The chain is **irreducible**.

**Step 2: periodicity.** State 0 has $P_{00} = 0$, $P_{00}^{(2)} > 0$ (e.g. path 0→1→0). But also path 0→2→0 in 2 steps, and 0→1→0→... in 3 steps. So return times include 2 and 3. $\gcd(2, 3) = 1$. State 0 is **aperiodic** ($d = 1$).

**Conclusion.** Irreducible + aperiodic = **ergodic**. The unique stationary distribution is $\pi = (0.3, 0.4, 0.3)$ from Lesson 2, and $\mathbf{P}^n \to \tilde{\pi}$.

---

## Task

Open `exercise.R`. You will use the `markovchain` package to test irreducibility and compute periods, observe the non-convergence of the alternating chain, and simulate a random walk with reflecting boundaries to compare empirical visit frequencies with the theoretical stationary distribution.

Run the check when done:

```
npm run check -- bdat-624 module-02 lesson-03
```

## Check

```
npm run check -- bdat-624 module-02 lesson-03
```

## Reflection

The ergodic theorem says the long-run proportion of time in state j equals $\pi_j$. A researcher uses this to estimate transition probabilities from a long observed trajectory of a single patient's disease states. What assumption about the patient's disease process does this require? Is it plausible for a chronic disease like diabetes or HIV? What would violate the time-homogeneity assumption, and how might you detect the violation in the data?
