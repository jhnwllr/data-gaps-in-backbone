# estimate how many missing table 

# setwd("C:/Users/ftw712/Desktop/Beetles/")

library(dplyr)

readr::read_tsv("data/df_filter.tsv") %>%
filter(reason == "other") %>% 
group_by(order_) %>%
count() %>% 
mutate(estimated_missing = plyr::round_any(n*.25,100)) %>% 
select(group=order_,estimated_missing) %>% 
arrange(-estimated_missing) %>%
glimpse() %>%
readr::write_tsv("data/estimated_num_missing_names.tsv")

# slice_sample(n=5) %>% 
# glimpse() %>%
# select(v_scientificname) %>% 






