# Lesson 1: The Pure Birth Process — Yule Model

## Goal

By the end of this lesson you will be able to write down the differential equations for the Yule process, solve them step-by-step using the integrating factor method, recognise the negative binomial distribution as the exact solution, and compute the mean and variance of population size at any time t.

## Concept

### Why the Poisson process is not enough

In the Poisson process, events arrive at a constant rate λ regardless of how many have already arrived. But consider a bacterial colony: the more bacteria present, the more divisions happen per unit time. The rate of new arrivals depends on the current state. This is the key departure that motivates the **Yule process** — a continuous-time birth process where the birth rate grows with population size.

---

### Notation and setup

> **Notation:** X(t) — the population size at time t. We always write X(t) ∈ {j, j+1, j+2, ...} because only births occur (no deaths, no immigration).

> **Notation:** X(0) = j — the initial population. In most problems j = 1 (a single founding individual), but the theory holds for any positive integer j.

> **Notation:** λₙ — the birth rate when the current population size is n. This is the instantaneous rate at which the next birth occurs given that there are currently n individuals.

> **Notation:** P_n(t) = P(X(t) = n) — the probability that the population equals exactly n at time t.

> **Notation:** "Pure birth" — births only; no deaths. The population can never decrease.

---

### The Yule process: λₙ = nλ

In the **Yule process** (also called the linear pure birth process), each individual reproduces independently at rate λ. When there are n individuals, the total birth rate is:

$$\lambda_n = n\lambda$$

This is the defining property of the Yule process: the aggregate rate is proportional to the current population size.

---

### Setting up the differential equations

Consider what happens in a short interval (t, t + Δt]. The population can be in state n at time t + Δt in exactly two ways:

1. It was in state n at time t, and no birth occurred in (t, t+Δt].
2. It was in state n−1 at time t, and exactly one birth occurred in (t, t+Δt].

Writing these probabilities out (using the definition of λₙ for infinitesimal intervals):

$$P_n(t + \Delta t) = P_n(t)\bigl[1 - \lambda_n \Delta t + o(\Delta t)\bigr] + P_{n-1}(t)\bigl[\lambda_{n-1}\Delta t + o(\Delta t)\bigr]$$

Rearranging, dividing by Δt, and taking the limit Δt → 0:

$$P_n'(t) = \lambda_{n-1}P_{n-1}(t) - \lambda_n P_n(t) \tag{6.1}$$

This is the **Kolmogorov forward equation** for the pure birth process.

For the Yule process (λₙ = nλ), equation (6.1) becomes:

$$P_n'(t) = (n-1)\lambda P_{n-1}(t) - n\lambda P_n(t) \tag{6.2}$$

---

### Solving the ODEs — integrating factor method

**Initial conditions:** the process starts at population j, so:

$$P_j(0) = 1, \qquad P_n(0) = 0 \text{ for } n \neq j$$

---

**Step 1: Solve for P_j(t).**

When n = j, equation (6.2) reduces to:

$$P_j'(t) = -j\lambda P_j(t)$$

(The P_{j-1}(t) term vanishes because starting at j, we cannot reach state j−1 in a pure birth process.)

Separate variables:

