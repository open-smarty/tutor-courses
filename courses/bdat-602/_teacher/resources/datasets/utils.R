# =============================================================================
# BDAT 602 — Shared helper functions
# Source this file at the top of any lecture script:
#   source("R/utils.R")
# =============================================================================

# Statistical mode for categorical imputation
get_mode <- function(x) {
  ux <- na.omit(unique(x))
  ux[which.max(tabulate(match(x, ux)))]
}

# Min-Max normalisation to [0, 1]
min_max_scale <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# Winsorise a numeric vector to the [p_lo, p_hi] percentile range
winsorise <- function(x, p_lo = 0.01, p_hi = 0.99) {
  lo <- quantile(x, p_lo, na.rm = TRUE)
  hi <- quantile(x, p_hi, na.rm = TRUE)
  pmax(lo, pmin(hi, x))
}
