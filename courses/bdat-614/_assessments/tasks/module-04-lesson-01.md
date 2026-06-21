# Task: PDCA Cycle Simulation — Tracking Improvement Over Time

## Objective

Simulate eight successive PDCA improvement cycles for a tablet manufacturing defect rate and produce charts that clearly communicate the diminishing-returns pattern of continuous improvement.

## Instructions

1. Open `exercise.py` in the `module-04/lesson-01/` directory.
2. Set `np.random.seed(614)`. Baseline defect rate: 12.0%. Target: 2.0%. Run 8 cycles.
3. Use the expected per-cycle reductions `[3.5, 2.8, 2.0, 1.5, 1.0, 0.8, 0.5, 0.4]` (percentage points). For each cycle add Gaussian noise with std = 0.3 pp. Clamp the defect rate to >= 0.
4. Build a `defect_rates` array of length 9 (index 0 = baseline, 1–8 = after each cycle). Build a `cumulative_improvement` array of the same length.
5. Find `first_target_cycle` — the first cycle index at which defect_rates <= 2.0%. Use `np.where`.
6. Print a formatted summary table with columns: Cycle | Defect Rate (%) | Change (pp) | Cumulative Reduction (pp).
7. Build a two-panel figure (14 × 6 inches):
   - **Panel A (Defect Rate):** Line chart of defect_rates vs cycle_numbers (steelblue, circle markers). Red dashed line at TARGET = 2.0%. Annotate each point with its rate value. Mark `first_target_cycle` with a green star and annotation "Target met (Cycle N)". Label x-axis ticks as "Baseline", "Cycle 1", …, "Cycle 8". Grid on.
   - **Panel B (Cumulative Improvement):** Bar chart of cumulative_improvement for cycles 1–8. Use a YlGn colourmap scaled to the fraction of maximum possible improvement (10 pp). Add a red dashed line at 10 pp (maximum possible). Label each bar "+X.X pp". Grid on y-axis only.
8. Save the figure as `module-04-lesson-01-pdca.png`. In comments, answer: why does the improvement per cycle decrease, and what does this imply for the long-term improvement strategy?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the summary table and which cycle meets the target.
- Two-panel PDCA figure saved as `module-04-lesson-01-pdca.png`.
