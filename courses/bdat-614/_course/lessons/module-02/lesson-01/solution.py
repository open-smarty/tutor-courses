"""
BDAT 614 — Module 2, Lesson 1
Solution: Xbar-R Control Charts for Fill Weight Data
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(7)

# Control chart constants for subgroup size n=5
A2 = 0.577
D3 = 0.0
D4 = 2.114

# ============================================================
# Task 1: Generate subgroup data
# ============================================================
data = np.random.normal(loc=500, scale=1.5, size=(25, 5))

# ============================================================
# Task 2: Compute subgroup statistics
# ============================================================
subgroup_means  = np.mean(data, axis=1)
subgroup_ranges = np.max(data, axis=1) - np.min(data, axis=1)

xbar_bar = np.mean(subgroup_means)
R_bar    = np.mean(subgroup_ranges)

print(f"Grand mean (x̄̄):      {xbar_bar:.3f} g")
print(f"Average range (R̄):    {R_bar:.3f} g")

# ============================================================
# Task 3: Compute control limits
# ============================================================
UCL_xbar = xbar_bar + A2 * R_bar
LCL_xbar = xbar_bar - A2 * R_bar
UCL_R    = D4 * R_bar
LCL_R    = D3 * R_bar

print(f"\nXbar chart — UCL: {UCL_xbar:.3f}  CL: {xbar_bar:.3f}  LCL: {LCL_xbar:.3f}")
print(f"R chart    — UCL: {UCL_R:.3f}  CL: {R_bar:.3f}  LCL: {LCL_R:.3f}")

# ============================================================
# Task 4: Plot both charts
# ============================================================
subgroup_numbers = np.arange(1, 26)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))

def plot_chart(ax, values, cl, ucl, lcl, title, ylabel):
    """Plot a single control chart panel."""
    ax.plot(subgroup_numbers, values, color="steelblue",
            marker="o", markersize=5, linewidth=1.5, label="Subgroup statistic")

    ax.axhline(ucl, color="red",   linestyle="--", linewidth=1.5, label=f"UCL = {ucl:.3f}")
    ax.axhline(cl,  color="green", linestyle="--", linewidth=1.5, label=f"CL  = {cl:.3f}")
    ax.axhline(lcl, color="red",   linestyle="--", linewidth=1.5, label=f"LCL = {lcl:.3f}")

    # Flag out-of-control points
    ooc = (values > ucl) | (values < lcl)
    if ooc.any():
        ax.scatter(subgroup_numbers[ooc], values[ooc], color="red", s=80,
                   zorder=5, label="Out of control")

    ax.set_xlabel("Subgroup number")
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.legend(loc="upper right", fontsize=8)
    ax.grid(True, alpha=0.3)

plot_chart(ax1, subgroup_means,  xbar_bar, UCL_xbar, LCL_xbar,
           "Xbar Chart — Fill Weight (n=5)", "Subgroup mean (g)")

plot_chart(ax2, subgroup_ranges, R_bar, UCL_R, LCL_R,
           "R Chart — Fill Weight (n=5)", "Subgroup range (g)")

plt.suptitle("Xbar-R Control Charts: Bottling Machine Fill Weight", fontsize=13)
plt.tight_layout()
plt.savefig("module-02-lesson-01-xbar-r.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-02-lesson-01-xbar-r.png")
