# Task: Module 5, Lesson 1 — Logistic Regression on Real Data

## Objective

Apply logistic regression to a real dataset and interpret results correctly.

## Instructions

The `Default` dataset from the `ISLR2` package contains credit card default information. Install `ISLR2` if needed and load it:

```r
# install.packages("ISLR2")
library(ISLR2)
data("Default")
Default$default_bin <- as.integer(Default$default == "Yes")
```

1. Fit a logistic regression model:
   ```r
   mod_default <- glm(default_bin ~ balance + income + student,
                      data = Default, family = binomial("logit"))
   ```

2. Print `summary(mod_default)` and `exp(coef(mod_default))`.

3. Interpret the coefficient for `balance` in plain language (include odds ratio and direction).

4. Create a prediction plot: P(default) vs `balance`, coloured by `student`.

5. At what balance level does the predicted default probability reach 50% for a non-student with average income? Use `uniroot()` or manual inspection.

6. Write a 3–4 sentence managerial summary of your findings.

## Submission

Submit the knitted HTML with your plots and written interpretation.
