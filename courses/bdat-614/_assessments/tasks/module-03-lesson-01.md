# Task: Module 3, Lesson 1 — Capability Study for a Manufacturing Process

## Objective

Perform a complete process capability study including control chart validation, Cp/Cpk calculation, and an improvement recommendation.

## Instructions

1. Generate 100 measurements using `numpy.random.normal(loc=50.3, scale=0.25, size=100)`. The spec limits are LSL = 49.5, USL = 50.5.

2. First, verify the process is in control by building an I-MR chart from the 100 individual measurements. If out-of-control signals exist, note them but proceed with the capability analysis.

3. Compute Cp and Cpk. Interpret both values.

4. Plot:
   - A capability histogram with LSL, USL, mean, and a fitted normal curve.
   - The I-MR chart.

5. Write a two-paragraph management summary (as Python comments or printed text) covering:
   - Is the process stable and capable?
   - What specific action do you recommend and why?

## Criteria

- I-MR chart computed correctly: 25%
- Cp and Cpk correct with proper interpretation: 35%
- Both charts properly plotted and labeled: 20%
- Management summary is clear and actionable: 20%
