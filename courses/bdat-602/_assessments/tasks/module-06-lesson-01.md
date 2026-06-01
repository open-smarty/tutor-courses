# Task: TF-IDF Analysis of Churned vs Retained Customers

## Objective

Use TF-IDF to identify which words in complaint notes most strongly differentiate churned from retained policyholders.

## Instructions

1. **Prepare corpus** — From `health_small`, filter to rows where `complaint_notes` is not NA. Add `doc_id = row_number()`. Retain `churned` for later joining.

2. **Tokenise** — `unnest_tokens()`, remove stop words, filter `nchar(word) > 2`.

3. **TF-IDF by churn status** — Use `churned` (0 vs 1) as the document grouping variable. Compute `bind_tf_idf()`. Show the top 8 discriminating words for churned = 1 and churned = 0.

4. **Visualisation** — Create a faceted bar chart: top 8 words by TF-IDF for `churned = 0` (left panel) and `churned = 1` (right panel). Use different fill colours.

5. **Interpretation** — Write 2–3 sentences: which complaint types are most associated with churn? Do the TF-IDF findings make business sense?

6. **Bigrams** — Repeat Task 3 but tokenise into bigrams (`token = "ngrams", n = 2`). Remove bigrams that contain stop words in either position. Report the top 5 bigrams for churned = 1.

## Submission

Knit your Rmd with the faceted bar chart, interpretation text, and bigram table visible.
