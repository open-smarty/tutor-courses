# Task: Transition Probability Matrices and n-Step Forecasting

## Objective

Build a valid Transition Probability Matrix from clinical transition data, compute matrix powers to make multi-step probability forecasts, and visualise how a cohort's state distribution evolves over time.

## Instructions

1. **Construct the TPM.** Fill in the `P` matrix in Task 1 using the stated clinical probabilities for Mild, Moderate, and Severe states. Run `rowSums(P)` to confirm all rows sum to 1. Add a comment identifying which state has the highest self-transition probability and why this makes clinical sense.

2. **Compute matrix powers.** Use the `mat_power()` helper function (already provided) to compute P^5 and P^10. Print both, rounded to 4 decimal places. In a comment, note whether the rows of P^10 appear to be converging to a common vector. This common vector is the stationary distribution, which you will compute formally in Module 2.

3. **Track the cohort.** Starting from π₀ = (0.60, 0.30, 0.10), compute the probability distribution over states at weeks 1, 5, 10, and 20. Print the results as a table using `round(..., 4)`.

4. **Visualise.** Create a `ggplot2` line plot showing the probability of each state (Mild, Moderate, Severe) over weeks 0, 1, 2, 3, 5, 7, 10, 15, 20. Use different colours for each state. The plot must have a title, axis labels, and a colour legend.

5. **Verify and interpret.** Confirm that the rows of P^10 still sum to 1. Write a one-sentence comment explaining what the first row of P^10 (row "M") tells you about a patient who is currently in the Mild state — what does each entry represent biologically?

## Submission

Submit your completed `exercise.R`. Requirements:
- No `NA` values in the TPM
- All `rowSums` equal 1 (verified in output)
- A rendered ggplot2 figure
- Interpretive comments for Tasks 1 and 5
- Pass `npm run check -- bdat-624 module-01 lesson-02`
