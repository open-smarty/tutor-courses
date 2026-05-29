# Task: Module 5, Lesson 3 — Lean Value Stream Mapping for a Data Pipeline

## Objective

Create a current-state and future-state Value Stream Map for a realistic data analytics pipeline and quantify the improvement.

## Scenario

A marketing analytics team produces a weekly campaign performance report. The current process takes 3 working days from data extraction to report delivery. The team suspects most of that time is waste.

Current-state process steps (with times):

| Step | Time |
|------|------|
| Manual data extraction from CRM | 4 hours |
| Data cleaning by analyst | 6 hours |
| Waiting for data validation approval | 8 hours |
| Loading into the analytics tool | 1 hour |
| Running the analysis | 3 hours |
| Generating the report | 2 hours |
| Management review and revision requests | 6 hours |
| Final formatting and distribution | 1 hour |

## Instructions

1. In a Python file `task_vsm.py`, classify each step as VA, NVA, or NNVA.

2. Compute the current Process Cycle Efficiency.

3. For each NVA step, identify the Lean waste category and propose a specific improvement (e.g., "automate X", "eliminate Y", "reduce Z from 6 hours to 1 hour using automated validation").

4. Design a future-state pipeline by applying your improvements. Compute the new PCE.

5. Print a summary showing:
   - Current total time, VA time, PCE
   - Future total time, VA time, PCE (after improvements)
   - Total time saved

## Criteria

- Step classification correct: 25%
- Lean waste categories identified: 25%
- Improvements are specific and feasible: 25%
- Future-state PCE computed and printed: 25%
