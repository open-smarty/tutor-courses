# Lesson 7: Mining Rules from the Health Insurance Dataset

## Goal

After this lesson you can convert the insurance add-on flag columns into an `arules` transaction object, mine rules with `apriori()`, visualise them with `arulesViz`, and translate the strongest rules into actionable business recommendations.

## Concept

### Preparing insurance data as transactions

The `arules` package expects an object of class `transactions`, where each row is a "basket" of items and each column is a binary item indicator. Our health insurance dataset already has four binary add-on columns: `dental_cover`, `vision_cover`, `mental_cover`, and `maternity_cover`. We also include `plan_tier` and `smoker` as categorical items to discover richer cross-variable rules.

**Step 1**: Select the binary flag columns and convert each 0/1 column to a logical (TRUE/FALSE). `arules::as()` then treats each TRUE as "item is in this transaction."

```r
flag_cols <- c("dental_cover", "vision_cover", "mental_cover", "maternity_cover")

trans_df <- health_data |>
  select(all_of(flag_cols)) |>
  mutate(across(everything(), as.logical))

trans <- as(trans_df, "transactions")
```

**Step 2**: Inspect what `arules` sees.

```r
summary(trans)
itemFrequencyPlot(trans, topN = 4, type = "relative",
                  main = "Item Frequency — Insurance Add-ons")
```

`itemFrequencyPlot()` shows that `dental_cover` has the highest frequency (~35%), followed by `vision_cover` (~30%), `mental_cover` (~28%), and `maternity_cover` (~13%).

### Running apriori()

```r
rules <- apriori(
  trans,
  parameter = list(supp = 0.05, conf = 0.70, minlen = 2)
)
summary(rules)
```

- `supp = 0.05`: at minimum 5% of policyholders must hold the cover combination (25,000 records out of 500,000 — enough to be a real pattern, not noise).
- `conf = 0.70`: the consequent is held by at least 70% of policyholders who already hold the antecedent.
- `minlen = 2`: rules must have at least one item on each side (no trivial single-item rules).

### Sorting and filtering rules

```r
# Top 10 by lift
top_rules <- head(sort(rules, by = "lift"), 10)
inspect(top_rules)

# Rules with dental_cover as consequent
dental_rules <- subset(rules, rhs %in% "dental_cover=TRUE")
inspect(sort(dental_rules, by = "lift"))
```

### Visualising with arulesViz

```r
plot(rules, method = "scatter", measure = c("support", "confidence"),
     shading = "lift")
```

The scatter plot places each rule at the position (support, confidence). The colour (shading) encodes lift: darker = higher lift. Rules in the top-right of the plot are both common and reliable. Rules in the upper-left have high confidence but low support — they are reliable but rare patterns.

```r
plot(top_rules, method = "graph")
```

The network graph shows items as nodes and rules as directed arrows. Thicker arrows = higher lift. This makes it easy to see which items are "hubs" (connected to many rules).

### Interpreting rules as business actions

A high-lift rule is statistically significant, but is it actionable? Ask three questions:
1. **Is it novel?** (You didn't already know this.)
2. **Is it actionable?** (Can the business act on it — e.g., a targeted offer?)
3. **Is it profitable?** (Does the combined add-on generate more margin than the cost of the campaign?)

Example: if the rule `{vision_cover=TRUE} → {dental_cover=TRUE}` has lift = 1.9 and confidence = 0.74, you can run a targeted campaign offering a dental add-on to all policyholders who hold vision cover but not yet dental. The lift of 1.9 means they are 1.9× more likely to take dental cover than a random policyholder — a strong ROI signal.

## Example

```r
library(tidyverse)
library(arules)
library(arulesViz)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

# Prepare transactions
flag_cols <- c("dental_cover", "vision_cover", "mental_cover", "maternity_cover")
trans_df  <- health_data |>
  select(all_of(flag_cols)) |>
  mutate(across(everything(), as.logical))
trans <- as(trans_df, "transactions")

# Mine rules
rules <- apriori(trans, parameter = list(supp = 0.05, conf = 0.70, minlen = 2))

# Top 5 by lift
inspect(head(sort(rules, by = "lift"), 5))

# Scatter plot
plot(rules, method = "scatter", measure = c("support", "confidence"), shading = "lift")
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) prepare the transaction object from the add-on columns; (2) plot item frequencies; (3) mine rules and display the top 10 by lift; (4) create a scatter plot, identify the three rules with the highest lift, and write one actionable recommendation for each.

## Check

```
npm run check -- bdat-602 module-03 lesson-02
```

## Reflection

You mined rules from the full 500,000-row dataset using only four binary items. In a real insurer's data warehouse you might have 200 binary product flags. How would the Apriori algorithm's runtime scale, and what practical strategies would you use to keep the computation tractable?
