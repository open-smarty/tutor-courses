"""
Module 1, Lesson 2 — Process Variation (Solution)
Note: The 5 Whys answers are one plausible chain — any logically consistent chain is acceptable.
"""

scenarios = [
    {"description": "A bottling machine fills between 499 ml and 501 ml every cycle due to minor pressure fluctuations.", "type": "common"},
    {"description": "A batch of raw plastic pellets from a new supplier causes 20% of parts to be brittle.", "type": "special"},
    {"description": "Daily website response times vary between 120 ms and 140 ms with no clear pattern.", "type": "common"},
    {"description": "A server hardware failure causes response times to spike to 8000 ms.", "type": "special"},
    {"description": "Sensor readings in a factory fluctuate by ±0.5°C throughout the day due to normal air circulation.", "type": "common"},
    {"description": "A data analyst changes the ETL script without testing it, doubling the number of null records.", "type": "special"},
]

special_causes = [
    {"description": "A sensor that measures temperature drifts due to a dead battery.", "source": "Measurement"},
    {"description": "An operator skips a required cleaning step because they were not trained properly.", "source": "Man"},
    {"description": "A new batch of raw data contains duplicate records from the upstream database.", "source": "Material"},
    {"description": "High humidity in the storage room causes product to absorb moisture and gain weight.", "source": "Environment"},
    {"description": "Two teams use different rounding rules when aggregating sales figures.", "source": "Method"},
]

five_whys = {
    "Problem": "The daily data pipeline failed at 3am and no alert was sent.",
    "Why 1": "The pipeline job ran out of memory and crashed silently.",
    "Why 2": "A new data source added that day tripled the data volume unexpectedly.",
    "Why 3": "There was no capacity check when onboarding the new data source.",
    "Why 4": "There is no formal data source onboarding process.",
    "Why 5": "Root cause: no documented change management process for pipeline data sources.",
}

print("=== Part 1: Common vs Special Cause ===")
for s in scenarios:
    print(f"  [{s['type'].upper():7s}] {s['description']}")

print("\n=== Part 2: 6M Categories ===")
for sc in special_causes:
    print(f"  [{sc['source']:12s}] {sc['description']}")

print("\n=== Part 3: 5 Whys Chain ===")
for step, answer in five_whys.items():
    print(f"  {step}: {answer}")
