# Lesson 1: What is Quality? Definitions and Dimensions

## Goal

Explain Garvin's 8 dimensions of quality and distinguish Quality Control from Quality Assurance.

## Concept

Quality means different things to different people. A patient values accurate diagnosis. A hospital administrator values efficient throughput. A data engineer values clean, timely records. Without a common framework, "improve quality" is meaningless. David Garvin gave us one.

**Garvin's 8 Dimensions of Quality**

Each dimension captures a distinct aspect of what makes something "good":

1. **Performance** — does it do its primary job? For a claims processing system: does it calculate the correct benefit amount?
2. **Features** — capabilities beyond the minimum. For claims: automated fraud scoring, real-time eligibility checks.
3. **Reliability** — how often does it fail? For lab equipment: mean time between failures (MTBF).
4. **Conformance** — does it meet the specification? For a data feed: are all required fields present and within valid ranges?
5. **Durability** — how long before replacement is needed? For a database system: how many years until the architecture is obsolete?
6. **Serviceability** — how easily can it be repaired or patched? For a pipeline: is the SLA for bug fixes 2 hours or 2 weeks?
7. **Aesthetics** — look, feel, user experience. For a reporting portal: is the interface intuitive and visually clear?
8. **Perceived Quality** — reputation and brand trust. For a health insurer: do policyholders trust the company to pay claims fairly?

**Quality Control vs Quality Assurance**

These two terms are often confused but describe fundamentally different activities:

- **Quality Control (QC)** = detecting defects *after* they occur — inspecting the output of a process. Example: auditing 5% of processed claims for errors.
- **Quality Assurance (QA)** = preventing defects from occurring — improving the process itself. Example: redesigning the claims intake form so required fields cannot be left blank.

The key insight: QC is reactive; QA is proactive. An organisation that only does QC is paying to find problems. An organisation that invests in QA reduces the frequency of problems in the first place.

**Conformance Quality vs Performance Quality**

These two concepts are orthogonal. A system has:
- **Conformance quality**: it meets its written specifications exactly.
- **Performance quality**: those specifications are the right ones — the product actually does the job well.

A claims system could conform perfectly to its spec (all fields valid, all calculations correct per the formula) while still failing to pay the right amount because the formula itself was designed incorrectly. High conformance, low performance.

**ISO 9001** is an internationally recognised standard for quality management systems. It specifies requirements for consistent, customer-focused processes — documentation, management review, continual improvement. It does not prescribe specific tools but requires evidence that processes are defined and monitored.

## Example

Apply all 8 dimensions to an ETL (Extract, Transform, Load) pipeline for health insurance claims:

| Dimension | ETL Pipeline Assessment |
|---|---|
| Performance | Correctly transforms raw claim codes to standardised ICD-10 format |
| Features | Includes automated duplicate detection and fraud score enrichment |
| Reliability | 99.5% uptime; fails fewer than 4 hours per month |
| Conformance | All output records match the data contract schema |
| Durability | Architecture supports 5× current volume without redesign |
| Serviceability | Mean time to repair a failed job: 45 minutes |
| Aesthetics | Monitoring dashboard shows pipeline status with clear colour coding |
| Perceived Quality | Business analysts trust the data; no shadow datasets maintained |

Overall audit: score each dimension 1 (very poor) to 5 (excellent). A score of 3 on Reliability signals that improving uptime is the priority.

## Task

In `exercise.py`, create a Python dictionary representing a quality audit of an ETL pipeline across all 8 Garvin dimensions. Score each dimension from 1 (poor) to 5 (excellent). Compute the overall quality score as the mean. Plot a radar (spider) chart showing all 8 dimension scores.

## Check

```
npm run check -- bdat-614 module-01 lesson-01
```

## Reflection

Can a product have high conformance quality but low performance quality? Give a specific example from healthcare analytics — where a system meets every written specification yet still fails the user.
