# Simulate data with heavy-tailed (Student-t, df=2) noise — prone to outliers
library('tidyverse')

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

measure_mae <- function(mod, data) {
  resid <- data$y - model1(mod, data)
  mean(abs(resid))
}

set.seed(42)
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

cat('Sim1A data')
sim1a

cat('Best Measure')
best_mae <- optim(c(0, 0), measure_mae, data = sim1a)

best_mae

ols_fit  <- lm(y ~ x, data = sim1a)

cat("MAE-optimal: intercept =", round(best_mae$par[1], 3),
    "  slope =", round(best_mae$par[2], 3), "\n")