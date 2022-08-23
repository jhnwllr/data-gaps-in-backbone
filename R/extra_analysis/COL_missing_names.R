# Missing names for COL checklists 
setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

source("R/filter_names_fun.R")
source("R/syn_check_fun.R")
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

col_source %>% as.data.frame()

col_list = col_name_list(col_source,"order",500) %>%
merge(col_source,id="key") %>% 
group_by(key) %>% 
mutate(count=n()) %>% 
filter(count < 500) %>%
ungroup() %>% 
filter(key == 1018) 

group_list = col_list %>% 
pull(group) %>%
rgbif::name_backbone_checklist() %>%
glimpse()

# if(length(unique(group_list$order)) > 1) stop("bad families")

focal_group = group_list$order
focal_column = "order"
dataset_title = unique(col_list$title)

dataset_title

d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(order_ %in% focal_group) %>%
collect() %>% 
glimpse() 

pp = filter_names_fun(d) %>%
syn_check_fun() %>%
glimpse() %>%
saveRDS("C:/Users/ftw712/Desktop/pp.rda")



# dataset_title = "test"
# pp = readRDS("C:/Users/ftw712/Desktop/pp.rda")

pp %>% glimpse()

# genusorabove specificepithet

# pp %>% select(v_scientificname) %>% as.data.frame()

# prepare for export 

# if(nrow(pp) > 500) print(pp %>% sample_n(500) %>% select(v_scientificname) %>% as.data.frame())
# if(nrow(pp) < 500) print(pp %>% select(v_scientificname) %>% as.data.frame())

clean_col = function(x) paste(na.omit(unique(x)),collapse=";")

# mutate(is_likely_syn = !is.na(potential_combo)) %>%
pp %>% 
filter(rankmarker_parsed == "sp.") %>%
mutate(genus_species = paste(genusorabove_parsed,specificepithet_parsed)) %>%
filter(is.na(potential_combo)) %>% # filter to syns
select(
canonicalname=genus_species,
v_scientificname,
v_specificepithet=specificepithet_parsed,
v_genus=genusorabove_parsed,
accepted_genus=genus,
kingdom,
phylum,
class,
order=order_,
family,
n_occ, 
n_dataset,
n_publisher
) %>%
unique() %>%
glimpse() %>%
group_by(
canonicalname,
kingdom,
phylum,
class,
order,
family
) %>% 
summarise(
v_genus = clean_col(v_genus),
accepted_genus = clean_col(accepted_genus),
scientificname_variants=clean_col(v_scientificname),
n_occ = sum(n_occ), 
n_dataset = sum(n_dataset),
n_publisher = sum(n_publisher)
) %>%
ungroup() %>% 
unique() %>% 
select(accepted_genus,v_genus,canonicalname,everything()) %>%
glimpse() %>%
openxlsx::write.xlsx(paste0("data/",dataset_title,"-potentially missing names.xlsx"),na.string="",keepNA = TRUE,overwrite = TRUE)



# select(
# canonicalname = canonicalname_parsed,
# scientificname_variants,
# specificepithet = specificepithet_parsed,
# rank = rankmarker_parsed,
# genus = genusorabove_parsed,
# family,
# order,
# class,
# phylum,
# kingdom
# ) %>%
# arrange(canonicalname,family) %>% 
# glimpse() %>%
# readr::write_tsv(paste0("data/",dataset_title,"-potentially missing names.tsv"))

# quit(save="no")

if(FALSE) {
# if(FALSE) {
}
