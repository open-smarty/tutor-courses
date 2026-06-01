# Lesson 1: Tokenisation and TF-IDF

## Goal

Tokenise the `complaint_notes` free-text column, remove stop words, compute term frequency–inverse document frequency (TF-IDF), and identify the most discriminating words per plan tier.

## Concept

### Text as Data

Unstructured text cannot be fed directly into statistical algorithms. The standard pipeline:

```
Raw text → Tokenise → Remove stop words → Stem/Lemmatise
        → Document-Term Matrix (DTM) → TF-IDF weights → Model
```

---

### Tokenisation

A **token** is the basic unit of text. For word-level analysis a token is a single word. The `tidytext` package implements tidy tokenisation:

```r
library(tidytext)
library(dplyr)
source("R/simulate_bdat602_data.R")

health_small <- simulate_bdat602(n = 10000, seed = 602)

# Keep only rows with complaint notes; add a row ID
complaints <- health_small |>
  filter(!is.na(complaint_notes)) |>
  mutate(doc_id = row_number()) |>
  select(doc_id, complaint_notes, plan_tier, churned)

# Tokenise: one row per word
tokens <- complaints |>
  unnest_tokens(word, complaint_notes)

head(tokens, 10)
nrow(tokens)   # ~90,000 tokens from 9,000 complaints
```

---

### Stop Word Removal and Word Counts

Stop words (the, and, is, …) are frequent but carry no meaning:

```r
data("stop_words")

tokens_clean <- tokens |>
  anti_join(stop_words, by = "word") |>
  filter(nchar(word) > 2)   # drop very short tokens

# Top 20 most frequent words
tokens_clean |>
  count(word, sort = TRUE) |>
  slice_head(n = 20) |>
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 20 Words in Complaint Notes",
       x = NULL, y = "Count") +
  theme_minimal()
```

---

### TF-IDF

**Term Frequency (TF):** how often a word appears in a document.
**Inverse Document Frequency (IDF):** penalises words that appear in many documents (less discriminating).

$$\text{TF-IDF}(w, d) = \text{TF}(w, d) \times \log\frac{N}{\text{DF}(w)}$$

where $N$ is the number of documents and $\text{DF}(w)$ is the number of documents containing word $w$.

Words with high TF-IDF are frequent in a specific document group but rare across others — they are **discriminating**.

```r
# Compute TF-IDF per plan tier
tfidf_tier <- tokens_clean |>
  count(plan_tier, word) |>
  bind_tf_idf(term = word, document = plan_tier, n = n) |>
  arrange(desc(tf_idf))

# Top 5 discriminating words per plan tier
tfidf_tier |>
  group_by(plan_tier) |>
  slice_max(tf_idf, n = 5) |>
  ungroup() |>
  ggplot(aes(x = reorder(word, tf_idf), y = tf_idf,
             fill = plan_tier)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ plan_tier, scales = "free_y") +
  coord_flip() +
  labs(title = "Top TF-IDF Words by Plan Tier",
       x = NULL, y = "TF-IDF") +
  theme_minimal()
```

---

### Document-Term Matrix

For algorithms that require a matrix format, convert the tidy token table to a sparse DTM:

```r
dtm <- tokens_clean |>
  count(doc_id, word) |>
  cast_dtm(document = doc_id, term = word, value = n)

dim(dtm)   # documents × terms
```

## Example

```r
# Words that appear only in Bronze complaints
bronze_words <- tokens_clean |>
  count(plan_tier, word) |>
  tidyr::pivot_wider(names_from = plan_tier, values_from = n,
                     values_fill = 0) |>
  filter(Bronze > 0 & Gold == 0 & Silver == 0 & Platinum == 0) |>
  arrange(desc(Bronze))
```

## Task

Open `exercise.Rmd` and complete the three marked chunks:

1. Tokenise `complaint_notes`, remove stop words, and count the top 10 words.
2. Compute TF-IDF with `plan_tier` as the grouping document. Show the top 3 words per tier.
3. Create a DTM. Report its dimensions.

Knit the document. All chunks must run without errors.

## Check

```
npm run check -- bdat-602 module-06 lesson-01
```

## Reflection

In the TF-IDF result, the word "claim" appears in the top words for several plan tiers with similar TF-IDF scores. Explain why this reduces its discriminating power, and suggest a preprocessing step that might make the term more informative.
