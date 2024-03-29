
# Export a list of probably missing names in GBIF 

library(dplyr)
library(purrr)
library(rgbif)

setwd("C:/Users/ftw712/Desktop/data-gaps-in-backbone/")

black_list = 
c("larva",
"larvae",
"juv\\.",
"Pupa",
"unk\\.",
"Phylum",	
"undifferentiated",
"BOLD",
"gen\\.",
"cfr\\.",
"Mystery mystery",
"Sonus naturalis",
"sp\\.",
" sp",
"var\\.",
"\\ssp\\.",
"nr\\.",
"prox\\.",
"SDJB",
"VOB",
"indet",
"uncultured ",
"environmental sample",
"INCERTAE",
"Unplaced",
"Unknown",
"unknown",
"undet.",
"Unidentified",
"hybrid",
"Cape Fear R\\.",
"subsection",
" or ",
"Hi from Henrik!",
" / ", # no hybrids 
"/", # no hybrids 
" x ", # no hybrids
" s\\.s\\. ", 
"var\\.", # no varieties
"Genus"
)

focal_group = "Bryophyta"
# focal_group = "Ologamasidae"
# focal_group = "Chiroptera"
# focal_group = "Lepidoptera"
# focal_group = "Odonata"

# focal_column = "order_"

if(TRUE) {
# filter(order_ == focal_group) %>%
# filter(family == focal_group) %>%
d = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(phylum == focal_group) %>%
filter(grepl("^[A-Z][^ ]+[[:space:]][a-z][^ ]+",v_scientificname)) %>%
filter(!grepl("^[^a-z]*$",v_scientificname)) %>% # not all caps
filter(!grepl("[_#?:+*-]",v_scientificname)) %>% # symbols indicative of ids or hybrids
filter(!grepl("^[^ ]+[[:space:]][(][A-Za-z]+[)][[:space:]][A-Za-z]+",v_scientificname)) %>% # avoid word (word) word pattern
filter(!grepl("\\d",v_scientificname) | grepl("\\d{4}",v_scientificname)) %>% # only year numbers
filter(!grepl("^[A-Za-z]+\\.",v_scientificname)) %>% # Sp. Gen. Hal. pattern at start
collect() %>%
filter(!grepl(paste(black_list, collapse="|"),v_scientificname)) %>% # no blacklist 
filter(kingdom %in% c("Plantae","Animalia","Fungi")) %>% # don't consider bacteria ect...
filter(nchar(v_scientificname) < 100) %>% # avoid long lists
filter(!stringr::str_count(v_scientificname, ",") > 2) %>% 
glimpse() 

pp = d %>% 
pull(v_scientificname) %>%
rgbif::name_parse() %>%
rename_all(paste0,"_parsed") %>% 
cbind(d) %>% 
filter(!map_lgl(canonicalnamecomplete_parsed,~ nrow(name_suggest(.x,limit=2)$data) > 1)) %>% # no too many choices 
filter(type_parsed == "SCIENTIFIC") %>% # only keep Scientific for giving to checklist publishers
filter(!parsedpartially_parsed) %>% # none of this please
filter(rankmarker_parsed %in% c("sp.","infrasp.")) %>% 
filter(across(any_of("sensu_parsed"), ~is.na(.x))) %>% # none of this please
filter(across(any_of("nomstatus_parsed"), ~is.na(.x))) %>% # none of this please
filter(across(any_of("notho_parsed"), ~is.na(.x))) %>% # none of this please
glimpse() %>% 
saveRDS(paste0("data/",focal_group,"_parsed.rda"))

}

pp = readRDS(paste0("data/",focal_group,"_parsed.rda")) %>% glimpse()

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
readr::write_tsv(paste0("data/",focal_group,"_missing_names.tsv"))

quit(save="no")



