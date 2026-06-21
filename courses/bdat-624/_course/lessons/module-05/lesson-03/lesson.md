# Lesson 3: Parametric Survival Models and AFT

## Goal

Understand the Accelerated Failure Time (AFT) parameterisation; derive the Weibull AFT model and its equivalence to a Weibull proportional hazards model; fit parametric survival models in R using `survreg()` and `flexsurv::flexsurvreg()`; and select among distributional families using AIC and BIC.

## Concept

### Motivation: Going Fully Parametric

The Cox model leaves h₀(t) unspecified. This is advantageous when you don't know the hazard shape — but it means you cannot predict the absolute baseline hazard without additional estimation. If you are willing to assume a specific distributional family (Exponential, Weibull, log-normal, log-logistic, Gamma), you gain:

1. A fully specified model for direct survival probability prediction
2. Potentially more efficient estimates when the distributional assumption holds
3. A clearer mechanistic interpretation via the scale/shape parameters

The cost: if the distributional assumption is wrong, estimates can be biased.

### The Accelerated Failure Time (AFT) Framework

The AFT model specifies a linear model on the log of survival time:

> **Notation block:**
> - T — event time (positive random variable)
> - log(T) = μ + β₁X₁ + ... + βₚXₚ + σε — the AFT linear model; read "log T equals mu plus covariates plus scale times error"
> - μ — intercept (baseline log-time)
> - βⱼ — **AFT coefficient**: effect of covariate Xⱼ on log(T); read "beta_j"
> - σ — **scale parameter**: controls the spread of the distribution; read "sigma"
> - ε — **error term**: follows a specified distribution (extreme value, logistic, normal, etc.) that determines the survival distribution family

$$\log(T) = \mu + \beta_1 X_1 + \cdots + \beta_p X_p + \sigma\varepsilon$$

**Key interpretation:** A unit increase in Xⱼ **accelerates or decelerates** the event time by a factor of exp(βⱼ). Specifically:

$$\frac{T \mid X_j = x+1}{T \mid X_j = x} = e^{\beta_j}$$

- If βⱼ > 0 (exp(βⱼ) > 1): the event is delayed — the covariate **prolongs** survival
- If βⱼ < 0 (exp(βⱼ) < 1): the event is accelerated — the covariate **shortens** survival

**Caution on sign conventions.** In the Cox model, a positive coefficient means higher hazard (worse survival). In the AFT model, a positive coefficient means longer survival time. The signs of the AFT and Cox coefficients are *opposite* in sign (roughly).

### Parametric Families: Choosing the Error Distribution

The choice of ε determines the distributional family for T:

| Distribution of ε | Distribution of T | Hazard shape |
|---|---|---|
| Extreme value (Gumbel) | Weibull | Monotone (increasing/decreasing) |
| Logistic | Log-logistic | Unimodal (rises then falls) |
| Normal | Log-normal | Unimodal |
| Extreme value with shape=1 | Exponential | Constant |

### The Weibull Distribution

The Weibull is the most commonly used parametric family because it is both an AFT model and a PH model.

> **Notation block:**
> - α — **shape parameter** (also written k); α > 1: increasing hazard; α = 1: exponential (constant hazard); 0 < α < 1: decreasing hazard; read "alpha"
> - λ — **scale parameter** (also written 1/β or η); read "lambda"

**Weibull hazard, survival, and density:**

$$h(t) = \frac{\alpha}{\lambda}\left(\frac{t}{\lambda}\right)^{\alpha-1}$$

$$S(t) = \exp\!\left(-\left(\frac{t}{\lambda}\right)^\alpha\right)$$

$$f(t) = \frac{\alpha}{\lambda}\left(\frac{t}{\lambda}\right)^{\alpha-1}\exp\!\left(-\left(\frac{t}{\lambda}\right)^\alpha\right)$$

**Special cases:** α=1 gives the Exponential(1/λ). As α increases beyond 1, the hazard rises monotonically (ageing). For 0 < α < 1, the hazard decreases (high early risk, declining over time — e.g., post-surgery mortality).

### Weibull AFT ↔ PH Duality

The Weibull model belongs to both the AFT and PH families. The conversion between parameterisations is:

$$\text{AFT coefficient } \beta^{\text{AFT}}_j = -\frac{\beta^{\text{PH}}_j}{\alpha}$$

