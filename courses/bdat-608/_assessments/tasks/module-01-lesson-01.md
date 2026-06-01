# Task: Module 1, Lesson 1 — Identifying Signal and Noise

## Objective

Distinguish signal from noise in a real dataset, and describe the modelling cycle step that would come next.

## Instructions

1. Run the following code in R:

```r
library(modelr)
library(ggplot2)
data("sim1")

ggplot(sim1, aes(x, y)) +
  geom_point(size = 3, colour = "#1B3A6B") +
  geom_smooth(method = "lm", se = FALSE, colour = "#C9A84C", linewidth = 1.2) +
  theme_minimal() +
  labs(title = "sim1 with a linear trend line")
```

2. Answer the following questions **in 2–4 sentences each**:

   a. Looking at the plot, describe what you think the signal (systematic trend) is. What shape is it?

   b. The gold line is a fitted model. Point to a specific observation that has a **large positive residual** (the actual y is well above the line). What does this residual tell you about that observation?

   c. At step 3 of the modelling cycle (after fitting the model), what would you do next, and what would you be looking for?

## Submission

Copy your three answers into a comment block in your `exercise.Rmd` and re-knit.
