# Task: PCA Interpretation and Dimensionality Reduction Decision

## Objective

Determine how many PCs to retain for downstream modelling and interpret their meaning.

## Instructions

1. **Fit PCA** — Use 10 numeric variables: `age`, `bmi`, `income`, `premium`, `deductible`, `num_chronic_conditions`, `num_visits`, `num_claims`, `avg_past_claim`, `claim_amount`. Impute medians. Normalise. Apply `step_pca(..., num_comp = 8)`.

2. **Scree plot** — Plot % variance explained per PC. Add a cumulative line. Annotate the point where cumulative variance crosses 80%.

3. **Loadings heatmap** — Use `tidy(pca_prep, number = ..., type = "coef")` to extract loadings for PC1–PC4. Create a heatmap using `ggplot2` with `geom_tile()`: rows = original variables, columns = PCs, fill = loading value.

4. **Interpret** — For each of PC1–PC3, write 1–2 sentences naming what business dimension the PC captures, based on its top loading variables.

5. **Decision** — How many PCs would you retain before a downstream k-means clustering? Justify using the cumulative variance plot and the Kaiser rule (eigenvalue > 1, equivalent to % variance > 100/p for p variables).

## Submission

Knit your Rmd with the scree plot, loadings heatmap, interpretation text, and retention decision visible.
