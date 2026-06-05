# Task: Topic Modelling of Insurance Complaints with LDA

## Objective

Build a document-term matrix from the complaint notes, fit a 5-topic LDA model using Gibbs sampling, interpret the discovered topics, and choose the optimal number of topics using perplexity.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Setup**: Generate 20,000 rows from `simulate_bdat602()`. Prepare cleaned word counts (filter NA notes, unnest\_tokens, anti\_join stop words, count by doc\_id and word) — reuse the pipeline from Lesson 1.

3. **Task 1 — DTM**: Convert `word_counts` to a document-term matrix with `cast_dtm(doc_id, word, n)`. Print the DTM object and report: number of documents, number of terms, and sparsity percentage.

4. **Task 2 — Fit LDA**: Run `LDA(dtm, k = 5, method = "Gibbs", control = list(seed = 602, iter = 500, burnin = 100))`. This may take 1-2 minutes. Assign the result to `lda5`.

5. **Task 3 — Interpret topics**: Extract word-topic probabilities with `tidy(lda5, matrix = "beta")`. Plot the top 10 words per topic using `facet_wrap()` with `reorder_within()`. Assign a human-readable label to each topic based on its top words. Labels must reference insurance terminology (not generic descriptions).

6. **Task 4 — Perplexity**: Use `tidy(lda5, matrix = "gamma")` to extract document-topic probabilities. Print the mean gamma per topic. Then fit LDA for K = 3, 4, 5, 6, 7 (with `iter = 200, burnin = 50` for speed) and compute `perplexity()` for each. Plot the curve and identify the best K. In a comment, state whether your chosen K matches the 5 simulator template categories and why.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Topic labels (Task 3) and K selection reasoning (Task 4) must be written as R comments inside their respective code chunks.
