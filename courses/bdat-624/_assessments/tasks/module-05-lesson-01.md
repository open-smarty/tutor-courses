# Task: Module 5, Lesson 1 — Kaplan-Meier Analysis of the Veteran Trial

## Dataset

Use the `veteran` dataset from the `survival` package. This is a randomised trial of two chemotherapy regimens (standard vs. test) in 137 veterans with advanced lung cancer.

```r
library(survival)
data(veteran)
# Key columns:
#   trt      : 1 = standard, 2 = test chemotherapy
#   time     : survival time in days
#   status   : 1 = dead, 0 = censored
#   celltype : cell type (squamous, smallcell, adeno, large)
#   karno    : Karnofsky performance score (0–100; higher = better)
#   diagtime : months from diagnosis to randomisation
#   age      : age in years
#   prior    : prior therapy (0 = no, 10 = yes)
```

## Tasks

**(a) Kaplan-Meier curves by treatment arm.**

Fit KM survival curves for the standard treatment arm and the test treatment arm separately. Plot both curves on the same graph with:
- Different colours for each arm
- 95% confidence bands (or at minimum, note-worthy confidence intervals)
- A legend identifying the arms
- Appropriate axis labels and a descriptive title

**(b) Median survival by treatment arm.**

Report the median survival time (in days) for each treatment arm, together with its 95% confidence interval (Greenwood-based). Present these in a small table.

**(c) Log-rank test.**

Perform a log-rank test comparing survival between the two treatment arms.
- State H₀ and H₁ explicitly.
- Report the test statistic and p-value.
- At α = 0.05, what do you conclude? Does the test chemotherapy appear to change survival compared to standard treatment?

**(d) Subgroup exploration: sex within treatment.**

Within each treatment arm, explore whether male and female patients differ in survival using KM curves and a log-rank test.
- Fit KM curves stratified by sex, separately for each treatment arm (two plots: one per arm).
- For each arm, report the log-rank p-value comparing male vs. female survival.
- Interpret your findings: is the sex difference in survival consistent across treatment arms?

## Deliverable

Submit your R script and a brief written summary (≤ 300 words) covering parts (a)–(d). The summary should be written for a clinical collaborator who is not a statistician — avoid jargon where possible.
