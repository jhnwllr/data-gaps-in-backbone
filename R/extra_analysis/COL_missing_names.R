# Missing names for COL checklists 
setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

source("R/filter_names_fun.R")
library(rgbif)
library(dplyr)
library(purrr)

col_name_list = function(col_source,rank,limit) {

col_source %>% 
pull(key) %>% 
map(~
paste0("https://api.checklistbank.org/dataset/9820/nameusage/search?SECTOR_DATASET_KEY=",
.x,
"&rank=",rank,"&limit=",limit) %>%
jsonlite::fromJSON(flatten = TRUE) %>% 
pluck("result") 
) %>%
compact() %>%
bind_rows() %>% 
select(key=sectorDatasetKey,group=usage.label) 
}

col_source = "https://api.checklistbank.org/dataset/9820/source" %>% 
httr::GET() %>%
httr::content() %>%
map(~ tibble(key = .x$key, title=.x$title, alias = .x$alias)) %>%
bind_rows() %>% 
glimpse() 

col_list = col_name_list(col_source,"family",500) %>%
merge(col_source,id="key") %>% 
group_by(key) %>% 
mutate(count=n()) %>% 
filter(count < 500) %>%
ungroup() %>% 
filter(key == 1146) 

group_list = col_list %>% 
pull(group) %>%
rgbif::name_backbone_checklist() %>%
glimpse()

if(length(unique(group_list$order)) > 1) stop("bad families")

focal_group = group_list$family
focal_column = "family"
dataset_title = unique(col_list$title)

dataset_title


d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(family %in% focal_group) %>%
collect() %>% 
glimpse()

pp = filter_names_fun(d) %>%
glimpse()

# prepare for export 

if(nrow(pp) > 500) print(pp %>% sample_n(500) %>% select(v_scientificname) %>% as.data.frame())
if(nrow(pp) < 500) print(pp %>% select(v_scientificname) %>% as.data.frame())

pp %>% 
select(
v_scientificname,
canonicalname_parsed,
rankmarker_parsed,
kingdom,
phylum,
class,
order = order_,
family,
genusorabove_parsed,
) %>%
unique() %>%
group_by(
canonicalname_parsed,
rankmarker_parsed,
kingdom,
phylum,
class,
order,
family,
genusorabove_parsed
) %>% 
summarise(scientificname_variants=paste(v_scientificname, collapse = ';'),n=n()) %>%
ungroup() %>% 
select(
canonicalname = canonicalname_parsed,
scientificname_variants,
rank = rankmarker_parsed,
genus = genusorabove_parsed,
family,
order,
class,
phylum,
kingdom
) %>%
arrange(canonicalname,family) %>% 
glimpse() %>%
readr::write_tsv(paste0("data/",dataset_title,"-potentially missing names.tsv"))

quit(save="no")

# if(FALSE) {
# }
