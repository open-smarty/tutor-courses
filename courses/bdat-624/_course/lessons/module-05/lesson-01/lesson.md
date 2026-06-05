# Lesson 1: Survival Functions and Kaplan-Meier Estimation

## Goal

Define the survival function, hazard function, and their relationship; understand right censoring; derive the Kaplan-Meier estimator; and apply the log-rank test to compare survival curves.

## Concept

### Motivation: Time-to-Event Data

A clinical trial follows 100 lung cancer patients from diagnosis. After 2 years, some patients have died, but 30 are still alive. For those 30, we know they survived at least 2 years — but we don't know when they will die. For 5 patients who dropped out at various points, we know they were alive when last seen. These are **censored observations**: partial information, not missing data.

Survival analysis is the branch of statistics designed to handle time-to-event data — especially when some event times are only partially observed due to censoring.

### The Survival Function S(t)

> **Notation block:**
> - T — the **event time** (a non-negative random variable); for a patient, T is the time from some origin (e.g., diagnosis) to the event (e.g., death or relapse); read "T"
> - t — a specific time point; a non-negative real number; read "t"
> - S(t) = P(T > t) — the **survival function**; probability of surviving (not experiencing the event) beyond time t; read "S of t"

$$S(t) = P(T > t) = 1 - F(t)$$

where F(t) = P(T ≤ t) is the cumulative distribution function.

**Properties of S(t):**
- S(0) = 1 (at time 0, everyone is event-free)
- S(∞) = 0 (eventually, all experience the event — or we assume this)
- S(t) is non-increasing: once you've had the event, you can't "un-have" it
- S(t) is right-continuous

### The Hazard Function h(t)

> **Notation block:**
> - h(t) — the **hazard function** (also called hazard rate or force of mortality); read "h of t"
> - Δ — a small time increment (used in the limit definition)
> - P(t ≤ T < t+Δ | T ≥ t) — the conditional probability of the event in [t, t+Δ) given survival to t; read "probability of event in [t, t+delta] given survived to t"

$$h(t) = \lim_{\Delta \to 0} \frac{P(t \leq T < t + \Delta \mid T \geq t)}{\Delta}$$

The hazard is the **instantaneous rate** of the event at time t, given survival to t. It is not a probability — it can exceed 1.

**Biological shapes of h(t):**
- **Constant:** h(t) = λ (exponential distribution) — appropriate when risk doesn't change with time (e.g., certain infections)
- **Increasing:** h(t) rises with t (Weibull with shape > 1) — ageing, progressive disease
- **Decreasing:** h(t) falls with t (Weibull with shape < 1) — early events are riskier (neonatal mortality, post-surgery complications)
- **Bathtub:** high early, then low, then rising again — human mortality (infant mortality → healthy adult → old age)

### The Key Relationship: S, h, and H

> **Notation block:**
> - H(t) = ∫₀ᵗ h(u) du — the **cumulative hazard function**; read "H of t"
> - f(t) = -S'(t) — the **probability density function** of T; read "f of t"

The fundamental identity connecting S and h:

$$S(t) = \exp(-H(t)) = \exp\!\left(-\int_0^t h(u) \, du\right)$$

**Derivation.** By the chain rule and the definition of conditional probability:

