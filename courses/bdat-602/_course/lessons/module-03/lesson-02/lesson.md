# Lesson 7: Mining Rules at Scale — Spark, Sequences, Filtering, and Visualisation

## Goal

After this lesson you can prepare the health insurance dataset as an `arules` transaction object with discretised continuous variables, mine rules at scale using ECLAT and Spark FP-Growth, mine temporal event sequences with `arulesSequences`, filter out redundant and spurious rules with Fisher's exact test, visualise rule sets with all four `arulesViz` plot types, and translate the strongest rules into plain-language business recommendations.

## Concept

### Preparing insurance data as transactions

Standard association mining requires every variable to be categorical. The insurance dataset contains continuous variables (age, BMI, income) that must be **discretised** before they can become items. Binary flags (dental\_cover = 1) become labelled strings ("Dental").

```r
trans_df <- health_data |>
  mutate(
    dental    = ifelse(dental_cover    == 1, "Dental",    NA),
    vision    = ifelse(vision_cover    == 1, "Vision",    NA),
    mental    = ifelse(mental_cover    == 1, "Mental",    NA),
    maternity = ifelse(maternity_cover == 1, "Maternity", NA),
    age_grp   = cut(age, breaks = c(17, 30, 45, 60, 85),
                    labels = c("Young", "MidAge", "Senior", "Elderly")),
    bmi_grp   = cut(bmi, breaks = c(0, 18.5, 25, 30, 100),
                    labels = c("Underweight", "Normal", "Overweight", "Obese")),
    fraud_lbl = ifelse(fraud_flag == 1, "Fraud",   "NoFraud"),
    churn_lbl = ifelse(churned    == 1, "Churned", "Retained"),
    smoker_lbl= ifelse(smoker     == 1, "Smoker",  "NonSmoker")
  ) |>
  select(dental, vision, mental, maternity,
         plan_tier, region, age_grp, bmi_grp,
         employment_type, smoker_lbl, fraud_lbl, churn_lbl)
```

Each row becomes one policyholder's "basket" of attribute values. Missing (NA) entries are treated as absent items.

```r
trans_obj <- as(trans_df, "transactions")
summary(trans_obj)
itemFrequencyPlot(trans_obj, topN = 20, type = "absolute",
                  main = "Top 20 Items in Insurance Transactions",
                  col = "steelblue", las = 2, cex.names = 0.75)
inspect(trans_obj[1:5])  # each row is a set of items
```

### Running Apriori and ECLAT on the full dataset

```r
rules_apriori <- apriori(
  trans_obj,
  parameter = list(supp = 0.02, conf = 0.60, minlen = 2, maxlen = 5)
)
summary(rules_apriori)
inspect(sort(rules_apriori, by = "lift", decreasing = TRUE)[1:15])

# Fraud-specific rules (RHS = Fraud)
fraud_rules <- subset(rules_apriori,
                      subset = rhs %in% "fraud_lbl=Fraud" & lift > 1.5)
inspect(sort(fraud_rules, by = "lift"))
```

For datasets larger than 100,000 rows, prefer ECLAT:

```r
freq_sets      <- eclat(trans_obj, parameter = list(supp = 0.02, minlen = 2, maxlen = 5))
rules_from_eclat <- ruleInduction(freq_sets, trans_obj, confidence = 0.60)
inspect(sort(rules_from_eclat, by = "lift")[1:10])
```

### Scaling with Spark: distributed FP-Growth

For 500,000 rows and production-scale item spaces, move the computation to Spark:

```r
library(sparklyr)
sc <- spark_connect(master = "local[*]", version = "3.4.1")
health_tbl <- copy_to(sc, health_data, name = "health_ins", overwrite = TRUE)

health_items <- health_tbl |>
  mutate(items = array(
    ifelse(dental_cover    == 1, "Dental",    NULL),
    ifelse(vision_cover    == 1, "Vision",    NULL),
    ifelse(mental_cover    == 1, "Mental",    NULL),
    ifelse(maternity_cover == 1, "Maternity", NULL),
    plan_tier, region
  )) |>
  select(record_id, items)

fp_model   <- health_items |>
  ml_fpgrowth(items_col = "items", min_support = 0.02, min_confidence = 0.60)
spark_rules <- ml_association_rules(fp_model)
spark_rules |> collect() |> arrange(desc(lift)) |> head(15)
```

`ml_fpgrowth()` implements the distributed FP-Growth algorithm. It scales linearly with both data size and number of workers.

### Sequence pattern mining

Standard association rules capture **co-occurrence** but ignore **order**. Sequential pattern mining finds frequent ordered subsequences: $\langle A \rangle \rightarrow \langle B \rangle \rightarrow \langle C \rangle$ means event $A$ occurs, then $B$, then $C$.

