# Lesson 8: Distance Measures and k-Means Clustering

## Goal

After this lesson you can compute Euclidean, Manhattan, Minkowski, cosine, and Gower distances between policyholder feature vectors; explain why all features must be scaled before clustering; state the k-means WCSS objective function; trace Lloyd's algorithm through two full iterations on a small dataset; choose $k$ using the elbow method; fit k-means with `factoextra::fviz_cluster()`; and profile each cluster in business terms.

## Concept

### Why clustering?

Clustering is **unsupervised** — there are no predefined labels. The goal is to discover natural groups in the data: which policyholders resemble each other enough to be grouped together? For a health insurer, useful segments might be "young low-risk", "elderly high-utilisation", or "mid-career fraudulent claimers". Each segment gets a tailored product, pricing, or intervention.

Clustering differs from classification in that no target variable exists. The algorithm finds structure purely from the feature space.

### Distance and similarity measures

All clustering algorithms rely on a notion of "closeness" between observations. The choice of distance measure is as important as the choice of algorithm.

**Euclidean distance** (straight-line, $L_2$):
$$d_E(\mathbf{x}, \mathbf{y}) = \sqrt{\sum_{j=1}^{p} (x_j - y_j)^2}$$

Standard for continuous, normally distributed features on comparable scales. The most commonly used metric.

**Manhattan distance** (city-block, $L_1$):
$$d_M(\mathbf{x}, \mathbf{y}) = \sum_{j=1}^{p} |x_j - y_j|$$

Less sensitive to large differences in a single dimension than Euclidean. More robust to outliers in high-dimensional data.

**Minkowski distance** ($L_p$, generalises both):
$$d_p(\mathbf{x}, \mathbf{y}) = \left(\sum_{j=1}^{p} |x_j - y_j|^p\right)^{1/p}$$

$p = 1$ gives Manhattan; $p = 2$ gives Euclidean; $p \to \infty$ gives the Chebyshev distance (maximum absolute difference across dimensions).

**Cosine distance** — measures the angle between two vectors, not their magnitude:
$$d_{\cos}(\mathbf{x}, \mathbf{y}) = 1 - \frac{\mathbf{x} \cdot \mathbf{y}}{\|\mathbf{x}\|\,\|\mathbf{y}\|}$$

Appropriate when the magnitude of a vector is less important than its direction — for example, TF-IDF document vectors where two documents of different length may have the same topical content.

**Gower distance** — handles mixed data types (numeric, categorical, binary) by computing a feature-specific similarity for each variable and averaging:
$$d_G(\mathbf{x}, \mathbf{y}) = 1 - \frac{1}{p} \sum_{j=1}^{p} s_j(x_j, y_j)$$

where $s_j$ is 1 for identical categorical values, a range-normalised absolute difference for numeric variables, or the Jaccard similarity for binary variables. Use Gower when your feature matrix contains a mix of variable types.

### Why scaling is mandatory

Consider two features: age (range 20–80) and income (range 20,000–200,000). The Euclidean distance between two policyholders with the same age but different incomes will be dominated entirely by the income difference — age is irrelevant in practice. Scaling removes this artefact.

**Z-score standardisation** (most common):
$$x_j^* = \frac{x_j - \bar{x}_j}{s_j}$$

After scaling, every feature has mean 0 and standard deviation 1. Use `scale()` in R.

**A practical note on skewed features**: the insurance dataset has right-skewed income and claim\_amount. Apply a log (or signed-log) transformation *before* scaling to prevent a handful of extreme values from distorting centroids:

```r
signed_log <- function(x) sign(x) * log1p(abs(x))
```

### k-Means clustering

k-Means partitions $n$ observations into $k$ non-overlapping clusters so that points within a cluster are as similar as possible.

**Objective — minimise the Within-Cluster Sum of Squares (WCSS)**:
$$\text{WCSS} = \sum_{k=1}^{K} \sum_{i \in C_k} \|\mathbf{x}_i - \boldsymbol{\mu}_k\|^2$$

where $\boldsymbol{\mu}_k = \frac{1}{|C_k|} \sum_{i \in C_k} \mathbf{x}_i$ is the centroid of cluster $k$.

**Why squared distances?** The centroid (mean) is the point that minimises the sum of squared distances. Using squared distances makes the update step trivial — recompute the mean.

### Lloyd's algorithm

1. **Initialise**: randomly choose $k$ data points as initial centroids $\boldsymbol{\mu}_1, \ldots, \boldsymbol{\mu}_k$.
2. **Assignment step**: assign each point to the nearest centroid:
$$c_i = \arg\min_{k} \|\mathbf{x}_i - \boldsymbol{\mu}_k\|^2$$
3. **Update step**: recompute each centroid as the mean of its assigned points:
$$\boldsymbol{\mu}_k \leftarrow \frac{1}{|C_k|} \sum_{i:\, c_i = k} \mathbf{x}_i$$
4. **Repeat** steps 2–3 until no assignments change (convergence).

**Convergence is guaranteed** because WCSS decreases (or stays the same) at every step. However, Lloyd's only finds a **local minimum** — the result depends on initial centroids. Use `nstart = 25` to run the algorithm 25 times with different random starts and keep the lowest-WCSS solution.

### k-Means++ initialisation

