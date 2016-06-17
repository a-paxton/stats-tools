# stats-tools
Just some bits of code to help clean up and display statistical analyses, largely in R.

Below are the current functions:
* `pander_lme`: Clean up an `lme4` model output in a `pander`-like table
 + Optional: Create caption with marginal (i.e., considering fixed effects only) and conditional (i.e., considering both fixed and random effects) *R*-squared. Requires `piecewiseSEM`.
* `pander_lm`: Clean up an `lm` model output in a `pander`-like table
 + Optional: Create caption with adjusted *R*-squared and F-statistics.
