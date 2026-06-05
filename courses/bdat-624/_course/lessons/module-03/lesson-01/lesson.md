# Lesson 1: Branching Processes — Extinction and Population Growth

## Goal

Derive the Galton-Watson branching process model, prove by induction that E(Xₙ) = μⁿ, characterise the extinction probability as the smallest positive root of G(q) = q, and apply the result to a viral infection model.

## Concept

### Motivation: The Question of Extinction

Imagine a viral infection. One virion enters a host cell, hijacks its machinery, and produces offspring virions. Each offspring virion then independently infects a new cell and produces its own offspring — and so on, generation by generation. The fundamental question: will this viral lineage survive forever, or will it die out?

This is the central question of **branching process theory**: given a population where each individual independently reproduces according to the same offspring distribution, what is the probability of ultimate extinction?

The model was originally proposed by Galton and Watson in the 1870s to study whether family surnames would die out — but today its applications span viral epidemics, cancer cell evolution, neutron chain reactions, and extinct species populations.

### The Galton-Watson Model

**Setup:** Let Xₙ denote the population size (number of individuals) in generation n, with X₀ = 1 (the process starts with a single ancestor). Each individual in generation n independently produces a random number of offspring.

> **Notation block:**
> - Xₙ — population size in generation n; read "X sub n"
> - X₀ = 1 — the initial ancestor (one virion, one bacterium, one cell)
> - ξ — the **offspring random variable**; the number of offspring produced by one individual; read "xi"
> - pₖ = P(ξ = k) — probability that one individual produces exactly k offspring; read "p sub k"
> - {pₖ, k = 0, 1, 2, ...} — the **offspring distribution**; must satisfy Σₖ pₖ = 1 and pₖ ≥ 0

**The key rule:** Individual i in generation n independently produces ξᵢₙ offspring, where ξ₁ₙ, ξ₂ₙ, ... are all independent and identically distributed (i.i.d.) with the offspring distribution {pₖ}.

The population in generation n+1 is the total offspring of all Xₙ individuals:

$$X_{n+1} = \sum_{i=1}^{X_n} \xi_{i,n}$$

> **Notation block:**
> - Σᵢ₌₁^{Xₙ} — sum over i from 1 to Xₙ; but Xₙ is itself random, so this is a **random sum** (a sum with a random number of terms)
> - ξᵢ,ₙ — the offspring of individual i in generation n; independent across i and across n

If Xₙ = 0, the population is extinct: no offspring can be produced, so X_{n+1} = 0 also.

### Probability Generating Function

> **Notation block:**
> - G(s) — the **probability generating function** (PGF) of the offspring distribution; read "G of s"
> - s — a real number in [0, 1]; the argument of the PGF (a dummy variable, not a probability itself)
> - E(sˣ) — the expected value of s raised to the power of the random variable X; read "expected value of s to the X"

The PGF of the offspring distribution {pₖ} is:

$$G(s) = \mathrm{E}(s^\xi) = \sum_{k=0}^{\infty} p_k s^k$$

Properties of G:
- G(0) = p₀ (probability of zero offspring)
- G(1) = Σₖ pₖ = 1 (must equal 1 since probabilities sum to 1)
- G'(s) = Σₖ k pₖ sᵏ⁻¹, so G'(1) = Σₖ k pₖ = E(ξ) = μ (the mean offspring number)

> **Notation block:**
> - μ = E(ξ) = G'(1) — the **mean offspring number** (mean number of children per individual); read "mu"

### Proof: E(Xₙ) = μⁿ

We prove by induction that the expected population size in generation n equals μⁿ.

**Claim:** E(Xₙ) = μⁿ for all n ≥ 0.

**Base case (n = 0).** E(X₀) = 1 = μ⁰. ✓

> **Notation:** E(X₀) = 1 because we start with exactly one ancestor; μ⁰ = 1 by the convention that anything raised to the 0 is 1.

**Inductive hypothesis.** Assume E(Xₙ) = μⁿ for some fixed n ≥ 0.

**Inductive step:** We must show E(Xₙ₊₁) = μⁿ⁺¹.

**Step 1: Condition on Xₙ using the tower property.**

> **Notation:** E[E(Y|X)] = E(Y) — the **tower property** (or law of iterated expectations); read "expected value of the conditional expected value equals the unconditional expected value"

$$\mathrm{E}(X_{n+1}) = \mathrm{E}\!\left[\mathrm{E}(X_{n+1} \mid X_n)\right]$$

This is valid because we can first average over possible values of Xₙ (the inner expectation), then average over those values (the outer expectation).

**Step 2: Compute the inner conditional expectation.**

Given Xₙ = k, the population Xₙ₊₁ is the sum of k independent copies of the offspring variable ξ:

$$\mathrm{E}(X_{n+1} \mid X_n = k) = \mathrm{E}\!\left(\sum_{i=1}^{k} \xi_i\right) = \sum_{i=1}^{k} \mathrm{E}(\xi_i) = k \mu$$

> **Annotation:** The first equality uses the definition of Xₙ₊₁. The second equality uses linearity of expectation. The third uses E(ξᵢ) = μ for each i (all offspring variables have the same mean). The result is kμ — if there are k parents and each produces an average of μ offspring, total offspring averages kμ.

Therefore, as a function of the random variable Xₙ:

$$\mathrm{E}(X_{n+1} \mid X_n) = X_n \cdot \mu$$

**Step 3: Apply the outer expectation.**

