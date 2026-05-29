"""
Module 5, Lesson 2 — Six Sigma: DPMO and Performance Levels (Solution)
"""
import numpy as np

sigma_dpmo_table = {6: 3.4, 5: 233, 4: 6210, 3: 66807, 2: 308537}

processes = [
    {"name": "Medical device assembly", "units_per_day": 10000, "opportunities_per_unit": 8, "defects_per_day": 50},
    {"name": "Data pipeline validation", "units_per_day": 500000, "opportunities_per_unit": 12, "defects_per_day": 3600},
    {"name": "Customer order fulfilment", "units_per_day": 2000, "opportunities_per_unit": 5, "defects_per_day": 80},
]

def compute_dpmo(units, opu, defects):
    return defects / (units * opu) * 1_000_000

def estimate_sigma_level(dpmo):
    for sigma in sorted(sigma_dpmo_table.keys(), reverse=True):
        if dpmo >= sigma_dpmo_table[sigma]:
            return sigma
    return 6

def defects_needed_for_next_level(dpmo, units, opu):
    current_sigma = estimate_sigma_level(dpmo)
    next_sigma = current_sigma + 1
    if next_sigma > 6:
        return 0, 6, 3.4
    target_dpmo = sigma_dpmo_table[next_sigma]
    current_defects = dpmo * units * opu / 1_000_000
    target_defects  = target_dpmo * units * opu / 1_000_000
    return current_defects - target_defects, next_sigma, target_dpmo

print("=== Six Sigma Process Analysis ===\n")
for p in processes:
    dpmo = compute_dpmo(p["units_per_day"], p["opportunities_per_unit"], p["defects_per_day"])
    sigma = estimate_sigma_level(dpmo)
    reduction, next_sigma, target_dpmo = defects_needed_for_next_level(dpmo, p["units_per_day"], p["opportunities_per_unit"])
    print(f"Process: {p['name']}")
    print(f"  DPMO:          {dpmo:,.1f}")
    print(f"  Sigma level:   ~{sigma}σ")
    print(f"  To reach {next_sigma}σ ({target_dpmo:.1f} DPMO): eliminate ~{reduction:.0f} defects/day")
    print()
