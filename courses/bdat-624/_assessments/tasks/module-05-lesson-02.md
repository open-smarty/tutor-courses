# Task: Cox Proportional Hazards Model

## Objective

Fit a Cox proportional hazards model to the NCCTG lung cancer dataset, interpret hazard ratios, test the proportional hazards assumption using two complementary methods, compare nested models with a likelihood ratio test, and predict absolute survival for a new patient.

## Instructions

1. **Fit the Cox model.** Using complete cases (drop rows with missing `ph.ecog`), fit `coxph(Surv(time, event) ~ sex + age + ph.ecog, data=lung_cc)`. From `summary()`, extract and report: the estimated log-hazard ratio, hazard ratio (exp(coef)), 95% CI, and Wald p-value for each covariate. State which covariates are significant at α=0.05. Report the concordance statistic.

2. **Forest plot.** Use `ggforest(cox_fit, data=lung_cc)` to create a hazard ratio forest plot. Identify the covariate with the strongest effect on survival and describe the direction of each effect.

3. **Schoenfeld residual test.** Run `cox.zph(cox_fit)` and print the result. Plot residuals with `ggcoxzph()`. For each covariate, state whether the PH assumption holds (p > 0.05). Describe what a non-flat smooth line in the residual plot would imply.

4. **Log-log plot.** Fit a stratified KM model for sex. Plot `log(−log(Ŝ(t)))` vs `log(t)` using `ggsurvplot(..., fun="cloglog")`. Comment on whether the curves are approximately parallel. Relate your observation to the Schoenfeld test result for sex.

5. **Likelihood ratio test.** Fit a reduced model (sex only). Compute LR = 2×(loglik_full − loglik_reduced), degrees of freedom = difference in number of parameters, and the p-value from `pchisq()`. Cross-check using `anova(cox_sex, cox_fit)`. State whether age and ph.ecog significantly improve the model.

6. **Absolute survival prediction.** Extract the Breslow baseline cumulative hazard with `basehaz(cox_fit, centered=FALSE)`. For a 60-year-old male with ECOG=1, compute the linear predictor β̂⊤X, then S(t|X) = exp(−H₀(t)·exp(β̂⊤X)). Plot the predicted survival curve. Report the estimated 1-year survival probability.

## Submission

Submit your completed `exercise.R`. Requirements:
- Cox model summary with interpretation of each coefficient
- Hazard ratio forest plot
- Schoenfeld residual plot and test output with interpretation
- Log-log plot with commentary on parallelism
- LR test output and conclusion
- Predicted survival plot and estimated 1-year survival for the specified patient profile
- Pass `npm run check -- bdat-624 module-05 lesson-02`
