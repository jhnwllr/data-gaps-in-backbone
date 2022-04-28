library(dplyr)
library(rgbif)
library(purrr)
library(stringdist)

focal_groups =
c(
"Carditida",
"Coleoptera",
"Lepidoptera",
"Araneae",
"Cyatheales",
"Passeriformes",
"Asterales",
"Odonata",
"Primates",
"Percopsiformes",
"Fabales",
"Agaricales",
"Carnivora",
"Chiroptera",
"Rodentia",
"Anura",
"Neuroptera"
)

black_list = c("larva","s\\. str\\.","larvae","unk\\.","Phylum","undifferentiated","BOLD","gen.","Mystery mystery","Sonus naturalis","gen.","sp.","SDJB","\\ssp","VOB","indet","uncultured ",  "environmental sample","INCERTAE","Unplaced","Unknown","undet.","Unidentified")

focal_groups %>%
map(~{
p = arrow::open_dataset("data/wanted_names_unfiltered.parquet") %>% 
filter(order_ == .x) %>%
collect() 

parsed = p %>% 
pull(v_scientificname) %>%
parsenames() %>% 
select(-scientificname) %>%
cbind(p) 
df_filter = parsed %>% 
mutate(name_matches_above_sp_rank = taxonrank %in% c("ORDER","GENUS","FAMILY")) %>%
mutate(name_in_blacklist = grepl(paste(black_list, collapse="|"),v_scientificname)) %>%
mutate(name_was_parsed = parsed) %>% 
mutate(name_has_epithet = !is.na(specificepithet)) %>% 
mutate(name_two_words = grepl("[^ ] [^ ]",v_scientificname)) %>% 
mutate(name_has_para_in_middle = grepl("[^ ]+ [(][^ ]+[)] [^ ]+",v_scientificname,perl=TRUE)) %>% 
mutate(name_has_letterdot = grepl("^[^ ]\\. ",v_scientificname,perl=TRUE)) %>% 
mutate(name_has_weird_dot_prefix = grepl("[A-Za-z]+\\.[A-Za-z]+ [A-Za-z]+",v_scientificname,perl=TRUE)) %>% 
mutate(name_has_para_after_name = grepl("^[^ ]+ \\([^ ]+\\)",v_scientificname,perl=TRUE)) %>%
mutate(name_has_question_mark = grepl("\\?",v_scientificname,perl=TRUE)) %>%
mutate(name_has_letter_dot = grepl("[A-Z]\\.",v_scientificname,perl=TRUE)) %>%
mutate(name_has_uppercase = grepl("^[[:upper:]]+$",v_scientificname,perl=TRUE)) %>%
mutate(name_has_na = is.na(v_scientificname)) %>%
mutate(name_is_hybrid = type == "HYBRID") %>% 
mutate(name_is_bad = 
name_has_na |
name_in_blacklist |
!name_two_words |
!name_was_parsed | 
name_has_weird_dot_prefix |
name_has_para_after_name |
name_has_question_mark |
name_has_letter_dot |    
name_has_uppercase
) %>% 
mutate(has_suggestions = map_lgl(canonicalnamecomplete,~ nrow(name_suggest(.x,limit=2)$data) > 1)) %>%
mutate(reason = case_when(
!name_matches_above_sp_rank ~ "below_species",
has_suggestions & !name_is_bad & !name_is_hybrid ~ "too_many_choices",
name_is_hybrid ~ "hybrid",
name_is_bad & !name_is_hybrid~ "bad_name",
TRUE ~ "other"
)) %>%
glimpse()
readr::write_delim(df_filter,
  "name_log.txt",
  delim = "\t",
  na = "NA",
  append = TRUE,
  quote = c("none"))

df_filter
}) %>%
bind_rows() %>%
glimpse() %>%
readr::write_tsv("data/df_filter.tsv")

quit(save="no")


