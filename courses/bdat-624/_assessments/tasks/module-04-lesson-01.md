# Task: The Pure Birth Process — Yule Model

## Scenario

A tumour is discovered when it contains j = 10 cells. Each cell divides (gives birth to a new cell) at rate λ = 0.3 per day, and no cell death occurs (pure birth). You will use the Yule model to analyse how this tumour evolves.

---

## Part (a) — Expected tumour size at day 7

Use the formula E[X(t) | X(0) = j] = je^{λt}.

Show your calculation. What is the expected number of tumour cells at day 7?

---

## Part (b) — Probability of exactly 15 cells at day 7

The exact distribution is negative binomial: X(7) | X(0) = 10 ~ NegBin(j = 10, p = e^{−λ × 7}).

1. Compute p = e^{−0.3 × 7}. What is p?
2. Apply the formula:

$$P(X(7) = 15) = \binom{14}{9} p^{10}(1-p)^{5}$$

Show the calculation step by step. You may use R to evaluate the binomial coefficient.

---

## Part (c) — Simulation of 500 tumour trajectories

In R, simulate 500 independent Yule process trajectories with j = 10 cells, λ = 0.3, for t = 0 to 10 days. Use the exact next-event algorithm (draw Exp(nλ) waiting times).

Produce the following plot:
- Grey step-function lines for all 500 trajectories (low alpha).
- Red line: the empirical mean trajectory.
- Blue dashed line: the theoretical E[X(t)] = 10e^{0.3t}.
- Green dotted lines: empirical 2.5th and 97.5th percentiles at each time point (this is the 95% simulation interval).

At day 10, count and report:
- The fraction of simulated tumours with more than 500 cells.
- The theoretical expected size at day 10 (j·e^{λ × 10}).

---

## Part (d) — Biological reflection

The pure birth process assumes no cell death. For most solid tumours, this is unrealistic.

Answer in 3–5 sentences:

1. What biological phenomenon does the "no death" assumption ignore?
2. What modification to the Yule model would you introduce to make it more realistic? Write down the modified birth rate and add a death rate term. What type of process does it become?
3. If you were fitting this model to real tumour growth data from imaging studies, what would you need to estimate from the data?

---

## Submission

Submit your R code (as a `.R` file) and your written answers for parts (a), (b), and (d) in a short document. Make sure your simulation plots are saved or displayed.
