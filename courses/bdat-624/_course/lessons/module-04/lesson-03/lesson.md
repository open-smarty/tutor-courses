# Lesson 3: Birth-Death Process — Linear Growth and Extinction

## Goal

By the end of this lesson you will be able to write the Kolmogorov equations for the linear birth-death process, derive the mean population E[X(t)] = ie^{(λ−μ)t}, compute the probability of ultimate extinction for both sub- and super-critical processes, state the effect of immigration, and use simulation to verify theoretical extinction probabilities.

## Concept

### Motivation

Births and deaths rarely occur in isolation. A viral population in the bloodstream is produced by infected cells (births) and simultaneously cleared by the immune system (deaths). A rumour spreads through a network (births) and is forgotten (deaths). The **birth-death process** combines both mechanisms and asks: what wins — growth or decay? And even when growth dominates on average, can the population still go extinct by bad luck?

---

### Notation and setup

> **Notation:** λₙ — birth rate when population is n. For the linear process: λₙ = nλ.

> **Notation:** μₙ — death rate when population is n. For the linear process: μₙ = nμ.

> **Notation:** State 0 is the **absorbing state**: λ₀ = μ₀ = 0. Once the population reaches 0, it stays there.

> **Notation:** i = X(0) — the initial population size.

> **Notation:** ρ = μ/λ — the **death-to-birth ratio**. This single number determines the long-run fate of the process.

---

### The four postulates

These are the infinitesimal assumptions that define the birth-death process:

1. P(one birth in (t, t+Δt] | X(t)=n) = λₙΔt + o(Δt)
2. P(one death in (t, t+Δt] | X(t)=n) = μₙΔt + o(Δt)
3. P(no change in (t, t+Δt] | X(t)=n) = 1 − λₙΔt − μₙΔt + o(Δt)
4. Births and deaths in (t, t+Δt] are conditionally independent given X(t)

---

### The Kolmogorov forward equations

Applying the same infinitesimal argument as in Lessons 1 and 2, but now with both births and deaths:

$$P_n'(t) = -({\lambda_n + \mu_n})P_n(t) + \lambda_{n-1}P_{n-1}(t) + \mu_{n+1}P_{n+1}(t) \tag{8.1}$$

For the linear process (λₙ = nλ, μₙ = nμ):

$$P_n'(t) = -n(\lambda + \mu)P_n(t) + (n-1)\lambda P_{n-1}(t) + (n+1)\mu P_{n+1}(t) \tag{8.2}$$

(For n = 1, the term μ₁P₁(t) = μP₁(t) flows down to state 0. For n = 0, only the inflow μP₁(t) matters since state 0 is absorbing.)

---

### The mean — deriving E[X(t)]

> **Notation:** m(t) = E[X(t) | X(0) = i] — the mean population at time t.

We derive the ODE for m(t) by computing d/dt Σ n P_n(t):

$$m'(t) = \sum_{n=0}^{\infty} n P_n'(t)$$

Substituting (8.2) and rearranging (each sum telescopes — students may verify this as an exercise):

$$m'(t) = (\lambda - \mu) m(t)$$

This is a simple first-order linear ODE with solution:

$$\boxed{m(t) = E[X(t) \mid X(0) = i] = ie^{(\lambda - \mu)t}} \tag{8.3}$$

Here's the key insight: the **intrinsic growth rate** is (λ − μ). Three regimes:

- If **λ > μ** (supercritical): m(t) → ∞ exponentially. On average the population grows without bound.
- If **λ = μ** (critical): m(t) = i. The expected population is constant — but this does not mean the process is stable. Randomness still drives it toward 0.
- If **λ < μ** (subcritical): m(t) → 0 exponentially. The average population declines.

Note: the mean alone does not tell the full story. Even in the supercritical case, *individual realisations* can still go extinct.

---

### Extinction probability

One of the most important results in the theory of birth-death processes concerns the **probability of ultimate extinction** — the probability that the population eventually reaches 0.

Let q_i = P(eventual extinction | X(0) = i).

By the independent branching structure of the linear birth-death process (each individual in the initial population contributes an independent sub-process):

$$q_i = q_1^i$$

so it suffices to find q_1.

Solving the generating function equation for q_1 yields:

$$q_1 = \begin{cases} 1 & \text{if } \lambda \leq \mu \\ \mu/\lambda & \text{if } \lambda > \mu \end{cases}$$

