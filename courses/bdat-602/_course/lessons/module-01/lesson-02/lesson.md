# Lesson 2: CRISP-DM and Setting Up the Course Dataset

## Goal

After this lesson you can apply the six CRISP-DM phases to a real insurance analytics project, generate and describe the course dataset, and connect a local R session to Apache Spark using `sparklyr`.

## Concept

### CRISP-DM: the project lifecycle

CRISP-DM (Cross-Industry Standard Process for Data Mining) is a vendor-neutral, iterative framework that organises a data mining project into six phases. Unlike the KDD process (which focuses on the technical pipeline), CRISP-DM also covers the business and deployment context.

**Phase 1 — Business Understanding**
Define what you want to achieve *in business terms*, then translate that into a data mining objective. Example: the insurance company wants to reduce churn. Business goal: "retain 10% more Gold-tier policyholders over the next year." Mining objective: "build a classifier that predicts churn 60 days before renewal with recall ≥ 0.70."

**Phase 2 — Data Understanding**
Collect initial data, explore it, and assess its quality. You answer: What variables do we have? Are they reliable? What patterns are immediately visible? Tools: `skim()`, `naniar::vis_miss()`, `ggplot2` histograms. At this stage you are not yet cleaning — you are *diagnosing*.

**Phase 3 — Data Preparation**
Transform raw data into the analysis-ready form the modelling step needs. This is the most time-consuming phase in practice (often 60–70% of total project time). It includes selecting rows and columns, handling missing values, treating outliers, encoding categoricals, and engineering new features.

**Phase 4 — Modelling**
Apply one or more algorithms. In CRISP-DM you often try several model families (logistic regression, random forest, gradient boosting) and tune hyperparameters. Output: a trained model and its performance on a validation set.

**Phase 5 — Evaluation**
Assess whether the model meets the business goal defined in Phase 1. Accuracy on a test set is necessary but not sufficient — a 99%-accurate fraud model that catches 0 fraudulent claims fails the business goal. Decide here whether to deploy or loop back.

**Phase 6 — Deployment**
Put the model into production: a batch scoring pipeline, a REST API, or a dashboard. This phase is often outside a data scientist's core skills but must be planned for from the start.

*CRISP-DM is circular, not linear.* After deployment, new data arrives, model performance drifts, and you loop back to Phase 1 or 2.

### The course dataset: `simulate_bdat602()`

Rather than using a real insurer's proprietary data (which cannot be shared), we use a carefully simulated dataset that mimics a real global health insurance portfolio.

```r
options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)
```

Key properties:
- **500,000 rows**, one per policy-record. ~70% of policyholders have multiple records.
- **40 columns**: 4 identifiers, 7 demographics, 8 policy details, 4 medical usage, 5 claims history, 1 fraud flag, 5 customer behaviour, 1 free-text, 3 targets.
- **Targets**: `churned` (binary), `high_risk` (binary), `claim_amount` (continuous).
- **Intentional quality issues**: ~5% missing BMI, ~4% missing income, ~10% missing complaint notes, injected outliers in BMI and income.

### Spark with sparklyr (introduction)

When data exceeds available RAM, we move computation to Apache Spark. `sparklyr` provides a dplyr-compatible interface to Spark from R.

```{r spark-connect, eval=FALSE}
library(sparklyr)

# Connect to a local Spark instance (uses all available CPU cores)
sc <- spark_connect(master = "local[*]", version = "3.4.1")

# Push the R data frame into Spark memory
health_tbl <- copy_to(sc, health_data, name = "health_insurance", overwrite = TRUE)

# All dplyr verbs work on health_tbl — they translate to Spark SQL
health_tbl |> count(plan_tier) |> collect()

spark_disconnect(sc)
```

`collect()` brings results back to R as a tibble. Keep computations in Spark and only `collect()` the final summary — never collect 500,000 rows into R if you don't need them all.

## Example

A CRISP-DM business understanding document for a churn-prediction project.

**Business goal**: Reduce churn among Gold and Platinum policyholders by 15% over the next policy renewal cycle.

**Success criterion**: A model that identifies policyholders at risk of churning in the next 60 days, achieving recall ≥ 0.70 on the test set (we prefer catching actual churners even at the cost of some false alarms).

**Mining objective**: Train a binary classifier on `churned` using `age`, `plan_tier`, `deductible`, `customer_rating`, `support_calls`, `auto_pay`, and `policy_age_months`. Evaluate with precision-recall and ROC-AUC.

**Data source**: `simulate_bdat602()` with n = 500,000. Policy records from 2024.

**Constraints**: Must not use `policyholder_id` or `agent_id` as features (leakage risk). Model must be explainable to the retention team.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) set up packages and generate the dataset, (2) write a one-paragraph CRISP-DM Phase 1 document for a fraud-detection project using this dataset, (3) explore the three target variables (`churned`, `high_risk`, `claim_amount`) with `skim()` and at least one plot, (4) write the Spark code (with `eval=FALSE`) to connect to Spark and push the dataset.

## Check

```
npm run check -- bdat-602 module-01 lesson-02
```

## Reflection

CRISP-DM Phase 5 (Evaluation) asks whether the model meets the *business* goal, not just the *statistical* goal. Can you construct a scenario where a model with 95% accuracy completely fails the business goal? What metric would catch this failure?
