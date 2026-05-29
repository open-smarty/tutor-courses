"""
Module 5, Lesson 1 — Acceptance Sampling OC Curves (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom

n, c = 100, 2
AQL, LTPD = 0.02, 0.08

p_values = np.arange(0, 0.151, 0.001)
pa_values = binom.cdf(c, n, p_values)

pa_at_aql  = binom.cdf(c, n, AQL)
pa_at_ltpd = binom.cdf(c, n, LTPD)
alpha = 1 - pa_at_aql
beta  = pa_at_ltpd

print("=== Single Sampling Plan OC Curve ===")
print(f"n={n}, c={c}")
print(f"Pa at AQL={AQL*100:.0f}%:   {pa_at_aql:.4f}  (Producer's risk α = {alpha:.4f})")
print(f"Pa at LTPD={LTPD*100:.0f}%: {pa_at_ltpd:.4f}  (Consumer's risk β = {beta:.4f})")

fig, ax = plt.subplots(figsize=(9, 6))
ax.plot(p_values * 100, pa_values, 'b-', linewidth=2, label=f'OC Curve (n={n}, c={c})')

ax.axvline(AQL * 100,  color='green', linestyle='--', linewidth=1.5,
           label=f'AQL={AQL*100:.0f}%  Pa={pa_at_aql:.2f}  α={alpha:.2f}')
ax.axvline(LTPD * 100, color='red',   linestyle='--', linewidth=1.5,
           label=f'LTPD={LTPD*100:.0f}%  Pa={pa_at_ltpd:.2f}  β={beta:.2f}')
ax.axhline(pa_at_aql,  color='green', linestyle=':', linewidth=1)
ax.axhline(pa_at_ltpd, color='red',   linestyle=':', linewidth=1)

ax.set_xlabel('Proportion Defective (%)')
ax.set_ylabel('Probability of Acceptance (Pa)')
ax.set_title(f'OC Curve — Single Sampling Plan (n={n}, c={c})')
ax.legend()
ax.grid(True, alpha=0.3)
ax.set_xlim(0, 15)
ax.set_ylim(0, 1.05)
plt.tight_layout()
plt.savefig('oc_curve.png', dpi=100)
plt.show()
