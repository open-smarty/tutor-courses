# Lesson 6: Rule Metrics, the Apriori Algorithm, and FP-Growth

## Goal

After this lesson you can define support, confidence, lift, conviction, and leverage with their formal expressions; compute all five by hand from a transaction table; trace the Apriori algorithm step by step on the insurance cover dataset; and explain how FP-Growth achieves the same output with only two database scans.

## Concept

### What association rule mining does

A policyholder's record is treated as a "basket" of attributes: cover add-ons held, age group, plan tier, smoking status. Association mining asks: **which combinations of attributes appear together more often than chance would predict?** The rules extracted have the form $A \Rightarrow B$ (if a policyholder has attributes $A$, they also tend to have $B$).

Typical insurance applications:
- **Upselling**: Gold-plan, dental holders are 1.9× more likely to take vision cover → target them with a bundle offer.
- **Fraud detection**: Unemployed, young, weekend-claim policyholders are 4.1× more likely to commit fraud → route to the manual review queue.

### Intuition first: the three core metrics

Consider 1,000 policyholders. 600 have dental cover (D), 570 have vision cover (V), and 400 have both.

**Support**: how common is this combination?

$$\text{supp}(D \Rightarrow V) = \frac{|\text{D and V}|}{N} = \frac{400}{1000} = 0.40$$

Support = 40%: 40% of all policyholders hold both covers.

**Confidence**: of those who have D, what fraction also has V?

$$\text{conf}(D \Rightarrow V) = \frac{|\text{D and V}|}{|\text{D}|} = \frac{400}{600} = 0.67$$

Confidence = 67%: among dental holders, 67% also take vision.

**Lift**: is this rule better than random chance?

$$\text{lift}(D \Rightarrow V) = \frac{\text{conf}(D \Rightarrow V)}{\text{supp}(V)} = \frac{0.67}{0.57} = 1.17$$

Lift > 1: D and V co-occur more than by chance. Knowing a policyholder has D makes them 1.17× more likely to have V than a randomly chosen policyholder.

| Lift | Interpretation |
|---|---|
| = 1 | D and V are independent; rule is useless |
| > 1 | D and V co-occur more than by chance |
| < 1 | D and V are negatively associated |

**A critical warning**: high confidence can occur simply because B is very common. A rule with confidence = 0.90 but lift = 0.95 is actually *negatively* associated — B is so common that knowing A barely helps. **Always report lift alongside confidence.**

### Formal definitions of rule metrics

Let $\mathcal{T}$ be the set of all transactions, $|\mathcal{T}| = n$. Let $A$ and $B$ be itemsets where $A \cap B = \emptyset$.

**Support** of rule $A \Rightarrow B$:
$$\text{supp}(A \Rightarrow B) = \frac{|\{t \in \mathcal{T} : A \cup B \subseteq t\}|}{|\mathcal{T}|}$$

**Confidence**:
$$\text{conf}(A \Rightarrow B) = \frac{\text{supp}(A \cup B)}{\text{supp}(A)} = P(B \mid A)$$

**Lift**:
$$\text{lift}(A \Rightarrow B) = \frac{\text{conf}(A \Rightarrow B)}{\text{supp}(B)} = \frac{\text{supp}(A \cup B)}{\text{supp}(A) \cdot \text{supp}(B)}$$

**Conviction** — measures directional dependence:
$$\text{conv}(A \Rightarrow B) = \frac{1 - \text{supp}(B)}{1 - \text{conf}(A \Rightarrow B)}$$

Conviction = 1 means $A$ and $B$ are independent. Higher values indicate stronger directional dependence. Unlike lift, conviction is not symmetric: $\text{conv}(A \Rightarrow B) \neq \text{conv}(B \Rightarrow A)$.

**Leverage** — difference between observed and expected co-occurrence:
$$\text{lev}(A \Rightarrow B) = \text{supp}(A \cup B) - \text{supp}(A) \cdot \text{supp}(B)$$

Leverage = 0 means independence. Positive leverage means the pair co-occurs more than expected.

### Worked example: metric calculations from 10,000 policyholders

