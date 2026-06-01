# BDAT 624 — Module 1, Lesson 1
# Exercise: Simulating the Four Types of Stochastic Processes
#
# Instructions: Complete each TODO section below.
# After finishing, run: npm run check -- bdat-624 module-01 lesson-01

library(ggplot2)
library(dplyr)
library(gridExtra)

set.seed(42)  # for reproducibility — do not change this line

# ============================================================
# TYPE I: Discrete Time, Discrete State
# Random walk on {0, 1, 2, ...} — absorbing barrier at 0
# Simulates patient disease severity score (0 = recovered/absorbed)
# ============================================================

n_steps <- 50
start_state <- 5

# TODO 1: Simulate the random walk.
# - Create a vector `rw` of length (n_steps + 1), initialised to NA.
# - Set rw[1] <- start_state
# - For each step i in 2:(n_steps + 1):
#     Draw a step of +1 or -1 with equal probability (hint: sample(c(-1, 1), 1))
#     The new state is rw[i-1] + step, BUT it cannot go below 0 (absorbing barrier).
#     If the new value would be < 0, set rw[i] <- 0; otherwise use the new value.
#     Once the state reaches 0, it stays at 0 for all future steps.
rw <- rep(NA, n_steps + 1)
# --- your code here ---


df_rw <- data.frame(step = 0:n_steps, state = rw)

# ============================================================
# TYPE II: Continuous Time, Discrete State
# Poisson arrivals — number of patients arriving at an ED over 24 hours
# ============================================================

# Average arrival rate: lambda = 6 patients per hour
lambda_per_hour <- 6
hours <- 24

# TODO 2: Simulate Poisson arrivals.
# - Generate a vector `arrivals` of length `hours` using rpois().
#   Each element is the number of arrivals in that hour.
# - Compute `cum_arrivals` as the cumulative sum of `arrivals`.
# - Create a data frame `df_pois` with columns:
#     hour: 1:hours
#     cumulative: cum_arrivals
arrivals <- NULL       # replace NULL
cum_arrivals <- NULL   # replace NULL
# --- your code here ---

df_pois <- data.frame(hour = 1:hours, cumulative = cum_arrivals)

# ============================================================
# TYPE III: Discrete Time, Continuous State
# Weekly body weight fluctuations over one year (52 weeks)
# Starting weight: 75 kg; weekly fluctuation ~ N(0, 0.8) kg
# ============================================================

n_weeks <- 52
start_weight <- 75
sd_weekly <- 0.8

# TODO 3: Simulate weekly weight.
# - Create a vector `weight` of length (n_weeks + 1).
# - Set weight[1] <- start_weight
# - For each week i in 2:(n_weeks + 1), add a draw from rnorm(1, mean=0, sd=sd_weekly)
#   to the previous weight.
weight <- rep(NA, n_weeks + 1)
# --- your code here ---

df_weight <- data.frame(week = 0:n_weeks, kg = weight)

# ============================================================
# TYPE IV: Continuous Time, Continuous State
# Brownian motion approximation — blood pressure fluctuation
# Use cumsum of 1000 iid N(0,1) increments scaled to a plausible range
# ============================================================

n_points <- 1000
bm_increments <- rnorm(n_points, mean = 0, sd = 1)

# TODO 4: Construct the Brownian motion path.
# - Set `bm_path` as cumsum(bm_increments).
# - Shift and scale so the starting point is 120 (mmHg) and the
#   standard deviation of bm_path is approximately 15:
#     bm_path <- 120 + 15 * (bm_path / sd(bm_path))
# - Create a data frame `df_bm` with columns:
#     t: seq(0, 24, length.out = n_points)   (time in hours)
#     bp: bm_path
bm_path <- NULL  # replace NULL
# --- your code here ---

df_bm <- data.frame(t = seq(0, 24, length.out = n_points), bp = bm_path)

# ============================================================
# PLOTTING — combine all four into a 2x2 grid
# ============================================================

# TODO 5: Create four ggplot objects (p1, p2, p3, p4) and arrange them.
# Requirements for each plot:
#   p1 (Type I):  x = step (0 to 50), y = state (integer).
#                 Use geom_step(). Title: "Type I: Discrete Time, Discrete State".
#                 x-label: "Step", y-label: "Severity Score"
#   p2 (Type II): x = hour, y = cumulative arrivals.
#                 Use geom_step(). Title: "Type II: Continuous Time, Discrete State".
#                 x-label: "Hour of Day", y-label: "Cumulative Arrivals"
#   p3 (Type III):x = week, y = weight in kg.
#                 Use geom_line(). Title: "Type III: Discrete Time, Continuous State".
#                 x-label: "Week", y-label: "Body Weight (kg)"
#   p4 (Type IV): x = t (hours), y = bp (mmHg).
#                 Use geom_line(). Title: "Type IV: Continuous Time, Continuous State".
#                 x-label: "Time (hours)", y-label: "Blood Pressure (mmHg)"
# All plots: add theme_minimal() and a descriptive subtitle if you wish.

p1 <- NULL  # replace with ggplot(...)
p2 <- NULL
p3 <- NULL
p4 <- NULL

# --- your code here ---

# Display the grid
grid.arrange(p1, p2, p3, p4, nrow = 2)

# ============================================================
# REFLECTION (no code needed — answer as a comment)
# ============================================================
# After looking at your four plots, answer:
# Which plot shows the most "predictable" long-run behaviour? Why?
# Which would be hardest to model with a deterministic equation? Why?

# YOUR ANSWER:
#
