"""
BDAT 614 — Module 2, Lesson 2
Solution: Individuals and Moving Range (I-MR) Charts
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(13)

d2 = 1.128
D4 = 3.267

# ============================================================
# Task 1: Generate data with process shift
# ============================================================
x = np.random.normal(245, 18, 30)
x[21:] += 60   # shift at observation 22 (0-based index 21)

# ============================================================
# Task 2: Moving range
# ============================================================
MR     = np.abs(np.diff(x))
MR_bar = np.mean(MR)
x_bar  = np.mean(x)

print(f"x̄ = {x_bar:.2f} ms")
print(f"MR̄ = {MR_bar:.2f} ms")

# ============================================================
# Task 3: Control limits
# ============================================================
UCL_I  = x_bar + 3 * (MR_bar / d2)
LCL_I  = x_bar - 3 * (MR_bar / d2)
UCL_MR = D4 * MR_bar
LCL_MR = 0.0

print(f"\nI chart  — UCL: {UCL_I:.2f}  CL: {x_bar:.2f}  LCL: {LCL_I:.2f}")
print(f"MR chart — UCL: {UCL_MR:.2f}  CL: {MR_bar:.2f}  LCL: {LCL_MR:.2f}")

# ============================================================
# Task 4: I-MR charts
# ============================================================
obs_I  = np.arange(1, 31)
obs_MR = np.arange(2, 31)

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))

# --- I chart ---
ax1.plot(obs_I, x, color="steelblue", marker="o", markersize=4,
         linewidth=1.5, label="Individual value")
ax1.axhline(UCL_I, color="red",   linestyle="--", linewidth=1.5,
            label=f"UCL = {UCL_I:.1f}")
ax1.axhline(x_bar,  color="green", linestyle="--", linewidth=1.5,
            label=f"CL  = {x_bar:.1f}")
ax1.axhline(LCL_I, color="red",   linestyle="--", linewidth=1.5,
            label=f"LCL = {LCL_I:.1f}")

ooc_I = (x > UCL_I) | (x < LCL_I)
if ooc_I.any():
    ax1.scatter(obs_I[ooc_I], x[ooc_I], color="red", s=80,
                zorder=5, label="Out of control")

ax1.set_xlabel("Observation number")
ax1.set_ylabel("Response time (ms)")
ax1.set_title("Individuals (I) Chart — API Response Time")
ax1.legend(loc="upper left", fontsize=8)
ax1.grid(True, alpha=0.3)

# --- MR chart ---
ax2.plot(obs_MR, MR, color="darkorange", marker="o", markersize=4,
         linewidth=1.5, label="Moving range")
ax2.axhline(UCL_MR, color="red",   linestyle="--", linewidth=1.5,
            label=f"UCL = {UCL_MR:.1f}")
ax2.axhline(MR_bar, color="green", linestyle="--", linewidth=1.5,
            label=f"CL  = {MR_bar:.1f}")
ax2.axhline(LCL_MR, color="red",   linestyle="--", linewidth=1.5,
            label=f"LCL = {LCL_MR:.1f}")

ooc_MR = MR > UCL_MR
if ooc_MR.any():
    ax2.scatter(obs_MR[ooc_MR], MR[ooc_MR], color="red", s=80,
                zorder=5, label="Out of control")

ax2.set_xlabel("Observation number")
ax2.set_ylabel("Moving range (ms)")
ax2.set_title("Moving Range (MR) Chart — API Response Time")
ax2.legend(loc="upper left", fontsize=8)
ax2.grid(True, alpha=0.3)

plt.suptitle("I-MR Control Charts: API Response Time (shift at obs 22)", fontsize=13)
plt.tight_layout()
plt.savefig("module-02-lesson-02-imr.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-02-lesson-02-imr.png")
