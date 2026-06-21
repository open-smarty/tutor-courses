# Lesson 14: Topic Modelling with LDA

## Goal

After this lesson you can describe the LDA generative model, explain the role of the Dirichlet hyperparameters, run LDA on the insurance complaint notes, interpret the resulting topics, and choose the number of topics using perplexity.

## Concept

### What is topic modelling?

Topic modelling discovers latent (hidden) themes in a corpus without any labels. Rather than asking "is this complaint about billing or claims?", we ask "what natural groupings of words cluster together across thousands of complaints?" — and the algorithm names these groupings *topics*.

### LDA: the generative story

Latent Dirichlet Allocation (LDA) assumes each document was written via the following generative process:

1. For this document, draw a mixture of topics from a Dirichlet distribution: $\boldsymbol{\theta}_d \sim \text{Dir}(\alpha)$. For example, document $d$ is 60% "billing", 30% "claims", 10% "coverage."

2. For each word position in document $d$:
   a. Draw a topic $z \sim \text{Multinomial}(\boldsymbol{\theta}_d)$.
   b. Draw a word from that topic's word distribution: $w \sim \text{Multinomial}(\boldsymbol{\phi}_z)$, where $\boldsymbol{\phi}_z \sim \text{Dir}(\beta)$.

**LDA inverts this process**: given the observed words across all documents, infer the hidden $\boldsymbol{\theta}$ (document-topic distributions) and $\boldsymbol{\phi}$ (topic-word distributions).

### The Dirichlet distribution

The Dirichlet distribution $\text{Dir}(\alpha_1, \ldots, \alpha_K)$ is a distribution over probability vectors (i.e., vectors that sum to 1). It is the natural prior for multinomial proportions.

- **High $\alpha$** (e.g., $\alpha = 5$): the distribution is concentrated near equal proportions — every document covers all topics roughly equally (no specialisation).
- **Low $\alpha$** (e.g., $\alpha = 0.1$): the distribution is concentrated near the corners — each document is dominated by one or two topics (specialised).

Similarly for $\beta$: high $\beta$ means each topic uses many words; low $\beta$ means each topic is concentrated on a few words.

**In practice**, set $\alpha = 50/K$ and $\beta = 0.01$ as defaults (Griffiths & Steyvers 2004).

### Perplexity

Perplexity measures how well the model predicts held-out text:

$$\text{Perplexity} = \exp\!\left(-\frac{1}{N_{\text{test}}} \sum_{d,w} \log P(w \mid d)\right)$$

Lower perplexity = better fit = the model is less "surprised" by new text. Plot perplexity vs. number of topics $K$ and choose the elbow (similar to k-means). Perplexity always decreases with more topics, so look for the inflection.

### Running LDA in R

```r
library(topicmodels)
library(tidytext)

# 1. Build the DTM (document-term matrix)
dtm <- word_counts |>
  cast_dtm(doc_id, word, n)

# 2. Fit LDA
lda_model <- LDA(dtm, k = 5, method = "Gibbs",
                 control = list(seed = 602, iter = 500, burnin = 100))

# 3. Extract word-topic distributions (beta matrix)
# beta[k, w] = P(word w | topic k)
topics_beta <- tidy(lda_model, matrix = "beta")

# 4. Extract document-topic distributions (gamma matrix)
# gamma[d, k] = P(topic k | document d)
doc_topics <- tidy(lda_model, matrix = "gamma")
```

### Interpreting topics

For each topic, print the top 10 words by $\beta$ (probability):

```r
topics_beta |>
  group_by(topic) |>
  slice_max(beta, n = 10) |>
  ungroup() |>
  mutate(term = reorder_within(term, beta, topic)) |>
  ggplot(aes(x = term, y = beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free_y") +
  scale_x_reordered() +
  coord_flip() +
  labs(title = "Top 10 Words per LDA Topic", x = "Term", y = "β (word probability)") +
  theme_minimal()
```

