# Lesson 8: The Shewhart Cycle — PDCA and PDSA

## Goal
Describe the four phases of the Shewhart Cycle (PDCA/PDSA), explain the difference between PDCA and PDSA, and apply the cycle to a quality improvement scenario.

## Concept

The **Shewhart Cycle** is a scientific, iterative method for continuous improvement. Walter A. Shewhart (1891–1967) introduced it in the 1930s. W. Edwards Deming later popularised it worldwide.

The cycle has four phases:

### PDCA (Plan–Do–Check–Act)

| Phase | What Happens |
|-------|-------------|
| **Plan** | Identify the problem, collect baseline data, set SMART objectives, develop an action plan and prediction about what will happen. |
| **Do** | Execute the plan on a **small scale** (pilot) to test the change. Document observations. |
| **Check** | Measure and collect data. Analyse results using Control Charts, Capability Analysis, and Statistics. Compare against objectives. Identify what worked and what didn't. |
| **Act** | If the change worked: standardise it. If not: adjust the plan and restart the cycle. Either way, cycle continues. |

### PDSA (Plan–Do–Study–Act)

Deming preferred **PDSA** (Study instead of Check). The "Study" phase emphasises *learning* — not just checking numbers, but understanding *why* the results occurred. PDSA is now the preferred form.

### Why Iterate?

Quality improvement is rarely solved in one cycle. Each cycle produces learning that informs the next. Over many iterations:
- Common-cause variation is reduced by process redesign
- Special causes are eliminated and prevented
- The process moves toward the next improvement target

### Shewhart Cycle in Big Data

The cycle maps directly onto data pipeline improvement:
- **Plan:** Identify that ETL error rate is 2.8%; target < 0.5%.
- **Do:** Deploy improved data validation rules in a staging pipeline.
- **Study:** Monitor the error rate using a p-chart on staging for two weeks.
- **Act:** If error rate drops to 0.4%, promote to production. Otherwise, adjust.

Control charts are essential in the **Check/Study phase** — they distinguish real improvements from random variation.

## Example

A bottle-filling line has excessive fill variation (σ = 4 ml; target σ < 2 ml):

- **Plan:** Baseline data shows average fill = 503 ml, σ = 4 ml. Hypothesis: filler nozzle wear is the cause. Plan to replace nozzles on 2 of 6 lines.
- **Do:** Replace nozzles on 2 lines. Run for 2 weeks. Collect 50 subgroups.
- **Study:** Xbar-R chart for the 2 replaced lines shows σ drops to 1.8 ml. Original 4 lines unchanged.
- **Act:** Replace nozzles on all 6 lines. Implement preventive maintenance schedule. Start next cycle: investigate fill mean drift.

## Task

Open `exercise.py`. You are given a scenario description. Map each action to the correct PDCA/PDSA phase (Plan, Do, Study, Act). Then simulate a before/after comparison using Python to show whether the improvement was real or just random variation.

Run the check when done:
`npm run check -- bdat-614 module-04 lesson-01`

## Check

```
npm run check -- bdat-614 module-04 lesson-01
```

## Reflection

Why does Deming prefer "Study" over "Check"? What is the risk of treating the third phase as just a box to tick rather than as genuine learning? Give a concrete example of how the distinction matters in a data analytics project.
