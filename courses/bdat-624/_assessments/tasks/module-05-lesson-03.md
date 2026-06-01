# Task: Module 5, Lesson 3 — Parametric Survival Analysis of the Veteran Trial

## Dataset

Use the `veteran` dataset from the `survival` package.

```r
library(survival)
library(flexsurv)
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

**(a) Fit a Weibull AFT model.**

Using `flexsurvreg(..., dist = "weibull")`, fit a Weibull AFT model with `trt`, `age`, and `karno` as predictors.

- Report the time ratio (TR) for each predictor with its 95% confidence interval.
- Present the results in a table with columns: Predictor, TR, 95% CI lower, 95% CI upper, p-value.

**(b) Interpret the treatment time ratio.**

Provide a plain-language interpretation of the time ratio for `trt` (treatment group). Your interpretation should be understandable to a clinician who is not familiar with statistical modelling. Specifically:

- Is the effect of the test chemotherapy beneficial or harmful?
- By approximately what factor does the test treatment multiply the expected survival time?
- Is the effect statistically significant?

**(c) Model comparison: Weibull AFT vs Cox.**

Fit a Cox proportional hazards model with the same three predictors (`trt`, `age`, `karno`).

- Report the AIC and BIC for the Weibull AFT model and the AIC for the Cox model.
  (Note: the Cox model's AIC is based on the partial likelihood, so direct AIC comparison with a fully parametric model should be interpreted cautiously — mention this limitation in your answer.)
- Which model would you prefer for this dataset, and why? Consider: (1) which predictors are significant in each model; (2) whether the Weibull shape parameter k differs meaningfully from 1 (i.e., whether the non-constant hazard matters); (3) whether you need absolute survival time predictions or just relative comparisons between groups.

**(d) Predict median survival.**

Using your fitted Weibull AFT model, predict the median survival time (in days) for the following patient profile:

- Male (if the dataset has a sex variable; otherwise omit)
- Age: 60 years
- Karnofsky score: 70
- Treatment: standard (trt = 1)

Report the predicted median survival time and its 95% confidence interval. Show your R code.

## Deliverable

Submit your R script and a written summary (≤ 400 words) covering parts (a)–(d). The summary for part (c) should include your model recommendation and a brief justification.
