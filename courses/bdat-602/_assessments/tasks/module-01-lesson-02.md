# Task: CRISP-DM Project Plan and Dataset Setup

## Objective

Apply the CRISP-DM framework to a fraud-detection project using the health insurance dataset, and demonstrate the ability to set up both a local R session and a Spark connection for large-scale analysis.

## Instructions

1. Open `exercise.Rmd` and knit it to verify it runs without errors.

2. **Task 1 — Dataset setup**: Source the simulator file and generate `health_data` with `n = 500000, seed = 602`. Print `dim(health_data)` to confirm dimensions.

3. **Task 2 — Business Understanding**: Write a CRISP-DM Phase 1 document for a **fraud detection** project. Your document must include:
   - A clear statement of the business problem (what is the financial or operational impact of fraud?).
   - The mining objective (what exactly will you predict, using which features?).
   - A measurable success criterion (choose an appropriate metric for an imbalanced target and justify your threshold).
   - Data source and any constraints (which columns must be excluded to prevent leakage?).

4. **Task 3 — Target exploration**: Use `skim()` on `churned`, `high_risk`, and `claim_amount`. Create a `ggplot2` histogram of `claim_amount` (for non-zero values only) and describe its distribution shape in a comment. Compute and compare the churn rate and high-risk rate.

5. **Task 4 — Spark setup**: Write the `sparklyr` code (chunk with `eval=FALSE`) to:
   - Connect to a local Spark instance.
   - Push `health_data` to Spark as `"health_insurance"`.
   - Count records by `plan_tier` and collect the result.
   - Disconnect from Spark.

## Submission

Knit `exercise.Rmd` to `exercise.html`. Submit both files. Your Phase 1 document (Task 2) must be written as R comments inside the code chunk, with clear labels for each section (Business problem, Mining objective, Success criterion, Data source, Constraints).
