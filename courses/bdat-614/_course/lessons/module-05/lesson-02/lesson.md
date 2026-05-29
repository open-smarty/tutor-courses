# Lesson 11: Six Sigma — DPMO, Performance Levels, and DMAIC Roadmap

## Goal
Calculate DPMO from process data, interpret Six Sigma performance levels, and map the DMAIC roadmap to a concrete improvement scenario.

## Concept

**Six Sigma** is a data-driven methodology aimed at achieving near-perfect quality. The goal: reduce process variation until the defect rate reaches **3.4 Defects Per Million Opportunities (DPMO)**. Originated at Motorola (1986, Bill Smith) and popularised by GE under Jack Welch.

### What Does "Six Sigma" Mean?

In a normal process, ±3σ from the mean captures 99.73% of output — that is about 2,700 DPMO. Six Sigma demands that the process mean be 6 standard deviations away from the nearest specification limit. This achieves 3.4 DPMO (accounting for a ±1.5σ long-term shift in the mean).

### Six Sigma Performance Levels

| Sigma Level | DPMO | Process Yield |
|-------------|------|---------------|
| 6σ | 3.4 | 99.99966% |
| 5σ | 233 | 99.977% |
| 4σ | 6,210 | 99.38% |
| 3σ | 66,807 | 93.32% |
| 2σ | 308,537 | 69.15% |

Most industry processes operate at 3σ–4σ. Healthcare and aviation target 6σ.

### Computing DPMO

```
DPMO = (Number of Defects / (Number of Units × Opportunities per Unit)) × 1,000,000
```

**Example:** A data pipeline processes 50,000 records per day. Each record has 10 fields that can be invalid. In one day, 150 invalid fields are found.

```
DPMO = 150 / (50,000 × 10) × 1,000,000 = 300 DPMO
```

That is just above 5σ — excellent quality.

### DMAIC as the Six Sigma Roadmap

DMAIC is the structured problem-solving framework of Six Sigma (covered in detail in Module 4). At the Six Sigma level, each phase has specific deliverables:

| Phase | Six Sigma Deliverable |
|-------|----------------------|
| Define | Project Charter with financial impact; Voice of Customer analysis |
| Measure | Baseline DPMO and sigma level; Gauge R&R validated |
| Analyze | Root causes statistically confirmed (not just hypothesised) |
| Improve | Designed experiments (DOE) or Kaizen events; validated on pilot |
| Control | Statistical control charts deployed; control plan signed off |

### Six Sigma Roles

- **Champion:** Senior manager who sponsors and removes barriers.
- **Master Black Belt (MBB):** Expert trainer and mentor.
- **Black Belt (BB):** Full-time project leader — typically runs 3–6 DMAIC projects per year.
- **Green Belt (GB):** Part-time team member with basic Six Sigma training.
- **Yellow Belt:** Basic awareness training only.

### Six Sigma in Big Data

DMAIC applies directly to data quality and ML model improvement:
- Reduce model drift (Analyze: identify which features drift; Improve: add retraining triggers)
- Improve A/B test reliability (Define: define success metrics; Control: monitor with control charts)
- Reduce ETL error rates (full DMAIC as shown in Module 4, Lesson 9)

## Example

A bank's loan approval system incorrectly classifies 6,200 applications per million (4σ level). Management launches a Six Sigma project:
- **Target:** reach 5σ (233 DPMO)
- **DMAIC:** Identify that 85% of misclassifications come from 2 data sources with 12% missing values. Fix the imputation strategy. Validate with holdout set. Monitor with a p-chart.
- **Result:** DPMO drops to 210 (just above 5σ).

## Task

Open `exercise.py`. Given defect data for three processes, compute DPMO and sigma level for each. Then determine which process is closest to Six Sigma performance and how many defects per day would need to be eliminated to reach the next sigma level.

Run the check when done:
`npm run check -- bdat-614 module-05 lesson-02`

## Check

```
npm run check -- bdat-614 module-05 lesson-02
```

## Reflection

A manager says: "We are already at 99.38% accuracy — that is excellent." A Six Sigma engineer says: "That is only 4σ — we have 6,210 DPMO." Who is right? In what context does the difference between 99.38% and 99.99966% actually matter? Give a specific example where the gap between 4σ and 6σ has life-or-death consequences.
