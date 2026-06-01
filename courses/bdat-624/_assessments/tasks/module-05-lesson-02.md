# Task: Module 5, Lesson 2 — Cox PH Model on the Veteran Trial

## Dataset

Use the `veteran` dataset from the `survival` package.

```r
library(survival)
data(veteran)
# Key columns:
#   trt      : 1 = standard, 2 = test chemotherapy
#   time     : survival time in days
#   status   : 1 = dead, 0 = censored
#   karno    : Karnofsky performance score (0–100)
#   diagtime : months from diagnosis to randomisation
#   age      : age in years
#   prior    : prior therapy (0 = no, 10 = yes)
```

## Tasks

**(a) Fit the Cox PH model.**

Fit a Cox proportional hazards model with the following predictors: `trt`, `age`, `karno`, and `diagtime`. Print the full model summary.

**(b) Significant predictors and hazard ratios.**

- Which predictors are statistically significant at α = 0.05?
- For each significant predictor, report the estimated hazard ratio with its 95% confidence interval and provide a one-sentence plain-language interpretation (e.g., "Each 10-point increase in Karnofsky score is associated with a ___% reduction in the hazard of death.").

**(c) PH assumption check.**

- Run `cox.zph()` on your fitted model. Print the results.
- Plot the Schoenfeld residuals for each covariate.
- Does any covariate show evidence of violating the PH assumption? (Report the covariate name and the p-value from `cox.zph`.)

**(d) Handling a PH violation (conceptual).**

If you found that one covariate violates the PH assumption:
- Describe two strategies for handling this violation (stratification and time-varying coefficients).
- For your specific covariate, which approach would you prefer and why? You do not need to implement the fix — a clear conceptual explanation (4–6 sentences) is sufficient.

## Deliverable

Submit your R script and a written summary covering (a)–(d). The summary for (b) should be written so that a clinical collaborator with no statistics background can understand the direction and magnitude of each significant effect.
