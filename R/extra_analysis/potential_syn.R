
library(dplyr)
library(rgbif)
library(purrr)

set.seed(1)

d = "C:/Users/ftw712/Desktop/data-gaps-in-backbone/data/The Global Lepidoptera Names Index-potentially missing names.tsv" %>% 
readr::read_tsv() %>%
sample_n(5000) %>%
filter(rank == "sp.") %>%
mutate(verbatim_index = row_number()) 

g = d %>% 
select(name=genus,order) %>%
unique() %>%
name_backbone_checklist(verbose=TRUE) %>%
filter(order == "Lepidoptera") %>%
filter(rank == "GENUS") %>% 
mutate(syn_list = map(genusKey,~unique(name_usage(.x,data="synonyms")$data$canonicalName))) %>%
select(verbatim_index,accepted_genus=genus,acceptedUsageKey,canonicalName,syn_list) %>%
glimpse() 

merge(d,g,id="verbatim_index",all.x=TRUE) %>% 
mutate(likely_syn = !is.na(acceptedUsageKey)) %>% 
mutate(accepted_combo = paste(accepted_genus,specificepithet)) %>%
mutate(accepted_combo_in_backbone = accepted_combo %>% map_dbl(~name_backbone(.x,order="Lepidoptera") %>% filter(matchType=="EXACT") %>% nrow())) %>%
filter(likely_syn) %>% 
glimpse() 


# filter(accepted_combo_in_backbone > 0) %>% 
# tidyr::unnest(cols="syn_list") %>% 
# mutate(syn_combo = paste(syn_list,specificepithet)) %>%
# mutate(syn_combo_in_backbone = syn_combo %>% map_dbl(~name_backbone(.x,order="Lepidoptera",verbose=TRUE) %>% filter(matchType=="EXACT") %>% nrow())) %>%

# %>%
# pull(in_backbone) %>%
# map(~ .x$matchType) 

# filter(likely_syn) 


# filter(!is.na(syn_list)) %>% 

# %>% 
# filter(in_backbone == 1) %>% 
# glimpse() 

# mutate(x = ifelse(is.null(syn_list),NA,syn_list)) %>% 
# mutate(=ifelse(!is.na(syn_list),map(syn_list,~unique(.x$genus),NA))) %>%


# g %>% select(stsyn_list)


# select(status == "SYNONYM") %>%
# genusKey

# filter(status == "SYNONYM") %>% 
# filter(!is.na(acceptedUsageKey)) %>% 
# select(accepted_genus,acceptedUsageKey,verbatim_index) %>% 
# glimpse()

# merge(d,ag,id="verbatim_index",all.x=TRUE) %>% 
# mutate(likely_syn = !is.na(accepted_genus)) %>% 
# mutate(syn_genera = map(acceptedUsageKey, ~ ifelse(is.na(.x),"",name_usage(.x,data="synonyms")$data$genus))) %>% 

# glimpse() %>% 
# pull(syn_genera) %>% 
# map(~ length(.x))
# mutate(potential = map(acceptedUsageKey, ~ ifelse(is.na(.x),"",name_usage(.x,data="synonyms")$data$genus))) %>% 

# mutate(accepted_genus = ifelse(is.na(accepted_genus),genus,accepted_genus)) %>% 
# mutate(accepted_combination = paste(accepted_genus,specificepithet)) %>% 

# mutate(accepted_genusKey = accepted_genus %>% map_dbl(~name_backbone(.x,order="Lepidoptera")$genusKey)) %>%

# mutate(in_backbone = potential_combination %>% map_dbl(~name_backbone(.x,order="Lepidoptera") %>% filter(matchType == "EXACT") %>% nrow())) %>%
# mutate(potential_combination_in_backbone = in_backbone==1) %>%
# arrange(accepted_genus,specificepithet) %>% 
# select(accepted_genus,likely_syn,canonicalname,potential_combination,potential_combination_in_backbone,everything()) %>%  
# unique() %>%
# select(-verbatim_index,-in_backbone) %>% 
# glimpse() %>%
# openxlsx::write.xlsx("C:/Users/ftw712/Desktop/export.xlxs",overwrite = TRUE)




# mutate(n_row = map_dbl(syn,~nrow(.x))) %>%
# arrange(-n_row) %>% 
# arrange(acceptedUsageKey) %>%
# tidyr::unnest(cols="syn") %>% 
# as.data.frame() %>%
# head()



# %>% 
# mutate(specificepithet = map_chr(canonicalname,~name_parse(.x) %>% pull(specificepithet))) %>% 
# glimpse()

# d %>% 
# filter(specificepithet == "japonica") %>% 
# group_by(genus,specificepithet) %>% 
# count() %>%
# arrange(-n) %>%
# as.data.frame()

# d_syn = d_org %>% 
# select(canonicalname,name=genus,order) %>%
# name_backbone_checklist(verbose=TRUE) %>%
# filter(order == "Lepidoptera") %>%
# filter(status == "SYNONYM") %>% 
# filter(rank == "GENUS") %>% 
# mutate(syn = map(acceptedUsageKey,~name_usage(.x,data="synonyms")$data %>% rename_all(paste0,"_syn"))) %>%
# tidyr::unnest(cols="syn") %>% 
# glimpse() 


# d_org %>% 
# select(source_canonicalname=canonicalname,source_genus=genus,source_specificepithet=specificepithet,verbatim_index) %>% 
# merge(d_syn,id="verbatim_index") %>% 
# mutate(new_combo = paste(canonicalName_syn,source_specificepithet)) %>%
# select(source_canonicalname,new_combo) %>%
# pull(new_combo) %>% 
# name_backbone_checklist(verbose=TRUE) %>%
# filter(order == "Lepidoptera") %>%
# filter(matchType == "EXACT") %>% 
# glimpse() 

# %>%
# group_by(matchType) %>% 
# count() %>% 
# arrange(-n) 








# %>%
# saveRDS("C:/Users/ftw712/Desktop/d.rda")

# readRDS("C:/Users/ftw712/Desktop/d.rda")
# name_usage



# glimpse() %>%
# na.omit() %>%
# mutate(genus_is_syn = map_lgl(genus,~is_syn(.x))) %>% 
# glimpse() %>% 
# filter(genus_is_syn) %>%
# head(2) %>% 


# mutate(nb=map(genus,~ name_backbone(.x) %>% rename_all(paste0,"_nb"))) %>%
# tidyr::unnest(cols="nb") %>% 


# slice(2) %>%  

# Pterichis translucida
# Faustula delia
# accepted
# Spirorbula marmorata
# name_lookup(query="Pseudomaenas",status="SYNONYM",rank="GENUS")$data %>% glimpse() 

# rgbif::name_lookup("Callistege")$data %>% glimpse()
# SYNONYM

# pp = d %>% 
# pull(canonicalname) %>%
# rgbif::name_parse() %>%
# rename_all(paste0,"_parsed") %>% 
# cbind(d) %>% 
# mutate(genus_equal = genusorabove_parsed == genus) %>%
# glimpse() %>% 
# saveRDS("C:/Users/ftw712/Desktop/p.rda")

# pp = readRDS("C:/Users/ftw712/Desktop/p.rda")
# pp %>% filter(!genus_equal)

# pp = d %>% 
# rgbif::name_parse() %>%

# d %>% pull(genus) %>% unique()













