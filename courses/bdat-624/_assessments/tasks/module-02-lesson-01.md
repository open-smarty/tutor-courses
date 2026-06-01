# Task: Module 2, Lesson 1 — Design a Biological Transition Matrix

## Overview

You will design a 4-state Markov chain model for a biological system of your choice, construct its transition probability matrix, and verify its mathematical properties.

---

## Instructions

### Step 1: Choose your biological system

Select one of the following (or propose your own with instructor approval):

- **Immune response progression:** Naive → Activated → Exhausted → Memory
- **Cancer staging:** Localised → Regional → Metastatic → Remission
- **Ecological population states:** Thriving → Stressed → Collapsed → Recovered
- **Drug response:** Susceptible → Partially resistant → Fully resistant → Cleared

Name your four states clearly and give a brief (1–2 sentence) biological interpretation of each.

---

### Step 2: Construct the transition probability matrix

Write a 4×4 TPM **P** where $P_{ij}$ is the monthly (or per-observation-period) probability of transitioning from state i to state j.

**For each non-zero off-diagonal entry**, write one sentence justifying the biological rationale. For example: "P_{01} = 0.15 because approximately 15% of patients in the localised stage progress to regional disease per month, based on published staging data."

You do not need real data — but your probabilities should be *plausible* for the system you described.

---

### Step 3: Verify the stochastic matrix properties

Explicitly check both required properties:

1. **Non-negativity:** confirm all entries are ≥ 0.
2. **Row sums:** compute each row sum and confirm all equal 1.

Show your working (a small table or the R output of `rowSums()` is sufficient).

---

### Step 4: Identify absorbing states

For each state, determine whether it is absorbing (i.e., $P_{ii} = 1$).

- If your model has an absorbing state, name it and explain why it is biologically irreversible.
- If your model has **no** absorbing states, explain what this means for the long-run behaviour of the system — will all states be visited indefinitely?

---

### Step 5: Reflection

Answer the following in 3–5 sentences:

> "Your TPM encodes the assumption that transition probabilities are constant over time (time-homogeneity). For your chosen biological system, over what time horizon is this assumption reasonable? What biological event or process would cause the assumption to break down, and how would you modify the model?"

---

## Submission format

Submit a short written report (approx. 300–500 words) containing:

- Your system description and state definitions
- The 4×4 TPM (as a table or R matrix printout)
- One justification sentence per non-zero off-diagonal entry
- Your row-sum verification
- Identification of absorbing states (or explanation of why none exist)
- Your reflection answer

Include your R code (the `matrix()` definition and `rowSums()` call) as an appendix.

---

## Grading criteria

| Criterion | Marks |
|---|---|
| States are clearly defined with biological meaning | 20% |
| All TPM entries are non-negative and rows sum to 1 | 20% |
| Biological justification for non-zero entries is plausible | 30% |
| Absorbing states correctly identified (or absence explained) | 15% |
| Reflection on time-homogeneity is thoughtful and specific | 15% |
