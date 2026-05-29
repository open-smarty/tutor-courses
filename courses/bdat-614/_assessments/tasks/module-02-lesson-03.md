# Task: Module 2, Lesson 3 — Attribute Chart Selection and Analysis

## Objective

Choose the correct attribute chart for three different scenarios, build each one in Python, and interpret the results.

## Scenarios

**Scenario A:** A customer service team receives between 80 and 120 calls per day. Each call is either resolved (pass) or unresolved (fail). You have 15 days of data.

**Scenario B:** A software QA team reviews one release build per week. Each build is examined and the number of bugs found is recorded. You have 10 weeks of data.

**Scenario C:** A data validation system checks different-sized data batches each hour. The number of records failing validation is recorded along with the batch size. You have 20 hours of data.

## Instructions

1. For each scenario, state which chart type (p, np, c, or u) is correct and why.

2. Generate realistic sample data using `numpy.random` for each scenario.

3. In a Python file called `task_attribute_charts.py`, build all three charts in one figure with three subplots.

4. For each chart:
   - Compute and display the correct control limits.
   - Identify and mark any out-of-control points.
   - Print a one-sentence interpretation.

## Criteria

- Correct chart selected for each scenario with justification: 30%
- Correct formulas used for each chart type: 40%
- Charts are labeled and out-of-control points are identified: 20%
- Interpretations are correct: 10%
