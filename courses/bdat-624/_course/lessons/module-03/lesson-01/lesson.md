# Lesson 1: Branching Processes — Extinction and Population Growth

## Goal

By the end of this lesson you will be able to define the Galton-Watson branching process, derive the expected population size at any generation, characterise the three qualitatively different regimes (subcritical, critical, supercritical), and compute the probability of ultimate extinction as the fixed point of the probability generating function.

## Concept

### A biological question to anchor everything

A single virion enters a cell. Once inside, the cell either fails to produce any new virus particles — and the infection is cleared — or it bursts, releasing *r* new virions that each infect a fresh cell. Will the infection die out on its own, or will it spread through the organism indefinitely?

This is not just a biological question; it is a *mathematical* question about how populations behave when each individual independently produces a random number of offspring. The Galton-Watson branching process answers it precisely.

---

### Setting up the model

> **Notation:** X_n — the size of the n-th generation: the number of individuals alive at generation n. We always start with a single individual, so X_0 = 1.

> **Notation:** P_r = P(an individual has exactly r offspring), for r = 0, 1, 2, ... — the **offspring distribution**. These are non-negative probabilities that sum to 1: Σ_{r=0}^∞ P_r = 1.

> **Notation:** Z_i — the number of offspring produced by the i-th individual in generation n. All Z_i are independent and identically distributed (i.i.d.) with the offspring distribution {P_r}.

The branching process is built from one simple rule:

$$X_{n+1} = \sum_{i=1}^{X_n} Z_i$$

Read this as: "the size of the next generation equals the total offspring of everyone in the current generation." If X_n = 0 (the population is extinct), the sum is empty and X_{n+1} = 0 automatically — extinction is permanent.

**Why is this a Markov chain?** X_{n+1} depends on the current size X_n through the Z_i values, but once you know X_n, you don't need to know X_0, X_1, ..., X_{n-1}. The history is irrelevant. So:

$$P(X_{n+1} = j \mid X_n = i, X_{n-1}, \ldots, X_0) = P(X_{n+1} = j \mid X_n = i)$$

State 0 is an **absorbing state**: once the population hits zero, it stays at zero forever (P_{00} = 1). There is no resurrection.

---

### The probability generating function

Let's unpack this notation before we go further. A probability generating function (p.g.f.) encodes the entire offspring distribution in a single function of a dummy variable.

> **Notation:** f(z) = E(z^{X_1}) = Σ_{r=0}^∞ P_r · z^r — the **probability generating function** of X_1 (the first generation, starting from X_0 = 1). Here z is a real number in [0, 1] — it is the p.g.f. argument, not a random variable.

Three facts about f(z) to keep handy:

| Property | Meaning |
|---|---|
| f(0) = P_0 | probability the first individual has zero offspring (immediate extinction) |
| f(1) = 1 | all probabilities sum to 1 |
| f'(1) = E(X_1) = m | the mean number of offspring per individual |

The number m = f'(1) is called the **mean offspring** and controls the long-run fate of the population. It plays the role of R₀ in epidemiology.

---

### Deriving E(X_n) = m^n

Here's the key insight: the mean population size grows (or shrinks) geometrically with generation number. Let's derive this by induction.

**Base case:** E(X_0) = 1 = m^0. ✓

**Inductive step:** Assume E(X_n) = m^n. We compute E(X_{n+1}):

$$E(X_{n+1}) = E\!\left[\sum_{i=1}^{X_n} Z_i\right]$$

$$= E\!\left[E\!\left(\sum_{i=1}^{X_n} Z_i \;\Big|\; X_n\right)\right] \qquad \text{(by the law of total expectation)}$$

$$= E\!\left[X_n \cdot E(Z_i)\right] \qquad \text{(by independence of the } Z_i \text{ and linearity of expectation)}$$

$$= E(X_n) \cdot m \qquad \text{(since } E(Z_i) = m \text{ for all } i \text{)}$$

$$= m^n \cdot m = m^{n+1} \qquad \text{(by the inductive hypothesis)}$$

So **E(X_n) = m^n** for all n ≥ 0. ∎

---

### Variance of X_n

> **Notation:** σ² = Var(Z_r) — the variance of a single individual's offspring count.

The variance of X_n can be derived with a similar double-expectation argument. We state the result with annotations:

$$\text{Var}(X_n) = \begin{cases} \sigma^2 m^{n-1} \dfrac{1 - m^n}{1 - m} & \text{if } m \neq 1 \\ n \sigma^2 & \text{if } m = 1 \end{cases}$$

- For m < 1: Var(X_n) → 0 as n → ∞ (population is vanishing with certainty).
- For m = 1: Var grows linearly with n — the population wanders but stays near its mean in expectation, though it is actually absorbed at 0 eventually.
- For m > 1: Var(X_n) grows exponentially — massive spread around the growing mean.

---

### Three regimes — the critical trichotomy

Here's the key insight: whether the infection takes off or dies out is entirely determined by whether m is below, at, or above 1.

**Subcritical (m < 1):** E(X_n) = m^n → 0. The average population shrinks to zero. Extinction is certain with probability 1. *In epidemiology: R₀ < 1, the epidemic cannot sustain itself.*

**Critical (m = 1):** E(X_n) = 1 for all n — the expected size never changes. But the variance grows linearly. Despite the flat expected trajectory, the process is eventually absorbed at 0: extinction is still certain with probability 1. *This is deceptive — "average stable" does not mean "will survive."*

