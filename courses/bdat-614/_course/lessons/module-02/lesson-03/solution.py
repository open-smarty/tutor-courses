"""
Module 2, Lesson 3 — Attribute Control Charts (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt

sample_sizes_p = np.array([150, 160, 145, 155, 150, 165, 148, 152, 158, 150,
                            153, 147, 161, 156, 149, 154, 160, 151, 157, 155])
complaints     = np.array([6, 8, 5, 10, 7, 9, 4, 11, 8, 6,
                           7, 5, 9, 12, 6, 8, 10, 7, 9, 6])

p_bar = complaints.sum() / sample_sizes_p.sum()
p_values = complaints / sample_sizes_p
p_ucl = p_bar + 3 * np.sqrt(p_bar * (1 - p_bar) / sample_sizes_p)
p_lcl = np.maximum(0, p_bar - 3 * np.sqrt(p_bar * (1 - p_bar) / sample_sizes_p))

batches_per_day = np.array([50, 60, 55, 70, 45, 65, 58, 52, 67, 53])
total_errors    = np.array([12, 14,  8, 21,  9, 16, 13, 10, 20, 11])

u_bar    = total_errors.sum() / batches_per_day.sum()
u_values = total_errors / batches_per_day
u_ucl    = u_bar + 3 * np.sqrt(u_bar / batches_per_day)
u_lcl    = np.maximum(0, u_bar - 3 * np.sqrt(u_bar / batches_per_day))

print(f"p-Chart: p̄ = {p_bar:.4f}")
print(f"u-Chart: ū = {u_bar:.4f}")

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))

days_p = np.arange(1, len(sample_sizes_p) + 1)
ax1.plot(days_p, p_values, 'b-o', markersize=5, label='pᵢ')
ax1.axhline(p_bar, color='green', linestyle='-', label=f'p̄={p_bar:.4f}')
ax1.plot(days_p, p_ucl, 'r--', label='UCL')
ax1.plot(days_p, p_lcl, 'r--', label='LCL')
ooc_p = np.where((p_values > p_ucl) | (p_values < p_lcl))[0]
ax1.plot(days_p[ooc_p], p_values[ooc_p], 'ro', markersize=10, label='OOC')
ax1.set_title('p-Chart — Call Centre Complaint Proportion')
ax1.set_xlabel('Day')
ax1.set_ylabel('Proportion Defective')
ax1.legend(fontsize=8)
ax1.grid(True, alpha=0.3)

days_u = np.arange(1, len(batches_per_day) + 1)
ax2.plot(days_u, u_values, 'b-o', markersize=5, label='uᵢ')
ax2.axhline(u_bar, color='green', linestyle='-', label=f'ū={u_bar:.4f}')
ax2.plot(days_u, u_ucl, 'r--', label='UCL')
ax2.plot(days_u, u_lcl, 'r--', label='LCL')
ooc_u = np.where((u_values > u_ucl) | (u_values < u_lcl))[0]
ax2.plot(days_u[ooc_u], u_values[ooc_u], 'ro', markersize=10, label='OOC')
ax2.set_title('u-Chart — Pipeline Errors per Batch')
ax2.set_xlabel('Day')
ax2.set_ylabel('Defects per Unit')
ax2.legend(fontsize=8)
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('attribute_charts.png', dpi=100)
plt.show()
