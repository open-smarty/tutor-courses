# Lesson 1: Market Basket Analysis and the Apriori Algorithm

## Goal

Define support, confidence, and lift, explain why the Apriori algorithm is efficient, and mine association rules from a small grocery transaction dataset using the `arules` package.

## Concept

### What Are Association Rules?

An association rule has the form $\{A\} \Rightarrow \{B\}$, meaning: "when item A is present, item B tends to be present too."

Three measures quantify rule quality:

| Measure | Formula | Interpretation |
|---------|---------|---------------|
| **Support** | $\text{supp}(A \cup B) = \frac{|A \cup B|}{N}$ | How common is the itemset? |
| **Confidence** | $\text{conf}(A \Rightarrow B) = \frac{\text{supp}(A \cup B)}{\text{supp}(A)}$ | Given A, how often does B appear? |
| **Lift** | $\text{lift}(A \Rightarrow B) = \frac{\text{conf}(A \Rightarrow B)}{\text{supp}(B)}$ | Is the rule better than random chance? |

Lift interpretation:
- Lift = 1: A and B are independent — the rule is no better than chance
- Lift > 1: A and B co-occur more than expected — positive association
- Lift < 1: A and B co-occur less than expected — negative association (substitutes)

---

### The Apriori Algorithm

With $n$ items there are $2^n - 1$ possible itemsets — explosive. The **Apriori principle** prunes this space:

> If an itemset is infrequent (below `minSupport`), all of its supersets are also infrequent.

This means you can prune entire branches of the search tree. The algorithm:

1. Find all frequent 1-itemsets (items meeting `minSupport`)
2. Combine into candidate 2-itemsets; prune using Apriori principle
3. Scan database to count candidate 2-itemsets; keep frequent ones
4. Repeat until no new frequent itemsets are found
5. Generate rules from frequent itemsets; keep rules meeting `minConfidence`

---

### Running Apriori in R with arules

The `arules` package works with a special `transactions` object (a sparse binary matrix):

```r
library(arules)
library(arulesViz)

# Built-in Groceries dataset (9,835 transactions, 169 items)
data("Groceries")

rules <- apriori(
  Groceries,
  parameter = list(
    supp       = 0.01,   # at least 1% of transactions
    conf       = 0.30,   # at least 30% confidence
    minlen     = 2       # minimum rule length (LHS + RHS)
  )
)

inspect(head(sort(rules, by = "lift"), 10))
```

Visualise rules:

```r
# Scatter plot: support vs confidence, colour = lift
plot(rules, method = "scatter", measure = c("support", "confidence"),
     shading = "lift")

# Graph for top 10 rules by lift
plot(head(sort(rules, by = "lift"), 10),
     method = "graph", control = list(type = "items"))
```

---

### Data Format: Transactions

The `transactions` class stores binary item presence/absence efficiently as a sparse matrix:

```r
# Convert a binary data frame to transactions
df_trans <- data.frame(
  bread   = c(1, 1, 0, 1),
  milk    = c(1, 0, 1, 1),
  butter  = c(0, 1, 1, 1),
  eggs    = c(1, 0, 0, 1)
)

trans <- as(as.matrix(df_trans) == 1, "transactions")
summary(trans)
itemFrequencyPlot(trans, topN = 4)
```

## Example

```r
# Which rules have lift > 3?
rules_high_lift <- subset(rules, lift > 3)
inspect(sort(rules_high_lift, by = "lift"))

# Rules with whole milk on the right-hand side
milk_rules <- subset(rules, rhs %pin% "whole milk")
inspect(head(sort(milk_rules, by = "confidence"), 5))
```

The `%pin%` operator matches partial item names (pin = partial item name).

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Load the `Groceries` dataset from `arules`. Call `summary()`. Report: how many transactions? how many items?
2. Run `apriori()` with `supp = 0.01`, `conf = 0.25`. How many rules are generated?
3. Print the top 5 rules sorted by lift using `inspect(head(sort(...), 5))`.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-03 lesson-01
```

## Reflection

A colleague sets `minSupport = 0.001` (0.1%) to find more rules. What is the computational risk of this choice, and why does the Apriori principle not fully protect you from it?
