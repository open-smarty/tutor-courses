# Task: Insurance Cross-Sell Recommendations from Association Rules

## Objective

Mine association rules from the health insurance add-on cover flags and translate the findings into actionable product cross-sell recommendations.

## Instructions

1. **Prepare** — Generate `health_small` (n = 10000, seed = 602). Create a binary data frame with columns: `dental_cover`, `vision_cover`, `mental_cover`, `maternity_cover`, and a bucketed variable `is_high_tier` (TRUE if `plan_tier %in% c("Gold", "Platinum")`). Convert to `transactions`.

2. **Mine** — Run Apriori with `supp = 0.05`, `conf = 0.50`, `minlen = 2`.

3. **Filter and analyse** — For each of the four add-on covers, find the top rule (by confidence) where that cover appears on the right-hand side. Fill in this table:

| Target cover | LHS | Confidence | Lift | Recommendation |
|---|---|---|---|---|
| dental_cover | ? | ? | ? | "Offer dental to customers who buy…" |
| vision_cover | ? | ? | ? | ... |
| mental_cover | ? | ? | ? | ... |
| maternity_cover | ? | ? | ? | ... |

4. **Confounding** — `is_high_tier` is included in your transactions. Check whether any of your cross-sell rules disappear or have their lift drop below 1.2 when you restrict the analysis to Gold/Platinum policyholders only (`subset(rules, lhs %pin% "is_high_tier")`). Discuss whether plan tier is a confounder.

## Submission

Knit your Rmd to HTML with the table filled in and the confounding analysis visible.