**Supercritical (m > 1):** E(X_n) = m^n → ∞. The population may explode. But here is the surprise: extinction is *still possible*, just not certain. There is a positive probability that early bad luck (many individuals having zero offspring) drives the process to 0 before it escapes. The exact extinction probability is computed via the p.g.f.

---

### The extinction probability q

> **Notation:** q = lim_{n→∞} P(X_n = 0 | X_0 = 1) — the **probability of ultimate extinction**: the probability that, starting from one individual, the population eventually reaches zero.

The key equation is elegant: q must satisfy

$$q = f(q)$$

That is, q is a **fixed point** of the p.g.f. f. Here is the theorem:

**Theorem (Extinction Criterion):**
- If m ≤ 1, then q = 1 (extinction is certain; q = 1 is the unique fixed point in [0,1]).
- If m > 1, then q < 1, and q is the **smallest non-negative** solution to q = f(q) in [0, 1). The other fixed point is q = 1, which we discard.

**Why does q = f(q) hold?** Condition on the first generation. If the original individual has r offspring (probability P_r), each of those r individuals independently starts its own process with extinction probability q. So:

$$q = \sum_{r=0}^{\infty} P_r \cdot q^r = f(q)$$

The function f is convex on [0,1], f(0) = P_0 ≥ 0, and f(1) = 1. When m = f'(1) > 1, the slope at z=1 exceeds 1, so f dips below the diagonal y = z in (0, 1), creating a crossing — a second fixed point q < 1.

---

### Worked example (Dr. Asiedu, p.28)

**Offspring distribution:** P_0 = 1/4, P_1 = 1/4, P_2 = 1/2, P_r = 0 for r ≥ 3.

**Step 1 — compute the mean:**

$$m = 0 \cdot \frac{1}{4} + 1 \cdot \frac{1}{4} + 2 \cdot \frac{1}{2} = 0 + \frac{1}{4} + 1 = \frac{5}{4} > 1$$

Since m > 1, extinction is possible but not certain.

**Step 2 — write the p.g.f.:**

$$f(z) = P_0 + P_1 z + P_2 z^2 = \frac{1}{4} + \frac{z}{4} + \frac{z^2}{2}$$

**Step 3 — solve f(q) = q:**

$$\frac{1}{4} + \frac{q}{4} + \frac{q^2}{2} = q$$

Multiply through by 4:

$$1 + q + 2q^2 = 4q \qquad \text{(multiply both sides by 4)}$$

$$2q^2 - 3q + 1 = 0 \qquad \text{(rearrange)}$$

$$(2q - 1)(q - 1) = 0 \qquad \text{(factorise)}$$

So q = 1/2 or q = 1.

**Step 4 — select the correct root:**

Since m > 1, we reject q = 1 and take the smaller root:

$$q = \frac{1}{2}$$

**Interpretation:** starting from a single virion with this offspring distribution, there is a 50% probability that the viral lineage eventually goes extinct and a 50% probability it persists indefinitely.

**Numerical iteration check:** starting from q_0 = 0 and iterating q_{n+1} = f(q_n):

- q_0 = 0
- q_1 = f(0) = 1/4 = 0.25
- q_2 = f(0.25) = 1/4 + 0.25/4 + 0.25²/2 = 0.25 + 0.0625 + 0.03125 = 0.34375
- q_3 = f(0.34375) ≈ 0.404
- ... converges to 0.5 ✓

---

## Example

### Viral outbreak in a patient cohort

Suppose we are modelling the early spread of a respiratory virus in a hospital. Each infected patient independently:
- Has zero secondary infections with probability P_0 = 0.3 (isolated quickly)
- Has exactly one secondary infection with probability P_1 = 0.2
- Has exactly two secondary infections with probability P_2 = 0.3
- Has exactly three secondary infections with probability P_3 = 0.2

**Mean offspring:** m = 0(0.3) + 1(0.2) + 2(0.3) + 3(0.2) = 0 + 0.2 + 0.6 + 0.6 = **1.4 > 1**.

**P.g.f.:** f(z) = 0.3 + 0.2z + 0.3z² + 0.2z³

**Is extinction certain?** No — m > 1 so there is a positive survival probability.

**Extinction probability:** solve f(q) = q numerically. Starting from q_0 = 0:

```
q1 = 0.3 + 0.2(0) + 0.3(0)^2 + 0.2(0)^3 = 0.30
q2 = 0.3 + 0.2(0.3) + 0.3(0.09) + 0.2(0.027) = 0.3 + 0.06 + 0.027 + 0.0054 = 0.3924
q3 = f(0.3924) ≈ 0.4527
...
q∞ ≈ 0.658
```

So if a single case is introduced, there is roughly a **65.8% chance the outbreak dies out on its own**, but a **34.2% chance** it establishes a sustained chain of transmission.

This is the kind of calculation public health officials make when evaluating whether an index case can seed an epidemic.

---

## Task

Open `exercise.R`. You will simulate Galton-Watson branching processes under subcritical and supercritical offspring distributions, compute the extinction probability numerically via fixed-point iteration, and compare theoretical moments (mean and variance) against simulated values across generations.

Run:

```
npm run check -- bdat-624 module-03 lesson-01
```

## Check

```
npm run check -- bdat-624 module-03 lesson-01
```

## Reflection

Consider two viruses with the same mean offspring m = 1.5, but different variances: Virus A has σ² = 0.5 (low variance, consistent spreader) and Virus B has σ² = 3.0 (high variance, mostly infects few but occasionally causes a super-spreader event). Both have the same E(X_n) = 1.5^n. But do they have the same extinction probability? Why or why not? What does the shape of f(z) tell you about how variance affects survival?
