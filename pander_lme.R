# Create a cleaner lme4 model output with pander
pander_lme = function(lme_model_name){
  library(pander)

  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lme_model_name)$coefficient)

  # get it to display p-values and asterisks based on significance
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'
  
  # return the table
  return(pander(neat_output, style="grid",split.table = Inf))
}
