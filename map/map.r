# courtesy of https://cran.r-project.org/web/packages/fiftystater/vignettes/fiftystater.html

library(ggplot2)
library(fiftystater)

data("fifty_states")

files <- c("tweet_mornings", "tweet_states", "tweet_courtesies")

for (i in 1:length(files)) {
    pic <- png(paste(files[i],".png",sep=""), width=1600, height=1200, res=300)
    table <- read.table(paste(files[i],".csv",sep=""), header=TRUE, sep=",")

    p <- ggplot(table, aes(map_id = tolower(state))) +
      # map points to the fifty_states shape data
      geom_map(aes(fill = num), map = fifty_states) +
      expand_limits(x = fifty_states$long, y = fifty_states$lat) +
      coord_map() +
      scale_x_continuous(breaks = NULL) +
      scale_y_continuous(breaks = NULL) +
      labs(x = "", y = "") +
      theme(legend.position = "bottom",
            legend.text=element_text(size=6),
            panel.background = element_blank())
    print(p)
}
dev.off()
