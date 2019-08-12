pander_lm = function(lm_model_name, stats.caption=FALSE){

  #'  Create a cleaner lm model output with pander.
  #'
  #'  Parameters
  #'  ----------
  #'  lm_model_name : lm model
  #'     Model whose output will be cleaned.
  #'
  #'  stats.caption : boolean, optional (default: FALSE)
  #'     Specify whether or not to provide the adjusted
  #'     R-squared and F-statistics in the table caption.
  #'
  #'  Output
  #'  ------
  #'  neat_output : table
  #'     Cleaned lm model output.

  # load in pander
  require(pander)

  # disable scientific notation
  options(scipen = 999)

  # convert the model summary to a dataframe
  neat_output = data.frame(summary(lm_model_name)$coefficient)

  # round p-values (using Psychological Science's recommendations)
  neat_output$p = neat_output$"Pr...t.."
  neat_output = subset(neat_output, select=-c(Pr...t..))
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

  # if desired, set a caption that includes R-squared values
  if (stats.caption==TRUE){

    # grab adjusted
    model_adj_r_squared = summary(lm_model_name)$adj.r.squared
    model_fstatistics = summary(lm_model_name)$fstatistic
    neat_caption = paste('**Adjusted *R*-squared: ',
                         round(model_adj_r_squared,2), "; *F*(",
                         model_fstatistics[2],",",model_fstatistics[3],
                         ") = ",round(model_fstatistics[1],2),"**",sep="")

    # return the table
    return(pander(neat_output, split.table = Inf, caption = neat_caption, style = 'rmarkdown'))
  } else { # or return a table without the caption
    return(pander(neat_output, style="rmarkdown", split.table = Inf))
  }
}
