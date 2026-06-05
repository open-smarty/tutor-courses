# Lesson 3: Birth-Death Process — Linear Growth and Extinction

## Goal

Define the linear birth-death process, introduce the PGF approach to derive key quantities, prove the extinction probability formula, and interpret the death-to-birth ratio ρ = μ/λ as the fundamental threshold parameter.

## Concept

### Motivation: Competing Birth and Death

The Yule process only grows; the pure death process only declines. Real biological populations do both simultaneously: bacteria divide AND die; cancer cells proliferate AND are cleared by the immune system; viral particles infect new cells AND are degraded. The **linear birth-death process** combines both forces.

The outcome — growth or extinction — depends on which force dominates. This competition is captured by a single ratio: ρ = μ/λ.

### Model Definition

> **Notation block:**
> - λₙ = nλ — birth rate when n individuals are present (each individual contributes λ independently); read "lambda sub n"
> - μₙ = nμ — death rate when n individuals are present (each individual dies at rate μ independently); read "mu sub n"
> - ρ = μ/λ — the **death-to-birth ratio**; read "rho"; the fundamental threshold parameter

Both birth and death rates are proportional to n — each of the n individuals independently gives birth at rate λ and independently dies at rate μ. This is called the **linear** birth-death process because both rates are linear in n.

The ODE system is:

$$\frac{dP_n}{dt} = \lambda(n-1)P_{n-1} - (\lambda+\mu)nP_n + \mu(n+1)P_{n+1}, \quad n \geq 1$$

$$\frac{dP_0}{dt} = \mu P_1$$

with P₁(0) = 1 (start with one individual), Pₙ(0) = 0 for n ≥ 2.

### Probability Generating Function Approach

Rather than solving the ODE system directly (which requires methods beyond this course for the full distribution), we use the **probability generating function (PGF)**.

> **Notation block:**
> - G(s, t) = Σₙ₌₀^∞ Pₙ(t) sⁿ — the PGF of N(t); read "G of s and t"
> - ∂G/∂t — partial derivative of G with respect to t; the PGF is a function of two variables: s (dummy) and t (time)
> - ∂G/∂s — partial derivative of G with respect to s; this gives E[N(t)] when evaluated at s=1 (after multiplying by appropriate factors)

Multiplying the ODE by sⁿ and summing over all n leads to the **PDE** (partial differential equation):

$$\frac{\partial G}{\partial t} = (\lambda s - \mu)(s - 1) \frac{\partial G}{\partial s}$$

This is a first-order linear PDE in s and t. Its derivation involves:

1. Multiply each ODE (for Pₙ) by sⁿ and sum over n=0,1,2,...
2. Recognise that Σₙ n Pₙ sⁿ⁻¹ = ∂G/∂s
3. Use index shifts to collect like terms

**Solving the PDE (outline).** The PDE ∂G/∂t = (λs-μ)(s-1) ∂G/∂s is solved by the **method of characteristics**: transform to characteristic curves along which the PDE becomes an ODE. The full solution (starting from G(s,0) = s — one individual) is:

$$G(s, t) = \left[\frac{\mu(s-1) - (\mu s - \lambda)\,e^{(\lambda-\mu)t}}{\lambda(s-1) - (\mu s - \lambda)\,e^{(\lambda-\mu)t}}\right] \quad \text{for } \lambda \neq \mu$$

From this, P₀(t) = G(0, t) gives the extinction probability by time t, and letting t → ∞ gives the long-run extinction probability.

### Deriving the Extinction Probability

The extinction probability q = P(eventual extinction | X₀ = 1) is the limit of P₀(t) as t → ∞.

Setting s = 0 in the PGF formula:

$$P_0(t) = G(0,t) = \frac{-\mu(1) - (-\mu)\,e^{(\lambda-\mu)t}}{\lambda(-1) - (-\mu)\,e^{(\lambda-\mu)t}} = \frac{\mu(e^{(\lambda-\mu)t} - 1)}{\lambda e^{(\lambda-\mu)t} - \mu}$$

Let's simplify by considering the three cases.

**Case 1: λ < μ (ρ = μ/λ > 1 — deaths exceed births).** As t → ∞, e^{(λ-μ)t} → 0 (since λ-μ < 0). Therefore:

$$P_0(\infty) = \lim_{t\to\infty} \frac{\mu(e^{(\lambda-\mu)t}-1)}{\lambda e^{(\lambda-\mu)t} - \mu} = \frac{\mu(0-1)}{\lambda\cdot 0 - \mu} = \frac{-\mu}{-\mu} = 1$$

