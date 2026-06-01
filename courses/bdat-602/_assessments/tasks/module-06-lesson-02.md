# Task: LDA Topic Discovery and Churn Insight

## Objective

Use LDA to discover complaint topics and identify which topics are associated with higher churn rates.

## Instructions

1. **Build DTM** — Repeat the Lesson 1 pipeline (filter, tokenise, stop words, nchar > 2, cast_dtm). Remove any terms that appear in fewer than 5 documents (`removeSparseTerms(dtm, 0.995)`).

2. **Fit LDA** — Try k = 4 and k = 6. For each, compute the **perplexity** on the training DTM: `perplexity(lda_fit, dtm)`. Choose the k with lower perplexity and proceed with it.

3. **Label topics** — Extract the beta matrix. For your chosen k, list the top 8 words per topic in a table. Give each topic a business label (e.g. "Claims Processing", "Billing", "Coverage", "Service", "Positive").

4. **Gamma analysis** — Assign each document its dominant topic. Join back to `health_small` via `doc_id`. Compute per-topic:
   - Average gamma (dominant topic strength)
   - Churn rate (%)
   - Mean `claim_amount`
   - n (documents)

5. **Visualisation** — Bar chart of churn rate per topic, sorted descending.

6. **Business recommendation** — Which 1–2 complaint topics should the retention team prioritise? Write 2–3 sentences linking the LDA finding to a concrete operational action.

## Submission

Knit your Rmd with the perplexity comparison, topic label table, gamma summary, bar chart, and recommendation visible.
