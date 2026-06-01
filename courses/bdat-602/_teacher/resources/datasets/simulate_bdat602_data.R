# =============================================================================
# BDAT 602: Data Mining and Applications
# Simulated Dataset: Global Health Insurance Portfolio
# -----------------------------------------------------------------------------
# Covers ALL six weeks of BDAT 602 and feeds directly into BDAT 604:
#   Week 1  – Data types, 4 Vs, KDD overview
#   Week 2  – Cleaning: intentional NAs, outliers, skewed variables
#   Week 3  – Association rules: binary product/condition flags
#   Week 4  – Clustering: rich continuous variables
#   Week 5  – Classification: binary targets (high_risk, churned, fraud_flag)
#   Week 6  – Text mining: free-text complaint_notes column
#   BDAT604 – Regression target (claim_amount), fairness audit variables
#
# n = 500,000 rows | 30 variables (4 ID + 26 analytical)
# =============================================================================

library(dplyr)
library(lubridate)

simulate_bdat602 <- function(n = 500000, seed = 602) {
  
  set.seed(seed)
  
  # ── SECTION 1: IDENTIFIERS (4 variables) ─────────────────────────────────────
  # High-cardinality IDs — used in Week 1 to discuss data types and cardinality
  
  record_id        <- 1:n
  policyholder_id  <- sample(1:round(n * 0.70), n, replace = TRUE)  # ~350k unique customers
  agent_id         <- sample(1:5000,  n, replace = TRUE)             # 5,000 agents
  provider_id      <- sample(1:2000,  n, replace = TRUE)             # 2,000 providers
  
  
  # ── SECTION 2: DEMOGRAPHICS (7 variables) ────────────────────────────────────
  # Real-world distributions; sex/region introduce fairness discussion in BDAT604
  
  age <- pmax(18, pmin(85, round(rnorm(n, mean = 43, sd = 14))))
  
  sex <- sample(c("Male", "Female"), n, replace = TRUE, prob = c(0.49, 0.51))
  
  region <- sample(
    c("North America", "Europe", "Asia", "Africa", "South America", "Oceania"),
    n, replace = TRUE,
    prob = c(0.28, 0.22, 0.26, 0.12, 0.08, 0.04)
  )
  
  education <- sample(
    c("None", "Primary", "Secondary", "Tertiary", "Postgraduate"),
    n, replace = TRUE,
    prob = c(0.05, 0.15, 0.30, 0.35, 0.15)
  )
  
  employment_type <- sample(
    c("Full-time", "Part-time", "Self-employed", "Unemployed", "Retired"),
    n, replace = TRUE,
    prob = c(0.45, 0.15, 0.15, 0.10, 0.15)
  )
  
  # Income: structured by education + region + employment + lognormal noise
  # Intentionally right-skewed — good outlier/transform example for Week 2
  base_income <- case_when(
    education == "None"         ~  8000,
    education == "Primary"      ~ 14000,
    education == "Secondary"    ~ 28000,
    education == "Tertiary"     ~ 52000,
    education == "Postgraduate" ~ 80000,
    TRUE                        ~ 28000
  )
  
  income <- round(
    base_income *
      ifelse(sex == "Male", 1.12, 1.00) *
      ifelse(region %in% c("North America", "Europe", "Oceania"), 1.40, 1.00) *
      case_when(
        employment_type == "Full-time"     ~ 1.00,
        employment_type == "Part-time"     ~ 0.60,
        employment_type == "Self-employed" ~ 1.10,
        employment_type == "Unemployed"    ~ 0.20,
        employment_type == "Retired"       ~ 0.70,
        TRUE                               ~ 1.00
      ) *
      rlnorm(n, meanlog = 0, sdlog = 0.35),
    2
  )
  
  # BMI: correlated with age, sex, and region — clustering variable (Week 4)
  bmi_mean <- 24 +
    0.08 * (age - 30) +
    ifelse(sex == "Male", 0.5, -0.5) +
    ifelse(region %in% c("North America", "Oceania"), 1.5, 0)
  
  bmi <- round(pmax(16, pmin(50, rnorm(n, mean = bmi_mean, sd = 4))), 1)
  
  # Smoker: logistic model — association mining (Week 3) and fairness (BDAT604)
  smoke_prob <- plogis(
    -1.8 +
      0.40 * (sex == "Male") +
      0.50 * (education %in% c("None", "Primary")) +
      0.30 * (region == "Asia") -
      0.30 * (employment_type == "Full-time")
  )
  smoker <- rbinom(n, 1, prob = smoke_prob)
  
  
  # ── SECTION 3: POLICY DETAILS (6 variables) ───────────────────────────────────
  # Core insurance product variables — association rules between tier and add-ons
  
  plan_tier <- sample(
    c("Bronze", "Silver", "Gold", "Platinum"),
    n, replace = TRUE,
    prob = c(0.30, 0.35, 0.25, 0.10)
  )
  
  # Premium: age, smoker, BMI drive the price — regression signal for BDAT604
  base_premium <- case_when(
    plan_tier == "Bronze"   ~  150,
    plan_tier == "Silver"   ~  280,
    plan_tier == "Gold"     ~  450,
    plan_tier == "Platinum" ~  750,
    TRUE                    ~  280
  )
  
  premium <- round(
    base_premium *
      (1 + 0.025 * pmax(0, age - 30)) *
      (1 + 0.400 * smoker) *
      (1 + 0.015 * pmax(0, bmi - 25)) *
      rlnorm(n, meanlog = 0, sdlog = 0.10),
    2
  )
  
  # Deductible: inversely related to plan tier (cost-sharing mechanism)
  deductible <- round(
    case_when(
      plan_tier == "Bronze"   ~ runif(n, 2000, 5000),
      plan_tier == "Silver"   ~ runif(n, 1000, 3000),
      plan_tier == "Gold"     ~ runif(n,  500, 1500),
      plan_tier == "Platinum" ~ runif(n,    0,  500),
      TRUE                    ~ runif(n, 1000, 3000)
    ),
    0
  )
  
  # Coverage amount: higher tier = higher ceiling
  coverage_amount <- round(
    case_when(
      plan_tier == "Bronze"   ~ runif(n,  50000,  100000),
      plan_tier == "Silver"   ~ runif(n, 100000,  250000),
      plan_tier == "Gold"     ~ runif(n, 250000,  500000),
      plan_tier == "Platinum" ~ runif(n, 500000, 1500000),
      TRUE                    ~ runif(n, 100000,  250000)
    ),
    0
  )
  
  # Policy age (months): lognormal — long-tail distribution example (Week 2)
  policy_age_months <- pmax(1, round(rlnorm(n, meanlog = 3.0, sdlog = 0.8)))
  
  policy_start_date <- as.Date("2024-12-31") - months(policy_age_months)
  
  # Optional add-on riders — binary flags; great for association rule mining (Week 3)
  # Probabilities correlated with plan tier and demographics
  dental_cover   <- rbinom(n, 1, prob = ifelse(plan_tier %in% c("Gold","Platinum"), 0.75, 0.30))
  vision_cover   <- rbinom(n, 1, prob = ifelse(plan_tier %in% c("Gold","Platinum"), 0.65, 0.25))
  mental_cover   <- rbinom(n, 1, prob = ifelse(plan_tier %in% c("Gold","Platinum"), 0.70, 0.20))
  maternity_cover <- rbinom(n, 1, prob = ifelse(sex == "Female" & age < 45, 0.40, 0.08))
  
  
  # ── SECTION 4: MEDICAL USAGE (4 variables) ────────────────────────────────────
  # Count variables — skewed, Poisson-like; good for EDA and normalisation (Week 2)
  
  chronic_prob <- plogis(
    -2.5 +
      0.04 * (age - 40) +
      0.06 * (bmi - 25) +
      0.60 * smoker +
      0.30 * (plan_tier %in% c("Gold", "Platinum"))
  )
  num_chronic_conditions <- rpois(n, lambda = pmax(0.05, chronic_prob * 3))
  
  # Doctor visits per year
  num_visits <- rpois(n, lambda = pmax(
    0.5,
    1.5 + 0.08 * age + 1.5 * num_chronic_conditions
  ))
  
  # Prescriptions per year
  num_prescriptions <- rpois(n, lambda = pmax(
    0,
    0.5 + 0.05 * age + 1.2 * num_chronic_conditions + 0.4 * smoker
  ))
  
  # Hospital admissions per year (sparse — many zeros)
  num_hospital_admissions <- rpois(n, lambda = pmax(
    0,
    0.05 + 0.02 * age + 0.5 * num_chronic_conditions + 0.3 * smoker
  ))
  
  
  # ── SECTION 5: CLAIMS HISTORY (5 variables) ───────────────────────────────────
  # The main regression and classification targets live here
  
  num_claims <- rpois(n, lambda = pmax(
    0.1,
    0.3 * policy_age_months / 12 +
      0.8 * num_chronic_conditions +
      0.4 * num_visits / 10 +
      0.5 * smoker +
      0.03 * pmax(0, bmi - 25)
  ))
  
  avg_past_claim <- round(
    ifelse(
      num_claims == 0, 0,
      pmax(0,
        500 +
          20  * age +
          80  * num_chronic_conditions +
          200 * smoker +
          case_when(
            plan_tier == "Bronze"   ~    0,
            plan_tier == "Silver"   ~  500,
            plan_tier == "Gold"     ~ 1500,
            plan_tier == "Platinum" ~ 4000,
            TRUE                    ~  500
          ) +
          rlnorm(n, 0, 0.5) * 200
      )
    ),
    2
  )
  
  # PRIMARY REGRESSION TARGET for BDAT604 Week 1
  # Strong, interpretable signal from age, chronic conditions, BMI, smoker, plan
  claim_amount <- round(
    ifelse(
      num_claims == 0, 0,
      pmax(0,
        200 +
          15  * age +
          100 * num_chronic_conditions +
          180 * smoker +
          25  * pmax(0, bmi - 25) +
          10  * num_prescriptions +
          0.3 * avg_past_claim +
          case_when(
            plan_tier == "Bronze"   ~    0,
            plan_tier == "Silver"   ~  800,
            plan_tier == "Gold"     ~ 2500,
            plan_tier == "Platinum" ~ 7000,
            TRUE                    ~  800
          ) +
          rlnorm(n, 0, 0.6) * 300
      )
    ),
    2
  )
  
  days_since_last_claim <- ifelse(
    num_claims == 0, NA_real_,
    round(runif(n, 1, 730))
  )
  
  last_claim_date <- as.Date("2024-12-31") -
    days(ifelse(is.na(days_since_last_claim), 9999, days_since_last_claim))
  last_claim_date[is.na(days_since_last_claim)] <- NA
  
  weekend_claim <- ifelse(
    !is.na(last_claim_date),
    wday(last_claim_date) %in% c(1, 7),
    NA
  )
  
  
  # ── SECTION 6: FRAUD FLAG — rare event ~3% (Week 5 imbalanced classes) ────────
  
  fraud_score <- plogis(
    -4.5 +
      0.8 * (claim_amount > quantile(claim_amount[claim_amount > 0], 0.90, na.rm = TRUE)) +
      0.5 * (age < 30) +
      0.7 * (employment_type == "Unemployed") +
      0.4 * ifelse(is.na(weekend_claim), 0, weekend_claim) +
      0.3 * (num_claims > 5) +
      rnorm(n, 0, 0.3)
  )
  fraud_flag <- rbinom(n, 1, prob = pmin(fraud_score, 0.50))
  
  
  # ── SECTION 7: CUSTOMER BEHAVIOUR (5 variables) ───────────────────────────────
  # Engagement metrics — useful for clustering customer segments (Week 4)
  
  payment_method <- sample(
    c("Direct Debit", "Credit Card", "Bank Transfer", "Mobile Money"),
    n, replace = TRUE,
    prob = c(0.45, 0.30, 0.15, 0.10)
  )
  
  auto_pay <- rbinom(n, 1, prob = ifelse(
    payment_method == "Direct Debit",  0.95,
    ifelse(payment_method == "Credit Card", 0.60, 0.20)
  ))
  
  app_logins_monthly <- round(pmax(0, rnorm(
    n,
    mean = 3 + 2 * (plan_tier %in% c("Gold","Platinum")) +
      1.5 * (num_claims > 0) - 1.5 * (employment_type == "Retired"),
    sd = 2
  )))
  
  support_calls <- rpois(n, lambda = pmax(
    0,
    0.5 + 0.03 * deductible / 1000 +
      0.5 * (num_claims > 3) +
      0.4 * (plan_tier == "Bronze") -
      0.3 * auto_pay
  ))
  
  customer_rating <- pmin(5, pmax(1, round(
    4.2 -
      0.05 * support_calls +
      0.10 * (plan_tier %in% c("Gold", "Platinum")) +
      0.05 * auto_pay -
      0.08 * (deductible > 3000) +
      rnorm(n, 0, 0.6)
  )))
  
  
  # ── SECTION 8: FREE-TEXT COLUMN (Week 6 — Text Mining) ───────────────────────
  # Templated complaint / note text; realistic enough for TF-IDF and LDA topics
  
  complaint_templates <- c(
    # Billing complaints
    "I was charged twice for my premium this month and no one has resolved it.",
    "My premium increased without any prior notice. I need an explanation.",
    "The billing statement is confusing and impossible to understand.",
    "I paid on time but my account shows an outstanding balance.",
    "I was not informed about the deductible changes when my plan renewed.",
    # Claims complaints
    "My claim has been pending for three months with no update whatsoever.",
    "The claim was denied but I followed all the required procedures correctly.",
    "Claim processing is extremely slow and customer service is unhelpful.",
    "I submitted all documents but the claim is still showing as incomplete.",
    "My hospital claim was partially approved without any clear reason given.",
    # Coverage complaints
    "My doctor visit was not covered even though it is listed in my policy.",
    "Dental treatment was refused despite having dental cover on my policy.",
    "The mental health sessions were not reimbursed as expected under my plan.",
    "My prescription medication is not on the approved formulary list.",
    "Physiotherapy sessions are not covered despite being medically necessary.",
    # Service complaints
    "Customer service kept me on hold for over an hour without resolution.",
    "The mobile app crashes every time I try to submit a claim online.",
    "I have been transferred between departments multiple times with no help.",
    "No one responds to my emails and the phone line is always busy.",
    "The online portal does not show my current coverage details correctly.",
    # Positive notes (minority — realistic imbalance)
    "Everything was handled quickly and professionally. Very satisfied.",
    "The claims team was helpful and my reimbursement arrived promptly.",
    "Great service. I renewed my policy without any issues at all.",
    "The app is easy to use and the coverage explanation was very clear.",
    "I am happy with the plan and will recommend it to my family members."
  )
  
  complaint_notes <- sample(complaint_templates, n, replace = TRUE)
  
  # Add some NA (10% of records have no notes — missingness for Week 2)
  complaint_notes[sample(1:n, size = round(n * 0.10))] <- NA_character_
  
  
  # ── SECTION 9: INTENTIONAL DATA QUALITY ISSUES (Week 2) ──────────────────────
  # Inject realistic missingness and outliers for cleaning exercises
  
  # ~5% missing BMI (e.g. not collected at point of sale)
  bmi[sample(1:n, size = round(n * 0.05))]    <- NA_real_
  
  # ~4% missing income (sensitive field — often refused)
  income[sample(1:n, size = round(n * 0.04))] <- NA_real_
  
  # ~3% missing days_since_last_claim already handled above (no-claim records)
  # Additional 2% random missing for non-zero claim records
  has_claims <- which(num_claims > 0)
  days_since_last_claim[sample(has_claims, size = round(length(has_claims) * 0.02))] <- NA_real_
  
  # Inject a small number of extreme BMI outliers (data entry errors)
  bmi[sample(1:n, size = round(n * 0.002))] <- sample(c(5, 8, 120, 150, 200), round(n * 0.002), replace = TRUE)
  
  # Inject extreme income outliers (e.g. data error / ultra-high-net-worth)
  income[sample(1:n, size = round(n * 0.001))] <- sample(c(0, -999, 9999999), round(n * 0.001), replace = TRUE)
  
  
  # ── SECTION 10: TARGET VARIABLES (3 columns) ──────────────────────────────────
  
  # TARGET A — Churn (binary classification, Week 5 and BDAT604)
  churn_prob <- plogis(
    -2.0 -
      0.50 * (customer_rating - 3) +
      0.40 * (deductible / (income / 12 + 1)) +
      0.30 * (num_claims == 0) +
      0.50 * (support_calls > 3) -
      0.04 * policy_age_months +
      0.30 * (plan_tier == "Bronze") -
      0.40 * auto_pay +
      rnorm(n, 0, 0.3)
  )
  churned <- rbinom(n, 1, prob = pmin(churn_prob, 0.85))
  
  # TARGET B — High-risk policyholder (binary classification, Week 5)
  high_risk <- as.integer(
    age > 55 |
      (smoker == 1 & bmi > 30) |
      num_chronic_conditions >= 3 |
      (claim_amount > quantile(claim_amount, 0.80, na.rm = TRUE))
  )
  
  # TARGET C — claim_amount is the continuous regression target (BDAT604 Week 1)
  # Already computed above in Section 5
  
  
  # ── ASSEMBLE FINAL DATA FRAME ─────────────────────────────────────────────────
  # 30 analytical variables + 4 identifiers = 34 total columns
  
  data.frame(
    
    # --- Identifiers (4) ---
    record_id,
    policyholder_id,
    agent_id,
    provider_id,
    
    # --- Demographics (7) ---
    age,
    sex,
    region,
    education,
    employment_type,
    income,
    bmi,
    smoker,
    
    # --- Policy details (8) ---
    plan_tier,
    premium,
    deductible,
    coverage_amount,
    policy_age_months,
    policy_start_date,
    dental_cover,
    vision_cover,
    mental_cover,
    maternity_cover,
    
    # --- Medical usage (4) ---
    num_chronic_conditions,
    num_visits,
    num_prescriptions,
    num_hospital_admissions,
    
    # --- Claims history (5) ---
    num_claims,
    avg_past_claim,
    claim_amount,
    days_since_last_claim,
    weekend_claim,
    
    # --- Fraud (1) ---
    fraud_flag,
    
    # --- Customer behaviour (5) ---
    payment_method,
    auto_pay,
    app_logins_monthly,
    support_calls,
    customer_rating,
    
    # --- Text (1) ---
    complaint_notes,
    
    # --- Targets (3) ---
    churned,
    high_risk,
    # claim_amount serves as the continuous target (already included above)
    
    stringsAsFactors = FALSE
  )
}


