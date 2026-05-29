"""
Module 1, Lesson 1 — What is Quality?
Exercise: Identify quality dimensions and compute a data quality score.
"""

# ----- Part 1: Quality Dimensions -----
# For each product scenario below, fill in the most relevant Garvin quality dimension.
# Choose from: "Performance", "Features", "Reliability", "Conformance",
#              "Durability", "Serviceability", "Aesthetics", "Perceived Quality"

scenarios = [
    {
        "description": "A car engine that meets the manufacturer's horsepower specification exactly.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A smartphone that looks premium and has an elegant design.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A washing machine that still works reliably after 10 years.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A printer that can be repaired cheaply and quickly by any technician.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A laptop that rarely crashes or freezes during normal use.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A coffee maker that also has a built-in grinder and milk frother.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A brand-name medication that customers trust more than the generic version.",
        "dimension": ""  # TODO: fill in
    },
    {
        "description": "A sensor that accurately measures temperature within ±0.1°C as specified.",
        "dimension": ""  # TODO: fill in
    },
]

# ----- Part 2: Data Quality Score -----
# A data pipeline is evaluated on five quality criteria.
# Each criterion is scored 0 (fails) or 1 (passes).
# Compute the percentage quality score.

data_quality_checks = {
    "Completeness": 1,    # No missing values
    "Accuracy": 0,        # Some records contain wrong values
    "Consistency": 1,     # Data is consistent across sources
    "Timeliness": 1,      # Data arrives on schedule
    "Validity": 0,        # Some values are out of valid range
}

# TODO: compute the percentage score (number of passes / total checks * 100)
quality_score = None  # replace with your calculation

# TODO: print each scenario and its dimension, then print the quality score
