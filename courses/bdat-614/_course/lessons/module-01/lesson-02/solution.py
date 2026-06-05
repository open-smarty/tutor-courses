"""
BDAT 614 — Module 1, Lesson 2
Solution: Process Variation — Common Cause vs Special Cause
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(42)

# ============================================================
# Task 1: Generate baseline data
# ============================================================
baseline_mean = 245  # ms
baseline_sd   = 15   # ms
n = 50

response_times = np.random.normal(baseline_mean, baseline_sd, n)

# ============================================================
# Task 2: Insert special cause at observation 35
# ============================================================
special_cause_start = 34  # 0-based index (observation 35)
response_times[special_cause_start:] += 200

print("First 34 observations (common-cause only):")
print(f"  Mean: {response_times[:special_cause_start].mean():.1f} ms")
print(f"  Std:  {response_times[:special_cause_start].std():.1f} ms")
print(f"\nObservations 35-50 (after special cause):")
print(f"  Mean: {response_times[special_cause_start:].mean():.1f} ms")
print(f"  Std:  {response_times[special_cause_start:].std():.1f} ms")

# ============================================================
# Task 3: Run chart
# ============================================================
obs_numbers = np.arange(1, n + 1)

fig, ax = plt.subplots(figsize=(12, 5))

# Full time series
ax.plot(obs_numbers, response_times, color="steelblue", linewidth=1.5,
        marker="o", markersize=4, label="Response time")

# Highlight the special-cause point
ax.scatter(
    special_cause_start + 1,  # 1-based observation number
    response_times[special_cause_start],
    color="red", s=120, zorder=5, label="Special cause detected"
)

# Baseline mean reference line
ax.axhline(baseline_mean, color="green", linestyle="--", linewidth=1.5,
           label=f"Baseline mean = {baseline_mean} ms")

# Vertical marker for the deployment
ax.axvline(special_cause_start + 1, color="red", linestyle=":", linewidth=1.5,
           label="Special cause: bad SQL deployment")

# Annotation
ax.annotate(
    "Bad deployment\n(full table scan)",
    xy=(special_cause_start + 1, response_times[special_cause_start]),
    xytext=(special_cause_start - 8, response_times[special_cause_start] + 30),
    arrowprops=dict(arrowstyle="->", color="red"),
    fontsize=9, color="red",
)

ax.set_xlabel("Observation number")
ax.set_ylabel("Response time (ms)")
ax.set_title("Server Response Times — Run Chart\n"
             "Common-cause variation up to obs 34; special cause from obs 35")
ax.legend(loc="upper left")
ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("module-01-lesson-02-run-chart.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nChart saved as module-01-lesson-02-run-chart.png")
