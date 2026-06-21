"""
BDAT 614 — Module 4, Lesson 2
Solution: DMAIC Root Cause Analysis — Pareto Chart, 5 Whys, Fishbone Diagram
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.patheffects as pe

np.random.seed(614)

defect_data = {
    "Underfill":         510,
    "Label misalignment":240,
    "Cap seal failure":  195,
    "Foreign particle":  120,
    "Broken glass":       90,
    "Other":              45,
}

# ============================================================
# Task 1: Compute Pareto statistics
# ============================================================
sorted_items = sorted(defect_data.items(), key=lambda x: x[1], reverse=True)
categories   = [item[0] for item in sorted_items]
counts       = [item[1] for item in sorted_items]
n_total      = sum(counts)

cumulative_counts = np.cumsum(counts)
cumulative_pct    = cumulative_counts / n_total * 100

print("=== Pareto Table — Bottling Line Defects ===")
print(f"{'Rank':<5} {'Defect Type':<22} {'Count':>7} {'% of Total':>12} {'Cumulative %':>14}")
print("-" * 63)
for rank, (cat, cnt, cum) in enumerate(zip(categories, counts, cumulative_pct), start=1):
    pct = cnt / n_total * 100
    print(f"{rank:<5} {cat:<22} {cnt:>7} {pct:>11.1f}% {cum:>13.1f}%")
print(f"\nTotal defects: {n_total}")

# ============================================================
# Task 2: Pareto chart
# ============================================================
x_pos = np.arange(len(categories))
vital_cutoff = np.searchsorted(cumulative_pct, 80)   # first index at or above 80%

fig1, ax_left = plt.subplots(figsize=(10, 6))
ax_right = ax_left.twinx()

bars = ax_left.bar(x_pos, counts, color="steelblue", edgecolor="white",
                   alpha=0.85, label="Defect Count")
ax_right.plot(x_pos, cumulative_pct, color="darkorange",
              marker="o", linewidth=2, markersize=7, label="Cumulative %")

# 80% reference line
ax_right.axhline(80, color="red", linestyle="--", linewidth=1.5, label="80% threshold")

# Vital few separator
if vital_cutoff < len(categories) - 1:
    ax_left.axvline(vital_cutoff + 0.5, color="grey", linestyle="--",
                    linewidth=1.2, alpha=0.8)
    ax_left.text(vital_cutoff + 0.55, max(counts) * 0.92,
                 "Vital\nFew →", fontsize=9, color="grey")
    ax_left.text(vital_cutoff - 0.45, max(counts) * 0.92,
                 "← Vital\nFew", fontsize=9, color="grey", ha="right")

# Bar value labels
for bar, cnt in zip(bars, counts):
    ax_left.text(bar.get_x() + bar.get_width() / 2,
                 bar.get_height() + 5,
                 str(cnt), ha="center", va="bottom", fontsize=9, fontweight="bold")

ax_left.set_xticks(x_pos)
ax_left.set_xticklabels(categories, rotation=20, ha="right", fontsize=10)
ax_left.set_xlabel("Defect Category", fontsize=11)
ax_left.set_ylabel("Frequency (count)", fontsize=11)
ax_right.set_ylabel("Cumulative Percentage (%)", fontsize=11)
ax_right.set_ylim(0, 110)
ax_left.set_title("Pareto Chart — Bottling Line Defects (n = 1,200)", fontsize=13)

# Combined legend
handles_l, labels_l = ax_left.get_legend_handles_labels()
handles_r, labels_r = ax_right.get_legend_handles_labels()
ax_left.legend(handles_l + handles_r, labels_l + labels_r,
               loc="center right", fontsize=9)
ax_left.grid(axis="y", alpha=0.3)

plt.tight_layout()
plt.savefig("module-04-lesson-02-pareto.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nPareto chart saved as module-04-lesson-02-pareto.png")

# ============================================================
# Task 3: 5 Whys chain
# ============================================================
five_whys = [
    (1, "Why did the line produce underfill defects?",
        "The fill-level sensor reported incorrect readings."),
    (2, "Why did the sensor report incorrect readings?",
        "The sensor calibration had drifted from its reference value."),
    (3, "Why had the calibration drifted?",
        "Sensor recalibration was overdue by six weeks."),
    (4, "Why was recalibration overdue?",
        "The sensor was not on the preventive maintenance schedule."),
    (5, "Why was the sensor absent from the maintenance schedule?",
        "The schedule was written before the sensor was installed and was never updated."),
]
root_cause = "ROOT CAUSE: Maintenance SOP not updated after equipment installation."

print("\n=== 5 Whys Analysis — Underfill Defects ===")
print(f"Problem: Underfill defects on the bottling line.\n")
for num, question, answer in five_whys:
    print(f"  Why {num}: {question}")
    print(f"         → {answer}\n")
print(f"  {root_cause}")

# ============================================================
# Task 4: Fishbone (Ishikawa) diagram
# ============================================================
fig2, ax2 = plt.subplots(figsize=(13, 7))
ax2.set_xlim(0, 1)
ax2.set_ylim(0, 1)
ax2.axis("off")
ax2.set_facecolor("#fafafa")

# --- Problem box (fish head) ---
problem_text = "Underfill\nDefects"
problem_box = mpatches.FancyBboxPatch((0.88, 0.40), 0.10, 0.20,
                                       boxstyle="round,pad=0.01",
                                       facecolor="#ffcccc", edgecolor="#cc0000",
                                       linewidth=2)
ax2.add_patch(problem_box)
ax2.text(0.93, 0.50, problem_text, ha="center", va="center",
         fontsize=10, fontweight="bold", color="#cc0000")

# --- Spine (horizontal arrow) ---
ax2.annotate("", xy=(0.89, 0.50), xytext=(0.08, 0.50),
             arrowprops=dict(arrowstyle="-|>", color="black",
                             lw=2, mutation_scale=18))

# Helper: draw a main bone and its sub-causes
def draw_bone(ax, spine_x, spine_y, direction, bone_label, sub_causes,
              bone_color="#2c6e9e", sub_color="#444444"):
    """
    direction: +1 for above spine, -1 for below spine.
    Bone goes from (spine_x, spine_y) diagonally to the category label.
    """
    dx, dy = -0.14, direction * 0.18
    tip_x, tip_y = spine_x + dx, spine_y + dy
    ax.annotate("", xy=(spine_x, spine_y), xytext=(tip_x, tip_y),
                arrowprops=dict(arrowstyle="-|>", color=bone_color,
                                lw=1.8, mutation_scale=14))
    ax.text(tip_x - 0.01, tip_y + direction * 0.025, bone_label,
            ha="center", va="bottom" if direction > 0 else "top",
            fontsize=11, fontweight="bold", color=bone_color)

    # Sub-causes along the bone (evenly spaced)
    n = len(sub_causes)
    for k, sub in enumerate(sub_causes):
        t    = (k + 1) / (n + 1)
        bx   = tip_x + t * (spine_x - tip_x)
        by   = tip_y + t * (spine_y - tip_y)
        sbdx = -0.01
        sbdy = direction * 0.10
        ax.plot([bx, bx + sbdx], [by, by + sbdy],
                color=bone_color, lw=1.2, alpha=0.7)
        ax.text(bx + sbdx, by + sbdy + direction * 0.015,
                sub, ha="center",
                va="bottom" if direction > 0 else "top",
                fontsize=8.5, color=sub_color,
                wrap=True)

# Main bones — above and below spine
# Spine anchors
anchor_left  = (0.32, 0.50)
anchor_right = (0.58, 0.50)

draw_bone(ax2, *anchor_left, direction=+1,
          bone_label="Machine",
          sub_causes=["Sensor drift", "Worn fill nozzle", "Pressure\nfluctuation"])

draw_bone(ax2, *anchor_right, direction=+1,
          bone_label="Method",
          sub_causes=["No calibration SOP", "Inconsistent\nfill speed"])

draw_bone(ax2, *anchor_left, direction=-1,
          bone_label="Material",
          sub_causes=["Viscosity variation", "Supplier batch\ninconsistency"])

draw_bone(ax2, *anchor_right, direction=-1,
          bone_label="Man",
          sub_causes=["Inadequate training", "Operator\nskip checks"])

ax2.set_title("Fishbone (Ishikawa) Diagram — Underfill Defects on Bottling Line",
              fontsize=13, pad=10)
plt.tight_layout()
plt.savefig("module-04-lesson-02-fishbone.png", dpi=150, bbox_inches="tight")
plt.show()
print("Fishbone diagram saved as module-04-lesson-02-fishbone.png")