| Item combination | Count |
|---|---|
| Dental only | 2,000 |
| Vision only | 1,500 |
| Mental only | 1,000 |
| Dental + Vision | 2,800 |
| Dental + Mental | 1,200 |
| Vision + Mental | 800 |
| Dental + Vision + Mental | 600 |
| **Total with Dental** | 6,600 |
| **Total with Vision** | 5,700 |

Rule: $\{\text{Dental}\} \Rightarrow \{\text{Vision}\}$

$$\text{supp} = \frac{2800}{10000} = 0.28 \qquad \text{conf} = \frac{2800}{6600} = 0.424 \qquad \text{lift} = \frac{0.424}{5700/10000} = \frac{0.424}{0.57} = 0.744$$

Lift < 1 despite reasonable confidence (42%). Dental and vision cover are **negatively** associated — dental holders are actually *less* likely to take vision than the average policyholder. This is a counter-intuitive but important finding.

### Setting thresholds: minsupp and minconf

With $d$ binary items, there are $2^d$ possible itemsets and up to $3^d - 2^{d+1} + 1$ possible rules. With $d = 10$ items (4 riders plus 6 others), this is over 59,000 rules — most are spurious.

- **minsupp** filters out rare rules. Typical range for insurance data: **0.01–0.10**. Too high → miss interesting rare patterns. Too low → millions of meaningless rules.
- **minconf** filters out unreliable rules. Typical range: **0.50–0.80**. Always check lift even after filtering by confidence.

### The Apriori algorithm

**The Apriori principle (anti-monotonicity)**: if an itemset is frequent, then *all* of its subsets must also be frequent. Equivalently: if an itemset is infrequent, then *all* of its supersets must also be infrequent.

This allows **pruning entire branches** of the search space. If {Dental, Vision} is infrequent, we never need to check {Dental, Vision, Mental}.

**Phase 1 — find all frequent itemsets** (minsupp = $s$):
1. **Pass 1**: scan $\mathcal{T}$; count each single item; keep items with support ≥ $s$ → $L_1$
2. **Generate candidates**: combine pairs from $L_1$ → $C_2$
3. **Pass 2**: scan $\mathcal{T}$; count $C_2$; keep those ≥ $s$ → $L_2$
4. **Prune**: any $C_2$ candidate with an infrequent subset is dropped before scanning
5. **Repeat** for $k = 3, 4, \ldots$ until no new frequent itemsets

**Phase 2 — generate rules from frequent itemsets**: for each frequent itemset $L$, generate all non-empty subsets $A \subset L$. Output rule $A \Rightarrow (L \setminus A)$ if $\text{conf} \geq c$.

**Complexity**: number of database scans = maximum itemset length. Each scan is $O(|\mathcal{T}| \times \bar{w})$ where $\bar{w}$ is average transaction width. Candidate generation is $O(|L_k|^2)$ per level. The bottleneck is repeated full database scans.

### Apriori worked trace (5 transactions, minsupp = 0.60)

| TID | Items |
|---|---|
| T1 | Dental, Vision |
| T2 | Dental, Mental, Vision |
| T3 | Vision, Maternity |
| T4 | Dental, Mental |
| T5 | Dental, Vision, Mental |

**Pass 1** — item counts:

| Item | Count | Frequent? |
|---|---|---|
| Dental | 4 | Yes (4/5 = 0.80) |
| Vision | 4 | Yes (4/5 = 0.80) |
| Mental | 3 | Yes (3/5 = 0.60) |
| Maternity | 1 | No — dropped |

$L_1 = \{\{D\}, \{V\}, \{M\}\}$

**Pass 2** — 2-itemset counts:

| Itemset | Count | Frequent? |
|---|---|---|
| {Dental, Vision} | 3 | Yes (0.60) |
| {Dental, Mental} | 3 | Yes (0.60) |
| {Vision, Mental} | 2 | No (0.40) |

$L_2 = \{\{D, V\}, \{D, M\}\}$

**Pass 3**: candidate {D, V, M} — its subset {V, M} is infrequent → **pruned**. No frequent 3-itemsets.

**Frequent itemsets**: $\{D\}, \{V\}, \{M\}, \{D,V\}, \{D,M\}$

