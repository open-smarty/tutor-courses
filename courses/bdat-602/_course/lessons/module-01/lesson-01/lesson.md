# Lesson 1: What Is Data Mining? The Big Data Landscape and the KDD Process

## Goal

After this lesson you can name and distinguish all six core mining tasks, explain the 4 Vs of Big Data, trace the five-step KDD process, run a first exploratory analysis on the course dataset using `skimr`, and generate an automated EDA report with `DataExplorer`.

## Concept

### What is data mining?

Data mining is the computational process of discovering non-obvious, potentially useful patterns in large collections of data. The key word is *non-obvious*: simple counting (e.g., "65% of policyholders are under 45") is not mining; uncovering that policyholders who carry both dental and maternity cover are three times more likely to churn is.

There are six canonical mining tasks:

1. **Classification** — predict which of several pre-defined categories a record belongs to. Formal definition: learn a function $f: \mathcal{X} \rightarrow \mathcal{Y}$ where $\mathcal{Y}$ is a finite label set. Insurance example: predict whether a policyholder will churn (`churned = 1`) given their demographics and plan details.

2. **Regression** — predict a continuous numeric value. Formal definition: learn $f: \mathcal{X} \rightarrow \mathbb{R}$. Insurance example: predict next year's claim amount given age, BMI, and plan tier.

3. **Clustering** — group records so that items within a group are more similar to each other than to items in other groups, *without* using pre-defined labels (unsupervised). Insurance example: segment policyholders into behavioural profiles (e.g., "young low-risk", "elderly chronic-condition", "high-utilisation") to tailor marketing.

4. **Association rule mining** — find items that co-occur more often than chance predicts. Formal: discover rules $X \Rightarrow Y$ with high support and confidence. Insurance example: discover that policyholders with `dental_cover = 1` also hold `vision_cover = 1` in 72% of cases.

5. **Anomaly detection** — identify records that deviate markedly from the pattern of the majority. Insurance example: flag claims whose amount and timing look statistically improbable (`fraud_flag = 1`).

6. **Text mining** — extract structured information from unstructured natural language. Insurance example: categorise the free-text `complaint_notes` column into billing, claims, and coverage complaints.

### The 4 Vs of Big Data

Big Data is characterised by four dimensions that make traditional tools inadequate:

- **Volume**: data too large for a single machine's memory (our simulated dataset: 500,000 rows × 40 variables; real insurer datasets run to billions of claim records).
- **Velocity**: data arriving faster than batch pipelines can process (streaming telematics data from wearables).
- **Variety**: structured tables, images, audio, GPS traces, free text — all in one pipeline.
- **Veracity**: trustworthiness and accuracy of the data (our dataset deliberately injects 5% missing BMI and extreme outliers to mirror real-world quality issues).

### The KDD Process (5 steps)

KDD stands for *Knowledge Discovery in Databases*. It is the overarching pipeline of which data mining is one step:

1. **Selection** — choose which data sources, tables, and time windows are relevant to your question.
2. **Preprocessing** — handle missing values, remove duplicates, resolve inconsistencies.
3. **Transformation** — scale variables, encode categoricals, engineer new features, reduce dimensions.
4. **Data Mining** — apply a mining algorithm (Apriori, k-means, random forest, LDA, …) to the prepared data.
5. **Interpretation / Evaluation** — assess whether the patterns found are valid, novel, useful, and understandable.

These steps are not strictly linear: you may loop back from step 4 to step 2 after discovering that missing values in a particular column are corrupting your clusters.

### Reading large files in R

For files up to ~1 GB, `readr::read_csv()` is fast and returns a tibble. For files beyond that, `data.table::fread()` is typically 5-10× faster and uses less memory by leveraging multiple CPU cores.

`skimr::skim()` produces a compact summary: n missing, completion rate, mean, sd, percentiles for numeric columns, and frequency tables for character columns — everything `summary()` gives plus more, in a readable format.

### Automated EDA with DataExplorer

Once you have a first `skim()` summary, `DataExplorer` lets you go deeper with a single function call. Its key functions:

| Function | What it produces |
|---|---|
| `plot_missing(df)` | Bar chart of missing-value proportions per column |
| `plot_histogram(df)` | Histograms for every numeric column |
| `plot_correlation(df)` | Correlation heatmap for numeric columns |
| `create_report(df)` | Full HTML report combining all of the above |

```r
library(DataExplorer)

# Visual missing-value map: immediately shows which columns have gaps
plot_missing(health_small)

# Distribution shapes: reveals skew, bimodality, outliers
plot_histogram(health_small)

# Correlation structure: identifies multicollinear pairs before modelling
plot_correlation(
  health_small |> select(age, bmi, income, premium, claim_amount, num_claims),
  title = "Correlation Matrix: Key Numeric Variables"
)

# One-line full report — generates output/lecture1_eda.html
create_report(
  health_small,
  output_file  = "lecture1_eda.html",
  output_dir   = "output/reports",
  report_title = "BDAT 602: Health Insurance EDA"
)
```

`plot_missing()` is especially useful at this early stage: it shows at a glance that `bmi` (~5%), `income` (~4%), and `complaint_notes` (~10%) have the highest missingness — which directly motivates the imputation strategies in Module 2.

**Rule**: always run `skim()` first (fast, text-based, good for large datasets in any environment), then `plot_missing()` and `plot_histogram()` for the visual layer, then `plot_correlation()` once you have a target variable in mind.

## Example

Below we load a 10-row sample of the insurance data and interpret the `skim()` output.

```r
library(tidyverse)
library(skimr)

# Source the dataset simulator
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
options(bdat602.source_only = TRUE)  # prevent auto-run

# Generate the full dataset
set.seed(602)
health_data <- simulate_bdat602(n = 500000)

# Peek at 10 rows
health_data |> slice_sample(n = 10) |> glimpse()

# Full summary
skim(health_data)
```

Key findings from `skim()` output on the full dataset:
- `bmi` has ~5% missing (50,000 rows). This is not random — the simulator links missingness to point-of-sale collection. We call this **MAR** (more in Module 2).
- `claim_amount` has a mean near $4,200 but a p75 of ~$6,000 and a maximum exceeding $80,000: severely right-skewed, indicating outliers.
- `complaint_notes` has ~10% missing — rows where no note was recorded.
- `churned` has a prevalence of roughly 18%, so the majority class is "not churned" — class imbalance we will address in Module 5.

## Task

Open `exercise.Rmd` and complete the five tasks described there:
1. Load all required packages.
2. Generate the insurance dataset and read its structure.
3. Run `skim()` and identify three interesting findings (one numeric, one character, one about missingness).
4. Write one sentence for each of the six mining tasks describing what you would mine from this dataset.
5. Use `DataExplorer` to produce a missing-value plot, a histogram grid, and a correlation heatmap for key numeric variables.

## Check

```
npm run check -- bdat-602 module-01 lesson-01
```

## Reflection

`DataExplorer::plot_missing()` and `skimr::skim()` both reveal *that* data is missing and *how much*, but neither tells you *why*. Why does knowing the mechanism behind missingness (MCAR, MAR, or MNAR) matter before you choose an imputation strategy?