Therefore:

$$\boxed{q_i = \begin{cases} 1 & \text{if } \lambda \leq \mu \\ (\mu/\lambda)^i & \text{if } \lambda > \mu \end{cases}} \tag{8.4}$$

Using our notation ρ = μ/λ:

- If ρ ≥ 1 (subcritical or critical): extinction is **certain**.
- If ρ < 1 (supercritical): extinction probability is ρⁱ, which is less than 1 but positive.

Here's the key insight: even when births dominate deaths (λ > μ), a small initial population can still go extinct by bad luck. With i = 1, the extinction probability is μ/λ — the ratio of the death rate to the birth rate. Starting with more individuals (larger i) reduces the extinction probability multiplicatively: with i = 10 and ρ = 0.6, the probability is (0.6)^{10} ≈ 0.006.

---

### The critical case (λ = μ) — a subtle warning

When λ = μ, the expected population stays at i forever. Yet the extinction probability is 1 — the process *will* eventually go extinct with probability 1. This seems paradoxical.

The resolution: the distribution of X(t) becomes highly skewed as t increases. Most realisations go to 0, but the few that survive grow very large — and those rare survivors dominate the mean. The mean is not a reliable summary of a critical birth-death process.

---

### Linear birth-death with immigration

Add a constant immigration rate ε > 0, so that λₙ = nλ + ε for all n ≥ 0. The key changes are:

- State 0 is no longer absorbing: immigrants arrive at rate ε even when n = 0.
- Extinction probability = 0 for any ε > 0.

The mean becomes:

$$E[X(t) \mid X(0) = i] = \begin{cases} \dfrac{\varepsilon}{\lambda - \mu}\bigl(e^{(\lambda-\mu)t} - 1\bigr) + ie^{(\lambda-\mu)t} & \text{if } \lambda \neq \mu \\[6pt] \varepsilon t + i & \text{if } \lambda = \mu \end{cases} \tag{8.5}$$

When λ < μ (subcritical with immigration), the process reaches a **stationary distribution** — it fluctuates around a positive mean rather than going extinct. Immigration rescues the population.

---

## Example

### HIV infection dynamics

An HIV infection begins with i = 3 infected cells. Each infected cell produces new virions (modelled as births) at rate λ = 1.5 per day, and each infected cell is destroyed by the immune response (deaths) at rate μ = 1.0 per day.

**Intrinsic growth rate:** λ − μ = 0.5 per day.

**Expected infected cells at day 5:**
$$E[X(5)] = 3 e^{0.5 \times 5} = 3e^{2.5} \approx 36.4 \text{ cells}$$

**Extinction probability:**
$$q_3 = (\mu/\lambda)^3 = (1.0/1.5)^3 = (2/3)^3 \approx 0.296$$

So about 30% of infections starting with 3 cells go extinct naturally (immune system wins the early battle). The remaining 70% grow on average.

**Effect of antiretroviral treatment** doubling the death rate to μ = 3.0 per day (with λ = 1.5 unchanged):
$$\rho = 3.0/1.5 = 2 > 1$$

The process becomes subcritical. Extinction is now certain with probability 1. Treatment tips the balance from supercritical to subcritical, guaranteeing eventual viral clearance.

---

## Task

Open `exercise.R`. You will:

1. Simulate 300 supercritical birth-death trajectories (X(0)=5, λ=0.4, μ=0.3) and plot with theoretical mean.
2. Simulate 300 critical trajectories (λ=μ=0.3) and measure the fraction going extinct by t=30.
3. Simulate 300 subcritical trajectories (λ=0.3, μ=0.4) and measure the fraction going extinct.
4. Verify the theoretical extinction probability (μ/λ)^5 = (0.75)^5 for the supercritical case.
5. Add immigration (ε=0.5) to the subcritical case and show extinction becomes rare.

Fill in every `# TODO:` marker and run the check:

```
npm run check -- bdat-624 module-04 lesson-03
```

## Check

```
npm run check -- bdat-624 module-04 lesson-03
```

## Reflection

In the critical birth-death process (λ = μ), every individual realisation eventually goes extinct (probability 1), yet the expected population remains constant at i for all time. How can both statements be true simultaneously? Think about what the distribution of X(t) looks like as t → ∞ — specifically, does the distribution become more concentrated around its mean, or more spread out? How does this connect to the concept of a "heavy-tailed" distribution?
