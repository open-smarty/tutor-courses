# Lesson 1: Competing Risks and Multi-State Models

## Goal

Understand why standard Kaplan-Meier estimates are misleading in the presence of competing risks; derive the cumulative incidence function (CIF); apply the Fine-Gray subdistribution hazard model; and model multi-state processes as continuous-time Markov chains — connecting Arc 2 (survival) back to Arc 1 (stochastic processes).

## Concept

### Motivation: Multiple Event Types

In a bone marrow transplant study, patients can die from either relapse of leukaemia or transplant-related toxicity. These are **competing risks** — two causes of death that prevent each other. If a patient dies of toxicity, they can no longer die of relapse.

**Why the standard KM estimator fails.** Treating the competing event as a censoring time is tempting but wrong. Censoring assumes the patient would eventually experience the event of interest if followed long enough. But a patient who died of toxicity will never relapse — they have been permanently removed from the risk pool in a way that censoring cannot capture. Using the KM estimator with competing events censored systematically *overestimates* the probability of the event of interest.

### The Cumulative Incidence Function (CIF)

> **Notation block:**
> - K — number of competing event types; events are labelled k = 1, 2, ..., K
> - T — time to the first event (whichever occurs first)
> - C — the cause (event type) at time T; C ∈ {1, 2, ..., K}
> - Fₖ(t) = P(T ≤ t, C = k) — the **Cumulative Incidence Function** for cause k; read "F sub k of t"
> - S(t) = P(T > t) — the **overall survival function** (probability of no event of any kind by t)
> - hₖ(t) — the **cause-specific hazard** for event type k; instantaneous rate of event k given no prior event

The CIF for cause k is:

$$F_k(t) = \int_0^t h_k(u) \cdot S(u) \, du$$

where S(u) = exp(−∑ₖ Hₖ(u)) is the overall survival function and Hₖ(u) = ∫₀ᵘ hₖ(v)dv is the cause-specific cumulative hazard. The CIFs sum to 1 − S(t):

$$\sum_{k=1}^{K} F_k(t) = 1 - S(t)$$

**Key interpretation:** Fₖ(t) is the probability of experiencing event type k by time t *in the presence of competing risks*. It accounts for the fact that competing events permanently remove subjects from the risk set.

### Cause-Specific vs Subdistribution Hazard

Two modelling frameworks exist for regression with competing risks:

**1. Cause-specific hazard model:**

$$h_k(t \mid \mathbf{X}) = h_{k0}(t) \cdot \exp(\boldsymbol{\beta}_k^\top \mathbf{X})$$

This is a separate Cox model for each cause, treating the other causes as censored. The coefficients βₖ describe the effect of X on the rate of cause k among those still event-free. This is appropriate for **aetiology** (understanding mechanisms of each cause).

**2. Fine-Gray subdistribution hazard model:**

> **Notation block:**
> - λₖ(t|X) — the **subdistribution hazard** for cause k; read "lambda sub k of t given X"
> - F̃ₖ(t) — the CIF as estimated by the Fine-Gray model; depends directly on X through γₖ

$$\lambda_k(t \mid \mathbf{X}) = \lambda_{k0}(t) \cdot \exp(\boldsymbol{\gamma}_k^\top \mathbf{X})$$

The subdistribution hazard is defined with a *modified* risk set: patients who have experienced a competing event remain in the risk set (with a zero subdistribution hazard contribution). A positive γₖ for a covariate directly implies a higher CIF Fₖ(t) — which is what clinicians usually want to know for **prognosis** (predicting the probability that a patient will experience event k).

**Key distinction:** A covariate may increase the cause-specific hazard of event k (bad for cause k mechanism) while simultaneously decreasing the CIF (because it also strongly increases the rate of competing event m, so fewer subjects are "available" to experience k). The subdistribution hazard approach directly models the CIF and is recommended when the clinical question is prognosis.

### Gray's Test

**Gray's test** compares CIFs between groups (the analogue of the log-rank test for competing risks):

H₀: F₁(t|group A) = F₁(t|group B) for all t

The test statistic uses a weighted sum of differences in the CIFs, accounting for the subdistribution approach. In R: `cmprsk::cuminc()` followed by `cmprsk::cuminc()$Tests`.

### Multi-State Models: The Full Picture

A **multi-state model** generalises both survival analysis and competing risks. Patients transition among a set of states over time.

> **Notation block:**
> - {1, 2, ..., S} — the set of states; "alive and healthy", "sick", "dead from disease", "dead from other causes"
> - qₛᵣ(t) — the **transition intensity** (instantaneous rate) from state s to state r at time t; read "q sub sr of t"
> - P_{sr}(s, t) = P(state at time t = r | state at time s = s) — the **transition probability** from state s at time s to state r at time t

The transition probabilities satisfy the **Kolmogorov forward equations** — which are the continuous-time Markov chain equations from Module 2! This is the bridge between Arc 1 and Arc 2:

$$\frac{d}{dt}P(s,t) = P(s,t) \cdot Q(t)$$

where Q(t) is the matrix of transition intensities (Q matrix, generator matrix). For time-homogeneous models, P(s,t) = exp(Q(t−s)) (matrix exponential).

A classic multi-state model for transplant patients:

```
[Alive: healthy] → [Alive: relapsed] → [Dead: relapsed]
         ↓                                      
    [Dead: toxicity]
```

This is a 4-state model with 4 possible transitions.

## Example

**Competing risks in R using cmprsk and mstate.**

```r
library(cmprsk)
# Simulate a competing risks dataset
set.seed(42)
n <- 200
time  <- rexp(n, 0.1)
cause <- sample(1:2, n, replace=TRUE, prob=c(0.6, 0.4))  # 1=event of interest, 2=competing

# Estimate CIF for each cause
ci_fit <- cuminc(ftime = time, fstatus = cause)
plot(ci_fit, main="Cumulative Incidence Functions")
```

The CIF for cause 1 will be lower than a KM estimate that ignores cause 2, because the competing event reduces the pool of subjects who can experience cause 1.

```r
library(mstate)
# Multi-state models require a transition matrix and long-format data
# See mstate vignette: transMat(), msprep(), coxph(strata(trans), data=msdata)
```

## Task

See `exercise.R`. You will construct a simulated competing risks dataset, estimate CIFs with `cmprsk::cuminc()`, compare CIFs across groups with Gray's test, fit a Fine-Gray model with `cmprsk::crr()`, and fit a simple 3-state multi-state model with the `mstate` package.

## Check

```
npm run check -- bdat-624 module-06 lesson-01
```

## Reflection

The multi-state model is a continuous-time Markov chain — the same object we studied in Modules 2 and 4. The transition intensity matrix Q is the generator matrix from Module 2; the Kolmogorov equations are the same ODEs we solved for birth-death processes in Module 4. This closure of the two arcs is not coincidental: stochastic processes provide the theoretical foundation for all of modern survival analysis. Reflect on the following: in a multi-state model for disease progression, what is the analogue of the "stationary distribution" from the Markov chain module? Under what conditions would a patient population reach a steady state? Is a stationary distribution biologically meaningful in a survival context, given that death is an absorbing state?
