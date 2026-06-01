# Lesson 1: Competing Risks and Multi-State Models

## Goal

By the end of this lesson you will be able to define cause-specific and subdistribution hazards, compute and interpret the Cumulative Incidence Function (CIF) for competing risks, explain why the Kaplan-Meier estimator overestimates cause-specific cumulative incidence, fit the Fine-Gray model in R, and connect multi-state models to the continuous-time Markov chains from Arc 1 — including writing the transition intensity matrix Q and computing transition probabilities via the matrix exponential P(t) = exp(Qt).

## Concept

### Opening — The Arc Connection

We have come full circle. In Arc 1 we studied Markov chains — processes that jump between states. In Arc 2 we studied survival analysis — the time until a patient transitions from "alive" to "dead". Now we combine both ideas: patients can transition to *multiple* possible endpoints (relapse, non-cancer death, complete remission), and the transitions happen in continuous time. This is the world of competing risks and multi-state models.

---

### Part 1: Competing Risks

#### Motivation

Consider a patient with leukaemia. Three things might happen first: (a) they die from the leukaemia, (b) they die from another cause such as heart disease, or (c) they achieve complete remission. These are three **competing events** — whichever happens first "wins" and prevents the others from occurring.

The temptation is to analyse leukaemia death using Kaplan-Meier, treating non-leukaemia death as ordinary censoring. This is wrong. Here's the key insight: a patient who dies of heart disease was not censored in the usual sense — they did not "escape" observation of the leukaemia outcome. They were permanently removed from the risk set by a competing event. Treating them as censored inflates the apparent risk of leukaemia death.

---

#### Cause-Specific Hazard

> **Notation:** K — the number of distinct event types (causes). We label causes k = 1, 2, ..., K.

> **Notation:** hₖ(t) — the **cause-specific hazard** for cause k. This is the instantaneous rate of cause-k events at time t, among individuals who have not yet experienced *any* event.

$$h_k(t) \,\Delta t \approx P(\text{event of type } k \text{ in } (t,\, t+\Delta t] \mid \text{no event before } t)$$

> **Notation:** h(t) — the **overall hazard**, equal to the sum of all cause-specific hazards:

$$h(t) = \sum_{k=1}^{K} h_k(t)$$

> **Notation:** S(t) — the **overall survival function**, the probability of experiencing no event of any type before time t:

$$S(t) = \exp\!\left(-\int_0^t h(u)\,du\right) = \exp\!\left(-\sum_{k=1}^{K} H_k(t)\right)$$

where $H_k(t) = \int_0^t h_k(u)\,du$ is the cumulative cause-specific hazard for cause k.

---

#### Cumulative Incidence Function (CIF)

> **Notation:** Fₖ(t) — the **Cumulative Incidence Function** (CIF) for cause k. This is the probability that a subject experiences a cause-k event *by time t*, accounting for the fact that competing events can occur first.

$$F_k(t) = P(T \leq t \;\text{AND cause} = k) = \int_0^t h_k(u) \cdot S(u) \; du \tag{1}$$

The integrand $h_k(u) \cdot S(u)$ has a natural reading: $S(u)$ is the probability of being "event-free" up to time u, and $h_k(u)$ is the rate of cause-k events at that instant. Integrating over $[0, t]$ accumulates the probability of a cause-k event occurring at each instant while still at risk.

**Critical property:**

$$\sum_{k=1}^{K} F_k(t) = 1 - S(t) \leq 1$$

The CIFs sum to the overall event probability, not to 1 individually. This is why you cannot simply add the KM curves for each cause — they would sum to more than 1 - S(t).

---

#### Why KM Overestimates Cause-Specific Cumulative Incidence

When KM analysis treats competing events as censored, it estimates the hypothetical probability of cause k in a world where competing events *cannot* happen. This is larger than the real-world probability, because in reality competing events remove individuals from the risk set before cause k can claim them.

**Numerical example.** 10 patients at time 0.

| Time | Event |
|------|-------|
| t = 1 | 2 die of cause 1, 1 dies of cause 2 |
| t = 2 | 1 dies of cause 1, 1 dies of cause 2 |

