# Lesson 1: The Pure Birth Process — Yule Model

## Goal

Derive the Yule (pure birth) process by solving its ODE system with an integrating factor, find the probability distribution Pₙ(t), compute the mean and variance of the population, and simulate bacterial growth.

## Concept

### Motivation: Population Growth in Continuous Time

In a bacterial culture, each cell divides independently: it does not wait for its neighbours, and it does not die (in this idealised model). Division happens at random times — not at fixed clock intervals. How do we model this in continuous time?

The **Yule process** (also called the pure birth process) is the continuous-time analogue of the geometric distribution. It starts with one individual, and each individual gives birth at rate λ (independently). As the population grows, so does the total birth rate — because there are more individuals producing offspring.

This is the simplest continuous-time Markov chain with a countably infinite state space S = {0, 1, 2, 3, ...}.

### Model Definition

> **Notation block:**
> - N(t) — population size at time t; a continuous-time process taking values in {1, 2, 3, ...}
> - λ — **individual birth rate**: each individual gives birth at rate λ per unit time; read "lambda"
> - λₙ = nλ — **state-dependent birth rate**: when there are n individuals, the total rate of a new birth is nλ (each of n individuals contributes λ); read "lambda sub n"
> - Pₙ(t) = P(N(t) = n) — probability of having exactly n individuals at time t; read "P sub n of t"

**The Yule assumption:** When the population is of size n, a new birth occurs at instantaneous rate nλ. No deaths occur.

### The ODE System

Using the same "short interval" argument as for the Poisson process:

For n ≥ 2, in a small time interval [t, t+Δt]:
- P(N(t+Δt) = n) = P(N(t) = n) × P(no birth in [t,t+Δt] | n individuals) + P(N(t) = n-1) × P(one birth in [t,t+Δt] | n-1 individuals)

> **Notation block:**
> - o(Δt) — terms negligible compared to Δt (probability of 2+ births in a tiny interval)
> - e^{-nλΔt} ≈ 1 - nλΔt for small Δt (probability of no birth given n individuals present)

The ODE system (taking Δt → 0) is:

$$\frac{dP_n(t)}{dt} = -n\lambda P_n(t) + (n-1)\lambda P_{n-1}(t), \quad n \geq 2$$

$$\frac{dP_1(t)}{dt} = -\lambda P_1(t)$$

with initial condition P₁(0) = 1 (we start with exactly 1 individual) and Pₙ(0) = 0 for n ≥ 2.

### Solving P₁(t)

The equation for n=1 is:

$$P_1'(t) = -\lambda P_1(t), \quad P_1(0) = 1$$

This is identical to the P₀ equation in the Poisson derivation. The solution is:

$$P_1(t) = e^{-\lambda t}$$

Interpretation: the probability of still having only 1 individual at time t is e^{-λt} — the first birth hasn't happened yet.

### Solving for General Pₙ(t) by Integrating Factor

We use induction. Suppose we have already solved for Pₙ₋₁(t). The ODE for Pₙ is:

$$\frac{dP_n}{dt} + n\lambda P_n = (n-1)\lambda P_{n-1}(t)$$

> **Notation block:**
> - Integrating factor — a function μ(t) = e^{nλt} that, when multiplied to both sides of the ODE, converts the left side into a perfect derivative d/dt[μ(t)Pₙ(t)]

**Step 1: Multiply both sides by e^{nλt}:**

$$e^{n\lambda t} \frac{dP_n}{dt} + n\lambda e^{n\lambda t} P_n = (n-1)\lambda e^{n\lambda t} P_{n-1}(t)$$

**Step 2: Recognise the left side as a perfect derivative:**

$$\frac{d}{dt}\!\left[e^{n\lambda t} P_n(t)\right] = (n-1)\lambda e^{n\lambda t} P_{n-1}(t)$$

**Step 3: Substitute Pₙ₋₁(t) using the inductive hypothesis.**

We claim (and verify by induction) that:

$$P_{n-1}(t) = e^{-\lambda t}(1 - e^{-\lambda t})^{n-2}, \quad n \geq 2$$

> **Notation:** (1 - e^{-λt})^{n-2} — a power of (1 - e^{-λt}); this factor represents the probability that at least n-1 births have occurred given the geometric structure of the Yule process.

Substituting:

$$\frac{d}{dt}\!\left[e^{n\lambda t} P_n(t)\right] = (n-1)\lambda e^{n\lambda t} \cdot e^{-\lambda t}(1 - e^{-\lambda t})^{n-2} = (n-1)\lambda e^{(n-1)\lambda t}(1-e^{-\lambda t})^{n-2}$$

**Step 4: Integrate.** Let u = 1 - e^{-λt}, so du = λe^{-λt}dt, and e^{(n-1)λt} = (1-u)^{-(n-1)} e^{λt}... 

