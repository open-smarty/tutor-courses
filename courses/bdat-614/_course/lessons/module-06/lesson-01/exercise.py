"""
Module 6, Lesson 1 — Total Quality Management and Cost of Poor Quality
Exercise: Compute COPQ and analyse prevention investment.

Requirements: (no external libraries needed)
"""

# Annual COPQ data for a data analytics team (in £)
copq_data = {
    "Prevention": {
        "Data quality training for new hires": 3000,
        "Automated schema validation system": 5000,
        "Data quality audit (quarterly)": 2000,
    },
    "Appraisal": {
        "Daily automated data quality checks": 8000,
        "Manual spot-check reviews by analyst": 12000,
        "Data profiling tool licence": 4000,
    },
    "Internal Failure": {
        "Reprocessing failed pipeline jobs": 25000,
        "Correcting mislabelled training data": 18000,
        "Downtime from data outages": 30000,
    },
    "External Failure": {
        "Revenue loss from inaccurate recommendations": 95000,
        "SLA penalties from late reports": 40000,
        "Customer churn attributed to data errors": 120000,
    },
}

# TODO: Step 1 — compute the total cost per category
category_totals = {}  # dict: category → total cost

# TODO: Step 2 — compute the grand total COPQ
total_copq = None

# TODO: Step 3 — compute the percentage of COPQ spent on prevention
prevention_pct = None

# TODO: Step 4 — print results with recommendations
print("=== Cost of Poor Quality Analysis ===")
# print each category total and percentage of total COPQ
# print total COPQ
# print prevention percentage
# print whether prevention investment is adequate (typical benchmark: 5–10% of total COPQ)
