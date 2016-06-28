
write_sleeping_beauty <- function(x,y) { #x=filename,
                                        #y=citation threshold

                                        #libraries
    library(dplyr)
    library(tidyr)
    library(ggplot2)
    library(scales) #for log axis in plotgraph
    library(stringr)

                                        #read csv
    sb <- read.csv(x,stringsAsFactors=FALSE)
    sb <- rename(sb,name=Title)
    sb <- rename(sb,PublicationYear=Publication.Year)
    sb <- rename(sb,Journal=Source.Title)


                                        #transform from wide to long
    sb <- sb  %>%
        select(name,Authors,PublicationYear,Journal,X1973:X2016) %>%
            gather(Year,cite,X1973:X2016) %>% #assumes this range, not
                                        #always the case
                mutate(Year = as.numeric(gsub("X","", Year))) %>%
                    group_by(name) %>%
                        mutate (cite = cumsum(cite))

                                        #create elapsed column
    sb$PublicationYear <- as.numeric(sb$PublicationYear) #for text
                                        #export from Web of Science
    sb$name <- str_to_title(sb$name)
    sb$Journal <- str_to_title(sb$Journal)
    sb <- sb %>% mutate(elapsed=Year-PublicationYear) %>% filter (elapsed>0)


                                        #write csv for d3.js display
    sb <- sb %>% filter(max(cite)>=y) # keep only those with cites greater than
                                        # threshold

                                        #need to create clean key column before writing or munge titles so
                                        #they will be clean as key values in javascript: remove all
                                        #quotes, commas, parentheses,
                                        #etc.

    sb$id <- group_indices(sb) #Fixed per Andrew Goldstone's helpful
                                        #explanation.

    sb$id <- sub("^","flute",sb$id) #for javascript hash---seems to
                                        #work
    sb$Journal <- sub("-PUBLICATIONS OF THE MODERN LANGUAGE ASSOCIATION OF AMERICA","",sb$Journal) # journal specific tweak

                                        # need to change 0s to 0.9 for d3.scale.log
    sb$cite[sb$cite==0] <- 0.9
    sb$threshold <- y #hackish way of showing threshold in d3 graph


    write.csv(sb, "data.csv", row.names=FALSE)


sb


}

plotgraph <- function(sb,x,y) { #sb is dataframe from above; x is
                             #citation theshold, y years

                                        #position labels
        sb <- sb %>% mutate (label_x_position=max(elapsed))
        sb <- sb %>% mutate(label_position=max(cite))

        at <- subset(sb,cite<x & elapsed>y) #for labels

        rt <- sb %>% filter(name %in% at$name) # for highlight

        gg <- ggplot(data=sb, aes(x=elapsed,y=cite, Group=name))
        gg <- gg + theme_bw()
        gg <- gg + geom_line(colour="gray", alpha=.25)
        gg <- gg + geom_line(data=rt, aes(x=elapsed, y=cite,
                                        Group=name), alpha=1, colour="red")
        gg <- gg + scale_y_continuous(trans=log2_trans())
        gg <-  gg + xlab("Years Elapsed Since Publication")
        gg <-  gg + ylab("Cumulative Citations")
        gg <-  gg + ggtitle("Sleeping Beauties")
        gg <- gg + geom_text(data=at, aes(x=label_x_position, y=label_position, Group=name, label=name), colour="red", size=2)

        gg
    }