Let's use a direct substitution. Write e^{(n-1)λt}(1-e^{-λt})^{n-2} = (e^{λt} - 1)^{n-2}. Let v = e^{λt} - 1, dv = λe^{λt}dt.

Actually the clearest route: integrate by recognising that:

$$\frac{d}{dt}(1 - e^{-\lambda t})^{n-1} = (n-1)(1-e^{-\lambda t})^{n-2} \cdot \lambda e^{-\lambda t}$$

So:

$$\int (n-1)\lambda e^{(n-1)\lambda t}(1-e^{-\lambda t})^{n-2} \, dt = e^{n\lambda t}(1-e^{-\lambda t})^{n-1} + C$$

(This can be verified by differentiating the right side: d/dt[e^{nλt}(1-e^{-λt})^{n-1}] = nλe^{nλt}(1-e^{-λt})^{n-1} + e^{nλt}(n-1)(1-e^{-λt})^{n-2}λe^{-λt}.)

**Step 5: Apply initial condition.** At t=0, e^{nλ·0}Pₙ(0) = 0. The constant C = 0 (since (1-e⁰)^{n-1} = 0).

Therefore:

$$e^{n\lambda t} P_n(t) = e^{n\lambda t}(1 - e^{-\lambda t})^{n-1}$$

$$\boxed{P_n(t) = e^{-\lambda t}(1 - e^{-\lambda t})^{n-1}, \quad n = 1, 2, 3, \ldots} \quad \blacksquare$$

Here's the key insight: this is a **Geometric distribution** with success probability p = e^{-λt}. Setting p(t) = e^{-λt}, we have:

$$P_n(t) = p(t) \cdot (1 - p(t))^{n-1}$$

which is exactly the Geometric(p(t)) PMF for n ≥ 1. As t increases, p(t) = e^{-λt} decreases toward 0, meaning the population is increasingly likely to be large.

### Mean and Variance

For a Geometric(p) distribution on {1, 2, 3, ...}:
- Mean: 1/p
- Variance: (1-p)/p²

With p(t) = e^{-λt}:

$$\mathrm{E}[N(t)] = e^{\lambda t}$$

$$\mathrm{Var}[N(t)] = e^{\lambda t}(e^{\lambda t} - 1)$$

> **Notation block:**
> - E[N(t)] = e^{λt} — exponential growth of the expected population; the mean doubles every ln(2)/λ time units
> - Var[N(t)] = e^{λt}(e^{λt}-1) — variance grows as e^{2λt} for large t; the population is highly variable

The variance grows faster than the mean (it grows as e^{2λt} while the mean grows as e^{λt}). This captures the fact that Yule processes are "bursty" — sometimes they explode, sometimes they die out early.

### Simulating the Yule Process (Gillespie Algorithm)

Rather than drawing from the distribution directly, we can simulate the process step by step:

1. **Start** with n = 1 individual at t = 0.
2. **Wait time:** When in state n, the time until the next birth is Exponential(nλ) (since nλ is the total rate).
3. **Birth event:** Add 1 to the population: n → n+1.
4. **Repeat** until time T is exceeded.

This is the **Gillespie algorithm** (or kinetic Monte Carlo), widely used in systems biology.

## Example

**Bacterial cell division.**

Parameters: λ = 0.3/hour (each cell divides at rate 0.3 per hour), starting with n₀ = 1 cell.

At t = 2 hours:
- p(2) = e^{-0.3×2} = e^{-0.6} ≈ 0.5488
- E[N(2)] = e^{0.6} ≈ 1.822 cells (expected population is 1.82)
- P(N(2) = 1) = 0.5488 (still only 1 cell — first division hasn't happened)
- P(N(2) = 2) = 0.5488 × 0.4512 ≈ 0.2477
- P(N(2) = 3) = 0.5488 × 0.4512² ≈ 0.1117
- Var[N(2)] = e^{0.6}(e^{0.6}-1) ≈ 1.822 × 0.822 ≈ 1.497

At t = 10 hours: E[N(10)] = e^{3} ≈ 20.1. Starting from 1 cell, we expect about 20 cells after 10 hours.

## Task

See `exercise.R`. You will simulate the Yule process using a Gillespie algorithm for λ = 0.3/hour, compare the simulated population distribution to the theoretical Geometric(e^{-λt}), and plot mean population growth against the theoretical e^{λt} curve.

## Check

```
npm run check -- bdat-624 module-04 lesson-01
```

## Reflection

The Yule process assumes each individual gives birth at the same rate λ — independent of population density. In biology, this is rarely true: cells compete for nutrients, viral particles face a limited number of susceptible cells, and bacterial populations experience crowding. The **logistic growth model** adds a carrying capacity K by making the net birth rate depend on n: effective rate = λn(1 - n/K). How would you modify the Yule ODE to include carrying capacity? Can the resulting system still be solved analytically? What happens to the stationary distribution when n > K?
