# Lesson 11: Generalised Linear Models — Logistic and Poisson Regression

## Goal

Fit logistic regression for binary responses and Poisson regression for count responses using `glm()`, and correctly interpret exponentiated coefficients as odds ratios and rate ratios.

## Concept

### Why not OLS for binary or count responses?

Ordinary linear regression can predict values outside $[0,1]$ for probabilities and negative values for counts — both physically impossible. **Generalised Linear Models (GLMs)** solve this by introducing a *link function* that maps the linear predictor to a valid range.

### Logistic Regression (binary response)

The response $Y \in \{0,1\}$. The model is:

$$\log\!\left(\frac{p}{1-p}\right) = \beta_0 + \beta_1 x_1 + \cdots$$

where $p = P(Y=1)$. Back-transforming gives $p = e^\eta / (1+e^\eta) \in (0,1)$.

```r
mod_logit <- glm(Y ~ quant + verbal + gpa + toptier,
                 data   = admit,
                 family = binomial(link = "logit"))
```

**Interpreting coefficients:**
- Exponentiate with `exp(coef(mod_logit))` to get **odds ratios**.
- An odds ratio of 1.8 means a one-unit increase in the predictor multiplies the odds of the event by 1.8 (+80%).
- Use `type = "response"` in `add_predictions()` to get probabilities, not log-odds.

### Poisson Regression (count response)

The response $Y \in \{0, 1, 2, \ldots\}$. The model is:

$$\log(\mu) = \beta_0 + \beta_1 x_1 + \cdots$$

```r
mod_pois <- glm(n_claims ~ age + veh_age,
                data   = claims,
                family = poisson(link = "log"))
```

**Interpreting coefficients:**
- Exponentiate to get **rate ratios**.
- A rate ratio of 1.02 means a one-unit increase in the predictor multiplies the expected count by 1.02 (+2%).

### The modelr workflow still applies

```r
add_predictions(mod_logit, type = "response")   # predicted probabilities
add_predictions(mod_pois,  type = "response")   # predicted counts
```

## Example

```r
library(cvAUC)
data("admissions")
admit <- as_tibble(admissions)

mod_logit <- glm(Y ~ quant + verbal + gpa + toptier,
                 data = admit, family = binomial("logit"))

exp(coef(mod_logit))
# toptier: ~7 → attending a top-tier school multiplies admission odds by 7
```

## Task

Open `exercise.Rmd` and complete:

1. Fit `mod_logit` on `admissions`. Print `summary()` and `exp(coef())`.
2. Create a prediction plot: P(admit) vs `verbal`, coloured by `toptier`.
3. Fit `mod_pois` on the simulated `claims` data. Print `exp(coef())`.
4. Create a prediction plot: expected claims vs `age` for `veh_age = 2` and `veh_age = 8`.

## Check

```
npm run check -- bdat-608 module-05 lesson-01
```

## Reflection

A logistic regression coefficient for `gpa` is 0.8. A student says "an extra grade point increases the probability of admission by 0.8." What is wrong with this interpretation, and what is the correct interpretation?
