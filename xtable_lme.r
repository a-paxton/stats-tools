# `xtable_lme`
#
#  Create a cleaner lme4 model output for
#  printing with xtable.
#
#  Parameters
#  ----------
#  lme_model_name : lme4 model
#     Model whose output will be cleaned.
#
#  Output
#  ------
#  neat_output : table
#     Cleaned lme4 model output.

xtable_lme = function(lme_model_name){

  # load in pander
  library(pander)
  library(dplyr)
  library(xtable)

  # disable scientific notation
  options(scipen = 999)

  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lme_model_name)$coefficient)

  # round p-values (using Psychological Science's recommendations)
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  neat_output$p[neat_output$p < .0005] = round(neat_output$p[neat_output$p < .0005],4)
  neat_output$p[neat_output$p >= .0005] = round(neat_output$p[neat_output$p >= .0005],3)
  neat_output$p[neat_output$p >= .25] = round(neat_output$p[neat_output$p >= .25],2)

  # create significance and trending markers
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .1] = '.'
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'

  # remove unneeded variables
  neat_output = select(neat_output, -Std..Error, -t.value)

  # fix printed names
  setDT(neat_output, keep.rownames = TRUE)[]
  names(neat_output)[1] = ""
  names(neat_output)[2] = "Estimate"
  names(neat_output)[3] = "p-value"
  names(neat_output)[4] = "Sig."

  # return the table
  return(neat_output)
}
