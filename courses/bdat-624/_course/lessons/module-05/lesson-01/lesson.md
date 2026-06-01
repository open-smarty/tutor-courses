# Lesson 1: Survival Functions and Kaplan-Meier Estimation

## Goal

By the end of this lesson you will be able to define the survival function, hazard function, and cumulative hazard, derive the key relationships connecting them, explain what censoring is and why it arises, compute a Kaplan-Meier estimate by hand, and fit and plot KM curves in R using the `survival` package.

## Concept

### Connection to Arc 1

We have spent the first arc studying continuous-time stochastic processes — Poisson processes, birth-death chains, and Markov chains — asking: how many events occur by time t? The Poisson process, for instance, counts arrivals at rate λ. Survival analysis asks the complementary question: **when does the first event occur, and what is its distribution?** We now shift from counting events to modelling the *time until* an event. The tools we build here sit at the heart of clinical trial analysis, epidemiology, and reliability engineering.

---

### Why standard regression fails

In a clinical trial, patients are enrolled at different times and may not experience the event (death, relapse, infection) before the study ends. Consider a patient who is alive at the end of a 5-year study. We do not know when they will die — only that they have survived at least 5 years. This is **partial information**: informative, but incomplete. Discarding such patients would introduce severe bias. Treating them as if they had experienced the event at the last contact time would be equally wrong. Standard regression has no natural way to handle this structure. Survival analysis was developed precisely to use these partial observations correctly.

---

### The survival function and its relatives

> **Notation:** T — the survival time (time from study entry until the event of interest, e.g., death, relapse, infection). T is a non-negative continuous random variable defined on [0, ∞).

> **Notation:** S(t) = P(T > t) — the **survival function**. This is the probability of surviving (not yet experiencing the event) beyond time t.

> **Notation:** F(t) = P(T ≤ t) = 1 − S(t) — the **cumulative distribution function** of T. This is the probability of the event occurring by time t.

> **Notation:** f(t) = −dS(t)/dt = F′(t) — the **probability density function** of T.

> **Notation:** h(t) = f(t) / S(t) — the **hazard function** (also called the hazard rate or intensity function). This is the instantaneous rate of the event at time t, *given* survival up to t.

Let us unpack the hazard more carefully. For a small interval (t, t + Δt]:

$$h(t)\,\Delta t \approx P\bigl(T \in (t,\,t+\Delta t] \mid T > t\bigr)$$

Here's the key insight: h(t) answers "given that you have made it to time t, what is your risk of the event in the next tiny instant?" It is a conditional rate, not a probability. It can exceed 1. A decreasing hazard means the longer you survive, the safer you become (e.g., post-operative mortality). An increasing hazard means the risk grows with age or time (e.g., age-related disease incidence).

> **Notation:** H(t) = ∫₀ᵗ h(u) du — the **cumulative hazard function**. This integrates the instantaneous risk over time.

---

### Key relationships

We derive the three fundamental identities that link S(t), h(t), and H(t).

**Identity 1: H(t) = −ln S(t), equivalently S(t) = e^{−H(t)}.**

