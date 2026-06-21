# Lesson 2: DMAIC Framework and Root Cause Analysis Tools

## Goal

By the end of this lesson you will be able to describe each phase of the DMAIC framework, apply the 5 Whys technique to trace a defect to its root cause, construct and interpret a Pareto chart using the 80/20 rule, and sketch the structure of an Ishikawa (fishbone) diagram. You will implement Pareto analysis and a fishbone visualisation in Python.

## Concept

### DMAIC — The Six Sigma Problem-Solving Framework

DMAIC is the structured improvement methodology used within Six Sigma programmes. It provides a rigorous, data-driven roadmap from symptom to sustained solution. Each phase has defined deliverables and statistical tools.

---

**Define**

Scope the problem formally. Deliverables:
- **Project Charter**: problem statement, goal statement, scope boundaries, business case, team roles, timeline.
- **SIPOC diagram**: Suppliers → Inputs → Process → Outputs → Customers. Gives a macro view of the process.
- **Voice of the Customer (VOC)**: customer requirements translated into measurable Critical-to-Quality (CTQ) characteristics.

Key question: What is the problem, who does it affect, and what constitutes success?

---

**Measure**

Quantify the current state. Deliverables:
- **Process map / value stream map**: detailed flow of all process steps.
- **Gauge R&R**: verify the measurement system is adequate before collecting data.
- **Baseline capability**: Cp, Cpk, DPMO, sigma level.
- **Data collection plan**: what to measure, where, how often, who is responsible.

Key question: How bad is the problem right now, and can we trust our measurements?

---

**Analyse**

Identify the root causes of the problem. This is the most statistically intensive phase. Tools:
- **Pareto chart** (see below)
- **Fishbone / Ishikawa diagram** (see below)
- **5 Whys** (see below)
- **Multi-vari charts**, **regression**, **hypothesis tests** (t-test, ANOVA, chi-square)
- **Failure Mode and Effects Analysis (FMEA)**

Key question: What are the vital few root causes that account for most of the defect?

---

**Improve**

Generate, select, and test solutions. Deliverables:
- **Solution matrix**: candidate solutions evaluated against cost, feasibility, and impact.
- **Design of Experiments (DOE)**: statistically optimise process factor settings.
- **Pilot study**: test the solution on small scale (PDCA Do phase) before full deployment.
- **Revised control plan**: document the new standard operating conditions.

Key question: What change will eliminate or substantially reduce the root cause?

---

**Control**

Sustain the gain. Deliverables:
- **Control charts**: ongoing monitoring of the improved process.
- **Control Plan**: documented response plan if the process goes out of control.
- **Standard Operating Procedures (SOPs)**: updated procedures reflecting the new method.
- **Mistake-proofing (Poka-yoke)**: design the process so the defect cannot recur.
- **Project handover**: transition ownership to the process owner.

Key question: How do we ensure the improvement is permanent?

---

### Root Cause Analysis Tool 1: Pareto Chart

The Pareto chart operationalises the **80/20 rule** (Pareto Principle): in most quality problems, approximately 80% of defects are caused by 20% of the possible causes. By identifying and eliminating the vital few, you achieve disproportionate improvement.

Construction:
1. List all defect categories and count their frequencies.
2. Sort categories by frequency (descending).
3. Plot frequency as descending bars (left axis).
4. Compute cumulative percentage and plot as a line (right axis).
5. Draw a horizontal line at 80% to identify the "vital few" categories.

Interpretation: categories to the left of the point where the cumulative line crosses 80% are the vital few. Focus improvement efforts here.

---

### Root Cause Analysis Tool 2: 5 Whys

The 5 Whys is a structured brainstorming technique for tracing a symptom to its underlying root cause through iterative questioning. The name reflects the observation that five levels of "Why?" typically reaches the systemic root cause rather than a surface symptom.

Example:

