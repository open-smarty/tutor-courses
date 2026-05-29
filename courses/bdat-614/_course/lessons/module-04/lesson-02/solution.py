"""
Module 4, Lesson 2 — DMAIC and Root Cause Analysis Tools (Solution)
"""
import numpy as np
import matplotlib.pyplot as plt

defects = {
    "Null handling errors":  120,
    "Schema mismatch":        85,
    "Timeout failures":       60,
    "Duplicate records":      40,
    "Authentication errors":  25,
    "Encoding issues":        15,
    "Configuration errors":    5,
}

sorted_defects = sorted(defects.items(), key=lambda x: x[1], reverse=True)
names  = [d[0] for d in sorted_defects]
counts = np.array([d[1] for d in sorted_defects])
total  = counts.sum()
cumulative_pct = np.cumsum(counts) / total * 100

fig, ax1 = plt.subplots(figsize=(10, 6))
bars = ax1.bar(names, counts, color='steelblue', alpha=0.8)
ax1.set_ylabel('Count', color='steelblue')
ax1.tick_params(axis='x', rotation=30)
ax1.set_xlabel('Defect Type')

ax2 = ax1.twinx()
ax2.plot(names, cumulative_pct, 'ro-', linewidth=2, markersize=6, label='Cumulative %')
ax2.axhline(80, color='orange', linestyle='--', linewidth=1.5, label='80% line')
ax2.set_ylabel('Cumulative %', color='red')
ax2.set_ylim(0, 105)
ax2.legend(loc='center right')

ax1.set_title('Pareto Chart — Software Defects by Type')
plt.tight_layout()
plt.savefig('pareto_chart.png', dpi=100)
plt.show()

idx_80 = next(i for i, v in enumerate(cumulative_pct) if v >= 80)
print(f"\nPareto Analysis: The top {idx_80+1} defect types account for ≥80% of all defects.")
print(f"Focus on: {', '.join(names[:idx_80+1])}")

causes = [
    {"cause": "Analysts use different data aggregation formulas", "bone": "Method"},
    {"cause": "Input data files contain unexpected special characters", "bone": "Material"},
    {"cause": "The ETL scheduler crashes when server CPU > 90%", "bone": "Environment"},
    {"cause": "Data quality checks were not run before loading", "bone": "Method"},
    {"cause": "A new data engineer was not trained on the schema conventions", "bone": "Man"},
    {"cause": "The validation script counts nulls incorrectly", "bone": "Measurement"},
]

print("\n=== Part 2: Fishbone Causes ===")
for c in causes:
    print(f"  [{c['bone']:12s}] {c['cause']}")
