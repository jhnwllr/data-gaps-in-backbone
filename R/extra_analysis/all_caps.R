library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(grepl("^[^a-z]*$",v_scientificname)) %>% 
filter(!grepl(":",v_scientificname)) %>%
filter(!grepl("-",v_scientificname)) %>%
filter(!grepl("[*]",v_scientificname)) %>%
filter(grepl("[^ ]{4} [^ ]{4}",v_scientificname)) %>% # two words
filter(!grepl("SP.",v_scientificname)) %>% # two words
collect() %>% 
mutate(first_capped = substr(v_scientificname,1,1) %>% toupper()) %>% 
mutate(rest = substr(v_scientificname,2,nchar(v_scientificname)) %>% tolower()) %>% 
mutate(nc_v_scientificname = paste0(first_capped,rest)) %>%
mutate(verbatim_index = row_number()) %>%
glimpse() 

if(FALSE) {

not_capped_df = d %>%
mutate(name=nc_v_scientificname) %>%
name_backbone_checklist() %>%
select(
verbatim_index,
nc_verbatim_name = verbatim_name,
nc_matchType = matchType,
nc_kingdom = kingdom,
nc_rank = rank
) %>% 
glimpse() %>% 
saveRDS("data/not_capped_df.rda") 

capped_df = d %>%
mutate(name=v_scientificname) %>%
name_backbone_checklist() %>%
select(
verbatim_index,
c_verbatim_name = verbatim_name,
c_matchType = matchType,
c_kingdom = kingdom,
c_rank = rank
) %>% 
glimpse() %>%
saveRDS("data/capped_df.rda") 
}

not_capped_df = readRDS("data/not_capped_df.rda") 
capped_df = readRDS("data/capped_df.rda") 

df_merged = merge(capped_df,not_capped_df,id="verbatim_index") %>% 
merge(d,id="verbatim_index") %>% 
mutate(datasetkey = stringr::str_split(datasetkeys,";")) %>%
tidyr::unnest(cols=datasetkey) %>%
filter(c_matchType == "HIGHERRANK", nc_matchType == "EXACT") %>%
filter(nc_rank %in% c("SPECIES","VARIETY","SUBSPECIES")) 

df_merged %>% 
sample_n(20) %>%
select(v_scientificname,nc_v_scientificname) %>%
mutate(no_match_link=paste0("[link](https://api.gbif.org/v1/species/match?name=",v_scientificname,")") %>% gsub(" ","%20",.)) %>%
mutate(match_link=paste0("[link](https://api.gbif.org/v1/species/match?name=",nc_v_scientificname,")") %>% gsub(" ","%20",.)) %>%
glimpse() %>%
knitr::kable() 

# dataset table 
# df_merged %>% 
# group_by(datasetkey) %>% 
# summarise(n_names=n_distinct(v_scientificname),n_occ=sum(n_occ)) %>%
# arrange(-n_names) %>% 
# head(50) %>%
# gbifapi::addDatasetTitle(datasetkey) %>%
# gbifapi::addPublishingOrganization(datasetkey) %>% 
# mutate(link = paste0("[link](https://www.gbif.org/dataset/",datasetkey,")")) %>%
# select(datasettitle,publishingOrganizationTitle,n_names,n_occ,link) %>%
# knitr::kable() 

# glimpse()

# filter(datasetkey %in% bioversity) %>%
# filter(c_kingdom %in% c("Plantae","Animalia","Fungi")) %>% 
# filter(!grepl("-",c_verbatim_name)) %>% 
# filter(!grepl("_",c_verbatim_name)) %>% 
# select(nc_verbatim_name) %>% 
# unique() %>%
# readr::write_tsv("C:/Users/ftw712/Desktop/bioversity_uncapped_names.tsv") 



# df_merged %>% glimpse()

# %>% 
# sample_n(500) %>% 
# print(n=500)

# select(v_scientificname) %>%

