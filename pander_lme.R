# `pander_lme`
#
#  Create a cleaner lme4 model output with pander.
#
#  Parameters
#  ----------
#  lme_model_name : lme4 model
#     Model whose output will be cleaned.
#
#  stats.caption : boolean, optional (default: FALSE)
#     Specify whether or not to provide the marginal
#     (i.e., fixed effects only) and conditional (i.e.,
#     fixed and random effects) R-squared values in the
#     table's caption.
#
#  Output
#  ------
#  neat_output : pander table
#     Cleaned lme4 model output.

pander_lme = function(lme_model_name, stats.caption=FALSE){

  # load in pander
  require(pander)

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

  # create significance and trending markers
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .1] = '.'
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'

  # if desired, create a caption that includes R-squared
  if (stats.caption == TRUE){

    # use MuMIN to calculate R-squared
    require(MuMIn)
    model_marginal_r_squared = r.squaredGLMM(lme_model_name)[['R2m']]
    model_conditional_r_squared = r.squaredGLMM(lme_model_name)[['R2c']]
    neat_caption = paste('**Marginal *R*-squared: ',
                         round(model_marginal_r_squared,2),
                         ". Conditional *R*-squared: ",
                         round(model_conditional_r_squared,2),".**",sep="")

    # return the table
    return(pander(neat_output, split.table = Inf, caption = neat_caption, style = 'rmarkdown'))

  } else { # or return a table without it
    return(pander(neat_output, split.table = Inf, style = 'rmarkdown'))
  }
}
