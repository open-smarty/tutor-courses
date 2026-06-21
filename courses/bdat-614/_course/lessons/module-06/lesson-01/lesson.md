# Lesson 1: Total Quality Management (TQM) and Cost of Poor Quality

## Goal

Articulate the TQM philosophy and Deming's 14 Points, decompose the Cost of Poor Quality (COPQ) using the PAF model, and use Python to model and simulate how increased prevention investment reduces total quality costs.

## Concept

**What is Total Quality Management?**

TQM is an organisation-wide philosophy that aligns every function — design, production, procurement, customer service, and management — around a single objective: continuously delivering value that meets or exceeds customer expectations. Unlike inspection-based quality control (which finds defects after the fact), TQM aims to build quality into every process and decision from the outset.

Three pillars define TQM:
1. **Customer focus** — quality is defined by the customer, not the producer.
2. **Continuous improvement (Kaizen)** — improvement is never finished; every process can be better.
3. **Total employee involvement** — every person from senior management to the shop floor owns quality.

**Deming's 14 Points**

W. Edwards Deming articulated 14 management obligations that shift organisations from reactive inspection to proactive quality:

| # | Point | Key idea |
|---|---|---|
| 1 | Create constancy of purpose | Long-term vision over short-term fire-fighting |
| 2 | Adopt the new philosophy | Accept that poor quality is not inevitable |
| 3 | Cease dependence on inspection | Build quality in; don't inspect it in |
| 4 | End price-based supplier selection | Total cost of ownership > lowest bid price |
| 5 | Improve constantly | Reduce variation continuously, not just when things break |
| 6 | Institute training | Operators and managers must understand the process |
| 7 | Institute leadership | Managers should help people do their jobs better |
| 8 | Drive out fear | People must feel safe to report problems |
| 9 | Break down silos | Cross-functional collaboration is essential |
| 10 | Eliminate slogans | Slogans without systems create resentment |
| 11 | Eliminate quotas | Quotas drive the wrong behaviours |
| 12 | Remove barriers to pride | Give workers the means to do quality work |
| 13 | Institute education | Continuous learning for all employees |
| 14 | Put everyone to work on transformation | Quality is everyone's responsibility |

**Cost of Poor Quality — the PAF model**

COPQ quantifies the financial impact of not doing things right the first time. The PAF model organises quality costs into four categories:

| Category | Definition | Examples |
|---|---|---|
| **Prevention** | Costs incurred to prevent defects from occurring | Training, process design, preventive maintenance, SPC implementation |
| **Appraisal** | Costs incurred to evaluate conformance | Incoming inspection, calibration, final testing, audits |
| **Internal Failure** | Costs of defects found before delivery to the customer | Scrap, rework, re-inspection, downtime |
| **External Failure** | Costs of defects found after delivery to the customer | Warranty claims, returns, recalls, customer complaints, legal liability |

**Total quality cost:**

$$\text{COPQ} = C_{\text{Prevention}} + C_{\text{Appraisal}} + C_{\text{Internal Failure}} + C_{\text{External Failure}}$$

**The optimal quality cost trade-off**

Prevention and appraisal are **conformance costs** — the organisation spends these proactively. Internal and external failure are **non-conformance costs** — these arise when defects escape the system.

Key insight: investing more in prevention reduces failure costs non-linearly. A 10% increase in prevention spending can reduce external failure costs by 40–60% because defects are caught and eliminated much earlier in the process where correction is cheapest.

In the classical trade-off model:
- At low prevention investment: failure costs dominate; total COPQ is high.
- As prevention investment increases: failure costs fall rapidly; total COPQ decreases.
- Beyond an optimal point: marginal prevention investment yields diminishing returns; total COPQ begins to rise again.

The optimal point is where the marginal reduction in failure costs equals the marginal increase in prevention costs.

**Feigenbaum's rule of thumb:**

High-quality companies typically spend approximately:
- 70–85% of quality costs on failure (before TQM)
- After TQM maturity: <40% on failure, >60% on conformance

## Example

A medical device manufacturer has annual revenue of £20M and the following quality cost data:

| Category | Annual Cost |
|---|---|
| Prevention | £180,000 |
| Appraisal | £320,000 |
| Internal Failure | £540,000 |
| External Failure | £960,000 |
| **Total COPQ** | **£2,000,000** |

COPQ as % of revenue = 2,000,000 / 20,000,000 × 100 = **10%** — typical for pre-TQM organisations. World-class manufacturers target COPQ < 1% of revenue.

External failure (warranty and recall costs) is the largest single category at 48% of total COPQ. This indicates underinvestment in prevention. A lean quality improvement project increases prevention spending to £350,000; modelling predicts internal failure drops to £300,000 and external failure drops to £500,000 — net saving of £700,000 per year.

## Task

In `exercise.py`:

1. Define the COPQ baseline as a dictionary with the four PAF categories and their costs.
2. Compute total COPQ and each category's percentage share. Print a summary.
3. Plot a pie chart and a horizontal bar chart of the COPQ breakdown.
4. Model the trade-off: simulate what happens to total COPQ as prevention investment increases from £50,000 to £600,000 in steps of £10,000. Assume that failure costs decrease exponentially with prevention: `failure_cost = baseline_failure * exp(-k * prevention_ratio)`, where `prevention_ratio = prevention / max_prevention` and k = 3.0. Appraisal cost stays constant.
5. Plot total COPQ vs prevention investment, marking the minimum point.

## Check

```
npm run check -- bdat-614 module-06 lesson-01
```

## Reflection

Deming's Point 3 states "cease dependence on mass inspection to achieve quality." Yet many organisations still rely heavily on appraisal costs. Using the PAF model and your trade-off simulation, make a quantitative argument for why investing more in prevention and less in appraisal leads to lower total COPQ over time.
