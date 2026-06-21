# Lesson 1: Acceptance Sampling Plans and OC Curves

## Goal

Design single-attribute acceptance sampling plans, quantify producer and consumer risk, and construct the Operating Characteristic (OC) curve to visualise how a plan discriminates between acceptable and unacceptable lots.

## Concept

**Why acceptance sampling?**

When it is destructive, too costly, or physically impossible to inspect every unit, a lot is submitted for inspection and accepted or rejected based on the results from a random sample. Acceptance sampling does **not** improve quality; it separates good lots from bad ones at a given inspection point.

**The single sampling plan (n, c)**

Draw a random sample of **n** units from the lot. Count the number of defectives **d**.
- If d ≤ c — **accept** the lot.
- If d > c — **reject** the lot.

Two parameters define the plan:
- **n** = sample size
- **c** = acceptance number (maximum allowable defectives in the sample)

**Key quality levels**

| Term | Symbol | Definition |
|---|---|---|
| Acceptable Quality Level | AQL | Maximum process defect rate (p) for which the producer wants a high probability of lot acceptance |
| Lot Tolerance Percent Defective | LTPD | Defect rate at which the consumer wants a low probability of accepting the lot |

**Producer risk (α) and consumer risk (β)**

- **α** (producer risk): probability of **rejecting** a lot with incoming defect rate = AQL. This is a false rejection; a good lot is turned away.
- **β** (consumer risk): probability of **accepting** a lot with incoming defect rate = LTPD. This is a false acceptance; a bad lot passes through.

Industry conventions: α ≈ 0.05 and β ≈ 0.10 (these are targets, not guarantees, for a specific plan).

**The Operating Characteristic (OC) Curve**

The OC curve plots **P(accept | p)** — the probability of accepting a lot — against the incoming defect rate p for a fixed plan (n, c).

For a lot of size N with true defect rate p, the exact model is the **hypergeometric distribution**. For large N (N ≥ 10n), the **binomial distribution** is an excellent approximation:

$$P(\text{accept}) = P(D \leq c \mid n, p) = \sum_{d=0}^{c} \binom{n}{d} p^d (1-p)^{n-d}$$

where D ~ Binomial(n, p).

**Reading the OC curve**

- A "steep" OC curve (high n, low c) discriminates sharply — it reliably accepts good lots and rejects bad lots.
- A "flat" OC curve (low n) fails to discriminate — good and bad lots have similar acceptance probabilities.
- Increasing n while keeping AQL and LTPD constant simultaneously reduces α and β.
- Increasing c at fixed n shifts the entire curve upward (more lenient plan), reducing α but increasing β.

**Comparing plans**

| Plan | n | c | Characteristic |
|---|---|---|---|
| Tight | 125 | 2 | Steep OC curve, low AQL, small β |
| Moderate | 80 | 3 | Balanced discrimination |
| Lenient | 50 | 5 | Flat OC curve, high AQL risk |

Tighter plans cost more (larger sample) but provide stronger quality assurance.

## Example

A manufacturer ships lots of N = 3000 circuit boards. The agreed AQL = 1% and LTPD = 5%. A plan with n = 100 and c = 2 is proposed.

**At p = AQL = 0.01:**

$$P(\text{accept}) = \sum_{d=0}^{2} \binom{100}{d}(0.01)^d(0.99)^{100-d}$$

- P(d=0) = 0.99^100 = 0.366
- P(d=1) = 100 × 0.01 × 0.99^99 = 0.370
- P(d=2) = 4950 × 0.0001 × 0.99^98 = 0.185

P(accept | p=0.01) ≈ 0.921 → producer risk α = 1 − 0.921 = **0.079 (7.9%)**

**At p = LTPD = 0.05:**

P(accept | p=0.05) ≈ 0.118 → consumer risk β = **0.118 (11.8%)**

The plan is close to the standard α = 5%, β = 10% target but slightly generous to the producer.

## Task

In `exercise.py`, implement the following:

1. Use `scipy.stats.binom.cdf(c, n, p)` to compute P(accept) for p values from 0 to 0.20.
2. Plot the OC curve for three sampling plans — (n=50, c=2), (n=100, c=2), (n=100, c=4) — on the same axes.
3. Mark the AQL (p=0.01) and LTPD (p=0.06) as vertical dashed lines and read off α and β for each plan.
4. Print a table: for each plan, print P(accept) at AQL and at LTPD.

## Check

```
npm run check -- bdat-614 module-05 lesson-01
```

## Reflection

A quality manager argues that increasing n from 100 to 200 (while keeping c = 2) will protect both producer and consumer better. Use your OC curve knowledge to explain why this is true, and identify any trade-off the manager should consider before approving the change.
