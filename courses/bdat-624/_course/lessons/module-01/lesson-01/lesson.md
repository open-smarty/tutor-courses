# Lesson 1: What is a Stochastic Process?

## Goal

By the end of this lesson you will be able to define a stochastic process formally, decode every symbol in the standard notation, and classify any real biological process into one of four types based on its state space and parameter space.

## Concept

### Why randomness can't be avoided

Suppose you're modelling the spread of an infection through a hospital ward. You could write a deterministic ODE — one that tells you the exact number of infected patients at any future time. That model is useful. But it misses something important.

Real biological systems are noisy. A patient's immune response, the exact moment a bacterium divides, whether a drug works on a given individual — these outcomes are inherently random. When that randomness is the *point* (not a nuisance), we need a different framework: **stochastic processes**.

Here's the key insight: deterministic models tell you what *will* happen on average. Stochastic models tell you the full *distribution* of what can happen — including low-probability but high-consequence events like population extinction or epidemic die-out.

---

### The formal definition

> **Notation:** *{X(t), t ∈ T}* — read this as "the family of random variables X(t), indexed by t, where t ranges over the set T."

A **stochastic process** is a collection of random variables

$$\{X(t),\; t \in T\}$$

all defined on the same probability space, where:

- **X(t)** is the **state** of the process at "time" *t* — it is a random variable, not a fixed number. At any given *t*, X(t) could take different values depending on chance.
- **T** is the **parameter space** (also called the *index set*) — the set of values that *t* ranges over. Most often T represents time, but it can be any ordered set.
- The set of all values that X(t) *can* take is called the **state space**, written **S** (or sometimes *SS* in notes).

Think of a stochastic process as a *movie* rather than a *photograph*. Each frame (time point) shows a random value; the full sequence of frames is the process.

---

### Decoding the two common notations

You will see stochastic processes written in two ways depending on whether time is discrete or continuous:

> **Notation:** *{X_n, n = 0, 1, 2, ...}* — a discrete-time process. The subscript *n* counts steps. X_0 is the starting state, X_1 is the state after one step, and so on.

> **Notation:** *{X(t), t ≥ 0}* — a continuous-time process. The argument *t* is a non-negative real number. X(t) is the state at the instant *t* seconds (or minutes, or years) after the start.

The difference is purely in T: for the first, T = {0, 1, 2, ...} (countable); for the second, T = [0, ∞) (uncontinuous).

---

### The four types

Two independent choices produce four combinations:

| | **Discrete state space S** | **Continuous state space S** |
|---|---|---|
| **Discrete T** | Type I | Type III |
| **Continuous T** | Type II | Type IV |

Let's ground each type in a real biostatistics scenario.

**Type I — Discrete time, discrete state**

> **Notation:** S = {0, 1, 2, ...} or a finite label set like {Healthy, Sick, Dead}; T = {0, 1, 2, ...}

A patient's disease status is checked every month. At each checkup, the patient is classified as Healthy (H), Sick (S), or Dead (D). The state space is S = {H, S, D}; the parameter space is T = {0, 1, 2, ...} months. This is the classic **Markov chain** setup — the core of Arc 1 of this course.

**Type II — Continuous time, discrete state**

> **Notation:** S is countable (e.g., S = {0, 1, 2, ...}); T = [0, ∞)

The number of bacteria in a culture flask changes only by integer jumps (one cell divides → count goes up by 1; one cell dies → count goes down by 1), but these events can happen at *any* instant in continuous time. This is the setting of **birth-death processes** (Module 4).

**Type III — Discrete time, continuous state**

> **Notation:** S = ℝ (or an interval); T = {0, 1, 2, ...}

A participant's body weight is recorded once a week. Weight is a real number — it does not jump in whole-number steps. The parameter space is weekly time points (discrete), but the state space is continuous.

**Type IV — Continuous time, continuous state**

> **Notation:** S = ℝ; T = [0, ∞)

A patient's blood pressure is monitored continuously by an arterial line. At every instant in time, blood pressure is a real-valued measurement. **Brownian motion** is the canonical example and will appear again in later modules as a limiting process.

---

### State space and parameter space — a quick reference

> **Notation:** *S* — the **state space**: the set of all values X(t) can take. If S is finite or countable we call it a *discrete state space*; if S is an interval or all of ℝ we call it a *continuous state space*.

> **Notation:** *T* — the **parameter space** (index set): the set of "times" the process is observed. If T = {0, 1, 2, ...} we have *discrete time*; if T = [0, ∞) we have *continuous time*.

These two choices are independent, which is why we get four types, not two.

---

## Example

### Tracking HIV treatment response

A clinical trial follows 300 HIV-positive patients starting antiretroviral therapy (ART). Every 3 months, each patient is classified into one of three states:

- **State 1:** Virologically suppressed (viral load < 200 copies/mL)
- **State 2:** Virologically failing (viral load ≥ 200 copies/mL)
- **State 3:** Lost to follow-up / discontinued

Let X_n denote patient status at the *n*-th 3-month checkpoint.

**Decoding the setup:**
- *X_n* is the state at checkpoint *n*. For a specific patient, X_0 might be 1 (suppressed at baseline), X_1 might be 1 again, X_4 might be 2 (failing at month 12).
- State space: S = {1, 2, 3} — finite and discrete.
- Parameter space: T = {0, 1, 2, 3, 4} checkpoints — discrete.
- **Classification: Type I (discrete time, discrete state).**

Now compare this with a second study that monitors viral load *continuously* using real-time PCR. Here X(t) is the actual viral count (a large integer) at any instant *t* ≥ 0. The count changes by integer jumps but at arbitrary continuous times — **Type II (continuous time, discrete state)**.

Here's the key insight: the same biological system can be modelled as different types of stochastic process depending on what you measure and when. Choosing the right type is a modelling decision.

---

## Task

Open `exercise.R`. You will simulate all four types of stochastic processes in R and produce a 2×2 grid of plots. Each simulation is short (< 15 lines of code), but pay close attention to what the axes represent — that will tell you the type.

Run the check when done:

```
npm run check -- bdat-624 module-01 lesson-01
```

## Check

```
npm run check -- bdat-624 module-01 lesson-01
```

## Reflection

A colleague says: "I always use a deterministic ODE model — it's simpler, and if I simulate it many times with slightly different parameters I can capture variability." What is the fundamental difference between this bootstrap-style approach and a proper stochastic process model? Think about what happens near a critical threshold — for example, when a bacterial population is close to extinction. Which model captures that behaviour correctly, and why?
