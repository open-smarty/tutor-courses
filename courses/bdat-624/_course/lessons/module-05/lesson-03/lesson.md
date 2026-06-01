# Lesson 3: Parametric Survival Models and Accelerated Failure Time

## Goal

By the end of this lesson you will be able to describe the exponential, Weibull, log-normal, and log-logistic survival distributions and their hazard shapes, write down and interpret the accelerated failure time (AFT) model, explain why the Weibull model belongs to both the PH and AFT families, compare models using AIC and BIC, and fit parametric survival models in R using the `flexsurv` package.

## Concept

### Why go parametric?

The Cox model is powerful, but it deliberately avoids specifying the shape of h₀(t). This flexibility is a strength — but it comes at a cost:

1. We cannot make absolute predictions. Cox gives us hazard ratios (relative effects), but to predict "what is the probability this patient survives 2 years?" we need to estimate h₀(t) as well (via the Breslow estimator, which is rough).
2. Extrapolation is unreliable. The non-parametric baseline hazard is only defined where we have data.
3. The effect size metric — the hazard ratio — is not always the most natural or clinically interpretable.

If we are willing to **assume a parametric form** for T (or equivalently for h(t)), we gain cleaner predictions, better extrapolation, and a new family of models — the **accelerated failure time (AFT)** family — that expresses covariate effects on the time scale rather than the hazard scale.

---

### Connection to Arc 1

In Arc 1 we studied exponential inter-arrival times in the Poisson process: T ~ Exponential(λ). The exponential survival model is exactly this: constant hazard λ, memoryless, the simplest possible survival distribution. The Weibull generalises this to allow increasing or decreasing hazard — a bridge from the memoryless Poisson world to more realistic biological aging models.

---

### Common parametric distributions for survival times

> **Notation:** λ > 0 — the **scale parameter** (related to the overall level of the hazard).

> **Notation:** k > 0 — the **shape parameter** (controls how the hazard changes over time; present in Weibull but not exponential).

#### Exponential

$$h(t) = \lambda, \quad S(t) = e^{-\lambda t}, \quad f(t) = \lambda e^{-\lambda t}$$

Hazard is **constant**. The exponential model is the simplest parametric survival model and corresponds to the memoryless property. It is a special case of the Weibull with k = 1.

#### Weibull

$$h(t) = k\lambda(\lambda t)^{k-1}, \quad S(t) = \exp\bigl(-(\lambda t)^k\bigr), \quad f(t) = k\lambda(\lambda t)^{k-1} e^{-(\lambda t)^k}$$

The shape parameter k controls the hazard's behaviour over time:
- k = 1: reduces to exponential (constant hazard).
- k > 1: **monotone increasing** hazard — risk grows with time (e.g., age-related disease, material fatigue).
- k < 1: **monotone decreasing** hazard — risk falls with time (e.g., post-operative recovery, where the hazard is highest immediately after surgery).

Here's the key insight: the Weibull is the only common distribution that is simultaneously a **proportional hazards model** and an **accelerated failure time model**. This dual membership makes it particularly useful for comparisons between the Cox and AFT frameworks.

#### Log-normal

T is log-normal if log(T) ~ Normal(μ, σ²). The hazard is **non-monotone**: it increases from 0, peaks at some time, then decreases back towards 0. This shape models settings where the event is rare early on (initial build-up phase), peaks, then becomes rare again (e.g., cancer recurrence after treatment).

#### Log-logistic

T is log-logistic if log(T) follows a logistic distribution. Like the log-normal, its hazard is **unimodal** (rises then falls). It has a heavier tail than the log-normal and has a closed-form survival function, making it computationally convenient.

---

### Summary of hazard shapes

| Distribution | Shape parameter | Hazard h(t) |
|---|---|---|
| Exponential | — | Constant |
| Weibull (k > 1) | k > 1 | Monotone increasing |
| Weibull (k < 1) | k < 1 | Monotone decreasing |
| Log-normal | σ | Increases then decreases |
| Log-logistic | γ | Increases then decreases (unimodal) |

---

### The exponential model with covariates (PH parameterisation)

With a covariate vector X, the exponential model sets:

$$\lambda_i = \exp(\beta_0 + \beta_1 X_{1i} + \cdots + \beta_p X_{pi})$$

so that:

