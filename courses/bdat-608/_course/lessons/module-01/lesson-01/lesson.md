# Lesson 1: What Is a Statistical Model?

## Goal

Explain what a statistical model is by decomposing observed data into signal (the systematic pattern) and noise (random variation), and describe the two key objects: the model family and the fitted model.

## Concept

A statistical model is a mathematical device for separating what we can explain from what we cannot.

Every observation $y$ is written as:

$$y = \underbrace{f(x)}_{\text{signal}} + \underbrace{\varepsilon}_{\text{noise}}$$

- **Signal** $f(x)$ is the structural relationship between the predictor $x$ and the response $y$. It is what we want to learn.
- **Noise** $\varepsilon$ is random variation — measurement error, unobserved factors, pure chance. No model can explain this.

### Two distinct objects

| Object | What it is | Example |
|--------|-----------|---------|
| **Model family** | The *shape* of the equation; all possible versions | All straight lines: $y = a_1 + a_2 x$ |
| **Fitted model** | The *specific member* of the family closest to the data | $\hat{y} = 4.22 + 2.05\,x$ |

Choosing a model family is an **assumption** about how the world works. You cannot verify the assumption from the data alone — you can only check whether it is reasonable by inspecting the residuals (what the model missed).

### The modelling cycle

Statistical modelling is iterative, not linear:

```
Observe Data → Choose Model Family → Fit Model → Generate Predictions
      ↑                                                      ↓
 Revise Model ← Inspect Residuals ←────────────────────────┘
```

This cycle repeats until the residuals look like random noise — meaning the model has captured all available systematic variation.

> "All models are wrong, but some are useful." — George E. P. Box

The question is never *Is the model true?* but *Is the model adequate for this purpose?*

## Example

Consider the `sim1` dataset from the `modelr` package. It has 30 rows with two columns: `x` (a predictor) and `y` (a response).

```r
library(modelr)
data("sim1")
glimpse(sim1)
# $ x <int> 1 1 1 2 2 2 3 3 3 ... (each x-value repeated 3 times)
# $ y <dbl> 4.20 7.51 2.13 8.99 ...
```

Plotting `sim1` reveals a clear **linear** trend with random scatter around it:

```r
library(ggplot2)
ggplot(sim1, aes(x, y)) +
  geom_point(size = 3, colour = "#1B3A6B") +
  labs(title = "sim1: Response vs Predictor") +
  theme_minimal()
```

The model family we choose is: $y = a_1 + a_2 x + \varepsilon$ (a straight line).

The fitted model — found by minimising a loss function, as we will learn in Module 2 — turns out to be approximately $\hat{y} = 4.22 + 2.05\,x$.

The **residuals** (observed minus fitted) are what the straight line could not explain. Plotting them reveals whether any systematic pattern remains.

## Task

Open `exercise.Rmd` and complete the two marked chunks:

1. Load `sim1` from `modelr` and call `glimpse()` on it. Report: how many rows? How many columns?
2. Create a scatter plot of `y` versus `x` using `ggplot2`. Add a title "sim1: My first look".

Knit the document when done. All chunks must run without errors.

## Check

```
npm run check -- bdat-608 module-01 lesson-01
```

## Reflection

A classmate says: "We just need to find the equation that fits the data perfectly — zero residuals." What is wrong with this goal, and what does it tell us about the difference between fitting training data and predicting new observations?