Insurance examples:
- $\langle \text{Claim} \rangle \rightarrow \langle \text{SupportCall} \rangle \rightarrow \langle \text{Churn} \rangle$: policyholders who file a claim and then call support are at high churn risk.
- $\langle \text{SupportCall} \rangle \rightarrow \langle \text{SupportCall} \rangle \rightarrow \langle \text{Churn} \rangle$: two support calls predict churn with support 0.40.

Key algorithms: **GSP** (Generalised Sequential Patterns) and **PrefixSpan**. In R, `arulesSequences::cspade()` implements the SPADE algorithm.

```r
library(arulesSequences)
event_seq <- health_data |>
  filter(num_claims > 0) |>
  select(policyholder_id, policy_start_date, support_calls, churned) |>
  mutate(
    event1 = "Claim",
    event2 = ifelse(support_calls > 0, "SupportCall", NA),
    event3 = ifelse(churned       == 1, "Churn",       NA)
  ) |>
  tidyr::pivot_longer(cols = starts_with("event"), values_to = "event") |>
  filter(!is.na(event)) |>
  arrange(policyholder_id)

seq_rules <- cspade(
  as(event_seq, "transactions"),
  parameter = list(support = 0.02),
  control   = list(verbose = TRUE)
)
inspect(seq_rules)
```

### Managing too many rules

A lenient minsupp generates thousands of rules. Many are **redundant** (a more general rule with equal confidence already exists), **trivial** (high support + low lift — the consequent is just very common), or **spurious** (passing thresholds by chance in a large dataset).

**Redundancy example**: Rule $\{D\} \Rightarrow \{M\}$ (conf = 0.72, lift = 1.8) and Rule $\{D, V\} \Rightarrow \{M\}$ (conf = 0.72, lift = 1.8). Adding V to the LHS does not improve confidence or lift. Rule 2 is redundant — prefer the more general Rule 1.

```r
# 1. Remove redundant rules
non_redundant <- rules_apriori[!is.redundant(rules_apriori)]
cat("Before:", length(rules_apriori), " After:", length(non_redundant), "\n")

# 2. Filter by lift > 1.2 (positively associated)
strong_rules <- subset(non_redundant, subset = lift > 1.2)

# 3. Focus on churn rules (churn on the RHS)
churn_rules <- subset(non_redundant,
                      subset = rhs %in% "churn_lbl=Churned" &
                               lift > 1.3 & confidence > 0.65)
inspect(sort(churn_rules, by = "lift"))

# 4. Convert to data frame for further analysis
rules_df <- as(non_redundant, "data.frame")
head(rules_df |> arrange(desc(lift)), 10)
```

### Statistical significance: Fisher's exact test

With $n = 500{,}000$ records, even spurious co-occurrences achieve high support by chance. Fisher's exact test confirms whether the association is genuinely non-random.

```r
measures <- interestMeasure(
  rules_apriori,
  measure      = c("support", "confidence", "lift", "conviction",
                   "leverage", "fishersExactTest"),
  transactions = trans_obj
)
rules_df <- cbind(as(rules_apriori, "data.frame"), measures)

significant_rules <- rules_df |>
  filter(lift > 1.5, fishersExactTest < 0.01) |>
  arrange(desc(lift))

significant_rules |>
  select(rules, support, confidence, lift, conviction, fishersExactTest) |>
  head(15)
```

**Why statistical testing matters at scale**: at $n = 500{,}000$, even a 1% support threshold includes 5,000 policyholders — enough for spurious patterns to pass. Fisher's exact test confirms the association is beyond chance.

### Visualising rules with arulesViz

`arulesViz` provides six plot types for exploring rule sets:

| Plot | Method string | What it shows |
|---|---|---|
| Scatter | `"scatter"` | Support vs. confidence; colour = lift |
| Two-key | `"two-key plot"` | Size = support; colour = confidence |
| Matrix | `"matrix"` | Items on axes; colour = lift |
| Graph | `"graph"` | Items as nodes; rules as directed edges |
| Parallel coordinates | `"paracoord"` | Each rule as a line across item axes |
| Grouped matrix | `"grouped"` | Hierarchical grouping of rules |

```r
library(arulesViz)

# Scatter plot: support vs. confidence, coloured by lift
plot(rules_apriori,
     measure = c("support", "confidence"), shading = "lift",
     main = "Association Rules: Support vs Confidence (shade = Lift)",
     col  = colorRampPalette(c("steelblue", "gold", "red"))(100))

# Graph plot: items as nodes, rules as directed edges (top 30 by lift)
top30 <- sort(rules_apriori, by = "lift")[1:30]
plot(top30, method = "graph", engine = "htmlwidget")

# Grouped matrix plot
plot(rules_apriori, method = "grouped",
     control = list(k = 10), main = "Grouped Matrix of Association Rules")

# Parallel coordinates plot
plot(top30, method = "paracoord", control = list(reorder = TRUE))
```

