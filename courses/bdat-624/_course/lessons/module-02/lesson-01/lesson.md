# Lesson 1: The Markov Property and Transition Matrices

## Goal

By the end of this lesson you will be able to state the Markov property precisely, construct a transition probability matrix (TPM) from verbal descriptions of a biological system, verify that it is a stochastic matrix, and identify absorbing states.

## Concept

### Motivation: does history matter?

Imagine a patient whose disease status is recorded every month. At each observation they are classified as:

- **State 0:** Healthy
- **State 1:** Mildly ill
- **State 2:** Severely ill
- **State 3:** Deceased

To forecast next month's status, do we need the patient's full medical history — every state they passed through — or is knowing their status *right now* enough?

Here's the key insight: a Markov chain is a process where the future depends only on the present, not on how you got here. Knowing that a patient is currently "Severely ill" tells you everything there is to know about their future — it does not matter whether they were healthy last month or have been sick for years.

That is not just a convenient modelling assumption. For many biological processes it is a reasonable approximation of reality, and it has enormous mathematical consequences: it lets us summarise an entire process with a single matrix.

---

### The Markov property — formal statement

Let's unpack this notation before we go further.

> **Notation:** *{X(t), t ∈ T}* — a stochastic process. X(t) is the state at time t. When time is discrete we write *X_n* for the state at step n. T is the parameter space (time index set).

**Continuous-time version.** For a process with continuous time t:

$$P[X(t) \leq x \mid X(t_n) = x_n,\; X(t_{n-1}) = x_{n-1},\; \ldots,\; X(t_0) = x_0]
= P[X(t) \leq x \mid X(t_n) = x_n]$$

**Discrete-time version.** For a discrete-time chain the condition simplifies nicely:

$$P[X_n = j \mid X_{n-1} = i_1,\; X_{n-2} = i_2,\; \ldots,\; X_0 = i_0]
= P[X_n = j \mid X_{n-1} = i_1]$$

In words: knowing the entire past $(i_0, i_1, \ldots, i_{n-1})$ adds nothing over knowing just the most recent state $i_1$. Everything about the future is encoded in where you are *now*.

> **Notation:** *P[X_n = j | X_{n-1} = i]* — the **one-step transition probability** from state i to state j. This is the probability that, if you are currently in state i, you will be in state j at the very next time step.

---

### The transition probability matrix (TPM)

Let's unpack this notation before we go further.

> **Notation:** *P_{ij}* — the entry in row i, column j of the TPM **P**. It equals P[X_{n+1} = j | X_n = i]. The subscripts always follow the convention: *i = current state (row), j = next state (column)*.

The TPM **P** collects all one-step transition probabilities into a single matrix. If the state space has m states, **P** is an m × m matrix:

$$\mathbf{P} = \begin{pmatrix} P_{00} & P_{01} & \cdots & P_{0,m-1} \\ P_{10} & P_{11} & \cdots & P_{1,m-1} \\ \vdots & \vdots & \ddots & \vdots \\ P_{m-1,0} & P_{m-1,1} & \cdots & P_{m-1,m-1} \end{pmatrix}$$

**Two properties every TPM must satisfy** (it is called a *stochastic matrix*):

1. All entries are non-negative: $P_{ij} \geq 0$ for all i, j.
2. Each row sums to 1: $\sum_{j} P_{ij} = 1$ for every row i.

The second property follows directly from probability: given you are in state i right now, you *must* be in *some* state next step. So the probabilities of all possible destinations sum to 1.

**A simple 2-state example.** Let the states be {0, 1}. The most general 2×2 stochastic matrix has just two free parameters:

$$\mathbf{P} = \begin{pmatrix} 1-a & a \\ b & 1-b \end{pmatrix}$$

where $0 \leq a \leq 1$ and $0 \leq b \leq 1$.

- $a = P_{01}$: the probability of *switching* from state 0 to state 1 in one step.
- $b = P_{10}$: the probability of *switching* from state 1 to state 0 in one step.
- The diagonal entries $1-a$ and $1-b$ are the probabilities of *staying* in the current state.

---

### Time-homogeneity

