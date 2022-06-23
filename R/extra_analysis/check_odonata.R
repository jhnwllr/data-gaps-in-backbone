library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

pp = readRDS(paste0("data/Odonata_parsed.rda")) %>% 
select(v_scientificname,canonicalname_parsed) %>%
unique() %>%
mutate(id = canonicalname_parsed) %>% 
mutate(occ_name = id) %>% 
group_by(id,occ_name) %>% 
summarise(versions = paste(v_scientificname, collapse = ';'),versions_count=n()) %>%
ungroup() %>%
select(id,occ_name,versions) %>%
glimpse() 

# arrange(-versions_count) %>%
wol = readr::read_tsv("https://raw.githubusercontent.com/jhnwllr/world-odonata-list-dwca/main/taxon.txt") %>% 
filter(taxonRank == "species") 

# %>% 
# rgbif::name_backbone_checklist() %>% 
# filter(matchType == "HIGHERRANK") 

wol

ppp = wol %>% 
pull(scientificName) %>%
rgbif::name_parse() %>%
rename_all(paste0,"_parsed") %>% 
cbind(wol) %>%
mutate(id = canonicalname_parsed) %>%
mutate(wol_name = scientificName) %>%
select(id,wol_name) %>% 
group_by(id) %>% 
summarise(wol_name = paste(wol_name, collapse = ';')) %>%
ungroup() %>% 
unique() %>% 
glimpse() 

merge(pp,ppp,id="id",all.x=TRUE) %>% 
filter(!is.na(wol_name)) %>% 
glimpse()

# 190 missing names. I estimated 300. 
