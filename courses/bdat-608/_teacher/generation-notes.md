# Generation Notes — BDAT 608

## Resources Found

| Resource | Path | Used For |
|----------|------|----------|
| Lecture slides PDF (144 slides) | `resources/slides/BDAT608_Ch4_2.pdf` | Primary content source; module order follows slide order |
| Lecture Rmd (1803 lines) | `resources/slides/BDAT608_Model_Basics.Rmd` | Code, explanations, and exercises extracted verbatim |
| Full study script | `resources/exercises/BDAT608_Model_Basics_full_study_script.R` | Exercise starter code adapted from this |
| Evening/week script | `resources/exercises/BDAT608_Eve.R` | Supplementary sparklyr + Week 2–3 examples |
| Playground | `resources/exercises/playground.R` | Additional examples |
| Compiled HTML | `resources/BDAT608_Model_Basics.html` | Reference output |

## Structural Decisions

- **Module order follows the lecture slide outline exactly**: Introduction → Fitting → Visualising → Formulas → Missing Values → Beyond Linear → Case Studies.
- **6 modules, 14 lessons** mirroring the BDAT-614 and BDAT-624 hub conventions.
- **Exercise/solution files are .Rmd** (not .html) because the course is R-based and the instructor specified knitting as the expected workflow.
- Module 4 absorbs both "Missing Values" and "Splines/CV" (lecture sections 5–6) to keep module 5 focused on the beyond-linear family.
- Module 6 is a single extended lesson covering all three case studies (diamonds, flights, nls) matching the "Extended Case Studies + Summary and Exercises" lecture section.

## Quiz Design Notes

- Quiz questions are written to test understanding, not recall; they cannot be answered by copying lecture text.
- Difficulty escalates within each module: Q1–Q2 recall, Q3–Q4 apply, Q5 analyse/evaluate.
- E-series exercise questions (E1–E7) from the Rmd informed task files and some quiz questions.

## Code Colour Scheme (from source)

- Navy `#1B3A6B` for data/observation points
- Gold `#C9A84C` for fitted values / model lines