**Generated rules** (minconf = 0.60):
- $D \Rightarrow V$: conf = 3/4 = 0.75 ✓
- $V \Rightarrow D$: conf = 3/4 = 0.75 ✓
- $D \Rightarrow M$: conf = 3/4 = 0.75 ✓

### Why Apriori struggles at scale

With 500,000 records and 12 items (4 riders + plan tier + region + age group + …), Apriori may generate thousands of candidates at level 3 and beyond. Each candidate level requires a full scan of all 500,000 records. Candidate generation also stores millions of candidates in memory before pruning.

### FP-Growth: only two database scans

FP-Growth (Han et al. 2000) avoids candidate generation entirely by compressing the database into a compact **FP-Tree** structure:

1. **Scan 1**: count item frequencies; remove infrequent items; sort remaining items by frequency (descending)
2. **Scan 2**: for each transaction, insert items (in frequency order) into the tree; if a path already exists, increment its node counts; a header table links all nodes for each item

**Mining the FP-Tree** (no further scans): for each item $i$ (least frequent first), extract the **conditional pattern base** (all paths ending at $i$) and build a smaller conditional FP-Tree. Recursively mine each conditional FP-Tree.

FP-Growth is typically 10–100× faster than Apriori on large datasets.

**ECLAT** (Equivalence Class Transformation) uses a depth-first search with a vertical data format and achieves similar efficiency. In R, `arules::eclat()` implements ECLAT; `arules::apriori()` uses an optimised implementation that selects the most efficient algorithm internally.

| Algorithm | Strength | Use When |
|---|---|---|
| Apriori | Simple; interpretable | Small/medium datasets; teaching |
| ECLAT | Faster than Apriori | Medium datasets; itemset-first mining |
| FP-Growth | Fastest; no candidate generation | Large datasets ($n > 100{,}000$) |
| GSP/PrefixSpan | Ordered sequences | Event logs; time-stamped data |

## Example

```r
library(arules)
library(dplyr)

# 5-transaction toy database
trans_list <- list(
  T1 = c("Dental", "Vision"),
  T2 = c("Dental", "Mental", "Vision"),
  T3 = c("Vision", "Maternity"),
  T4 = c("Dental", "Mental"),
  T5 = c("Dental", "Vision", "Mental")
)

# Convert to arules transactions object
trans <- as(trans_list, "transactions")
summary(trans)
inspect(trans)

# Compute support by hand in R
N <- length(trans_list)
contains <- function(tl, items) sum(sapply(tl, function(t) all(items %in% t)))

supp_D  <- contains(trans_list, "Dental")  / N   # 0.80
supp_V  <- contains(trans_list, "Vision")  / N   # 0.80
supp_DV <- contains(trans_list, c("Dental", "Vision")) / N  # 0.60
conf_DV <- supp_DV / supp_D                              # 0.75
lift_DV <- conf_DV / supp_V                              # 0.9375

cat("conf(D→V) =", conf_DV, "  lift(D→V) =", lift_DV, "\n")

# Run Apriori
rules <- apriori(trans, parameter = list(supp = 0.60, conf = 0.60, minlen = 2))
inspect(sort(rules, by = "lift"))

# Run ECLAT (FP-Growth-family)
freq_items <- eclat(trans, parameter = list(supp = 0.60, minlen = 2))
rules_eclat <- ruleInduction(freq_items, trans, confidence = 0.60)
inspect(sort(rules_eclat, by = "lift"))
```

## Task

Open `exercise.Rmd` and complete the four tasks: (1) compute all five metrics (support, confidence, lift, conviction, leverage) by hand in R from the 10,000-policyholder table in the Concept section; (2) trace Apriori Pass 1 and Pass 2 on the 5-transaction database using the `contains()` helper; (3) run `apriori()` and `eclat()` with minsupp = 0.40, minconf = 0.60; (4) compare the top 5 rules by lift from both algorithms and verify they are identical.

## Check

```
npm run check -- bdat-602 module-03 lesson-01
```

## Reflection

The worked example in the Concept section shows that $\{\text{Dental}\} \Rightarrow \{\text{Vision}\}$ has confidence 0.424 but lift 0.744 — a negative association hiding behind a seemingly reasonable confidence value. Define a business scenario in this course dataset where acting on confidence alone (without checking lift) would lead to a wasteful marketing campaign.
