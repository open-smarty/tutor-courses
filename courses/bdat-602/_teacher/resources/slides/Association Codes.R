 #######################################
 #The "arules" package is not on CRAN
 #So we install it from github.com
 #Internet is require for these three codes
 install.packages("devtools")
 library("devtools")
 install_github("mhahsler/arules")


### Preparing Transactional Data
library(arules)
library(dplyr)

source("simulate_bdat602.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

# --- Step 1: Select and discretise variables ---
# For association mining, ALL variables must be categorical/binary
# Continuous variables must be binned first

trans_df <- health_data |>
  mutate(
    # Binary riders (already 0/1 --- convert to logical labels)
    dental    = ifelse(dental_cover   == 1, "Dental",    NA),
    vision    = ifelse(vision_cover   == 1, "Vision",    NA),
    mental    = ifelse(mental_cover   == 1, "Mental",    NA),
    maternity = ifelse(maternity_cover== 1, "Maternity", NA),
    # Discretise continuous variables into meaningful bins
    age_grp   = cut(age,
                    breaks = c(17, 30, 45, 60, 85),
                    labels = c("Young","MidAge","Senior","Elderly")),
    bmi_grp   = cut(bmi,
                    breaks = c(0, 18.5, 25, 30, 100),
                    labels = c("Underweight","Normal","Overweight","Obese")),
    # Keep categorical variables as-is
    fraud_lbl = ifelse(fraud_flag == 1, "Fraud",    "NoFraud"),
    churn_lbl = ifelse(churned    == 1, "Churned",  "Retained"),
    smoker_lbl= ifelse(smoker     == 1, "Smoker",   "NonSmoker")
  ) |>
  select(dental, vision, mental, maternity,
         plan_tier, region, age_grp, bmi_grp,
         employment_type, smoker_lbl, fraud_lbl, churn_lbl)

####Creating the Transactions Object
library(arules)

# --- Step 2: Convert to arules transactions format ---
# Each row = one policyholder's "basket" of attributes

# Method A: from a data frame of factors/characters
trans_obj <- as(trans_df, "transactions")

# Inspect the transaction object
summary(trans_obj)
# Reports: number of transactions, items, density,
#          most frequent items, transaction size distribution

# --- Item frequency plot: what are the most common items? ---
itemFrequencyPlot(
  trans_obj,
  topN      = 20,
  type      = "absolute",
  main      = "Top 20 Most Frequent Items in Insurance Transactions",
  col       = "steelblue",
  las       = 2,
  cex.names = 0.75
)

# --- Inspect a few transactions ---
inspect(trans_obj[1:5])

#### Running Apriori

library(arules)

# --- Run Apriori algorithm ---
rules_apriori <- apriori(
  trans_obj,
  parameter = list(
    supp     = 0.02,    # at least 2% of policyholders
    conf     = 0.60,    # at least 60% confidence
    minlen   = 2,       # minimum rule length (LHS + RHS items)
    maxlen   = 5        # maximum rule length
  )
)

# How many rules were found?
summary(rules_apriori)

# Inspect top 15 rules sorted by lift
inspect(
  sort(rules_apriori, by = "lift", decreasing = TRUE)[1:15]
)

# --- Focus on rules with fraud on the RHS ---
fraud_rules <- subset(rules_apriori,
                      subset = rhs %in% "fraud_lbl=Fraud" &
                        lift > 1.5)
inspect(sort(fraud_rules, by = "lift"))


### FP-Growth in R ##
library(arules)
# --- FP-Growth in arules ---
# The arules package uses FP-Growth internally when
# eclat() is called, and also supports it via apriori()
# with optimised implementations for large data
# --- Method 1: ECLAT (Equivalence Class Transformation)
# Depth-first search using vertical data format;
# similar efficiency to FP-Growth for itemset mining
rules_eclat <- eclat(trans_obj, parameter = list(supp= 0.02,minlen = 2, maxlen = 5))
# Convert frequent itemsets to rules
rules_from_eclat <- ruleInduction(rules_eclat,trans_obj,
                                  confidence = 0.60)
summary(rules_from_eclat)
inspect(sort(rules_from_eclat, by = "lift")[1:10])


#Scaling Association Mining with Spark
library(sparklyr)
library(dplyr)
sc <- spark_connect(master = "local[*]", version = "3.4.1")
# Copy transactions to Spark
health_tbl <- copy_to(sc, health_data,
name = "health_ins", overwrite = TRUE)
# --- FP-Growth in Spark via sparklyr ---
# ml_fpgrowth() implements the distributed FP-Growth algorithm
# Items must be in a list-column format
# Prepare: create item list column
health_items <- health_tbl |>
mutate(items = array(
ifelse(dental_cover == 1, "Dental",    NULL),
ifelse(vision_cover == 1, "Vision",    NULL),
ifelse(mental_cover == 1, "Mental",    NULL),
ifelse(maternity_cover == 1, "Maternity", NULL),
plan_tier, region)) |>
select(record_id, items)
# Run FP-Growth in Spark
fp_model <- health_items |>
ml_fpgrowth(items_col = "items",
min_support = 0.02,min_confidence  = 0.60)
# Extract association rules
spark_rules <- ml_association_rules(fp_model)
spark_rules |> collect() |> arrange(desc(lift)) |> head(15)




##### Sequence Mining with arulesSequences####
library(arulesSequences)
library(dplyr)

# --- Build a sequence database from claims history ---
# Each policyholder has a sequence of events over time

# Construct event sequences: one row per event per policyholder
event_seq <- health_data |>
filter(num_claims > 0) |>
select(policyholder_id, policy_start_date,
       days_since_last_claim, support_calls, churned) |>
mutate(
event1 = "Claim",
event2 = ifelse(support_calls > 0, "SupportCall", NA),
event3 = ifelse(churned == 1, "Churn", NA)) |>
tidyr::pivot_longer(cols = starts_with("event"),
                      values_to = "event") |>
filter(!is.na(event)) |>
arrange(policyholder_id)

# Convert to transaction sequences format
# (arulesSequences requires a specific format)
# See package vignette for full specification:
# vignette("arulesSequences")

# Mine frequent sequences
seq_rules <- cspade(
as(event_seq, "transactions"),  # after proper formatting
parameter = list(support = 0.02),
control   = list(verbose = TRUE)
)

inspect(seq_rules)



#### Filtering and Inspecting Rules ###
library(arules)
library(dplyr)

# --- Filter rules by multiple criteria ---

# 1. Keep only rules with lift > 1.2 (positively associated)
strong_rules <- subset(rules_apriori,
                       subset = lift > 1.2)

# 2. Focus on churn-related rules (churn on the RHS)
churn_rules <- subset(rules_apriori,
                      subset = rhs %in% "churn_lbl=Churned" &
                        lift > 1.3 &
                        confidence > 0.65)
inspect(sort(churn_rules, by = "lift"))

# 3. Remove redundant rules
non_redundant <- rules_apriori[!is.redundant(rules_apriori)]
cat("Rules before:", length(rules_apriori), "\n")
cat("Rules after removing redundant:", length(non_redundant), "\n")

# 4. Convert rules to a data frame for further analysis
rules_df <- as(non_redundant, "data.frame")
head(rules_df |> arrange(desc(lift)), 10)

# 5. Find rules containing a specific item anywhere
dental_rules <- subset(rules_apriori,
                       items %in% "dental=Dental")
inspect(sort(dental_rules, by = "confidence")[1:10])


##### Visualising Rules with arulesViz###
library(arulesViz)

# --- 1. Scatter plot: support vs confidence, coloured by lift ---
plot(rules_apriori,
     measure  = c("support", "confidence"),
     shading  = "lift",
     main     = "Association Rules: Support vs Confidence (shade = Lift)",
     col      = colorRampPalette(c("steelblue","gold","red"))(100))

# --- 2. Graph plot: items as nodes, rules as directed edges ---
# Use only top 30 rules by lift for readability
top30 <- sort(rules_apriori, by = "lift")[1:30]

plot(top30,
     method = "graph",
     engine = "htmlwidget")   # interactive; opens in browser

# --- 3. Grouped matrix plot ---
plot(rules_apriori,
     method  = "grouped",
     control = list(k = 10),
     main    = "Grouped Matrix of Association Rules")

# --- 4. Parallel coordinates plot ---
plot(top30,
     method = "paracoord",
     control = list(reorder = TRUE))




########## Interpreting the Graph Plot###

library(arulesViz)
library(igraph)

# --- Detailed graph plot with custom aesthetics ---
plot(top30,
     method  = "graph",
     engine  = "igraph",
     control = list(
       layout     = igraph::layout_with_fr,
       nodeCol    = grey.colors(10),
       edgeCol    = "steelblue",
       arrowSize  = 0.5,
       precision  = 3
     ),
     main = "Top 30 Rules by Lift: Graph Visualisation")

# Reading the graph:
# - Circles = ITEMS (attributes)
# - Squares = RULES
# - Arrow from item circle to rule square = LHS item
# - Arrow from rule square to item circle = RHS item
# - Larger square = higher support
# - Darker colour = higher lift

# --- Which items appear most in high-lift rules? ---
rules_df <- as(top30, "data.frame")
cat("Top consequents (RHS) in high-lift rules:\n")
table(rules_df$rules) |> sort(decreasing = TRUE) |> head(10)


####### Statistical Significance of Rules ####

library(arules)

# --- Compute additional interest measures ---
measures <- interestMeasure(
  rules_apriori,
  measure      = c("support", "confidence", "lift",
                   "conviction", "leverage",
                   "fishersExactTest"),
  transactions = trans_obj
)

# Attach measures to rules data frame
rules_df <- as(rules_apriori, "data.frame")
rules_df <- cbind(rules_df, measures)

# Filter: lift > 1.5 AND Fisher p-value < 0.01 (statistically significant)
significant_rules <- rules_df |>
  filter(lift > 1.5,
         fishersExactTest < 0.01) |>
  arrange(desc(lift))

nrow(significant_rules)

# Display top rules
significant_rules |>
  select(rules, support, confidence, lift,
  conviction, fishersExactTest) |>
  head(15)
