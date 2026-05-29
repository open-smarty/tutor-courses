"""
Module 5, Lesson 2 — Six Sigma: DPMO and Performance Levels
Exercise: Compute DPMO and sigma level for three processes.

Requirements: numpy, scipy
"""
import numpy as np
from scipy.stats import norm

# Six Sigma performance table (sigma level → DPMO)
sigma_dpmo_table = {
    6: 3.4,
    5: 233,
    4: 6210,
    3: 66807,
    2: 308537,
}

# ----- Process Data -----
processes = [
    {
        "name": "Medical device assembly",
        "units_per_day": 10000,
        "opportunities_per_unit": 8,  # 8 critical assembly steps
        "defects_per_day": 50,
    },
    {
        "name": "Data pipeline validation",
        "units_per_day": 500000,     # records per day
        "opportunities_per_unit": 12, # 12 fields per record
        "defects_per_day": 3600,
    },
    {
        "name": "Customer order fulfilment",
        "units_per_day": 2000,
        "opportunities_per_unit": 5,
        "defects_per_day": 80,
    },
]

def compute_dpmo(units, opportunities_per_unit, defects):
    """Compute DPMO given total units, opportunities per unit, and total defects."""
    pass  # TODO: return DPMO value

def estimate_sigma_level(dpmo):
    """Estimate the sigma level from DPMO using the performance table."""
    # TODO: find the closest sigma level in sigma_dpmo_table
    pass

def defects_needed_for_next_level(dpmo, units_per_day, opportunities_per_unit):
    """Compute how many fewer defects per day are needed to reach the next sigma level."""
    pass  # TODO: find next sigma level DPMO, compute target defects, return difference

# TODO: For each process:
# 1. Compute DPMO
# 2. Estimate sigma level
# 3. Compute defects to eliminate to reach the next sigma level
# 4. Print results
print("=== Six Sigma Process Analysis ===")
