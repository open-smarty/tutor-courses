# Lesson 2: The Poisson Process and Renewal Counting

## Goal

By the end of this lesson you will be able to state and interpret the four postulates of the Poisson process, derive the Poisson PMF from those postulates using differential equations, explain the memoryless property of the exponential interarrival times, and connect the waiting time to the n-th event to the Gamma distribution.

## Concept

### Why we need a model for random arrivals

Patients arrive at an emergency room. Drug-resistant mutations appear in a tumour. Radio-active atoms decay. In each case, events arrive at random moments in continuous time, with no regularity — you cannot predict when the next one will occur. The Poisson process is the canonical mathematical model for exactly this situation.

Here's the key insight: the Poisson process is not just a formula. It emerges inevitably from four simple, physically motivated assumptions. Understanding those assumptions tells you *when* the model is appropriate — and when it isn't.

---

### Notation

> **Notation:** X(t) — the number of events (arrivals, mutations, emissions) that have occurred in the interval (0, t]. This is a discrete-valued, continuous-time stochastic process. X(0) = 0.

> **Notation:** λ — the **rate parameter** (events per unit time). We require λ > 0. It is constant over time — this is the homogeneous Poisson process.

> **Notation:** o(Δt) — **"little-oh of Δt"**: any term h(Δt) such that lim_{Δt→0} h(Δt)/Δt = 0. These terms vanish so fast compared to Δt that they are negligible as Δt → 0. Think of them as "higher-order corrections" we can ignore in the limit.

---

### The four postulates

The homogeneous Poisson process is defined by four conditions. Read each one first in mathematical language, then in plain English.

**Postulate 1 — Independence of non-overlapping intervals:**

For any 0 ≤ t_1 < t_2 ≤ t_3 < t_4, the counts X(t_2) − X(t_1) and X(t_4) − X(t_3) are independent random variables.

*In plain English:* "What happens in the interval 9–10am has no bearing on what happens in 10–11am." This is the stochastic analogue of saying the arrivals have no memory of each other.

**Postulate 2 — Proportional probability of one event:**

$$P(\text{exactly 1 event in } (t,\; t + \Delta t]) = \lambda \Delta t + o(\Delta t)$$

*In plain English:* "In a tiny window of length Δt, the probability of seeing exactly one arrival is approximately proportional to the window length. Halve the window, halve the probability."

**Postulate 3 — Complementary probability of zero events:**

$$P(\text{zero events in } (t,\; t + \Delta t]) = 1 - \lambda \Delta t + o(\Delta t)$$

*In plain English:* "In a tiny window, nothing happens almost certainly — the probability is close to 1 minus the probability of one arrival."

**Postulate 4 — Negligible probability of two or more events:**

$$P(\text{two or more events in } (t,\; t + \Delta t]) = o(\Delta t)$$

*In plain English:* "Two events cannot happen at exactly the same instant. The probability of a double arrival shrinks faster than the window length — it is negligible compared to Δt."

Note that Postulates 2, 3, and 4 are consistent: 1 = P(0) + P(1) + P(≥2) ≈ (1 − λΔt) + λΔt + 0. ✓

---

### Deriving P_n(t) = P(X(t) = n)

Let's unpack this derivation before we go further. We will derive the distribution of X(t) directly from the postulates using ordinary differential equations. Every step is annotated.

> **Notation:** P_n(t) = P(X(t) = n) — the probability that exactly n events have occurred by time t.

#### Step 1: Differential equation for P_0(t)

Starting from P_0(0) = 1 (no events at time 0):

$$P_0(t + \Delta t) = P_0(t) \cdot [1 - \lambda \Delta t + o(\Delta t)]$$

This says: "no events by time t+Δt" = "no events by time t" AND "no event in the next Δt". We used independence (Postulate 1) and Postulate 3.

Rearranging:

$$P_0(t + \Delta t) - P_0(t) = -\lambda \Delta t \cdot P_0(t) + o(\Delta t)$$

Dividing both sides by Δt and taking the limit Δt → 0:

$$P_0'(t) = -\lambda P_0(t) \qquad \text{(the } o(\Delta t)/\Delta t \text{ term vanishes by definition)}$$

This is a first-order linear ODE with constant coefficients. The general solution is P_0(t) = Ce^{-λt}. Applying the initial condition P_0(0) = 1:

