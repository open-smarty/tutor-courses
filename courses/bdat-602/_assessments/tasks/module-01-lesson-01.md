# Task: Exploratory Data Analysis on the Insurance Dataset

## Objective

Generate the BDAT 602 health insurance dataset, produce a full `skimr` summary, and connect each of the six data mining tasks to a concrete question you could answer using this data.

## Instructions

1. Open `exercise.Rmd` in RStudio and knit it to HTML to confirm it runs without errors.
2. In **Task 1**, call `simulate_bdat602(n = 500000, seed = 602)` and assign the result to `health_data`. Use `glimpse()` to verify the dimensions (500,000 × 40).
3. In **Task 2**, draw a 10-row sample with `slice_sample(n = 10)` and inspect the output.
4. In **Task 3**, run `skim(health_data)` and identify:
   - One finding about a **numeric** variable (mention the variable name, its mean, and whether it is skewed).
   - One finding about a **character** variable (mention the variable name, number of unique values, and most frequent value).
   - One finding about **missingness** (name the variable, state the proportion missing, and suggest why data might be missing).
5. In **Task 4**, complete the `mining_tasks` tibble by writing one sentence per task that is specific to the insurance dataset (do not copy the lesson text verbatim).

## Submission

Knit the completed `exercise.Rmd` to `exercise.html` and submit both the `.Rmd` and `.html` files. Your findings in Tasks 3 and 4 must be written as R comments inside the code chunks, not in separate text cells.
