# Task: Module 6, Lesson 1 — Final Capstone Project

## Objective

Apply the complete modelling workflow from scratch on a new dataset, demonstrating mastery of the full BDAT 608 pipeline.

## Instructions

Choose **one** of the following datasets:

**Option A:** `msleep` from `ggplot2` — mammalian sleep patterns  
**Option B:** `txhousing` from `ggplot2` — Texas housing market  
**Option C:** `gapminder` from the `gapminder` package — country-level GDP and life expectancy

Build a complete analysis Rmd with the following sections:

### 1. Exploratory Data Analysis (EDA)
- `glimpse()` the dataset
- Identify the response variable of interest and at least two potential predictors
- Produce at least two EDA plots; check if transformation is needed

### 2. Model 1 — Simple Model
- Fit a simple model (OLS or GLM as appropriate)
- Visualise fitted values and residuals
- Interpret R² and at least one coefficient

### 3. Model 2 — Extended Model
- Add at least one additional predictor or interaction
- Compare Model 1 and Model 2 using AIC
- Show residual plots for both

### 4. Model 3 — Extended Family (choose one)
- If residuals show non-linearity: fit a GAM
- If there are outliers: compare OLS vs rlm()
- If there are many predictors: fit LASSO

### 5. Many Models (bonus)
- If the dataset has a grouping variable, replicate the purrr many-models pattern

### 6. Summary
Write a 1-page (≈ 300-word) statistical report covering:
- Which model you recommend and why
- The key finding (main predictor, effect size, uncertainty)
- One limitation of your analysis

## Submission

Submit the knitted HTML. The document must knit without errors and contain all six sections.
