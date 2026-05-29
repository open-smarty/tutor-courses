# Task: Module 6, Lesson 2 — Real-Time Quality Monitoring System Design

## Objective

Design and implement a complete real-time quality monitoring system using EWMA, CUSUM, and basic anomaly detection.

## Scenario

You are a data engineer at a cloud services company. The API gateway logs response times (ms) for thousands of requests per second. Management wants a quality monitoring system that:
1. Detects a sustained increase of 20ms in average response time within 10 observations.
2. Alerts immediately when a single observation exceeds 3σ (Shewhart rule).
3. Flags multivariate anomalies using a simple Z-score based approach.

Historical baseline: μ₀ = 200 ms, σ = 15 ms.

## Instructions

In a Python file `task_realtime_monitoring.py`:

1. **Simulate data:** Generate 200 observations from N(200, 15²). At observation 120, inject a sustained shift to N(220, 15²). At observation 160, inject a single spike to 280 ms.

2. **Shewhart I-Chart:** Apply 3σ rule and detect the spike at observation 160.

3. **EWMA Chart (λ = 0.15):** Detect the sustained shift at obs 120. Report which observation first signals.

4. **CUSUM Chart (K = 10, H = 50):** Detect the sustained shift at obs 120. Report which observation first signals.

5. **Comparison table:** Print a summary showing which observation each chart first signalled and how many observations after the shift was injected.

6. **Plot:** Three subplots (Shewhart, EWMA, CUSUM) on one figure with the shift injection points marked.

## Criteria

- All three charts implemented correctly: 45%
- Detection times correctly identified and printed: 25%
- Comparison table printed clearly: 15%
- All three charts plotted with shift points marked: 15%
