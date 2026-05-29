"""
Module 1, Lesson 2 — Process Variation: Sources and Types
Exercise: Classify variation, identify 6M categories, and trace a 5 Whys chain.
"""

# ----- Part 1: Common Cause vs Special Cause -----
# Classify each scenario as "common" or "special" cause variation.

scenarios = [
    {
        "description": "A bottling machine fills between 499 ml and 501 ml every cycle due to minor pressure fluctuations.",
        "type": ""  # TODO: "common" or "special"
    },
    {
        "description": "A batch of raw plastic pellets from a new supplier causes 20% of parts to be brittle.",
        "type": ""  # TODO
    },
    {
        "description": "Daily website response times vary between 120 ms and 140 ms with no clear pattern.",
        "type": ""  # TODO
    },
    {
        "description": "A server hardware failure causes response times to spike to 8000 ms.",
        "type": ""  # TODO
    },
    {
        "description": "Sensor readings in a factory fluctuate by ±0.5°C throughout the day due to normal air circulation.",
        "type": ""  # TODO
    },
    {
        "description": "A data analyst changes the ETL script without testing it, doubling the number of null records.",
        "type": ""  # TODO
    },
]

# ----- Part 2: 6M Category -----
# For each special-cause scenario below, identify the 6M source.
# Choose from: "Man", "Machine", "Material", "Method", "Measurement", "Environment"

special_causes = [
    {
        "description": "A sensor that measures temperature drifts due to a dead battery.",
        "source": ""  # TODO
    },
    {
        "description": "An operator skips a required cleaning step because they were not trained properly.",
        "source": ""  # TODO
    },
    {
        "description": "A new batch of raw data contains duplicate records from the upstream database.",
        "source": ""  # TODO
    },
    {
        "description": "High humidity in the storage room causes product to absorb moisture and gain weight.",
        "source": ""  # TODO
    },
    {
        "description": "Two teams use different rounding rules when aggregating sales figures.",
        "source": ""  # TODO
    },
]

# ----- Part 3: 5 Whys Chain -----
# Problem: "The daily data pipeline failed at 3am and no alert was sent to the team."
# Fill in each 'why' answer to trace the root cause.

five_whys = {
    "Problem": "The daily data pipeline failed at 3am and no alert was sent.",
    "Why 1": "",  # TODO: what caused the failure?
    "Why 2": "",  # TODO: why did that happen?
    "Why 3": "",  # TODO: why did that happen?
    "Why 4": "",  # TODO: why did that happen?
    "Why 5": "",  # TODO: what is the root cause?
}

# TODO: print Part 1 and Part 2 results, and print the 5 Whys chain
