# Lesson 13: Tokenisation and TF-IDF

## Goal

After this lesson you can tokenise the insurance complaint notes, remove stop words, compute TF-IDF scores, build a document-term matrix, and identify the most discriminating terms for each complaint category.

## Concept

### From text to numbers: the challenge

Machine learning algorithms expect numeric input. Text is unstructured — a sequence of characters with no natural numeric representation. The first step is to convert text into a matrix of numbers. Two decisions drive this: (1) what is a token? (2) how do we weight each token?

### Tokenisation

A **token** is the unit of analysis in text mining. Common choices:
- **Words (unigrams)**: "claim", "denied", "billing" — most common, simple to interpret.
- **Bigrams**: pairs of adjacent words — "claim denied", "not covered". Bigrams capture negations ("not good" vs. "good") that unigrams miss.
- **Sentences**: useful when document boundaries matter.

In `tidytext`: `unnest_tokens(word, complaint_notes)` splits each complaint into one row per word (unigram). For bigrams: `unnest_tokens(bigram, complaint_notes, token = "ngrams", n = 2)`.

### Stop word removal

Stop words are extremely common, non-discriminating words: "the", "a", "is", "I", "and". They appear in virtually every document and add noise. Remove them with `anti_join(stop_words)` where `stop_words` is a built-in `tidytext` lexicon.

### Term Frequency (TF)

For term $t$ in document $d$:

$$\text{tf}(t, d) = \frac{\text{count}(t, d)}{\sum_{t'} \text{count}(t', d)}$$

This is the proportion of document $d$'s words that are the term $t$. Normalising by document length prevents long documents from dominating.

**Numeric example**: a complaint of 20 words contains the word "billing" twice. $\text{tf}(\text{billing}, d) = 2/20 = 0.10$.

### Inverse Document Frequency (IDF)

A term that appears in almost every document (e.g., "insurance") is uninformative — it does not distinguish one document type from another. IDF downweights such terms:

$$\text{idf}(t) = \log\!\left(\frac{N}{\text{df}(t)}\right)$$

where $N$ = total number of documents and $\text{df}(t)$ = number of documents containing $t$.

**Numeric example**: $N = 500{,}000$ complaints. "Insurance" appears in 480,000 documents: $\text{idf}(\text{insurance}) = \log(500000/480000) = \log(1.042) \approx 0.041$ — very low. "Reimbursed" appears in 12,000 documents: $\text{idf}(\text{reimbursed}) = \log(500000/12000) \approx 3.73$ — much higher.

**Why log?** Without the log, $N/\text{df}(t)$ grows without bound and overwhelms TF. The log compresses the range. It also means that doubling the corpus size only adds a constant $\log(2)$ to every IDF — the relative ordering of terms is preserved.

### TF-IDF

$$\text{tf-idf}(t, d) = \text{tf}(t, d) \times \text{idf}(t)$$

A term gets a high TF-IDF score if it appears often in this document (high TF) but rarely across all documents (high IDF). It is the "fingerprint" of a document — the terms that make this document unique.

### The document-term matrix (DTM)

Rows = documents. Columns = unique terms. Entry $(d, t)$ = tf-idf$(t, d)$. This matrix is very sparse (most terms appear in few documents). In `tidytext`, you work with the long form and convert with `cast_dtm()`.

### tidytext workflow

```r
library(tidytext)

tfidf_df <- health_data |>
  filter(!is.na(complaint_notes)) |>
  mutate(doc_id = row_number()) |>
  unnest_tokens(word, complaint_notes) |>       # tokenise
  anti_join(stop_words, by = "word") |          # remove stop words
  count(doc_id, word) |>                        # term frequency counts
  bind_tf_idf(word, doc_id, n)                  # compute tf, idf, tf_idf
```

`bind_tf_idf()` adds columns `tf`, `idf`, and `tf_idf` to your word-count data frame.

### Top terms per complaint category

If documents are labelled by category (e.g., billing, claims, coverage, service), group them and find the top TF-IDF terms:

