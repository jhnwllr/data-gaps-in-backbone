# datasets which have quotes around the names 

library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(grepl('["]|\'',v_scientificname)) %>% 
filter(grepl("[^ ]{4} [^ ]{4}",v_scientificname)) %>% # two words
filter(!grepl(":",v_scientificname)) %>%
filter(!grepl("-",v_scientificname)) %>%
filter(!grepl("_",v_scientificname)) %>%
collect() %>% 
mutate(nq_v_scientificname = gsub('["]|\'',"",v_scientificname)) %>%
mutate(verbatim_index = row_number()) %>%
glimpse()

if(FALSE) {

not_capped_df = d %>%
mutate(name=nq_v_scientificname) %>%
name_backbone_checklist() %>%
select(
verbatim_index,
nq_verbatim_name = verbatim_name,
nq_matchType = matchType,
nq_kingdom = kingdom,
nq_rank = rank
) %>% 
glimpse() %>% 
saveRDS("data/nq_df.rda") 

capped_df = d %>%
mutate(name=v_scientificname) %>%
name_backbone_checklist() %>%
select(
verbatim_index,
q_verbatim_name = verbatim_name,
q_matchType = matchType,
q_kingdom = kingdom,
q_rank = rank
) %>% 
glimpse() %>%
saveRDS("data/q_df.rda") 
}

nq_df = readRDS("data/nq_df.rda") 
q_df = readRDS("data/q_df.rda") 

df_merged = merge(q_df,nq_df,id="verbatim_index") %>% 
merge(d,id="verbatim_index") %>% 
mutate(datasetkey = stringr::str_split(datasetkeys,";")) %>%
tidyr::unnest(cols=datasetkey) %>%
filter(q_matchType == "HIGHERRANK", nq_matchType == "EXACT") %>%
filter(nq_rank %in% c("SPECIES","VARIETY","SUBSPECIES")) %>% 
glimpse()

# sample_n(20) %>%
# df_merged %>% 
# select(v_scientificname,nq_v_scientificname) %>%
# mutate(no_match_link=paste0("[link](https://api.gbif.org/v1/species/match?name=",v_scientificname,")") %>% gsub(" ","%20",.)) %>%
# mutate(match_link=paste0("[link](https://api.gbif.org/v1/species/match?name=",nq_v_scientificname,")") %>% gsub(" ","%20",.)) %>%
# glimpse() %>%
# knitr::kable() 

df_merged %>% 
group_by(datasetkey) %>% 
summarise(n_names=n_distinct(v_scientificname),n_occ=sum(n_occ)) %>%
arrange(-n_names) %>% 
head(50) %>%
gbifapi::addDatasetTitle(datasetkey) %>%
gbifapi::addPublishingOrganization(datasetkey) %>% 
mutate(link = paste0("[link](https://www.gbif.org/dataset/",datasetkey,")")) %>%
select(datasettitle,publishingOrganizationTitle,n_names,n_occ,link) %>%
knitr::kable()

# df_merged %>% select(nq_v_scientificname) 


# filter(!grepl("[^ ]'[^]",v_scientificname)) %>% # two words
# filter(!grepl("[*]",v_scientificname)) %>%
# filter(!grepl("SP.",v_scientificname)) %>% # two words
# mutate(first_capped = substr(v_scientificname,1,1) %>% toupper()) %>% 
# mutate(rest = substr(v_scientificname,2,nchar(v_scientificname)) %>% tolower()) %>% 
# mutate(nc_v_scientificname = paste0(first_capped,rest)) %>%
# glimpse() 







