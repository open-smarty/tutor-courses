"""
BDAT 614 — Module 6, Lesson 1
Solution: Total Quality Management (TQM) and Cost of Poor Quality (COPQ)
"""
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(614)

# ============================================================
# Baseline COPQ data (medical device manufacturer, annual £)
# ============================================================
copq_baseline = {
    "Prevention":       180_000,
    "Appraisal":        320_000,
    "Internal Failure": 540_000,
    "External Failure": 960_000,
}
annual_revenue = 20_000_000

# ============================================================
# Task 1: Compute and print COPQ summary
# ============================================================
total_copq         = sum(copq_baseline.values())
copq_pct_revenue   = total_copq / annual_revenue * 100

print("COPQ Summary — PAF Model")
print("=" * 50)
print(f"{'Category':<20} {'Cost (£)':>12} {'Share (%)':>10}")
print("-" * 50)
for cat, cost in copq_baseline.items():
    share = cost / total_copq * 100
    print(f"{cat:<20} {cost:>12,.0f} {share:>10.1f}%")
print("=" * 50)
print(f"{'Total COPQ':<20} {total_copq:>12,.0f}")
print(f"COPQ as % of revenue: {copq_pct_revenue:.1f}%")

# ============================================================
# Task 2: COPQ breakdown charts
# ============================================================
categories = list(copq_baseline.keys())
costs      = list(copq_baseline.values())

colours_map = {
    "Prevention":       "steelblue",
    "Appraisal":        "mediumseagreen",
    "Internal Failure": "orange",
    "External Failure": "crimson",
}
bar_colours = [colours_map[c] for c in categories]

fig1, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Pie chart
explode = [0.0, 0.0, 0.0, 0.05]   # explode External Failure
ax1.pie(costs, labels=categories, colors=bar_colours, explode=explode,
        autopct="%1.1f%%", startangle=140, textprops={"fontsize": 10})
ax1.set_title("COPQ Breakdown — PAF Model", fontsize=12)

# Horizontal bar chart — sorted by cost descending
sorted_cats  = sorted(categories, key=lambda c: copq_baseline[c], reverse=True)
sorted_costs = [copq_baseline[c] for c in sorted_cats]
sorted_cols  = [colours_map[c] for c in sorted_cats]

bars = ax2.barh(sorted_cats, sorted_costs, color=sorted_cols, edgecolor="white", height=0.6)
for bar, cost in zip(bars, sorted_costs):
    ax2.text(bar.get_width() + 10_000, bar.get_y() + bar.get_height() / 2,
             f"£{cost/1000:.0f}k", va="center", fontsize=9)
ax2.set_xlabel("Annual cost (£)")
ax2.set_title("COPQ by Category")
ax2.invert_yaxis()
ax2.grid(True, axis="x", alpha=0.3)
ax2.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f"£{x/1000:.0f}k"))

plt.suptitle("Cost of Poor Quality Analysis — Medical Device Manufacturer", fontsize=13)
plt.tight_layout()
plt.savefig("module-06-lesson-01-copq-breakdown.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nBreakdown chart saved as module-06-lesson-01-copq-breakdown.png")

# ============================================================
# Task 3: Prevention vs failure trade-off model
# ============================================================
k               = 3.0
max_prevention  = 600_000
baseline_failure = copq_baseline["Internal Failure"] + copq_baseline["External Failure"]
appraisal_cost  = copq_baseline["Appraisal"]

prevention_range = np.arange(50_000, 610_000, 10_000)
failure_costs    = baseline_failure * np.exp(-k * (prevention_range / max_prevention))
total_costs      = prevention_range + appraisal_cost + failure_costs

# Find minimum
min_idx       = np.argmin(total_costs)
opt_prevention = prevention_range[min_idx]
opt_total     = total_costs[min_idx]

print(f"\nOptimal prevention investment: £{opt_prevention:,.0f}")
print(f"Minimum total COPQ:            £{opt_total:,.0f}")
print(f"Savings vs baseline total COPQ: £{total_copq - opt_total:,.0f}")

fig2, ax3 = plt.subplots(figsize=(10, 6))

ax3.plot(prevention_range, total_costs,    color="steelblue",  linewidth=2, label="Total COPQ")
ax3.plot(prevention_range, failure_costs,  color="crimson",    linewidth=2,
         linestyle="--", label="Failure cost (internal + external)")
ax3.plot(prevention_range, prevention_range, color="seagreen", linewidth=2,
         linestyle="--", label="Prevention cost")
ax3.axhline(appraisal_cost, color="orange", linewidth=1.5,
            linestyle=":", label=f"Appraisal cost = £{appraisal_cost/1000:.0f}k (constant)")

# Mark optimum
ax3.scatter(opt_prevention, opt_total, color="gold", s=150, zorder=5,
            marker="*", label=f"Optimum (£{opt_prevention/1000:.0f}k prevention → £{opt_total/1000:.0f}k total)")

ax3.set_xlabel("Annual prevention investment (£)", fontsize=12)
ax3.set_ylabel("Annual cost (£)", fontsize=12)
ax3.set_title("COPQ Trade-off: Prevention Investment vs Failure Costs", fontsize=13)
ax3.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f"£{x/1000:.0f}k"))
ax3.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f"£{x/1000:.0f}k"))
ax3.legend(fontsize=9, loc="upper right")
ax3.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("module-06-lesson-01-copq-tradeoff.png", dpi=150, bbox_inches="tight")
plt.show()
print("Trade-off chart saved as module-06-lesson-01-copq-tradeoff.png")
