# possibly missing table 

# setwd("C:/Users/ftw712/Desktop/Beetles/")

library(dplyr)

readr::read_tsv("data/df_filter.tsv") %>%
filter(reason == "other") %>% 
select(order = order_,v_scientificname) %>% 
glimpse() %>%
readr::write_tsv("data/possibly_missing_table.tsv")

quit(save="no")



