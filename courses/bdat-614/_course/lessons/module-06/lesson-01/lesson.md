# Lesson 13: Total Quality Management (TQM) and Cost of Poor Quality

## Goal
Describe the core principles and contributors of TQM, apply Deming's 14 Points to a modern context, and compute the Cost of Poor Quality (COPQ) for a given scenario.

## Concept

**Total Quality Management (TQM)** is a management philosophy in which the *entire organisation* — from senior executives to frontline workers — is committed to continuously improving quality. It shifts focus from inspecting products at the end of a line to building quality into every process.

TQM is the foundation for modern frameworks like Six Sigma, Lean, and ISO 9001.

### Core Principles of TQM

- **Customer Focus:** All quality decisions start with the customer — both internal customers (the next process step) and external customers (end users).
- **Total Employee Involvement:** Everyone is responsible for quality, not just the QC department.
- **Process-Centred Approach:** Manage and improve the process — good processes produce good outcomes consistently.
- **Integrated System:** All departments work toward common quality goals.
- **Continuous Improvement (Kaizen):** Never accept the current state as the best possible state.
- **Fact-Based Decision Making:** Decisions are made using data and statistical tools, not intuition alone.

### Key Contributors to TQM

| Expert | Key Contribution |
|--------|-----------------|
| **W. Edwards Deming** | 14 Points for Management, PDCA Cycle, System of Profound Knowledge |
| **Joseph Juran** | Quality Trilogy (Planning, Control, Improvement), Cost of Poor Quality |
| **Philip Crosby** | "Quality is Free", Zero Defects concept |
| **Kaoru Ishikawa** | Fishbone Diagram, 7 QC Tools, Company-wide Quality Control |
| **Genichi Taguchi** | Robust Design, Taguchi Loss Function |

### Deming's 14 Points (Key Points)

1. Create constancy of purpose for improvement of products and services.
2. Adopt the new philosophy — do not accept defects as inevitable.
3. Cease dependence on inspection to achieve quality — build quality in.
4. End awarding business on price tag alone — build long-term supplier relationships.
5. Improve constantly and forever every process.
6. Institute training on the job.
7. Institute leadership — managers should help people do a better job.
8. Drive out fear — employees must feel safe to report problems.
9. Break down barriers between departments.
...continuing to point 14: put everyone to work on the transformation.

### Cost of Poor Quality (COPQ)

Introduced by Juran and Crosby, COPQ categorises the financial cost of quality failures into four types:

| Category | What it Includes | Example |
|----------|-----------------|---------|
| **Prevention Costs** | Training, process planning, quality audits | Staff training on data validation |
| **Appraisal Costs** | Inspection, testing, calibration | Running data quality checks on each pipeline run |
| **Internal Failure Costs** | Rework, scrap, downtime | Reprocessing corrupt records; re-running failed jobs |
| **External Failure Costs** | Warranty, returns, lost goodwill | Customer churn from inaccurate reports |

**Key insight:** Prevention is the cheapest category. Every £1 spent on prevention saves approximately £10 on internal failures and £100 on external failures (the 1:10:100 rule).

### TQM in Big Data Context

- **Data Quality Management** is TQM applied to data: completeness, accuracy, consistency, timeliness, validity.
- **Quality of algorithms:** Are ML models being validated and monitored for drift? Are training datasets audited?
- **Reducing "Data Debt":** accumulated poor-quality data, duplicate pipelines, undocumented transformations — analogous to technical debt but for data quality.
- **Building a quality culture in data teams:** DevOps (test-driven development, CI/CD pipelines) is TQM for software.

## Example

An e-commerce company discovers its recommendation engine has been using stale product data for 3 months.

- **Internal failure cost:** 40 hours of data engineering time to clean and reload the data.
- **External failure cost:** 12% drop in click-through rate, estimated £80,000 revenue loss.
- **Prevention cost (that was missing):** automated data freshness monitoring — would have cost £500 to implement.

This is a classic COPQ example: a £500 prevention investment would have avoided £80,000+ in losses.

## Task

Open `exercise.py`. You are given COPQ data for a data analytics team. Compute the total cost in each category, compute the total COPQ, and determine what percentage of total cost is spent on prevention. Then write a recommendation.

Run the check when done:
`npm run check -- bdat-614 module-06 lesson-01`

## Check

```
npm run check -- bdat-614 module-06 lesson-01
```

## Reflection

Deming's Point 3 says: "Cease dependence on inspection to achieve quality." In a data context, this means don't rely on manual data quality checks after the fact. What would it mean in practice to "build quality in" to a data pipeline — and why is this cheaper than detection?
