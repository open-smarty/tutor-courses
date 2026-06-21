# Lesson 3: Lean Six Sigma — Waste Elimination and Quality Tools

## Goal

Identify and quantify the 8 types of waste in a production or service process, understand Value Stream Mapping as a lean diagnostic tool, apply the 5S workplace organisation methodology, and simulate value-added versus non-value-added time in Python.

## Concept

**Lean thinking**

Lean manufacturing originates from the Toyota Production System (TPS) and centres on one principle: **eliminate everything that does not add value from the customer's perspective**. Lean focuses on flow speed and waste removal, while Six Sigma focuses on variation reduction and defect counts. Lean Six Sigma combines both, using DMAIC as the improvement roadmap and Lean tools for rapid waste elimination during the Improve phase.

**The 8 Wastes — TIMWOODS**

| Letter | Waste | Manufacturing Example | Service Example |
|---|---|---|---|
| T | Transport | Moving parts between distant workstations | Routing documents through multiple departments |
| I | Inventory | Raw materials piling up before an assembly step | Backlog of unprocessed loan applications |
| M | Motion | Operators walking far to retrieve tools | Nurses crossing the ward to fetch supplies |
| W | Waiting | Machine idle while upstream step finishes | Patients waiting for lab results |
| O | Overproduction | Making 1,000 units when only 800 are ordered | Generating reports nobody reads |
| O | Overprocessing | Applying tolerances tighter than the customer requires | Re-checking an already-approved form |
| D | Defects | Rework, scrap, warranty returns | Billing errors requiring correction |
| S | Skills | Not using an operator's full expertise | Assigning a PhD analyst to data entry |

**Calculating process efficiency**

Total lead time = Value-Added (VA) time + Non-Value-Added (NVA) time.

$$\text{Process Efficiency} = \frac{\text{VA time}}{\text{VA time} + \text{NVA time}} \times 100\%$$

A typical manufacturing process has process efficiency of only **5–15%** — most elapsed time is waste. Lean targets >25% efficiency in the short term, with continuous improvement toward flow.

**Value Stream Mapping (VSM)**

A VSM is a diagram that follows the flow of material and information from supplier to customer. For each process step it records:
- Cycle time (CT): time to complete one unit
- Change-over time (CO): time to switch from one product type to another
- Uptime (%)
- Inventory (I): number of units waiting between steps

A VSM has two states:
- **Current state map**: how the process actually runs today
- **Future state map**: how it should run after lean improvement

**5S Methodology**

5S is a workplace organisation system that creates the physical foundation for lean flow:

| Step | Japanese | Meaning |
|---|---|---|
| Sort (Seiri) | 整理 | Remove everything not needed for current work |
| Set in order (Seiton) | 整頓 | Arrange needed items so they are easy to find |
| Shine (Seiso) | 清掃 | Clean and inspect the workspace regularly |
| Standardise (Seiketsu) | 清潔 | Create standards so the first 3 S's are maintained |
| Sustain (Shitsuke) | 躾 | Build discipline to keep the system going |

5S reduces the Motion and Waiting wastes by ensuring tools and materials are where they need to be, when they need to be there.

**Lean + Six Sigma synergy**

Lean alone cannot fix variation (a perfectly flow-efficient process can still have high defect rates). Six Sigma alone cannot fix flow (a zero-defect process can still have terrible lead times). Together:
- Lean compresses lead time and exposes waste.
- Six Sigma reduces variation and defect rates within the remaining value-adding steps.
- DMAIC provides the roadmap; lean tools fill the Improve phase.

## Example

A hospital emergency triage process has five sequential steps:

| Step | Activity | VA/NVA | Duration (min) |
|---|---|---|---|
| 1 | Patient arrives, waits in queue | NVA — Waiting | 18 |
| 2 | Triage nurse assessment | VA | 7 |
| 3 | Move to examination room | NVA — Transport | 4 |
| 4 | Wait for attending physician | NVA — Waiting | 25 |
| 5 | Physician examination | VA | 12 |

Total lead time = 66 min. VA time = 7 + 12 = 19 min.

Process Efficiency = (19 / 66) × 100% = **28.8%**

The two largest waste categories are Waiting (43 min, 65% of lead time) and Transport (4 min, 6%). A lean kaizen event would target physician scheduling and room allocation to shrink waiting time.

## Task

In `exercise.py`:

1. Define a list of process steps, each with a name, VA/NVA flag, waste category, and duration. Use the hospital example plus at least 3 additional custom steps.
2. Compute total lead time, VA time, NVA time, and process efficiency. Print a summary.
3. Build a stacked horizontal bar chart showing the time breakdown for each step, coloured green (VA) or red (NVA).
4. Create a bar chart of NVA time by waste category (TIMWOODS). Which category accounts for the most waste?
5. Simulate 100 production cycles through the process by sampling durations from normal distributions (mean = stated duration, sd = 0.2 × duration). Plot a histogram of total lead time across the 100 simulated cycles.

## Check

```
npm run check -- bdat-614 module-05 lesson-03
```

## Reflection

The 5S "Sustain" step is widely regarded as the most difficult to maintain. Using your process simulation results, explain why variation in individual step durations compounds across the entire value stream, and how this makes standardisation (the 4th S) a prerequisite for sustaining lean gains.
