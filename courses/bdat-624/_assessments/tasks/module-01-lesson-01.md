# Task: Classifying and Simulating Stochastic Processes

## Objective

Apply the four-way classification of stochastic processes to real biological examples, build a Markov chain in R using the `markovchain` package, simulate a trajectory, and interpret the results in biological terms.

## Instructions

1. **Classification exercise.** For each of the four processes in Part 1 of `exercise.R`, write clear comments identifying: (a) the index set T and whether it is discrete or continuous, (b) the state space S and whether it is discrete or continuous, and (c) the type (DT-DS, DT-CS, CT-DS, or CT-CS). Include one sentence justifying your classification.

2. **Build the transition matrix.** Fill in the `trans_matrix` in Part 2 using the stated probabilities. Verify that every row sums to exactly 1 by running `rowSums(trans_matrix)`. If any row does not sum to 1, adjust your entries.

3. **Create and inspect the chain.** Construct the `markovchain` object and print its summary. Note: the output should display the states and the transition matrix.

4. **Simulate and plot.** Run the 100-step simulation starting from state "H". Create a `ggplot2` figure that clearly shows the trajectory over time. Your plot must include a title, axis labels, and a colour legend distinguishing the three states.

5. **Interpret proportions.** In Part 5, compute the empirical proportion of time the simulated chain spends in each state. Write a one-sentence comment interpreting the proportion in state "S" (Sick): is it large or small, and why does that make clinical sense given the transition probabilities?

## Submission

Submit your completed `exercise.R` file. Your solution must:
- Contain no `NA` values in the transition matrix
- Produce a plot that renders without error
- Include interpretive comments for Parts 1 and 5
- Pass `npm run check -- bdat-624 module-01 lesson-01`
