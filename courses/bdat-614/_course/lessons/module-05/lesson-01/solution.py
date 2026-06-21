"""
BDAT 614 — Module 5, Lesson 1
Solution: Acceptance Sampling Plans and OC Curves
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom

np.random.seed(614)

# Quality benchmarks
AQL  = 0.01   # Acceptable Quality Level
LTPD = 0.06   # Lot Tolerance Percent Defective

# Range of incoming defect rates to evaluate
p_values = np.linspace(0, 0.20, 200)

# Three sampling plans to compare: (n, c, label)
plans = [
    (50,  2, "n=50, c=2"),
    (100, 2, "n=100, c=2"),
    (100, 4, "n=100, c=4"),
]

# ============================================================
# Task 1: Compute the OC curve for each plan
# ============================================================
oc_curves = []
for n, c, label in plans:
    pa = binom.cdf(c, n, p_values)   # P(D <= c) for each p
    oc_curves.append(pa)

# ============================================================
# Task 2: Print risk table
# ============================================================
print(f"{'Plan':<18} {'P(acc|AQL)':>10} {'α (prod risk)':>14} {'P(acc|LTPD)':>12} {'β (cons risk)':>14}")
print("-" * 72)
for (n, c, label), pa_curve in zip(plans, oc_curves):
    p_acc_aql  = binom.cdf(c, n, AQL)
    p_acc_ltpd = binom.cdf(c, n, LTPD)
    alpha = 1 - p_acc_aql
    beta  = p_acc_ltpd
    print(f"{label:<18} {p_acc_aql:>10.4f} {alpha:>14.4f} {p_acc_ltpd:>12.4f} {beta:>14.4f}")

# ============================================================
# Task 3: Plot the OC curves
# ============================================================
colours = ["steelblue", "darkorange", "seagreen"]

fig, ax = plt.subplots(figsize=(10, 6))

for (n, c, label), pa_curve, colour in zip(plans, oc_curves, colours):
    ax.plot(p_values, pa_curve, color=colour, linewidth=2, label=label)

# Reference lines
ax.axvline(AQL,  color="red",    linestyle="--", linewidth=1.5, label=f"AQL = {AQL}")
ax.axvline(LTPD, color="darkorange", linestyle=":",  linewidth=1.5, label=f"LTPD = {LTPD}")
ax.axhline(0.10, color="grey",   linestyle="--", linewidth=1.0, label="β = 0.10 target")
ax.axhline(0.95, color="grey",   linestyle=":",  linewidth=1.0, label="1−α = 0.95 target")

ax.set_xlabel("Incoming defect rate p", fontsize=12)
ax.set_ylabel("P(accept)", fontsize=12)
ax.set_title("Operating Characteristic (OC) Curves — Single Sampling Plans", fontsize=13)
ax.set_xlim(0, 0.20)
ax.set_ylim(0, 1.05)
ax.legend(loc="upper right", fontsize=9)
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("module-05-lesson-01-oc-curves.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-05-lesson-01-oc-curves.png")