Extinction is certain. ✓

**Case 2: λ > μ (ρ < 1 — births exceed deaths).** As t → ∞, e^{(λ-μ)t} → ∞ (since λ-μ > 0). Divide numerator and denominator by e^{(λ-μ)t}:

$$P_0(\infty) = \lim_{t\to\infty} \frac{\mu(1 - e^{-(λ-μ)t})}{\lambda - \mu e^{-(λ-μ)t}} = \frac{\mu \cdot 1}{\lambda - \mu \cdot 0} = \frac{\mu}{\lambda} = \rho$$

> **Notation block:**
> - ρ = μ/λ — the extinction probability when λ > μ (supercritical); read "rho equals mu over lambda"

**Extinction probability from 1 individual: q = min(1, ρ) = min(1, μ/λ).**

If there are n₀ individuals initially (not 1), and all lineages are independent:

$$q_{n_0} = q^{n_0} = \left(\frac{\mu}{\lambda}\right)^{n_0} \quad \text{(if } \lambda > \mu \text{)}$$

because all n₀ lineages must independently go extinct.

> **Annotation:** This uses the key insight that each of the n₀ initial individuals starts an independent branching process, and all must go extinct for the whole population to go extinct.

Here's the key insight: the death-to-birth ratio ρ = μ/λ is the **fundamental threshold**:
- ρ < 1 (λ > μ): population likely survives, extinction probability = ρ < 1
- ρ = 1 (λ = μ): extinction certain despite equal rates (borderline critical)
- ρ > 1 (μ > λ): extinction certain

### Mean and Variance

From the PGF, differentiating with respect to s and evaluating at s=1:

$$\mathrm{E}[N(t)] = e^{(\lambda-\mu)t}$$

$$\mathrm{Var}[N(t)] = \frac{\lambda+\mu}{\lambda-\mu} e^{(\lambda-\mu)t}(e^{(\lambda-\mu)t}-1) \quad \text{for } \lambda \neq \mu$$

When λ > μ: the mean grows exponentially at net rate (λ-μ). When λ < μ: the mean decays to 0.

When λ = μ: E[N(t)] = 1 (mean constant!) but Var[N(t)] = 2λt → ∞. The population is on average unchanged but increasingly variable — it either explodes or goes extinct.

### Connection to Epidemic Models

The Kermack-McKendrick SIR model has a basic reproduction number R₀ = β/γ (contact rate over recovery rate). This is exactly 1/ρ = λ/μ in our notation. The threshold:
- R₀ > 1 (ρ < 1): epidemic possible, P(extinction) = 1/R₀ = ρ
- R₀ < 1 (ρ > 1): epidemic dies out with probability 1

The birth-death process gives the stochastic foundation for the deterministic epidemic threshold.

## Example

**Epidemic initiation: one infected individual, ρ = 0.5 and ρ = 1.5.**

**Scenario 1: R₀ = 2 (λ=2, μ=1, ρ=0.5).** Extinction probability from 1 infected: q = ρ = 0.5. Probability of a major epidemic = 1-0.5 = 50%.

**Scenario 2: R₀ = 0.67 (λ=2, μ=3, ρ=1.5).** Extinction probability = 1 (certain). No epidemic possible — the disease burns out.

**Scenario 3: ρ=0.5 but starting with n₀=3 infected cases (e.g., three simultaneous introductions).** Extinction probability = ρ³ = 0.5³ = 0.125. Only 12.5% chance of extinction — P(major epidemic) = 87.5%.

## Task

See `exercise.R`. You will simulate birth-death processes for ρ=0.5, 1.0, and 1.5 with 500 replicates each, empirically estimate the extinction probability, and compare to the theoretical formula.

## Check

```
npm run check -- bdat-624 module-04 lesson-03
```

## Reflection

The linear birth-death process has extinction probability ρ = μ/λ when ρ < 1. This was derived assuming the process starts from a single individual (X₀ = 1). Now consider a hospital outbreak starting with X₀ = 5 infectious cases (not 1). Using the independence argument, the extinction probability is ρ⁵. If the infection control team intervenes and raises μ (by isolating cases faster), but λ stays fixed, how does the extinction probability change as μ increases from μ = λ/2 to μ = λ? Plot q = min(1, μ/λ)^5 as a function of μ/λ ∈ [0, 1.5] and identify the critical point where extinction becomes certain.
