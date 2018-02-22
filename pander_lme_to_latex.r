# `pander_lme_to_latex`
#
#  Export an LMER summary table to a LaTex file.
#
#  Note that this will retain the row index column,
#  which will be given a name`neat" in the table.
#  This will be need to be manually removed in the
#  final `.tex` file.
#
#  Parameters
#  ----------
#  lme_model_name : lme4 model
#     Model whose output will be cleaned.
#
#  save_filename : str
#     File name for saved LaTex model.
#
#  Output
#  ------
#  neat_output : pander table
#     Cleaned lme4 model output.

pander_lme_to_latex = function(lme_model_name, save_filename){

  # load in pander
  require(pander)
  require(Hmisc)
  require(plyr)
  require(dplyr)

  # disable scientific notation
  options(scipen = 999)

  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lme_model_name)$coefficient)

  # round p-values (using Psychological Science's recommendations) for display
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  neat_output$p[neat_output$p < .0001] = .0001
  neat_output$p[neat_output$p >= .0001] = round(neat_output$p[neat_output$p >= .0001],4)
  neat_output$p[neat_output$p >= .0005] = round(neat_output$p[neat_output$p >= .0005],3)
  neat_output$p[neat_output$p >= .25] = round(neat_output$p[neat_output$p >= .25],2)

  # round the estimates, standard error, and t-values
  neat_output$"t-value" = round(neat_output$t.value,3)
  neat_output$"Std. Error" = round(neat_output$Std..Error,3)
  neat_output$Estimate = round(neat_output$Estimate,3)

  # create a new column for variable names
  neat_output$Predictor = row.names(neat_output)
  rownames(neat_output) = NULL
  neat_output = neat_output[,c(7,1,6,5,4)]

  # create significance and trending markers
  neat_output$"Sig." = ' '
  neat_output$"Sig."[neat_output$p < .1] = '.'
  neat_output$"Sig."[neat_output$p < .05] = '*'
  neat_output$"Sig."[neat_output$p < .01] = '**'
  neat_output$"Sig."[neat_output$p < .001] = '***'
  neat_output = plyr::rename(neat_output,c("p" = 'p-value'))

  # save to file
  latex(neat_output,file=save_filename,rownamesTexCmd=NULL)

  # return the table
  return(neat_output)
}
