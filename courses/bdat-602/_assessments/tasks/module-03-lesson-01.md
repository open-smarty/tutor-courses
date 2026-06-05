# Task: Computing Association Rule Metrics and Running Apriori

## Objective

Compute support, confidence, and lift by hand from a toy transaction database, verify the anti-monotone property, and run `arules::apriori()` to discover association rules.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Manual computation**: Using the 5-transaction toy database (dental, vision, mental cover flags), compute the following using R arithmetic (not `apriori()`):
   - `supp({dental})`, `supp({vision})`, `supp({mental})`, `supp({dental, vision})`
   - `conf(dental → vision)` and `conf(vision → dental)`
   - `lift(dental → vision)`
   - In a comment: state whether the association is positive, negative, or independent and why.

3. **Task 2 — Anti-monotone property**: With min\_supp = 0.60, show that `{dental, mental}` is infrequent. Then compute `supp({dental, vision, mental})` and confirm it is also below min\_supp. In a comment, explain why this is guaranteed by the anti-monotone property.

4. **Task 3 — apriori()**: Convert `trans_list` to an `arules` transactions object. Run `apriori()` with `supp = 0.40, conf = 0.60, minlen = 2`. Use `inspect(sort(rules, by = "lift"))` to display the rules.

5. **Task 4 — Interpretation**: For the top 3 rules by lift, write a one-sentence business interpretation for each. Your interpretation must be in insurance terms (not generic market basket language).

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Business interpretations (Task 4) must be written as R comments inside the code chunk.
