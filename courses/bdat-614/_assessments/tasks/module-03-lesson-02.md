# Task: Module 3, Lesson 2 — Gauge R&R for a Sensor System

## Objective

Simulate and analyse a Gauge R&R study for a data collection system, and make a recommendation about its fitness for use.

## Scenario

A data team is using three different data ingestion scripts (Op1, Op2, Op3) to collect temperature readings from the same IoT sensor array. They want to know whether the scripts are producing consistent readings before they build a control chart from the data.

They measure 5 sensor nodes, each three times, with each script.

## Instructions

1. Simulate the study data in Python using `numpy.random`:
   - Base part (sensor node) values: `[98, 100, 102, 97, 103]` (true temperatures)
   - Op1 adds a repeatability error of `N(0, 0.3)` per reading
   - Op2 adds a systematic bias of `+0.5` plus `N(0, 0.4)` error
   - Op3 adds `N(0, 0.3)` error

2. Compute:
   - Repeatability variance
   - Reproducibility variance
   - % GR&R
   - Your assessment of whether the scripts are adequate

3. Write a one-paragraph recommendation for the data team (as printed text or comments).

4. Identify which operator (script) contributes most to reproducibility variation and suggest a specific fix.

## Criteria

- Data simulated correctly: 20%
- Variance components computed correctly: 40%
- % GR&R computed and interpreted: 20%
- Recommendation is practical and specific: 20%
