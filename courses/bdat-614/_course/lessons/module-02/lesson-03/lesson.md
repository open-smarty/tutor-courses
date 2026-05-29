# Lesson 5: Attribute Control Charts — p, np, c, and u Charts

## Goal
Select the correct attribute control chart for a given situation, compute its control limits, and explain the difference between defectives and defects.

## Concept

When quality is measured by *counting* rather than *measuring*, we use **attribute control charts**. There are two types of counts:

- **Defective (nonconforming) unit:** an entire item is defective — it either passes or fails (binary). A bottle with the wrong label. A transaction that errors out.
- **Defect (nonconformity):** a specific flaw on a unit — one unit can have multiple defects. Scratches on a surface. Null values in a record.

This distinction drives which chart to use:

| Chart | What is Counted | Sample Size |
|-------|----------------|-------------|
| **p-chart** | Proportion of defectives | Variable |
| **np-chart** | Number of defectives | Constant |
| **c-chart** | Number of defects | Constant |
| **u-chart** | Defects per unit | Variable |

### p-Chart (Proportion Defective)

Used when you count the fraction of defective items per sample and sample size varies.

- p̄ = total defectives / total inspected
- UCL_p = p̄ + 3√(p̄(1−p̄)/nᵢ)   ← computed per sample if nᵢ varies
- LCL_p = max(0, p̄ − 3√(p̄(1−p̄)/nᵢ))

### np-Chart (Number of Defectives)

Used when you count the actual number of defective items and sample size is constant.

- np̄ = p̄ × n
- UCL = np̄ + 3√(np̄(1−p̄))
- LCL = max(0, np̄ − 3√(np̄(1−p̄)))

### c-Chart (Number of Defects)

Used when counting defects on a single unit (or fixed inspection area) with constant sample size. Based on the Poisson distribution.

- c̄ = total defects / number of units
- UCL = c̄ + 3√c̄
- LCL = max(0, c̄ − 3√c̄)

### u-Chart (Defects per Unit)

Like the c-chart but sample size (number of units inspected) can vary.

- ū = total defects / total units inspected
- UCL_u = ū + 3√(ū/nᵢ)   ← varies per sample
- LCL_u = max(0, ū − 3√(ū/nᵢ))

**Big Data example:** monitoring error rates in an ETL pipeline — each daily run inspects a different number of records, so the u-chart (defects per unit = errors per record) is appropriate, with variable limits.

## Example

A web service is monitored for failed API calls. Each hour, 200 requests are sampled (constant n). The number of failures in 8 hours: 4, 6, 2, 8, 5, 3, 7, 4.

This is an np-chart (number of defectives, constant n=200).

- p̄ = (4+6+2+8+5+3+7+4) / (8×200) = 39/1600 = 0.0244
- np̄ = 0.0244 × 200 = 4.875
- UCL = 4.875 + 3√(4.875 × (1−0.0244)) = 4.875 + 3√4.756 = 4.875 + 6.54 = **11.4**
- LCL = max(0, 4.875 − 6.54) = **0**

Hour 4 (8 failures) is within control. The process is in control.

## Task

Open `exercise.py`. You are given daily data from two different processes. For each one, select and build the correct attribute chart (p, np, c, or u), compute variable or fixed limits, and plot the chart.

Run the check when done:
`npm run check -- bdat-614 module-02 lesson-03`

## Check

```
npm run check -- bdat-614 module-02 lesson-03
```

## Reflection

An analyst is monitoring a data ingestion pipeline. Each day, a different number of records arrive. The analyst wants to track the number of invalid records per day. Should they use a c-chart or a u-chart? Why does it matter which one they choose?
