# Lesson 2: The Pure Death Process

## Goal

Derive the pure death process distribution by solving its ODE system, recognise that N(t) follows a Binomial distribution, compute mean and variance, and apply the model to chemotherapy-induced cell death.

## Concept

### Motivation: Population Decline

In the Yule process (Lesson 1), populations only grew — each individual gave birth and no one died. The **pure death process** is the mirror image: individuals die (or leave, or deactivate) and no new individuals are born. This is the model for:
- Cells dying under chemotherapy
- Virions being cleared by the immune system
- Radioactive atoms decaying
- Patients recovering from a ward (being discharged)

### Model Definition

> **Notation block:**
> - N(t) — population size at time t; starts at N(0) = N₀ > 0
> - N₀ — the **initial population size** (given, fixed at time 0); read "N sub zero"
> - μ — **individual death rate**: each individual dies (independently) at rate μ per unit time; read "mu"
> - μₙ = nμ — **state-dependent death rate**: when n individuals are alive, the total death rate is nμ; read "mu sub n"
> - Pₙ(t) = P(N(t) = n) — probability of n individuals surviving at time t; n ∈ {0, 1, ..., N₀}

The state space is now **finite**: S = {0, 1, ..., N₀}. Once N(t) = 0 (all individuals dead), the process is absorbed.

### The ODE System

Using the same short-interval argument:

$$\frac{dP_n(t)}{dt} = -(n\mu) P_n(t) + (n+1)\mu P_{n+1}(t), \quad n = 0, 1, \ldots, N_0 - 1$$

$$\frac{dP_{N_0}(t)}{dt} = -N_0 \mu \, P_{N_0}(t)$$

Initial condition: P_{N₀}(0) = 1 (all N₀ individuals alive at time 0), Pₙ(0) = 0 for n < N₀.

Note the direction: the "source" term (n+1)μ P_{n+1}(t) comes from the state above (n+1 individuals) — one death takes us from n+1 to n. The "sink" term -nμ P_n(t) represents the rate of leaving state n (by one death taking us to n-1).

### The Solution: Binomial Distribution

Rather than solving the ODE directly (which becomes algebraically intensive for large N₀), we use a probabilistic argument:

**Key insight:** Each of the N₀ individuals alive at time 0 survives independently to time t with probability e^{-μt} (the individual's survival time is Exp(μ), so P(survival > t) = e^{-μt}).

> **Notation block:**
> - p(t) = e^{-μt} — probability that one individual survives from time 0 to time t; read "p of t"
> - 1 - p(t) = 1 - e^{-μt} — probability that one individual has died by time t; read "one minus p of t"

Since each individual's fate is independent:

$$N(t) = \text{Binomial}(N_0, \, p(t)) = \text{Binomial}(N_0, \, e^{-\mu t})$$

The PMF is:

$$P_n(t) = \binom{N_0}{n} \left(e^{-\mu t}\right)^n \left(1 - e^{-\mu t}\right)^{N_0 - n}, \quad n = 0, 1, \ldots, N_0$$

> **Notation block:**
> - C(N₀, n) = N₀!/(n!(N₀-n)!) — the **binomial coefficient**; number of ways to choose which n individuals survive; read "N₀ choose n"

**Derivation of the Binomial result.** We verify this satisfies the ODE:

Differentiate P_n(t) with respect to t, treating p = e^{-μt} as the dynamic quantity (dp/dt = -μe^{-μt} = -μp):

$$\frac{d}{dt} P_n = \binom{N_0}{n} \frac{d}{dt}\!\left[p^n (1-p)^{N_0-n}\right]$$

$$= \binom{N_0}{n} \left[n p^{n-1}(1-p)^{N_0-n} + p^n(N_0-n)(1-p)^{N_0-n-1}(-1)\right] \dot{p}$$

With dp/dt = -μp:

$$= \binom{N_0}{n} (-\mu p) \left[n p^{n-1}(1-p)^{N_0-n} - p^n(N_0-n)(1-p)^{N_0-n-1}\right]$$

$$= -\mu \left[n \binom{N_0}{n} p^n(1-p)^{N_0-n} - (N_0-n)\binom{N_0}{n}p^{n+1}(1-p)^{N_0-n-1}\right]$$

Using the identity (N₀-n)C(N₀,n) = (n+1)C(N₀,n+1):

$$= -n\mu P_n(t) + (n+1)\mu P_{n+1}(t) \quad \checkmark$$

This matches the ODE exactly. ∎

### Mean and Variance

For a Binomial(N₀, p) distribution:
- Mean: N₀p
- Variance: N₀p(1-p)

Substituting p = e^{-μt}:

$$\mathrm{E}[N(t)] = N_0 e^{-\mu t}$$

$$\mathrm{Var}[N(t)] = N_0 e^{-\mu t}(1 - e^{-\mu t})$$

The mean decays exponentially (exponential die-off), reaching 0 as t → ∞. The variance is maximised at t = ln(2)/μ (when p = 1/2, i.e., half the population has died), then decreases back to 0.

### Contrast with the Birth Process

| | Pure Birth (Yule) | Pure Death |
|---|---|---|
| Distribution | Geometric(e^{-λt}) | Binomial(N₀, e^{-μt}) |
| Mean | e^{λt} | N₀e^{-μt} |
| State space | {1,2,3,...} | {0,1,...,N₀} |
| Long-run | E[N(t)] → ∞ | E[N(t)] → 0 |

### Extinction Time

The time until total extinction (N(t) = 0) is T_ext = max(T₁, T₂, ..., T_{N₀}) where Tᵢ ~ Exp(μ) are the individual lifetimes.

> **Notation block:**
> - T_ext — extinction time; the time when the last individual dies; read "T extinction"
> - max(T₁,...,T_{N₀}) — the maximum of N₀ i.i.d. exponential variables (the last to die)

The CDF of T_ext:

$$P(T_{\text{ext}} \leq t) = P(\text{all } N_0 \text{ individuals dead by } t) = P_0(t) = (1 - e^{-\mu t})^{N_0}$$

The expected extinction time is:

$$E[T_{\text{ext}}] = \frac{1}{\mu} \sum_{k=1}^{N_0} \frac{1}{k} = \frac{1}{\mu} H_{N_0}$$

where H_{N₀} = 1 + 1/2 + 1/3 + ... + 1/N₀ is the N₀-th **harmonic number**.

> **Notation block:**
> - H_{N₀} — the N₀-th harmonic number; H_{N₀} ≈ ln(N₀) + 0.577 for large N₀

This result makes intuitive sense: the last survivor hangs on much longer than you'd expect from the individual death rate alone. With N₀ = 100 cells and μ = 0.5/day, E[T_ext] = (1/0.5)×H₁₀₀ ≈ 2×5.19 ≈ 10.4 days — but an individual cell's expected lifetime is only 1/μ = 2 days.

## Example

**Chemotherapy cell kill model.**

A tumour has N₀ = 1000 cancer cells. Chemotherapy induces cell death at rate μ = 0.5 per cell per day (individual death rate).

At day 3 (t=3):
- p(3) = e^{-0.5×3} = e^{-1.5} ≈ 0.2231
- E[N(3)] = 1000 × 0.2231 ≈ 223 cells surviving
- Var[N(3)] = 1000 × 0.2231 × 0.7769 ≈ 173.3
- SD[N(3)] ≈ 13.2 cells

The 95% interval for N(3) is approximately 223 ± 2×13.2 = (197, 249) cells.

At day 7 (t=7):
- p(7) = e^{-3.5} ≈ 0.0302
- E[N(7)] = 1000 × 0.0302 ≈ 30 cells
- P(extinct by day 7) = P₀(7) = (1-0.0302)^{1000} ≈ e^{-30.2} — very small!

At day 14 (t=14):
- p(14) = e^{-7} ≈ 0.000912
- E[N(14)] ≈ 0.912 cells
- P(extinct) = (1-0.000912)^{1000} ≈ e^{-0.912} ≈ 0.402 — about 40% chance all cells dead

Expected extinction time: (1/0.5)×H₁₀₀₀ ≈ 2×7.49 ≈ 14.98 days. So after about 15 days of treatment, we expect all cancer cells to be dead on average.

## Task

See `exercise.R`. You will implement the pure death process simulation (Gillespie), compare the simulated distribution to Binomial(N₀, e^{-μt}), plot the decline in mean population, and estimate the extinction time distribution.

## Check

```
npm run check -- bdat-624 module-04 lesson-02
```

## Reflection

The pure death process models each individual's fate as independent. In chemotherapy, cells are NOT killed independently: drug concentration affects all cells simultaneously, drug-resistant cells have lower death rates, and cells can undergo apoptosis in cascades triggered by neighbours. How does positive correlation between individual fates (cells dying together) change the variance of N(t) compared to the Binomial model? Would correlated deaths make extinction faster or slower (on average) than the independent model? Think about this in terms of "clumped" versus "spread out" deaths.
