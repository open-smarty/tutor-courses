# Lesson 2: The Poisson Process and Renewal Counting

## Goal

Derive the Poisson distribution from first principles via differential equations, establish the memoryless property of exponential inter-arrival times, and connect n-th event waiting times to the Gamma distribution.

## Concept

### Motivation: Counting Random Events in Time

When does the next mutation arise in a dividing cell? When does the next patient arrive at the emergency room? When does the next HIV replication event occur in a treated patient?

All of these share a common structure: events happen at random moments in continuous time, and we want to count how many occur by time t. The **Poisson process** is the canonical model for such random counting in continuous time. It is the continuous-time analogue of the Binomial distribution — but where the number of trials is replaced by a continuous time interval.

### The Three Poisson Postulates

Rather than defining the Poisson process by its distribution, we build it from three biologically natural axioms.

> **Notation block:**
> - N(t) — the **counting process**; number of events in the interval [0, t]; read "N of t"
> - λ — the **rate** (intensity) of the process; number of events per unit time on average; read "lambda"
> - Δt — a small time increment; read "delta t"
> - o(Δt) — any function of Δt that goes to zero faster than Δt; formally o(Δt)/Δt → 0 as Δt → 0; read "little-oh of delta t" — this represents negligible terms

**Postulate 1 — Stationarity:** The probability of exactly one event in a short interval [t, t+Δt] depends only on the length Δt, not on when it starts:

$$P(\text{1 event in } [t, t+\Delta t]) = \lambda \Delta t + o(\Delta t)$$

The rate λ > 0 is constant over time. The o(Δt) term captures higher-order corrections that vanish faster than Δt.

**Postulate 2 — Independence of disjoint intervals:** For any two non-overlapping intervals [a, b] and [c, d] (with b < c), the counts N(b) - N(a) and N(d) - N(c) are independent random variables.

In biological terms: what happened in the first hour has no bearing on what happens in the second hour. Events don't "remember" each other.

**Postulate 3 — Orderliness (no simultaneous events):** The probability of two or more events in [t, t+Δt] is negligible:

$$P(\text{2 or more events in } [t, t+\Delta t]) = o(\Delta t)$$

As Δt → 0, the chance of two events at "the same instant" vanishes.

### Deriving the Poisson PMF from the Postulates

> **Notation block:**
> - Pₙ(t) = P(N(t) = n) — probability of exactly n events by time t; read "P sub n of t"
> - Pₙ'(t) = dPₙ/dt — the derivative of Pₙ(t) with respect to t; read "P sub n prime of t"

From the three postulates, we derive a system of **ordinary differential equations (ODEs)** for Pₙ(t).

**Setting up the ODE for P₀(t).**

P₀(t+Δt) = P(no events in [0, t+Δt]) = P(no events in [0,t]) × P(no events in [t, t+Δt])

> The second equality uses Postulate 2 (independence of disjoint intervals): [0,t] and [t,t+Δt] are disjoint, so the events in them are independent.

P(no events in [t, t+Δt]) = 1 - λΔt + o(Δt)

> From Postulate 1: P(exactly 1 event) = λΔt + o(Δt), and Postulate 3: P(2+ events) = o(Δt). So P(0 events) = 1 - λΔt - o(Δt) + o(Δt) = 1 - λΔt + o(Δt).

Therefore:

$$P_0(t + \Delta t) = P_0(t) \cdot (1 - \lambda \Delta t + o(\Delta t))$$

Rearranging:

$$\frac{P_0(t + \Delta t) - P_0(t)}{\Delta t} = -\lambda P_0(t) + \frac{o(\Delta t)}{\Delta t}$$

Taking Δt → 0:

$$P_0'(t) = -\lambda P_0(t) \quad \text{with initial condition } P_0(0) = 1$$

> **Why P₀(0) = 1?** At time 0, no time has elapsed, so no events can have occurred.

**Solving P₀(t).** This is a first-order linear ODE with constant coefficient. The solution is:

$$P_0(t) = e^{-\lambda t}$$

Verify: P₀'(t) = -λe^{-λt} = -λP₀(t). ✓ And P₀(0) = e⁰ = 1. ✓

**Setting up the ODE for Pₙ(t), n ≥ 1.**

For n events by time t+Δt, either:
- There were n events by time t, and 0 events in [t, t+Δt], OR
- There were n-1 events by time t, and exactly 1 event in [t, t+Δt]
- (Postulate 3 makes "2 or more in [t, t+Δt]" negligible)

$$P_n(t + \Delta t) = P_n(t)(1 - \lambda\Delta t) + P_{n-1}(t)(\lambda\Delta t) + o(\Delta t)$$

Rearranging and taking Δt → 0:

$$P_n'(t) = -\lambda P_n(t) + \lambda P_{n-1}(t) \quad \text{for } n \geq 1$$

with initial condition Pₙ(0) = 0 for n ≥ 1 (at time 0, there are 0 events, so all n ≥ 1 are impossible).

**Solving P₁(t) by integrating factor.**

$$P_1'(t) + \lambda P_1(t) = \lambda P_0(t) = \lambda e^{-\lambda t}$$

> **Notation:** Multiplying both sides by the **integrating factor** e^{λt}: this turns the left side into a perfect derivative.

Multiply both sides by e^{λt}:

$$e^{\lambda t} P_1'(t) + \lambda e^{\lambda t} P_1(t) = \lambda$$

The left side is the derivative of the product e^{λt} P₁(t):

