# Task: Four-State Clinical Markov Chain

## Objective

Build a clinically realistic four-state Markov chain in R, verify the absorbing state structure, simulate patient trajectories, and track how the cohort distribution evolves over a 20-week period.

## Instructions

1. **Construct the TPM.** Fill in the transition matrix `P4` using the clinical probabilities from the lesson (H, MI, SI, D states). Run `rowSums(P4)` and verify all rows sum to 1. Explicitly check that the Dead row equals (0, 0, 0, 1) using `P4["D", ]`.

2. **Create the chain object.** Use `new("markovchain", ...)` to build `health_mc4`. Print its summary. Run `is.irreducible(health_mc4)` and write a comment explaining why the result is FALSE (or TRUE if you disagree — justify it).

3. **Simulate two trajectories.** Simulate 100-step trajectories starting from "H" and from "MI". Use `set.seed(2024)` for reproducibility.

4. **Plot the trajectories.** Create a `ggplot2` figure using `facet_wrap(~ start)` to show both trajectories. Use ordered factor levels for states (H < MI < SI < D) so the y-axis is meaningful. Colour each state distinctly.

5. **Track the cohort distribution.** Starting from π₀ = (1, 0, 0, 0) (all Healthy), compute and plot the probability distribution over all four states for weeks 0 to 20. Extract and print P(Dead at week 10 | Healthy at week 0) with a one-sentence interpretation: is this value surprising given the small per-step death probabilities?

## Submission

Submit your completed `exercise.R`. Requirements:
- TPM contains no NA values; all row sums equal 1
- Absorbing state verified in output
- Both trajectory plots rendered
- Cohort distribution plot rendered
- Interpretive comment on the irreducibility result
- Pass `npm run check -- bdat-624 module-02 lesson-01`
