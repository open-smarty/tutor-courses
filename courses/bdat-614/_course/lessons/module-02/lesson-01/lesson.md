# Lesson 3: Variables Control Charts — Xbar-R and Xbar-S

## Goal
Construct Xbar-R and Xbar-S control charts from subgroup data, compute control limits using the correct constants, and identify out-of-control signals.

## Concept

A **control chart** is a time-series plot with three horizontal lines:
- **Center Line (CL):** the process average
- **Upper Control Limit (UCL):** CL + 3 standard deviations
- **Lower Control Limit (LCL):** CL − 3 standard deviations

Points outside the UCL or LCL signal that the process is out of control — a special cause is likely present.

Control charts for **variables data** (measurements like weight, temperature, time) use subgroups — small samples taken at regular intervals. Two charts are always plotted together: one for the **location** (average) and one for the **spread** (range or standard deviation).

### Xbar-R Chart (subgroup size n = 2 to 10)

Used when subgroups are small (n ≤ 10). "R" is the range within each subgroup (max − min).

**Step 1:** Collect k subgroups, each of size n. Compute the subgroup means (x̄ᵢ) and ranges (Rᵢ).

**Step 2:** Compute the grand mean and average range:
- x̄̄ = mean of all x̄ᵢ
- R̄ = mean of all Rᵢ

**Step 3:** Apply control chart constants (from the standard table, based on n):

| n | A₂ | D₃ | D₄ |
|---|----|----|-----|
| 2 | 1.880 | 0 | 3.267 |
| 3 | 1.023 | 0 | 2.574 |
| 4 | 0.729 | 0 | 2.282 |
| 5 | 0.577 | 0 | 2.114 |

- **Xbar chart:** UCL = x̄̄ + A₂·R̄, LCL = x̄̄ − A₂·R̄
- **R chart:** UCL = D₄·R̄, LCL = D₃·R̄

### Xbar-S Chart (subgroup size n > 10)

For larger subgroups, use the within-subgroup standard deviation S instead of R. The constants A₃, B₃, B₄ replace A₂, D₃, D₄.

### Western Electric Rules (Out-of-Control Signals)

A chart signals out of control when:
1. One point beyond 3σ limits (most common)
2. Two of three consecutive points beyond 2σ on the same side
3. Four of five consecutive points beyond 1σ on the same side
4. Eight consecutive points on the same side of the centre line

## Example

Bottle filling line. Subgroup size n = 5. We take 6 subgroups:

| Subgroup | x̄ᵢ (ml) | Rᵢ (ml) |
|---|---|---|
| 1 | 500.2 | 2.1 |
| 2 | 499.8 | 1.9 |
| 3 | 500.5 | 2.3 |
| 4 | 499.6 | 2.0 |
| 5 | 500.1 | 1.8 |
| 6 | 500.3 | 2.2 |

x̄̄ = 500.08, R̄ = 2.05. For n=5: A₂=0.577, D₃=0, D₄=2.114.

- Xbar UCL = 500.08 + 0.577 × 2.05 = 501.26
- Xbar LCL = 500.08 − 0.577 × 2.05 = 498.90
- R UCL = 2.114 × 2.05 = 4.33, R LCL = 0

All points are within limits — the process is in control.

## Task

Open `exercise.py`. You are given subgroup data from a manufacturing process. Compute the Xbar-R control chart limits and plot both charts using matplotlib. Identify any out-of-control points.

Run the check when done:
`npm run check -- bdat-614 module-02 lesson-01`

## Check

```
npm run check -- bdat-614 module-02 lesson-01
```

## Reflection

Your Xbar chart shows no out-of-control points, but the R chart shows one point above the UCL. The process average looks stable. Should you be concerned? What does an out-of-control R chart tell you about the process that an in-control Xbar chart cannot?
