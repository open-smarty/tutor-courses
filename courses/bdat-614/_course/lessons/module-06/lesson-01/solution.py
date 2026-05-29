"""
Module 6, Lesson 1 — TQM and Cost of Poor Quality (Solution)
"""

copq_data = {
    "Prevention": {
        "Data quality training for new hires": 3000,
        "Automated schema validation system": 5000,
        "Data quality audit (quarterly)": 2000,
    },
    "Appraisal": {
        "Daily automated data quality checks": 8000,
        "Manual spot-check reviews by analyst": 12000,
        "Data profiling tool licence": 4000,
    },
    "Internal Failure": {
        "Reprocessing failed pipeline jobs": 25000,
        "Correcting mislabelled training data": 18000,
        "Downtime from data outages": 30000,
    },
    "External Failure": {
        "Revenue loss from inaccurate recommendations": 95000,
        "SLA penalties from late reports": 40000,
        "Customer churn attributed to data errors": 120000,
    },
}

category_totals = {cat: sum(items.values()) for cat, items in copq_data.items()}
total_copq = sum(category_totals.values())
prevention_pct = category_totals["Prevention"] / total_copq * 100

print("=== Cost of Poor Quality Analysis ===\n")
for cat, total in category_totals.items():
    pct = total / total_copq * 100
    print(f"  {cat:20s}: £{total:>9,}  ({pct:4.1f}%)")
    for item, cost in copq_data[cat].items():
        print(f"    - {item}: £{cost:,}")
    print()

print(f"  TOTAL COPQ: £{total_copq:,}")
print(f"\n  Prevention as % of COPQ: {prevention_pct:.1f}%")

if prevention_pct < 5:
    print("\n  RECOMMENDATION: Prevention spending is critically low (< 5%).")
    print("  The 1:10:100 rule suggests every £1 in prevention saves ~£10 in")
    print("  internal failures and ~£100 in external failures.")
    print("  Target: increase prevention budget from "
          f"£{category_totals['Prevention']:,} to at least "
          f"£{int(total_copq * 0.10):,} (10% of COPQ).")
    failure_cost = category_totals["Internal Failure"] + category_totals["External Failure"]
    print(f"  Current failure costs (£{failure_cost:,}) would likely drop by 40-60%.")
else:
    print("\n  Prevention spending is within the recommended range (5–10% of COPQ).")
