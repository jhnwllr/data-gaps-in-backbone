syn_check_fun = function(pp) {

gg = pp %>% 
filter(!taxonkey == acceptednameusageid) %>%
filter(rankmarker_parsed == "sp.") %>% 
filter(!is.na(genus)) %>% 
mutate(potential_combo = paste(genus,specificepithet_parsed)) 

bb = gg %>%
select(name=potential_combo,order=order_,canonicalname_parsed) %>%
name_backbone_checklist() %>%
filter(matchType == "EXACT") %>%
filter(rank == "SPECIES") %>%
mutate(combo_in_backbone = TRUE) %>% 
select(verbatim_index,combo_in_backbone)  

ee = merge(gg,bb,id="verbatim_index",all.x=TRUE) %>%
select(verbatim_index,potential_combo,combo_in_backbone) %>% 
unique() 

eee = merge(pp,ee,all.x=TRUE,id="verbatim_index")
eee
}
