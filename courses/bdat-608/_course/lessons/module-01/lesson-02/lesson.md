# Lesson 2: Setting Up the R Modelling Environment

## Goal

Configure a working R modelling environment, load and inspect the `diamonds` dataset, and produce your first annotated scatter plot and a basic fitted line — all inside an R Markdown document that knits cleanly to HTML.

## Concept

Before any modelling, you need two things in place: the right packages and a workflow that makes your analysis reproducible. R Markdown is how we achieve the second goal.

**Packages.** The core packages for this course are:

| Package | Why we need it |
|---|---|
| `tidyverse` | Data manipulation (`dplyr`, `tidyr`) and plotting (`ggplot2`) |
| `modelr` | `data_grid()`, `add_predictions()`, `add_residuals()` |
| `broom` | Turns model output into tidy data frames via `tidy()`, `augment()`, `glance()` |

Install packages once with `install.packages(c("tidyverse", "modelr", "broom"))`. After installation, load them at the top of every script with `library()`. Never put `install.packages()` inside a chunk that runs automatically — it re-downloads the package every time you knit.

**R Markdown chunk options.** Each code chunk has a header like `` ```{r label, option=value} ``. The most important options are:

- `echo = TRUE` — show the source code in the output (good for teaching).
- `eval = FALSE` — show the code but do not run it (useful for `install.packages()`).
- `include = FALSE` — run the code but show nothing (good for setup).
- `message = FALSE` — suppress messages (e.g., package loading messages).
- `warning = FALSE` — suppress warnings.

**The pipe operator `|>`.** Instead of nesting function calls, we write them left to right:

```r
diamonds |> filter(carat > 1) |> summarise(mean_price = mean(price))
```

This reads: "take diamonds, then filter to carat > 1, then compute the mean price." It is equivalent to `summarise(filter(diamonds, carat > 1), mean_price = mean(price))` but far easier to read and modify.

**Inspecting a dataset.** Before fitting any model, always run:

- `glimpse(data)` — one row per column, shows type and first few values.
- `summary(data)` — min, max, mean, and quartiles for numeric columns; level counts for factors.
- `ggplot(data, aes(x, y)) + geom_point()` — a quick scatter plot to see the raw relationship.

## Example

We inspect `diamonds` and produce a scatter plot with a linear fit.

```r
library(tidyverse)
library(modelr)
library(broom)

data("diamonds", package = "ggplot2")
glimpse(diamonds)
```

`glimpse()` shows 53,940 rows and 10 columns. Key columns: `price` (integer, USD), `carat` (double, weight), `cut` (ordered factor: Fair < Good < Very Good < Premium < Ideal), `color` (D–J, D is best), `clarity` (I1 to IF, IF is best).

```r
ggplot(diamonds, aes(x = carat, y = price, colour = cut)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title  = "Diamond price vs carat",
    x      = "Carat",
    y      = "Price (USD)"
  ) +
  theme_minimal()
```

`geom_smooth(method = "lm")` fits one straight line per `cut` group. You will notice that: (1) heavier diamonds cost more, (2) the lines are roughly parallel — suggesting cut shifts the intercept but not the slope dramatically, (3) the cloud of points gets wider for large carats — confirming the heteroscedasticity we saw in lesson 1.

**Reading `summary(diamonds)`.** For `price`: Min = \$326, Median = \$2,401, Mean = \$3,933, Max = \$18,823. The mean exceeds the median, indicating a right-skewed distribution — more cheap diamonds than expensive ones.

## Task

Open `exercise.Rmd`. Complete the following inside a knittable R Markdown document:

1. Install the required packages (only in a chunk with `eval = FALSE`).
2. Load `tidyverse`, `modelr`, and `broom`.
3. Run `glimpse()` and `summary()` on `diamonds`. Report the number of rows, columns, and the median diamond price.
4. Create a scatter plot of `price` vs `carat` coloured by `cut`, with `alpha = 0.3` and `geom_smooth(method = "lm")`.
5. Write one sentence interpreting the `geom_smooth()` line.
6. Use the pipe `|>` to filter diamonds where `carat > 2` and report how many remain.

## Check

```
npm run check -- bdat-608 module-01 lesson-02
```

## Reflection

The pipe `|>` makes code easier to read by presenting operations in the order they happen. But pipes can also make debugging harder — if one step in the chain produces an unexpected result, you have to break the chain apart to find it. When is it better to use nested function calls or intermediate variables instead of a long pipe chain?
