
library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

if(FALSE) { 
readr::read_tsv("data/df_filter.tsv") %>%
filter(reason == "too_many_choices") %>% 
sample_n(5000) %>% 
glimpse() %>%
saveRDS("data/too_many_choices_sample.rda")

# %>%
readRDS("data/too_many_choices_sample.rda") %>% 
glimpse() %>%
mutate(suggestions = canonicalnamecomplete %>% 
map({ ~ 
name_suggest(.x,limit=20)$data
})) %>%
tidyr::unnest(cols=suggestions) %>%
select(v_scientificname,s_key=key,s_rank=rank) %>%
mutate(name_usage = s_key %>% map(~ name_usage(.x)$data)) %>% 
tidyr::unnest(cols=name_usage) %>%
glimpse() %>%
select(v_scientificname,synonym,s_rank,taxonomicStatus,authorship) %>%
glimpse() %>%
saveRDS("data/d.rda")
}

readRDS("data/d.rda") %>% 
cglimpse() %>% 
select(v_scientificname) %>%
unique()

# count() %>% 
# filter(!is.na(s_authorship)) %>%
# pull(sugg) %>%
# glimpse()




# pull(key) %>% 
# bind_rows() %>%
# mutate(n = max(row_number())) %>%
# mutate(n_syn = sum(grepl("SYNONYM",taxonomicStatus))) %>%
# mutate(per_syn = (n_syn/n)*100) %>%
# pull(per_syn) %>% 
# unique() 


# %>% 
# select(canonicalnamecomplete,sugg) %>%



# saveRDS("data/too_many_choices_sample_sugg.rda") %>%
# glimpse()

# readRDS("data/too_many_choices_sample_sugg.rda") %>% 
# glimpse() %>%
# head(1) %>% 
# select(sugg) %>% 

# name_usage(8406520)$data %>% pull(taxonomicStatus)


# canonicalName


# select(v_scientificname) %>%














