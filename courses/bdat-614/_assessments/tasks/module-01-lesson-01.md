# Task: Garvin Quality Audit — ETL Pipeline

## Objective

Apply Garvin's 8 dimensions of quality to a real or simulated ETL pipeline and produce a scored audit with a radar chart visualisation.

## Instructions

1. Open `exercise.py` in the `module-01/lesson-01/` directory.
2. Define the `audit` dictionary with the 8 Garvin dimensions as keys and integer scores (1–5) as values. Use the provided scores or substitute your own if you are auditing a real system you have access to.
3. Compute the overall quality score as the arithmetic mean of all 8 dimension scores. Print it to 2 decimal places.
4. Build the radar chart following the step-by-step comments in the exercise file:
   - Extract dimension names and scores.
   - Compute angles using `np.linspace`.
   - Close the polygon.
   - Create a polar subplot.
   - Plot and fill the polygon.
   - Label axes and set the score range to [0, 5].
   - Add a title that includes the overall score.
5. Save or display the chart.
6. Answer in a comment at the bottom of your script: which dimension would you prioritise improving first, and why?

## Submission

- Submit your completed `exercise.py`.
- The radar chart image (saved as PNG) if required by your instructor.
- The overall quality score printed to the console.
