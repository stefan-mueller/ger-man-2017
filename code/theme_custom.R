## Load function for plots
theme_custom <- function (){
  theme_bw()  %+replace% 
    theme(panel.background = ggplot2::element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(), 
          panel.grid.minor.y = element_blank(), 
          plot.background = element_blank(),
          legend.title = element_text(size = 12),
          panel.grid.major.y = element_line(linetype = "dotted"),
          legend.position = "bottom",
          strip.text = element_text(size = 12),
          axis.text = element_text(colour="black", size = 10),
          axis.title = element_text(size = 12))
}