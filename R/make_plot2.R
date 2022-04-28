# make plot 2
# make the 2nd plot looking at beetles closer

library(dplyr)

# setwd("C:/Users/ftw712/Desktop/Beetles/")

d = readr::read_tsv("data/df_filter.tsv") %>%
filter(order_ == "Coleoptera") %>%
group_by(family) %>%
mutate(total_n=n()) %>%
ungroup() %>%
filter(total_n > 1000) %>%
group_by(family,reason) %>%
mutate(reason_n=n()) %>%
mutate(percent = (reason_n/total_n)*100) %>% 
select(reason,family,total_n,reason_n,percent) %>% 
ungroup() %>% 
na.omit() %>% 
unique() 

fct_lev_group = d %>% 
filter(reason == "other") %>%
select(family,total_n) %>% 
arrange(total_n) %>% 
glimpse() %>%
pull(family) %>% 
unique() %>% 
na.omit()

# fct_lev_reason = c("below_species","too_many_choices","bad_name","hybrid","other")
fct_lev_reason = c("below_species","too_many_choices","hybrid","bad_name","other")

d = d %>%
tidyr::gather("key","value",-"reason",-"family",-"total_n") %>%
glimpse() 

fct_lev_group

pd = d %>%
mutate(family = forcats::fct_relevel(family,fct_lev_group)) %>%
mutate(reason = forcats::fct_relevel(reason,fct_lev_reason)) %>%
mutate(key = recode(key, reason_n = "Total Name Count", percent = "Percent")) %>%
glimpse()

library(ggplot2) 

p = ggplot(pd,aes(family,value)) +
geom_bar(position="stack",stat="identity",aes(fill=reason)) +
coord_flip() +
theme_bw() + 
facet_wrap(~key,scales="free_x") +
xlab("") +
ylab("") +
theme(legend.position="top") +
theme(strip.background =element_rect(fill="white")) +
theme(legend.title = element_blank()) +
theme(axis.title.x = element_text(margin = margin(t = 8, r = 0, b = 5, l = 0), size = 11, face="plain")) +
scale_fill_manual(
labels = c("below_species" = "below species", "too_many_choices"="too many choices","bad_name"="unmatchable name","other"="other (possibly missing)"),
values = c(
"below_species"="#40BFFF",
"too_many_choices" ="#26e3d3",
"hybrid" = "#fcc200",
"bad_name" = "#ff7373",
"other" = "#e32636"
)) + 
guides(fill=guide_legend(reverse=TRUE))

save_dir = "plots/"
gbifapi::save_ggplot_formats(p,save_dir,"reason_buckets_coleoptera",height=8.5,width=8.5,formats=c("pdf","jpg","svg"))

quit(save="no")






