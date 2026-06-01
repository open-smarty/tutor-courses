# Task: Module 2, Lesson 2 — optim() on a Custom Loss

## Objective

Apply `optim()` to a loss function of your own design and compare it with RMSE.

## Instructions

1. Define a new loss function called `measure_huber()` that implements the Huber loss with threshold $k = 1.345$:

$$\text{loss}(r_i) = \begin{cases} r_i^2 / 2 & \text{if } |r_i| \leq k \\ k \cdot |r_i| - k^2/2 & \text{if } |r_i| > k \end{cases}$$

   The total Huber loss is the mean of `loss(r_i)` over all observations.

2. Use `optim()` to minimise the Huber loss on `sim1`. Report the optimal intercept and slope.

3. Inject two outliers into `sim1` (add 15 to the y values at rows 3 and 17). Refit using:
   - RMSE via `optim()`
   - Huber loss via `optim()`

4. Plot the three fitted lines (original RMSE, outlier RMSE, outlier Huber) on the scatter plot with outliers highlighted as star shapes.

5. Which line stays closest to the non-outlier data? Explain why in 2–3 sentences.

## Submission

Submit the knitted HTML. The plot must show all three lines with a legend.
