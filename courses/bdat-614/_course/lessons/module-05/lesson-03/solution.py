"""
BDAT 614 — Module 5, Lesson 3
Solution: Lean Six Sigma — Waste Elimination and Quality Tools
"""
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict

np.random.seed(614)

# ============================================================
# Process step definitions (hospital triage + 3 extensions)
# ============================================================
steps = [
    {"name": "Wait in queue",           "va": False, "waste": "Waiting",         "duration": 18.0},
    {"name": "Triage assessment",        "va": True,  "waste": "VA",              "duration":  7.0},
    {"name": "Move to exam room",        "va": False, "waste": "Transport",       "duration":  4.0},
    {"name": "Wait for physician",       "va": False, "waste": "Waiting",         "duration": 25.0},
    {"name": "Physician examination",    "va": True,  "waste": "VA",              "duration": 12.0},
    {"name": "Documentation (EHR entry)","va": False, "waste": "Overprocessing",  "duration":  8.0},
    {"name": "Wait for lab results",     "va": False, "waste": "Waiting",         "duration": 30.0},
    {"name": "Prescription writing",     "va": True,  "waste": "VA",              "duration":  5.0},
    {"name": "Discharge paperwork",      "va": False, "waste": "Overprocessing",  "duration":  6.0},
]

# ============================================================
# Task 1: Compute and print process efficiency metrics
# ============================================================
total_time = sum(s["duration"] for s in steps)
va_time    = sum(s["duration"] for s in steps if s["va"])
nva_time   = sum(s["duration"] for s in steps if not s["va"])
efficiency = (va_time / total_time) * 100

print("Process Step Summary")
print("=" * 60)
print(f"{'Step':<28} {'Type':>5} {'Category':<16} {'Min':>5}")
print("-" * 60)
for s in steps:
    vtype = "VA" if s["va"] else "NVA"
    print(f"{s['name']:<28} {vtype:>5} {s['waste']:<16} {s['duration']:>5.1f}")
print("=" * 60)
print(f"Total lead time:  {total_time:.1f} min")
print(f"Value-added time: {va_time:.1f} min")
print(f"Non-VA time:      {nva_time:.1f} min")
print(f"Process efficiency: {efficiency:.1f}%")

# ============================================================
# Task 2: Stacked horizontal bar chart
# ============================================================
names     = [s["name"] for s in steps]
durations = [s["duration"] for s in steps]
colours   = ["seagreen" if s["va"] else "tomato" for s in steps]

fig, axes = plt.subplots(3, 1, figsize=(12, 14))

ax1 = axes[0]
bars = ax1.barh(names, durations, color=colours, edgecolor="white", height=0.6)
for bar, dur in zip(bars, durations):
    ax1.text(bar.get_width() + 0.5, bar.get_y() + bar.get_height() / 2,
             f"{dur:.0f} min", va="center", fontsize=9)
ax1.set_xlabel("Duration (minutes)")
ax1.set_title("Value Stream: VA (green) vs NVA (red) Time by Step")
ax1.invert_yaxis()
ax1.grid(True, axis="x", alpha=0.3)

# Legend proxy
from matplotlib.patches import Patch
ax1.legend(handles=[Patch(color="seagreen", label="Value-Added"),
                    Patch(color="tomato",   label="Non-Value-Added")],
           loc="lower right")

# ============================================================
# Task 3: NVA time by waste category
# ============================================================
waste_totals = defaultdict(float)
for s in steps:
    if not s["va"]:
        waste_totals[s["waste"]] += s["duration"]

categories = sorted(waste_totals.keys(), key=lambda k: waste_totals[k], reverse=True)
values     = [waste_totals[c] for c in categories]

ax2 = axes[1]
ax2.bar(categories, values, color="darkorange", edgecolor="white")
for i, v in enumerate(values):
    ax2.text(i, v + 0.5, f"{v:.0f}", ha="center", fontsize=10)
ax2.set_ylabel("Total NVA time (minutes)")
ax2.set_title("NVA Time by Waste Category (TIMWOODS)")
ax2.grid(True, axis="y", alpha=0.3)

# ============================================================
# Task 4: Simulate 100 production cycles
# ============================================================
n_cycles = 100
simulated_totals = np.zeros(n_cycles)

for cycle in range(n_cycles):
    cycle_total = 0.0
    for s in steps:
        sampled_dur = np.random.normal(loc=s["duration"], scale=0.2 * s["duration"])
        sampled_dur = max(0.0, sampled_dur)   # clip at 0
        cycle_total += sampled_dur
    simulated_totals[cycle] = cycle_total

mean_sim = np.mean(simulated_totals)
std_sim  = np.std(simulated_totals)

ax3 = axes[2]
ax3.hist(simulated_totals, bins=20, color="steelblue", edgecolor="white", alpha=0.85)
ax3.axvline(total_time, color="red",    linestyle="--", linewidth=2, label=f"Nominal = {total_time:.0f} min")
ax3.axvline(mean_sim,   color="green",  linestyle="--", linewidth=2, label=f"Sim mean = {mean_sim:.1f} min")
ax3.set_xlabel("Total lead time (minutes)")
ax3.set_ylabel("Frequency")
ax3.set_title(f"Simulated Lead Time Distribution (100 cycles) — mean={mean_sim:.1f}, sd={std_sim:.1f} min")
ax3.legend()
ax3.grid(True, alpha=0.3)

plt.suptitle("Lean Six Sigma: Value Stream Analysis — Hospital Triage", fontsize=13, y=1.01)
plt.tight_layout()
plt.savefig("module-05-lesson-03-lean-analysis.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-05-lesson-03-lean-analysis.png")
