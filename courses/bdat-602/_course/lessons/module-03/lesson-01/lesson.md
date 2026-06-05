# Lesson 6: Market Basket Analysis and the Apriori Algorithm

## Goal

After this lesson you can formally define support, confidence, and lift, compute them by hand from a toy transaction table, and explain step-by-step how the Apriori algorithm exploits the anti-monotone property to prune its search space.

## Concept

### The market basket problem

Imagine a supermarket receipt: {milk, bread, butter}. A transaction database is a collection of such receipts. The question market basket analysis asks is: "which items tend to appear together more often than chance would predict?" In insurance the "basket" is a policyholder's set of cover add-ons: {dental\_cover, vision\_cover, mental\_cover, maternity\_cover}.

### Key definitions

**Itemset**: a non-empty set of items. $\{A, B\}$ is a 2-itemset.

**Transaction set**: $\mathcal{T} = \{t_1, t_2, \ldots, t_N\}$ where each $t_i \subseteq \mathcal{I}$ and $\mathcal{I}$ is the set of all possible items.

**Support** of an itemset $X$:

$$\text{supp}(X) = \frac{|\{t \in \mathcal{T} : X \subseteq t\}|}{|\mathcal{T}|}$$

Interpretation: the proportion of transactions that contain $X$. Equivalently, $\text{supp}(X) = P(X)$ — the probability that a randomly chosen transaction contains all items in $X$.

**Confidence** of a rule $X \Rightarrow Y$:

$$\text{conf}(X \Rightarrow Y) = \frac{\text{supp}(X \cup Y)}{\text{supp}(X)} = P(Y \mid X)$$

Interpretation: among all transactions that contain $X$, what fraction also contains $Y$? This is the conditional probability.

**Lift** of a rule $X \Rightarrow Y$:

$$\text{lift}(X \Rightarrow Y) = \frac{\text{conf}(X \Rightarrow Y)}{\text{supp}(Y)} = \frac{P(X \cap Y)}{P(X) \cdot P(Y)}$$

Interpretation: how much more often $X$ and $Y$ appear together than we would expect if they were statistically independent. Lift = 1 means $X$ and $Y$ are independent; lift > 1 means positive association (knowing $X$ increases the probability of $Y$); lift < 1 means negative association.

### Worked example (5 transactions)

| Transaction | Items |
|---|---|
| T1 | dental, vision |
| T2 | dental, mental |
| T3 | dental, vision, mental |
| T4 | vision, mental |
| T5 | dental, vision |

$N = 5$.

- $\text{supp}(\{\text{dental}\}) = 4/5 = 0.80$
- $\text{supp}(\{\text{vision}\}) = 4/5 = 0.80$
- $\text{supp}(\{\text{mental}\}) = 3/5 = 0.60$
- $\text{supp}(\{\text{dental, vision}\}) = 3/5 = 0.60$
- $\text{conf}(\text{dental} \Rightarrow \text{vision}) = 0.60 / 0.80 = 0.75$
- $\text{lift}(\text{dental} \Rightarrow \text{vision}) = 0.75 / 0.80 = 0.9375$

Lift < 1 here, so in this tiny example dental and vision are slightly negatively associated (transaction T2 has dental but not vision; T4 has vision but not dental). With a real dataset of 500,000 rows the patterns are more stable.

### The Apriori algorithm

With $|\mathcal{I}|$ items, the number of possible itemsets is $2^{|\mathcal{I}|} - 1$ — exponential. For $|\mathcal{I}| = 40$ this is over a trillion. Apriori makes the search tractable using the **anti-monotone property** (also called the Apriori property):

> **If an itemset $X$ is infrequent (supp($X$) < min\_supp), then every superset of $X$ is also infrequent.**

**Proof**: for any $Y \supset X$, every transaction containing $Y$ also contains $X$ (since $X \subseteq Y$). Therefore $|\{t : Y \subseteq t\}| \leq |\{t : X \subseteq t\}|$, which implies $\text{supp}(Y) \leq \text{supp}(X) < \text{min\_supp}$.

**Algorithm** (with min\_supp = 0.05, min\_conf = 0.70):
1. Scan all transactions, count the support of every 1-itemset. Keep only frequent 1-itemsets ($L_1$).
2. Generate candidate 2-itemsets by taking all pairs of items from $L_1$ (if either item in a pair is infrequent, the pair cannot be frequent — prune it).
3. Scan transactions, count 2-itemset supports. Keep frequent ones ($L_2$).
4. Repeat: generate $L_{k+1}$ candidates from $L_k$, prune, scan, filter.
5. Stop when no new frequent itemsets are found.
6. Generate association rules from all frequent itemsets: for each $X$, try $X \setminus \{y\} \Rightarrow \{y\}$ for all $y \in X$; keep rules with conf ≥ min\_conf.

## Example

Full worked example with 5 items and 5 transactions (see table above). Setting min\_supp = 0.60:
- $L_1 = \{\{dental\}, \{vision\}, \{mental\}\}$ — all support ≥ 0.60.
- Candidates for $L_2$: {dental, vision} (supp = 0.60 ✓), {dental, mental} (supp = 0.40 ✗, pruned), {vision, mental} (supp = 0.40 ✗, pruned).
- $L_2 = \{\{dental, vision\}\}$.
- No candidates for $L_3$ (only one 2-itemset, can't form a 3-itemset with the anti-monotone pruning).
- Rule dental → vision: conf = 0.60/0.80 = 0.75 ✓. Rule vision → dental: conf = 0.60/0.80 = 0.75 ✓.

## Task

Open `exercise.Rmd` and complete the four tasks: (1) compute support, confidence, and lift by hand (with R arithmetic) for a small toy transaction table; (2) verify the anti-monotone property by showing that a superset of an infrequent itemset is also infrequent; (3) run `arules::apriori()` on the toy transactions; (4) interpret the top three rules by lift and write a business-friendly sentence for each.

## Check

```
npm run check -- bdat-602 module-03 lesson-01
```

## Reflection

Lift measures association relative to independence. A rule can have high confidence but lift close to 1 — meaning the consequent is simply very common. Can you think of an insurance example where high confidence is misleading and lift reveals the rule is not actionable?
