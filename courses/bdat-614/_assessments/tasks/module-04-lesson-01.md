# Task: Module 4, Lesson 1 — Apply PDSA to an Improvement Project

## Objective

Design a complete PDSA improvement project for a realistic quality problem.

## Scenario

A retail company's recommendation engine has an average click-through rate (CTR) of 3.2%, but the target is 5.0%. The team believes a new collaborative filtering algorithm will improve CTR.

## Instructions

Write a structured PDSA plan for this improvement project. For each phase, provide:

**Plan:**
- State the problem and current baseline.
- Define the objective (SMART goal).
- State your hypothesis and prediction.
- Describe what data you will collect and how.

**Do:**
- Describe the small-scale pilot (which users? which routes? duration?).
- What safety measures are in place to limit risk?

**Study:**
- What statistical tool(s) will you use to determine if the CTR improved?
- How will you distinguish real improvement from random variation?
- What is your decision threshold (p-value or control chart signal)?

**Act:**
- If the experiment succeeds: what specifically gets standardised?
- If it fails: what is the next hypothesis to test?

## Deliverable

Write your PDSA plan as structured text in a Python file `task_pdsa_plan.py` using `print()` statements or multi-line string variables. It should be readable as a document.

## Criteria

- All four phases are addressed: 40%
- Statistical tool in the Study phase is appropriate and correctly described: 30%
- Pilot design limits risk appropriately: 15%
- Act phase handles both success and failure: 15%
