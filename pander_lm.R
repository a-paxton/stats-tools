# 'pander_lm': Create a cleaner lm model output with pander.
#
# Optional: 
#   Include caption with adjusted R-squared and F-stats.

pander_lm = function(lm_model_name, stats.caption){
  
  # load in pander
  library(pander)
  
  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lm_model_name)$coefficient)
  
  # get it to display p-values and asterisks based on significance
  neat_output$p = 2*(1-pnorm(abs(neat_output$t.value)))
  neat_output$sig = ' '
  neat_output$sig[neat_output$p < .1] = '.'
  neat_output$sig[neat_output$p < .05] = '*'
  neat_output$sig[neat_output$p < .01] = '**'
  neat_output$sig[neat_output$p < .001] = '***'
  
  # if desired, create a caption that includes R-squared
  if (stats.caption == TRUE){
    
    # get adjusted R-squared and F statistics
    model_adj_r_squared = summary(lm_model_name)$adj.r.squared
    model_fstatistics = summary(lm_model_name)$fstatistic
    
    # create caption (includes markdown formatting)
    neat_caption = paste('**Adjusted *R*-squared: ',
                         round(model_adj_r_squared,2), "; *F*(",
                         model_fstatistics[2],",",model_fstatistics[3],
                         ") = ",round(model_fstatistics[1],2),"**",sep="")
    
    # return the table with caption
    return(pander(neat_output, split.table = Inf, caption = neat_caption))
    
  }else{
    
    # or return a table without it
    return(pander(neat_output, style="rmarkdown",split.table = Inf))
    
  }
}