# Lesson 10: PCA for Dimensionality Reduction and Cluster Visualisation

## Goal

After this lesson you can derive the first two principal components from the covariance matrix, interpret a scree plot and a biplot, project cluster assignments into PCA space, and explain why visualising clusters in PC1-PC2 is both useful and potentially misleading.

## Concept

### Why reduce dimensions?

With 5+ features, we cannot plot the raw data directly. PCA finds a low-dimensional linear projection that retains as much variance as possible. Projecting into 2D lets us plot and visually inspect whether clusters are well-separated.

### The covariance matrix

For a dataset of $n$ observations and $p$ variables, first centre the data (subtract the column mean). The covariance matrix $\Sigma$ is a $p \times p$ symmetric matrix where:

$$\Sigma_{ij} = \text{Cov}(X_i, X_j) = \frac{1}{n-1} \sum_{k=1}^{n} (x_{ki} - \bar{x}_i)(x_{kj} - \bar{x}_j)$$

The diagonal $\Sigma_{ii} = \text{Var}(X_i)$. Off-diagonal entries measure linear co-movement between variables.

**Why is $\Sigma$ positive semi-definite?** For any vector $\mathbf{v}$, $\mathbf{v}^T \Sigma \mathbf{v} = \text{Var}(\mathbf{v}^T \mathbf{X}) \geq 0$ — variance is always non-negative.

### Eigendecomposition

We find vectors $\mathbf{v}_k$ (eigenvectors) and scalars $\lambda_k$ (eigenvalues) satisfying:

$$\Sigma \mathbf{v}_k = \lambda_k \mathbf{v}_k$$

Each eigenvector $\mathbf{v}_k$ is a **principal component direction** — the linear combination of original variables that maximises variance in that direction, subject to being orthogonal to all previous PCs. The eigenvalue $\lambda_k$ is the variance of the data projected onto $\mathbf{v}_k$.

**Proportion of variance explained by PC$k$**:
$$\text{PVE}_k = \frac{\lambda_k}{\sum_{j=1}^{p} \lambda_j}$$

**Numeric example**: suppose we have 5 variables and the eigenvalues are $\lambda = (3.2, 1.8, 0.6, 0.3, 0.1)$. Total variance = $\sum \lambda = 6.0$.
- PC1 explains $3.2/6.0 = 53.3\%$ of variance.
- PC2 explains $1.8/6.0 = 30.0\%$.
- PC1 + PC2 together explain $83.3\%$ — projecting to 2D retains most information.

### The scree plot

Plot $\lambda_k$ (or PVE$_k$) against $k$ (component number). Look for an "elbow" where the eigenvalues flatten. Choose the number of PCs that accounts for at least 80-85% of variance, or at the elbow.

### The biplot

A biplot superimposes two things:
1. **Scores** (points): the projection of each observation onto PC1 and PC2.
2. **Loadings** (arrows): the direction and magnitude of each original variable's contribution to PC1 and PC2.

Long arrows pointing in the PC1 direction mean that variable has a large positive loading on PC1 (it strongly influences the first component). Two arrows pointing in the same direction mean those variables are positively correlated.

### Projecting clusters

After running k-means on the scaled features, we can colour the PCA score plot by cluster label:

```r
scores <- as.data.frame(pca$x[, 1:2])
scores$cluster <- factor(km$cluster)

ggplot(scores, aes(x = PC1, y = PC2, colour = cluster)) +
  geom_point(alpha = 0.4, size = 0.8) +
  labs(title = "k-Means Clusters in PCA Space") +
  theme_minimal()
```

**Caution**: if clusters overlap in PCA space, it does not necessarily mean the clustering is poor — the clusters may be separated in dimensions 3, 4, or 5 that are not shown.

### prcomp() in R

```r
pca <- prcomp(data_scaled, scale. = FALSE)  # already scaled, so scale. = FALSE
summary(pca)   # shows cumulative proportion of variance
biplot(pca, scale = 0, cex = 0.5)
```

Set `scale. = TRUE` if feeding raw (unscaled) data. Here, since we already applied `scale()`, we set `scale. = FALSE`.

## Example

```r
library(tidyverse)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 50000, seed = 602)

clust_data <- health_data |>
  select(age, bmi, income, num_claims, num_chronic_conditions) |>
  drop_na() |>
  scale()

pca <- prcomp(clust_data, scale. = FALSE)

# Scree plot
tibble(
  PC  = 1:ncol(clust_data),
  PVE = pca$sdev^2 / sum(pca$sdev^2)
) |>
  ggplot(aes(x = PC, y = PVE)) +
  geom_col(fill = "steelblue") +
  geom_line(group = 1) + geom_point() +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Scree Plot", y = "Proportion of Variance Explained") +
  theme_minimal()

# k-means and PCA scatter plot
set.seed(602)
km <- kmeans(clust_data, centers = 4, nstart = 25)

as.data.frame(pca$x[, 1:2]) |>
  mutate(cluster = factor(km$cluster)) |>
  ggplot(aes(x = PC1, y = PC2, colour = cluster)) +
  geom_point(alpha = 0.3, size = 0.6) +
  labs(title = "k-Means Clusters in PCA Space") +
  theme_minimal()
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) run `prcomp()` on the scaled insurance features; (2) produce a scree plot and report how many PCs explain 80% of variance; (3) create a biplot and identify which variables drive PC1 and PC2; (4) project k-means clusters into PC1-PC2 space and assess visual separation.

## Check

```
npm run check -- bdat-602 module-04 lesson-03
```

## Reflection

The first two PCs explain 83% of variance, so the PCA plot shows clusters reasonably well. But if two clusters overlap in the PC1-PC2 plot, does that mean k-means has failed? What additional evidence would you look at?
