"""
Module 2, Lesson 2 — I-MR Charts (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt

response_times = [
    245, 238, 252, 241, 260, 255, 248, 272,
    250, 243, 258, 247, 265, 253, 246, 270,
    242, 251, 310, 249, 257, 244, 263, 250
]

E2, D4, D3 = 2.66, 3.267, 0.0

x = np.array(response_times)
x_bar = x.mean()
mr_values = np.abs(np.diff(x))
mr_bar = mr_values.mean()

i_ucl = x_bar + E2 * mr_bar
i_lcl = x_bar - E2 * mr_bar
mr_ucl = D4 * mr_bar
mr_lcl = 0.0

print("=== I-MR Chart Limits ===")
print(f"x̄  = {x_bar:.3f} ms")
print(f"MR̄ = {mr_bar:.3f} ms")
print(f"I-Chart:  UCL={i_ucl:.3f}  CL={x_bar:.3f}  LCL={i_lcl:.3f}")
print(f"MR-Chart: UCL={mr_ucl:.3f}  CL={mr_bar:.3f}  LCL={mr_lcl:.3f}")

x_ooc  = [i for i, v in enumerate(x)         if v > i_ucl  or v < i_lcl]
mr_ooc = [i for i, v in enumerate(mr_values) if v > mr_ucl]
print(f"\nOut-of-control I-Chart  obs: {[i+1 for i in x_ooc]}")
print(f"Out-of-control MR-Chart obs: {[i+2 for i in mr_ooc]}")

hours_x  = np.arange(1, len(x) + 1)
hours_mr = np.arange(2, len(x) + 1)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 7))

ax1.plot(hours_x, x, 'b-o', markersize=5)
ax1.axhline(x_bar, color='green', linestyle='-',  label=f'CL={x_bar:.1f}')
ax1.axhline(i_ucl, color='red',   linestyle='--', label=f'UCL={i_ucl:.1f}')
ax1.axhline(i_lcl, color='red',   linestyle='--', label=f'LCL={i_lcl:.1f}')
for i in x_ooc:
    ax1.plot(i+1, x[i], 'ro', markersize=10)
ax1.set_title('I-Chart — Server Response Time (ms)')
ax1.set_xlabel('Hour')
ax1.set_ylabel('Response Time (ms)')
ax1.legend(fontsize=8)
ax1.grid(True, alpha=0.3)

ax2.plot(hours_mr, mr_values, 'orange', marker='o', markersize=5)
ax2.axhline(mr_bar, color='green', linestyle='-',  label=f'CL={mr_bar:.1f}')
ax2.axhline(mr_ucl, color='red',   linestyle='--', label=f'UCL={mr_ucl:.1f}')
ax2.axhline(mr_lcl, color='red',   linestyle='--', label=f'LCL={mr_lcl:.1f}')
for i in mr_ooc:
    ax2.plot(i+2, mr_values[i], 'ro', markersize=10)
ax2.set_title('MR-Chart — Server Response Time (ms)')
ax2.set_xlabel('Hour')
ax2.set_ylabel('Moving Range (ms)')
ax2.legend(fontsize=8)
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('imr_chart.png', dpi=100)
plt.show()
print("\nChart saved as imr_chart.png")
