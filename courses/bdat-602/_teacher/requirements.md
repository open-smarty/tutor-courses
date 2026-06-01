# Learning Requirements

## Learning outcomes

After completing this course, students will be able to:

1. Explain the six data mining tasks and apply the KDD and CRISP-DM frameworks to organise a real mining project
2. Diagnose and treat missing values and outliers, and build a reproducible preprocessing pipeline with `recipes`
3. Mine association rules from transactional data and interpret support, confidence, and lift
4. Cluster observations with k-means and hierarchical methods and validate cluster quality
5. Apply PCA to reduce dimensionality and visualise high-dimensional data
6. Build and evaluate decision tree and random forest classifiers, and handle severe class imbalance
7. Tokenise text, compute TF-IDF, and extract latent topics with LDA

## Prerequisites

- Basic R: data frames, `dplyr`, `ggplot2`, `tidyr`
- First statistics course: distributions, mean/variance, basic probability
- BDAT 601 or equivalent introductory data analytics experience

## Constraints

- All exercises use R (not Python); code should be written in R Markdown (`.Rmd`)
- The `simulate_bdat602()` function in `R/simulate_bdat602_data.R` is the single data source for all modules
- Lessons must include Spark (`sparklyr`) variants for large-scale sections to demonstrate scale-out
- Exercise files must be knittable without a live Spark session (Spark chunks use `eval=FALSE`)

## Structure

- Modules: 6
- Lessons per module: 2–3 (14 total)
