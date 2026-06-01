# Generation Notes

## Pedagogical design principles

This course serves two masters simultaneously: **accessibility** and **rigour**. Every lesson must feel like a thoughtful tutor sitting next to the student, not a textbook.

### Notation must always be unpacked first

Before any formula appears, add a **Notation** callout that decodes every symbol in plain English with a one-line intuition. Example:

> **Notation:** P_{ij}^{(n)} — the probability of moving from state *i* to state *j* in exactly *n* steps. Read it as "n-step transition probability from i to j."

Never assume the reader knows what a subscript means. At MSc level, the notation *is* often the barrier.

### Structure every lesson as: Motivation → Concept → Worked Example → Task → Check → Reflection

- **Motivation** (2–3 sentences): why does this topic exist? What biological question does it answer?
- **Concept**: explain in plain English first, then give the formal definition. For mathematical derivations, show every algebraic step and annotate each step with what you're doing.
- **Worked Example**: use a realistic biological/health scenario (disease states, clinical trial outcomes, cell division, epidemics, patient queues)
- **Task**: R exercise file. Must require the student to write non-trivial code — not just fill in one line.
- **Check**: `npm run check -- bdat-624 module-XX lesson-YY`
- **Reflection**: a conceptual question that goes slightly beyond the lesson. No code required. Asks the student to reason about an edge case or connect to a real-world problem.

### R exercise files

- Use R (`.R` extension for exercise.R and solution.R)
- Start with the required library imports at the top
- Use realistic (not toy) scenarios — reference real R datasets where possible (`survival::lung`, `survival::veteran`, `KMsurv::bmt`, `msm` package vignettes)
- Each exercise should require 20–40 lines of student code
- The solution should be clean, well-commented, and demonstrate best practices

### Rigor requirements

The following must be present for the relevant lessons:
- **Chapman-Kolmogorov proof**: show both parts (a) discrete chains and (b) continuous time; annotate each step
- **Branching process**: derive E(Xₙ) = μⁿ by induction; explain each inductive step
- **Poisson process**: derive P_n(t) = e^{-λt}(λt)^n / n! from the differential equations — don't just state the result
- **Pure birth process**: show the integrating factor solution step by step
- **Birth-death extinction**: derive lim_{t→∞} P_0(t) and explain what ρ = λ/μ means biologically

### Tone

- Conversational but precise. Use "we" when doing derivations together. Use "you" when asking the student to do something.
- When introducing a tricky concept, say "Here's the key insight:" before the punch line.
- When a notation is dense, say "Let's unpack this notation before we go further."
- Connect every abstract result to a concrete biological application.

## Module and lesson plan

### Module 1: Foundations of Stochastic Processes (2 lessons)
- Lesson 1: What is a Stochastic Process? — intuition, definition, four types, notation decoder
- Lesson 2: Probability Distributions and Transition Probabilities — joint/conditional distributions, time-homogeneity, formal definition of TPM

### Module 2: Markov Chains (3 lessons)
- Lesson 1: The Markov Property and Transition Probability Matrices — Markov postulate, TPM construction, stochastic matrix properties
- Lesson 2: Chapman-Kolmogorov Equations and Stationary Distributions — CKE proof, n-step TPM = Pⁿ, limiting distribution, πP = π
- Lesson 3: State Classification — accessibility, communication, irreducibility, periodicity, ergodicity, regular chains

### Module 3: Branching and Counting Processes (2 lessons)
- Lesson 1: Branching Processes — Galton-Watson model, p.g.f., E(Xₙ) = μⁿ, Var(Xₙ), extinction probability theorem
- Lesson 2: Poisson and Renewal Processes — Poisson postulates, ODE derivation of P_n(t), waiting time = Gamma(n,λ), memoryless property

### Module 4: Birth-Death Processes (3 lessons)
- Lesson 1: The Pure Birth Process — Yule model (λₙ = nλ), ODE solution by integrating factor, negative binomial distribution, E and Var
- Lesson 2: The Pure Death Process — similar ODE approach, binomial distribution, comparing to birth process
- Lesson 3: The Birth-Death Process — combined ODE, linear growth model, extinction probability ρ = μ/λ, immigration extension

### Module 5: Survival Analysis (3 lessons)
- Lesson 1: Survival Functions and Kaplan-Meier — S(t), h(t), H(t) definitions and relationships; KM estimator derivation; log-rank test; R: `survfit`, `survdiff`
- Lesson 2: Cox Proportional Hazards Model — partial likelihood, hazard ratio interpretation, Schoenfeld residuals, R: `coxph`
- Lesson 3: Parametric Survival and AFT Models — Exponential, Weibull, log-normal; AFT vs PH parameterisations; hypothesis testing (Wald, LRT); R: `survreg`, `flexsurv`

### Module 6: Advanced Biostatistical Applications (1 lesson)
- Lesson 1: Competing Risks and Multi-State Models — cause-specific hazards vs subdistribution hazards; CIF; Fine-Gray model; connecting to CTMC; R: `mstate`, `cmprsk`, `msm`

Note: Module 6 has been consolidated to 1 rich lesson covering both competing risks and multi-state models, bringing the total to 14 lessons.