Most of this course assumes a **time-homogeneous** chain:

> **Notation:** *P_{ij}^{(t)} = P_{ij} for all t ∈ T* — the transition probabilities do not depend on *when* you make the transition. The superscript (t) is dropped because the matrix is the same at every time step.

Biologically, this means the switching rates between states are constant over time. A disease model might be time-homogeneous over a short period (say, a single treatment phase) but not over years if the patient ages.

---

### Worked example: a 3-state health model

Consider a model with three states:

- **0 = Healthy**
- **1 = Sick**
- **2 = Dead** *(an absorbing state)*

The TPM is:

$$\mathbf{P} = \begin{pmatrix} 0.7 & 0.2 & 0.1 \\ 0.1 & 0.5 & 0.4 \\ 0 & 0 & 1 \end{pmatrix}$$

Let's verify it's a stochastic matrix:

- Row 0: $0.7 + 0.2 + 0.1 = 1.0$ ✓
- Row 1: $0.1 + 0.5 + 0.4 = 1.0$ ✓
- Row 2: $0 + 0 + 1 = 1.0$ ✓

Now let's interpret each entry:

| Entry | Value | Meaning |
|---|---|---|
| $P_{00} = 0.7$ | 70% | A healthy person stays healthy next month |
| $P_{01} = 0.2$ | 20% | A healthy person becomes sick next month |
| $P_{02} = 0.1$ | 10% | A healthy person dies next month (sudden death) |
| $P_{10} = 0.1$ | 10% | A sick person recovers to healthy |
| $P_{11} = 0.5$ | 50% | A sick person stays sick |
| $P_{12} = 0.4$ | 40% | A sick person dies next month |
| $P_{20} = 0$ | 0% | A dead person cannot become healthy |
| $P_{21} = 0$ | 0% | A dead person cannot become sick |
| $P_{22} = 1$ | 100% | A dead person stays dead |

---

### Absorbing states

Here's the key insight: **state 2 (Dead)** is special. Once you enter it, you never leave. This is called an **absorbing state**.

> **Notation:** *State i is absorbing* if $P_{ii} = 1$, equivalently $P_{ij} = 0$ for all $j \neq i$. The entire row of state i in the TPM is zero except the diagonal entry, which equals 1.

Biological examples of absorbing states:

- **Death** (as above) — once dead, always dead.
- **Complete remission** in some cancer models, if relapse is defined as impossible after a certain duration.
- **Fixation** in population genetics — once an allele fixes at frequency 1 (or 0), drift cannot change it.

In the TPM, absorbing states are easy to spot: their row is all zeros except a single 1 on the diagonal.

---

## Example

### Reading a TPM from a diagram

Suppose a diagram shows three states {A, B, C} with arrows labelled by probabilities:

- From A: 60% stay A, 30% go to B, 10% go to C
- From B: 20% go to A, 50% stay B, 30% go to C
- From C: 0% anywhere except C (100% stay C)

The TPM is:

$$\mathbf{P} = \begin{pmatrix} 0.6 & 0.3 & 0.1 \\ 0.2 & 0.5 & 0.3 \\ 0 & 0 & 1 \end{pmatrix}$$

Row sums: all equal 1. State C is absorbing.

Notice the *asymmetry*: $P_{AB} = 0.3$ does not have to equal $P_{BA} = 0.2$. Each row must sum to 1, but there is no constraint relating rows to each other.

---

## Task

Open `exercise.R`. You will use the `markovchain` package to build the 3-state health model, visualise its transition diagram, compute multi-step probabilities by matrix exponentiation, and simulate patient trajectories.

Run the check when done:

```
npm run check -- bdat-624 module-02 lesson-01
```

## Check

```
npm run check -- bdat-624 module-02 lesson-01
```

## Reflection

A colleague proposes a 3-state disease model where the TPM has $P_{02} = 0$ (healthy patients cannot die suddenly — they must pass through the sick state first). Is this a restriction on the *mathematics* or on the *biology*? Could you have a mathematically valid stochastic matrix with this constraint? What biological evidence would you need to justify or reject it for a specific disease?