```r
tfidf_df |>
  group_by(category, word) |>
  summarise(mean_tfidf = mean(tf_idf)) |>
  slice_max(mean_tfidf, n = 10) |>
  ungroup() |>
  ggplot(aes(x = reorder_within(word, mean_tfidf, category), y = mean_tfidf, fill = category)) +
  geom_col() + facet_wrap(~category, scales = "free") +
  scale_x_reordered() +
  coord_flip() + theme_minimal()
```

### Scaling text feature extraction to 500,000 complaints with Spark

`tidytext` processes text row-by-row in R. For 500,000 complaint notes the `unnest_tokens()` step can be slow. Spark provides a distributed text pipeline via **transformer functions** (`ft_*`):

| Transformer | What it does |
|---|---|
| `ft_tokenizer()` | Splits each string into a list of words by whitespace |
| `ft_stop_words_remover()` | Removes common English stop words from each word list |
| `ft_count_vectorizer()` | Converts word lists to term-frequency sparse vectors |
| `ft_idf()` | Multiplies TF vectors by inverse document frequency weights |

```{r spark-tfidf, eval=FALSE}
library(sparklyr)
library(dplyr)

sc <- spark_connect(master = "local[*]", version = "3.4.1")

health_tbl <- copy_to(
  sc, simulate_bdat602(n = 500000, seed = 602),
  name = "health_ins", overwrite = TRUE
)

# Keep only rows with complaint notes
complaints_spark <- health_tbl |>
  filter(!is.na(complaint_notes)) |>
  mutate(doc_id = monotonically_increasing_id())

# Step 1: Tokenise (lowercase + split on whitespace)
tokenised <- complaints_spark |>
  ft_tokenizer(input_col = "complaint_notes", output_col = "words_raw")

# Step 2: Remove stop words
cleaned <- tokenised |>
  ft_stop_words_remover(input_col = "words_raw", output_col = "words")

# Step 3: Count vectoriser — learn vocabulary from training data
cv_model <- ft_count_vectorizer(cleaned, input_col = "words",
                                output_col = "tf", min_df = 5)
# min_df = 5: ignore terms appearing in fewer than 5 documents

tf_vectors <- ml_transform(cv_model, cleaned)

# Step 4: IDF — downweight common terms
idf_model   <- ft_idf(tf_vectors, input_col = "tf", output_col = "tfidf")
tfidf_spark <- ml_transform(idf_model, tf_vectors)

# Inspect schema — tfidf column holds a SparseVector per document
tfidf_spark |> glimpse()

# Retrieve vocabulary to map vector indices back to words
vocab <- cv_model$vocabulary
cat("Vocabulary size:", length(vocab), "\n")

# Collect a sample to inspect top terms
sample_doc <- tfidf_spark |>
  select(doc_id, complaint_notes, tfidf) |>
  head(3) |>
  collect()

spark_disconnect(sc)
```

**Key difference from tidytext**: Spark produces a *sparse vector* per document (each document is one row with a vector of TF-IDF values indexed by vocabulary position), not a long-format data frame. This format is ready for downstream Spark ML algorithms (`ml_lda()`, `ml_kmeans()`, classification) without any further conversion.

## Example

Full worked example is in `solution.Rmd`. It processes the `complaint_notes` column, builds TF-IDF scores, and identifies the top discriminating words for each complaint template category.

## Task

Open `exercise.Rmd` and complete the five tasks: (1) tokenise the complaint notes and count word frequencies; (2) remove stop words and identify the top 20 most common words; (3) compute TF-IDF with `bind_tf_idf()`; (4) visualise the top 10 TF-IDF words per complaint category; (5) build the equivalent Spark text pipeline using `ft_tokenizer()`, `ft_stop_words_remover()`, `ft_count_vectorizer()`, and `ft_idf()` on the full 500,000-row dataset.

## Check

```
npm run check -- bdat-602 module-06 lesson-01
```

## Reflection

TF-IDF treats each document independently and ignores word order. A complaint saying "not satisfied" and one saying "satisfied" would share the token "satisfied" and get similar TF-IDF scores for that term. What text mining technique would capture this difference, and what are the trade-offs of using it?