$$h(t \mid X) = \lambda_i = e^{\beta'X}$$

This is a proportional hazards model: h(t|X)/h(t|X*) = exp(β′(X−X*)), constant in t. The exponential model is thus a special case of the Cox model with constant baseline hazard.

---

### The AFT model

The **accelerated failure time (AFT) model** is a regression model on the log of survival time:

> **Notation:** AFT model: log(T) = β₀ + β₁X₁ + β₂X₂ + ... + βₚXₚ + σε

where ε is a standardised error distribution. The choice of error distribution determines the survival distribution:
- ε ~ Normal → log-normal survival times
- ε ~ Extreme-value (Gumbel) → Weibull survival times
- ε ~ Logistic → log-logistic survival times

> **Notation:** φⱼ = exp(βⱼ) — the **time ratio** for a 1-unit increase in covariate Xⱼ. This is the AFT analogue of the hazard ratio.

The time ratio φⱼ multiplies the expected survival time:

$$E[T \mid X_j = x + 1] = \phi_j \cdot E[T \mid X_j = x]$$

Here's the key insight: covariates in an AFT model **accelerate or decelerate the time scale**. A covariate with φ = 2 means the event happens twice as late for a 1-unit increase in that covariate — time moves at half speed, so patients survive twice as long. A covariate with φ = 0.5 compresses time, doubling the speed of the process.

Interpretation:
- φ > 1: time is **stretched** → longer survival (beneficial covariate)
- φ < 1: time is **compressed** → shorter survival (harmful covariate)
- φ = 1: no effect on survival time

**Example:** A Weibull AFT model gives β₁ = 0.693 for the treatment indicator. Then φ = exp(0.693) = 2.0. Treated patients survive twice as long as untreated, on average.

---

### Weibull: a member of both families

For the Weibull distribution, the hazard ratio (PH parameterisation) and the time ratio (AFT parameterisation) are related. If β_PH is the PH coefficient and β_AFT is the AFT coefficient for the same covariate:

$$\beta_\text{PH} = -k \cdot \beta_\text{AFT}$$

where k is the Weibull shape parameter. Both parameterisations describe the same underlying model — they just express the covariate effect in different units (multiplicative change in hazard vs. multiplicative change in time). The `flexsurv` package in R reports AFT coefficients by default.

---

### Model selection: AIC and BIC

When comparing parametric survival models fitted to the same data, we use information criteria.

> **Notation:** p — the number of estimated parameters in the model.

> **Notation:** n — the number of observations.

> **Notation:** logL — the maximised log-likelihood.

$$\text{AIC} = -2\,\log L + 2p \tag{5.9}$$

$$\text{BIC} = -2\,\log L + p\,\ln(n) \tag{5.10}$$

**Lower AIC (or BIC) is better.** Both criteria penalise model complexity (the 2p or p·ln(n) term), but BIC penalises more heavily for large n, favouring more parsimonious models.

Here's the key insight: AIC and BIC are only meaningful for comparing models fitted to the **same data and same set of observations**. If models differ in their handling of missing values (and thus have different effective sample sizes), direct AIC/BIC comparisons are invalid.

---

### Hypothesis tests in survival analysis

**1. Wald test (for individual coefficients):**

$$Z = \frac{\hat\beta_j}{\text{SE}(\hat\beta_j)} \overset{\text{approx}}{\sim} N(0,1) \text{ under } H_0: \beta_j = 0$$

This is the test reported by default in `summary(coxph(...))` and `summary(flexsurvreg(...))`.

**2. Likelihood ratio test (LRT) for nested models:**

$$\Lambda = 2(\log L_1 - \log L_0) \overset{\text{approx}}{\sim} \chi^2(df_1 - df_0) \text{ under } H_0 \tag{5.11}$$

where model 1 (with more parameters, df₁) is the full model and model 0 (with fewer parameters, df₀) is the restricted model. Use the LRT to test whether the additional parameters in model 1 significantly improve fit.

**Example:** The exponential model is a special case of the Weibull (with k = 1, fixing one parameter). The LRT tests H₀: k = 1.

$$\Lambda = 2(\log L_\text{Weibull} - \log L_\text{Exponential}) \overset{\text{approx}}{\sim} \chi^2(1)$$

---

## Example

Using the `lung` dataset with a Weibull AFT model (`flexsurvreg(..., dist="weibull")`), fitting sex as the only predictor, typical output:

| Parameter | Estimate | exp(Estimate) | 95% CI | Interpretation |
|---|---|---|---|---|
| shape k | 1.09 | — | (0.93, 1.27) | Slightly increasing hazard |
| β_sex | 0.44 | 1.55 | (1.17, 2.05) | Female patients survive 1.55× longer |

The time ratio for sex is exp(0.44) ≈ 1.55. Female patients survive 55% longer than males on average, after controlling for other factors — a different framing of the same sex effect estimated by the Cox model (HR ≈ 0.60, meaning 40% lower hazard for females).

## Task

Open `exercise.R`. You will:

1. Fit exponential, Weibull, log-normal, and log-logistic models using `flexsurv`.
2. Compare AIC and BIC; identify the best-fitting distribution.
3. Interpret the time ratio for sex from the best model.
4. Overlay predicted and KM curves to assess fit visually.
5. Perform an LRT comparing exponential to Weibull.

Fill in every `# TODO:` marker and run:

```
npm run check -- bdat-624 module-05 lesson-03
```

## Check

```
npm run check -- bdat-624 module-05 lesson-03
```

## Reflection

The Cox model gives a hazard ratio for treatment; the AFT model gives a time ratio. Both are valid summaries of the treatment effect. Describe a clinical scenario where you would prefer to communicate the effect as a **time ratio** rather than a **hazard ratio**. Then describe a scenario where the **hazard ratio** is more natural. Think about what information each metric conveys to a clinician, and what assumptions each requires about how the treatment acts over time.
