# Lesson 1: What is Quality? Definitions and Dimensions

## Goal
Explain what quality means in production and service contexts, identify its eight dimensions, and distinguish between Quality Control (QC) and Quality Assurance (QA).

## Concept

**Quality** is not a single thing. Different people define it differently:

- **Conformance to requirements** (Crosby) — quality means meeting a specification exactly.
- **Fitness for use** (Juran) — quality means the product does what the customer needs it to do.
- **Loss to society** (Taguchi) — quality is the degree to which a product avoids causing loss to the customer or society after delivery.

No single definition covers every situation, which is why Garvin proposed **eight dimensions of quality** that together give a complete picture:

| Dimension | Meaning |
|---|---|
| Performance | Does it do the primary job? |
| Features | Does it have extra capabilities? |
| Reliability | Does it work consistently over time? |
| Conformance | Does it meet the specification? |
| Durability | How long does it last? |
| Serviceability | How easy is it to fix? |
| Aesthetics | How does it look/feel/sound? |
| Perceived quality | What do customers believe about it? |

**Quality Control (QC)** is about detecting and correcting defects — it is reactive. QC happens during or after production: inspect the output, find the defects, remove or fix them.

**Quality Assurance (QA)** is about preventing defects — it is proactive. QA builds the system, processes, and standards so that defects are unlikely to occur in the first place. ISO 9001 is a globally recognised QA standard.

In Big Data analytics, "quality" applies to data itself. A dataset that is accurate, complete, consistent, timely, and valid is a *high-quality* dataset. Poor data quality leads to incorrect analysis — "garbage in, garbage out."

## Example

A company manufactures USB drives.

- **Conformance quality:** each drive must store exactly 64 GB and read at ≥ 400 MB/s. Any drive below spec is a defect.
- **Fitness for use:** the drive must be reliable enough that a user trusts it with important files. A drive that meets the speed spec but fails after 3 months has poor quality.
- **Perceived quality:** if the packaging looks cheap, customers may rate it poorly even if it performs perfectly.

Which dimension matters most? It depends on the customer and context — that is exactly why all eight dimensions exist.

## Task

Open `exercise.py`. You will find a list of eight product scenarios. For each one, identify the most relevant Garvin dimension and write your answer as a string in the provided list. Then compute a simple "quality score" for a data pipeline using the provided checklist.

Run the check when done:
`npm run check -- bdat-614 module-01 lesson-01`

## Check

```
npm run check -- bdat-614 module-01 lesson-01
```

## Reflection

A data pipeline runs on time and produces results, but 5% of records contain null values that downstream models silently treat as zero. Which quality dimensions are violated, and is this a QC problem, a QA problem, or both? Explain your reasoning.
