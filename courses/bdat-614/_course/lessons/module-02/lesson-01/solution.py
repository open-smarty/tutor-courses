"""
Module 2, Lesson 1 — Xbar-R Control Charts (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt

subgroups = [
    [10.02, 10.05, 9.98, 10.01, 10.03],
    [10.04, 10.00, 10.06, 9.99, 10.02],
    [9.97, 10.03, 10.01, 10.00, 9.99],
    [10.05, 10.02, 10.04, 10.01, 10.03],
    [10.00, 9.98, 10.02, 10.05, 10.01],
    [10.03, 10.01, 9.99, 10.04, 10.02],
    [10.08, 10.06, 10.07, 10.09, 10.05],
    [10.01, 10.03, 10.00, 10.02, 10.04],
    [9.99, 10.00, 10.01, 9.98, 10.02],
    [10.02, 10.04, 10.01, 10.03, 10.00],
]

A2, D3, D4 = 0.577, 0.0, 2.114

data = np.array(subgroups)
xbar_values = data.mean(axis=1)
r_values = data.max(axis=1) - data.min(axis=1)

xbar_bar = xbar_values.mean()
r_bar = r_values.mean()

xbar_ucl = xbar_bar + A2 * r_bar
xbar_lcl = xbar_bar - A2 * r_bar
r_ucl = D4 * r_bar
r_lcl = D3 * r_bar

print("=== Xbar-R Control Chart Limits ===")
print(f"Grand Mean (x̄̄):   {xbar_bar:.4f}")
print(f"Average Range (R̄): {r_bar:.4f}")
print(f"Xbar UCL: {xbar_ucl:.4f}  CL: {xbar_bar:.4f}  LCL: {xbar_lcl:.4f}")
print(f"R    UCL: {r_ucl:.4f}   CL: {r_bar:.4f}  LCL: {r_lcl:.4f}")

x_ooc = [i for i, v in enumerate(xbar_values) if v > xbar_ucl or v < xbar_lcl]
r_ooc = [i for i, v in enumerate(r_values)    if v > r_ucl    or v < r_lcl]
print(f"\nOut-of-control Xbar points: subgroups {[i+1 for i in x_ooc]}")
print(f"Out-of-control R     points: subgroups {[i+1 for i in r_ooc]}")

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 7))
k = range(1, len(subgroups) + 1)

for ax, values, cl, ucl, lcl, ooc, title in [
    (ax1, xbar_values, xbar_bar, xbar_ucl, xbar_lcl, x_ooc, "Xbar Chart — Bolt Diameter (mm)"),
    (ax2, r_values,    r_bar,    r_ucl,    r_lcl,    r_ooc, "R Chart — Bolt Diameter (mm)"),
]:
    ax.plot(k, values, 'b-o', label='Value')
    ax.axhline(cl,  color='green', linestyle='-',  label=f'CL={cl:.4f}')
    ax.axhline(ucl, color='red',   linestyle='--', label=f'UCL={ucl:.4f}')
    ax.axhline(lcl, color='red',   linestyle='--', label=f'LCL={lcl:.4f}')
    for i in ooc:
        ax.plot(i + 1, values[i], 'ro', markersize=12, label='Out of control' if i == ooc[0] else '')
    ax.set_title(title)
    ax.set_xlabel('Subgroup')
    ax.legend(loc='upper right', fontsize=8)
    ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('xbar_r_chart.png', dpi=100)
plt.show()
print("\nChart saved as xbar_r_chart.png")
