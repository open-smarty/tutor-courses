# SOLUTION: Module 04 Lesson 03 — Birth-Death Process and Extinction
library(ggplot2)
library(dplyr)

lambda_vals <- c(2, 1, 2); mu_vals <- c(1, 1, 3)
rho_vals    <- mu_vals / lambda_vals
labels      <- paste0("rho = ", rho_vals)

cat("Theoretical extinction probabilities:\n")
for (i in seq_along(rho_vals))
  cat(sprintf("  lambda=%.0f mu=%.0f rho=%.1f: q* = %.4f\n",
              lambda_vals[i], mu_vals[i], rho_vals[i], min(1, rho_vals[i])))

simulate_bd <- function(lambda, mu, T_max, n0=1) {
  times <- c(0); pops <- c(n0); n <- n0; t <- 0
  while (n > 0 && t < T_max) {
    wait <- rexp(1, rate=n*(lambda+mu)); t <- t+wait
    if (t > T_max) break
    n <- ifelse(runif(1) < lambda/(lambda+mu), n+1, n-1)
    times <- c(times,t); pops <- c(pops,n)
  }
  data.frame(time=times, pop=pops)
}

set.seed(2024)
n_sim <- 500; T_max <- 20

results_list <- lapply(seq_along(rho_vals), function(i) {
  lam <- lambda_vals[i]; mu_i <- mu_vals[i]
  sims <- lapply(seq_len(n_sim), function(s) simulate_bd(lam, mu_i, T_max))
  final_pops <- sapply(sims, function(s) tail(s$pop,1))
  ext_by_t <- sapply(0:T_max, function(t_int) {
    mean(sapply(sims, function(s) {
      idx <- max(which(s$time <= t_int))
      as.integer(s$pop[idx] == 0)
    }))
  })
  list(rho=rho_vals[i], final_pops=final_pops, ext_by_t=ext_by_t,
       label=labels[i], sims=sims)
})

cat("\nEmpirical extinction at T=20:\n")
ext_df_all <- lapply(results_list, function(res) {
  cat(sprintf("  rho=%.1f: empirical=%.4f theoretical=%.4f\n",
              res$rho, mean(res$final_pops==0), min(1,res$rho)))
  data.frame(t=0:T_max, p_ext=res$ext_by_t, rho=res$rho, label=res$label)
}) |> bind_rows()

p1 <- ggplot(ext_df_all, aes(x=t, y=p_ext, color=factor(rho), group=factor(rho))) +
  geom_line(linewidth=1.2) +
  geom_hline(data=data.frame(rho=rho_vals, q=pmin(1,rho_vals)),
             aes(yintercept=q, color=factor(rho)), linetype="dashed", linewidth=0.8) +
  scale_color_manual(values=c("0.5"="#2ecc71","1"="#f39c12","1.5"="#e74c3c"),
                     labels=c("0.5"="rho=0.5 (lambda>mu)",
                              "1"="rho=1 (critical)",
                              "1.5"="rho=1.5 (mu>lambda)")) +
  labs(title="P(Extinct by t) for Birth-Death Process",
       subtitle="Dashed = theoretical q* = min(1, rho)",
       x="Time t", y="P(Extinct by t)", color="Scenario") +
  theme_minimal(base_size=12)
print(p1)

set.seed(42)
traj_examples <- lapply(seq_along(rho_vals), function(i) {
  lapply(1:3, function(j) {
    traj <- simulate_bd(lambda_vals[i], mu_vals[i], T_max)
    traj$rho <- rho_vals[i]; traj$sim_id <- j; traj$label <- labels[i]; traj
  }) |> bind_rows()
}) |> bind_rows()

p2 <- ggplot(traj_examples, aes(x=time, y=pop, group=sim_id, color=factor(sim_id))) +
  geom_step(linewidth=0.8, alpha=0.9) +
  facet_wrap(~label) +
  labs(title="Birth-Death Trajectories: rho=0.5, 1.0, 1.5",
       x="Time", y="N(t)", color="Replicate") +
  theme_minimal(base_size=12)
print(p2)

rho_grid <- seq(0, 2, by=0.01)
q_theory <- lapply(c(1,3,5), function(n0) {
  data.frame(rho=rho_grid, q=pmin(1,rho_grid)^n0, n0=paste0("n0=",n0))
}) |> bind_rows()

p3 <- ggplot(q_theory, aes(x=rho, y=q, color=n0, group=n0)) +
  geom_line(linewidth=1.2) +
  geom_vline(xintercept=1, linetype="dashed", color="grey40") +
  annotate("text", x=1.05, y=0.55, label="rho=1\n(threshold)", hjust=0, size=3.5) +
  scale_color_brewer(palette="Set1") +
  labs(title="Extinction Probability q* vs rho for Various Starting Sizes",
       x="rho = mu/lambda", y="Extinction probability q*", color="n0") +
  theme_minimal(base_size=12)
print(p3)