Standard random initialisation can place multiple centroids in the same dense region, leading to slow convergence and poor solutions. **k-Means++** (Arthur & Vassilvitskii 2007) spreads the initial centroids more evenly:

1. Choose the first centroid uniformly at random.
2. For each subsequent centroid, choose a data point with probability proportional to its squared distance from the nearest already-chosen centroid.

k-Means++ often finds a better local minimum in fewer iterations. R's `kmeans()` uses a similar heuristic automatically when `nstart > 1`.

### Choosing k: the elbow method

Plot WCSS against $k$ for $k = 1, 2, \ldots, 10$. WCSS always decreases as $k$ increases (in the extreme, $k = n$ gives WCSS = 0). The "elbow" is the value of $k$ where the rate of decrease sharply slows — adding one more cluster beyond this point yields diminishing returns in variance explained.

```r
set.seed(602)
elbow_plot <- fviz_nbclust(
  health_scaled,
  FUNcluster = kmeans,
  method     = "wss",
  k.max      = 10,
  nstart     = 10
) +
  labs(title = "Elbow Method: Choosing Optimal k",
       x = "Number of Clusters k", y = "Total Within-Cluster SS") +
  theme_minimal()
```

The elbow is often subtle with real data. If unclear, combine the elbow method with the silhouette method (covered in Lesson 10).

### Fitting k-means in R

```r
set.seed(602)
km_fit <- kmeans(
  health_scaled,
  centers  = 4,
  nstart   = 25,
  iter.max = 100
)

km_fit$size           # cluster sizes
km_fit$tot.withinss   # total WCSS
km_fit$betweenss / km_fit$totss  # proportion of variance explained
```

### Profiling and visualising clusters

Add cluster labels back to the original (unscaled) data and summarise each cluster:

```r
health_sub$cluster <- factor(km_fit$cluster)

health_sub |>
  group_by(cluster) |>
  summarise(
    n             = n(),
    avg_age       = mean(age),
    avg_bmi       = mean(bmi,     na.rm = TRUE),
    avg_income    = mean(income,  na.rm = TRUE),
    avg_claims    = mean(num_claims),
    pct_smoker    = mean(smoker)     * 100,
    pct_fraud     = mean(fraud_flag) * 100,
    pct_churned   = mean(churned)    * 100
  ) |>
  arrange(desc(avg_claims))
```

Assign each cluster a descriptive business label based on the profile: "Young healthy", "Elderly high-utilisation", "Mid-career frequent claimers", "Fraud-prone unemployed".

Visualise clusters in 2D using a PCA projection:

```r
fviz_cluster(
  km_fit,
  data         = health_scaled,
  geom         = "point",
  ellipse      = TRUE,
  ellipse.type = "convex",
  alpha        = 0.3,
  palette      = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3"),
  ggtheme      = theme_minimal(),
  main         = "k-Means Clusters (k = 4): PCA Projection"
)
```

The 2D projection is informative but not the full picture — clusters separated in dimensions 3+ may appear to overlap here.

## Example

```r
library(tidyverse)
library(factoextra)

source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

cluster_vars <- c("age", "bmi", "income", "premium",
                  "num_chronic_conditions", "num_claims",
                  "claim_amount", "support_calls",
                  "customer_rating", "app_logins_monthly")

set.seed(602)
health_sub <- health_data |>
  filter(!is.na(bmi), !is.na(income)) |>
  slice_sample(n = 50000)

signed_log <- function(x) sign(x) * log1p(abs(x))

health_scaled <- health_sub |>
  select(all_of(cluster_vars)) |>
  mutate(income = signed_log(income), claim_amount = log1p(claim_amount)) |>
  scale() |>
  as.data.frame()

# Elbow plot
fviz_nbclust(health_scaled, kmeans, method = "wss", k.max = 10, nstart = 10)

# Fit k = 4
set.seed(602)
km_fit <- kmeans(health_scaled, centers = 4, nstart = 25, iter.max = 100)

cat("Variance explained:", round(km_fit$betweenss / km_fit$totss * 100, 1), "%\n")

# Cluster profile
health_sub$cluster <- factor(km_fit$cluster)
health_sub |> group_by(cluster) |>
  summarise(n = n(), avg_age = mean(age), avg_claims = mean(num_claims),
            pct_fraud = mean(fraud_flag) * 100, pct_churned = mean(churned) * 100) |>
  arrange(desc(avg_claims))

# Visualise
fviz_cluster(km_fit, data = health_scaled, geom = "point",
             ellipse.type = "convex", alpha = 0.3, ggtheme = theme_minimal())
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) prepare and scale the 10 clustering features from the insurance dataset (50,000-row sample), applying log transforms to income and claim\_amount; (2) compute Euclidean and Manhattan distances between the first five scaled observations and comment on which features dominate each metric; (3) produce the elbow plot and identify the optimal $k$; (4) fit k-means with your chosen $k$ and nstart = 25, profile each cluster, and assign a descriptive business label.

## Check

```
npm run check -- bdat-602 module-04 lesson-01
```

## Reflection

k-Means assumes spherical clusters of similar size and uses Euclidean distance, which treats all dimensions equally. The insurance dataset includes both continuous features (age, income) and binary flags (smoker, fraud\_flag). What are the consequences of including the binary flags in the Euclidean distance calculation, and what alternative distance measure or pre-processing step could address this?