# =============================================================================
# USAGE — Run locally or in a Spark environment
# (Only executes when the file is run directly, not when sourced)
# =============================================================================

if (!isTRUE(getOption("bdat602.source_only"))) {

# ── Option A: Pure R (single machine) ──────────────────────────────────────
library(dplyr)
library(lubridate)

health_data <- simulate_bdat602(n = 500000, seed = 602)

cat("Rows     :", nrow(health_data), "\n")
cat("Columns  :", ncol(health_data), "\n")
cat("Targets  : claim_amount (regression), high_risk (classification),",
    "churned (classification), fraud_flag (rare event)\n")
dplyr::glimpse(health_data)


# ── Option B: Push to Spark for large-scale exercises (Weeks 2, 4, 6) ───────
library(sparklyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

health_tbl <- copy_to(
  sc,
  health_data,
  name      = "health_insurance",
  overwrite = TRUE
)

# Bernoulli sample for quick prototyping (10%)
health_sample <- health_tbl %>%
  sdf_sample(fraction = 0.10, replacement = FALSE, seed = 602)

cat("Spark table rows (full)   :", sdf_nrow(health_tbl),    "\n")
cat("Spark table rows (sample) :", sdf_nrow(health_sample), "\n")

} # end if (!isTRUE(getOption("bdat602.source_only")))
