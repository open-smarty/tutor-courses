# Lesson 7: Measurement System Analysis — Gauge R&R

## Goal
Explain what Gauge R&R measures, compute the percentage of variation due to the measurement system, and determine whether a measurement system is acceptable for use in SPC or capability studies.

## Concept

Before you trust any control chart or capability index, you need to know: **can you trust the measurements themselves?** A measurement system (gauge, sensor, instrument) that is inaccurate or inconsistent will make a perfectly stable process look out of control — and will hide real problems.

**Measurement System Analysis (MSA)** evaluates this. The most common method is **Gauge Repeatability and Reproducibility (Gauge R&R)**.

### Two Components of Measurement Variation

**Repeatability (Equipment Variation — EV):** The same operator measures the same part multiple times with the same gauge. How much does the reading vary? This is the gauge's own variation.

**Reproducibility (Appraiser Variation — AV):** Different operators measure the same part. How much do their averages differ? This is operator-to-operator variation.

Together:
```
σ²_GaugeR&R = σ²_Repeatability + σ²_Reproducibility
```

Total variation:
```
Total Variation (TV) = √(σ²_Process + σ²_GaugeR&R)
```

### % Gauge R&R

The key metric is the percentage of total variation caused by the measurement system:

```
% GR&R = (σ_GaugeR&R / σ_Total) × 100
```

### Acceptance Criteria

| % GR&R | Interpretation |
|--------|----------------|
| < 10%  | Excellent — measurement system is adequate |
| 10–30% | Acceptable (depends on application) |
| > 30%  | Unacceptable — improve measurement system first |

Also check **ndc (Number of Distinct Categories)**: should be ≥ 5 to detect meaningful differences between parts.

### Standard Gauge R&R Study Design

- 10 parts representing the full process variation
- 2–3 operators (appraisers)
- 2–3 repeated measurements per part per operator
- Total readings = 10 × 3 × 3 = 90 measurements

Analysis is done using **ANOVA** (most recommended method) or the Average and Range method.

### Why This Matters for Big Data

In Big Data systems, "gauges" are sensors, APIs, and data collection scripts. A sensor that varies by ±1.5°C when measuring the same part is repeatable-defective. Two data collection scripts producing different averages have a reproducibility problem. Poor measurement systems poison downstream analytics — "garbage in, garbage out."

## Example

A Gauge R&R study on a temperature sensor gives:
- % Repeatability = 18.2%
- % Reproducibility = 9.8%
- **% GR&R = 28.0%**
- ndc = 4.8

**Conclusion:** Marginally acceptable. The measurement system needs improvement before trusting it for SPC or capability studies. The ndc < 5 means the system cannot reliably distinguish between parts.

**Action:** Calibrate sensors, standardise data collection scripts, and re-run the study.

## Task

Open `exercise.py`. You are given Gauge R&R data: 4 parts, 3 operators, 2 replicates each (matching the ANOVA example from the slides). Compute the variance components, % GR&R, and determine whether the measurement system is acceptable.

Run the check when done:
`npm run check -- bdat-614 module-03 lesson-02`

## Check

```
npm run check -- bdat-614 module-03 lesson-02
```

## Reflection

An analyst says: "Our sensors have 28% GR&R but we're using them for Big Data analytics, so it doesn't matter — we have millions of data points and the average will be accurate." Is the analyst correct? What specific problem does high %GR&R cause even with large sample sizes?
