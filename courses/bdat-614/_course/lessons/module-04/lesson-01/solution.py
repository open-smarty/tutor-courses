"""
BDAT 614 — Module 4, Lesson 1
Solution: Simulating Process Improvement Across PDCA Cycles
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

np.random.seed(614)

BASELINE_DEFECT_RATE = 12.0
TARGET_DEFECT_RATE   =  2.0
N_CYCLES             =  8

# ============================================================
# Task 1: Simulate defect rate across PDCA cycles
# ============================================================
expected_reductions = [3.5, 2.8, 2.0, 1.5, 1.0, 0.8, 0.5, 0.4]

cycle_numbers = np.arange(N_CYCLES + 1)
defect_rates  = np.zeros(N_CYCLES + 1)
defect_rates[0] = BASELINE_DEFECT_RATE

for i in range(N_CYCLES):
    noise = np.random.normal(0, 0.3)
    reduction = expected_reductions[i] + noise
    defect_rates[i + 1] = max(0.0, defect_rates[i] - reduction)

# ============================================================
# Task 2: Find when target is first met
# ============================================================
below_target = np.where(defect_rates <= TARGET_DEFECT_RATE)[0]
first_target_cycle = int(below_target[0]) if len(below_target) > 0 else None

# ============================================================
# Task 3: Cumulative improvement
# ============================================================
cumulative_improvement = BASELINE_DEFECT_RATE - defect_rates

# ============================================================
# Task 4: Summary table
# ============================================================
print("=== PDCA Cycle-by-Cycle Defect Reduction Summary ===")
print(f"{'Cycle':<8} {'Defect Rate (%)':<20} {'Change (pp)':<15} {'Cumul. Reduction (pp)'}")
print("-" * 65)
for i in range(N_CYCLES + 1):
    if i == 0:
        change = 0.0
    else:
        change = defect_rates[i] - defect_rates[i - 1]
    label = "(Baseline)" if i == 0 else ""
    print(f"{i:<8} {defect_rates[i]:<20.2f} {change:<15.2f} "
          f"{cumulative_improvement[i]:.2f}  {label}")

if first_target_cycle is not None:
    print(f"\nTarget of {TARGET_DEFECT_RATE}% first achieved at Cycle {first_target_cycle}.")
else:
    print(f"\nTarget of {TARGET_DEFECT_RATE}% not reached within {N_CYCLES} cycles.")

# ============================================================
# Task 5: Two-panel figure
# ============================================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# --- Panel A: Defect rate line chart ---
ax1.plot(cycle_numbers, defect_rates, color="steelblue",
         marker="o", markersize=7, linewidth=2, label="Defect Rate")

ax1.axhline(TARGET_DEFECT_RATE, color="red", linestyle="--",
            linewidth=1.5, label=f"Target = {TARGET_DEFECT_RATE}%")

# Annotate each data point with its value
for i, rate in enumerate(defect_rates):
    ax1.annotate(f"{rate:.1f}%",
                 xy=(i, rate),
                 xytext=(0, 10),
                 textcoords="offset points",
                 ha="center", fontsize=8, color="navy")

# Mark first cycle at target
if first_target_cycle is not None:
    ax1.scatter(first_target_cycle, defect_rates[first_target_cycle],
                color="green", s=150, zorder=6, marker="*",
                label=f"Target met (Cycle {first_target_cycle})")
    ax1.annotate(f"Target met\n(Cycle {first_target_cycle})",
                 xy=(first_target_cycle, defect_rates[first_target_cycle]),
                 xytext=(15, -20), textcoords="offset points",
                 fontsize=9, color="green",
                 arrowprops=dict(arrowstyle="->", color="green"))

ax1.set_title("Defect Rate Across PDCA Cycles", fontsize=12)
ax1.set_xlabel("Cycle Number")
ax1.set_ylabel("Defect Rate (%)")
ax1.set_xticks(cycle_numbers)
ax1.set_xticklabels(["Baseline"] + [f"Cycle {i}" for i in range(1, N_CYCLES + 1)],
                    rotation=30, ha="right", fontsize=8)
ax1.legend(fontsize=9)
ax1.grid(alpha=0.3)
ax1.set_ylim(0, BASELINE_DEFECT_RATE + 1)

# --- Panel B: Cumulative improvement bar chart ---
max_possible = BASELINE_DEFECT_RATE - TARGET_DEFECT_RATE
cycles_1_to_n = cycle_numbers[1:]
cum_1_to_n    = cumulative_improvement[1:]

# Colour gradient: light to dark green
norm_vals = cum_1_to_n / max_possible
colours   = cm.YlGn(0.3 + 0.7 * norm_vals)

bars = ax2.bar(cycles_1_to_n, cum_1_to_n,
               color=colours, edgecolor="white", alpha=0.9)
ax2.axhline(max_possible, color="red", linestyle="--",
            linewidth=1.5, label=f"Max possible = {max_possible:.0f} pp")

for bar, val in zip(bars, cum_1_to_n):
    ax2.text(bar.get_x() + bar.get_width() / 2,
             bar.get_height() + 0.1,
             f"+{val:.1f} pp",
             ha="center", va="bottom", fontsize=8, fontweight="bold")

ax2.set_title("Cumulative Defect Reduction Across Cycles", fontsize=12)
ax2.set_xlabel("Cycle Number")
ax2.set_ylabel("Total Reduction (percentage points)")
ax2.set_xticks(cycles_1_to_n)
ax2.set_xticklabels([f"Cycle {i}" for i in cycles_1_to_n],
                    rotation=30, ha="right", fontsize=8)
ax2.legend(fontsize=9)
ax2.grid(axis="y", alpha=0.3)
ax2.set_ylim(0, max_possible + 1.5)

plt.suptitle("PDCA Cycle Simulation — Tablet Manufacturing Defect Rate", fontsize=13)
plt.tight_layout()
plt.savefig("module-04-lesson-01-pdca.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-04-lesson-01-pdca.png")
