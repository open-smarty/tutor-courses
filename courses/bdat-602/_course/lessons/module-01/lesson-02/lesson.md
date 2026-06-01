# Lesson 2: CRISP-DM and Setting Up the Course Dataset

## Goal

Describe the six phases of CRISP-DM and explain how they differ from the linear KDD process. Load the course dataset from CSV using `readr` and `data.table`, perform first exploratory visualisations, and run an automated EDA report with `DataExplorer`.

## Concept

### CRISP-DM: Industry Standard for Mining Projects

**CRISP-DM** (Cross-Industry Standard Process for Data Mining) operationalises KDD for industry projects. It adds *Business Understanding* and *Deployment* phases and emphasises that the process is **cyclical** — evaluation findings loop back to earlier phases.

```
Business Understanding
        ↓
Data Understanding  ←──────────────────────┐
        ↓                                  │
Data Preparation                           │
        ↓                                  │
   Modelling                               │
        ↓                                  │
   Evaluation ─────────────────────────────┘
        ↓
  Deployment
```

| Phase | Key questions |
|-------|--------------|
| **Business Understanding** | What problem are we solving? What does success look like? |
| **Data Understanding** | What data do we have? What are its quality issues? |
| **Data Preparation** | How do we clean, transform, and engineer features? |
| **Modelling** | Which algorithm? Which hyperparameters? |
| **Evaluation** | Does the model meet business goals? Is the performance acceptable? |
| **Deployment** | How do we deliver the model to users or systems? |

CRISP-DM vs KDD:

| Aspect | KDD | CRISP-DM |
|--------|-----|---------|
| Starting point | Raw data | Business problem |
| End point | Knowledge | Deployed solution |
| Process shape | Linear (mostly) | Cyclical (explicitly) |
| Iteration | Implied | Explicitly modelled |

---

### Reading Data from CSV

In practice you read data from flat files rather than generating it. Two main functions:

```r
# readr — tidyverse, auto-detects types
library(readr)
df_readr <- read_csv("data/raw/health_insurance_small.csv")

# data.table — maximum speed on large files
library(data.table)
df_dt <- fread("data/raw/health_insurance_small.csv")
```

Key `read_csv()` arguments:
- `col_types` — override inferred types
- `na` — additional strings to treat as NA (e.g. `na = c("", "NA", "N/A", "Unknown")`)
- `n_max` — read only the first n rows (useful for inspecting large files)

---

### First Exploratory Visualisations

```r
library(ggplot2)
library(dplyr)

# Distribution of claim amounts (right-skewed)
ggplot(health_small |> filter(claim_amount > 0),
       aes(x = claim_amount)) +
  geom_histogram(bins = 60, fill = "steelblue", colour = "white") +
  scale_x_log10(labels = scales::comma) +
  labs(title = "Distribution of Claim Amounts (log scale)",
       x = "Claim Amount (USD, log scale)", y = "Count") +
  theme_minimal()

# Claim amount by plan tier
ggplot(health_small |> filter(claim_amount > 0),
       aes(x = plan_tier, y = claim_amount, fill = plan_tier)) +
  geom_boxplot(outlier.alpha = 0.2) +
  scale_y_log10(labels = scales::comma) +
  labs(title = "Claim Amount by Plan Tier", x = NULL) +
  theme_minimal() +
  theme(legend.position = "none")
```

Higher plan tiers show higher median claims — both because Platinum attracts higher-risk enrollees and because higher coverage incentivises larger claims.

---

### Automated EDA with DataExplorer

`DataExplorer::create_report()` generates a complete HTML EDA report in one call — missing value profiles, distributions, correlations, and QQ plots.

```r
library(DataExplorer)

# Quick visual summaries
plot_missing(health_small)       # missing value map
plot_histogram(health_small)     # continuous distributions
plot_correlation(               # correlation heatmap
  health_small |>
    select(age, bmi, income, premium, claim_amount,
           num_claims, num_chronic_conditions),
  title = "Correlation Matrix: Key Numeric Variables"
)

# Full automated report (eval=FALSE — run interactively)
create_report(
  health_small,
  output_file  = "lecture1_eda.html",
  output_dir   = "output/reports",
  report_title = "BDAT 602: Health Insurance EDA"
)
```

## Example

Applying CRISP-DM to this course project:

| Phase | What we do |
|-------|-----------|
| Business Understanding | Reduce churn and fraud losses for a health insurer |
| Data Understanding | 500k records, 40 vars, 3 targets; intentional quality issues found via `skim()` |
| Data Preparation | Impute BMI/income, winsorise outliers, encode categoricals, build `recipes` pipeline |
| Modelling | Random forests for churn, isolation forest + logistic for fraud |
| Evaluation | AUC, precision-recall, business lift; compare to naïve baseline |
| Deployment | Score new policyholders monthly; alert high-risk accounts |

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Read `data/raw/health_insurance_small.csv` with `readr::read_csv()`. Call `glimpse()` and report: how many rows? how many columns? Which columns were automatically parsed as logical?
2. Create a histogram of `claim_amount` (filter to rows where `claim_amount > 0`), using a log10 x-axis. Title: "Claim Amounts: 10k Sample".
3. Use `DataExplorer::plot_missing()` on the loaded data frame. Report which columns have missing values.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-01 lesson-02
```

## Reflection

The CRISP-DM process is explicitly cyclical. Describe a scenario in this project where completing the Evaluation phase would send you back to the Data Preparation phase rather than to Deployment. What specific finding would trigger that loop?
