# Task: Mining and Interpreting Association Rules

## Objective

Prepare insurance add-on data as a transaction object, mine association rules with `apriori()`, visualise them, and deliver actionable business recommendations.

## Instructions

1. Knit `exercise.Rmd` to confirm it runs without errors.

2. **Task 1 — Transactions**: Select `dental_cover`, `vision_cover`, `mental_cover`, and `maternity_cover` from `health_data`. Convert each to logical. Convert the data frame to an `arules` transactions object with `as(df, "transactions")`. Print the `summary()`.

3. **Task 2 — Item frequencies**: Plot relative item frequencies with `itemFrequencyPlot()`. In a comment, state which item is most frequent and which is rarest, and explain how rarity affects the number of rules you expect.

4. **Task 3 — Mine rules**: Run `apriori()` with `supp = 0.05, conf = 0.70, minlen = 2`. Print the `summary()` of the rules. Display the top 10 rules by lift with `inspect()`. Then filter for rules where `dental_cover=TRUE` is the consequent and inspect those sorted by lift.

5. **Task 4 — Scatter plot and recommendations**: Create a scatter plot with `method = "scatter", shading = "lift"`. Inspect the top 3 rules by lift and write one actionable business recommendation for each. Recommendations must be specific: name the cover involved, the direction of the campaign (which customers to target), and why the lift justifies the action.

## Submission

Submit `exercise.Rmd` and the knitted `exercise.html`. Recommendations (Task 4) must be written as R comments inside the code chunk. Do not copy the lesson's example recommendations verbatim.
