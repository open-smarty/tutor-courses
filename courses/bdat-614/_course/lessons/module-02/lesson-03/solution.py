"""BDAT 614 — Module 2, Lesson 3
Solution: Attribute Control Charts — p, np, c, and u Charts"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

rng = np.random.default_rng(seed=42)

k = 20
p_true = 0.04
u_true = 0.018

# ── Simulated data ───────────────────────────────────────────────────────────
n_sizes = rng.integers(350, 601, size=k)

# Defective-item counts (for p chart)
D_i = rng.binomial(n_sizes, p_true)
p_i = D_i / n_sizes

# Defect counts (for u chart)
c_i = rng.poisson(u_true * n_sizes)
u_i = c_i / n_sizes

# ── p Chart ──────────────────────────────────────────────────────────────────
p_bar = D_i.sum() / n_sizes.sum()
se_p = np.sqrt(p_bar * (1 - p_bar) / n_sizes)
ucl_p = p_bar + 3 * se_p
lcl_p = np.maximum(0, p_bar - 3 * se_p)

oos_p = (p_i > ucl_p) | (p_i < lcl_p)

fig, axes = plt.subplots(2, 1, figsize=(12, 8))
batches = np.arange(1, k + 1)

ax = axes[0]
ax.plot(batches, p_i, marker='o', color='steelblue', label='p_i')
ax.axhline(p_bar, color='green', linestyle='--', linewidth=1.5, label=f'CL = {p_bar:.4f}')
ax.step(batches, ucl_p, color='red', linestyle='--', linewidth=1.2, where='mid', label='UCL/LCL')
ax.step(batches, lcl_p, color='red', linestyle='--', linewidth=1.2, where='mid')
ax.scatter(batches[oos_p], p_i[oos_p], color='red', zorder=5, s=80, label='OOC')
ax.set_title('p Chart — Proportion Defective (variable n)', fontsize=13)
ax.set_xlabel('Batch')
ax.set_ylabel('Proportion Defective (p_i)')
ax.legend(fontsize=9)
ax.set_xlim(0.5, k + 0.5)
ax.grid(alpha=0.3)

print("p Chart Summary")
print(f"  p-bar = {p_bar:.4f}")
print(f"  # out-of-control: {oos_p.sum()}")

# ── u Chart ──────────────────────────────────────────────────────────────────
u_bar = c_i.sum() / n_sizes.sum()
se_u = np.sqrt(u_bar / n_sizes)
ucl_u = u_bar + 3 * se_u
lcl_u = np.maximum(0, u_bar - 3 * se_u)

oos_u = (u_i > ucl_u) | (u_i < lcl_u)

ax = axes[1]
ax.plot(batches, u_i, marker='s', color='darkorange', label='u_i')
ax.axhline(u_bar, color='green', linestyle='--', linewidth=1.5, label=f'CL = {u_bar:.4f}')
ax.step(batches, ucl_u, color='red', linestyle='--', linewidth=1.2, where='mid', label='UCL/LCL')
ax.step(batches, lcl_u, color='red', linestyle='--', linewidth=1.2, where='mid')
ax.scatter(batches[oos_u], u_i[oos_u], color='red', zorder=5, s=80, label='OOC')
ax.set_title('u Chart — Defects per Unit (variable n)', fontsize=13)
ax.set_xlabel('Batch')
ax.set_ylabel('Defects per Unit (u_i)')
ax.legend(fontsize=9)
ax.set_xlim(0.5, k + 0.5)
ax.grid(alpha=0.3)

print("\nu Chart Summary")
print(f"  u-bar = {u_bar:.4f}")
print(f"  # out-of-control: {oos_u.sum()}")

# Summary table
df = pd.DataFrame({
    'Batch': batches,
    'n_i': n_sizes,
    'D_i': D_i,
    'p_i': p_i.round(4),
    'UCL_p': ucl_p.round(4),
    'c_i': c_i,
    'u_i': u_i.round(4),
    'UCL_u': ucl_u.round(4),
})
print("\nData Table (first 5 rows):")
print(df.head().to_string(index=False))

plt.tight_layout()
plt.savefig('attribute_charts.png', dpi=150)
plt.show()
