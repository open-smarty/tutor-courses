# Lesson 9: DMAIC Framework and Root Cause Analysis Tools

## Goal
Describe the five DMAIC phases, match quality tools to each phase, and use the Fishbone diagram and Pareto analysis to identify the dominant root cause of a quality problem.

## Concept

**DMAIC** is the core problem-solving methodology of **Six Sigma**. It is a structured, data-driven approach to improving existing processes. DMAIC stands for:

| Phase | Question | Key Tools |
|-------|----------|-----------|
| **Define** | What is the problem? | Project Charter, SIPOC, Voice of Customer |
| **Measure** | How is the process performing now? | Control Charts, Gauge R&R, Process Maps |
| **Analyze** | What are the root causes? | Fishbone Diagram, Pareto Chart, Hypothesis Testing |
| **Improve** | How can we fix it? | DOE, Kaizen Events, Pilot |
| **Control** | How do we sustain the gains? | Control Charts, Control Plans, Dashboards |

### Fishbone (Ishikawa) Diagram

A visual tool for the **Analyze phase**. It maps all possible causes of a problem (the "effect") by category. The categories are typically the 6Ms: Man, Machine, Material, Method, Measurement, Environment. The result looks like a fish skeleton — the problem is the head, each M-category is a bone.

**How to use it:**
1. Write the problem (effect) on the right.
2. Draw six "bones" for each M-category.
3. Brainstorm possible causes under each bone.
4. Drill deeper with "why?" within each bone.
5. Identify the most likely causes to investigate.

### Pareto Chart

A bar chart that ranks causes (or defect types) from most frequent to least frequent, with a cumulative percentage line overlaid. Based on the **Pareto Principle (80/20 rule)**: approximately 80% of problems come from 20% of causes.

**How to use it:** Focus improvement efforts on the top 1–3 causes. Fix those and you will resolve most of the problem with minimum effort.

### DMAIC in Big Data — Example (ETL Pipeline)

- **Define:** ETL pipeline error rate is 2.8%; target < 0.5%.
- **Measure:** Baseline control chart shows the process is stable at 2.8%. Gauge R&R confirms data quality metrics are reliable.
- **Analyze:** Pareto chart shows 80% of errors come from 3 of 15 data sources. Fishbone on those sources points to inconsistent API response formats (Method) and missing null-handling (Method/Material).
- **Improve:** Rewrite the transformation step for those 3 sources; add null-handling rules. Pilot on staging.
- **Control:** Deploy a real-time p-chart monitoring error rate. Set up automated alerts. Update documentation.

## Example

A Pareto analysis of 500 customer complaints:

| Defect Type | Count | Cumulative % |
|---|---|---|
| Wrong delivery address | 200 | 40% |
| Damaged packaging | 150 | 70% |
| Missing item | 75  | 85% |
| Wrong product | 50  | 95% |
| Other | 25  | 100% |

**Conclusion:** Fix "wrong delivery address" and "damaged packaging" first — together they account for 70% of complaints.

## Task

Open `exercise.py`. You are given a list of defect types and counts from a manufacturing process. Build a Pareto chart in Python and identify the critical few causes. Then complete a structured Fishbone analysis by mapping provided potential causes to the correct 6M bones.

Run the check when done:
`npm run check -- bdat-614 module-04 lesson-02`

## Check

```
npm run check -- bdat-614 module-04 lesson-02
```

## Reflection

In the Analyze phase of DMAIC, a team creates a beautiful Fishbone diagram and identifies 20 potential causes of high process variation. But they have no data to verify which causes are real. What should they do next, and why is the Fishbone diagram alone not sufficient to identify the root cause?