1. **Why** did the machine produce defective tablets? → Because the tablet press exerted inconsistent force.
2. **Why** was the force inconsistent? → Because the hydraulic pressure fluctuated.
3. **Why** did the pressure fluctuate? → Because the hydraulic fluid was contaminated.
4. **Why** was the fluid contaminated? → Because the maintenance schedule did not include fluid replacement.
5. **Why** was fluid replacement omitted from the schedule? → Because the maintenance SOP was written before the new press was installed and was never updated.

**Root cause:** Outdated maintenance SOP.

Rules for effective 5 Whys:
- Each answer must be evidence-based, not speculative.
- Follow the causal chain — do not switch to a different defect pathway mid-analysis.
- Ask "Why?" until a systemic or process-design failure is reached, not a human error.
- Human error answers ("operator didn't check") almost always indicate a higher-level system failure.

---

### Root Cause Analysis Tool 3: Fishbone (Ishikawa) Diagram

The fishbone diagram is a graphical tool for organising potential causes of a problem. The "effect" (problem statement) is written at the head of the fish (right side). "Bones" radiate from the spine, each representing a major cause category. Sub-causes branch from each bone.

Standard cause categories for manufacturing (the 6M framework):

| Category | Example causes |
|---|---|
| **Man** (People) | Inadequate training, fatigue, high turnover |
| **Machine** | Worn tooling, calibration drift, unplanned downtime |
| **Method** | Non-standardised procedure, batch changeover errors |
| **Material** | Supplier variation, incoming inspection failure |
| **Measurement** | Gauge R&R > 30%, measurement bias |
| **Mother Nature** | Temperature, humidity, vibration |

For service processes, common alternatives are: People, Process, Policy, Technology, Environment, Measurement.

The fishbone diagram does not rank causes — it is a brainstorming aid used before data collection and Pareto analysis.

---

### Connecting DMAIC tools to phases

| Tool | DMAIC Phase |
|---|---|
| Project Charter, SIPOC | Define |
| Gauge R&R, Capability (Cp/Cpk) | Measure |
| Pareto chart, Fishbone, 5 Whys, FMEA | Analyse |
| DOE, Pilot study | Improve |
| Control charts, SOP, Poka-yoke | Control |

## Example

A beverage company's bottling line has a weekly defect rate of 6.2%. A DMAIC project is initiated. In the Analyse phase, operators log every defect type for four weeks (n = 1,200 defects):

| Defect Type | Count |
|---|---|
| Underfill | 510 |
| Label misalignment | 240 |
| Cap seal failure | 195 |
| Foreign particle | 120 |
| Broken glass | 90 |
| Other | 45 |

Pareto analysis: Underfill (42.5%) + Label misalignment (20.0%) + Cap seal failure (16.25%) = 78.75%. Adding Broken glass (7.5%) crosses 80%. The vital few are underfill and label misalignment — fix these two and you address ~63% of all defects.

A 5 Whys analysis on underfill finds the root cause is an outdated fill-level sensor calibration that was not on the preventive maintenance schedule.

## Task

Complete `exercise.py`. You will:

1. Build a Pareto chart for the beverage bottling defect data above. Include cumulative percentage line, 80% threshold, and correct axis labelling.
2. Simulate a 5 Whys tree as a Python dictionary and print it as a formatted chain.
3. Draw a fishbone diagram using matplotlib annotations and lines (no external libraries): a horizontal spine, four bones for Man/Machine/Method/Material, and at least two sub-causes per bone.

## Check

```
npm run check -- bdat-614 module-04 lesson-02
```

## Reflection

- The Pareto chart shows that the top 3 defect types account for 79% of defects, but the plant manager insists on fixing all six types simultaneously. What is the quality argument against this approach?
- In the 5 Whys technique, an engineer responds to "Why did the operator make an error?" with "Because the operator was careless." Why is this an inadequate root cause, and what should the engineer ask next?
- At which DMAIC phase is it too late to discover that the measurement system has a %GRR of 45%? What are the consequences?
