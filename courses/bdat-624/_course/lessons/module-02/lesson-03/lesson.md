# Lesson 3: State Classification — Recurrence, Transience, and Ergodicity

## Goal

Classify every state in a Markov chain as accessible, communicating, recurrent, or transient; compute the period of a state; and understand what ergodicity means and why it guarantees long-run stability.

## Concept

### Accessibility and Communication

Before we ask whether a chain converges, we need to understand the structure of its states: which states can "see" each other?

> **Notation block:**
> - P⁽ⁿ⁾ᵢⱼ — n-step transition probability from state i to state j
> - i → j — "state j is **accessible** from state i"; read "i leads to j"
> - i ↔ j — "states i and j **communicate**"; read "i and j communicate"

**Definition: Accessibility.** State j is **accessible** from state i (written i → j) if there exists some n ≥ 0 such that P⁽ⁿ⁾ᵢⱼ > 0.

In plain English: starting from i, there is a positive probability of eventually reaching j (possibly in multiple steps). Note: if n=0, then i → i trivially (the chain "goes to i from i in 0 steps" means it stays put).

**Definition: Communication.** States i and j **communicate** (written i ↔ j) if i → j AND j → i — each is accessible from the other.

Communication is an **equivalence relation** (it satisfies reflexivity, symmetry, and transitivity). It therefore partitions the state space S into disjoint **communicating classes** — groups of states that all mutually communicate.

**Definition: Irreducibility.** A Markov chain is **irreducible** if all states communicate with each other — i.e., there is only one communicating class, which is all of S.

Here's the key insight: in an irreducible chain, you can get from anywhere to anywhere (given enough steps). This is a strong and useful property — it guarantees a unique stationary distribution and eventual convergence.

### Period

Even in an irreducible chain, the chain might visit certain states only at regular intervals. The **period** captures this regularity.

> **Notation block:**
> - d(i) — the **period** of state i; read "d of i"
> - gcd — **greatest common divisor**
> - {n ≥ 1 : P⁽ⁿ⁾ᵢᵢ > 0} — the set of return times to state i; "all step counts at which there is positive probability of returning to i"

**Definition: Period.** The period of state i is:

$$d(i) = \gcd\{n \geq 1 : P^{(n)}_{ii} > 0\}$$

If d(i) = 1: state i is **aperiodic** — the chain can return to i at *any* step length (given enough time).
If d(i) = 2: state i is **periodic with period 2** — the chain can only return to i at even-numbered steps.
If d(i) = k > 1: returns are only possible at multiples of k.

**Important fact:** All states in the same communicating class have the same period. So we can speak of the "period of a class."

**Example:** Consider a chain that alternates between two states: 1 → 2 → 1 → 2 → ... Both states have period 2 (can only return after 2, 4, 6, ... steps). This is a periodic chain.

**Biological example:** A bacterium divides exactly every generation — a strictly synchronous population. If we model health states at each generation, the period equals the generation length. In practice, biological systems are rarely perfectly periodic, so aperiodicity (period=1) is common.

### Recurrence and Transience

Perhaps the most important classification: will the chain ever return to a state it has visited, or might it wander away forever?

> **Notation block:**
> - fᵢ — the probability that the chain, starting from state i, ever returns to state i; read "f sub i"
> - fᵢ = P(Xₙ = i for some n ≥ 1 | X₀ = i)

**Definition: Recurrent state.** State i is **recurrent** if fᵢ = 1 — the chain returns to i with probability 1, starting from i.

**Definition: Transient state.** State i is **transient** if fᵢ < 1 — there is a positive probability of never returning to i.

Here's the key insight for transient states: if fᵢ < 1, then the probability of visiting i exactly k times is fᵢᵏ⁻¹(1-fᵢ) (geometric distribution). So the total number of visits to a transient state is finite almost surely (geometric random variable). Eventually the chain leaves a transient state and never returns.

For recurrent states: if fᵢ = 1, then the chain returns infinitely often with probability 1. The average return time is E[T_i] where T_i = min{n ≥ 1 : Xₙ = i}.

**Positive recurrence vs null recurrence:**
- **Positive recurrent:** E[T_i] < ∞ (the mean return time is finite)
- **Null recurrent:** fᵢ = 1 but E[T_i] = ∞ (the chain returns with certainty, but it takes infinitely long on average)

For finite state spaces, all recurrent states are positive recurrent. Null recurrence only arises in infinite state spaces (e.g., random walk on ℤ).

### Ergodic Chains

**Definition: Ergodic chain.** A Markov chain is **ergodic** if it is:
1. **Irreducible** — all states communicate
2. **Aperiodic** — period d(i) = 1 for all i (equivalently, the single communicating class is aperiodic)
3. **Positive recurrent** — all states have finite mean return times

For finite state spaces, irreducibility alone guarantees positive recurrence. So for practical purposes: a finite, irreducible, aperiodic chain is ergodic.

**Ergodic theorem.** For an ergodic chain:

