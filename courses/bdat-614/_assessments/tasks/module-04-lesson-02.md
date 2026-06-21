# Task: DMAIC Root Cause Analysis — Pareto Chart, 5 Whys, and Fishbone Diagram

## Objective

Apply three core DMAIC Analyse-phase tools — the Pareto chart, 5 Whys, and Ishikawa (fishbone) diagram — to a beverage bottling line defect dataset, implementing all three visualisations in Python without external quality libraries.

## Instructions

1. Open `exercise.py` in the `module-04/lesson-02/` directory.
2. Use the provided `defect_data` dictionary (6 defect categories, n = 1,200 total defects). Sort by count descending and compute cumulative percentages.
3. Print a formatted Pareto table with columns: Rank | Defect Type | Count | % of Total | Cumulative %.
4. Build a Pareto chart (figure size 10 × 6):
   - Left y-axis: steelblue bar chart of counts. Label each bar with its count.
   - Right y-axis: darkorange cumulative percentage line (circles, linewidth=2).
   - Red dashed horizontal line at 80% on the right axis.
   - Grey dashed vertical separator between the vital few and trivial many categories.
   - Proper axis labels, title "Pareto Chart — Bottling Line Defects (n = 1,200)", and combined legend.
   - Save as `module-04-lesson-02-pareto.png`.
5. Implement the 5 Whys causal chain for underfill defects as an ordered list of tuples (why_number, question, answer). Print the full chain with clear arrows indicating the causal flow. State the root cause explicitly at the end.
6. Draw a fishbone diagram (figure size 13 × 7) using only matplotlib:
   - A horizontal spine with an arrowhead pointing to a problem box ("Underfill Defects").
   - Four main bones: Machine, Method, Material, Man — two above the spine and two below.
   - At least two sub-causes per bone as labelled text branches.
   - Turn off axes. Save as `module-04-lesson-02-fishbone.png`.
7. In comments, explain: why does a fishbone diagram precede, not replace, the Pareto chart in the Analyse phase?

## Submission

- Completed `exercise.py` with all tasks implemented.
- Console output showing the Pareto table and the 5 Whys chain.
- Two figures: `module-04-lesson-02-pareto.png` and `module-04-lesson-02-fishbone.png`.
