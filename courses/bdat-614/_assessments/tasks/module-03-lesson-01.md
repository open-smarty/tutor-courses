# Task: Process Capability Analysis — Cp and Cpk

## Objective

Quantify the capability of a pharmaceutical fill process under two conditions — perfectly centred and off-centre — and communicate the diagnostic difference between Cp and Cpk.

## Instructions

1. Open `exercise.py` in the `module-03/lesson-01/` directory.
2. Generate 200 fill-weight observations for Scenario A (mu = 500, sigma = 0.9) using `rng.normal(mu_A, sigma_A, 200)` with `rng = np.random.default_rng(seed=7)`. Specification limits are LSL = 496 g, USL = 504 g.
3. Compute Cp for Scenario A using the formula Cp = (USL - LSL) / (6 * sigma). Print the result.
4. Compute Cpk for Scenario A: calculate CPU = (USL - mu) / (3 * sigma) and CPL = (mu - LSL) / (3 * sigma), then Cpk = min(CPU, CPL). Print the result.
5. Generate 200 observations for Scenario B (mu = 501, sigma = 0.9). Compute Cp and Cpk. Notice that Cp stays the same while Cpk falls.
6. Print a formatted summary table showing Cp and Cpk for both scenarios side by side.
7. Using `scipy.stats.norm.cdf`, compute the expected fraction nonconforming for each scenario. Print as a percentage.
8. Build a two-panel figure (1 row, 2 columns):
   - Histogram of fill weights (bins=25, density=True) with a fitted normal curve overlaid.
   - Red dashed vertical lines at LSL and USL.
   - Blue dotted vertical line at the process mean mu.
   - A text box in the upper-left of each panel displaying Cp and Cpk.
   - Meaningful title, x-label ("Fill Weight (g)"), y-label ("Density"), and legend for each panel.
9. In comments, answer: if a process has Cp = 1.8 but Cpk = 0.6, which single corrective action is most valuable?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing Cp, Cpk, and % nonconforming for both scenarios.
- Two-panel capability chart (saved or displayed) with annotations.