$$\boxed{P_0(t) = e^{-\lambda t}}$$

#### Step 2: Differential equation for P_n(t), n ≥ 1

There are exactly two ways to have n events by time t + Δt:

| Path | Probability |
|------|-------------|
| n−1 events by t, then 1 event in (t, t+Δt] | P_{n-1}(t) · λΔt + o(Δt) |
| n events by t, then 0 events in (t, t+Δt] | P_n(t) · (1 − λΔt) + o(Δt) |
| ≥2 events in (t, t+Δt] | o(Δt) (negligible by Postulate 4) |

Adding the two main paths:

$$P_n(t + \Delta t) = P_{n-1}(t) \cdot \lambda \Delta t + P_n(t) \cdot (1 - \lambda \Delta t) + o(\Delta t)$$

Rearranging and dividing by Δt:

$$P_n'(t) = \lambda P_{n-1}(t) - \lambda P_n(t), \qquad n \geq 1$$

#### Step 3: Solving the recursive ODE system

Let's unpack this notation before we go further. Define Q_n(t) = e^{λt} P_n(t) (an integrating factor substitution). Then:

$$Q_n'(t) = \lambda e^{\lambda t} P_n(t) + e^{\lambda t} P_n'(t)$$

$$= \lambda Q_n(t) + e^{\lambda t} [\lambda P_{n-1}(t) - \lambda P_n(t)] \qquad \text{(substituting the ODE for } P_n' \text{)}$$

$$= \lambda Q_n(t) + \lambda Q_{n-1}(t) - \lambda Q_n(t) \qquad \text{(since } e^{\lambda t} P_k(t) = Q_k(t) \text{)}$$

$$Q_n'(t) = \lambda Q_{n-1}(t)$$

Now solve recursively with Q_0(t) = e^{λt} P_0(t) = 1:

- n = 0: Q_0(t) = 1, so Q_0'(t) = 0 = λ · Q_{-1}... (base case, consistent)
- n = 1: Q_1'(t) = λ Q_0(t) = λ · 1 = λ. Integrating: Q_1(t) = λt (using Q_1(0) = 0)
- n = 2: Q_2'(t) = λ Q_1(t) = λ · λt. Integrating: Q_2(t) = (λt)²/2
- n = k: Q_k'(t) = λ Q_{k-1}(t). By induction: Q_k(t) = (λt)^k / k!

Converting back to P_n:

$$P_n(t) = e^{-\lambda t} Q_n(t) = e^{-\lambda t} \frac{(\lambda t)^n}{n!}$$

This is the **Poisson PMF** with parameter λt:

$$\boxed{X(t) \sim \text{Poisson}(\lambda t)}$$

The derivation is complete. All four postulates were used; every step was driven by the definitions of the postulates and the integrating-factor technique.

---

### Mean and variance of X(t)

Since X(t) ~ Poisson(λt):

$$E(X(t)) = \lambda t \qquad \text{Var}(X(t)) = \lambda t$$

The expected number of events is proportional to time — doubling the observation window doubles the expected count.

---

### The memoryless property of interarrival times

> **Notation:** T_k — the **k-th interarrival time**: the elapsed time between the (k−1)-th and k-th events. T_1 is the waiting time until the first event.

**Claim:** The interarrival times T_1, T_2, T_3, ... are i.i.d. Exponential(λ) random variables.

**Derivation for T_1:**

$$P(T_1 > t) = P(\text{no events in } (0, t]) = P_0(t) = e^{-\lambda t}$$

This is the survival function of the Exponential(λ) distribution. ✓

The **memoryless property** of the exponential distribution states: for s, t > 0,

$$P(T > t + s \mid T > s) = \frac{P(T > t + s)}{P(T > s)} = \frac{e^{-\lambda(t+s)}}{e^{-\lambda s}} = e^{-\lambda t} = P(T > t)$$

*In plain English:* "If you have already been waiting for s time units with no arrival, the additional waiting time has exactly the same distribution as if you had just started. The system has no memory of the past wait."

Here's the key insight: this is the *only* continuous distribution with the memoryless property. The Poisson process is the unique continuous-time process with independent increments and memoryless interarrival times. These are two sides of the same coin.

---

### Waiting times and the Gamma distribution

> **Notation:** T_n (also written S_n in some texts) — the **waiting time to the n-th event**: the total elapsed time from the start until the n-th event occurs.

$$T_n = \tau_1 + \tau_2 + \cdots + \tau_n$$

where τ_1, τ_2, ..., τ_n are the i.i.d. Exp(λ) interarrival times.

**Key result:** T_n ~ Gamma(n, λ)

The PDF of T_n is:

$$f_{T_n}(t) = \frac{\lambda e^{-\lambda t} (\lambda t)^{n-1}}{(n-1)!}, \qquad t > 0$$

This is the **n-Erlang distribution** (a special case of the Gamma). The mean and variance are:

$$E(T_n) = \frac{n}{\lambda} \qquad \text{Var}(T_n) = \frac{n}{\lambda^2}$$

**Connecting counts to waiting times:** There is a beautiful duality:

$$P(T_n \leq t) = P(X(t) \geq n)$$

*Both sides mean the same thing:* "The n-th event has occurred by time t." On the left, we ask about the waiting time; on the right, we ask about the count. They are two perspectives on the same process.

**Derivation sketch:**

$$P(T_n \leq t) = P(\text{at least } n \text{ events in } [0, t]) = \sum_{k=n}^{\infty} P_k(t) = \sum_{k=n}^{\infty} e^{-\lambda t} \frac{(\lambda t)^k}{k!} = P(X(t) \geq n) \qquad \checkmark$$

---

### Summary table

| Quantity | Distribution | Mean | Variance |
|---|---|---|---|
| X(t) — events in (0, t] | Poisson(λt) | λt | λt |
| T_k — k-th interarrival time | Exp(λ) | 1/λ | 1/λ² |
| T_n — time to n-th event | Gamma(n, λ) | n/λ | n/λ² |

---

## Example

### Mutations in oncology

During tumour development, point mutations arise in DNA at a rate λ = 2 mutations per kilobase pair (kb). We model mutation occurrence as a Poisson process along the genome.

**Question 1:** What is the probability that a 3 kb region contains exactly 4 mutations?

X(3) ~ Poisson(2 × 3) = Poisson(6):

$$P(X(3) = 4) = \frac{e^{-6} \cdot 6^4}{4!} = \frac{e^{-6} \cdot 1296}{24} = 54 e^{-6} \approx 0.1339$$

**Question 2:** What is the expected number of mutations in a 0.5 kb stretch?

$$E(X(0.5)) = \lambda \cdot 0.5 = 2 \times 0.5 = 1 \text{ mutation}$$

**Question 3:** A cancer biologist scans the genome and finds the first 20 coding positions mutation-free. What is the probability the next mutation occurs within the following 10 positions?

By the memoryless property: this is simply P(T_1 ≤ 10) = 1 − e^{−2×10} = 1 − e^{−20} ≈ 1. (The extremely high rate means a 10-position window almost certainly contains a mutation regardless of past history.)

For a lower rate λ = 0.05 mutations/kb: P(T_1 ≤ 0.010 kb | T_1 > 0.020 kb) = P(T_1 ≤ 0.010) = 1 − e^{−0.0005} ≈ 0.0005.

**Question 4:** What is the probability we wait more than 1 kb for the first mutation (λ = 2)?

$$P(T_1 > 1) = e^{-2 \times 1} = e^{-2} \approx 0.135$$

In R:

```r
pexp(1, rate = 2, lower.tail = FALSE)  # = e^{-2} = 0.1353
```

---

## Task

Open `exercise.R`. You will simulate a Poisson process in continuous time, verify the Poisson PMF against simulated counts, demonstrate the memoryless property empirically, and connect interarrival times to waiting times via the Gamma distribution.

Run:

```
npm run check -- bdat-624 module-03 lesson-02
```

## Check

```
npm run check -- bdat-624 module-03 lesson-02
```

## Reflection

The Poisson process requires a constant rate λ. But in an emergency room, arrivals are much more frequent at 7pm than at 3am. How would you modify the model to handle a time-varying rate λ(t)? (Hint: what would the postulate 2 look like?) This generalisation is called the *non-homogeneous* Poisson process, and its count distribution in (0, t] has parameter Λ(t) = ∫₀ᵗ λ(s) ds. Does the memoryless property still hold for interarrival times in the non-homogeneous case? Why or why not?