$$\frac{d}{dt}\!\left[e^{\lambda t} P_1(t)\right] = \lambda$$

Integrate both sides from 0 to t:

$$e^{\lambda t} P_1(t) - e^0 P_1(0) = \lambda t$$

Since P₁(0) = 0:

$$e^{\lambda t} P_1(t) = \lambda t$$

$$P_1(t) = \lambda t \, e^{-\lambda t}$$

**Inductive step: Assume Pₙ₋₁(t) = e^{-λt}(λt)^{n-1}/(n-1)! and derive Pₙ(t).**

The ODE for Pₙ is:

$$P_n'(t) + \lambda P_n(t) = \lambda \cdot \frac{(λt)^{n-1}}{(n-1)!} e^{-\lambda t}$$

Multiply by integrating factor e^{λt}:

$$\frac{d}{dt}\!\left[e^{\lambda t} P_n(t)\right] = \lambda \cdot \frac{(\lambda t)^{n-1}}{(n-1)!}$$

Integrate from 0 to t (using Pₙ(0) = 0):

$$e^{\lambda t} P_n(t) = \lambda \cdot \frac{1}{(n-1)!} \cdot \frac{t^n}{n} \cdot \lambda^{n-1} = \frac{(\lambda t)^n}{n!}$$

Therefore:

$$P_n(t) = \frac{e^{-\lambda t}(\lambda t)^n}{n!}, \quad n = 0, 1, 2, \ldots \quad \blacksquare$$

Here's the key insight: N(t) ~ Poisson(λt). The Poisson distribution arises naturally from the three axioms of stationarity, independence, and orderliness. The parameter of the Poisson distribution is λt — the rate times the time elapsed.

### Inter-Arrival Times and the Exponential Distribution

Let Tₙ denote the waiting time until the n-th event (measured from time 0). Let W₁ = T₁ (waiting time from 0 to the first event) and Wₙ = Tₙ - Tₙ₋₁ (waiting time between the (n-1)-th and n-th events).

> **Notation block:**
> - Tₙ — the time of the n-th event; read "T sub n"
> - W₁, W₂, ... — inter-arrival times; Wₙ = Tₙ - Tₙ₋₁; read "W sub n"

**Claim:** The inter-arrival times W₁, W₂, ... are i.i.d. Exponential(λ) random variables.

**Proof:** P(W₁ > t) = P(N(t) = 0) = e^{-λt}. So W₁ ~ Exp(λ). By independence and stationarity, each subsequent Wₙ also ~ Exp(λ), independent of W₁, ..., Wₙ₋₁.

**Memoryless property.** The exponential distribution satisfies:

$$P(W > s + t \mid W > s) = P(W > t) \quad \text{for all } s, t \geq 0$$

**Proof:** 

$$P(W > s+t \mid W > s) = \frac{P(W > s+t)}{P(W > s)} = \frac{e^{-\lambda(s+t)}}{e^{-\lambda s}} = e^{-\lambda t} = P(W > t) \quad \blacksquare$$

Biological interpretation: if you have been waiting for the next mutation for s seconds, the distribution of remaining wait is the same as if you had just started waiting. The process has no memory of how long it has waited — which is a strong and sometimes unrealistic assumption for biological events.

### n-th Event Time: Gamma Distribution

The n-th event time Tₙ = W₁ + W₂ + ... + Wₙ is the sum of n i.i.d. Exp(λ) variables.

> **Notation block:**
> - Gamma(n, λ) — the Gamma distribution with shape n (positive integer) and rate λ; also called Erlang(n, λ) when n is an integer

The sum of n i.i.d. Exp(λ) random variables follows a Gamma(n, λ) distribution with PDF:

$$f_{T_n}(t) = \frac{\lambda^n t^{n-1} e^{-\lambda t}}{(n-1)!}, \quad t > 0$$

This makes intuitive sense: to wait for the n-th event, you must wait through n consecutive exponential waiting periods.

## Example

**Modelling emergency room patient arrivals.**

Patients arrive at an emergency room according to a Poisson process with rate λ = 4 patients/hour.

1. **P(exactly 3 patients in 1 hour):** P₃(1) = e^{-4}×4³/3! = e^{-4}×64/6 ≈ 0.0733×10.67 ≈ 0.1954.

2. **Expected time until 5th patient:** E[T₅] = n/λ = 5/4 = 1.25 hours.

3. **Memoryless check:** If 30 minutes have passed with no patient, the expected additional wait is still 1/λ = 15 minutes — the same as if we had just started. This is the memoryless property.

4. **Simulating in R:** Draw inter-arrival times from Exp(4) using `rexp(n, rate=4)`, cumulate to get event times, and verify that counts in any interval follow Poisson(4×interval length).

## Task

See `exercise.R`. You will simulate a Poisson process using exponential inter-arrival times, verify that inter-arrival times are exponential, verify that N(t) is Poisson(λt), and examine the Gamma waiting time distribution.

## Check

```
npm run check -- bdat-624 module-03 lesson-02
```

## Reflection

The Poisson process assumes events occur at a constant rate λ over time (Postulate 1: stationarity). In a clinical setting, patient arrivals at a hospital are not constant — they peak on Mondays, they surge during flu season, they increase around full moons (according to some studies). This motivates the **non-homogeneous Poisson process** (NHPP) where λ(t) is a function of time. In an NHPP, how would you modify the ODE for P₀(t)? What function replaces e^{-λt} as the survival function? (Hint: think about the cumulative rate Λ(t) = ∫₀ᵗ λ(u) du and how it generalises the product λt.)
