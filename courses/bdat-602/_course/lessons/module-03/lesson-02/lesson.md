# Lesson 2: Mining Rules from the Health Insurance Dataset

## Goal

Convert the binary add-on cover flags in the health insurance dataset to a `transactions` object, mine association rules with `arules`, interpret the rules in a business context, and visualise them with `arulesViz`.

## Concept

### From a Data Frame to Transactions

The insurance dataset has four binary add-on cover columns:
- `dental_cover`, `vision_cover`, `mental_cover`, `maternity_cover`

Plus other binary flags useful for rule mining:
- `smoker`, `auto_pay`, `churned`, `fraud_flag`, `high_risk`

To mine rules, convert these to an `arules` `transactions` object:

```r
library(arules)
library(dplyr)
source("R/simulate_bdat602_data.R")

health_small <- simulate_bdat602(n = 10000, seed = 602)

# Select binary flag columns
bin_cols <- c("dental_cover", "vision_cover", "mental_cover",
              "maternity_cover", "smoker", "auto_pay",
              "churned", "fraud_flag", "high_risk")

# Bucket plan_tier and region for richer rules
health_bin <- health_small |>
  select(all_of(bin_cols), plan_tier, region) |>
  mutate(
    is_gold_platinum = as.integer(plan_tier %in% c("Gold", "Platinum")),
    is_na_europe     = as.integer(region %in% c("North America", "Europe"))
  ) |>
  select(-plan_tier, -region) |>
  mutate(across(everything(), as.logical))

trans <- as(health_bin, "transactions")
summary(trans)
itemFrequencyPlot(trans, topN = 8, type = "absolute",
                  main = "Item Frequency: Insurance Flags")
```

---

### Mining Rules

```r
rules_ins <- apriori(
  trans,
  parameter = list(supp = 0.05, conf = 0.50, minlen = 2)
)

# Sort by lift, inspect top 10
inspect(head(sort(rules_ins, by = "lift"), 10))
```

---

### Filtering Rules for Business Insights

```r
# Rules that predict dental_cover on the right-hand side
dental_rules <- subset(rules_ins, rhs %pin% "dental_cover")
inspect(sort(dental_rules, by = "confidence"))

# Rules involving high-risk policyholders
highrisk_rules <- subset(rules_ins,
                         lhs %pin% "high_risk" | rhs %pin% "high_risk")
inspect(sort(highrisk_rules, by = "lift"))
```

---

### Visualisation

```r
library(arulesViz)

# Scatter plot: support vs confidence, colour = lift
plot(rules_ins, measure = c("support", "confidence"), shading = "lift",
     main = "Insurance Rules: Support vs Confidence")

# Matrix plot (compact for many rules)
plot(rules_ins, method = "matrix", measure = "lift")

# Graph for top 15 rules by lift
top15 <- head(sort(rules_ins, by = "lift"), 15)
plot(top15, method = "graph",
     control = list(type = "items", main = "Top 15 Rules by Lift"))
```

---

### Business Interpretation

A rule like:
```
{is_gold_platinum, mental_cover} => {dental_cover}
```
with support = 0.12, confidence = 0.84, lift = 1.9 means:

- 12 % of all policyholders have both Gold/Platinum tier and mental health cover *and* dental cover
- 84 % of Gold/Platinum + mental health cover holders *also* have dental cover
- This co-occurrence is 1.9× more likely than if the items were independent

**Business action:** When a customer upgrades to Gold/Platinum and adds mental cover, proactively offer dental cover — there is a strong natural bundling pattern.

## Example

```r
# Cross-sell insight: which covers bundle with maternity?
mat_rules <- subset(rules_ins, lhs %pin% "maternity_cover")
inspect(sort(mat_rules, by = "confidence"))
```

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Generate `health_small`, extract the four add-on cover columns plus `smoker` and `high_risk`, convert to `transactions`, and call `summary()`.
2. Run `apriori()` with `supp = 0.05`, `conf = 0.45`. How many rules are generated?
3. Filter for rules where `dental_cover` appears on the right-hand side. Print the top 3 by confidence.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-03 lesson-02
```

## Reflection

You discover the rule `{vision_cover} => {dental_cover}` with lift = 2.1 and confidence = 0.78. A product manager says: "Great — vision cover *causes* people to buy dental cover." What is wrong with this interpretation, and what would a more accurate statement be?
