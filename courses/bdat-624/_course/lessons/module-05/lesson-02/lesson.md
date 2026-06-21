# Lesson 2: Cox Proportional Hazards Model

## Goal

Derive the Cox proportional hazards model, understand partial likelihood estimation, interpret hazard ratios, test the proportional hazards assumption using Schoenfeld residuals and log-log plots, and fit Cox models in R.

## Concept

### Motivation: Covariates and Survival

The Kaplan-Meier estimator describes *when* patients die, but not *why*. In a lung cancer study, we want to know: does sex affect survival after controlling for age, performance status, and weight loss? The **Cox proportional hazards model** is the most widely used regression model for survival data because it handles censoring correctly and avoids specifying the baseline hazard.

### The Cox PH Model

> **Notation block:**
> - h(t|X) — the **conditional hazard** for a patient with covariate vector X = (X₁, X₂, ..., Xₚ); read "hazard at time t given covariates X"
> - h₀(t) — the **baseline hazard function**: the hazard for a patient with all covariates equal to zero; it is unspecified (non-parametric); read "h sub zero of t"
> - β = (β₁, ..., βₚ) — the **regression coefficients** (log-hazard ratios); estimated from data
> - exp(βⱼXⱼ) — the **relative risk** contribution from covariate Xⱼ; read "exponential of beta_j times X_j"

The Cox model specifies:

$$h(t \mid \mathbf{X}) = h_0(t) \cdot \exp(\beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p)$$

**Key insight:** The baseline hazard h₀(t) captures how risk evolves over time (the "shape"), while exp(β⊤X) scales the entire hazard curve up or down for each patient. The ratio of hazards for two patients with covariates X and X* does not depend on t:

$$\frac{h(t \mid \mathbf{X})}{h(t \mid \mathbf{X}^*)} = \frac{\exp(\boldsymbol{\beta}^\top \mathbf{X})}{\exp(\boldsymbol{\beta}^\top \mathbf{X}^*)} = \exp\!\left(\boldsymbol{\beta}^\top (\mathbf{X} - \mathbf{X}^*)\right)$$

This constant ratio is the **proportional hazards (PH) assumption**: two patients' hazard curves are proportional (parallel on the log-hazard scale) at all times.

### Hazard Ratios

> **Notation block:**
> - HR = exp(βⱼ) — the **hazard ratio** for a one-unit increase in Xⱼ, holding all other covariates fixed; read "exponential of beta_j"
> - HR > 1 — the covariate is associated with higher hazard (worse survival)
> - HR < 1 — the covariate is associated with lower hazard (better survival)
> - HR = 1 — no association with survival

For a binary covariate (e.g., sex = 0 for male, 1 for female), exp(β_sex) is the ratio of the female hazard to the male hazard at any time t. If exp(β_sex) = 0.60, females have 40% lower instantaneous risk of death at every time point.

### Partial Likelihood Estimation

Cox's insight was that β can be estimated **without specifying h₀(t)**, using the **partial likelihood**. At each event time tᵢ (when exactly one patient dies, for simplicity), the conditional probability that patient i died, given that one death occurred at tᵢ among the risk set R(tᵢ), is:

> **Notation block:**
> - R(tᵢ) — the **risk set** at tᵢ: all patients still at risk (alive, uncensored) just before tᵢ
> - Lᵢ(β) — the conditional likelihood contribution at event time tᵢ

$$L_i(\boldsymbol{\beta}) = \frac{\exp(\boldsymbol{\beta}^\top \mathbf{X}_i)}{\sum_{j \in R(t_i)} \exp(\boldsymbol{\beta}^\top \mathbf{X}_j)}$$

The partial likelihood is the product over all observed event times:

$$PL(\boldsymbol{\beta}) = \prod_{i: \delta_i = 1} \frac{\exp(\boldsymbol{\beta}^\top \mathbf{X}_i)}{\sum_{j \in R(t_i)} \exp(\boldsymbol{\beta}^\top \mathbf{X}_j)}$$

