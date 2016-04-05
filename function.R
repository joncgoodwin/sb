
write_sleeping_beauty <- function(x,y,z) { #x=filename,
                                        #y=citation threshold
    #z = sleeping threshold
                                        #libraries
    library(dplyr)
    library(tidyr)
    library(ggplot2)
    library(scales) #for log axis in plotgraph

                                        #read csv
    sb <- read.csv(x,stringsAsFactors=FALSE)
    sb <- rename(sb,name=Title)


                                        #transform from wide to long
    sb <- sb  %>%
        select(name,Authors,Publication.Year,X1973:X2016) %>%
            gather(Year,cite,X1973:X2016) %>% #assumes this range, not
                                        #always the case
                mutate(Year = as.numeric(gsub("X","", Year))) %>%
                    group_by(name) %>%
                        mutate (cite = cumsum(cite))

                                        #create elapsed column
    sb <- sb %>% mutate(elapsed=Year-Publication.Year) %>% filter (elapsed>0)


                                        #write csv for d3.js display
    sb <- sb %>% filter(max(cite)>=y) # keep only those with cites greater than
                                        # threshold

                                        #need to create clean key column before writing or munge titles so
                                        #they will be clean as key values in javascript: remove all
                                        #quotes, commas, parentheses,
                                        #etc.

    sb$id <- group_indices(sb,name) #who knows?
    sb$id <- sub("^","flute",sb$id) #for javascript hash---seems to work

                                        # need to change 0s to 0.1 for d3.scale.log
    sb$cite[sb$cite==0] <- 0.1
   # sb <- subset(sb, cite <1 & elapsed > z) #this isn't working

    write.csv(sb, "data.csv", row.names=FALSE) #this data will not be
                                        #clean enough for d3




}

plotgraph <- function(sb) {

                                        #position labels
        sb <- sb %>% mutate (label_x_position=max(elapsed))
        sb <- sb %>% mutate(label_position=max(cite))
                                        #need to come up with non-manual method for this higlighting
        rt <- sb %>% filter(grepl("STOKER|SENSATION|16TH-CENTURY SPAIN",name))

                                        #graph








        gg <- ggplot(data=sb, aes(x=elapsed,y=cite, Group=name))
        gg <- gg + theme_bw()
        gg <- gg + geom_line(colour="gray", alpha=.25)
        gg <- gg + geom_line(data=rt, aes(x=elapsed, y=cite, Group=name), alpha=1, colour="red")
        gg <- gg + scale_y_continuous(trans=log2_trans())
        gg <-  gg + xlab("Years Elapsed Since Publication")
        gg <-  gg + ylab("Cumulative Citations")
        gg <-  gg + ggtitle(x)
                                        #gg <- gg + scale_y_continuous(breaks=c(0,1,2,3,4,5,10,25,50,100,200,400))
        gg <- gg + geom_text(data=subset(sb, cite <1 & elapsed > 10), aes(x=label_x_position, y=label_position, Group=name, label=name), colour="red", size=2)

        gg
    }
