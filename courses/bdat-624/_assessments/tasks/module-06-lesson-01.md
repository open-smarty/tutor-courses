# Task: Module 6, Lesson 1 — Competing Risks and Multi-State Models

## Context

You have reached the end of BDAT 624. Arc 1 (Modules 1–4) built up the theory of stochastic processes: Markov chains, branching processes, Poisson processes, and birth-death processes. Arc 2 (Modules 5–6) developed survival analysis: Kaplan-Meier estimation, Cox regression, AFT models, and now competing risks and multi-state models. This task asks you to draw the connections explicitly.

---

## Questions

### Part (a) — Multi-State Model in R

A patient can move between three health states:

- **H** = Healthy (state 1)
- **S** = Sick / diseased (state 2)
- **D** = Dead (state 3, absorbing)

The following transitions are possible: H → S (onset), H → D (sudden death while healthy), S → D (death from disease), S → H (recovery).

Assume a time-homogeneous continuous-time Markov chain with the following annual transition rates:

| Transition | Rate |
|---|---|
| H → S | q₁₂ = 0.10 per year |
| H → D | q₁₃ = 0.02 per year |
| S → D | q₂₃ = 0.15 per year |
| S → H | q₂₁ = 0.05 per year |

**(i)** Write the 3 × 3 transition intensity matrix Q. Confirm that every row sums to zero.

**(ii)** In R, compute and print P(t) = exp(Qt) for t = 1, 5, and 10 years using the `expm` package:

```r
library(expm)
Q <- matrix(c(-0.12,  0.10, 0.02,
               0.05, -0.20, 0.15,
               0,     0,    0   ), nrow = 3, byrow = TRUE)
P1  <- expm(Q * 1)
P5  <- expm(Q * 5)
P10 <- expm(Q * 10)
```

For a patient starting in state H (state 1), extract and report:
- P(Healthy at year 1 | Healthy at year 0)
- P(Dead at year 5 | Healthy at year 0)
- P(Dead at year 10 | Healthy at year 0)

**(iii)** What happens to P(t) as t → ∞? Describe in words and verify numerically by computing expm(Q * 100). Why does every row of P(∞) place all probability mass on state 3?

---

### Part (b) — Competing Risks Interpretation

Now treat the same three-state system as a competing risks problem from the perspective of a Healthy patient. The two competing risks are:

- **Cause 1:** Direct death from the healthy state (H → D), with cause-specific hazard q₁₃ = 0.02 per year.
- **Cause 2:** Disease-then-death pathway (H → S → D). This is more complex because it passes through state S.

**(i)** For the direct pathway (Cause 1), what is the cause-specific cumulative incidence F₁(t) in a competing-risks model that also includes the disease pathway? Can you compute F₁(t) exactly from the overall survival S(t) = exp(−(q₁₂ + q₁₃)t)? Discuss qualitatively whether treating the H → S transition as censoring would overestimate or underestimate F₁(t).

**(ii)** Qualitatively: how does the existence of the S → D pathway affect the cumulative incidence of "overall death" (from any cause) compared to a simpler model that only includes direct H → D death? Does the two-pathway model produce a higher or lower overall CIF, and why?

You do not need to derive a closed-form CIF for part (b) — clear qualitative reasoning with reference to the formulas from the lesson is sufficient.

---

### Part (c) — Arc Connection (Written, No Code)

In 3–4 sentences, explain how the birth-death process from Module 4 (Arc 1) connects to the Cox proportional hazards model from Module 5 (Arc 2). Address all three of the following:

1. What quantity in the birth-death process is analogous to the hazard function h(t) in survival analysis?
2. What does the diagonal of the generator matrix Q correspond to in a survival analysis context?
3. What does the birth-death extinction probability q (the smallest non-negative root of the offspring p.g.f. fixed-point equation) correspond to in survival analysis — is there a quantity that plays the same conceptual role?

---

## Submission Checklist

- [ ] Part (a)(i): Q matrix written out explicitly with row sums verified equal to zero
- [ ] Part (a)(ii): R code for matrix exponential; P₁₁(1), P₁₃(5), P₁₃(10) reported numerically
- [ ] Part (a)(iii): description of limiting behaviour; expm(Q * 100) printed and interpreted
- [ ] Part (b)(i): qualitative discussion of F₁(t) and the direction of KM bias
- [ ] Part (b)(ii): qualitative comparison of one-pathway vs. two-pathway CIF for overall death
- [ ] Part (c): 3–4 sentences addressing all three arc-connection questions

---

## Marking Notes

| Part | Marks | Key criteria |
|------|-------|--------------|
| (a)(i) | 2 | Q correct; rows sum to 0 shown explicitly |
| (a)(ii) | 3 | Correct R code using expm; correct numerical values for P₁₁(1), P₁₃(5), P₁₃(10) |
| (a)(iii) | 2 | Correct identification of absorbing state; P(∞) described correctly |
| (b)(i) | 2 | Direction of KM bias correctly identified and justified using the CIF formula |
| (b)(ii) | 2 | Correct reasoning: two pathways lead to higher overall CIF |
| (c) | 4 | Total leaving rate ↔ overall hazard; extinction probability ↔ survival probability at t→∞ or probability of never dying from a specific cause; clear and accurate analogies |

**Total: 15 marks**
