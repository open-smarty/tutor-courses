# Task: Identify and Classify Stochastic Processes

## Instructions

Identify **three real stochastic processes** from your own area of interest — choose from biology, public health, or data science. For each process, answer the four questions below. Write your answers as structured comments in a new R file called `my_processes.R`.

Your R file does not need to run any simulations — this task is about articulating your understanding in writing.

---

## For each of your three processes, address:

1. **What does X(t) or X_n represent?**
   Describe in plain English what the random variable measures. Is it a count, a category, a continuous measurement? What are the units?

2. **What is the state space S?**
   List the possible values X can take. If the state space is discrete, enumerate the states. If it is continuous, describe the range (e.g., "all positive real numbers").

3. **What is the parameter space T?**
   Describe the index set. Is it discrete (daily, monthly, by generation) or continuous (any real time ≥ 0)? What are the units?

4. **What type is the process?**
   Classify it as one of:
   - Type I: Discrete time, discrete state
   - Type II: Continuous time, discrete state
   - Type III: Discrete time, continuous state
   - Type IV: Continuous time, continuous state

   Justify your choice in one or two sentences.

---

## Example R file structure

```r
# my_processes.R
# BDAT 624 — Module 1, Lesson 1 Task
# Student: [your name]

# ---- Process 1: [descriptive name] ----
# What X(t) represents:
#   ...
#
# State space S:
#   ...
#
# Parameter space T:
#   ...
#
# Type and justification:
#   ...

# ---- Process 2: [descriptive name] ----
# ...

# ---- Process 3: [descriptive name] ----
# ...
```

---

## Grading guidance

A strong response will:
- Use precise biological or epidemiological language to describe X(t)
- Be specific about the state space (e.g., "S = {0, 1, 2, ..., 10⁶}" rather than "S = counts")
- Correctly distinguish whether time in your system is best modelled as discrete or continuous, and defend that choice
- Choose three genuinely different types where possible — try not to submit three Type I processes
