# Task: Parametric Survival Models and AFT

## Objective

Fit and compare Exponential, Weibull, log-normal, and log-logistic survival models to the NCCTG lung cancer dataset, interpret AFT coefficients as survival time ratios, verify the Weibull AFT–PH duality, and select the best-fitting distribution using AIC and visual goodness-of-fit.

## Instructions

1. **Exponential AFT model.** Fit `survreg(Surv(time, event) ~ sex + ph.ecog, data=lung_cc, dist="exponential")`. For the `sex` coefficient, compute `exp(coef_sex)` and state how much longer females are estimated to survive than males. Compare the log-likelihood to the Weibull model to see the cost of the exponential constraint.

2. **Weibull AFT model.** Fit `survreg(... dist="weibull")`. Extract `aft_weib$scale` (= σ) and compute the Weibull shape α = 1/σ. State whether α > 1, α = 1, or α < 1 and explain what this implies about the lung cancer hazard shape. Verify the AFT–PH duality: compute β̂^{PH}_{sex} ≈ −β̂^{AFT}_{sex} × α and compare to the Cox result from Lesson 2 (which was approximately −0.53).

3. **Distribution comparison with flexsurv.** Fit all four distributions (`"exp"`, `"weibull"`, `"lnorm"`, `"llogis"`) using `flexsurvreg(Surv(time, event) ~ sex + ph.ecog, ...)`. Build a table of AIC and BIC values, sorted by AIC. Identify the best model. Write one sentence explaining why a non-monotone hazard distribution might fit lung cancer survival data better than Weibull.

4. **Goodness-of-fit plot.** Fit each of the four distributions as intercept-only models. Build a ggplot overlaying the KM step function against all four parametric fitted curves (dashed lines). Which distributional family visually tracks the KM curve most closely, especially in the tail?

5. **Weibull hazard shape.** Using the intercept-only Weibull estimates (shape and scale from `flexsurvreg`), compute and plot h(t) = (α/λ)(t/λ)^{α−1} over the observed time range. Describe the shape of the hazard and relate it to the clinical course of advanced lung cancer.

## Submission

Submit your completed `exercise.R`. Requirements:
- Exponential and Weibull `survreg()` summaries with coefficient interpretation
- Printed AFT–PH duality verification
- AIC/BIC comparison table (printed and sorted)
- GOF plot: KM vs all four parametric models (ggplot, dashed lines)
- Weibull hazard function plot with interpretation comment
- Pass `npm run check -- bdat-624 module-05 lesson-03`
