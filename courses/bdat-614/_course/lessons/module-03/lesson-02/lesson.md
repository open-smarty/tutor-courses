# Lesson 2: Measurement System Analysis — Gauge R&R

## Goal

By the end of this lesson you will understand why a measurement system must be evaluated before trusting any process data, how ANOVA-based Gauge R&R partitions total variation into its components, and how to judge whether a measurement system is fit for purpose using %Gauge R&R thresholds.

## Concept

### Why measurement systems matter

Every observation you record contains two sources of variation:

- **Part-to-Part variation** — genuine differences between the items being measured.
- **Measurement system error (Gauge R&R)** — variation introduced by the measurement system itself.

If the measurement system error is large relative to the specification tolerance, you cannot tell whether a product is conforming or not. Control charts and capability indices built on noisy data will mislead you. Gauge R&R studies make the measurement error visible and quantifiable.

---

### Components of a Gauge R&R study

A standard Gauge R&R study crosses **parts** with **operators**:

- **k** operators each measure each of **n** parts **r** times (replications).
- Total observations = n × k × r.

The total observed variation is partitioned as:

$$\sigma^2_{total} = \sigma^2_{part} + \sigma^2_{repeatability} + \sigma^2_{reproducibility}$$

| Component | Symbol | Meaning |
|---|---|---|
| Gauge R&R | sigma^2_GRR = sigma^2_EV + sigma^2_AV | Total measurement error |
| Repeatability (EV — Equipment Variation) | sigma^2_EV | Same operator, same part, repeated measures |
| Reproducibility (AV — Appraiser Variation) | sigma^2_AV | Variation between different operators |
| Part-to-Part | sigma^2_PV | True process variation |

---

### ANOVA approach to Gauge R&R

A two-factor crossed ANOVA (Part × Operator) provides unbiased estimates of each variance component. The ANOVA table has the following structure:

| Source | SS | df | MS | EMS |
|---|---|---|---|---|
| Part | SS_Part | n − 1 | MS_Part | sigma^2_e + r * sigma^2_PO + r * k * sigma^2_P |
| Operator | SS_Op | k − 1 | MS_Op | sigma^2_e + r * sigma^2_PO + r * n * sigma^2_O |
| Part × Operator | SS_PO | (n−1)(k−1) | MS_PO | sigma^2_e + r * sigma^2_PO |
| Repeatability (error) | SS_e | nk(r−1) | MS_e | sigma^2_e |

Variance component estimates (solving the EMS equations):

$$\hat{\sigma}^2_{EV} = MS_e$$

$$\hat{\sigma}^2_{PO} = \max\!\left(0,\, \frac{MS_{PO} - MS_e}{r}\right)$$

$$\hat{\sigma}^2_{AV} = \max\!\left(0,\, \frac{MS_{Op} - MS_{PO}}{r \cdot n}\right)$$

$$\hat{\sigma}^2_{PV} = \max\!\left(0,\, \frac{MS_{Part} - MS_{PO}}{r \cdot k}\right)$$

$$\hat{\sigma}^2_{GRR} = \hat{\sigma}^2_{EV} + \hat{\sigma}^2_{AV}$$

---

### Study variation and %Gauge R&R

The **study variation** for each component is defined as 5.15 standard deviations (covering 99% of a normal distribution):

$$StudyVar = 5.15 \times \sigma_{component}$$

The **%Gauge R&R** relative to the process tolerance (USL − LSL) is:

$$\%Gauge\,R\&R = \frac{5.15 \times \sigma_{GRR}}{USL - LSL} \times 100$$

**Decision thresholds (AIAG MSA Manual, 4th edition):**

| %Gauge R&R | Assessment |
|---|---|
| < 10% | Acceptable — measurement system is adequate |
| 10% – 30% | Marginal — may be acceptable depending on application |
| > 30% | Unacceptable — measurement system must be improved |

**%Part Variation** expresses how much of the study variation is attributable to genuine part differences:

$$\%PV = \frac{5.15 \times \sigma_{PV}}{USL - LSL} \times 100$$

Ideally %PV should dominate, meaning the study can distinguish between parts.

---

### Number of Distinct Categories (ndc)

The ndc quantifies how many different groups the measurement system can reliably distinguish:

$$ndc = \frac{\sqrt{2} \times \sigma_{PV}}{\sigma_{GRR}}$$

Truncate to the nearest integer. AIAG requires ndc >= 5 for an adequate measurement system.

---

## Example

A manufacturing plant measures shaft diameters with a digital calliper. The study uses n = 10 parts, k = 3 operators, r = 2 replications. Specification: LSL = 19.0 mm, USL = 21.0 mm (tolerance = 2 mm).

After running the ANOVA, the variance component estimates are:

- sigma^2_EV = 0.0016 (repeatability)
- sigma^2_AV = 0.0009 (reproducibility)
- sigma^2_PV = 0.0120 (part-to-part)
- sigma^2_GRR = 0.0025

Study variation calculations (× 5.15):

- StudyVar_GRR = 5.15 × sqrt(0.0025) = 5.15 × 0.05 = 0.2575 mm
- %Gauge R&R = (0.2575 / 2.0) × 100 = **12.9%** — marginal

This calliper introduces too much variation for a safety-critical shaft application. Possible remedies: improved operator training (if AV is the main driver) or instrument recalibration (if EV dominates).

## Task

Complete `exercise.py`. You will:

1. Simulate a Gauge R&R dataset: 10 parts × 3 operators × 2 replications with known variance components.
2. Compute the ANOVA table (SS, df, MS) for Part, Operator, Part × Operator, and Repeatability.
3. Estimate variance components (sigma^2_EV, sigma^2_AV, sigma^2_PV, sigma^2_GRR).
4. Compute %Gauge R&R and %Part Variation relative to the tolerance, and the ndc.
5. Produce a two-panel figure: (a) a grouped bar chart showing study variation by component; (b) a scatter plot of measurements by operator coloured by part.

## Check

```
npm run check -- bdat-614 module-03 lesson-02
```

## Reflection

- A Gauge R&R study shows %EV = 8% and %AV = 22%. Where should improvement efforts focus and why?
- Why is a high %Part Variation (say, 95%) actually a desirable outcome in a Gauge R&R study?
- A supervisor argues that because all measurements are within 0.01 mm of each other, the measurement system is fine. What is wrong with this reasoning?
