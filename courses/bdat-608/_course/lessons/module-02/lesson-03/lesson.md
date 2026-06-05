# Lesson 3: Closed-Form OLS with lm()

## Goal

Derive the OLS estimator from first principles, explain how `lm()` computes it via QR decomposition, and decode every component of the `summary()` output — including $R^2$, the $F$-statistic, $t$-values, and degrees of freedom.

## Concept

**The OLS objective.** We want to find the vector $\boldsymbol{\beta} = (\beta_0, \beta_1, \ldots, \beta_p)^\top$ that minimises the **Residual Sum of Squares**:

$$\text{RSS}(\boldsymbol{\beta}) = \sum_{i=1}^{n}(y_i - \hat{y}_i)^2 = \|\mathbf{y} - \mathbf{X}\boldsymbol{\beta}\|^2$$

where $\mathbf{y}$ is the $n \times 1$ response vector and $\mathbf{X}$ is the $n \times (p+1)$ design matrix (first column of all ones for the intercept).

**Derivation.** Setting the gradient to zero:

$$\frac{\partial \text{RSS}}{\partial \boldsymbol{\beta}} = -2\mathbf{X}^\top(\mathbf{y} - \mathbf{X}\boldsymbol{\beta}) = \mathbf{0}$$

This gives the **normal equations**:

$$\mathbf{X}^\top\mathbf{X}\,\boldsymbol{\hat{\beta}} = \mathbf{X}^\top\mathbf{y}$$

Provided $\mathbf{X}^\top\mathbf{X}$ is invertible (no perfect collinearity), the unique solution is:

$$\boldsymbol{\hat{\beta}} = (\mathbf{X}^\top\mathbf{X})^{-1}\mathbf{X}^\top\mathbf{y}$$

This is the OLS estimator. It is the **Best Linear Unbiased Estimator (BLUE)** when errors are independent, homoscedastic, and have zero mean — the Gauss-Markov theorem.

**QR decomposition.** `lm()` does not compute $(\mathbf{X}^\top\mathbf{X})^{-1}$ directly — that can be numerically unstable when columns of $\mathbf{X}$ are nearly collinear. Instead, it uses the QR decomposition: $\mathbf{X} = \mathbf{Q}\mathbf{R}$, where $\mathbf{Q}$ is orthogonal ($\mathbf{Q}^\top\mathbf{Q} = \mathbf{I}$) and $\mathbf{R}$ is upper-triangular. This reduces the normal equations to $\mathbf{R}\boldsymbol{\hat{\beta}} = \mathbf{Q}^\top\mathbf{y}$, a triangular system solved by back-substitution — much more stable.

**Decoding `summary(lm_fit)`.** After `lm(y ~ x)`, `summary()` prints:

- **Coefficients table.** `Estimate` = $\hat{\beta}_j$. `Std. Error` = $\hat{\sigma}\sqrt{[(\mathbf{X}^\top\mathbf{X})^{-1}]_{jj}}$. `t value` = Estimate / Std. Error. `Pr(>|t|)` = two-sided $p$-value for $H_0: \beta_j = 0$.
- **Residual standard error** = $\hat{\sigma} = \sqrt{\text{RSS}/(n-p-1)}$, in the same units as $y$.
- **$R^2$** = $1 - \text{RSS}/\text{TSS}$ where TSS is the total sum of squares. The fraction of variance in $y$ explained by the model.
- **Adjusted $R^2$** = $1 - (1-R^2)(n-1)/(n-p-1)$. Penalises for extra parameters; better for comparing models with different numbers of predictors.
- **$F$-statistic** tests the null that all slope coefficients are simultaneously zero: $F = \frac{(\text{TSS}-\text{RSS})/p}{\text{RSS}/(n-p-1)}$. Under $H_0$, $F \sim F(p, n-p-1)$.
- **Degrees of freedom**: residual df = $n - p - 1$ (total observations minus parameters estimated).

**Log-log model.** For the `diamonds` dataset, `log(price) ~ log(carat)` is better than `price ~ carat`. Why? The power law relationship $\text{price} = c \cdot \text{carat}^\gamma$ becomes linear on the log scale: $\log(\text{price}) = \log(c) + \gamma\log(\text{carat})$. The slope $\gamma$ is the price elasticity: a 1% increase in carat is associated with a $\gamma$% increase in price.

## Example

**Numeric derivation for a 2-observation toy dataset.** Let $\mathbf{y} = (2, 5)^\top$ and $\mathbf{X} = \begin{pmatrix}1 & 1 \\ 1 & 3\end{pmatrix}$ (intercept + $x = 1, 3$).

$$\mathbf{X}^\top\mathbf{X} = \begin{pmatrix}2 & 4 \\ 4 & 10\end{pmatrix}, \quad \mathbf{X}^\top\mathbf{y} = \begin{pmatrix}7 \\ 17\end{pmatrix}$$

$$(\mathbf{X}^\top\mathbf{X})^{-1} = \frac{1}{20-16}\begin{pmatrix}10 & -4 \\ -4 & 2\end{pmatrix} = \begin{pmatrix}2.5 & -1 \\ -1 & 0.5\end{pmatrix}$$

$$\hat{\boldsymbol{\beta}} = \begin{pmatrix}2.5 & -1 \\ -1 & 0.5\end{pmatrix}\begin{pmatrix}7 \\ 17\end{pmatrix} = \begin{pmatrix}0.5 \\ 1.5\end{pmatrix}$$

So $\hat{y} = 0.5 + 1.5x$. Check: for $x=1$, $\hat{y}=2$ ✓; for $x=3$, $\hat{y}=5$ ✓. (With 2 observations and 2 parameters, the line passes exactly through both points — RSS = 0.)

**Fitting the diamonds log-log model:**

```r
mod_linear <- lm(price ~ carat,           data = diamonds)
mod_loglog <- lm(log(price) ~ log(carat), data = diamonds)

cat("Linear R²:", summary(mod_linear)$r.squared |> round(3))
cat("Log-log R²:", summary(mod_loglog)$r.squared |> round(3))
# Linear: 0.849   Log-log: 0.933
```

The log-log model explains 93.3% of variance in log-price vs 84.9% in raw price — a substantial improvement driven by linearising the power-law relationship and stabilising variance.

## Task

Open `exercise.Rmd`. Fit and interpret two models on the full `diamonds` dataset:

1. Fit `lm(price ~ carat)`. Record intercept, slope, residual SE, $R^2$, $F$-statistic, and its $p$-value.
2. Interpret the slope in plain English: "a 1-carat increase is associated with a \$\_\_\_ change in price."
3. Fit `lm(log(price) ~ log(carat))`. Record the slope (price elasticity) and $R^2$.
4. Interpret the log-log slope: "a 1% increase in carat is associated with a \_\_% change in price."
5. Compare $R^2$ from both models. Which fits better and why?
6. From the log-log model summary, identify a coefficient with a small $t$-value (if any) and explain what that means.

## Check

```
npm run check -- bdat-608 module-02 lesson-03
```

## Reflection

The OLS estimator $\hat{\boldsymbol{\beta}} = (\mathbf{X}^\top\mathbf{X})^{-1}\mathbf{X}^\top\mathbf{y}$ requires $\mathbf{X}^\top\mathbf{X}$ to be invertible. What happens when two columns of $\mathbf{X}$ are perfectly correlated (perfect multicollinearity)? Why does this make the matrix singular? What is R's response when you include a perfectly collinear column in a `lm()` formula?
