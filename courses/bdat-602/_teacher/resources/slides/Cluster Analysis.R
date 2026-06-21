##$k$-Means on the Insurance Dataset

library(dplyr)
library(factoextra)

source("simulate_bdat602.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

# --- Step 1: Select and scale features ---
cluster_vars <- c("age", "bmi", "income", "premium",
                  "num_chronic_conditions", "num_claims",
                  "claim_amount", "support_calls",
                  "customer_rating", "app_logins_monthly")

# Use a 50,000-row sample for local computation
set.seed(602)
health_sub <- health_data |>
  filter(!is.na(bmi), !is.na(income)) |>
  slice_sample(n = 50000)

# Scale all selected numeric variables
signed_log <- function(x) {
  sign(x) * log1p(abs(x))
}

health_scaled <- health_sub |>
  select(all_of(cluster_vars)) |>
  mutate(
    income = signed_log(income),
    claim_amount = log1p(claim_amount)
  ) |>
  scale() |>
  as.data.frame()



# Confirm: means ~0, sds ~1
colMeans(health_scaled) |> round(3)
apply(health_scaled, 2, sd) |> round(3)

# Elbow Method and Running $k$-Means}
library(factoextra)

# --- Step 2: Elbow method to choose k ---
set.seed(602)
elbow_plot <- fviz_nbclust(
  health_scaled,
  FUNcluster = kmeans,
  method     = "wss",          # within-cluster sum of squares
  k.max      = 10,
  nstart     = 10
) +
  labs(title = "Elbow Method: Choosing Optimal k",
       x     = "Number of Clusters k",
       y     = "Total Within-Cluster Sum of Squares") +
  theme_minimal()

elbow_plot

# --- Step 3: Fit k-means with chosen k (e.g. k = 4) ---
set.seed(602)
km_fit <- kmeans(
  health_scaled,
  centers = 4,
  nstart  = 25,      # 25 random starts; keep best
  iter.max = 100     # allow enough iterations to converge
)

# Cluster sizes
km_fit$size

# Within-cluster SS and between-cluster SS
km_fit$tot.withinss
km_fit$betweenss / km_fit$totss   # proportion of variance explained
Profiling and Visualising Clusters
library(ggplot2)
library(factoextra)

# --- Step 4: Add cluster labels back to original data ---
health_sub$cluster <- factor(km_fit$cluster)

# --- Step 5: Profile each cluster ---
health_sub |>
  group_by(cluster) |>
  summarise(
    n             = n(),
    avg_age       = mean(age),
    avg_bmi       = mean(bmi,    na.rm = TRUE),
    avg_income    = mean(income, na.rm = TRUE),
    avg_claims    = mean(num_claims),
    avg_claim_amt = mean(claim_amount),
    pct_smoker    = mean(smoker) * 100,
    pct_fraud     = mean(fraud_flag) * 100,
    pct_churned   = mean(churned)    * 100
  ) |>
  arrange(desc(avg_claim_amt))

# --- Step 6: Visualise clusters in 2D (PCA projection) ---
fviz_cluster(
  km_fit,
  data        = health_scaled,
  geom        = "point",
  ellipse     = TRUE,
  ellipse.type= "convex",
  alpha       = 0.3,
  palette     = c("#E41A1C","#377EB8","#4DAF4A","#984EA3"),
  ggtheme     = theme_minimal(),
  main        = "k-Means Clusters (k=4): PCA Projection"
)


#Hierarchical Clustering and Dendrogram
library(factoextra)
library(ggplot2)

# --- Use a smaller subset for hierarchical clustering ---
# hclust() requires an n x n distance matrix: expensive for large n
set.seed(602)
health_hc <- health_scaled |> slice_sample(n = 2000)

# --- Step 1: Compute distance matrix ---
dist_matrix <- dist(health_hc, method = "euclidean")

# --- Step 2: Hierarchical clustering with Ward's linkage ---
hc_fit <- hclust(dist_matrix, method = "ward.D2")

# --- Step 3: Plot the dendrogram ---
fviz_dend(
  hc_fit,
  k          = 4,            # colour 4 clusters
  cex        = 0.4,
  palette    = "jco",
  rect       = TRUE,
  rect_fill  = TRUE,
  main       = "Dendrogram: Health Insurance Policyholders",
  xlab       = "Policyholders",
  ylab       = "Height (Ward Linkage Distance)"
)

# --- Step 4: Cut the tree at k=4 ---
hc_labels <- cutree(hc_fit, k = 4)
table(hc_labels)

# --- Compare with k-means solution ---
# Are the 4 clusters from hclust similar to k-means?
table(km_fit$cluster[1:2000], hc_labels)

#DBSCAN on Insurance Data
library(dbscan)
library(factoextra)

# --- Use a 2D projection for easy visualisation ---
# Apply PCA first; cluster on PC1 and PC2
pca_result <- prcomp(health_scaled, scale. = FALSE)
pca_2d     <- pca_result$x[, 1:2]   # first two PCs

# --- Step 1: k-NN distance plot to choose eps ---
kNNdistplot(
  pca_2d,
  k    = 4,          # MinPts - 1
  main = "k-NN Distance Plot: Choosing epsilon"
)
abline(h = 0.5, col = "red", lty = 2)   # candidate eps

# --- Step 2: Run DBSCAN ---
db_fit <- dbscan(
  pca_2d,
  eps     = 0.5,     # set from k-NN distance plot
  minPts  = 5
)
# Cluster membership (0 = noise)
table(db_fit$cluster)

# --- Step 3: Visualise DBSCAN results ---
fviz_cluster(
  db_fit,
  data    = pca_2d,
  geom    = "point",
  palette = "Set2",
  ggtheme = theme_minimal(),
  main    = "DBSCAN Clusters (eps=0.5, MinPts=5)"
)


#Using DBSCAN for Anomaly Detection
# --- DBSCAN noise points as anomaly candidates ---
# Points labelled 0 by DBSCAN do not belong to any dense cluster
# In our insurance context, these may be fraudulent or unusual records

noise_idx <- which(db_fit$cluster == 0)
cat("Number of noise points detected:", length(noise_idx), "\n")
cat("As % of total:", round(100 * length(noise_idx) /
                              nrow(pca_2d), 2), "%\n")

# Profile the noise points
health_sub[noise_idx, ] |>
  summarise(
    n             = n(),
    avg_age       = mean(age),
    avg_bmi       = mean(bmi,         na.rm = TRUE),
    avg_claim     = mean(claim_amount),
    pct_fraud     = mean(fraud_flag)  * 100,
    pct_unemployed= mean(employment_type == "Unemployed") * 100
  )

# Compare fraud rate: noise points vs.\ cluster members
cat("Fraud rate in noise points: ",
    round(mean(health_sub$fraud_flag[noise_idx]) * 100, 1), "%\n")
cat("Fraud rate in clusters    : ",
    round(mean(health_sub$fraud_flag[-noise_idx]) * 100, 1), "%\n")



#Silhouette Score and Optimal k
library(cluster)
library(factoextra)

# --- Method 1: Silhouette plot for a fixed k ---
# Compute pairwise distances
dist_sub <- dist(health_scaled[1:5000, ], method = "euclidean")

# k-means with k=4
set.seed(602)
km4 <- kmeans(health_scaled[1:5000, ], centers = 4, nstart = 25)

# Silhouette values for each observation
sil_scores <- silhouette(km4$cluster, dist_sub)
summary(sil_scores)           # mean silhouette width

# Silhouette plot
fviz_silhouette(
  sil_scores,
  palette = "jco",
  ggtheme = theme_minimal(),
  main    = "Silhouette Plot: k-Means (k=4)"
)

# --- Method 2: Silhouette method to choose optimal k ---
fviz_nbclust(
  health_scaled[1:5000, ],
  FUNcluster = kmeans,
  method     = "silhouette",
  k.max      = 10,
  nstart     = 10
) +
  labs(title = "Silhouette Method: Optimal Number of Clusters",
       x     = "Number of Clusters k",
       y     = "Average Silhouette Width") +
  theme_minimal()

#Distributed $k$-Means with sparklyr
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

# --- Step 1: Copy data to Spark and preprocess ---
health_tbl <- copy_to(sc, health_data,
                      name = "health_ins", overwrite = TRUE)

# Scale in Spark using ft_standard_scaler (via pipeline)
health_spark_scaled <- health_tbl |>
  mutate(
    log_income = log1p(income),
    log_claim  = log1p(claim_amount)
  ) |>
  select(age, bmi, log_income, premium,
         num_chronic_conditions, num_claims,
         log_claim, support_calls,
         customer_rating, app_logins_monthly)

# --- Step 2: Run k-means in Spark ---
set.seed(602)
spark_km <- health_spark_scaled |>
  ml_kmeans(
    formula    = ~ .,
    k          = 4,
    max_iter   = 100,
    init_mode  = "k-means||",   # scalable initialisation
    seed       = 602
  )

# --- Step 3: Inspect cluster centres ---
spark_km$centers



#Collecting and Profiling Spark Clusters
# --- Step 4: Get predictions (cluster assignments) ---
spark_predictions <- ml_predict(spark_km, health_spark_scaled)

# --- Step 5: Join back to full data for profiling ---
# Add record_id to spark data for joining
health_with_id <- health_tbl |>
  mutate(
    log_income = log1p(income),
    log_claim  = log1p(claim_amount)
  ) |>
  select(record_id, age, bmi, log_income, premium,
         num_chronic_conditions, num_claims,
         log_claim, support_calls,
         customer_rating, app_logins_monthly,
         smoker, fraud_flag, churned, plan_tier)

cluster_results <- ml_predict(spark_km, health_with_id)

# --- Step 6: Profile clusters in Spark ---
cluster_results |>
  group_by(prediction) |>
  summarise(
    n             = n(),
    avg_age       = mean(age,          na.rm = TRUE),
    avg_bmi       = mean(bmi,          na.rm = TRUE),
    avg_claims    = mean(num_claims,   na.rm = TRUE),
    pct_fraud     = mean(fraud_flag,   na.rm = TRUE) * 100,
    pct_churned   = mean(churned,      na.rm = TRUE) * 100,
    avg_support   = mean(support_calls,na.rm = TRUE)
  ) |>
  collect() |>
  arrange(desc(avg_claims))


#Elbow Method in Spark
# --- Elbow method in Spark: run k-means for k=2..8 ---
wcss_results <- purrr::map_dfr(2:8, function(k) {
  model <- health_spark_scaled |>
    ml_kmeans(
      formula   = ~ .,
      k         = k,
      max_iter  = 50,
      init_mode = "k-means||",
      seed      = 602
    )
  tibble(
    k    = k,
    wcss = model$summary$trainingCost  # within-cluster SS
  )
})

# Plot the elbow curve
library(ggplot2)
ggplot(wcss_results, aes(x = k, y = wcss)) +
  geom_line(colour = "steelblue", linewidth = 1) +
  geom_point(colour = "steelblue", size = 3) +
  labs(
    title = "Elbow Method: Spark k-Means (n = 500,000)",
    x     = "Number of Clusters k",
    y     = "Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal()




