# Lesson 1: Generalised Linear Models — Logistic and Poisson Regression

## Goal

Explain the GLM structure via the link function and exponential family, fit logistic and Poisson regression in R, and interpret exponentiated coefficients as odds ratios and rate ratios.

## Concept

**Why ordinary linear regression fails for binary and count responses.** OLS can predict values outside the valid range: probabilities must lie in $[0,1]$ and counts must be non-negative integers. OLS imposes neither constraint. A GLM fixes this by applying a **link function** that transforms the mean $\mu = E[y]$ to the unrestricted linear predictor $\eta = \mathbf{x}^\top\boldsymbol{\beta}$.

**The GLM structure.** Three components:

1. **Random component**: the distribution of $y$ (binomial for binary, Poisson for counts, normal for OLS).
2. **Systematic component**: the linear predictor $\eta = \beta_0 + \beta_1 x_1 + \cdots$.
3. **Link function**: $g(\mu) = \eta$, connecting the mean to the linear predictor.

**Logistic regression.** For a binary response $y \in \{0,1\}$, the mean is the probability $\mu = P(Y=1) \in (0,1)$. The logit link is:

$$g(\mu) = \log\!\left(\frac{\mu}{1-\mu}\right) = \eta = \mathbf{x}^\top\boldsymbol{\beta}$$

Inverting: $\mu = P(Y=1) = \frac{e^\eta}{1+e^\eta} = \frac{1}{1+e^{-\eta}}$. This is the logistic (sigmoid) function — always in $(0,1)$.

**Interpreting coefficients.** The **odds** of the event is $\text{odds} = \mu/(1-\mu)$. The log-odds (logit) is the linear predictor $\eta$. Exponentiating: $e^{\beta_j}$ is the **odds ratio (OR)** — each unit increase in $x_j$ multiplies the odds of the event by $e^{\beta_j}$. OR $> 1$: $x_j$ increases the odds; OR $< 1$: $x_j$ decreases them.

In R: `glm(y ~ x, family = binomial(link = "logit"))`.

**Deviance.** Instead of RSS, GLMs use the **deviance** $D = -2\log\hat{L}$, which measures lack of fit on the log-likelihood scale. AIC = $D + 2k$ where $k$ is the number of parameters. Residual deviance tests goodness of fit relative to the saturated model (one parameter per observation).

**Poisson regression.** For count responses $y \in \{0, 1, 2, \ldots\}$, the Poisson distribution with $\mu = \lambda > 0$ is standard. The log link is:

$$g(\mu) = \log(\mu) = \eta \implies \mu = e^\eta$$

Exponentiated coefficient $e^{\beta_j}$: each unit increase in $x_j$ multiplies the expected count by $e^{\beta_j}$ — this is the **rate ratio (RR)**.

In R: `glm(y ~ x, family = poisson(link = "log"))`.

## Example

We use `nycflights13::flights` and create a binary outcome: was the departure delay more than 30 minutes?

```r
library(nycflights13)
library(tidyverse)

flights_clean <- flights |>
  filter(!is.na(dep_delay)) |>
  mutate(
    long_delay = as.integer(dep_delay > 30),
    hour       = as.numeric(hour),
    month      = as.numeric(month)
  )
```

**Fit logistic regression:**

```r
mod_logit <- glm(
  long_delay ~ hour + month + origin,
  data   = flights_clean,
  family = binomial(link = "logit")
)
summary(mod_logit)
```

**Extract and interpret odds ratios:**

```r
exp(coef(mod_logit))
# hour: exp(0.08) ≈ 1.083 — each additional hour of the day multiplies
# the odds of a long delay by 1.08 (8% increase). Delays compound as
# the day progresses.
```

**Predict probability for a specific flight:** A flight departing at 18:00 in December from EWR:

$$\hat{\eta} = \hat{\beta}_0 + 0.08 \times 18 + \hat{\beta}_{\text{Dec}} + \hat{\beta}_{\text{EWR}}$$

$$\hat{P}(\text{long delay}) = \frac{1}{1+e^{-\hat{\eta}}}$$

Numerically, suppose $\hat{\eta} = -0.5$: $\hat{P} = 1/(1+e^{0.5}) \approx 0.38$ — about a 38% chance of a delay exceeding 30 minutes.

**Poisson example.** Predict the number of flights delayed by carrier:

```r
delay_counts <- flights_clean |>
  group_by(carrier, month) |>
  summarise(n_long = sum(long_delay), n_total = n(), .groups = "drop")

mod_pois <- glm(n_long ~ carrier + month + offset(log(n_total)),
                data = delay_counts, family = poisson())
```

The `offset(log(n_total))` adjusts for the number of flights — we model the rate (delays per flight) rather than the raw count.

## Task

Open `exercise.Rmd`. Using `flights` from `nycflights13`:

1. Create `long_delay = as.integer(dep_delay > 30)`. Remove rows with `NA` in `dep_delay`.
2. Fit `glm(long_delay ~ hour + month, family = binomial())`. Print `summary()`.
3. Exponentiate all coefficients. Interpret the `hour` odds ratio in plain English.
4. Use `add_predictions(type = "response")` on a grid of `hour` (0–23) and `month = 7` (July). Plot the predicted probability vs hour.
5. Compare `AIC(mod_null, mod_logit)` where `mod_null = glm(long_delay ~ 1, ...)`.

## Check

```
npm run check -- bdat-608 module-05 lesson-01
```

## Reflection

The logistic regression coefficient for `hour` gives the change in log-odds per hour. A journalist wants to report the finding as: "flights leaving at 6pm are X times more likely to be delayed than flights leaving at 6am." Is this the odds ratio? Is odds ratio the same as relative risk (probability ratio)? When are they approximately equal, and when do they diverge significantly?
