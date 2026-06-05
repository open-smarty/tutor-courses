# Task: TF-IDF Analysis of Insurance Complaint Notes

## Objective

Tokenise the `complaint_notes` column, remove stop words, compute TF-IDF, and identify the most discriminating terms for each complaint category using a faceted bar chart.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Tokenise**: Generate 100,000 rows from `simulate_bdat602()`. Filter out rows with missing `complaint_notes`. Assign a `doc_id` with `row_number()`. Use `unnest_tokens(word, complaint_notes)` to produce one row per token. Print the total number of tokens and the top 20 most frequent words (before stop word removal).

3. **Task 2 — Stop words**: Remove stop words with `anti_join(stop_words, by = "word")`. Print the token count before and after. Create a bar chart of the top 20 most frequent words after removal.

4. **Task 3 — TF-IDF**: Count words per document with `count(doc_id, word)`. Apply `bind_tf_idf(word, doc_id, n)`. Show the top 10 rows sorted by `tf_idf` descending. In a comment, explain why these particular words have high TF-IDF scores.

5. **Task 4 — Top terms per category**: Classify complaints into five categories using `str_detect()` on the complaint text (billing, claims, coverage, service, positive). Join the category labels to the TF-IDF data frame. For each category, compute the mean TF-IDF per word and plot the top 8 as a `facet_wrap()` bar chart. In a comment, state which category has the most distinctive vocabulary and why.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Interpretations (Tasks 3 and 4) must be written as R comments inside their code chunks.
