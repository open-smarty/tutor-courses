"""
Module 5, Lesson 3 — Lean Six Sigma (Solution)
"""

process_steps = [
    {"step": "Receive raw data files from vendor",           "time_min": 2,   "classification": "VA"},
    {"step": "Data sits in landing zone waiting for batch job", "time_min": 90, "classification": "NVA"},
    {"step": "Run schema validation checks",                 "time_min": 5,   "classification": "VA"},
    {"step": "Manual data quality review by analyst",        "time_min": 45,  "classification": "NVA"},
    {"step": "Transform and normalise data",                 "time_min": 10,  "classification": "VA"},
    {"step": "Load into staging database",                   "time_min": 3,   "classification": "NNVA"},
    {"step": "Generate intermediate report nobody uses",     "time_min": 20,  "classification": "NVA"},
    {"step": "Load into production warehouse",               "time_min": 4,   "classification": "VA"},
    {"step": "Wait for approval before publishing dashboard","time_min": 60,  "classification": "NVA"},
    {"step": "Publish dashboard to stakeholders",            "time_min": 2,   "classification": "VA"},
]

total_time = sum(s["time_min"] for s in process_steps)
va_time    = sum(s["time_min"] for s in process_steps if s["classification"] == "VA")
pce        = va_time / total_time * 100

nva_waste_mapping = {
    "Data sits in landing zone waiting for batch job": "Waiting",
    "Manual data quality review by analyst":          "Unused Talent",
    "Generate intermediate report nobody uses":       "Overproduction",
    "Wait for approval before publishing dashboard":  "Waiting",
}

print("=== Value Stream Analysis ===")
for s in process_steps:
    print(f"  [{s['classification']:4s}] {s['time_min']:3d} min  {s['step']}")
print(f"\n  Total time:          {total_time} min")
print(f"  Value-adding time:   {va_time} min")
print(f"  Process Cycle Eff.:  {pce:.1f}%")
print(f"\n  → {100-pce:.1f}% of time is waste. Target: reduce NVA steps to < 20% of total time.")

print("\n=== Lean Waste Classification ===")
for step, waste in nva_waste_mapping.items():
    print(f"  [{waste:16s}] {step}")

print("\nLean Six Sigma Improvements:")
print("  1. Automate schema validation and quality review → eliminate manual review (Unused Talent)")
print("  2. Schedule batch jobs to run immediately on data arrival → reduce 90 min waiting")
print("  3. Remove the intermediate report step → eliminate Overproduction")
print("  4. Automate approval workflow → reduce 60 min approval wait")
