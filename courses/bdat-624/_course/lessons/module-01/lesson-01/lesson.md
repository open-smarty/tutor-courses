# Lesson 1: What is a Stochastic Process?

## Goal

Understand what a stochastic process is, how it differs from a single random variable, and how to classify processes into four fundamental types based on their time and state spaces.

## Concept

### Motivation: From Snapshots to Movies

A **random variable** is like a single photograph — it captures the value of some uncertain quantity at one fixed instant. You roll a die: the outcome is a random variable. A patient's blood pressure at 9 a.m. on Monday: a random variable.

But biology rarely deals with single instants. Diseases progress. Populations grow and shrink. Patients move between health states over weeks and months. We need to track *how* randomness evolves over time — we need a movie, not a photograph.

A **stochastic process** is that movie: an indexed collection of random variables, one per point in time (or space, or any other index), each potentially depending on what came before.

### Formal Definition

**Notation:** Let T denote the **index set** — the set of "times" (or positions) at which we observe the process. Let S denote the **state space** — the set of values the process can take. Let X(t) denote the value of the process at index t. The process itself is the entire collection {X(t) : t ∈ T}.

> **Notation block:**
> - T — the **index set** (often time: days, hours, or any real number ≥ 0)
> - S — the **state space** (the possible values X(t) can take)
> - X(t) — the **random variable** at time t; read "X at time t"
> - {X(t) : t ∈ T} — the full **stochastic process**; read "the collection of all X(t) as t ranges over T"

**Formal definition.** A stochastic process is a collection of random variables {X(t) : t ∈ T} all defined on the same probability space (Ω, F, P), indexed by a parameter t ∈ T, where each X(t) takes values in the state space S.

The probability space (Ω, F, P) is the mathematical foundation: Ω is the set of all possible outcomes (every conceivable trajectory of the process), F is a σ-algebra of events we can assign probabilities to, and P is the probability measure. In practice you rarely work with this directly, but it guarantees the probabilities are well-defined.

### The Four Types of Stochastic Processes

The index set T and the state space S each come in two flavors: **discrete** or **continuous**. Combining them gives four types.

**Type 1 — Discrete time, discrete state.** Both T and S are countable sets.

> **Notation:** T = {0, 1, 2, 3, ...} — we observe the process at integer time steps. S = {s₁, s₂, ...} — a finite or countably infinite list of states.

*Example:* A sequence of coin flips. Record outcome at each flip n = 0, 1, 2, ... as Xₙ ∈ {H, T}. Or: the number of new infections diagnosed each day in a hospital ward — we count on integer days, and the count is a whole number.

**Type 2 — Discrete time, continuous state.** T is discrete but S = ℝ (or an interval).

> **Notation:** T = {0, 1, 2, ...} as before, but S ⊆ ℝ — real numbers.

*Example:* Record a patient's body temperature each hour: X₁, X₂, X₃, ... where Xₙ ∈ [35°C, 42°C]. The observation times are discrete (hourly) but the temperature is continuous.

**Type 3 — Continuous time, discrete state.** T = [0, ∞) and S is countable.

> **Notation:** T = [0, ∞) — the process is defined at *every* real time t ≥ 0. S = {s₁, s₂, ...} — a finite or countable set of discrete states.

*Example:* A patient's health status at any instant: S = {Healthy, Mildly Ill, Severely Ill, Recovered}. The patient can change state at any moment in continuous time, but is always in one of four discrete states.

**Type 4 — Continuous time, continuous state.** T = [0, ∞) and S ⊆ ℝ.

> **Notation:** Both time and state are continuous real-valued quantities.

*Example:* The concentration of bacteria in a culture flask measured continuously: X(t) ∈ [0, ∞) for t ≥ 0. Or: the voltage across a neuron's membrane as a function of time.

### Why the Classification Matters

The mathematics — and the software tools — differ sharply across types. Discrete-time, discrete-state processes (Markov chains) are analyzed with matrix algebra. Continuous-time, discrete-state processes (birth-death processes) require differential equations. Continuous-state processes often require stochastic calculus. Knowing the type is the first step in choosing the right tool.

### Sample Paths

A **sample path** (also called a **realization** or **trajectory**) is what you actually observe when the process plays out: one specific sequence of values over time.

> **Notation:** ω ∈ Ω — a specific outcome (scenario). The sample path corresponding to ω is the function t ↦ X(t, ω) — "the value of the process at time t, given that the world unfolded as ω."

Think of it this way: you run an epidemic simulation ten times; each run is a different sample path from the same stochastic process.

## Example

**Classifying four biological processes.**

Consider the following four processes. For each, we identify T, S, and the type.

**Process A: Number of patients admitted to an ICU each day.**
- T = {1, 2, 3, ...} — one observation per day (discrete)
- S = {0, 1, 2, 3, ...} — a count of admissions (discrete, whole numbers)
- **Type: Discrete time, discrete state.** This is a counting process on a discrete grid.

**Process B: Patient core temperature measured every hour during a fever.**
- T = {0, 1, 2, ..., 24} — hourly observations over 24 hours (discrete)
- S = [35.0, 42.0] ⊆ ℝ — temperature in degrees Celsius (continuous)
- **Type: Discrete time, continuous state.** The observation schedule is fixed (every hour) but temperature is a real number.

**Process C: Patient's clinical state (Healthy / Infected / Recovered) — transitions can happen at any moment.**
- T = [0, ∞) — transitions happen in continuous time
- S = {Healthy, Infected, Recovered} — three discrete states
- **Type: Continuous time, discrete state.** The state is discrete but time is continuous. This is the type we'll spend the most time on in this course: it describes Markov chains, branching processes, and birth-death processes.

**Process D: Concentration of a drug metabolite in bloodstream after injection.**
- T = [0, ∞) — measured continuously
- S = [0, ∞) — concentration in mg/L (continuous, non-negative)
- **Type: Continuous time, continuous state.** Both time and state are real-valued.

Here's the key insight: for this course, we will focus almost entirely on **Type 3** (continuous time, discrete state) and **Type 1** (discrete time, discrete state). These are the types that govern disease progression, population dynamics, clinical trials, and survival analysis.

## Task

See `exercise.R` for the full instructions. You will use the `markovchain` package to define a 3-state health chain (Healthy, Sick, Recovered), simulate a 100-step trajectory, plot the simulation, and classify four given biological processes by hand.

## Check

```
npm run check -- bdat-624 module-01 lesson-01
```

## Reflection

A stochastic process requires that all X(t) are defined on the **same** probability space. Why does this matter biologically? Suppose you observe two patients independently — can their health trajectories form a single stochastic process? What if they share a common infection source (a hospital ward outbreak)? How does dependence between patients change the appropriate probability space, and why might an independent-patients model be wrong for a nosocomial (hospital-acquired) infection study?
