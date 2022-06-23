

library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

black_list = c("larva","s\\. str\\.","larvae","unk\\.","Phylum","undifferentiated","BOLD","gen.","Mystery mystery","Sonus naturalis","gen.","sp.","SDJB","\\ssp","VOB","indet","uncultured ",  "environmental sample","INCERTAE","Unplaced","Unknown","undet.","Unidentified")

d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(grepl("^[a-z]",v_scientificname)) %>% 
collect() %>% 
glimpse() %>%
mutate(name_in_blacklist = grepl(paste(black_list, collapse="|"),v_scientificname)) %>%
mutate(name_two_words = grepl("[^ ] [^ ]",v_scientificname)) %>% 
mutate(first_capped = paste0(toupper(substr(v_scientificname,1,1)))) %>% 
mutate(rest = substr(v_scientificname,2,nchar(v_scientificname))) %>% 
mutate(capped_v_scientificname = paste0(first_capped,rest)) %>%
filter(!name_in_blacklist) %>% 
filter(name_two_words) %>% 
select(
v_scientificname,
capped_v_scientificname,
kingdom=v_kingdom,
phylum=v_phylum,
class=v_class,
order=v_order,
family=v_family,
genus=v_genus,
n_occ,
datasetkeys
) %>%
mutate(verbatim_index = row_number()) %>%
glimpse() 

if(FALSE) {
not_capped_df = d %>%
mutate(name=v_scientificname) %>%
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
mutate(name=capped_v_scientificname) %>%
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
mutate(datasetkey = stringr::str_split(datasetkeys,";")) 

# prepare names for reflora 
# exclude_keys = c(rgbif::network_constituents("4b0d8edb-7504-42c4-9349-63e86c01bf97")$datasetKey,"13b70480-bd69-11dd-b15f-b8a03c50a862")
bioversity = c("85818aea-f762-11e1-a439-00145eb45e9a","96867b98-f762-11e1-a439-00145eb45e9a")


# prepare AntWeb names
df_merged %>% 
tidyr::unnest(cols=datasetkey) %>%
filter(datasetkey %in% bioversity) %>%
filter(nc_matchType == "HIGHERRANK", c_matchType == "EXACT") %>%
filter(c_kingdom %in% c("Plantae","Animalia","Fungi")) %>% 
filter(c_rank %in% c("SPECIES","VARIETY","SUBSPECIES")) %>%
filter(!grepl("-",c_verbatim_name)) %>% 
filter(!grepl("_",c_verbatim_name)) %>% 
select(nc_verbatim_name) %>% 
unique() %>%
readr::write_tsv("C:/Users/ftw712/Desktop/bioversity_uncapped_names.tsv") 

# print(n=100)

# %>%
# group_by(datasetkey) %>% 
# summarise(n_names=n_distinct(v_scientificname),n_occ=sum(n_occ)) %>%
# arrange(-n_names) %>% 
# head(50) %>%
# gbifapi::addDatasetTitle(datasetkey) %>%
# gbifapi::addPublishingOrganization(datasetkey) %>% 
# mutate(link = paste0("[link](https://www.gbif.org/dataset/",datasetkey,")")) %>%
# select(datasettitle,publishingOrganizationTitle,n_names,n_occ,link) %>%
# knitr::kable() 


# count() %>%
# glimpse() 
# unique() %>%
# glimpse() %>% 
# readr::write_tsv("C:/Users/ftw712/Desktop/reflora_uncapped_names.tsv") 



# readr::write_tsv("C:/Users/ftw712/Desktop/antweb_uncapped_names.tsv") 


# glimpse() %>% 
# group_by(c_rank) %>%
# count()


# select(datasetkey,n_occ,v_scientificname) %>% 
# unique() %>%
# group_by(datasetkey) %>% 
# summarise(n_names=n_distinct(v_scientificname),n_occ=sum(n_occ)) %>%
# arrange(-n_names) %>% 
# head(50) %>%
# gbifapi::addDatasetTitle(datasetkey) %>%
# mutate(link = paste0("[link](https://www.gbif.org/dataset/",datasetkey,")")) %>%
# select(datasettitle,n_names,n_occ,link) %>%
# knitr::kable()






# df_merged %>%
# glimpse() %>%
# group_by(nc_matchType,c_matchType) %>%
# summarise(name_count=n(),occ_count=sum(n_occ))  


# df_merged %>% 
# filter(nc_matchType == "HIGHERRANK", c_matchType == "EXACT") %>%
# sample_n(100) %>%
# select(v_scientificname,capped_v_scientificname) %>%
# mutate(link=paste0("[link](https://api.gbif.org/v1/species/match?name=",v_scientificname,")")) %>%
# mutate(link=gsub(" ","%20",link)) %>%
# glimpse() %>% 
# select(v_scientificname,link) %>%
# readr::write_tsv("C:/Users/ftw712/Desktop/examples.tsv")

# df_merged %>% 
# filter(nc_matchType == "HIGHERRANK", c_matchType == "EXACT") %>%
# glimpse()

# df_merged %>% 
# filter(nc_matchType == "EXACT", c_matchType == "HIGHERRANK") %>%
# pull(nc_verbatim_name)
 
 
# Capitalizing the first letter in a name leads to 25K more unique name strings matching the the backbone 

 
# | no cap first letter | cap first letter | unique name count      |  interpretation  |
# | ------------------  | ---------------  |  --------------------- |  --------------- |
# | **HIGHERRANK**      | **EXACT**        | **25115**              | 25K names moved to exact match from higherrank with capitilization of first letter in name |
# | HIGHERRANK          | FUZZY            | 5041                   | 5K names moved to exact match from higher rank with capitilization of first letter in name |
# | HIGHERRANK   		  | HIGHERRANK       | 68150                  | makes no difference  |
# | EXACT               | EXACT            | 3230                   | makes no difference  |
# | HIGHERRANK          | NONE             | 136                    | 
# | **EXACT**           | **HIGHERRANK**   | **7**               | 7 names moved to higherrank from exact with capitilization of first letter in name |   
# | NONE                | HIGHERRANK       | 7                      |  
# | NONE                | EXACT            | 1                      |
# | NONE                | FUZZY            | 3                      |
# | FUZZY               | FUZZY            | 257                    |      
 

# Not capitalizing the first letter 

# **269924** occurrences flagged as **HIGHERRANK** get moved to **EXACT** matchType when simply capitalizing the first letter of the name. **17964** occurrences flagged as **HIGHERRANK** get moved to **FUZZY** matchType.



    # nc_matchType c_matchType name_count occ_count
   # <chr>        <chr>            <int>     <int>
 # 1 EXACT        EXACT             3230    467810
 # 2 EXACT        HIGHERRANK           7       173
 # 3 FUZZY        FUZZY              257     30868
 # 4 HIGHERRANK   EXACT            25115    269924
 # 5 HIGHERRANK   FUZZY             5041     17964
 # 6 HIGHERRANK   HIGHERRANK       68150    501257
 # 7 HIGHERRANK   NONE               136       836
 # 8 NONE         EXACT                1         1
 # 9 NONE         FUZZY                3         3
# 10 NONE         HIGHERRANK           7         8
 

# group_by(matchType) %>% 
# count()

# d %>%  
# mutate(name=capped_v_scientificname) %>%
# name_backbone_checklist() %>%
# group_by(matchType) %>% 
# count()






