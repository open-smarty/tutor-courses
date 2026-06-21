"""
BDAT 614 — Module 5, Lesson 2
Solution: Six Sigma — DPMO, Performance Levels, and DMAIC Roadmap
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

np.random.seed(614)

# ============================================================
# Task 1: Helper functions
# ============================================================
def dpmo(defects, units, opportunities):
    """Compute Defects Per Million Opportunities."""
    return (defects / (units * opportunities)) * 1_000_000

def sigma_level(dpmo_val):
    """Convert DPMO to sigma level (with 1.5-sigma long-run shift)."""
    if dpmo_val <= 0:
        return 6.0
    if dpmo_val >= 1_000_000:
        return 0.0
    return norm.ppf(1 - dpmo_val / 1_000_000) + 1.5

# ============================================================
# Task 2: Six Sigma performance table
# ============================================================
target_sigmas = [1, 2, 3, 4, 5, 6]

print("=" * 62)
print(f"{'Sigma':>6} {'DPMO':>10} {'Yield (%)':>10} {'Round-trip σ':>14}")
print("-" * 62)

for s in target_sigmas:
    dpmo_val = (1 - norm.cdf(s - 1.5)) * 1_000_000
    yield_pct = (1 - dpmo_val / 1_000_000) * 100
    rt_sigma  = sigma_level(dpmo_val)
    print(f"{s:>6} {dpmo_val:>10.1f} {yield_pct:>10.4f} {rt_sigma:>14.4f}")

print("=" * 62)

# ============================================================
# Task 3: Process DPMO and sigma level table
# ============================================================
process_data = [
    ("Assembly line A",    342, 10000, 5),
    ("Call centre",       1080, 12000, 4),
    ("Invoice processing",  45,  8000, 3),
    ("Surgical unit",        8,  5000, 7),
    ("Software releases",  150,  2000, 10),
]

print("\n" + "=" * 80)
print(f"{'Process':<22} {'Defects':>8} {'Units':>7} {'Opps':>5} {'DPMO':>10} {'Sigma':>7}")
print("-" * 80)

process_results = []
for name, defects, units, opps in process_data:
    d = dpmo(defects, units, opps)
    s = sigma_level(d)
    process_results.append((name, d, s))
    print(f"{name:<22} {defects:>8} {units:>7} {opps:>5} {d:>10.1f} {s:>7.3f}")

print("=" * 80)

# ============================================================
# Task 4: Sigma vs DPMO reference curve
# ============================================================
dpmo_range   = np.logspace(0, 6, 500)
sigma_curve  = np.clip([sigma_level(d) for d in dpmo_range], 0, 6.5)

fig, ax = plt.subplots(figsize=(10, 6))

ax.plot(dpmo_range, sigma_curve, color="steelblue", linewidth=2, label="Sigma level curve")

# Overlay the five processes
for name, d, s in process_results:
    ax.scatter(d, s, color="crimson", s=80, zorder=5)
    ax.annotate(name, xy=(d, s), xytext=(5, 4), textcoords="offset points", fontsize=8)

# Six Sigma target line
ax.axhline(6.0, color="green", linestyle="--", linewidth=1.5, label="Six Sigma target (6σ)")

ax.set_xscale("log")
ax.set_xlabel("DPMO (log scale)", fontsize=12)
ax.set_ylabel("Sigma Level", fontsize=12)
ax.set_title("Six Sigma Performance Curve: Sigma Level vs DPMO", fontsize=13)
ax.set_ylim(0, 7)
ax.legend(fontsize=10)
ax.grid(True, which="both", alpha=0.3)

plt.tight_layout()
plt.savefig("module-05-lesson-02-sigma-curve.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-05-lesson-02-sigma-curve.png")
