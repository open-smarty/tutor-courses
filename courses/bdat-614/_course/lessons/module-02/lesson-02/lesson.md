# Lesson 4: Individuals and Moving Range (I-MR) Charts

## Goal
Construct an I-MR chart for individual (n=1) observations, compute its control limits using the correct constants, and explain why it is the preferred control chart for Big Data streaming scenarios.

## Concept

The Xbar-R chart requires subgroups of 2 or more measurements taken at the same time. But many real processes produce **one observation at a time**:

- A daily server response time measurement
- A chemical batch that takes a full day to produce (one result per day)
- IoT sensor readings arriving one per second
- Daily average error rate from an ETL pipeline

For these processes, we use the **Individuals and Moving Range (I-MR) chart**, also called the X-MR chart. It is two charts:

**I-Chart (Individuals chart):** plots each individual measurement. Monitors the process *level* (mean).

**MR-Chart (Moving Range chart):** plots the absolute difference between consecutive measurements: MRᵢ = |xᵢ − xᵢ₋₁|. Monitors the process *variability*.

### Formulas

Let x₁, x₂, …, xₖ be k individual measurements.

- x̄ = (Σxᵢ) / k  ← centre line of I-Chart
- MRᵢ = |xᵢ − xᵢ₋₁|  for i = 2, 3, …, k
- MR̄ = (Σ MRᵢ) / (k − 1)  ← centre line of MR-Chart

**I-Chart limits:**
- UCLₓ = x̄ + 2.66 × MR̄
- LCLₓ = x̄ − 2.66 × MR̄

**MR-Chart limits:**
- UCL_MR = 3.267 × MR̄
- LCL_MR = 0

The constant 2.66 = E₂ = 3/d₂ where d₂ = 1.128 for n=1. The constant 3.267 = D₄ for n=1.

### Why I-MR for Big Data?

When data arrives as a continuous stream (one point per second from an IoT sensor), it is impractical to wait and form subgroups. The I-MR chart processes each new observation as it arrives, making it **ideal for real-time streaming quality control** using tools like Kafka or Spark Streaming.

## Example

Daily server response times (ms) for 8 days (from the course slides):

| Day | Response Time (xᵢ) | Moving Range (MRᵢ) |
|-----|---------------------|---------------------|
| 1   | 245                 | —                   |
| 2   | 238                 | 7                   |
| 3   | 252                 | 14                  |
| 4   | 241                 | 11                  |
| 5   | 260                 | 19                  |
| 6   | 255                 | 5                   |
| 7   | 248                 | 7                   |
| 8   | 272                 | 24                  |

x̄ = 251.375 ms,  MR̄ = 12.43 ms

- I-Chart: UCL = 251.375 + 2.66 × 12.43 = **284.4 ms**,  LCL = **218.3 ms**
- MR-Chart: UCL = 3.267 × 12.43 = **40.6 ms**,  LCL = 0

All 8 days are within control limits — the process is in control.

## Task

Open `exercise.py`. You are given 24 hourly server response time readings. Compute the I-MR chart limits, plot both charts, and identify any out-of-control observations.

Run the check when done:
`npm run check -- bdat-614 module-02 lesson-02`

## Check

```
npm run check -- bdat-614 module-02 lesson-02
```

## Reflection

Your I-Chart shows the process in control, but the MR-Chart has one point above its UCL. What does this tell you specifically? Can the process be considered stable? What should you investigate?
