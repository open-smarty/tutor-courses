# Task: Rule Mining Sensitivity Analysis

## Objective

Explore how support and confidence thresholds affect the number and quality of rules discovered by Apriori.

## Instructions

Using the `Groceries` dataset:

1. **Baseline** — Run Apriori with `supp = 0.01`, `conf = 0.30`. Record the number of rules.

2. **Sensitivity grid** — Run Apriori for each combination in this grid and record rule counts:

| supp | conf | Rules |
|------|------|-------|
| 0.005 | 0.30 | ? |
| 0.01 | 0.30 | ? |
| 0.02 | 0.30 | ? |
| 0.01 | 0.20 | ? |
| 0.01 | 0.40 | ? |
| 0.01 | 0.50 | ? |

3. **Top rules** — From the baseline run, identify and print the top 5 rules by lift. For each rule, interpret it in one sentence: "When customers buy X, they also tend to buy Y because…"

4. **Visualisation** — Create a scatter plot of the baseline rules with `arulesViz::plot(rules, measure = c("support", "confidence"), shading = "lift")`.

5. **Recommendation** — Based on your sensitivity analysis, which threshold combination would you recommend for a retail analyst wanting a manageable set of high-quality rules (< 200 rules, lift > 2)? Justify your answer.

## Submission

Knit your Rmd to HTML with the sensitivity grid filled in as a markdown table and the scatter plot visible.
