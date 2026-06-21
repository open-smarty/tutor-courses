"""
BDAT 614 — Module 6, Lesson 2
Solution: Big Data Applications in SQC — EWMA, CUSUM, and ML Integration
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(614)

# ============================================================
# Process parameters
# ============================================================
mu_0  = 10.0
sigma = 1.0
n_obs = 200
shift_point = 100
shift_size  = 1.5

lam = 0.2
L   = 3.0
K   = 0.5 * sigma
H   = 5.0 * sigma

# ============================================================
# Task 1: Generate process data with injected shift
# ============================================================
in_control  = np.random.normal(mu_0,                     sigma, shift_point)
out_control = np.random.normal(mu_0 + shift_size * sigma, sigma, n_obs - shift_point)
data = np.concatenate([in_control, out_control])

# ============================================================
# Task 2: EWMA chart
# ============================================================
z        = np.zeros(n_obs)
UCL_ewma = np.zeros(n_obs)
LCL_ewma = np.zeros(n_obs)

z[0] = mu_0
spread_0 = L * sigma * np.sqrt((lam / (2 - lam)) * (1 - (1 - lam) ** 2))
UCL_ewma[0] = mu_0 + spread_0
LCL_ewma[0] = mu_0 - spread_0

for t in range(1, n_obs):
    z[t] = lam * data[t] + (1 - lam) * z[t - 1]
    spread_t = L * sigma * np.sqrt((lam / (2 - lam)) * (1 - (1 - lam) ** (2 * (t + 1))))
    UCL_ewma[t] = mu_0 + spread_t
    LCL_ewma[t] = mu_0 - spread_t

ewma_detect = None
for t in range(shift_point, n_obs):
    if z[t] > UCL_ewma[t] or z[t] < LCL_ewma[t]:
        ewma_detect = t
        break

print(f"EWMA detected shift at observation: {ewma_detect + 1}")

# ============================================================
# Task 3: Tabular CUSUM
# ============================================================
C_plus  = np.zeros(n_obs)
C_minus = np.zeros(n_obs)

for t in range(1, n_obs):
    C_plus[t]  = max(0.0, data[t] - (mu_0 + K) + C_plus[t - 1])
    C_minus[t] = max(0.0, (mu_0 - K) - data[t] + C_minus[t - 1])

cusum_detect = None
for t in range(shift_point, n_obs):
    if C_plus[t] > H or C_minus[t] > H:
        cusum_detect = t
        break

print(f"CUSUM detected shift at observation: {cusum_detect + 1}")

# ============================================================
# Task 4: Individuals chart
# ============================================================
UCL_xbar = mu_0 + 3 * sigma
LCL_xbar = mu_0 - 3 * sigma

xbar_detect = None
for t in range(shift_point, n_obs):
    if data[t] > UCL_xbar or data[t] < LCL_xbar:
        xbar_detect = t
        break

print(f"Xbar chart detected shift at observation: {xbar_detect + 1}")

# ============================================================
# Task 5: Three-panel comparison plot
# ============================================================
obs = np.arange(1, n_obs + 1)

fig, axes = plt.subplots(3, 1, figsize=(13, 12), sharex=True)

def mark_detection(ax, detect_idx, color="darkorange"):
    if detect_idx is not None:
        ax.axvline(detect_idx + 1, color=color, linestyle="-.", linewidth=1.8,
                   label=f"Detection (obs {detect_idx + 1})")

# --- Panel 1: Individuals chart ---
ax1 = axes[0]
ax1.plot(obs, data, color="steelblue", linewidth=1.0, marker="o", markersize=3, label="Observation")
ax1.axhline(UCL_xbar, color="red",   linestyle="--", linewidth=1.5, label=f"UCL={UCL_xbar:.1f}")
ax1.axhline(mu_0,     color="green", linestyle="--", linewidth=1.5, label=f"CL={mu_0:.1f}")
ax1.axhline(LCL_xbar, color="red",   linestyle="--", linewidth=1.5, label=f"LCL={LCL_xbar:.1f}")
ax1.axvline(shift_point + 1, color="blue", linestyle=":", linewidth=1.5, label="Shift injected")
mark_detection(ax1, xbar_detect)

ooc_x = obs[shift_point:][(data[shift_point:] > UCL_xbar) | (data[shift_point:] < LCL_xbar)]
ooc_y = data[shift_point:][(data[shift_point:] > UCL_xbar) | (data[shift_point:] < LCL_xbar)]
ax1.scatter(ooc_x, ooc_y, color="red", s=50, zorder=5)
ax1.set_ylabel("Measurement")
ax1.set_title("Individuals (Xbar) Chart — 3σ Limits")
ax1.legend(loc="upper left", fontsize=8)
ax1.grid(True, alpha=0.3)

# --- Panel 2: EWMA chart ---
ax2 = axes[1]
ax2.plot(obs, z, color="purple", linewidth=1.5, marker="o", markersize=3, label="EWMA z_t")
ax2.plot(obs, UCL_ewma, color="red",   linestyle="--", linewidth=1.5, label="UCL (time-varying)")
ax2.plot(obs, LCL_ewma, color="red",   linestyle="--", linewidth=1.5, label="LCL (time-varying)")
ax2.axhline(mu_0, color="green", linestyle="--", linewidth=1.5, label=f"CL=μ₀={mu_0:.1f}")
ax2.axvline(shift_point + 1, color="blue", linestyle=":", linewidth=1.5, label="Shift injected")
mark_detection(ax2, ewma_detect)

ooc_ew = (z > UCL_ewma) | (z < LCL_ewma)
ooc_ew[:shift_point] = False
ax2.scatter(obs[ooc_ew], z[ooc_ew], color="red", s=50, zorder=5)
ax2.set_ylabel("EWMA statistic z_t")
ax2.set_title(f"EWMA Chart (λ={lam}, L={L})")
ax2.legend(loc="upper left", fontsize=8)
ax2.grid(True, alpha=0.3)

# --- Panel 3: CUSUM chart ---
ax3 = axes[2]
ax3.plot(obs, C_plus,  color="darkorange",  linewidth=1.5, label="C⁺ (upper CUSUM)")
ax3.plot(obs, C_minus, color="teal",        linewidth=1.5, linestyle="--", label="C⁻ (lower CUSUM)")
ax3.axhline(H,    color="red",   linestyle="--", linewidth=1.5, label=f"H = {H:.1f}")
ax3.axhline(0.0,  color="green", linestyle="--", linewidth=1.5, label="Reference = 0")
ax3.axvline(shift_point + 1, color="blue", linestyle=":", linewidth=1.5, label="Shift injected")
mark_detection(ax3, cusum_detect)

ooc_c = (C_plus > H) | (C_minus > H)
ooc_c[:shift_point] = False
ax3.scatter(obs[ooc_c], C_plus[ooc_c], color="red", s=50, zorder=5)
ax3.set_ylabel("CUSUM statistic")
ax3.set_xlabel("Observation number")
ax3.set_title(f"Tabular CUSUM Chart (K={K:.2f}, H={H:.2f})")
ax3.legend(loc="upper left", fontsize=8)
ax3.grid(True, alpha=0.3)

plt.suptitle(f"SPC Chart Comparison — +{shift_size}σ Shift Injected at Observation {shift_point + 1}",
             fontsize=13)
plt.tight_layout()
plt.savefig("module-06-lesson-02-ewma-cusum.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-06-lesson-02-ewma-cusum.png")

# Detection speed summary
print("\n" + "=" * 60)
print(f"{'Chart':<20} {'Detection obs':>14} {'Obs after shift':>16}")
print("-" * 60)
for name, detect in [("Xbar (3σ)", xbar_detect), ("EWMA (λ=0.2)", ewma_detect), ("CUSUM (K=0.5σ)", cusum_detect)]:
    if detect is not None:
        obs_after = detect - shift_point
        print(f"{name:<20} {detect + 1:>14} {obs_after:>16}")
    else:
        print(f"{name:<20} {'No detection':>14} {'—':>16}")
print("=" * 60)
