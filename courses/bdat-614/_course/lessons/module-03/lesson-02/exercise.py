"""
BDAT 614 — Module 3, Lesson 2
Exercise: Measurement System Analysis — Gauge R&R (ANOVA Method)
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

np.random.seed(614)

# Study design parameters
n_parts = 10       # number of parts
n_operators = 3    # number of operators (appraisers)
n_reps = 2         # replications per part-operator combination

# Specification limits
LSL = 19.0         # mm
USL = 21.0         # mm
TOLERANCE = USL - LSL

# Known true variance components (used to simulate realistic data)
sigma2_part   = 0.0120   # Part-to-Part variance
sigma2_op     = 0.0009   # Operator (reproducibility) variance
sigma2_repeat = 0.0016   # Repeatability variance

# ============================================================
# Task 1: Simulate the Gauge R&R dataset
# ============================================================
# Build a DataFrame with columns: Part, Operator, Replicate, Measurement
#
# The measurement model is:
#   y_{ijk} = mu + part_i + operator_j + error_{ijk}
# where:
#   mu            = grand mean = 20.0 mm
#   part_i        ~ N(0, sigma2_part)        for i = 1..n_parts
#   operator_j    ~ N(0, sigma2_op)          for j = 1..n_operators
#   error_{ijk}   ~ N(0, sigma2_repeat)      for k = 1..n_reps
#
# TODO: create the following random effects arrays:
#   part_effects     = np.random.normal(0, np.sqrt(sigma2_part),    n_parts)
#   operator_effects = np.random.normal(0, np.sqrt(sigma2_op),      n_operators)
#
# TODO: build a list of dicts (one per measurement) and convert to DataFrame.
#   Loop: for i in range(n_parts):
#           for j in range(n_operators):
#             for k in range(n_reps):
#               measurement = 20.0 + part_effects[i] + operator_effects[j]
#                             + np.random.normal(0, np.sqrt(sigma2_repeat))
#               append dict(Part=i+1, Operator=j+1, Rep=k+1, Measurement=measurement)
#
# TODO: df = pd.DataFrame(records)
# TODO: print(df.head(12))

part_effects     = None
operator_effects = None
df = None


# ============================================================
# Task 2: Compute ANOVA sums of squares
# ============================================================
# This is a balanced two-factor crossed ANOVA (Part × Operator) with replication.
#
# Grand mean: y_bar = mean of all measurements
# Correction factor: CF = N * y_bar^2 where N = n_parts * n_operators * n_reps
#
# SS_Total  = sum of (y_ijk - y_bar)^2 for all observations
# SS_Part   = n_ops * n_reps * sum_i (y_i.. - y_bar)^2  (i-dot means mean over j,k)
# SS_Op     = n_parts * n_reps * sum_j (y_.j. - y_bar)^2
# SS_PO     = n_reps * sum_ij (y_ij. - y_i.. - y_.j. + y_bar)^2  (interaction)
# SS_Error  = SS_Total - SS_Part - SS_Op - SS_PO
#
# TODO: extract the Measurement column as a numpy array: y = df["Measurement"].values
# TODO: compute y_bar = y.mean()
# TODO: reshape y to shape (n_parts, n_operators, n_reps) using y.reshape(...)
#       (rows = parts, cols = operators, depth = reps)
# TODO: compute:
#   y_i_dot  = mean over operators and reps: shape (n_parts,)
#   y_j_dot  = mean over parts and reps:     shape (n_operators,)
#   y_ij_dot = mean over reps:               shape (n_parts, n_operators)
#
# TODO: compute SS_Part, SS_Op, SS_PO, SS_Total, SS_Error
# TODO: compute degrees of freedom:
#   df_Part  = n_parts - 1
#   df_Op    = n_operators - 1
#   df_PO    = (n_parts - 1) * (n_operators - 1)
#   df_Error = n_parts * n_operators * (n_reps - 1)
# TODO: compute mean squares: MS_Part, MS_Op, MS_PO, MS_Error = SS / df

y        = None
y_bar    = None
y_cube   = None     # shape (n_parts, n_operators, n_reps)

SS_Part  = None
SS_Op    = None
SS_PO    = None
SS_Total = None
SS_Error = None

df_Part  = None
df_Op    = None
df_PO    = None
df_Error = None

MS_Part  = None
MS_Op    = None
MS_PO    = None
MS_Error = None


# ============================================================
# Task 3: Print ANOVA table
# ============================================================
# Print a formatted table with columns: Source | SS | df | MS
# Sources: Part, Operator, Part×Operator, Repeatability (Error)
#
# TODO: print the ANOVA table

# ============================================================
# Task 4: Estimate variance components
# ============================================================
# Using the EMS (Expected Mean Squares) equations:
#
#   sigma2_EV  = MS_Error                             (repeatability)
#   sigma2_PO  = max(0, (MS_PO - MS_Error) / n_reps) (interaction, usually folded into AV)
#   sigma2_AV  = max(0, (MS_Op  - MS_PO) / (n_reps * n_parts))  (reproducibility)
#   sigma2_PV  = max(0, (MS_Part - MS_PO) / (n_reps * n_operators)) (part-to-part)
#   sigma2_GRR = sigma2_EV + sigma2_AV + sigma2_PO
#
# TODO: compute all five variance components

sigma2_EV  = None
sigma2_PO  = None
sigma2_AV  = None
sigma2_PV  = None
sigma2_GRR = None


# ============================================================
# Task 5: Compute %Gauge R&R metrics
# ============================================================
# Study variation = 5.15 * sigma_component
# %GRR = (5.15 * sigma_GRR / TOLERANCE) * 100
# %PV  = (5.15 * sigma_PV  / TOLERANCE) * 100
# ndc  = int(np.sqrt(2) * sigma_PV / sigma_GRR) if sigma_GRR > 0 else 0
#
# TODO: compute study_var_GRR, study_var_EV, study_var_AV, study_var_PV
# TODO: compute pct_GRR, pct_EV, pct_AV, pct_PV
# TODO: compute ndc
# TODO: print a summary report

study_var_GRR = None
study_var_EV  = None
study_var_AV  = None
study_var_PV  = None

pct_GRR = None
pct_EV  = None
pct_AV  = None
pct_PV  = None
ndc     = None


# ============================================================
# Task 6: Visualisation
# ============================================================
# Panel A — grouped bar chart of study variation by component:
#   components = ["Repeatability (EV)", "Reproducibility (AV)", "Part-to-Part (PV)", "Total GRR"]
#   values     = [study_var_EV, study_var_AV, study_var_PV, study_var_GRR]
#   Draw a horizontal red dashed line at TOLERANCE (the full tolerance band).
#   Label each bar with its % value.
#   Title: "Gauge R&R — Study Variation by Component"
#   y-axis: "Study Variation (mm)"
#
# Panel B — scatter plot of all measurements:
#   x-axis: Operator number (1, 2, 3) with jitter so points don't overlap.
#   y-axis: Measurement value.
#   Colour each point by Part number (use a colormap such as tab10).
#   Add a horizontal line at LSL and USL.
#   Title: "Measurements by Operator (coloured by Part)"
#   Add a legend or colorbar.
#
# TODO: build the two-panel figure

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# --- Panel A ---
# TODO

# --- Panel B ---
# TODO

plt.tight_layout()
plt.show()
