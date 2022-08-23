
# function to filter v_scientificname from gbif to give back potentially missing names 


filter_names_fun = function(d) { # a data.frame with a v_scientificname column

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

d = d %>% 
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
filter(!stringr::str_count(v_scientificname, ",") > 2) 

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
filter(across(any_of("notho_parsed"), ~is.na(.x))) %>%
mutate(verbatim_index = row_number()) 

return(pp)
}