*KM estimate for cause 1* (treating cause-2 deaths as censored):
- At t=1: risk set = 10, cause-1 events = 2. KM hazard: 2/10. At t=1⁺: KM = 1 – 2/10 = 0.80. Cause-2 death censors 1 individual.
- At t=2: risk set = 10 – 2 – 1 = 7 (3 events, no censoring before t=2), KM hazard at t=2: 1/7. KM(2) = 0.80 × (1 – 1/7) ≈ 0.686.
- "1 – KM" estimate of cause-1 cumulative incidence at t=2: 1 – 0.686 = **0.314**.

*CIF estimate for cause 1* using equation (1):
- At t=1: S(1⁻) = 1. Events: h₁ contributes 2/10, h₂ contributes 1/10. S(1) = 1 – 3/10 = 0.70.
  F₁(t=1) ≈ (2/10) × 1 = **0.200**.
- At t=2: S(2⁻) = 0.70. Risk set at t=2: 7 survivors. h₁ contributes 1/7, h₂ contributes 1/7.
  F₁(t=2) ≈ 0.200 + (1/7) × 0.70 = 0.200 + 0.100 = **0.300**.

Here's the key insight: KM gives 0.314, CIF gives 0.300. KM *overestimates* by about 5%. In real data with many competing events, the bias is much larger.

---

#### The Fine-Gray Model

> **Notation:** $\tilde{h}_k(t)$ — the **subdistribution hazard** for cause k. Unlike the cause-specific hazard, the risk set for $\tilde{h}_k$ *retains* subjects who have experienced competing events. They remain "at risk" at $-\infty$ for the subdistribution.

$$\tilde{h}_k(t) = \lim_{\Delta t \to 0} \frac{P(t \leq T < t+\Delta t,\; \text{cause}=k \mid T \geq t \;\text{ or }\; (T < t \;\text{ and cause} \neq k))}{\Delta t}$$

The CIF links directly to the subdistribution hazard:

$$F_k(t) = 1 - \exp\!\left(-\int_0^t \tilde{h}_k(u)\,du\right) \tag{2}$$

The **Fine-Gray proportional subdistribution hazards model** specifies:

