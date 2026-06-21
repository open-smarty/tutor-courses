# Lesson 1: The Shewhart Cycle — PDCA and PDSA

## Goal

By the end of this lesson you will understand the Plan-Do-Check-Act (PDCA) cycle and its scientific refinement, the Plan-Do-Study-Act (PDSA) cycle. You will be able to distinguish their philosophical differences, describe the role of each phase in continuous improvement, and simulate a multi-cycle improvement process to visualise quality gains over time.

## Concept

### Origins: Shewhart and Deming

Walter Shewhart introduced the concept of a scientific improvement cycle in the 1930s as part of his work on statistical process control at Bell Labs. W. Edwards Deming adapted and popularised it, initially as PDCA and later, after reflecting on the inadequacy of the "Check" framing, as PDSA. Both cycles are often called the **Deming Cycle** or the **Shewhart Cycle**.

The key insight is that improvement is not a one-shot project — it is an iterative scientific method applied continuously to a living process.

---

### The Four Phases of PDCA

**Plan**

Identify the problem, analyse the current state, establish a measurable goal, and develop a specific change hypothesis. Outputs: problem statement, root cause analysis, improvement plan, predicted outcome, success metric.

Key questions:
- What problem are we solving?
- What do we predict will happen if we make this change?
- How will we measure success?

**Do**

Implement the planned change on a small, controlled scale. Collect data systematically. Do not skip the small-scale test in favour of immediate full deployment — this is the stage most frequently rushed in practice, leading to failed rollouts.

**Check**

Compare the actual results against the predicted results from the Plan phase. The "Check" in PDCA is often interpreted passively — simply verifying whether targets were met.

**Act**

If the change produced the desired improvement, standardise it and deploy at full scale. If it did not, return to Plan with new knowledge. The learning from each cycle seeds the next cycle.

---

### PDCA versus PDSA

Deming later argued that "Check" implies inspection — looking to see whether targets were reached — whereas the scientific method requires **Study**: deep analysis of results to understand *why* the change worked or did not. The difference is:

| Aspect | PDCA | PDSA |
|---|---|---|
| Origin | Shewhart / early Deming | Deming (1990s refinement) |
| Third phase | Check — verify against targets | Study — analyse and learn from data |
| Emphasis | Conformance to plan | Knowledge generation |
| Appropriate when | Target is well defined and mechanism is understood | Process is complex or mechanism is uncertain |
| Risk of misuse | Teams declare success if KPIs are met, without understanding why | Longer analysis phase may slow rapid cycles |

In practice: use PDSA when you are genuinely testing a hypothesis about a causal mechanism. Use PDCA when executing a well-understood change against a clear specification.

---

### Multiple PDCA/PDSA cycles

Continuous improvement is not a single cycle. Each completed cycle produces learning that raises the baseline:

- **Cycle 1**: quick win — low-hanging fruit, high return, rapid cycle.
- **Cycle 2**: deeper cause — requires more data collection and analysis.
- **Cycle 3+**: diminishing returns in the same dimension; pivot to a new improvement lever.

The cumulative effect of many small cycles is often far larger than a single large project. This is the argument for **rapid-cycle improvement** (common in healthcare quality improvement using the IHI Model for Improvement).

---

### Connecting PDCA to the broader quality ecosystem

- **Six Sigma DMAIC** is a structured elaboration of the Plan and Do phases, with explicit statistical tools at each step.
- **Lean** uses PDCA at the level of individual value-stream waste elimination.
- **ISO 9001** requires documented evidence of PDCA operation as part of its quality management system requirements.
- **Agile sprints** in software development are PDCA cycles with a cadence of one to four weeks.

---

### Key metric: Defect Rate across PDCA cycles

In a simulation, we track the defect rate (or some quality metric) across successive PDCA cycles. A well-executed improvement programme produces a decreasing trend with diminishing increments per cycle as the easiest problems are resolved first.

## Example

A hospital's radiology department has a patient wait time averaging 47 minutes (target: 30 minutes). They run three PDCA cycles over six months:

**Cycle 1 (Plan):** Hypothesis — scheduling gaps cause idle scanner time. Change: introduce block scheduling. Prediction: reduce wait by 8 minutes.

**Cycle 1 (Do/Check/Act):** Wait time dropped to 39 minutes (−8 min). Confirms hypothesis. Standardise block scheduling.

**Cycle 2 (Plan):** Remaining delay traced to patient transport. Change: dedicated porter allocation during peak hours. Prediction: −5 minutes.

**Cycle 2 (Do/Check/Act):** Wait time drops to 34 minutes (−5 min). Standardise.

**Cycle 3 (Plan):** Last 4 minutes traced to consent form completion delay. Change: pre-scan digital consent form. Prediction: −4 min.

**Cycle 3 (Do/Study/Act — PDSA):** Wait time drops to 31 minutes. Not at target but close. Study reveals forms are completed faster but nursing handoff still adds 1 minute. New cycle planned.

Notice the diminishing return per cycle (−8, −5, −1 net in Cycle 3) and how each cycle builds on the previous one.

## Task

Complete `exercise.py`. You will:

1. Simulate 8 PDCA cycles of a defect-reduction programme. Each cycle reduces the defect rate by a fraction drawn from a decreasing expected improvement (first cycles achieve more; later cycles achieve less).
2. Plot the defect rate across cycles as a line chart, marking each cycle with a labelled annotation.
3. Plot the cumulative improvement (total defect reduction from baseline) as a bar chart.
4. Calculate when the process first crosses the target defect rate and annotate that cycle on the plot.

## Check

```
npm run check -- bdat-614 module-04 lesson-01
```

## Reflection

- A quality manager says: "We ran the PDCA cycle last year and fixed the problem." What is fundamentally wrong with this statement from a continuous improvement philosophy perspective?
- In which situations would you prefer PDSA over PDCA, and why? Give an example from a manufacturing context.
- Why do rapid small-scale cycles (test on 10 patients, 1 machine, 1 shift) generally outperform large-scale rollouts as an improvement strategy?
