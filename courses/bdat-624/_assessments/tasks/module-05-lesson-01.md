# Task: Survival Functions and Kaplan-Meier Estimation

## Objective

Fit Kaplan-Meier survival curves to the NCCTG lung cancer dataset, verify Greenwood's variance formula manually, perform the log-rank test, and visualise the cumulative hazard to assess the exponential assumption.

## Instructions

1. **Overall KM curve.** Using `lung` from the `survival` package (recode `status==2` as event=1), fit an unstratified KM model with `survfit(Surv(time, event) ~ 1, data=lung)`. Print survival probabilities at t ∈ {180, 365, 547, 730} days. Plot with `ggsurvplot()` including confidence intervals, a risk table, and the median survival line (`surv.median.line = "hv"`).

2. **Stratified KM by sex.** Fit `survfit(Surv(time, event) ~ sex, data=lung)`. Print estimated survival at t=365 for each group. Plot both curves with `pval=TRUE` (log-rank p-value on plot), confidence intervals, and a risk table. Label the legend "Male" / "Female".

3. **Greenwood variance — manual.** Filter to male patients (sex=1) and fit a KM model for males. Extract the KM table (`$time`, `$n.risk`, `$n.event`, `$surv`). At t=365, compute the Greenwood sum ∑ dᵢ / [nᵢ(nᵢ − dᵢ)] over all event times ≤ 365, then compute Var = Ŝ(365)² × sum and construct a 95% CI. Cross-check against `summary(km_male, times=365)$lower` and `$upper`.

4. **Log-rank test.** Run `survdiff(Surv(time, event) ~ sex, data=lung)`. Extract the chi-squared statistic and compute the p-value with `pchisq()`. State whether you reject H₀ at α = 0.05, and interpret what this means biologically.

5. **Cumulative hazard.** Compute H_hat(t) = −log(Ŝ(t)) for males. Estimate a constant hazard rate λ = (total events) / (total person-time). Plot H_hat as a step function and overlay the exponential line λ×t. Interpret the shape: does the exponential model fit well, or is there evidence of increasing/decreasing hazard?

## Submission

Submit your completed `exercise.R`. Requirements:
- Overall KM plot with CI, risk table, and median line
- Stratified KM plot (sex) with log-rank p-value
- Greenwood manual CI with printed comparison to survminer output
- Log-rank test result with interpretation
- Cumulative hazard plot with exponential overlay and written comment
- Pass `npm run check -- bdat-624 module-05 lesson-01`
