"""
Module 3, Lesson 1 — Process Capability Analysis (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(42)
diameters = np.random.normal(loc=20.15, scale=0.18, size=80)

LSL = 19.5
USL = 20.5

mu    = diameters.mean()
sigma = diameters.std(ddof=1)

Cp  = (USL - LSL) / (6 * sigma)
Cpk = min((USL - mu) / (3 * sigma), (mu - LSL) / (3 * sigma))

def interpret_capability(cpk_value):
    if cpk_value > 1.33:
        return "Excellent (capable)"
    elif cpk_value >= 1.00:
        return "Marginal (borderline capable)"
    else:
        return "Not capable — process produces defects"

print("=== Process Capability Analysis ===")
print(f"Mean (μ):   {mu:.4f} mm")
print(f"Std Dev (σ):{sigma:.4f} mm")
print(f"Cp:   {Cp:.3f}")
print(f"Cpk:  {Cpk:.3f}  → {interpret_capability(Cpk)}")

if Cp > Cpk + 0.1:
    print(f"\nNote: Cp ({Cp:.3f}) >> Cpk ({Cpk:.3f}) — process is off-centre. "
          f"Shifting the mean toward {(USL+LSL)/2:.2f} mm would improve Cpk.")

fig, ax = plt.subplots(figsize=(9, 5))
ax.hist(diameters, bins=15, density=True, alpha=0.6, color='steelblue', label='Data')

x_range = np.linspace(diameters.min() - 0.1, diameters.max() + 0.1, 200)
ax.plot(x_range, stats.norm.pdf(x_range, mu, sigma), 'b-', lw=2, label='Normal fit')

ax.axvline(LSL, color='red',   linestyle='--', lw=2, label=f'LSL={LSL}')
ax.axvline(USL, color='red',   linestyle='--', lw=2, label=f'USL={USL}')
ax.axvline(mu,  color='green', linestyle='-',  lw=2, label=f'μ={mu:.3f}')
ax.axvline((USL+LSL)/2, color='gray', linestyle=':', lw=1, label='Target')

ax.set_title(f'Capability Histogram — Shaft Diameter\nCp={Cp:.3f}  Cpk={Cpk:.3f}')
ax.set_xlabel('Diameter (mm)')
ax.set_ylabel('Density')
ax.legend(fontsize=9)
ax.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig('capability_histogram.png', dpi=100)
plt.show()
