# Lesson 2: Diagnostic Plots and Model Comparison

## Goal

Produce and interpret the four standard diagnostic plots for a linear model, use AIC to compare models of different complexity, and apply the F-test to decide whether extra predictors are worth keeping.

## Concept

Fitting a model is not enough — you must verify that the model's assumptions hold. The four diagnostic plots produced by `plot(lm_fit)` each test a different assumption.

**Plot 1: Residuals vs Fitted.** Tests linearity and homoscedasticity. If the model is correctly specified, points should scatter randomly around the horizontal line at zero. A U-shaped or arch pattern means the relationship is non-linear. A fan shape (spread increasing with fitted values) means variance is non-constant (heteroscedastic).

**Plot 2: Normal Q-Q.** Tests normality of residuals. The x-axis is the theoretical quantile of a normal distribution; the y-axis is the observed residual quantile. If residuals are normal, all points lie close to the 45° diagonal. Heavy tails (points curving away at both ends) indicate outlier-prone, heavy-tailed noise. A left curve (points above the line at left) indicates left skew.

**Plot 3: Scale-Location (Spread-Location).** Tests homoscedasticity more directly. The y-axis is $\sqrt{|\text{standardised residual}|}$. If variance is constant, the red LOESS line should be approximately flat. An upward slope means variance increases with fitted values.

**Plot 4: Residuals vs Leverage.** Identifies influential observations. Leverage measures how extreme an observation's $x$-value is. Cook's distance combines leverage and residual size: $D_i > 1$ (or some use $D_i > 4/n$) indicates a highly influential point — removing it would substantially change the estimated coefficients.

**AIC (Akaike Information Criterion).** Model comparison requires balancing fit against complexity:

$$\text{AIC} = 2k - 2\log\hat{L}$$

where $k$ is the number of parameters estimated (including the error variance) and $\hat{L}$ is the maximised likelihood. Lower AIC is better. Adding a predictor that does not improve fit enough to justify its extra parameter will increase AIC. Rule of thumb: a difference of 2 AIC units is already meaningful; $\Delta\text{AIC} > 10$ is strong evidence for the better model.

In R: `AIC(model1, model2)`. For linear models, $-2\log\hat{L} = n\log(\hat{\sigma}^2) + n$, so AIC penalises models with more parameters and larger residual variance.

**F-test for nested models.** When model B contains all the terms of model A plus additional ones (B is "more complex"), we can formally test whether the extra terms improve fit:

$$F = \frac{(\text{RSS}_A - \text{RSS}_B)/(\text{df}_A - \text{df}_B)}{\text{RSS}_B/\text{df}_B}$$

Under $H_0$ (the extra terms are all zero), $F \sim F(\text{df}_A - \text{df}_B, \text{df}_B)$. A small $p$-value means the extra terms are worth including.

In R: `anova(simple_model, complex_model)`.

## Example

We compare two diamond models: `mod1 = lm(log(price) ~ log(carat))` and `mod2 = lm(log(price) ~ log(carat) + cut + color + clarity)`.

**Diagnostic plots for mod1:**

```r
par(mfrow = c(2, 2))
plot(mod1)
par(mfrow = c(1, 1))
```

What you see: Residuals vs Fitted shows slight curvature and a striped pattern (the ordinal nature of quality variables causes discretisation). Q-Q plot shows mild deviations in the tails — the price distribution has slightly heavier tails than normal. Scale-Location shows a non-flat line — heteroscedasticity remains. Residuals vs Leverage shows no single diamond with Cook's distance > 1.

**AIC comparison:**

```r
AIC(mod1, mod2)
# mod1: AIC ≈ -2,801   mod2: AIC ≈ -5,532
```

$\Delta\text{AIC} = 2{,}731$ — overwhelming evidence for `mod2`. The quality variables (cut, color, clarity) dramatically improve the model.

**F-test:**

```r
anova(mod1, mod2)
# F = 5,473, p-value < 2.2e-16
```

The extra 16 parameters (cut has 5 levels → 4 dummies; color has 7 → 6; clarity has 8 → 7; total: 4+6+7=17, minus mod1's parameters) jointly improve fit enormously. There is no question — add the quality variables.

**Numeric example.** `mod1` has $k = 3$ parameters ($\beta_0$, $\beta_1$, $\hat{\sigma}^2$). If RSS = 3{,}100 and $n = 53{,}940$:

$$\text{AIC} = 2 \times 3 - 2\log\hat{L} \approx 2 \times 3 + n\log(\text{RSS}/n) + n = 6 + 53940\log(3100/53940) \approx -2{,}800$$

`mod2` with RSS = 1{,}400 and $k = 20$: AIC $\approx -5{,}530$. The dramatic reduction in RSS more than compensates for the extra parameters.

## Task

Open `exercise.Rmd`. Fit `mod1 = lm(log(price) ~ log(carat))` and `mod2 = lm(log(price) ~ log(carat) + cut + color + clarity)` on `diamonds`:

1. Produce the four diagnostic plots for `mod1` using `plot(mod1)`. Describe what each plot tells you.
2. Compute `AIC(mod1, mod2)`. Which model wins?
3. Run `anova(mod1, mod2)`. Report $F$, degrees of freedom, and the $p$-value.
4. Produce the residuals vs fitted plot for `mod2` and compare it to `mod1`. Has the heteroscedasticity improved?

## Check

```
npm run check -- bdat-608 module-03 lesson-02
```

## Reflection

AIC penalises models for the number of parameters $k$. This prevents overfitting: a model with 100 parameters will always fit the training data better than a model with 2 parameters, but it may generalise worse. However, AIC assumes that adding one parameter always costs 2 AIC units. Is this penalty always appropriate? When might you want a larger penalty (BIC uses $k\log n$), and when might AIC be too conservative?
