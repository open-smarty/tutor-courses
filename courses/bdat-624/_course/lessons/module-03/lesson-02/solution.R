# SOLUTION: Module 03 Lesson 02 — Poisson Process and Renewal Counting
library(ggplot2)
library(dplyr)

lambda <- 5   # patients per hour
T_max  <- 10  # observe for 10 hours
set.seed(42)

# ============================================================
# Task 1: Simulate Poisson process
# ============================================================
inter_arrivals <- rexp(1000, rate = lambda)
event_times    <- cumsum(inter_arrivals)
event_times    <- event_times[event_times <= T_max]
n_events       <- length(event_times)
iats           <- inter_arrivals[seq_len(n_events)]

cat("Total events in [0,", T_max, "]:", n_events, "\n")
cat("Expected events:", lambda * T_max, "\n")

# ============================================================
# Task 2: Verify inter-arrivals are Exp(lambda)
# ============================================================
hist_df       <- data.frame(iat = iats)
iat_range     <- seq(0, max(iats) * 1.1, length.out = 200)
exp_dens_df   <- data.frame(x = iat_range, y = dexp(iat_range, rate = lambda))

p1 <- ggplot(hist_df, aes(x = iat)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30,
                 fill = "#3498db", alpha = 0.7, color = "white") +
  geom_line(data = exp_dens_df, aes(x=x, y=y), color="#e74c3c", linewidth=1.3) +
  labs(title = "Inter-Arrival Times: Observed vs Exponential(lambda)",
       subtitle = paste("lambda =", lambda, "; red = Exp(lambda) density"),
       x = "Inter-arrival time (hours)", y = "Density") +
  theme_minimal(base_size = 12)
print(p1)

cat("\nInter-arrival times:\n")
cat("  Observed mean:", round(mean(iats), 4), " | Theoretical:", round(1/lambda, 4), "\n")
cat("  Observed SD:  ", round(sd(iats),   4), " | Theoretical:", round(1/lambda, 4), "\n")

# ============================================================
# Task 3: Verify N(t) ~ Poisson(lambda*t)
# ============================================================
verify_poisson <- function(t, n_reps, lam) {
  counts <- replicate(n_reps, {
    iat <- rexp(ceiling(lam * t * 5), rate = lam)
    sum(cumsum(iat) <= t)
  })
  list(t=t, counts=counts, lambda_t=lam*t)
}

set.seed(100)
t_vals  <- c(0.5, 1, 2, 5)
results <- lapply(t_vals, verify_poisson, n_reps = 2000, lam = lambda)

cat("\nPoisson verification (mean ≈ variance ≈ lambda*t):\n")
for (res in results) {
  cat(sprintf("  t=%.1f: E[N(t)]=%.3f var[N(t)]=%.3f  theoretical lambda*t=%.3f\n",
              res$t, mean(res$counts), var(res$counts), res$lambda_t))
}

# ============================================================
# Task 4: n-th event time ~ Gamma(n, lambda)
# ============================================================
set.seed(200)
n_sim_gamma <- 5000
ns_to_check <- c(3, 8, 15)

gamma_df <- lapply(ns_to_check, function(n) {
  T_n_sim <- replicate(n_sim_gamma, sum(rexp(n, rate=lambda)))
  data.frame(n=n, n_label=paste0("n = ",n), T_n=T_n_sim)
}) |> bind_rows()

# Gamma density overlay per facet
density_overlay <- gamma_df |>
  group_by(n, n_label) |>
  reframe(
    x = seq(min(T_n)*0.5, max(T_n)*1.1, length.out = 300),
    y = dgamma(x, shape=unique(n), rate=lambda)
  )

p2 <- ggplot(gamma_df, aes(x=T_n)) +
  geom_histogram(aes(y=after_stat(density)), bins=40,
                 fill="#2ecc71", alpha=0.7, color="white") +
  geom_line(data=density_overlay, aes(x=x, y=y), color="#e74c3c", linewidth=1.2) +
  facet_wrap(~n_label, scales="free") +
  labs(title="n-th Event Time: Simulation vs Gamma(n, rate=lambda)",
       subtitle="Green = simulated; red = theoretical Gamma density",
       x="Time to n-th event (hours)", y="Density") +
  theme_minimal(base_size=12)
print(p2)

cat("\nGamma waiting time verification:\n")
for (n in ns_to_check) {
  sims <- filter(gamma_df, n == !!n)$T_n
  cat(sprintf("  n=%2d: E[T_n]=%.4f (theo=%.4f); Var[T_n]=%.4f (theo=%.4f)\n",
              n, mean(sims), n/lambda, var(sims), n/lambda^2))
}

# ============================================================
# Task 5: Memoryless property
# ============================================================
set.seed(999)
W_sims  <- rexp(100000, rate=lambda)
s_val   <- 1.0
residuals <- W_sims[W_sims > s_val] - s_val

cat("\nMemoryless property (conditioning on W > 1):\n")
cat("  Mean residual W-1 | W>1:", round(mean(residuals), 4),
    "(should be ~", round(1/lambda, 4), ")\n")
cat("  Mean of W (unconditional):", round(mean(W_sims), 4), "\n")
# Both ≈ 0.2 = 1/lambda — demonstrating memorylessness

# KS test to compare residual distribution to Exp(lambda)
ks <- ks.test(residuals, "pexp", rate=lambda)
cat("\nKolmogorov-Smirnov test (residuals vs Exp(lambda)):\n")
cat("  KS statistic:", round(ks$statistic, 5),
    "  p-value:", round(ks$p.value, 4), "\n")
cat("  (Large p-value confirms exponential distribution — memoryless property holds)\n")
