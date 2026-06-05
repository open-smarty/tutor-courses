# Lesson 4: Outlier Detection and Treatment

## Goal

After this lesson you can identify outliers using the IQR rule and Z-score method, explain why outliers bias statistical models, and apply winsorisation and log transformation as treatments.

## Concept

### What is an outlier and why does it matter?

An outlier is a data point that lies far from the bulk of the distribution. Outliers matter because:
- They inflate the variance estimator, which affects confidence intervals and hypothesis tests.
- In OLS regression, a single influential point can pull the fitted line dramatically away from the true relationship, biasing every coefficient.
- In clustering, a distant outlier can dominate a centroid calculation and produce meaningless clusters.

### The IQR rule

The interquartile range is IQR = Q3 − Q1. A point is flagged as an outlier if:

$$x < Q_1 - 1.5 \times \text{IQR} \quad \text{or} \quad x > Q_3 + 1.5 \times \text{IQR}$$

**Derivation of the 1.5 multiplier** (informal but rigorous): for a perfectly normal distribution, $Q_1 = \mu - 0.6745\sigma$ and $Q_3 = \mu + 0.6745\sigma$, so $\text{IQR} = 1.349\sigma$. The lower fence is $\mu - 0.6745\sigma - 1.5 \times 1.349\sigma = \mu - 2.698\sigma$ and the upper fence is $\mu + 2.698\sigma$. The interval $[\mu - 2.698\sigma, \mu + 2.698\sigma]$ contains $\Phi(2.698) - \Phi(-2.698) \approx 99.3\%$ of a normal distribution. So only about 0.7% of genuinely normal data is flagged — a reasonable false-positive rate.

**Numeric example**: for `claim_amount` in our insurance dataset, suppose Q1 = 1,200, Q3 = 6,800.
- IQR = 6,800 − 1,200 = 5,600
- Lower fence = 1,200 − 1.5 × 5,600 = 1,200 − 8,400 = −7,200 (not meaningful here — claim amounts are non-negative)
- Upper fence = 6,800 + 1.5 × 5,600 = 6,800 + 8,400 = 15,200

Any claim above $15,200 is flagged. A claim of $82,000 is clearly an outlier.

### Z-score method

Standardise each value as $z = (x - \bar{x}) / s$. Flag as outlier if $|z| > 3$. For a normal distribution, $P(|Z| > 3) \approx 0.27\%$. This method is *sensitive to outliers* because the very points it is trying to detect inflate $\bar{x}$ and $s$. The IQR rule is more robust for that reason.

### Box plots

A box plot draws the box from Q1 to Q3, with a line at the median. Whiskers extend to the fences (Q1 − 1.5×IQR and Q3 + 1.5×IQR). Points beyond the whiskers are plotted individually and are, by definition, the IQR-rule outliers.

### Treatment 1: Winsorisation

Cap values at a specified percentile instead of deleting them. Winsorising at the 1st and 99th percentile sets:

$$x_{\text{win}} = \begin{cases} p_{1} & \text{if } x < p_{1} \\ p_{99} & \text{if } x > p_{99} \\ x & \text{otherwise} \end{cases}$$

This retains the record (no data loss) but limits the leverage of extreme values. In R: `pmin(pmax(x, quantile(x, 0.01)), quantile(x, 0.99))`.

**Example**: if p99 of `claim_amount` = $42,000, every claim above $42,000 is replaced by $42,000. A $82,000 claim becomes $42,000 — still high, but no longer extreme enough to distort a regression.

### Treatment 2: Log transformation

For right-skewed positive data, $\log(x)$ compresses the upper tail: $\log(82000) \approx 11.3$ while $\log(1000) \approx 6.9$ — a much smaller relative gap. This makes the distribution more symmetric and reduces the influence of extreme values. Use $\log(x + 1)$ if $x$ can be zero (the "+1" avoids $\log(0) = -\infty$).

## Example

```r
library(tidyverse)

options(bdat602.source_only = TRUE)
source("courses/bdat-602/_teacher/resources/datasets/simulate_bdat602_data.R")
health_data <- simulate_bdat602(n = 500000, seed = 602)

# --- IQR-based outlier detection for claim_amount ---
q1  <- quantile(health_data$claim_amount, 0.25, na.rm = TRUE)
q3  <- quantile(health_data$claim_amount, 0.75, na.rm = TRUE)
iqr <- q3 - q1
lo  <- q1 - 1.5 * iqr
hi  <- q3 + 1.5 * iqr

n_outliers <- sum(health_data$claim_amount > hi | health_data$claim_amount < lo, na.rm = TRUE)
cat("Outliers in claim_amount (IQR rule):", n_outliers, "\n")

# --- Box plot ---
health_data |>
  filter(claim_amount > 0) |>
  ggplot(aes(y = claim_amount)) +
  geom_boxplot(fill = "steelblue") +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Claim Amount — Box Plot", y = "Claim Amount (USD)") +
  theme_minimal()

# --- Winsorise ---
p1  <- quantile(health_data$claim_amount, 0.01, na.rm = TRUE)
p99 <- quantile(health_data$claim_amount, 0.99, na.rm = TRUE)
health_data <- health_data |>
  mutate(claim_amount_win = pmin(pmax(claim_amount, p1), p99))

# --- Log transform ---
health_data <- health_data |>
  mutate(log_claim = log(claim_amount + 1))

health_data |>
  filter(claim_amount > 0) |>
  ggplot(aes(x = log_claim)) +
  geom_histogram(bins = 60, fill = "darkorange") +
  labs(title = "Log(Claim Amount + 1) — more symmetric", x = "log(claim + 1)") +
  theme_minimal()
```

After the log transform, the distribution is much closer to normal, as confirmed by the histogram.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) detect outliers in `claim_amount` and `bmi` using both the IQR rule and Z-score; (2) draw box plots for both variables; (3) winsorise `claim_amount` at the 1st/99th percentile and verify the new maximum; (4) apply a log transformation and compare the before/after histograms.

## Check

```
npm run check -- bdat-602 module-02 lesson-02
```

## Reflection

Winsorisation caps extreme values but does not remove them. Log transformation changes the *scale* of the variable. Can you describe a situation where winsorisation is preferred over log transformation, and another where the log transform is the better choice?
