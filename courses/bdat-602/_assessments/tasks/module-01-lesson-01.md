# Task: Mapping the 4 Vs to the Health Insurance Dataset

## Objective

Apply the 4 Vs framework to the course dataset to identify practical data challenges you will face throughout the course.

## Instructions

In your exercise Rmd, add a new code chunk after Task 3. Complete the following:

1. **Volume** — Generate `health_data` with `n = 500000`. Report the object size in memory using `object.size(health_data)`. Express it in MB.

2. **Veracity** — From `health_small` (n = 10000), compute the overall NA rate as a percentage: `sum(is.na(health_small)) / (nrow(health_small) * ncol(health_small)) * 100`. Report and interpret the result.

3. **Variety** — Use `sapply(health_small, class)` to tabulate the variable types. Report how many columns belong to each type (numeric, character, logical, Date).

4. **Written response** — In a markdown comment below your code: which V do you expect to be most costly to address in this project, and why? (2–3 sentences)

## Submission

Knit your Rmd to HTML. The HTML should display all three code outputs and the written response.
