# Task: EWMA and CUSUM Chart Implementation with Shift Detection

## Objective

Implement the EWMA and tabular CUSUM control charts from scratch in Python, inject a process shift into simulated data, and compare detection speed against the standard Shewhart individuals chart.

## Instructions

1. Open `exercise.py` in the `module-06/lesson-02/` directory.
2. Generate 200 observations: observations 1–100 are in-control (μ=10, σ=1); observations 101–200 have a +1.5σ shift (μ=11.5, σ=1). Use `np.random.seed(614)`.
3. Implement the **EWMA chart** (λ=0.2, L=3):
   - z₀ = μ₀ = 10
   - z_t = λ × x_t + (1−λ) × z_{t-1}
   - Compute time-varying UCL and LCL using the formula in the lesson.
   - Record the first observation index after t=100 where z_t crosses a limit.
4. Implement the **tabular CUSUM chart** (K=0.5σ, H=5σ):
   - C₀⁺ = C₀⁻ = 0
   - C_t⁺ = max(0, x_t − (μ₀ + K) + C_{t-1}⁺)
   - C_t⁻ = max(0, (μ₀ − K) − x_t + C_{t-1}⁻)
   - Record the first observation index after t=100 where C_t⁺ > H or C_t⁻ > H.
5. Compute the standard individuals (Shewhart) chart limits (UCL = μ₀ + 3σ, LCL = μ₀ − 3σ) and record its detection time.
6. Build a **three-panel figure** showing individuals chart, EWMA chart, and CUSUM (C⁺ only) on stacked subplots. For each panel:
   - Draw UCL, CL, and LCL as dashed lines.
   - Mark the shift injection point (obs 101) as a vertical dotted blue line.
   - Mark out-of-control points in red.
   - Mark the first detection point with a vertical orange dash-dot line.
7. Save the figure as `module-06-lesson-02-ewma-cusum.png`.
8. Print a detection speed comparison table: Chart | Detection observation | Observations after shift.

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing detection observations for all three charts.
- The three-panel chart (saved or displayed).
- A comment explaining which chart detected the shift earliest and why that chart is better suited to detecting this type of shift (sustained 1.5σ drift).
