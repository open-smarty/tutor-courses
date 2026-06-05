# Task: Setting Up the R Modelling Environment

## Objective

Produce a fully reproducible R Markdown document that loads the correct packages, inspects the `diamonds` dataset, and generates an annotated scatter plot — confirming your environment is correctly configured for the rest of the course.

## Instructions

1. Create a new R Markdown file with output `html_document`. Set global chunk options: `echo = TRUE`, `message = FALSE`, `warning = FALSE`.
2. Add a chunk with `eval = FALSE` containing `install.packages(c("tidyverse", "modelr", "broom"))`.
3. Load all three packages in a separate chunk that runs on knit.
4. Run `glimpse(diamonds)` and `summary(diamonds)`. In a text paragraph below the chunk, state: the number of rows, the number of columns, the data type of `cut`, and the median price.
5. Create a `ggplot2` scatter plot of `price` vs `carat` with `colour = cut` and `alpha = 0.3`. Overlay `geom_smooth(method = "lm", se = FALSE)`. Add a title and axis labels.
6. Use the pipe `|>` to filter `diamonds` to rows where `carat > 2` and compute the mean price of those large diamonds.
7. Write one sentence explaining why the mean price of "Fair" cut diamonds might be higher than the mean price of "Ideal" cut diamonds when looking at raw data.

## Submission

Knit to HTML and submit the `.html` file and the `.Rmd` source. The HTML must render without errors; all chunks must produce visible output.
