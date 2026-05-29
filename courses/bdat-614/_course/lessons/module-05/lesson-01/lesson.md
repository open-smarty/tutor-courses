# Lesson 10: Acceptance Sampling Plans and OC Curves

## Goal
Describe acceptance sampling, explain the roles of AQL and LTPD, design a single sampling plan, compute its Operating Characteristic (OC) curve, and interpret producer's risk and consumer's risk.

## Concept

**Acceptance sampling** is a statistical method used to decide whether to accept or reject a batch (lot) of products. Rather than inspecting every item (100% inspection), a sample is taken and a decision rule applied.

It is used when:
- 100% inspection is too expensive or destructive
- Items are incoming raw materials or finished goods
- A supplier sends regular batches and trust must be verified statistically

**It is not a substitute for SPC** — it does not improve the process, it only makes accept/reject decisions on existing lots.

### Key Terms

| Term | Meaning |
|------|---------|
| **N** | Lot size — total number of items in the batch |
| **n** | Sample size — number of items inspected |
| **c** | Acceptance number — maximum defectives allowed in the sample |
| **AQL** | Acceptable Quality Level — the proportion defective at which the producer's quality is good |
| **LTPD** | Lot Tolerance Percent Defective — the proportion defective the consumer considers unacceptable |
| **α (Producer's Risk)** | Probability of rejecting a good lot (Type I error) |
| **β (Consumer's Risk)** | Probability of accepting a bad lot (Type II error) |

### Single Sampling Plan

**Decision rule:** Inspect n items. Count the number of defectives d.
- If d ≤ c → **Accept** the lot
- If d > c → **Reject** the lot

**Parameters:** N = lot size, n = sample size, c = acceptance number.

### Operating Characteristic (OC) Curve

The OC curve plots **Pa (probability of accepting the lot)** on the y-axis against **p (true proportion defective)** on the x-axis.

For a single sampling plan, Pa(p) uses the **Binomial** (or Poisson for large lots) distribution:

```
Pa(p) = P(X ≤ c | X ~ Binomial(n, p))
       = Σ [k=0 to c] C(n,k) × pᵏ × (1-p)^(n-k)
```

A steep OC curve means the plan discriminates well between good and bad lots.

Key points on the OC curve:
- At p = AQL: Pa should be high (≈ 1 − α), because good lots should usually be accepted.
- At p = LTPD: Pa should be low (≈ β), because bad lots should usually be rejected.

### Example

N = 2000, n = 125, c = 3, AQL = 1%, LTPD = 5%.

Decision rule: inspect 125 items; reject the lot if more than 3 are defective.

At p = 0.01: Pa = P(X ≤ 3 | Binomial(125, 0.01)) ≈ 0.97 → producer's risk α ≈ 3%
At p = 0.05: Pa = P(X ≤ 3 | Binomial(125, 0.05)) ≈ 0.10 → consumer's risk β ≈ 10%

## Task

Open `exercise.py`. Design a single sampling plan with n=100, c=2. Use scipy to compute Pa for a range of p values and plot the OC curve. Mark the AQL and LTPD points and interpret the producer's and consumer's risks.

Run the check when done:
`npm run check -- bdat-614 module-05 lesson-01`

## Check

```
npm run check -- bdat-614 module-05 lesson-01
```

## Reflection

A supplier argues that single sampling is unfair — if their batch happens to have a bad sample by chance, the whole lot gets rejected even though most items are fine. Is this a valid concern? What does the OC curve tell you about this risk? How would you respond to the supplier?