$$\frac{1}{n} \sum_{k=0}^{n-1} \mathbf{1}[X_k = i] \xrightarrow{n \to \infty} \pi_i \quad \text{with probability 1}$$

> **Notation block:**
> - 1[Xₖ = i] — the **indicator function**; equals 1 if Xₖ = i, and 0 otherwise; read "one if X_k equals i"
> - (1/n) Σₖ 1[Xₖ = i] — the **time-average** fraction of steps spent in state i over n steps

The time-average fraction of time in state i converges (with probability 1) to the stationary probability πᵢ. This is the ergodic analogue of the law of large numbers: time averages equal space averages (= stationary probabilities).

### State Classification in a Chain with an Absorbing State

Consider a chain with states {H, MI, SI, D} where D is absorbing.

- **State D:** Recurrent (positive recurrent: return time = 0, since you never leave). Also, it forms its own communicating class {D}.
- **States H, MI, SI:** Each of H, MI, SI is accessible from the others (as long as the transition probabilities are positive). They form a communicating class {H, MI, SI}. However, because D is accessible from H, MI, SI but D cannot reach back, the class {H, MI, SI} is **transient**. Starting from any of H, MI, SI, the chain will eventually enter D and never return. So H, MI, SI are all transient states.

The chain as a whole is NOT irreducible (because of the absorbing state D).

## Example

**Classifying a 4-state chain.**

Consider S = {1, 2, 3, 4} with the following transitions:

$$P = \begin{pmatrix} 0 & 0.5 & 0.5 & 0 \\ 0.5 & 0 & 0 & 0.5 \\ 0.5 & 0 & 0 & 0.5 \\ 0 & 0 & 0 & 1 \end{pmatrix}$$

**Step 1: Accessibility.**
- From 1: can reach 2 (P₁₂=0.5), 3 (P₁₃=0.5). From 2, can reach 1 and 4. From 3, can reach 1 and 4. So from 1 we can reach 1↔2, 1↔3, and also 4.
- From 4: P₄₄=1, P₄j=0 for j≠4. So 4 cannot reach 1, 2, or 3.

**Step 2: Communicating classes.**
- Check: does 1 communicate with 2? 1→2 (direct) and 2→1 (direct). Yes: 1↔2.
- Does 1 communicate with 3? 1→3 (direct) and 3→1 (direct). Yes: 1↔3.
- Does 2 communicate with 3? 2→1→3 in 2 steps: P⁽²⁾₂₃ = P₂₁P₁₃ = 0.5×0.5=0.25>0. And 3→1→2 in 2 steps. Yes: 2↔3.
- Classes: {1, 2, 3} (all communicate), {4} (absorbing, only talks to itself).

**Step 3: Recurrence/Transience.**
- {4}: absorbing → recurrent (positive recurrent).
- {1, 2, 3}: can access 4 (e.g., 2→4: P₂₄=0.5>0), but 4 cannot return to 1, 2, 3. So {1, 2, 3} is a transient class. Once the chain enters 4, states 1, 2, 3 are never revisited.

**Step 4: Period.**
- State 1: P⁽¹⁾₁₁ = 0 (no self-loop). P⁽²⁾₁₁ = P₁₂P₂₁ + P₁₃P₃₁ = 0.25+0.25=0.5>0. So return in 2 steps is possible. P⁽³⁾₁₁ = ... (check: 1→2→4, dead end; 1→2→1→1... hmm, in 3 steps: 1→2→1→2? no, final at 2 not 1). Let me be careful: P⁽³⁾₁₁: paths of length 3 returning to 1. 1→2→1→? The chain from 1: 50% go to 2, 50% go to 3. From 2 in step 2: 50% to 1, 50% to 4. After 3 steps from 1 to 1: 1→2→1→... (then from 1 in 1 step: 50%→2, 50%→3, 0%→1). So 1→2→1→2 or 1→2→1→3, not 1→2→1→1. Similarly 1→3→1→{2,3} not 1→3→1→1. So P⁽³⁾₁₁ = 0 (can only return to 1 in even steps with this structure). Thus d(1) = gcd{2, 4, 6,...} = 2. State 1 is **periodic with period 2**.

**Conclusion:** The chain is NOT ergodic: it is not irreducible (state 4 is separate) and the non-absorbing class {1,2,3} is periodic (period 2) and transient.

## Task

See `exercise.R`. You will build and analyse a 5-state chain using the `markovchain` package: check irreducibility, identify communicating classes, determine periods, and classify states as recurrent or transient.

## Check

```
npm run check -- bdat-624 module-02 lesson-03
```

## Reflection

The ergodic theorem guarantees that time averages converge to space averages (the stationary distribution). In a clinical context, this says that if you follow one patient for a very long time under the Markov model, the fraction of time they spend in each state equals πᵢ. But consider: is it realistic to imagine following a single patient for "infinitely long"? Most models have an absorbing state (death). How does the presence of an absorbing state violate the ergodic theorem's assumptions, and what alternative long-run quantities (e.g., expected time in each transient state before absorption) would be more clinically meaningful?
