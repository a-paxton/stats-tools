# 'pander_lme': Create a cleaner lme4 model output with pander.
#
# Optional (requires 'piecewiseSEM'): 
#   Include caption with marginal (i.e., fixed effects only) 
#   and conditional (i.e., fixed and random effects) R-squared.

pander_lme = function(lme_model_name, stats.caption){
  library(pander)
  
  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lme_model_name)$coefficient)
  
  # get it to display p-values and asterisks based on significance
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'
  
  # if desired, create a caption that includes R-squared
  if (stats.caption == TRUE){
    
    # use piecewiseSEM to calculate R-squared
    library(piecewiseSEM)
    
    # get both marginal and conditional R-squared values
    model_marginal_r_squared = sem.model.fits(lme_model_name)$Marginal
    model_conditional_r_squared = sem.model.fits(lme_model_name)$Conditional
    
    # create caption (includes markdown formatting)
    neat_caption = paste('**Marginal *R*-squared: ',
                         round(model_marginal_r_squared,2), 
                         "; Conditional *R*-squared: ",
                         round(model_conditional_r_squared,2), ".**",sep="")
    
    # return the table with caption
    return(pander(neat_output, split.table = Inf, caption = neat_caption))
    
  } else {
    
    # or return a table without it
    return(pander(neat_output, style="rmarkdown",split.table = Inf))
    
  }
}