$$h(t) = \lim_{\Delta\to 0} \frac{P(t \leq T < t+\Delta | T \geq t)}{\Delta} = \frac{f(t)}{S(t)} = -\frac{S'(t)}{S(t)}$$

This gives the ODE S'(t) = -h(t)S(t), which (with S(0)=1) has solution S(t) = exp(-∫₀ᵗ h(u)du) = exp(-H(t)). ∎

Also: h(t) = -d[log S(t)]/dt.

### Censoring

**Right censoring** (most common): we know the patient survived to at least time c (the censoring time), but do not observe T. Example: the study ends before the patient experiences the event; or the patient is lost to follow-up.

> **Notation block:**
> - (tᵢ, δᵢ) — the data for patient i: tᵢ is the observed time, δᵢ is the event indicator; δᵢ = 1 if the event was observed, δᵢ = 0 if the observation was right-censored; read "t_i and delta_i"
> - tᵢ = min(Tᵢ, Cᵢ) — the observed time is the minimum of the true event time Tᵢ and the censoring time Cᵢ

**Why naively ignoring censored observations is wrong.** If you simply exclude censored patients, you are throwing away information — and you are selecting on who died (which biases estimates downward). The Kaplan-Meier estimator handles censoring correctly by updating the risk set.

### The Kaplan-Meier Estimator

> **Notation block:**
> - t₁ < t₂ < ... < tₖ — the distinct **event times** (only times at which events actually occurred, not censoring times); read "t sub 1, t sub 2, ..."
> - dᵢ — number of events (deaths/failures) at time tᵢ; read "d sub i"
> - nᵢ — **number at risk** just before time tᵢ: all patients who have neither experienced the event nor been censored before tᵢ; read "n sub i"
> - Ŝ(t) — the Kaplan-Meier estimate of S(t); read "S-hat of t"

$$\hat{S}(t) = \prod_{t_i \leq t} \left(1 - \frac{d_i}{n_i}\right)$$

**Intuition:** At each event time tᵢ, the conditional probability of surviving *through* tᵢ (given survival to just before tᵢ) is estimated as 1 - dᵢ/nᵢ. The Kaplan-Meier estimate multiplies these step-by-step conditional survival probabilities.

**Why censoring is handled correctly:** Censored patients contribute to the risk set nᵢ for all event times before they are censored, then are removed. They are "used" appropriately without being discarded.

**Greenwood's formula for variance:**

> **Notation block:**
> - Var(Ŝ(t)) — estimated variance of the KM estimator at time t

$$\widehat{\mathrm{Var}}(\hat{S}(t)) \approx \hat{S}(t)^2 \sum_{t_i \leq t} \frac{d_i}{n_i(n_i - d_i)}$$

95% confidence interval: Ŝ(t) ± 1.96 × √Var(Ŝ(t)).

### Log-Rank Test

The **log-rank test** compares survival curves between two (or more) groups.

> **Notation block:**
> - H₀: S₁(t) = S₂(t) for all t — the null hypothesis: the two groups have identical survival curves
> - Oᵢ — **observed** number of events in group g at event time tᵢ
> - Eᵢ — **expected** number of events under H₀
> - χ² = (Σ(O-E))² / Σ(Var) — the log-rank test statistic; under H₀, approximately χ²(1) for two groups

The log-rank test statistic weights all time points equally, giving more power when the hazard ratio between groups is constant over time.

## Example

**NCCTG Lung Cancer Dataset (R's `survival::lung`).**

The `lung` dataset in R contains survival times for 228 patients with advanced lung cancer. Variables include `time` (days), `status` (2=dead, 1=censored), and `sex` (1=male, 2=female).

```r
library(survival)
km_fit <- survfit(Surv(time, status==2) ~ sex, data = lung)
plot(km_fit)
```

The Kaplan-Meier curves show that female patients (sex=2) have better survival than male patients. The log-rank test (survdiff) gives a p-value to test whether this difference is statistically significant.

**Reading the KM curve:** At time t=365 days (1 year), Ŝ_female(365) ≈ 0.58 means approximately 58% of female patients are estimated to have survived 1 year.

## Task

See `exercise.R`. You will fit Kaplan-Meier curves to the `lung` dataset, stratified by sex; compute Greenwood's formula manually at one time point; perform and interpret the log-rank test; and create a publication-quality KM plot.

## Check

```
npm run check -- bdat-624 module-05 lesson-01
```

## Reflection

The log-rank test weights all time points equally. An alternative is the **Wilcoxon test** (using `survdiff(rho=1)`), which weights early time points more heavily. In a cancer trial, if a new treatment works only in the long term (late separation of KM curves), which test would be more powerful: log-rank or Wilcoxon? What biological scenario would make early-weighted tests more appropriate? Relate your answer to the shape of the hazard functions for the two groups.