> **Notation block:**
> - β^{PH}_j — Cox/PH log-hazard ratio coefficient for covariate j
> - β^{AFT}_j — AFT log-time-ratio coefficient (from survreg()) for covariate j
> - α — Weibull shape parameter (= 1/scale in survreg() output)

This means for Weibull models, you can move freely between the two interpretations. For non-Weibull families (log-normal, log-logistic), only the AFT interpretation applies.

### Model Selection: AIC and BIC

> **Notation block:**
> - ℓ — log-likelihood of the fitted model; read "ell"
> - k — number of estimated parameters
> - n — number of observations (uncensored + censored)
> - AIC = −2ℓ + 2k — Akaike Information Criterion; lower is better; penalises complexity lightly
> - BIC = −2ℓ + k·log(n) — Bayesian Information Criterion; lower is better; penalises complexity more heavily for large n

When comparing Exponential, Weibull, log-normal, and log-logistic models:
1. Fit each with `flexsurvreg(distribution = "...")` from the `flexsurv` package
2. Compare AIC (and BIC) — the model with the lowest AIC is preferred
3. Also check goodness-of-fit visually: plot observed KM against fitted S(t)

### R Implementation

**survreg() — standard AFT fitting:**
```r
library(survival)
# Weibull AFT (default dist="weibull")
aft_weibull <- survreg(Surv(time, event) ~ sex + age + ph.ecog,
                       data = lung_cc, dist = "weibull")
summary(aft_weibull)
# Output: Intercept + AFT coefficients + Log(scale) [= -log(shape)]
```

**flexsurv — flexible parametric models and AIC comparison:**
```r
library(flexsurv)
fs_exp    <- flexsurvreg(Surv(time, event) ~ sex, data=lung_cc, dist="exp")
fs_weib   <- flexsurvreg(Surv(time, event) ~ sex, data=lung_cc, dist="weibull")
fs_lnorm  <- flexsurvreg(Surv(time, event) ~ sex, data=lung_cc, dist="lnorm")
fs_llogis <- flexsurvreg(Surv(time, event) ~ sex, data=lung_cc, dist="llogis")
# Compare AIC:
AIC(fs_exp, fs_weib, fs_lnorm, fs_llogis)
```

## Example

**Lung cancer — Weibull AFT model.**

```r
library(survival)
data(lung)
lung_cc <- lung |> dplyr::mutate(event = ifelse(status==2,1,0)) |>
           dplyr::filter(!is.na(ph.ecog))
aft_fit <- survreg(Surv(time, event) ~ sex, data=lung_cc, dist="weibull")
summary(aft_fit)
```

Suppose the output gives β̂_sex = 0.40, scale = 0.75 (so α = 1/0.75 ≈ 1.33). Then:
- exp(β̂_sex) = exp(0.40) ≈ 1.49: females survive about 49% longer than males (median time ratio)
- Weibull shape α = 1/0.75 ≈ 1.33 > 1: hazard increases over time (lung cancer becomes more lethal as disease progresses)
- Cox PH equivalent: β̂^{PH}_sex ≈ −β̂^{AFT}_sex × α = −0.40 × 1.33 ≈ −0.53

The Cox model gave β̂_sex ≈ −0.53 in the previous lesson — consistent with the Weibull AFT result under the duality relationship.

## Task

See `exercise.R`. You will fit Exponential, Weibull, log-normal, and log-logistic AFT models to the lung dataset using `flexsurv::flexsurvreg()`, compare AIC, plot fitted survival curves against the KM estimate, and interpret Weibull AFT coefficients in terms of median survival time ratios.

## Check

```
npm run check -- bdat-624 module-05 lesson-03
```

## Reflection

The AFT and PH parameterisations offer different lenses on the same data. A clinical oncologist might prefer the AFT interpretation ("the treatment delays death by 30%") over the PH interpretation ("the treatment reduces the instantaneous risk by 25%"). But a statistician designing an adaptive trial might prefer the PH framework because the log-rank test is most powerful under PH. When would you choose a parametric AFT model over the semi-parametric Cox model? Consider: small samples, the need to extrapolate survival beyond the study period, and regulatory requirements for health economic modelling (where long-run survival predictions are required for cost-effectiveness analysis).
