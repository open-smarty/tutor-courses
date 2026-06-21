# Lesson 2: Big Data Applications in SQC — EWMA, CUSUM, and ML Integration

## Goal

Derive and implement the EWMA and CUSUM control charts from first principles, understand why they detect small process shifts faster than the Xbar chart, and explore how machine learning augments SPC in Big Data environments.

## Concept

**Why go beyond the Xbar chart?**

The Shewhart Xbar chart uses only the most recent observation to detect process shifts. It is powerful for detecting large shifts (≥ 3σ) but slow to detect small sustained shifts (< 1.5σ). Two memory-based charts address this:

1. **EWMA** — gives exponentially declining weight to older observations.
2. **CUSUM** — accumulates deviations from a reference value, detecting any sustained directional drift.

**Exponentially Weighted Moving Average (EWMA) Chart**

The EWMA statistic at time t is:

$$z_t = \lambda \cdot x_t + (1 - \lambda) \cdot z_{t-1}$$

where:
- xₜ = individual measurement at time t (or subgroup mean)
- λ ∈ (0, 1] = smoothing parameter (typically 0.1 ≤ λ ≤ 0.3)
- z₀ = μ₀ (target process mean, used as starting value)

A small λ (e.g. 0.1) gives heavy weight to history — effective for detecting very small shifts but slow to respond to sudden jumps. A large λ (e.g. 0.4) behaves more like the Shewhart chart.

**EWMA control limits:**

$$\text{UCL}_t = \mu_0 + L \sigma \sqrt{\frac{\lambda}{2 - \lambda}\left(1 - (1-\lambda)^{2t}\right)}$$

$$\text{LCL}_t = \mu_0 - L \sigma \sqrt{\frac{\lambda}{2 - \lambda}\left(1 - (1-\lambda)^{2t}\right)}$$

where L = 3 (3-sigma limits) and σ is the known process standard deviation. As t → ∞, the limits converge to:

$$\text{UCL} = \mu_0 + L\sigma\sqrt{\frac{\lambda}{2-\lambda}}, \quad \text{LCL} = \mu_0 - L\sigma\sqrt{\frac{\lambda}{2-\lambda}}$$

The EWMA chart is particularly useful when individual observations are autocorrelated or when small shifts (0.5σ to 1.5σ) must be detected quickly.

**CUSUM Chart — Tabular Form**

The CUSUM accumulates evidence of a process shift away from the target μ₀. The two one-sided statistics are:

$$C_t^+ = \max(0,\ x_t - (\mu_0 + K) + C_{t-1}^+)$$
$$C_t^- = \max(0,\ (\mu_0 - K) - x_t + C_{t-1}^-)$$

where:
- K = allowance (reference value) = Δ/2, with Δ = smallest shift to detect (in σ units)
  Typically K = 0.5σ to detect a 1σ shift.
- C₀⁺ = C₀⁻ = 0 (both start at zero)

**Decision rule:** signal out-of-control when Cₜ⁺ > H or Cₜ⁻ > H, where H = 5σ is the standard decision interval.

The CUSUM chart accumulates evidence over many time periods. A process that shifts by +0.5σ will produce Cₜ⁺ values that grow steadily, crossing H in roughly 8–10 periods. The same shift would take the Xbar chart over 100 periods to detect (on average).

**Average Run Length (ARL)**

ARL is the expected number of observations until a chart signals:
- ARL₀ = in-control ARL (false alarm rate: larger is better; Xbar 3σ has ARL₀ ≈ 370)
- ARL₁ = out-of-control ARL for a given shift (smaller is better)

For a 1σ shift:
| Chart | ARL₁ |
|---|---|
| Xbar (3σ) | ~43.9 |
| EWMA (λ=0.1) | ~10.3 |
| CUSUM (K=0.5, H=5) | ~8.4 |

EWMA and CUSUM are roughly 4–5× faster than Xbar at detecting a 1σ shift.

**Big Data and Machine Learning in SPC**

Modern manufacturing generates sensor data at MHz frequencies — far beyond what traditional SPC charts can manually monitor. ML integration addresses several challenges:

| Challenge | ML Approach |
|---|---|
| Detecting complex multivariate out-of-control states | Isolation Forest, One-class SVM for anomaly detection |
| Classifying the type of special cause (assignable cause) | Random Forest, neural network classifier on pattern features |
| Monitoring hundreds of variables simultaneously | Principal Component Analysis (PCA) + Hotelling T² on principal components |
| Adaptive control limits on non-stationary processes | LSTM or online learning for dynamic baseline estimation |
| Streaming real-time SPC on IoT data | Kafka + Spark Streaming pipelines feeding EWMA/CUSUM detectors |

The key principle: **ML augments but does not replace SPC**. EWMA and CUSUM provide interpretable, statistically grounded signals. ML classification then explains which fault mode caused the signal — enabling faster root cause identification.

## Example

A semiconductor fab monitors wafer thickness (target μ₀ = 200 nm, σ = 2 nm). The process runs in control for 50 wafers, then a coating tool drifts, adding +1.2 nm per wafer (a 0.6σ/observation shift). The table below shows detection times (observations until first signal):

| Chart | Detection time |
|---|---|
| Xbar (3σ) | 38 observations |
| EWMA (λ=0.15, L=3) | 14 observations |
| CUSUM (K=σ, H=5σ) | 11 observations |

By the time the Xbar chart detects the drift, 38 wafers may need rework or scrapping. The CUSUM chart signals after only 11 — potentially saving 27 wafers at £1,200 each = £32,400 per event.

## Task

In `exercise.py`:

1. Generate 200 in-control observations (μ=10, σ=1) then inject a +1.5σ shift at observation 101 (add 1.5 to observations 101–200).
2. Implement the EWMA chart (λ=0.2, L=3, μ₀=10, σ=1) from scratch. Compute z_t for t = 1…200 and the time-varying UCL and LCL.
3. Implement the tabular CUSUM (K = 0.5σ, H = 5σ) from scratch. Compute C⁺ and C⁻ for t = 1…200.
4. Plot three subplots: (a) Xbar/individuals chart, (b) EWMA chart, (c) CUSUM chart. Mark out-of-control points in red, draw UCL/LCL, and mark the true shift point with a vertical dashed line.
5. Report the detection time (first signal observation) for each chart. Print an ARL comparison table.

## Check

```
npm run check -- bdat-614 module-06 lesson-02
```

## Reflection

The EWMA smoothing parameter λ controls a fundamental bias-variance trade-off. A small λ (e.g. 0.05) is very sensitive to small sustained shifts but slow to recover after a large sudden shift. A large λ (e.g. 0.5) behaves almost like the Shewhart chart. Given a high-volume IoT manufacturing environment where both gradual drift and sudden jumps occur, what strategy would you use to set λ, and how might a Big Data pipeline allow you to adapt λ dynamically?
