library(stats)

pander_lme = function(lme_model_name, stats.caption=FALSE, p.adj = TRUE){

  #'  Create a cleaner lme4 model output with pander.
  #'
  #'  Parameters
  #'  ----------
  #'  lme_model_name : lme4 model
  #'     Model whose output will be cleaned.
  #'
  #'  stats.caption : boolean, optional (default: FALSE)
  #'     Specify whether or not to provide the marginal
  #'     (i.e., fixed effects only) and conditional (i.e.,
  #'     fixed and random effects) R-squared values in the
  #'     table's caption.
  #'
  #'  p.adj : boolean, optional (default: TRUE)
  #'     Specify whether or not to provide the adjusted
  #'     p-value in the table (using Benjamini & Hochberg, 1995).
  #'
  #'  Output
  #'  ------
  #'  neat_output : pander table
  #'     Cleaned lme4 model output. Includes both raw and
  #'     adjusted p-values.


  # load in pander
  require(pander)

  # disable scientific notation
  options(scipen = 999)

  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lme_model_name)$coefficient)

  # create p-value from t-value
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))

  # check whether p-values are already provided
  if (is.null(neat_output$"Pr...t..")) {
    # calculate p-value (per recommendations by Barr, Levy, Scheepers, & Tily, 2013)
    neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  } else {
    neat_output$p = neat_output$"Pr...t.."
    neat_output = subset(neat_output, select=-c(Pr...t..))
  }

  # if desired, output the p-value adjusted for multiple comparisons
  if (p.adj == TRUE){

    # create adjusted p-values
    neat_output$p_adj = stats::p.adjust(neat_output$p, method="BH")

    # round p-values (using Psychological Science's recommendations) for display
    neat_output$p_adj[neat_output$p_adj < .0001] = .0001
    neat_output$p_adj[neat_output$p_adj >= .0001] = round(neat_output$p_adj[neat_output$p_adj >= .0001],4)
    neat_output$p_adj[neat_output$p_adj >= .0005] = round(neat_output$p_adj[neat_output$p_adj >= .0005],3)
    neat_output$p_adj[neat_output$p_adj >= .25] = round(neat_output$p_adj[neat_output$p_adj >= .25],2)
  }

  # round unadjusted p-values for display
  neat_output$p[neat_output$p < .0001] = .0001
  neat_output$p[neat_output$p >= .0001] = round(neat_output$p[neat_output$p >= .0001],4)
  neat_output$p[neat_output$p >= .0005] = round(neat_output$p[neat_output$p >= .0005],3)
  neat_output$p[neat_output$p >= .25] = round(neat_output$p[neat_output$p >= .25],2)

  # create significance and trending markers
  neat_output$sig = ' '
  if (p.adj == TRUE){
    neat_output$sig[neat_output$p_adj < .1] = '.'
    neat_output$sig[neat_output$p_adj < .05] = '*'
    neat_output$sig[neat_output$p_adj < .01] = '**'
    neat_output$sig[neat_output$p_adj < .001] = '***'
  } else {
    neat_output$sig[neat_output$p < .1] = '.'
    neat_output$sig[neat_output$p < .05] = '*'
    neat_output$sig[neat_output$p < .01] = '**'
    neat_output$sig[neat_output$p < .001] = '***'
  }

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