$$\mathrm{E}(X_{n+1}) = \mathrm{E}\!\left[X_n \cdot \mu\right] = \mu \cdot \mathrm{E}(X_n) = \mu \cdot \mu^n = \mu^{n+1}$$

> **Annotation:** The first equality applies the tower property result from Step 2. The second takes μ outside the expectation (μ is a constant). The third applies the inductive hypothesis E(Xₙ) = μⁿ. The product μ × μⁿ = μⁿ⁺¹ completes the induction. ∎

Here's the key insight: the expected population grows geometrically at rate μ per generation. If μ > 1, the expected size grows exponentially. If μ < 1, the expected size decays to zero exponentially. If μ = 1, the expected size stays constant. However — critically — E(Xₙ) being large does not prevent extinction; it is the *probability of extinction* q that tells us whether the lineage survives.

### Extinction Probability

> **Notation block:**
> - q — the **extinction probability**; q = P(the process eventually reaches 0 | X₀ = 1); read "q"
> - qₙ = P(Xₙ = 0) — probability of extinction by generation n; q = limₙ→∞ qₙ

**The extinction equation.** The extinction probability q is the smallest non-negative root of the fixed-point equation:

$$q = G(q)$$

**Why?** Here is the derivation. Condition on the first generation offspring count ξ:

$$q = P(\text{extinction}) = \sum_{k=0}^{\infty} P(\text{extinction} \mid X_1 = k) \cdot p_k$$

If X₁ = k, then the process splits into k independent branching processes, each starting from one individual. Each of these independent sub-processes must also go extinct (since they are independent and each starts from one individual with the same offspring distribution). So:

$$P(\text{extinction} \mid X_1 = k) = q^k$$

Therefore:

$$q = \sum_{k=0}^{\infty} q^k p_k = G(q)$$

The extinction probability q satisfies q = G(q) — it is a fixed point of the PGF.

**Three cases based on μ:**

**Case 1: μ < 1 (sub-critical).** The mean offspring is less than 1. The only solution to G(q) = q in [0,1] is q = 1. Extinction is certain.

**Case 2: μ = 1 (critical).** By the convexity of G, the unique fixed point in [0,1] is still q = 1 (unless the offspring distribution is degenerate). Extinction is certain, but it takes a long time.

**Case 3: μ > 1 (super-critical).** G(q) = q has two solutions in [0,1]: q = 1 (which corresponds to the trivial case) and a unique smaller root q* < 1. The extinction probability is this smaller root q* < 1. The process has a positive probability (1 - q*) of surviving forever.

Here's the key insight: even when μ > 1 (the population can grow), extinction is not guaranteed to fail — there is always a positive probability of extinction due to early-generation stochastic fluctuations where all lineages happen to die out.

**Finding q numerically.** For a given PGF G, iterate the map q_{n+1} = G(qₙ) starting from q₀ = 0. This sequence converges to the extinction probability q (the smallest non-negative fixed point of G).

## Example

**Viral infection with a Poisson offspring distribution.**

Model: each virion infects exactly one cell and the cell produces a random number of new virions. Suppose the offspring distribution is Poisson with mean μ = 1.5.

> **Notation:** ξ ~ Poisson(λ) with λ = μ = 1.5; pₖ = e^{-λ}λᵏ/k! for k = 0, 1, 2, ...

**Step 1: PGF.** The PGF of a Poisson(λ) random variable is:

$$G(s) = e^{\lambda(s-1)}$$

(This can be verified: Σₖ e^{-λ}λᵏ/k! × sᵏ = e^{-λ} Σₖ (λs)ᵏ/k! = e^{-λ}e^{λs} = e^{λ(s-1)}.)

**Step 2: Extinction equation.** Solve q = G(q) = e^{λ(q-1)} with λ = 1.5.

This is a transcendental equation — no closed form. We solve it by the iteration q_{n+1} = e^{1.5(qₙ - 1)} starting from q₀ = 0:

- q₀ = 0
- q₁ = e^{1.5(0-1)} = e^{-1.5} ≈ 0.2231
- q₂ = e^{1.5(0.2231-1)} ≈ e^{-1.165} ≈ 0.3114
- q₃ ≈ e^{1.5(0.3114-1)} ≈ e^{-1.033} ≈ 0.3562
- ...continuing... converges to q* ≈ 0.4174

**Interpretation:** With Poisson(1.5) offspring and one initial virion, the probability of ultimate extinction is approximately 41.7%. The probability of long-term viral persistence (the infection "taking hold") is approximately 1 - 0.417 = 58.3%.

Note: this is precisely the biological threshold for the **basic reproduction number** R₀ in epidemiology — R₀ = μ = 1.5 here. R₀ > 1 does not guarantee an epidemic; it only means an epidemic is *possible* with probability 1 - q*.

## Task

See `exercise.R`. You will simulate 1000 independent branching process trajectories for 50 generations with Poisson(μ=1.5) offspring, compute the empirical extinction probability over generations, and compare to the theoretical q* ≈ 0.417.

## Check

```
npm run check -- bdat-624 module-03 lesson-01
```

## Reflection

In the Galton-Watson model, the offspring distribution is the *same* for every individual in every generation. In a viral epidemic context, this ignores **superspreaders**: individuals who infect far more than average. Suppose the offspring distribution has mean μ = 1.5 (same as Poisson) but a much heavier tail (higher variance). Does a higher variance in offspring number increase or decrease the extinction probability q? What does this imply for epidemic control strategies that target superspreader events (large gatherings) versus strategies that uniformly reduce contact rates?
