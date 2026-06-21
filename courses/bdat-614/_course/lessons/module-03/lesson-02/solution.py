"""
BDAT 614 — Module 3, Lesson 2
Solution: Measurement System Analysis — Gauge R&R (ANOVA Method)
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

np.random.seed(614)

# Study design parameters
n_parts = 10
n_operators = 3
n_reps = 2

LSL = 19.0
USL = 21.0
TOLERANCE = USL - LSL

# Known true variance components
sigma2_part   = 0.0120
sigma2_op     = 0.0009
sigma2_repeat = 0.0016

# ============================================================
# Task 1: Simulate Gauge R&R dataset
# ============================================================
part_effects     = np.random.normal(0, np.sqrt(sigma2_part),    n_parts)
operator_effects = np.random.normal(0, np.sqrt(sigma2_op),      n_operators)

records = []
for i in range(n_parts):
    for j in range(n_operators):
        for k in range(n_reps):
            measurement = (20.0
                           + part_effects[i]
                           + operator_effects[j]
                           + np.random.normal(0, np.sqrt(sigma2_repeat)))
            records.append({"Part": i + 1, "Operator": j + 1, "Rep": k + 1,
                            "Measurement": measurement})

df = pd.DataFrame(records)
print("=== First 12 observations ===")
print(df.head(12).to_string(index=False))

# ============================================================
# Task 2: Compute ANOVA sums of squares
# ============================================================
y     = df["Measurement"].values
y_bar = y.mean()
N     = len(y)

# Reshape to (n_parts, n_operators, n_reps)
y_cube = y.reshape(n_parts, n_operators, n_reps)

# Marginal means
y_i_dot  = y_cube.mean(axis=(1, 2))   # part means,     shape (n_parts,)
y_j_dot  = y_cube.mean(axis=(0, 2))   # operator means,  shape (n_operators,)
y_ij_dot = y_cube.mean(axis=2)        # cell means,      shape (n_parts, n_operators)

SS_Part  = n_operators * n_reps * np.sum((y_i_dot  - y_bar) ** 2)
SS_Op    = n_parts     * n_reps * np.sum((y_j_dot  - y_bar) ** 2)
SS_PO    = n_reps * np.sum(
               (y_ij_dot
                - y_i_dot[:, np.newaxis]
                - y_j_dot[np.newaxis, :]
                + y_bar) ** 2)
SS_Total = np.sum((y - y_bar) ** 2)
SS_Error = SS_Total - SS_Part - SS_Op - SS_PO

# Degrees of freedom
df_Part  = n_parts - 1
df_Op    = n_operators - 1
df_PO    = (n_parts - 1) * (n_operators - 1)
df_Error = n_parts * n_operators * (n_reps - 1)

# Mean squares
MS_Part  = SS_Part  / df_Part
MS_Op    = SS_Op    / df_Op
MS_PO    = SS_PO    / df_PO
MS_Error = SS_Error / df_Error

# ============================================================
# Task 3: Print ANOVA table
# ============================================================
print("\n=== ANOVA Table ===")
print(f"{'Source':<20} {'SS':>10} {'df':>5} {'MS':>10}")
print("-" * 48)
print(f"{'Part':<20} {SS_Part:>10.5f} {df_Part:>5} {MS_Part:>10.5f}")
print(f"{'Operator':<20} {SS_Op:>10.5f} {df_Op:>5} {MS_Op:>10.5f}")
print(f"{'Part x Operator':<20} {SS_PO:>10.5f} {df_PO:>5} {MS_PO:>10.5f}")
print(f"{'Repeatability':<20} {SS_Error:>10.5f} {df_Error:>5} {MS_Error:>10.5f}")
print(f"{'Total':<20} {SS_Total:>10.5f} {N - 1:>5}")

# ============================================================
# Task 4: Estimate variance components
# ============================================================
sigma2_EV  = MS_Error
sigma2_PO  = max(0.0, (MS_PO - MS_Error) / n_reps)
sigma2_AV  = max(0.0, (MS_Op - MS_PO) / (n_reps * n_parts))
sigma2_PV  = max(0.0, (MS_Part - MS_PO) / (n_reps * n_operators))
sigma2_GRR = sigma2_EV + sigma2_AV + sigma2_PO

print("\n=== Variance Component Estimates ===")
print(f"  Repeatability  (EV):  {sigma2_EV:.5f}  (true: {sigma2_repeat:.5f})")
print(f"  Reproducibility(AV):  {sigma2_AV:.5f}  (true: {sigma2_op:.5f})")
print(f"  Part-to-Part   (PV):  {sigma2_PV:.5f}  (true: {sigma2_part:.5f})")
print(f"  Gauge R&R (GRR):      {sigma2_GRR:.5f}")

# ============================================================
# Task 5: %Gauge R&R metrics
# ============================================================
k = 5.15   # coverage factor (99% of normal distribution)

study_var_EV  = k * np.sqrt(sigma2_EV)
study_var_AV  = k * np.sqrt(sigma2_AV)
study_var_PV  = k * np.sqrt(sigma2_PV)
study_var_GRR = k * np.sqrt(sigma2_GRR)

pct_EV  = (study_var_EV  / TOLERANCE) * 100
pct_AV  = (study_var_AV  / TOLERANCE) * 100
pct_PV  = (study_var_PV  / TOLERANCE) * 100
pct_GRR = (study_var_GRR / TOLERANCE) * 100

ndc = int(np.sqrt(2) * np.sqrt(sigma2_PV) / np.sqrt(sigma2_GRR)) if sigma2_GRR > 0 else 0

print("\n=== Gauge R&R Summary Report ===")
print(f"  Tolerance:              {TOLERANCE:.2f} mm")
print(f"  %Repeatability (EV):    {pct_EV:.1f}%  (StudyVar = {study_var_EV:.4f} mm)")
print(f"  %Reproducibility (AV):  {pct_AV:.1f}%  (StudyVar = {study_var_AV:.4f} mm)")
print(f"  %Total Gauge R&R:       {pct_GRR:.1f}%  (StudyVar = {study_var_GRR:.4f} mm)")
print(f"  %Part Variation (PV):   {pct_PV:.1f}%  (StudyVar = {study_var_PV:.4f} mm)")
print(f"  Number of Distinct Categories (ndc): {ndc}")

assessment = ("Acceptable" if pct_GRR < 10
              else "Marginal" if pct_GRR < 30
              else "Unacceptable")
print(f"\n  Measurement system assessment: {assessment} (%GRR = {pct_GRR:.1f}%)")

# ============================================================
# Task 6: Visualisation
# ============================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# --- Panel A: bar chart of study variation ---
components = ["Repeatability\n(EV)", "Reproducibility\n(AV)",
              "Part-to-Part\n(PV)", "Total\nGRR"]
values     = [study_var_EV, study_var_AV, study_var_PV, study_var_GRR]
pct_labels = [pct_EV, pct_AV, pct_PV, pct_GRR]
colours    = ["steelblue", "darkorange", "seagreen", "firebrick"]

bars = ax1.bar(components, values, color=colours, edgecolor="white", alpha=0.85)
ax1.axhline(TOLERANCE, color="red", linestyle="--", linewidth=1.5,
            label=f"Tolerance = {TOLERANCE:.2f} mm")
for bar, pct in zip(bars, pct_labels):
    ax1.text(bar.get_x() + bar.get_width() / 2,
             bar.get_height() + 0.005,
             f"{pct:.1f}%",
             ha="center", va="bottom", fontsize=9, fontweight="bold")
ax1.set_title("Gauge R&R — Study Variation by Component", fontsize=11)
ax1.set_ylabel("Study Variation (mm) [= 5.15 × σ]")
ax1.set_ylim(0, TOLERANCE * 1.15)
ax1.legend(fontsize=9)
ax1.grid(axis="y", alpha=0.3)

# --- Panel B: scatter of measurements by operator ---
cmap = plt.get_cmap("tab10")
jitter = np.random.uniform(-0.08, 0.08, size=len(df))
for part_id in range(1, n_parts + 1):
    mask = df["Part"] == part_id
    ax2.scatter(df.loc[mask, "Operator"] + jitter[mask.values],
                df.loc[mask, "Measurement"],
                color=cmap((part_id - 1) / n_parts),
                s=40, alpha=0.85,
                label=f"Part {part_id}")
ax2.axhline(LSL, color="red", linestyle="--", linewidth=1.5, label=f"LSL = {LSL}")
ax2.axhline(USL, color="red", linestyle="--", linewidth=1.5, label=f"USL = {USL}")
ax2.set_xticks([1, 2, 3])
ax2.set_xticklabels(["Operator 1", "Operator 2", "Operator 3"])
ax2.set_xlabel("Operator")
ax2.set_ylabel("Measurement (mm)")
ax2.set_title("Measurements by Operator (coloured by Part)", fontsize=11)
ax2.legend(fontsize=7, ncol=2, loc="lower right")
ax2.grid(alpha=0.3)

plt.suptitle("Gauge R&R Study — Shaft Diameter Calliper", fontsize=13)
plt.tight_layout()
plt.savefig("module-03-lesson-02-gauge-rr.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-03-lesson-02-gauge-rr.png")
