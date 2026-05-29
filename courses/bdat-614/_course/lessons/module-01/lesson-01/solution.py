"""
Module 1, Lesson 1 — What is Quality? (Solution)
"""

scenarios = [
    {"description": "A car engine that meets the manufacturer's horsepower specification exactly.", "dimension": "Conformance"},
    {"description": "A smartphone that looks premium and has an elegant design.", "dimension": "Aesthetics"},
    {"description": "A washing machine that still works reliably after 10 years.", "dimension": "Durability"},
    {"description": "A printer that can be repaired cheaply and quickly by any technician.", "dimension": "Serviceability"},
    {"description": "A laptop that rarely crashes or freezes during normal use.", "dimension": "Reliability"},
    {"description": "A coffee maker that also has a built-in grinder and milk frother.", "dimension": "Features"},
    {"description": "A brand-name medication that customers trust more than the generic version.", "dimension": "Perceived Quality"},
    {"description": "A sensor that accurately measures temperature within ±0.1°C as specified.", "dimension": "Performance"},
]

data_quality_checks = {
    "Completeness": 1,
    "Accuracy": 0,
    "Consistency": 1,
    "Timeliness": 1,
    "Validity": 0,
}

quality_score = sum(data_quality_checks.values()) / len(data_quality_checks) * 100

print("=== Part 1: Quality Dimensions ===")
for s in scenarios:
    print(f"  {s['dimension']:20s} — {s['description']}")

print(f"\n=== Part 2: Data Quality Score ===")
for criterion, result in data_quality_checks.items():
    status = "PASS" if result else "FAIL"
    print(f"  {criterion:15s}: {status}")
print(f"\n  Overall Data Quality Score: {quality_score:.1f}%")
