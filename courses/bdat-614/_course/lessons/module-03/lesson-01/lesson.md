# Lesson 6: Process Capability Analysis — Cp and Cpk

## Goal
Compute Cp and Cpk from process data and specification limits, interpret the indices to determine whether a process is capable, and explain the difference between the two indices.

## Concept

A control chart tells you whether a process is *statistically stable* — in control. But it does not tell you whether the process is actually producing parts that meet the **specification** (customer requirements). That is what **process capability analysis** answers.

**Specification limits** are set by engineers or customers:
- **USL** = Upper Specification Limit
- **LSL** = Lower Specification Limit

The **specification width** = USL − LSL.
The **process spread** = 6σ (the natural variation of the process, covering ±3σ).

### Cp — Potential Capability

Cp compares the specification width to the process spread:

```
Cp = (USL − LSL) / 6σ
```

- **Cp > 1.33:** Excellent — the process comfortably fits inside the spec.
- **1.00 < Cp ≤ 1.33:** Marginal — the process fits but with little room.
- **Cp < 1.00:** Not capable — the process produces defects.

**Limitation of Cp:** It assumes the process is centred between the spec limits. If the process mean is off-centre, Cp overstates capability.

### Cpk — Actual Capability (with centring)

Cpk accounts for how well the process is centred:

```
Cpk = min( (USL − μ) / 3σ,  (μ − LSL) / 3σ )
```

It takes the smaller of the two distances from the mean to a spec limit, divided by 3σ.

- **Cpk > 1.33:** Excellent
- **1.00 < Cpk ≤ 1.33:** Marginal
- **Cpk < 1.00:** Not capable

**Key insight:** Cp = Cpk only when the process is perfectly centred. If Cp is much larger than Cpk, the process is capable but off-centred — recentring the process (without reducing variation) would immediately improve quality.

**Important:** Process capability analysis is only valid **after** the process has been confirmed to be in statistical control (Xbar-R chart showing no out-of-control signals). Running capability analysis on an unstable process gives meaningless results.

## Example

A machining process produces shaft diameters. Specifications: LSL = 49.5 mm, USL = 50.5 mm. From 100 parts: μ = 50.1 mm, σ = 0.12 mm.

```
Cp  = (50.5 − 49.5) / (6 × 0.12) = 1.0 / 0.72 = 1.39  → Excellent
Cpk = min( (50.5 − 50.1)/(3×0.12), (50.1 − 49.5)/(3×0.12) )
    = min( 0.4/0.36, 0.6/0.36 )
    = min( 1.11, 1.67 )
    = 1.11  → Marginal
```

The process has good potential (Cp = 1.39) but the mean is shifted toward the USL. Action: adjust the process mean to 50.0 mm without changing the variability.

## Task

Open `exercise.py`. You are given a dataset of 80 shaft diameters. The specs are LSL = 19.5 mm, USL = 20.5 mm. Compute σ from the data, compute Cp and Cpk, and interpret the results. Then plot a histogram with spec lines.

Run the check when done:
`npm run check -- bdat-614 module-03 lesson-01`

## Check

```
npm run check -- bdat-614 module-03 lesson-01
```

## Reflection

A process has Cp = 1.50 and Cpk = 0.85. What does this tell you about the process? What specific action would you take — reduce variation, shift the mean, or both? Explain.
