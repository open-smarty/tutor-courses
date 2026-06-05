"""
BDAT 614 — Module 1, Lesson 1
Solution: Garvin's 8 Dimensions of Quality — ETL Pipeline Audit
"""
import numpy as np
import matplotlib.pyplot as plt

# ============================================================
# Task 1: Quality audit dictionary
# ============================================================
audit = {
    "Performance":       4,
    "Features":          3,
    "Reliability":       2,
    "Conformance":       5,
    "Durability":        3,
    "Serviceability":    3,
    "Aesthetics":        4,
    "Perceived Quality": 3,
}

# ============================================================
# Task 2: Overall quality score
# ============================================================
overall_score = np.mean(list(audit.values()))
print(f"Overall quality score: {overall_score:.2f} / 5.00")
print("\nDimension breakdown:")
for dim, score in audit.items():
    bar = "█" * score + "░" * (5 - score)
    print(f"  {dim:<20} {bar}  {score}/5")

# ============================================================
# Task 3: Radar chart
# ============================================================
dimensions = list(audit.keys())
scores = list(audit.values())
N = len(dimensions)

# Compute equally spaced angles; wrap around by appending the first
angles = np.linspace(0, 2 * np.pi, N, endpoint=False).tolist()
scores_plot = scores + [scores[0]]
angles_plot = angles + [angles[0]]

fig, ax = plt.subplots(figsize=(7, 7), subplot_kw=dict(polar=True))

# Plot polygon and fill
ax.plot(angles_plot, scores_plot, color="steelblue", linewidth=2, linestyle="solid")
ax.fill(angles_plot, scores_plot, color="steelblue", alpha=0.25)

# Axis labels
ax.set_xticks(angles)
ax.set_xticklabels(dimensions, fontsize=10)

# Score grid
ax.set_yticks([1, 2, 3, 4, 5])
ax.set_yticklabels(["1", "2", "3", "4", "5"], fontsize=8, color="grey")
ax.set_ylim(0, 5)

# Add score annotations at each vertex
for angle, score, dim in zip(angles, scores, dimensions):
    ax.annotate(
        str(score),
        xy=(angle, score),
        xytext=(angle, score + 0.3),
        ha="center",
        fontsize=9,
        fontweight="bold",
        color="steelblue",
    )

ax.set_title(
    f"ETL Pipeline Quality Audit\nOverall Score: {overall_score:.2f}/5.00",
    size=13,
    pad=20,
)

plt.tight_layout()
plt.savefig("module-01-lesson-01-radar.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-01-lesson-01-radar.png")
