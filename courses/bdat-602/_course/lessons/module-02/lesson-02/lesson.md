# Lesson 2: Outlier Detection and Treatment

## Goal

Distinguish three types of outliers, detect them using box plots, the IQR rule, and Z-scores, and apply the appropriate treatment — removal, winsorisation, or log transformation — for each scenario.

## Concept

### Types of Outliers

| Type | Definition | Example |
|------|-----------|---------|
| **Global** | Extreme relative to the whole dataset | BMI = 200 (data entry error) |
| **Contextual** | Extreme only within a context | £50k claim on a Bronze plan |
| **Collective** | A group that is anomalous together | Weekend claims from the same agent |

Outliers can be:
- **Errors** (wrong data) — remove or correct
- **Genuine extremes** (valid but rare) — winsorise to reduce leverage
- **Signals** (fraud, anomaly) — flag and retain; they are the target

---

### Visual Detection — Box Plots

The box plot whiskers extend to $Q_1 - 1.5 \times \text{IQR}$ and $Q_3 + 1.5 \times \text{IQR}$. Points beyond the whiskers are flagged.

```r
library(ggplot2)

ggplot(health_small, aes(y = bmi)) +
  geom_boxplot(fill = "steelblue", outlier.colour = "red",
               outlier.alpha = 0.4) +
  labs(title = "BMI Distribution with Outliers", y = "BMI") +
  theme_minimal()
```

---

### Statistical Detection — IQR Rule

Values below $Q_1 - 1.5 \times \text{IQR}$ or above $Q_3 + 1.5 \times \text{IQR}$ are flagged:

```r
library(dplyr)

q1  <- quantile(health_small$bmi, 0.25, na.rm = TRUE)
q3  <- quantile(health_small$bmi, 0.75, na.rm = TRUE)
iqr <- q3 - q1

health_small |>
  mutate(bmi_outlier = bmi < (q1 - 1.5 * iqr) | bmi > (q3 + 1.5 * iqr)) |>
  count(bmi_outlier)
```

---

### Statistical Detection — Z-Score

$|z_i| = \left|\frac{x_i - \bar{x}}{s}\right| > 3$ assumes approximate normality. Use on roughly symmetric variables:

```r
health_small |>
  mutate(
    income_z       = (income - mean(income, na.rm = TRUE)) /
                      sd(income, na.rm = TRUE),
    income_outlier = abs(income_z) > 3
  ) |>
  count(income_outlier)
```

---

### Treatment Strategies

| Treatment | When to use | Code |
|-----------|------------|------|
| **Remove** | Clear data-entry error | `filter(!bmi_outlier)` |
| **Winsorise** (cap) | Genuine extreme; want to retain the record | `pmax(lo, pmin(hi, x))` |
| **Flag + retain** | Outlier is the signal (fraud) | add `is_outlier` column |
| **Log-transform** | Right-skewed; all values valid | `log1p(x)` |

#### Winsorisation

```r
p01 <- quantile(health_small$income, 0.01, na.rm = TRUE)
p99 <- quantile(health_small$income, 0.99, na.rm = TRUE)

health_small |>
  mutate(
    bmi    = pmax(10, pmin(60, bmi)),         # biologically plausible range
    income = pmax(p01, pmin(p99, income))     # 1st–99th percentile cap
  ) |>
  select(bmi, income) |>
  summary()
```

#### Log Transformation

Right-skewed variables (income, claim amount) compress poorly with standardisation. $\log(1 + x)$ makes the distribution more symmetric:

```r
par(mfrow = c(1, 2))
hist(health_small$income,        main = "Income (raw)",    col = "steelblue")
hist(log1p(health_small$income), main = "Income (log1p)", col = "darkorange")
par(mfrow = c(1, 1))
```

---

### When to Investigate Before Acting

Not every extreme value is an error. In fraud detection, the outliers *are* the signal. Never remove a variable flagged as `fraud_flag = 1` just because its claim amount is extreme — that extreme value is why it is fraudulent.

## Example

```r
# Inject extreme BMI outliers (as done in the simulation)
# bmi = 5, 150, 200 are biologically implausible → remove or winsorise
# claim_amount = $200,000 on a Platinum plan → possibly genuine → flag, retain

health_small |>
  filter(bmi > 60 | bmi < 12) |>
  select(bmi, age, plan_tier, claim_amount, fraud_flag)
```

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Flag BMI outliers using the IQR rule. Count how many are flagged.
2. Winsorise `income` to the 1st–99th percentile range. Compare `summary()` before and after.
3. Create a side-by-side histogram of `claim_amount` raw versus `log1p(claim_amount)` for records where `claim_amount > 0`.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-02 lesson-02
```

## Reflection

A colleague argues: "Any BMI value above 50 is an outlier and should be removed." Explain why this is too broad a rule. What additional information would you want before deciding whether to remove, winsorise, or retain a record with BMI = 52?