**Reading the graph plot**: circles = items (attributes); squares = rules. An arrow from an item circle to a rule square means that item is on the LHS. An arrow from a rule square to an item circle means that item is on the RHS. Larger square = higher support; darker colour = higher lift.

### From rules to business recommendations

A high-lift rule is statistically interesting. Before acting on it, ask three questions:
1. **Is it novel?** (You did not already know this from domain knowledge.)
2. **Is it actionable?** (Can the business respond — e.g., a targeted offer, a fraud alert?)
3. **Is it profitable?** (Does the combined margin exceed the cost of the action?)

**Upsell example** — Rule: $\{\text{Gold}, \text{Dental}, \text{NonSmoker}\} \Rightarrow \{\text{Vision}\}$; support = 0.08, confidence = 0.74, lift = 1.92.

Plain language: 8% of policyholders hold a Gold plan, dental cover, and are non-smokers *and* also have vision cover. Among Gold/Dental/NonSmoker policyholders, 74% have vision cover — they are 1.92× more likely than average to hold vision. **Recommendation**: target this segment with a vision cover bundle promotion. The conversion rate is expected to be nearly double the portfolio average.

**Fraud detection example** — Rule: $\{\text{Unemployed}, \text{Young}, \text{WeekendClaim}\} \Rightarrow \{\text{Fraud}\}$; support = 0.012, confidence = 0.52, lift = 4.1.

Plain language: only 1.2% of records match this profile, but among them, 52% are fraudulent — 4.1× the base fraud rate. **Recommendation**: route all claims matching this profile to the manual review queue. Coverage is manageable (1.2% of 500,000 = 6,000 records).

### Common pitfalls in association mining

1. **Confusing correlation with causation**: $A \Rightarrow B$ does not mean $A$ causes $B$. Always seek a plausible mechanism before acting on a rule.
2. **Ignoring lift and using only confidence**: high confidence can occur simply because $B$ is very common. Always report lift alongside confidence.
3. **Mining without a business question**: "Let us mine everything and see" produces an uninterpretable mass of rules. Always define the RHS item of interest before running `apriori()`.
4. **Simpson's Paradox**: a rule may hold overall but reverse within subgroups. Always stratify and check rules within meaningful segments (by region, plan tier).
5. **Spurious rules in large datasets**: at $n = 500{,}000$, even rare combinations appear frequently by chance. Apply Fisher's exact test (`interestMeasure(..., "fishersExactTest")`).
6. **Not removing redundant rules**: always run `is.redundant()` before presenting results.

## Example

```r
library(tidyverse)
library(arules)
library(arulesViz)

source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

trans_df <- health_data |>
  mutate(
    dental    = ifelse(dental_cover    == 1, "Dental",    NA),
    vision    = ifelse(vision_cover    == 1, "Vision",    NA),
    mental    = ifelse(mental_cover    == 1, "Mental",    NA),
    maternity = ifelse(maternity_cover == 1, "Maternity", NA),
    age_grp   = cut(age, breaks = c(17, 30, 45, 60, 85),
                    labels = c("Young", "MidAge", "Senior", "Elderly")),
    bmi_grp   = cut(bmi, breaks = c(0, 18.5, 25, 30, 100),
                    labels = c("Underweight", "Normal", "Overweight", "Obese")),
    fraud_lbl = ifelse(fraud_flag == 1, "Fraud",   "NoFraud"),
    churn_lbl = ifelse(churned    == 1, "Churned", "Retained"),
    smoker_lbl= ifelse(smoker     == 1, "Smoker",  "NonSmoker")
  ) |>
  select(dental, vision, mental, maternity, plan_tier, region,
         age_grp, bmi_grp, employment_type, smoker_lbl, fraud_lbl, churn_lbl)

trans_obj <- as(trans_df, "transactions")

rules <- apriori(trans_obj,
                 parameter = list(supp = 0.02, conf = 0.60, minlen = 2, maxlen = 5))

non_redundant <- rules[!is.redundant(rules)]
inspect(sort(non_redundant, by = "lift")[1:10])

plot(non_redundant, method = "scatter",
     measure = c("support", "confidence"), shading = "lift")
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) prepare the transaction object from the full 500,000-row insurance dataset using the discretisation code above; (2) run `apriori()` with minsupp = 0.02, minconf = 0.60 and remove redundant rules; (3) produce a scatter plot and a graph plot of the top 30 rules by lift; (4) apply Fisher's exact test, filter to lift > 1.5 and p < 0.01, and write a plain-language business recommendation for the single highest-lift fraud rule.

## Check

```
npm run check -- bdat-602 module-03 lesson-02
```

## Reflection

The lecture states: "Define your business question before running the algorithm." Suppose a fraud analyst says "mine everything and filter for fraud afterwards." What are the statistical risks of this approach compared with setting the RHS to {Fraud} before calling `apriori()`? Consider both Type I error rate and computational cost.
