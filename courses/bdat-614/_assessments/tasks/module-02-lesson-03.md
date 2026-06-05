# Task: Attribute Control Charts — p, np, c, and u Charts

## Objective

Build and interpret both a p chart and a u chart from a simulated ETL pipeline dataset, demonstrating that you can select the right chart, compute variable control limits, and identify out-of-control batches.

## Instructions

1. **Set up your data.** Generate 20 batches with variable sizes uniformly distributed between 350 and 600 records. Use `np.random.default_rng(seed=42)` so results are reproducible.

2. **p Chart.**
   - Assume a true proportion defective of 4%. Generate defective-item counts using the Binomial distribution.
   - Compute p-bar from the pooled data.
   - Compute per-subgroup UCL_i and LCL_i. Clip any negative LCL to 0.
   - Plot the p chart with:
     - A line connecting p_i values (with markers)
     - A dashed green CL line
     - Dashed red stepped UCL/LCL lines (they change across batches because n_i varies)
     - Out-of-control points highlighted in red

3. **u Chart.**
   - Assume a true defect rate of 1.8 defects per 100 records (u_true = 0.018). Generate defect counts using the Poisson distribution.
   - Compute u-bar from the pooled data.
   - Compute per-subgroup UCL_i and LCL_i. Clip negatives to 0.
   - Plot the u chart following the same conventions as above.

4. **Interpretation.** Add a brief print statement (or comments) explaining:
   - Why the control limits step up/down across batches
   - Which batches, if any, are out of control and what that would mean in the ETL context

## Submission

Submit your completed `exercise.py` file. The file must run without errors and produce both charts when executed.