Assign a human-readable label to each topic based on the top words. In the insurance context, you might find: Topic 1 ≈ "Billing disputes", Topic 2 ≈ "Slow claim processing", Topic 3 ≈ "Coverage gaps", Topic 4 ≈ "Service quality", Topic 5 ≈ "Positive feedback".

### Choosing K with perplexity

```r
perp <- sapply(c(3, 4, 5, 6, 7), function(k) {
  mod <- LDA(dtm, k = k, method = "Gibbs",
             control = list(seed = 602, iter = 200, burnin = 50))
  perplexity(mod)
})
plot(c(3,4,5,6,7), perp, type = "b", xlab = "Topics K", ylab = "Perplexity")
```

### Scaling LDA to 500,000 documents with Spark

`topicmodels::LDA()` runs on a single core in R and cannot process 500,000 documents efficiently. Spark MLlib provides a distributed LDA implementation via `ml_lda()`. The input must be a **count vector** per document (from `ft_count_vectorizer()`) — Spark LDA handles frequency weighting internally.

```{r spark-lda, eval=FALSE}
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

health_tbl <- copy_to(
  sc, simulate_bdat602(n = 500000, seed = 602),
  name = "health_ins", overwrite = TRUE
)

# Build count vectors using the Lesson 1 Spark pipeline
complaints_spark <- health_tbl |>
  filter(!is.na(complaint_notes)) |>
  mutate(doc_id = monotonically_increasing_id())

tokenised  <- ft_tokenizer(complaints_spark,
                            input_col = "complaint_notes", output_col = "words_raw")
cleaned    <- ft_stop_words_remover(tokenised,
                                    input_col = "words_raw", output_col = "words")
cv_model   <- ft_count_vectorizer(cleaned,
                                   input_col = "words", output_col = "tf", min_df = 5)
tf_vectors <- ml_transform(cv_model, cleaned)

# Fit Spark LDA (online LDA by default — more scalable than EM)
lda_spark <- ml_lda(tf_vectors,
                    features_col = "tf",
                    k            = 5,
                    max_iter     = 20,
                    doc_concentration = rep(1.0 / 5, 5),  # symmetric alpha
                    topic_concentration = 0.01            # beta
                   )

# Extract word-topic matrix (equivalent to beta in tidytext)
vocab      <- cv_model$vocabulary
topic_mat  <- lda_spark$topics_matrix()   # K × V matrix: rows = topics, cols = words

# Top 10 words for each topic
apply(topic_mat, 1, function(row) {
  vocab[order(row, decreasing = TRUE)[1:10]]
})

spark_disconnect(sc)
```

**Key differences from `topicmodels::LDA()`**:
- Spark LDA uses *Online LDA* (variational inference with mini-batches) by default, not Gibbs sampling. Online LDA is faster and streams through the data without loading it all into memory, but may need more iterations for equivalent convergence.
- `doc_concentration` (α) and `topic_concentration` (β) are the Dirichlet hyperparameters — equivalent to `alpha` and `beta` in `topicmodels`.
- The output topic-word matrix uses normalised probability distributions (same semantics as `β` from `tidy(lda5, matrix = "beta")`).

## Example

Full worked example in `solution.Rmd` builds the DTM from the insurance complaint notes, fits a 5-topic LDA model, plots word-topic distributions, assigns topic labels, and produces a perplexity curve over K = 3 to 7.

## Task

Open `exercise.Rmd` and complete the five tasks: (1) build the DTM from the cleaned word counts; (2) fit a 5-topic LDA model with Gibbs sampling; (3) extract and visualise word-topic probabilities (beta); (4) compute perplexity for K = 3 to 7 and identify the best K; (5) fit Spark LDA on the full 500,000-document corpus using `ft_count_vectorizer()` + `ml_lda()` and compare the recovered topics with the topicmodels result.

## Check

```
npm run check -- bdat-602 module-06 lesson-02
```

## Reflection

LDA assumes that documents are exchangeable "bags of words" — word order does not matter. A complaint saying "the claim was denied without explanation" and one saying "without explanation, the claim was denied" are identical under LDA. What real-world information is lost by discarding word order, and what class of models would preserve it?
