# Lesson 3: Attribute Control Charts — p, np, c, and u Charts

## Goal

By the end of this lesson you will be able to select the correct attribute control chart for a given situation, derive its control limits from first principles, and interpret out-of-control signals. You will also understand how attribute charts apply to ETL and data-pipeline quality monitoring.

## Concept

### What is attribute data?

Variables data (covered in Module 2 Lessons 1–2) requires a measurement on a continuous scale — fill weight, diameter, latency. **Attribute data** is categorical: either an item is defective or it is not, or you count how many defects an item carries. Attribute charts are appropriate whenever measuring each item precisely is impractical or impossible.

Two key distinctions drive chart selection:

| Question | Answer → Chart family |
|---|---|
| Are you counting **defective items** (pass/fail) or **defects** (multiple faults per item)? | Defective items → p or np. Defects → c or u. |
| Is the **subgroup size** constant across samples? | Constant → np or c. Variable → p or u. |

---

### p Chart — Proportion Defective (variable n)

Each subgroup i has sample size n_i. Let D_i be the number of defective items. The sample proportion is p_i = D_i / n_i.

The process proportion defective p-bar is estimated from k subgroups:

$$\bar{p} = \frac{\sum_{i=1}^{k} D_i}{\sum_{i=1}^{k} n_i}$$

Control limits for subgroup i (limits vary because n_i varies):

$$\text{CL} = \bar{p}, \quad \text{UCL}_i = \bar{p} + 3\sqrt{\frac{\bar{p}(1-\bar{p})}{n_i}}, \quad \text{LCL}_i = \bar{p} - 3\sqrt{\frac{\bar{p}(1-\bar{p})}{n_i}}$$

If LCL_i < 0, set it to 0.

**Basis:** each D_i ~ Binomial(n_i, p), so Var(p_i) = p(1-p)/n_i; the 3-sigma rule applies.

---

### np Chart — Number Defective (constant n)

When n is the same in every subgroup, it is easier to plot the raw count D_i rather than the proportion.

$$\text{CL} = n\bar{p}, \quad \text{UCL} = n\bar{p} + 3\sqrt{n\bar{p}(1-\bar{p})}, \quad \text{LCL} = n\bar{p} - 3\sqrt{n\bar{p}(1-\bar{p})}$$

The np chart and p chart carry identical statistical power when n is constant; the np chart is simply easier to read on a factory floor.

---

### c Chart — Count of Defects (constant n)

A single item (or inspection unit of fixed size) can contain multiple defects. Model: D ~ Poisson(c-bar). The Poisson distribution has the convenient property that its mean equals its variance.

$$\text{CL} = \bar{c}, \quad \text{UCL} = \bar{c} + 3\sqrt{\bar{c}}, \quad \text{LCL} = \bar{c} - 3\sqrt{\bar{c}}$$

where c-bar = (sum of all defect counts) / k.

---

### u Chart — Defects per Unit (variable n)

When the inspection area or batch size varies, standardise by computing defects per unit: u_i = c_i / n_i.

$$\bar{u} = \frac{\sum c_i}{\sum n_i}, \quad \text{CL} = \bar{u}, \quad \text{UCL}_i = \bar{u} + 3\sqrt{\frac{\bar{u}}{n_i}}, \quad \text{LCL}_i = \bar{u} - 3\sqrt{\frac{\bar{u}}{n_i}}$$

---

### Chart selection summary

```
Item fails pass/fail?  Yes → p (variable n) or np (constant n)
Item can have many faults? Yes → u (variable n) or c (constant n)
```

---

### ETL Pipeline application

An ETL job processes insurance claim records in nightly batches. Each record can have **multiple** data quality issues simultaneously (missing field, out-of-range value, duplicate key, invalid code). Because one record can carry more than one defect, this is a **defects** (not defective) scenario. Because nightly batch sizes vary, the correct chart is a **u chart**.

If instead you only care whether a record passes or fails a validation gate (it either loads or it does not), a **p chart** is appropriate.

## Example

A data pipeline runs 20 nightly batches. The table below shows batch size and defect count for the first five batches:

| Batch | n_i | Defects c_i | u_i = c_i/n_i |
|---|---|---|---|
| 1 | 450 | 9 | 0.0200 |
| 2 | 480 | 6 | 0.0125 |
| 3 | 390 | 11 | 0.0282 |
| 4 | 510 | 7 | 0.0137 |
| 5 | 465 | 8 | 0.0172 |

Suppose across all 20 batches: sum(c_i) = 160, sum(n_i) = 9 200.

$$\bar{u} = \frac{160}{9200} = 0.01739$$

For batch 3 (n_3 = 390):

$$\text{UCL}_3 = 0.01739 + 3\sqrt{\frac{0.01739}{390}} = 0.01739 + 3 \times 0.00668 = 0.03742$$

$$\text{LCL}_3 = 0.01739 - 0.02004 = 0 \text{ (clipped to 0)}$$

Batch 3's u value of 0.0282 is within limits — no signal.

## Task

Complete the Python exercise file `exercise.py`. You will:

1. Simulate 20 batches with variable sizes sampled from a realistic range, generating defective-item counts (for the p chart) and multi-defect counts (for the u chart).
2. Compute p-bar and the variable UCL/LCL for each subgroup and plot a p chart.
3. Compute u-bar and the variable UCL/LCL for each subgroup and plot a u chart.
4. Annotate any point that falls outside its control limits.

## Check

```
npm run check -- bdat-614 module-02 lesson-03
```

## Reflection

Reflect on the following:

- An e-commerce company inspects 500 orders per day and flags each order as "complete" or "incomplete". Which chart would you use and why?
- In a loan application pipeline, each application is checked against 12 rules. A given application can fail multiple rules. You process 2 000 applications per day Monday–Thursday and 800 on Friday. Which chart is correct and how do the Friday control limits differ from Monday's?
- Why is it possible to have p-bar = 0.05 and still observe LCL = 0 for a small subgroup?
