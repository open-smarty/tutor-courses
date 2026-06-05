# Lesson 1: Process Capability Analysis — Cp and Cpk

## Goal

By the end of this lesson you will be able to compute and interpret Cp, Cpk, Pp, and Ppk for any process where the specification limits and process parameters are known. You will understand the critical difference between control limits and specification limits, and you will diagnose whether a process is failing because of too much spread, because of off-centring, or both.

## Concept

### Control limits versus specification limits

This distinction is the single most common confusion in SPC:

- **Control limits** (UCL/LCL) are calculated from the process data itself. They represent the natural voice of the process — how much variation the process actually produces when only common causes are present. They live on the control chart.
- **Specification limits** (USL/LSL) are set by the customer, design engineer, or regulatory body. They express the acceptable range of the output. They are external to the process.

A process can be statistically in control (all points inside UCL/LCL) and still fail to meet specifications if the natural spread is too wide, or if the process is centred away from the target. Process capability indices quantify this relationship.

---

### Cp — Potential Capability (spread only)

Cp measures whether the process spread is narrow enough to fit inside the specification window, assuming perfect centring.

$$C_p = \frac{USL - LSL}{6\sigma}$$

where sigma is the short-term (within-subgroup) standard deviation estimated from the control chart (sigma = R-bar/d_2 or S-bar/c_4).

Interpretation: Cp = 1.0 means the 6-sigma process spread exactly fills the spec window. Cp = 1.33 leaves a comfortable safety margin. Cp does not account for where the process mean sits.

---

### Cpk — Actual Capability (spread and centring)

Cpk penalises for off-centring. It computes the number of sigma-units from the process mean to the nearest specification limit, divided by 3:

$$C_{pk} = \min\!\left(\frac{USL - \mu}{3\sigma},\ \frac{\mu - LSL}{3\sigma}\right)$$

Note: Cpk <= Cp always. If Cpk = Cp, the process is perfectly centred. If Cpk < Cp, the mean has drifted toward one specification limit.

**Rules of thumb:**

| Cpk value | Assessment |
|---|---|
| < 1.00 | Poor — process produces nonconforming product |
| 1.00 – 1.33 | Marginal — barely capable; monitor closely |
| 1.33 – 1.67 | Capable — acceptable for most industries |
| > 1.67 | Excellent — Six Sigma–class capability |

---

### Cp > Cpk: capable but off-centre

If you see Cp = 1.50 but Cpk = 0.80, the process spread is narrow enough to fit well inside the spec window, but the mean has shifted toward one limit. The fix is centring (adjust the process mean), not reducing variation.

---

### Pp and Ppk — Long-term capability

Pp and Ppk use the **overall** standard deviation (s computed from all individual observations pooled), which includes both within-subgroup and between-subgroup variation. This gives a long-term performance view.

$$P_p = \frac{USL - LSL}{6 s_{overall}}, \qquad P_{pk} = \min\!\left(\frac{USL - \mu}{3 s_{overall}},\ \frac{\mu - LSL}{3 s_{overall}}\right)$$

Typically Ppk <= Cpk because s_overall >= sigma_within. A large gap (Cpk - Ppk > 0.2) signals that the process drifts or shifts over time.

---

### Percentage nonconforming from capability

For a normal distribution, the expected proportion outside specifications is:

$$P(\text{nonconforming}) = \Phi\!\left(\frac{LSL - \mu}{\sigma}\right) + \left[1 - \Phi\!\left(\frac{USL - \mu}{\sigma}\right)\right]$$

where Phi is the standard normal CDF.

## Example

A pharmaceutical packaging line fills sachets with a target of 500 g. Specification limits: LSL = 496 g, USL = 504 g. The process sigma (from control chart) is sigma = 1.5 g.

**Step 1 — Cp (assuming mu = 500):**

$$C_p = \frac{504 - 496}{6 \times 1.5} = \frac{8}{9} = 0.889$$

Cp < 1.0: the process spread is too wide to meet specifications even if perfectly centred.

**Step 2 — After reducing sigma to 0.9 g (process improvement), mu still = 500:**

$$C_p = \frac{8}{6 \times 0.9} = \frac{8}{5.4} = 1.481$$

Now the spread fits inside the window. But if the mean drifts to mu = 501:

$$C_{pk} = \min\!\left(\frac{504 - 501}{3 \times 0.9},\ \frac{501 - 496}{3 \times 0.9}\right) = \min(1.11,\ 1.85) = 1.11$$

Cpk = 1.11 — marginal. The process is off-centre; recentring to 500 would restore Cpk = 1.48.

## Task

Complete `exercise.py`. You will:

1. Generate 200 fill-weight observations from N(mu, sigma^2) using the parameters above.
2. Compute Cp and Cpk for the centred case (mu = 500, sigma = 0.9).
3. Shift the mean to 501 and recompute Cpk.
4. Plot a histogram of the fill weights with vertical lines for LSL, USL, and the process mean. Add a fitted normal curve.
5. Annotate the plot with Cp and Cpk values.

## Check

```
npm run check -- bdat-614 module-03 lesson-01
```

## Reflection

- A process has Cp = 2.0 but Cpk = 0.5. What does this tell you about the process? What single action would most improve quality?
- Why do engineers typically require Cpk >= 1.33 rather than >= 1.0?
- A supplier reports Cpk = 1.67 for their component. You find Ppk = 1.10. Should you be concerned? Why?