Start from the definition of h(t):
$$h(t) = \frac{f(t)}{S(t)} = \frac{-S'(t)}{S(t)} = -\frac{d}{dt}\ln S(t)$$

Integrate both sides from 0 to t, using S(0) = 1, so ln S(0) = 0:
$$H(t) = \int_0^t h(u)\,du = -\ln S(t)$$

Therefore:
$$\boxed{S(t) = e^{-H(t)} = \exp\!\left(-\int_0^t h(u)\,du\right)} \tag{5.1}$$

This identity is crucial: it means the full survival function is determined by the hazard function alone.

**Identity 2: h(t) = −d/dt ln S(t) = f(t)/S(t).**

This follows directly from the derivation above. We can also write:
$$h(t) = \frac{f(t)}{S(t)} = \frac{-S'(t)}{S(t)} \tag{5.2}$$

**Identity 3: For the exponential distribution, h(t) = λ (constant).**

If T ~ Exponential(λ), then f(t) = λe^{−λt} and S(t) = e^{−λt}. Therefore:
$$h(t) = \frac{\lambda e^{-\lambda t}}{e^{-\lambda t}} = \lambda$$

Here's the key insight: the exponential distribution has **constant hazard** — the risk of the event is the same at every time point, regardless of how long you have already survived. This is the "memoryless" property. From Identity 1: H(t) = λt and S(t) = e^{−λt}, consistent with the exponential CDF.

---

### Censoring

> **Notation:** δ (delta) — the **event indicator**. δ = 1 if the event was directly observed; δ = 0 if the observation was censored (the event had not occurred by last contact).

**Right censoring** (the most common type) occurs when we know only that T > c for some censoring time c. A patient alive at the end of the study, or who withdrew, is right-censored at their last contact time. We observe the pair (min(T, c), δ = 1{T ≤ c}).

**Left censoring** occurs when we know the event occurred before some observation time but not exactly when (e.g., already infected at first screening).

**Interval censoring** occurs when we know only that the event occurred in an interval (l, r] (e.g., infection detected at a quarterly visit).

The key assumption for valid survival analysis is **non-informative censoring**: the reason a subject is censored must be unrelated to their underlying survival time. A patient who drops out because they are too sick to attend violates this assumption.

---

### The Kaplan-Meier estimator

The KM estimator is the non-parametric maximum likelihood estimator of S(t). It makes no distributional assumption about T — it uses only the observed event times and censoring indicators.

Let t_{(1)} < t_{(2)} < ... < t_{(m)} be the ordered **distinct event times** (censored observations do not contribute event times).

At each event time t_{(j)}, define:

> **Notation:** dⱼ — the number of events (δ = 1) at time t_{(j)}.

> **Notation:** nⱼ — the number at risk just before t_{(j)}: all subjects who have not yet had the event and have not yet been censored.

> **Notation:** Ŝ(t) — the **Kaplan-Meier estimator** of S(t).

$$\boxed{\hat{S}(t) = \prod_{j:\,t_{(j)} \leq t} \left(1 - \frac{d_j}{n_j}\right)} \tag{5.3}$$

Here's the key insight: the KM estimator is a **product of conditional survival probabilities**. Each factor (1 − dⱼ/nⱼ) estimates the probability of surviving past t_{(j)} given survival to just before t_{(j)}. Multiplying these conditional probabilities gives the marginal probability of surviving past t — this is exactly the multiplicative structure of conditional probability.

Between event times, Ŝ(t) is constant. It is a step function that drops at each observed event time.

---

### Worked example

Six patients have the following observed times (+ denotes censored):

| Patient | Time | Status |
|---------|------|--------|
| 1 | 1 | event |
| 2 | 2+ | censored |
| 3 | 3 | event |
| 4 | 5 | event |
| 5 | 6+ | censored |
| 6 | 9 | event |

Distinct event times: t_{(1)}=1, t_{(2)}=3, t_{(3)}=5, t_{(4)}=9.

| j | t_{(j)} | nⱼ (at risk) | dⱼ (events) | 1 − dⱼ/nⱼ | Ŝ(t_{(j)}) |
|---|---------|-------------|------------|-----------|-----------|
| 1 | 1 | 6 | 1 | 5/6 | 5/6 ≈ 0.833 |
| 2 | 3 | 4 | 1 | 3/4 | (5/6)(3/4) = 5/8 = 0.625 |
| 3 | 5 | 3 | 1 | 2/3 | (5/8)(2/3) = 5/12 ≈ 0.417 |
| 4 | 9 | 1 | 1 | 0/1 = 0 | 0 |

Note: patient 2 was censored at time 2 (between t_{(1)}=1 and t_{(2)}=3), so the risk set at t_{(2)}=3 drops from 5 to 4. Patient 5 was censored at time 6 (between t_{(3)}=5 and t_{(4)}=9), so the risk set at t_{(4)}=9 is 1.

---

### Confidence intervals: Greenwood's formula

Ŝ(t) is a product of random quantities. Its variance is estimated using **Greenwood's formula** (stated without derivation):

$$\widehat{\operatorname{Var}}\!\left[\hat{S}(t)\right] = \hat{S}(t)^2 \sum_{j:\,t_{(j)} \leq t} \frac{d_j}{n_j(n_j - d_j)}$$

The 95% confidence interval is constructed on the log(−log) scale to ensure the CI stays within [0,1]:

$$\widehat{\operatorname{Var}}\!\left[\ln(-\ln \hat{S}(t))\right] \approx \sum_{j:\,t_{(j)} \leq t} \frac{d_j}{n_j(n_j - d_j)}$$

In R, `survfit()` computes these CIs automatically.

---

### The log-rank test

When we have two groups (e.g., treatment vs. control), we want to test:

H₀: S₁(t) = S₂(t) for all t (the two groups have the same survival function).

The **log-rank test** is the standard non-parametric test for this. At each event time t_{(j)}, it computes the observed (Oᵢⱼ) and expected (Eᵢⱼ) number of events in group i under H₀. The test statistic is a weighted sum of (O − E) across all event times. Under H₀ it follows approximately a χ²(1) distribution for two groups.

In R: `survdiff(Surv(...) ~ group, data = ...)`. The p-value tests whether the survival curves are equal over all time points simultaneously.

---

## Example

See the worked calculation in the table above. In R, the same calculation on the `lung` dataset is illustrated in `exercise.R`.

## Task

Open `exercise.R`. You will:

1. Create a `Surv` object from the `lung` dataset.
2. Fit and plot an overall KM curve with 95% confidence bands.
3. Fit KM curves stratified by sex and plot them on the same graph.
4. Perform a log-rank test comparing male vs. female survival.
5. Report median survival times and the log-rank p-value; write a one-sentence interpretation.

Fill in every `# TODO:` marker and run:

```
npm run check -- bdat-624 module-05 lesson-01
```

## Check

```
npm run check -- bdat-624 module-05 lesson-01
```

## Reflection

The Kaplan-Meier estimator drops to 0 when the last observed time is an event (as in the worked example above). But what happens when the last observation is a censored time? Ŝ(t) then stays positive beyond the last event — it is undefined beyond the last censored time. Why is this a problem for estimating, say, the median survival time? How would you handle it in a report?
