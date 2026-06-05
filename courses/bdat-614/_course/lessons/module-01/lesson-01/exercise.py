"""
BDAT 614 — Module 1, Lesson 1
Exercise: Garvin's 8 Dimensions of Quality — ETL Pipeline Audit
"""
import numpy as np
import matplotlib.pyplot as plt

# ============================================================
# Task 1: Define the quality audit dictionary
# ============================================================
# Create a dictionary called `audit` where:
#   - keys are the 8 Garvin dimension names (strings)
#   - values are integer scores from 1 (very poor) to 5 (excellent)
#
# Use the following scores for an ETL pipeline at your organisation:
#   Performance=4, Features=3, Reliability=2, Conformance=5,
#   Durability=3, Serviceability=3, Aesthetics=4, Perceived Quality=3
#
# TODO: define the audit dictionary
audit = {
    "Performance": 4,
    "Features": 3,
    "Reliability": 2,
    "Conformance": 5,
    "Durability": 3,
    "Serviceability": 3,
    "Aesthetics": 4,
    "Perceived Quality": 3,
}


# ============================================================
# Task 2: Compute the overall quality score
# ============================================================
# Compute the mean score across all 8 dimensions.
# Print it formatted to 2 decimal places.
#
# TODO: compute and print overall_score
overall_score = sum(audit.values()) / len(audit) * 100
print(f"Overall Data Quality Score: {overall_score:.2f}%")




# ============================================================
# Task 3: Plot a radar (spider) chart
# ============================================================
# A radar chart displays multi-dimensional data on equally spaced axes
# radiating from a common centre.
#
# Steps:
#   a) Extract dimension names and scores from the audit dict.
#   b) Compute the angle for each axis: angles = np.linspace(0, 2*np.pi, N, endpoint=False)
#      where N is the number of dimensions.
#   c) Close the polygon by appending the first value to the end of scores and angles.
#   d) Create a polar subplot: fig, ax = plt.subplots(subplot_kw=dict(polar=True))
#   e) Plot the polygon: ax.plot(angles, scores) and fill: ax.fill(angles, scores, alpha=0.25)
#   f) Set tick labels: ax.set_xticks(angles[:-1]) and ax.set_xticklabels(dimensions)
#   g) Set y-axis range to [0, 5] with ax.set_ylim(0, 5)
#   h) Add a title including the overall score.
#   i) plt.tight_layout() and plt.show()
#
# TODO: build the radar chart
dimensions = list(audit.keys())
scores = list(audit.values())
N = len(dimensions)
angles = np.linspace(0, 2 * np.pi, N, endpoint=False).tolist()
# Close the polygon
scores += scores[:1]
angles += angles[:1]
# Create a polar subplot
fig, ax = plt.subplots(subplot_kw=dict(polar=True))
# Plot the polygon and fill
ax.plot(angles, scores, color='blue', linewidth=2)
ax.fill(angles, scores, color='blue', alpha=0.25)
# Set tick labels
ax.set_xticks(angles[:-1])
ax.set_xticklabels(dimensions)
# Set y-axis range
ax.set_ylim(0, 5)
# Add a title
ax.set_title(f"Data Quality Audit (Overall Score: {overall_score:.2f}%)", pad=20)
# Show the plot
plt.tight_layout()
plt.show()