**Why "partial"?** We are conditioning on the set of times at which events occur, not modelling the inter-event waiting times. The baseline hazard drops out of the likelihood — it cancels in the ratio. This makes estimation semi-parametric: β is estimated parametrically, h₀(t) non-parametrically.

**The log-partial likelihood** is maximised numerically to obtain β̂. Standard errors come from the observed information matrix (negative Hessian of the log partial likelihood).

### Testing Coefficients: Wald, LR, and Score Tests

For a single coefficient βⱼ, the **Wald test** is:

$$z = \frac{\hat\beta_j}{\mathrm{SE}(\hat\beta_j)} \sim N(0,1) \text{ under } H_0:\beta_j = 0$$

or equivalently z² ~ χ²(1). The **likelihood ratio test** compares the full model to a model without covariate j:

$$LR = 2[\log PL(\hat\boldsymbol\beta) - \log PL(\hat\boldsymbol\beta_{-j})] \sim \chi^2(1)$$

### Testing the Proportional Hazards Assumption

The PH assumption — that hazard ratios are constant over time — must be checked. Two standard approaches:

**Schoenfeld residuals.** For each covariate j and each event time tᵢ, the Schoenfeld residual is the difference between the observed covariate value of the patient who died and the expected value under the model:

$$r_{ij} = X_{ij} - \hat{E}[X_j \mid R(t_i)]$$

> **Notation block:**
> - r_{ij} — Schoenfeld residual for covariate j at event time tᵢ; read "r sub i j"
> - cox.zph() — R function that tests whether scaled Schoenfeld residuals are correlated with time (slope ≠ 0 would indicate time-varying effects)

Under PH, Schoenfeld residuals should have no trend over time. `cox.zph()` in R tests the correlation of scaled Schoenfeld residuals with time; a significant p-value indicates violation of PH.

**Log-log plot.** Plot log(−log(Ŝ(t))) vs log(t) for each group. Under proportional hazards, these curves should be **parallel** (constant vertical distance = log(HR)):

$$\log(-\log S_k(t)) = \log(-\log S_0(t)) + \boldsymbol{\beta}^\top \mathbf{X}_k$$

Crossing or converging log-log curves indicate non-proportional hazards.

## Example

**Lung cancer dataset.**

```r
library(survival)
library(survminer)

# Fit Cox model with sex, age, and ph.ecog (performance status)
cox_fit <- coxph(Surv(time, status==2) ~ sex + age + ph.ecog, data = lung)
summary(cox_fit)
```

Key output:
- `coef` = β̂ (log hazard ratio)
- `exp(coef)` = hazard ratio HR
- `Pr(>|z|)` = Wald p-value for H₀: βⱼ = 0
- Concordance statistic (C-index): fraction of correctly ordered pairs

A sex coefficient of −0.53 means exp(−0.53) ≈ 0.59: females have a 41% lower hazard than males after adjusting for age and performance status.

```r
# Check PH assumption
cox_zph_test <- cox.zph(cox_fit)
ggcoxzph(cox_zph_test)  # plot Schoenfeld residuals vs time
```

```r
# Forest plot of hazard ratios
ggforest(cox_fit, data = lung)
```

## Task

See `exercise.R`. You will fit a Cox PH model to the `lung` dataset, interpret hazard ratios, test the PH assumption with Schoenfeld residuals and log-log plots, and compare nested models with the likelihood ratio test.

## Check

```
npm run check -- bdat-624 module-05 lesson-02
```

## Reflection

The Cox model estimates hazard ratios without specifying h₀(t). This flexibility is a strength — but what do you lose? If you need to predict the absolute survival probability S(t|X) for a new patient (e.g., for a clinical decision support tool), you need to estimate h₀(t) as well. R's `basehaz()` function provides the Breslow estimator of H₀(t). How does the Breslow estimator work, and what assumptions does it make? In what clinical context would absolute survival prediction matter more than the hazard ratio alone?
