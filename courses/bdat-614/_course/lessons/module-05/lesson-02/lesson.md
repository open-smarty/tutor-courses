# Lesson 2: Six Sigma — DPMO, Performance Levels, and DMAIC Roadmap

## Goal

Calculate Defects Per Million Opportunities (DPMO), convert between DPMO and sigma level, link sigma performance to process capability indices, and understand how DMAIC structures a Six Sigma improvement project.

## Concept

**What is Six Sigma?**

Six Sigma is a data-driven quality improvement strategy that sets a performance target of no more than **3.4 defects per million opportunities (DPMO)**. The name comes from the idea that the process mean should be at least 6 standard deviations from the nearest specification limit — but in practice the standard accounts for a 1.5σ mean shift that occurs in long-run production.

**Defects Per Million Opportunities (DPMO)**

$$\text{DPMO} = \frac{\text{Number of Defects}}{\text{Units} \times \text{Opportunities per Unit}} \times 1{,}000{,}000$$

Where:
- **Defects** = total number of observed defects
- **Units** = total number of items inspected
- **Opportunities per Unit** = number of ways a unit can be defective (distinct defect categories)

**Defect rate (proportion defective):**

$$p = \frac{\text{DPMO}}{1{,}000{,}000}$$

**Sigma level from DPMO**

Given DPMO, the corresponding sigma level (accounting for the 1.5σ shift) is:

$$\text{Sigma Level} = \Phi^{-1}\!\left(1 - \frac{\text{DPMO}}{1{,}000{,}000}\right) + 1.5$$

where Φ⁻¹ is the inverse of the standard normal CDF (use `scipy.stats.norm.ppf`).

The "+1.5" correction reflects the empirical observation that long-run processes drift by approximately 1.5σ from their short-run target.

**Six Sigma performance table**

| Sigma Level | DPMO | Yield (%) |
|---|---|---|
| 1 | 691,462 | 30.9 |
| 2 | 308,538 | 69.1 |
| 3 | 66,807 | 93.3 |
| 4 | 6,210 | 99.4 |
| 5 | 233 | 99.98 |
| 6 | 3.4 | 99.9997 |

**Link to process capability**

Process capability index Cp and sigma level are directly related for a centred process:

$$\text{Sigma Level} \approx 3 \times C_p \quad \text{(short-run, no mean shift)}$$

$$\text{Sigma Level} \approx 3 \times C_p - 1.5 \quad \text{(long-run, with 1.5σ shift)}$$

Or equivalently: Cp = Sigma Level / 3 (short-run). A Six Sigma process has Cp = 2.0.

For off-centre processes use Cpk: Sigma Level ≈ 3 × Cpk (short-run).

**The DMAIC Roadmap**

DMAIC is the structured problem-solving methodology used in every Six Sigma project:

| Phase | Key Question | Typical Tools |
|---|---|---|
| **Define** | What is the problem and who is affected? | Project charter, SIPOC, Voice of Customer |
| **Measure** | How bad is it? What data do we have? | Process mapping, MSA, baseline DPMO/Cpk |
| **Analyze** | Why does the problem occur? | Pareto chart, fishbone, regression, ANOVA |
| **Improve** | What changes will fix the root cause? | DOE, Poka-yoke, process redesign |
| **Control** | How do we sustain the improvement? | Control charts, control plan, SOP update |

The Measure phase anchors every project to a quantified baseline — DPMO and sigma level are the standard baseline metrics.

## Example

A call centre handles 12,000 calls per month. Each call has 4 potential failure opportunities: wrong resolution, excessive hold time, incorrect billing entry, and failure to follow script. Last month there were 1,080 defects recorded across all categories.

**DPMO calculation:**

$$\text{DPMO} = \frac{1080}{12000 \times 4} \times 1{,}000{,}000 = \frac{1080}{48000} \times 1{,}000{,}000 = 22{,}500$$

**Sigma level:**

$$\text{Sigma} = \Phi^{-1}(1 - 0.0225) + 1.5 = \Phi^{-1}(0.9775) + 1.5 \approx 2.00 + 1.5 = 3.5$$

The centre is operating at approximately 3.5 sigma. The Measure phase of a DMAIC project would capture this baseline. The Analyze phase would then investigate which of the 4 opportunity categories contributes most defects (a Pareto chart is the natural tool here).

## Task

In `exercise.py`:

1. Write a function `dpmo(defects, units, opportunities)` that returns DPMO.
2. Write a function `sigma_level(dpmo_val)` that returns the sigma level using the inverse-normal formula with the 1.5σ shift.
3. Use these functions to reproduce the six-row performance table (sigma 1 through 6), computing DPMO from sigma level by reversing the formula, then verifying the round-trip.
4. Given a dataset of 5 processes with varying defect counts, compute and print DPMO and sigma level for each.
5. Plot sigma level vs DPMO (log scale on x-axis) as a smooth reference curve, and overlay the 5 process points.

## Check

```
npm run check -- bdat-614 module-05 lesson-02
```

## Reflection

A process currently runs at 3.8 sigma with DPMO = 8,198. Management sets a target of 5 sigma. Using the performance table, estimate how large a reduction in DPMO is required, and explain why each additional half-sigma level becomes progressively harder to achieve as you move toward Six Sigma.
