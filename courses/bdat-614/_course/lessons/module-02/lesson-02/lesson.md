# Lesson 4: Individuals and Moving Range (I-MR) Charts

## Goal

Construct and interpret I-MR charts for processes where measurements are taken one at a time.

## Concept

**When to use I-MR**

Xbar-R charts require subgroups — multiple measurements taken under essentially the same conditions. But many real processes produce one measurement at a time with no natural grouping:
- One batch test result per day (pharmaceutical purity)
- One API latency measurement per scheduled health check (every 10 minutes)
- One daily ETL job runtime
- One monthly customer satisfaction score

For these situations, we use the **Individuals (I) chart** to monitor the process level and the **Moving Range (MR) chart** to monitor process variability.

**Moving Range**

The moving range between consecutive observations is defined as:

MRᵢ = |xᵢ − xᵢ₋₁|   for i = 2, 3, …, n

In plain English: the absolute difference between each observation and the one immediately before it. There are n−1 moving ranges for n observations. The average moving range is:

MR̄ = (1/(n−1)) × Σ MRᵢ

**Estimating process standard deviation from MR̄**

For two consecutive normal observations, the expected value of their absolute difference is:

E(|x₁ − x₂|) = d₂ × σ

where d₂ = 1.128 for a range of n=2 observations (a constant from control chart theory, tabulated for all subgroup sizes). Rearranging:

σ̂ = MR̄ / d₂ = MR̄ / 1.128

This is how we estimate the short-term process standard deviation from individual data.

**I chart control limits**

- CL = x̄ (mean of all individual observations)
- UCL = x̄ + 3 × (MR̄ / d₂) = x̄ + 3 × (MR̄ / 1.128) = x̄ + 2.660 × MR̄
- LCL = x̄ − 2.660 × MR̄

**MR chart control limits**

- CL = MR̄
- UCL = D₄ × MR̄ = 3.267 × MR̄
- LCL = 0

Note: D₄ = 3.267 for n=2 (from standard control chart constant tables).

**Important assumption**

The I-MR chart assumes individual measurements are approximately normally distributed. Unlike the Xbar chart (which benefits from the Central Limit Theorem to make the subgroup mean approximately normal even for non-normal data), the I chart plots raw observations directly. If your data is strongly skewed, the false alarm rate may be much higher or lower than 0.27%.

Additionally, I-MR assumes observations are **not autocorrelated** — each observation is independent of the previous one. If measurements are positively autocorrelated (e.g., slowly drifting temperature), the MR̄ will underestimate σ and the limits will be too tight, causing excessive false alarms.

## Example

API response times measured once per minute. After 30 observations: x̄ = 245ms, MR̄ = 18ms.

**I chart limits:**
- UCL = 245 + 2.660 × 18 = 245 + 47.9 = **292.9 ms**
- LCL = 245 − 47.9 = **197.1 ms**

**MR chart limits:**
- UCL = 3.267 × 18 = **58.8 ms**
- LCL = 0

At minute 42, the response time is 310ms. Since 310 > 292.9 = UCL, the I chart signals out of control. Investigation finds the database connection pool was exhausted — a special cause in the "Machine" category.

Moving range between observation 41 and 42: |310 − 248| = 62ms > 58.8 = UCL_MR. The MR chart also signals — the jump between consecutive observations was unusually large.

## Task

In `exercise.py`, generate 30 individual API response time measurements (mean=245ms, sd=18ms). Simulate a process shift at observation 22 by adding 60ms to observations 22 through 30. Compute the I chart and MR chart control limits. Plot both charts side by side. Mark any out-of-control points in red.

## Check

```
npm run check -- bdat-614 module-02 lesson-02
```

## Reflection

The I-MR chart assumes measurements are not autocorrelated. What happens to the false alarm rate if API response times are positively autocorrelated — for example, because a slow server stays slow for several consecutive minutes? Would the I chart signal too often or too rarely?
