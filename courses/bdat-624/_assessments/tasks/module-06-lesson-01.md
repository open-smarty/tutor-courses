# Task: Competing Risks and Multi-State Models

## Objective

Demonstrate why standard Kaplan-Meier estimates are biased in the presence of competing risks; estimate and compare Cumulative Incidence Functions using `cmprsk::cuminc()`; apply Gray's test; fit a Fine-Gray subdistribution hazard model; and build a 3-state multi-state model using the `mstate` package.

## Instructions

1. **Simulate the dataset.** Use the code provided in `exercise.R` with `set.seed(2024)` to generate n=300 patients with competing risks (cause 1=relapse, cause 2=TRM) and a binary group covariate. Summarise event counts by cause and group.

2. **KM vs CIF comparison.** Fit a naive KM curve for relapse, treating TRM as censoring (`event_naive = ifelse(cause==1, 1, 0)`). Fit CIFs using `cuminc(ftime=, fstatus=)`. Plot `1−KM` and the cause-1 CIF on the same axes. At t=400 days, compute both estimates and report how much the KM over-estimates P(relapse). Explain in one sentence why the KM is biased.

3. **Stratified CIFs and Gray's test.** Run `cuminc(ftime=, fstatus=, group=cr_data$group)`. Print `$Tests` and interpret the Gray's test p-values for each cause. Plot all four CIF curves (two groups × two causes) using `ggplot`. Describe which cause differs most between groups, and whether this difference is consistent with the simulation parameters.

4. **Fine-Gray model.** Fit `crr(ftime=, fstatus=, cov1=group_matrix, failcode=1, cencode=0)` for relapse. Print the summary. Compute and interpret `exp(coef)` for group. Explain why the subdistribution hazard ratio may not have the same direction as the cause-specific hazard ratio for relapse between groups.

5. **Multi-state model.** Using the code provided, build a 3-state model (Healthy → Relapse → Dead; Healthy → Dead directly). Fit `coxph(Surv(Tstart, Tstop, status) ~ group + strata(trans), id=id, data=ms_rows)`. Print the summary. Identify the transition most affected by group. Connect the transition intensity matrix Q to the generator matrix from Module 2 — write one sentence describing this relationship.

## Submission

Submit your completed `exercise.R`. Requirements:
- Printed event count table
- KM vs CIF plot with quantitative comparison at t=400
- Stratified CIF plot with Gray's test results and interpretation
- Fine-Gray model summary with exp(coef) interpreted
- Multi-state Cox model summary with written connection to Arc 1 theory
- Pass `npm run check -- bdat-624 module-06 lesson-01`