$$\tilde{h}_k(t \mid \mathbf{X}) = \tilde{h}_{k0}(t) \cdot \exp(\boldsymbol{\gamma}' \mathbf{X}) \tag{3}$$

> **Notation:** γ — the vector of Fine-Gray regression coefficients. exp(γⱼ) is the **subdistribution hazard ratio** for the j-th covariate.

Because of equation (2), a subdistribution hazard ratio > 1 directly implies a higher CIF, i.e., a higher probability of experiencing cause k by any fixed time t. This direct link to the observable probability is what distinguishes Fine-Gray from the cause-specific Cox model.

#### When to Use Which Model

| Question | Model |
|---|---|
| "What is the biological mechanism by which covariate X affects cause-k death?" | Cause-specific Cox |
| "What is the predicted probability of cause-k event by time t for this patient?" | Fine-Gray |

---

### Part 2: Multi-State Models

#### Motivation

Survival analysis tracks one transition: Alive → Dead. Real disease trajectories are richer: Alive → Remission → Relapse → Dead, or Healthy → Diseased → Recovered (or Dead). A **multi-state model** is a stochastic process in which individuals move among a set of health states, with transition rates that may depend on covariates and time.

Here's the key insight: this is precisely the continuous-time Markov chain from Module 2. The health states are the states of the chain; the transition rates are the cause-specific hazards between pairs of states; and the generator matrix Q is the continuous-time analogue of the one-step transition matrix P from discrete-time chains.

---

#### Transition Intensities and the Generator Matrix

> **Notation:** S — a finite set of health states, labelled 1, 2, ..., m.

> **Notation:** qᵢⱼ(t) — the **transition intensity** from state i to state j at time t (i ≠ j). This is the instantaneous rate of i → j transitions:

$$q_{ij}(t)\,\Delta t \approx P(\text{transition } i \to j \text{ in } (t,\, t+\Delta t] \mid \text{in state } i \text{ at time } t)$$

> **Notation:** Q — the **transition intensity matrix** (also called the **generator matrix** or **Q matrix**). For an m-state model, Q is an m × m matrix with:
> - Off-diagonal entries: $Q_{ij} = q_{ij}(t) \geq 0$ for $i \neq j$
> - Diagonal entries: $Q_{ii} = -\sum_{j \neq i} q_{ij}(t)$ (negative sum of row's off-diagonal entries)
> - Every row sums to zero.

The diagonal entry $q_{ii}$ is the rate of *leaving* state i by any route. This is the continuous-time analogue of the row-sum condition on transition matrices from Module 2, Lesson 1.

---

#### Example: The 3-State Illness-Death Model

States: 1 = Healthy, 2 = Ill (diseased), 3 = Dead.

Allowed transitions: 1 → 2 (onset of disease), 1 → 3 (death from healthy state), 2 → 3 (death from diseased state), 2 → 1 (recovery, if modelled).

$$Q = \begin{pmatrix} -q_{12} - q_{13} & q_{12} & q_{13} \\ q_{21} & -q_{21} - q_{23} & q_{23} \\ 0 & 0 & 0 \end{pmatrix}$$

State 3 is **absorbing** (no transitions out), so its row is all zeros.

With example rates q₁₂ = 0.08, q₁₃ = 0.02, q₂₁ = 0.04, q₂₃ = 0.12:

$$Q = \begin{pmatrix} -0.10 & 0.08 & 0.02 \\ 0.04 & -0.16 & 0.12 \\ 0 & 0 & 0 \end{pmatrix}$$

---

#### The Transition Probability Matrix — Connecting to Arc 1

> **Notation:** P(s, t) — the **transition probability matrix** from time s to time t. Entry Pᵢⱼ(s, t) = P(in state j at time t | in state i at time s).

For a time-homogeneous model (constant Q), the transition probability matrix from time 0 to time t is:

$$P(t) = \exp(Qt) \tag{4}$$

where exp denotes the **matrix exponential**: $\exp(Qt) = I + Qt + \frac{(Qt)^2}{2!} + \frac{(Qt)^3}{3!} + \cdots$

Here's the key insight: this is exactly the continuous-time analogue of the discrete-time result $P^n$ from Module 2, Lesson 2. There, raising the transition matrix to the n-th power gave the n-step transition probabilities. Here, the matrix exponential of Qt gives the t-time transition probabilities. The two are connected: as we take smaller and smaller time steps Δt, the discrete chain with transition matrix $I + Q\Delta t$ converges to the continuous process with generator Q.

As $t \to \infty$, $P(t)$ converges to a limiting matrix where each row equals the stationary distribution $\pi$ satisfying $\pi Q = 0$ — provided all states communicate (recalling Module 2, Lesson 3 on ergodicity). For models with absorbing states (like State 3 = Dead), every row of $P(\infty)$ has all probability mass on the absorbing states.

---

#### Example: 4-State CAV Model (Cardiac Allograft Vasculopathy)

The `cav` dataset from the `msm` package tracks cardiac transplant patients observed at clinic visits. States: 1 = no CAV, 2 = mild CAV, 3 = moderate/severe CAV, 4 = dead.

Allowed transitions (not all; typically forward disease progression and death from any living state, plus a possible 3 → 2 regression term):

$$Q = \begin{pmatrix}
-q_{12}-q_{14} & q_{12} & 0 & q_{14} \\
q_{21} & -q_{21}-q_{23}-q_{24} & q_{23} & q_{24} \\
0 & q_{32} & -q_{32}-q_{34} & q_{34} \\
0 & 0 & 0 & 0
\end{pmatrix}$$

We fit this model using `msm()`, which estimates all intensities simultaneously by maximum likelihood from the panel-observed data (patients seen at discrete clinic visits, not continuously monitored). The fitted Q matrix gives us estimates of all qᵢⱼ.

Covariates enter via the **proportional intensities** model:

$$\log q_{ij}(t \mid \mathbf{X}) = \log q_{ij,0}(t) + \boldsymbol{\beta}' \mathbf{X}$$

This is the multi-state analogue of the Cox model: each transition intensity has a baseline rate, multiplied by exp(β′X).

From the fitted model, we compute:

$$P(t) = \exp(Qt)$$

using `pmatrix.msm()` in R. For example, $P_{13}(5)$ gives the probability that a patient with no CAV at baseline will have moderate/severe CAV five years later.

---

## Example

### Worked Example: Numerical CIF vs. KM Comparison

We build on the 10-patient example from the Concept section and verify equation (1) step-by-step.

Events:
- t = 1: subjects 1, 2 die of cause 1; subject 3 dies of cause 2.
- t = 2: subject 4 dies of cause 1; subject 5 dies of cause 2.
- Subjects 6–10 are censored at t = 3.

**Step 1. Compute overall survival S(t).**

$S(0) = 1$.

At t = 1: three events of any cause out of 10 at risk. $S(1) = 1 - 3/10 = 0.70$.

At t = 2: two events out of 7 at risk (survivors from t=1). $S(2) = 0.70 \times (1 - 2/7) = 0.70 \times 5/7 \approx 0.50$.

**Step 2. Compute CIF for cause 1.**

$$F_1(1) = h_1(1) \cdot S(1^-) = \frac{2}{10} \times 1 = 0.200$$

$$F_1(2) = F_1(1) + h_1(2) \cdot S(2^-) = 0.200 + \frac{1}{7} \times 0.70 = 0.200 + 0.100 = 0.300$$

**Step 3. Compute 1 − KM₁(t)** treating cause-2 deaths as censored.

At t = 1: 2 cause-1 events; 1 cause-2 death is a "censor". Risk set = 10. KM₁(1) = 1 − 2/10 = 0.800.

At t = 2: 1 cause-1 event; 1 cause-2 death is a "censor". Risk set = 7. KM₁(2) = 0.800 × (1 − 1/7) ≈ 0.686.

1 − KM₁(2) = **0.314** vs. CIF = **0.300**.

The overestimation is 0.014 in this small example. As the competing event rate increases relative to the cause of interest, this gap widens substantially.

---

### Worked Example: Matrix Exponential for the Illness-Death Model

Using Q from the 3-state example (q₁₂ = 0.08, q₁₃ = 0.02, q₂₁ = 0.04, q₂₃ = 0.12) and t = 5 years, in R:

```r
library(expm)
Q <- matrix(c(-0.10,  0.08, 0.02,
               0.04, -0.16, 0.12,
               0,     0,    0   ), nrow = 3, byrow = TRUE)
P5 <- expm(Q * 5)
```

Reading row 1 of P(5): a healthy patient has approximately
- P₁₁(5) ≈ probability of still being Healthy after 5 years
- P₁₂(5) ≈ probability of being Ill after 5 years
- P₁₃(5) ≈ probability of being Dead after 5 years

(Exact values depend on the matrix eigenstructure; you will compute these in the exercise.)

---

## Task

Open `exercise.R`. You will work through two interconnected parts.

**Part 1: Competing Risks** uses the `bmt` dataset from `KMsurv` (bone marrow transplant outcomes). You will estimate CIFs for two competing causes (disease-related failure vs. transplant-related mortality), compare the CIF to the naive KM estimator, and fit a Fine-Gray regression model.

**Part 2: Multi-State Models** uses the `cav` dataset from `msm`. You will fit a 4-state illness-death model, interpret the estimated intensity matrix, and compute transition probabilities at multiple time horizons.

Fill in every `# TODO:` marker and run:

```
npm run check -- bdat-624 module-06 lesson-01
```

## Check

```
npm run check -- bdat-624 module-06 lesson-01
```

## Reflection

This lesson closed the arc connecting Modules 1–6. Consider the following synthesis question.

In Module 4 we studied the birth-death process, where the state space is {0, 1, 2, ...} and transitions move up (births) or down (deaths) one step at a time. The extinction probability q satisfies a fixed-point equation in the offspring p.g.f. In Module 5 we studied the Cox proportional hazards model, where the hazard function h(t|X) = h₀(t) · exp(β′X) governs the time to a single event.

In 3–4 sentences: what are the analogous quantities between the birth-death process and the Cox model? In particular, what does the total rate of leaving a state (the diagonal of Q) correspond to in the Cox model? And what does the birth-death extinction probability correspond to — is there a survival-analysis quantity that plays the same role?
