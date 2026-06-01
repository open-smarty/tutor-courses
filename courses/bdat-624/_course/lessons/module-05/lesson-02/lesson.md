# Lesson 2: Cox Proportional Hazards Model

## Goal

By the end of this lesson you will be able to write down and interpret the Cox proportional hazards model, explain what "semi-parametric" means in this context, compute and interpret hazard ratios with confidence intervals, describe the partial likelihood idea, and check the proportional hazards assumption using Schoenfeld residuals in R.

## Concept

### From KM curves to regression

The Kaplan-Meier curves from Lesson 1 show *whether* two groups differ in survival. But real studies involve multiple covariates — age, sex, treatment, disease severity — that may all affect the hazard simultaneously. We need a regression model for survival data that:

1. Allows us to adjust for multiple covariates simultaneously.
2. Does not discard censored observations.
3. Produces interpretable effect estimates (like hazard ratios).

The **Cox proportional hazards model**, introduced by David Cox in 1972, achieves all three goals while making only minimal distributional assumptions. It is the most widely used model in survival analysis.

---

### Connection to Arc 1

In Arc 1 we studied intensity functions for continuous-time Markov chains — the rate at which the process transitions from one state to another. The Cox model's hazard h(t|X) is an intensity function of the same flavour, but it models the time until the *first* event (transition from "alive" to "dead") as a function of individual covariates. The proportional hazards structure is analogous to a ratio of transition rates between subpopulations.

---

### The Cox model

> **Notation:** X = (X₁, X₂, ..., Xₚ) — the covariate vector for a subject (e.g., X₁ = age, X₂ = sex, X₃ = treatment group).

> **Notation:** h(t | X) — the hazard function at time t for a subject with covariates X.

> **Notation:** h₀(t) — the **baseline hazard function**. This is the hazard when all covariates are zero. Crucially, its functional form is left **completely unspecified** — it can be any non-negative function of t.

> **Notation:** β = (β₁, β₂, ..., βₚ) — the vector of regression coefficients, one per covariate. These are the parameters we estimate.

The Cox model specifies:

$$\boxed{h(t \mid X) = h_0(t) \cdot \exp(\beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p) = h_0(t) \cdot e^{\beta' X}} \tag{5.4}$$

Here's the key insight: the model separates into two parts. The baseline hazard h₀(t) captures *when* the event tends to happen (the time shape), while exp(β′X) captures *who* is at greater or lesser risk (the covariate effects). Because h₀(t) is unspecified, the Cox model is called **semi-parametric**: parametric in β, non-parametric in h₀(t).

---

### The proportional hazards assumption

Consider two subjects with covariate vectors X and X*. The ratio of their hazards is:

$$\frac{h(t \mid X)}{h(t \mid X^*)} = \frac{h_0(t)\,e^{\beta'X}}{h_0(t)\,e^{\beta'X^*}} = e^{\beta'(X - X^*)} \tag{5.5}$$

Here's the key insight: the h₀(t) cancels. The hazard ratio depends **only on the covariate difference** — it is a constant that does not change over time. This is the **proportional hazards (PH) assumption**: the hazard curves for any two subjects run parallel on the log scale, and their ratio is constant at every time point. Graphically, the KM curves for the two groups should not cross.

"Proportional hazards" does not mean the hazard is constant — it means the *ratio* of hazards between groups is constant. Within each group the hazard can be as irregular as you like.

---

### The hazard ratio

> **Notation:** HR = exp(βⱼ) — the **hazard ratio** for a 1-unit increase in covariate Xⱼ, holding all other covariates fixed.

Interpretation:
- HR = 1: covariate Xⱼ has no effect on the hazard.
- HR > 1: a 1-unit increase in Xⱼ *increases* the hazard by (HR − 1) × 100%. Shorter expected survival.
- HR < 1: a 1-unit increase in Xⱼ *decreases* the hazard by (1 − HR) × 100%. Longer expected survival (protective effect).

**Example:** Suppose β_age = 0.04, so HR_age = e^{0.04} ≈ 1.041. A patient 10 years older has a hazard that is e^{0.4} ≈ 1.49 times higher — about 49% greater risk at every time point, adjusting for other covariates.

**Example:** Suppose β_sex = −0.53 (coding: 1 = male, 2 = female), so HR_sex = e^{−0.53} ≈ 0.59. Female patients have a hazard that is 0.59 times that of males — about 41% lower hazard, or a 41% reduction in risk at every time point.

A 95% confidence interval for β̂ⱼ is β̂ⱼ ± 1.96 × SE(β̂ⱼ), and exponentiating gives a 95% CI for HRⱼ:

$$\text{95% CI for HR}_j = \left(e^{\hat\beta_j - 1.96\,\text{SE}(\hat\beta_j)},\; e^{\hat\beta_j + 1.96\,\text{SE}(\hat\beta_j)}\right) \tag{5.6}$$

---

### Partial likelihood — the idea

How do we estimate β without specifying h₀(t)? Cox's brilliant insight was that we can separate the two parts of the likelihood. At each event time t_{(j)}, given that exactly one event happened then, the probability that it happened to subject i (rather than any other subject in the risk set R(t_{(j)})) depends only on the covariate part:

$$P(\text{subject } i \text{ fails at } t_{(j)} \mid \text{one failure in } R(t_{(j)})) = \frac{e^{\beta'X_i}}{\displaystyle\sum_{l \in R(t_{(j)})} e^{\beta'X_l}} \tag{5.7}$$

The **partial likelihood** is the product of these conditional probabilities over all event times:

$$L(\beta) = \prod_{j=1}^{m} \frac{e^{\beta'X_{(j)}}}{\displaystyle\sum_{l \in R(t_{(j)})} e^{\beta'X_l}} \tag{5.8}$$

Here's the key insight: h₀(t) cancels from the numerator and denominator, so we can maximise L(β) over β without ever specifying or estimating h₀(t). The estimates β̂ obtained from this partial likelihood have the same large-sample properties (consistency, asymptotic normality) as ordinary MLE estimates.

---

### Checking the PH assumption: Schoenfeld residuals

The PH assumption — that the hazard ratio is constant over time — must be verified before trusting the Cox model output.

**Schoenfeld residuals:** For each event at time t_{(j)}, the Schoenfeld residual for covariate k is the difference between the observed covariate value and the weighted average across the risk set:

$$r_{jk} = X_{k,(j)} - \frac{\sum_{l \in R(t_{(j)})} X_{kl}\,e^{\hat\beta'X_l}}{\sum_{l \in R(t_{(j)})} e^{\hat\beta'X_l}}$$

Under the PH assumption, these residuals should show **no trend over time**. A systematic trend (e.g., increasing or decreasing pattern when plotted against event times) indicates that the hazard ratio for covariate k is not constant — the PH assumption is violated for that covariate.

In R, `cox.zph(fit)` performs a formal test (a correlation between rescaled Schoenfeld residuals and log time) and produces diagnostic plots. A significant p-value for `cox.zph` (p < 0.05) signals a violation of PH for that covariate.

---

### What to do when PH is violated

If the PH assumption fails for one covariate:

1. **Stratification:** Include the violating covariate as a stratum rather than a predictor: `coxph(Surv(...) ~ x1 + x2 + strata(x3), ...)`. Each stratum gets its own baseline hazard h₀ₖ(t), so no PH assumption is imposed on x3. We lose the ability to estimate an HR for x3, but β estimates for x1 and x2 remain valid.

2. **Time-varying coefficients:** Allow β₃ to change over time: `coxph(Surv(...) ~ x1 + x2 + tt(x3), tt = function(x, t, ...) x * log(t), ...)`. This models a changing HR and can directly estimate the time-interaction.

3. **Splitting the follow-up:** If PH holds in early follow-up but not late, split the time axis and fit separate models.

---

## Example

Consider a Cox model fitted to the `lung` dataset with predictors sex, age, and ph.karno (Karnofsky score rated by physician, 0–100). A typical output summary looks like:

| Covariate | β̂ | SE | HR | 95% CI | p |
|---|---|---|---|---|---|
| sex (female = 2) | −0.513 | 0.167 | 0.599 | (0.432, 0.831) | 0.002 |
| age | 0.017 | 0.009 | 1.017 | (0.999, 1.035) | 0.065 |
| ph.karno | −0.020 | 0.005 | 0.980 | (0.971, 0.990) | <0.001 |

Interpretation:
- **Sex:** Female patients (sex=2) have a hazard 0.60 times that of males — a 40% reduction in hazard, adjusting for age and ph.karno (p=0.002, statistically significant).
- **Age:** Each additional year of age is associated with a 1.7% increase in the hazard, but this is not statistically significant at α=0.05 (p=0.065).
- **ph.karno:** Each 1-point increase in Karnofsky score is associated with a 2% decrease in hazard. A 10-point improvement in performance status reduces the hazard by about 18% (HR = 0.98^{10} ≈ 0.82).

## Task

Open `exercise.R`. You will:

1. Fit a Cox model on `lung` with sex, age, and ph.karno.
2. Extract and interpret the hazard ratio for each predictor.
3. Check the PH assumption using `cox.zph()`.
4. Plot predicted survival curves for specific covariate profiles.

Fill in every `# TODO:` marker and run:

```
npm run check -- bdat-624 module-05 lesson-02
```

## Check

```
npm run check -- bdat-624 module-05 lesson-02
```

## Reflection

The Cox model estimates the *relative* risk between subjects but not the *absolute* survival probability — for that you need to estimate h₀(t). The Nelson-Aalen estimator of h₀(t) (the Breslow estimator) is used by R's `survfit()` applied to a `coxph` object. Why does the Cox model's ability to leave h₀(t) unspecified make it more robust than, say, an exponential regression model, even though the exponential model provides a complete predicted survival curve? Think about the trade-off between flexibility and the ability to extrapolate.