$$\frac{P_j'(t)}{P_j(t)} = -j\lambda$$

Integrate both sides with respect to t:

$$\ln P_j(t) = -j\lambda t + C$$

Apply the initial condition P_j(0) = 1, so ln(1) = 0 = C. Therefore:

$$\boxed{P_j(t) = e^{-j\lambda t}} \tag{6.3}$$

---

**Step 2: Solve for P_{j+1}(t).**

Set n = j+1 in equation (6.2):

$$P_{j+1}'(t) = j\lambda P_j(t) - (j+1)\lambda P_{j+1}(t)$$

Substituting P_j(t) = e^{-jλt} and rearranging to standard linear form:

$$P_{j+1}'(t) + \lambda(j+1)P_{j+1}(t) = j\lambda e^{-j\lambda t} \tag{linear first-order ODE}$$

Use the **integrating factor** I(t) = e^{λ(j+1)t}. Multiply both sides by I(t):

$$e^{\lambda(j+1)t}P_{j+1}'(t) + \lambda(j+1)e^{\lambda(j+1)t}P_{j+1}(t) = j\lambda e^{\lambda t}$$

The left side is the derivative of a product (by the product rule in reverse):

$$\frac{d}{dt}\Bigl[e^{\lambda(j+1)t} P_{j+1}(t)\Bigr] = j\lambda e^{\lambda t}$$

Integrate both sides with respect to t:

$$e^{\lambda(j+1)t} P_{j+1}(t) = je^{\lambda t} + C$$

Apply the initial condition P_{j+1}(0) = 0: at t = 0, j·1 + C = 0, so C = −j.

Therefore:

$$e^{\lambda(j+1)t} P_{j+1}(t) = j\bigl(e^{\lambda t} - 1\bigr)$$

$$P_{j+1}(t) = je^{-\lambda(j+1)t}\bigl(e^{\lambda t} - 1\bigr)$$

Factor out e^{−λt} from the bracket:

$$\boxed{P_{j+1}(t) = je^{-j\lambda t}\bigl(1 - e^{-\lambda t}\bigr)} \tag{6.4}$$

---

### The general pattern — negative binomial distribution

Continuing the integrating factor argument for P_{j+2}(t), P_{j+3}(t), and so on, we find by induction (each step uses the previously solved P_{j+k-1}(t)):

$$P_{j+k}(t) = \binom{j+k-1}{j-1} e^{-j\lambda t}\bigl(1 - e^{-\lambda t}\bigr)^k, \qquad k = 0, 1, 2, \ldots$$

Equivalently, writing n = j + k:

$$\boxed{P_n(t) = \binom{n-1}{j-1} e^{-j\lambda t}\bigl(1 - e^{-\lambda t}\bigr)^{n-j}, \qquad n = j, j+1, j+2, \ldots} \tag{6.5}$$

Here's the key insight: this is precisely the **negative binomial distribution**. If we let p = e^{−λt}, then we can write:

$$P_n(t) = \binom{n-1}{j-1} p^j (1-p)^{n-j}$$

which is NegBin(j, p) — the probability that the j-th "success" occurs on trial n, where each trial succeeds with probability p = e^{−λt}.

Biological reading: think of p = e^{−λt} as the probability that a given lineage has not yet produced a birth by time t. Then "we need j surviving original lineages among the n total individuals" matches the negative binomial structure exactly.

---

### Mean and variance

Using the negative binomial moments (or by differentiating the probability generating function):

$$E[X(t) \mid X(0) = j] = \frac{j}{p} = j \cdot e^{\lambda t} \tag{6.6}$$

$$\operatorname{Var}[X(t) \mid X(0) = j] = j \cdot \frac{1-p}{p^2} = je^{\lambda t}(e^{\lambda t} - 1) \tag{6.7}$$

Here's the key insight: the expected population grows **exponentially** at rate λ. A colony of j bacteria started at time 0 has expected size j·e^{λt} at time t. The population doubles on average every t* = ln(2)/λ time units — this is the **doubling time**.

Note also that Var[X(t)] grows faster than E[X(t)]: the process becomes increasingly variable over time. Individual trajectories can deviate wildly from the mean.

---

## Example

### Bacterial colony doubling time

Suppose a single bacterium (j = 1) divides at rate λ = 0.5 divisions per hour.

**Mean population at t = 4 hours:**
$$E[X(4)] = 1 \cdot e^{0.5 \times 4} = e^2 \approx 7.39$$

On average, about 7 or 8 bacteria after 4 hours.

**Doubling time:**
$$t^* = \frac{\ln 2}{\lambda} = \frac{0.693}{0.5} \approx 1.39 \text{ hours}$$

**Distribution at t = 2:**
$$p = e^{-0.5 \times 2} = e^{-1} \approx 0.368$$

X(2) | X(0) = 1 follows NegBin(1, 0.368) = Geometric(0.368). So:

$$P(X(2) = n) = (1 - 0.368)^{n-1} \times 0.368 = (0.632)^{n-1} \times 0.368, \quad n = 1, 2, 3, \ldots$$

**Effect of doubling λ to 1.0:**
$$E[X(4) \mid \lambda = 1.0] = e^{4} \approx 54.6$$

versus ≈ 7.4 at λ = 0.5. Doubling the division rate increases the 4-hour expected population sevenfold.

---

## Task

Open `exercise.R`. You will:

1. Simulate 100 Yule process trajectories (X(0) = 1, λ = 0.5) until t = 10 using the exact next-event simulation algorithm.
2. Plot all trajectories in grey, overlay the mean trajectory (red) and theoretical E[X(t)] = e^{λt} (blue dashed).
3. At t = 6, plot the distribution of X(6) and overlay the theoretical NegBin(1, e^{−3}) PMF.
4. Verify E[X(t)] ≈ e^{λt} at t = 2, 4, 6, 8.
5. Explore: double λ to 1.0 and plot both mean trajectories on the same graph.

Fill in every `# TODO:` marker and run the check:

```
npm run check -- bdat-624 module-04 lesson-01
```

## Check

```
npm run check -- bdat-624 module-04 lesson-01
```

## Reflection

The mean of X(t) grows as je^{λt}, but real bacterial populations hit a carrying capacity — they do not grow indefinitely. In the Yule model, what structural assumption causes unbounded growth, and how would you modify the process to introduce a carrying capacity? Think about what change to λₙ would slow growth as n approaches some maximum K. (You do not need to solve the new ODEs — just describe the modification and what qualitative change you would expect in the mean trajectory.)
