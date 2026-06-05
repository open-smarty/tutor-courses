"""BDAT 614 — Module 3, Lesson 1
Solution: Process Capability Analysis — Cp and Cpk"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

rng = np.random.default_rng(seed=7)

LSL = 496.0
USL = 504.0

# ── Scenario A: Centred process ───────────────────────────────────────────────
mu_A, sigma_A = 500.0, 0.9
data_A = rng.normal(mu_A, sigma_A, 200)

cp_A  = (USL - LSL) / (6 * sigma_A)
cpu_A = (USL - mu_A) / (3 * sigma_A)
cpl_A = (mu_A - LSL) / (3 * sigma_A)
cpk_A = min(cpu_A, cpl_A)

# ── Scenario B: Off-centre process ────────────────────────────────────────────
mu_B, sigma_B = 501.0, 0.9
data_B = rng.normal(mu_B, sigma_B, 200)

cp_B  = (USL - LSL) / (6 * sigma_B)   # same spread, so same Cp
cpu_B = (USL - mu_B) / (3 * sigma_B)
cpl_B = (mu_B - LSL) / (3 * sigma_B)
cpk_B = min(cpu_B, cpl_B)

# ── Summary ───────────────────────────────────────────────────────────────────
print("Process Capability Summary")
print(f"{'Scenario':<25} {'Cp':>6} {'Cpk':>6}")
print("-" * 40)
print(f"{'A — Centred (mu=500)':<25} {cp_A:>6.3f} {cpk_A:>6.3f}")
print(f"{'B — Off-centre (mu=501)':<25} {cp_B:>6.3f} {cpk_B:>6.3f}")

# Expected nonconforming fraction
for label, mu, sigma in [("A", mu_A, sigma_A), ("B", mu_B, sigma_B)]:
    p_nc = stats.norm.cdf(LSL, mu, sigma) + (1 - stats.norm.cdf(USL, mu, sigma))
    print(f"  Scenario {label}: estimated nonconforming = {p_nc*100:.4f}%")

# ── Plot ──────────────────────────────────────────────────────────────────────
scenarios = [
    (data_A, mu_A, sigma_A, cp_A, cpk_A, "A: Centred (mu=500 g)"),
    (data_B, mu_B, sigma_B, cp_B, cpk_B, "B: Off-centre (mu=501 g)"),
]

fig, axes = plt.subplots(1, 2, figsize=(13, 5))

for ax, (data, mu, sigma, cp, cpk, title) in zip(axes, scenarios):
    ax.hist(data, bins=25, density=True, alpha=0.55, color='steelblue', edgecolor='white')
    x_range = np.linspace(mu - 5 * sigma, mu + 5 * sigma, 300)
    ax.plot(x_range, stats.norm.pdf(x_range, mu, sigma), 'k-', linewidth=2, label='Normal fit')
    ax.axvline(LSL, color='red', linestyle='--', linewidth=1.8, label=f'LSL={LSL}')
    ax.axvline(USL, color='red', linestyle='--', linewidth=1.8, label=f'USL={USL}')
    ax.axvline(mu,  color='blue', linestyle=':',  linewidth=1.8, label=f'mu={mu}')
    ax.text(0.05, 0.95,
            f'Cp  = {cp:.3f}\nCpk = {cpk:.3f}',
            transform=ax.transAxes, fontsize=11,
            verticalalignment='top',
            bbox=dict(boxstyle='round,pad=0.3', facecolor='lightyellow', edgecolor='gray'))
    ax.set_title(f'Scenario {title}', fontsize=12)
    ax.set_xlabel('Fill Weight (g)')
    ax.set_ylabel('Density')
    ax.legend(fontsize=9)
    ax.grid(alpha=0.3)

plt.suptitle('Process Capability Analysis — Cp and Cpk', fontsize=13, y=1.01)
plt.tight_layout()
plt.savefig('capability_analysis.png', dpi=150)
plt.show()
