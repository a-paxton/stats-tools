# stats-tools
Just some bits of code to help clean up and display statistical analyses, largely in R.

Below are the current functions:
* `pander_lme`: Clean up an `lme4` model output in a `pander`-like table. Requires `pander`.
    + Optional: Create caption with marginal (i.e., considering fixed effects only) and conditional (i.e., considering both fixed and random effects) *R*-squared. Requires `MuMIn`.
* `pander_lm`: Clean up an `lm` model output in a `pander`-like table. Requires `pander`.
    + Optional: Create caption with adjusted *R*-squared and F-statistics.
* `pander_lme_to_latex`: Export the output of an `lme4` model in a LaTex-friendly file. Requires `pander`, `Hmisc`, `plyr`, and `dplyr`.
    + Note: The resulting table still contains row indices. These must be manually deleted from the resulting `.tex` file if they are not needed.
* `pander_anova`: Clean up an `anova` model output in a `pander`-like table, including adjusted *R*-squared and F-statistics in the caption. Requires `pander` and `plyr`.
