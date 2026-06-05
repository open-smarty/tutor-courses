# Lesson 3: Variables Control Charts — Xbar-R and Xbar-S

## Goal

Construct and interpret Xbar-R and Xbar-S control charts for continuous measurement data.

## Concept

A **control chart** is a time-series plot of process measurements with three horizontal reference lines:
- **CL** (Center Line) — the process average
- **UCL** (Upper Control Limit) — 3 standard deviations above the center
- **LCL** (Lower Control Limit) — 3 standard deviations below the center

**Why 3-sigma limits?**

If the process follows a normal distribution and is in statistical control, the probability of any single observation falling outside μ ± 3σ is:

P(|Z| > 3) = 2 × P(Z > 3) = 2 × 0.00135 = **0.0027**

Only 0.27% of points will fall outside the limits by chance — a false alarm rate of roughly 1 in 370 observations. This is low enough to treat an out-of-control signal as meaningful.

**Xbar-R Charts** (for subgroups of size n = 3 to 9)

We collect measurements in subgroups of size n. Let x̄ᵢ be the mean of subgroup i, and Rᵢ = x_max − x_min be the range of subgroup i.

Notation before formulas:
- x̄̄ = grand mean (mean of all subgroup means)
- R̄ = average range (mean of all subgroup ranges)
- A₂, D₃, D₄ = control chart constants that depend on subgroup size n (from standard tables)

**Xbar chart formulas:**

CL = x̄̄,   UCL = x̄̄ + A₂ × R̄,   LCL = x̄̄ − A₂ × R̄

**R chart formulas:**

CL = R̄,   UCL = D₄ × R̄,   LCL = D₃ × R̄

For n = 5: A₂ = 0.577, D₃ = 0, D₄ = 2.114. These constants are derived from the expected value of the range for normal samples of size n.

**Why plot R chart first?**

The R chart monitors variability. If variability is out of control (R chart signals), the Xbar chart limits are unreliable — always check the R chart before interpreting the Xbar chart.

**Xbar-S Charts** (for n ≥ 10)

For larger subgroups, the sample standard deviation S is a more efficient estimator of process variability than the range R. Replace R̄ with S̄ and use constants A₃, B₃, B₄ (tabulated for each n).

**Western Electric Rules for detecting out-of-control signals:**

Beyond the basic "1 point outside ±3σ" rule, these patterns also signal a special cause:
1. 1 point beyond 3σ
2. 2 of 3 consecutive points beyond 2σ (same side)
3. 4 of 5 consecutive points beyond 1σ (same side)
4. 8 consecutive points on the same side of the center line

## Example

A bottling machine fills containers with a target of 500g. We collect 25 subgroups of n = 5 fill weights.

After collecting all 25 subgroups: x̄̄ = 500.2g, R̄ = 3.8g.

For n = 5: A₂ = 0.577, D₃ = 0, D₄ = 2.114.

**Xbar chart:**
- CL = 500.2
- UCL = 500.2 + 0.577 × 3.8 = 500.2 + 2.19 = **502.4 g**
- LCL = 500.2 − 2.19 = **498.0 g**

**R chart:**
- CL = 3.8
- UCL = 2.114 × 3.8 = **8.0 g**
- LCL = 0 × 3.8 = **0 g**

Interpretation: if subgroup 15 has x̄ = 503.1 > UCL = 502.4, we signal out of control — investigate immediately (check for hopper blockage, worn fill nozzle, or calibration drift).

## Task

In `exercise.py`, simulate 25 subgroups of n = 5 fill weight measurements (mean=500, sd=1.5). Compute x̄̄ and R̄. Calculate UCL and LCL for both the Xbar chart and the R chart using the n = 5 constants. Plot both charts side by side with UCL, CL, and LCL drawn as horizontal lines. Mark any out-of-control points in red.

## Check

```
npm run check -- bdat-614 module-02 lesson-01
```

## Reflection

Why do we always plot the Xbar chart and the R chart together, and in which order should you check them when diagnosing an out-of-control situation?
