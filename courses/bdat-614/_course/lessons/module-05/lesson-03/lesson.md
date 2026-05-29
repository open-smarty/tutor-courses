# Lesson 12: Lean Six Sigma — Waste Elimination and Quality Tools

## Goal
Describe how Lean combines with Six Sigma, identify the 8 Lean wastes (Muda), and apply Value Stream Mapping to identify and eliminate non-value-adding steps in a process.

## Concept

**Six Sigma** focuses on reducing variation and defects. **Lean** focuses on eliminating waste and increasing speed. Together, **Lean Six Sigma** addresses both quality and efficiency simultaneously.

- **Six Sigma alone:** reduces variation but may leave slow, wasteful processes intact.
- **Lean alone:** speeds up processes but may still produce defective output.
- **Lean Six Sigma:** achieves both — fast, efficient, and defect-free processes.

### The 8 Lean Wastes (Muda — TIM WOODS)

| Letter | Waste | Example |
|--------|-------|---------|
| **T** | Transportation | Moving data between unnecessary systems |
| **I** | Inventory | Data waiting in queues; unprocessed records |
| **M** | Motion | Analysts repeatedly switching between tools |
| **W** | Waiting | Pipeline jobs waiting for upstream data |
| **O** | Overproduction | Generating reports nobody reads |
| **O** | Overprocessing | Running 10 validation steps when 3 suffice |
| **D** | Defects | Invalid records that must be reworked |
| **S** | Unused Talent | Analysts doing manual work that could be automated |

### Value Stream Map (VSM)

A VSM is a diagram that shows every step in a process — from supplier to customer — and labels each step as:
- **Value-Adding (VA):** the customer would pay for this step
- **Non-Value-Adding (NVA) / Waste:** the customer would not pay for this — eliminate it
- **Non-Value-Adding but Necessary (NNVA):** required but not adding direct value — minimise it

**How to draw one:**
1. Map the current state (every step, wait time, data flow)
2. Identify waste at each step
3. Design the future state (removing/reducing waste)
4. Implement the future state with PDCA

### Key Lean Tools

| Tool | Purpose |
|------|---------|
| **5S** | Sort, Set in order, Shine, Standardise, Sustain — workplace organisation |
| **Kanban** | Visual workflow management; limit work in progress |
| **Poka-Yoke** | Mistake-proofing — design the process so errors cannot occur |
| **Just-in-Time (JIT)** | Produce/process only what is needed, when it is needed |
| **Kaizen** | Continuous small improvements, involving everyone |

### Lean Six Sigma in Big Data

- **Waste = data debt:** unused tables, redundant pipelines, over-engineered transformations
- **VSM for data:** map raw data → ETL → staging → analytics → report, identify wait times and defect rates at each stage
- **Poka-Yoke for data:** schema validation at ingestion prevents invalid data from entering the pipeline
- **Kanban for data teams:** limit concurrent pipeline jobs to reduce queueing delays

## Example

A data pipeline with 7 steps:

| Step | Time | VA or Waste? |
|------|------|-------------|
| Ingest from source | 5 min | Value-Adding |
| Wait in queue | 45 min | Waste (Waiting) |
| Validate schema | 3 min | Value-Adding |
| Reformat data | 8 min | Partly NVA — could be done at source |
| Manual approval check | 30 min | Waste (Over-processing / Motion) |
| Load to warehouse | 4 min | Value-Adding |
| Wait for downstream job | 60 min | Waste (Waiting) |

**Total time:** 155 min. **Value-adding time:** 20 min (13%). Lean target: eliminate or reduce the 135 minutes of waste.

## Task

Open `exercise.py`. You are given a list of process steps with times. Classify each step as VA, NVA, or NNVA. Compute the process cycle efficiency (VA time / total time). Then identify which Lean waste category each NVA step belongs to.

Run the check when done:
`npm run check -- bdat-614 module-05 lesson-03`

## Check

```
npm run check -- bdat-614 module-05 lesson-03
```

## Reflection

A Six Sigma engineer says: "We should focus only on reducing defects — waste elimination is a distraction." A Lean practitioner says: "Speed is more important than quality." Which approach would you recommend to a Big Data team trying to improve their analytics pipeline, and why? What does Lean Six Sigma offer that neither approach alone provides?
