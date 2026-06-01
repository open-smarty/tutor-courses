# Lesson 2: The Pure Death Process

## Goal

By the end of this lesson you will be able to write and solve the Kolmogorov equations for the pure death process, identify the binomial distribution as the exact solution, compute the mean and variance of the surviving population, and interpret the half-life of a decaying population in terms of the death rate μ.

## Concept

### Motivation

A radioactive nucleus decays; a colony of bacteria is dosed with a lethal antibiotic; a cohort of patients on a toxic treatment experiences increasing mortality. In each case the population can only *decrease*. No new individuals are added. This is the **pure death process** — the mirror image of the Yule model from Lesson 1.

---

### Notation and setup

> **Notation:** X(t) — population size at time t. Here X(t) ∈ {0, 1, ..., j} because the population can only shrink.

> **Notation:** X(0) = j — initial population (all j individuals are alive at t = 0).

> **Notation:** μₙ — the death rate when the population is n. For the **simple pure death process**: μₙ = nμ (each individual dies independently at rate μ).

> **Notation:** μ — the per-individual death rate (units: time⁻¹).

> **Notation:** State 0 is the **absorbing state** — once every individual has died, the process stays at 0 forever.

> **Notation:** P_n(t) = P(X(t) = n) — probability of exactly n survivors at time t.

---

### The differential equations

Consider what can happen in (t, t + Δt]:

- The process is in state n at t+Δt if it was in state n (no death in the interval), OR it was in state n+1 (exactly one death moved it to n).

Writing this out and taking the limit Δt → 0:

$$P_n'(t) = \mu_{n+1}P_{n+1}(t) - \mu_n P_n(t) \tag{7.1}$$

For the simple pure death process (μₙ = nμ):

$$P_n'(t) = (n+1)\mu P_{n+1}(t) - n\mu P_n(t) \tag{7.2}$$

---

### Solving the ODEs — integrating factor method

**Initial conditions:** P_j(0) = 1, P_n(0) = 0 for n ≠ j.

---

**Step 1: Solve for P_j(t).**

When n = j, equation (7.2) reduces to:

$$P_j'(t) = -j\mu P_j(t)$$

(The inflow term (j+1)μP_{j+1}(0) = 0 because the process starts at j and cannot be in state j+1.)

Separate variables and integrate, then apply P_j(0) = 1:

$$\ln P_j(t) = -j\mu t \implies \boxed{P_j(t) = e^{-j\mu t} = (e^{-\mu t})^j} \tag{7.3}$$

---

**Step 2: Solve for P_{j-1}(t).**

Set n = j−1 in equation (7.2):

$$P_{j-1}'(t) = j\mu P_j(t) - (j-1)\mu P_{j-1}(t)$$

Substitute P_j(t) = e^{−jμt} and rearrange to standard linear form:

$$P_{j-1}'(t) + \mu(j-1)P_{j-1}(t) = j\mu e^{-j\mu t}$$

Use **integrating factor** I(t) = e^{μ(j-1)t}. Multiply both sides:

$$\frac{d}{dt}\Bigl[e^{\mu(j-1)t} P_{j-1}(t)\Bigr] = j\mu e^{-\mu t}$$

Integrate both sides:

$$e^{\mu(j-1)t} P_{j-1}(t) = -je^{-\mu t} + C$$

Apply P_{j-1}(0) = 0: 0 = −j + C, so C = j.

Therefore:

$$e^{\mu(j-1)t} P_{j-1}(t) = j\bigl(1 - e^{-\mu t}\bigr)$$

$$\boxed{P_{j-1}(t) = je^{-\mu(j-1)t}\bigl(1 - e^{-\mu t}\bigr)} \tag{7.4}$$

---

### The general result — binomial distribution

Continuing the induction, for n = 0, 1, ..., j:

$$\boxed{P_n(t) = \binom{j}{n}\bigl(e^{-\mu t}\bigr)^n\bigl(1 - e^{-\mu t}\bigr)^{j-n}} \tag{7.5}$$

Here's the key insight: this is the **Binomial(j, e^{−μt})** distribution. The interpretation is beautifully transparent:

