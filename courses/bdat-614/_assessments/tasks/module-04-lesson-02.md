# Task: Module 4, Lesson 2 — Full DMAIC Analysis for a Data Quality Problem

## Objective

Apply the complete DMAIC framework to a realistic data quality problem, using Pareto analysis and Fishbone in the Analyze phase.

## Scenario

A healthcare analytics team reports that their patient outcome prediction model is underperforming (AUC dropped from 0.87 to 0.74 over the past month). The team suspects data quality issues in the upstream feeds.

The following defect types were logged from the data validation system over 30 days:

| Defect Type | Count |
|---|---|
| Missing values in key features | 340 |
| Schema changes (unexpected columns) | 210 |
| Out-of-range values | 180 |
| Duplicate patient records | 95 |
| Encoding mismatches (UTF-8 vs Latin-1) | 60 |
| Timestamp format errors | 45 |
| Other | 20 |

## Instructions

1. **Define phase:** Write a problem statement and objective (one paragraph).

2. **Measure phase:** Use the defect counts above to compute a baseline defect rate (total defects per 30 days). State what additional data you would collect.

3. **Analyze phase (Python):** In `task_dmaic.py`:
   - Build a Pareto chart from the data above.
   - For the top 2 defect types, write a Fishbone analysis (as structured print statements or comments) identifying at least 2 causes per 6M bone that is relevant.

4. **Improve phase:** For each of the top 2 defect types, propose one specific, testable improvement.

5. **Control phase:** Describe which control chart you would implement and why.

## Criteria

- Pareto chart correct and labeled: 25%
- Fishbone analysis is specific (not vague): 25%
- Define and Measure phases are clear: 20%
- Improve phase proposals are testable: 15%
- Control phase chart choice is justified: 15%
