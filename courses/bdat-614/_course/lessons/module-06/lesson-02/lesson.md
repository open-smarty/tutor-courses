# Lesson 14: Big Data Applications in SQC — EWMA, CUSUM, and ML Integration

## Goal
Implement EWMA and CUSUM control charts in Python, explain why they outperform Shewhart charts for detecting small process shifts, and describe how machine learning augments traditional SQC in Big Data environments.

## Concept

Traditional Shewhart control charts (Xbar-R, I-MR) are excellent at detecting large, sudden shifts — but they can miss **small, sustained shifts** in the process mean. For Big Data streaming environments that generate millions of observations, two advanced charts are preferred:

### EWMA — Exponentially Weighted Moving Average

The EWMA chart weights recent observations more heavily than older ones using a smoothing parameter λ (0 < λ ≤ 1):

```
EWMA₀ = x̄ (process mean)
EWMAₜ = λ·xₜ + (1 − λ)·EWMAₜ₋₁
```

**Control limits** (asymptotically stable):
```
UCL = μ₀ + L·σ·√(λ/(2−λ))
LCL = μ₀ − L·σ·√(λ/(2−λ))
```
where L is typically 3 (3-sigma limits) and σ is the process standard deviation.

- **Small λ (e.g., 0.1):** more smoothing — sensitive to small, slow shifts.
- **Large λ (e.g., 0.4):** less smoothing — similar to Shewhart chart.

### CUSUM — Cumulative Sum

The CUSUM chart accumulates deviations from the target mean. It uses two statistics:

```
C⁺ₜ = max(0, C⁺ₜ₋₁ + (xₜ − μ₀ − K))   ← upper CUSUM (detects upward shifts)
C⁻ₜ = max(0, C⁻ₜ₋₁ − (xₜ − μ₀ + K))   ← lower CUSUM (detects downward shifts)
```

- **K** = reference value (typically K = δ/2, where δ = shift to detect in units of σ)
- **H** = decision interval (typically H = 4 or 5σ)
- **Signal:** when C⁺ₜ > H or C⁻ₜ > H

CUSUM accumulates small deviations over time — a persistent shift of 1σ will trigger it in ~10 observations, whereas a Shewhart chart might take 40+ observations.

### Traditional SQC vs Big Data SQC

| Feature | Traditional | Big Data |
|---------|-------------|----------|
| Sample size | Small (n=5, monthly) | Millions per minute |
| Update frequency | Hours/days | Sub-second |
| Detection | Reactive | Predictive |
| Charts | Shewhart | EWMA, CUSUM, Hotelling's T² |
| Tools | Minitab, manual | Python, Spark, Kafka, Flink |

### Machine Learning + SQC

ML can augment traditional SQC in two ways:

1. **Hybrid anomaly detection:** Use traditional 3σ control limits for interpretability, but also run an Isolation Forest or Autoencoder to catch complex, multivariate anomalies that a univariate chart would miss.

2. **Predictive quality:** Use time-series forecasting (ARIMA, LSTM) to predict when a process will go out of control *before* it happens — enabling preventive action rather than reactive correction.

### Big Data Architecture for Real-Time SPC

```
IoT Sensors → Kafka → Spark Streaming → EWMA/CUSUM Chart → Alert → Dashboard
                                       ↓
                               ML Anomaly Model
```

## Example

Server response times are monitored with an EWMA chart (λ = 0.2). The process mean is 250 ms, σ = 15 ms.

- L = 3, UCL = 250 + 3 × 15 × √(0.2/1.8) = 250 + 3 × 15 × 0.333 = 265 ms
- A sustained increase of 10 ms (from 250 to 260) is detected in ~6 observations by EWMA vs ~40 observations by a Shewhart chart.

## Task

Open `exercise.py`. Implement both EWMA and CUSUM charts for a simulated process. Inject a small shift at observation 50 (mean shifts from 100 to 103). Compare how quickly each chart detects the shift. Plot both charts.

Run the check when done:
`npm run check -- bdat-614 module-06 lesson-02`

## Check

```
npm run check -- bdat-614 module-06 lesson-02
```

## Reflection

A traditional Shewhart I-Chart and an EWMA chart are both monitoring a server response time metric. A small but sustained 5ms increase occurs at hour 100. The Shewhart chart does not trigger for 35 hours; the EWMA chart triggers at hour 108. What are the practical consequences of this 27-hour difference in a production system? Is the EWMA chart always better, or are there situations where the Shewhart chart is preferred?