- Each of the j initial individuals survives to time t independently, with probability e^{−μt} (the survival function of an Exponential(μ) lifetime).
- The number of survivors X(t) is the count of "successes" in j independent Bernoulli(e^{−μt}) trials.

The binomial structure emerges directly from the independence assumption built into μₙ = nμ.

---

### Mean and variance

From the Binomial(j, p) moments with p = e^{−μt}:

$$E[X(t) \mid X(0) = j] = jp = je^{-\mu t} \tag{7.6}$$

$$\operatorname{Var}[X(t) \mid X(0) = j] = jp(1-p) = je^{-\mu t}(1 - e^{-\mu t}) \tag{7.7}$$

The **half-life** — the time at which the expected population is half its initial value — is:

$$t_{1/2} = \frac{\ln 2}{\mu}$$

(found by setting je^{−μt} = j/2 and solving for t.)

---

### Comparison with the pure birth process

| Feature | Pure Birth (Yule) | Pure Death |
|---|---|---|
| Direction | Population grows only | Population shrinks only |
| Rate | λₙ = nλ | μₙ = nμ |
| Solution distribution | Negative Binomial(j, e^{−λt}) | Binomial(j, e^{−μt}) |
| E[X(t)] | je^{λt} → ∞ | je^{−μt} → 0 |
| Absorbing state | None | State 0 (extinction) |
| Variance | je^{λt}(e^{λt}−1) | je^{−μt}(1−e^{−μt}) |

Here's the key insight: the roles of λ and μ are symmetric. Replacing λ with −μ in the birth-process solution, or equivalently reflecting the time axis, transforms one into the other. The negative binomial and binomial distributions are the natural pair for exponential growth and exponential decay.

---

## Example

### Antibiotic treatment of a bacterial culture

A flask contains j = 100 bacteria. An antibiotic is added that kills each bacterium independently at rate μ = 0.2 per hour (pure death process).

**Expected survivors at t = 4 hours:**
$$E[X(4)] = 100 \cdot e^{-0.2 \times 4} = 100e^{-0.8} \approx 44.9 \text{ bacteria}$$

**Variance at t = 4:**
$$\operatorname{Var}[X(4)] = 100 \cdot e^{-0.8}(1 - e^{-0.8}) \approx 44.9 \times 0.551 \approx 24.7$$

**Half-life:**
$$t_{1/2} = \frac{\ln 2}{0.2} = \frac{0.693}{0.2} \approx 3.47 \text{ hours}$$

**Probability all bacteria are dead by t = 10:**
$$P(X(10) = 0) = (1 - e^{-0.2 \times 10})^{100} = (1 - e^{-2})^{100} \approx (0.865)^{100} \approx 5.0 \times 10^{-7}$$

(Extinction is very unlikely at t = 10, even though E[X(10)] ≈ 13.5, because the variance is large enough that many trajectories are near zero but not all.)

---

## Task

Open `exercise.R`. You will:

1. Simulate 200 pure death process trajectories (j = 50, μ = 0.1) from t = 0 to t = 30.
2. Plot all trajectories with the theoretical mean E[X(t)] = 50e^{−0.1t} overlaid.
3. At t = 10, compare the empirical distribution of X(10) to the Binomial(50, e^{−1}) PMF.
4. Estimate the half-life from simulations and compare to ln(2)/μ analytically.
5. Plot the distribution of extinction times for μ = 0.1, 0.2, 0.5.

Fill in every `# TODO:` marker and run the check:

```
npm run check -- bdat-624 module-04 lesson-02
```

## Check

```
npm run check -- bdat-624 module-04 lesson-02
```

## Reflection

In the pure death process with μₙ = nμ, every individual dies independently at the same rate μ. In a real biological system — say, a bacterial population exposed to an antibiotic — the killing rate may depend on the concentration of the drug, which itself decreases as bacteria absorb it. How would you modify μₙ to capture this "resource depletion" effect? Write down a modified death rate function and describe qualitatively how the surviving fraction would differ from the simple binomial result.
