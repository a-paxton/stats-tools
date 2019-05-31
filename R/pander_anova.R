library(pander)
library(plyr)

#' Create a cleaner ANOVA model output with pander.
#'
#' @param anova_model_name ANOVA model. Model whose output will be cleaned.
#' @return neat_output	pander table. Cleaned ANOVA model output.
#' @export
pander_anova = function(anova_model_name){

  # disable scientific notation
  options(scipen = 999)

  # convert the model summary to a dataframe and rename variables
  neat_output = data.frame(anova_model_name)

  # round p-values (using Psychological Science's recommendations)
  neat_output$p = neat_output$Pr..Chisq.
  neat_output$p[is.na(neat_output$p)] = 0
  neat_output$p[neat_output$p < .0005] = round(neat_output$p[neat_output$p < .0005],4)
  neat_output$p[neat_output$p >= .0005] = round(neat_output$p[neat_output$p >= .0005],3)
  neat_output$p[neat_output$p >= .25] = round(neat_output$p[neat_output$p >= .25],2)

  # create significance and trending markers
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .15] = '.'
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'

  # re-create blank spaces from original anova output
  neat_output$p[is.na(neat_output$Pr..Chisq.)] = ' '
  neat_output$sig[is.na(neat_output$Pr..Chisq.)] = ' '
  neat_output = replace(neat_output,is.na(neat_output),' ')

  # rename variables
  neat_output = plyr::rename(neat_output, replace = c('Df' = 'DF',
                                                      'logLik' = 'Log Likelihood',
                                                      'Chisq' = "Chi Sq.",
                                                      'Chi.Df' = "Chi Sq. DF"))
  neat_output = subset(neat_output, select = -c(Pr..Chisq.))

  # return the neatened table
  return(pander(neat_output, style="rmarkdown",split.table = Inf))
}
