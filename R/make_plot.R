# make plot

library(dplyr)

# setwd("C:/Users/ftw712/Desktop/Beetles/")

d = readr::read_tsv("data/df_filter.tsv") %>%
group_by(order_) %>%
mutate(total_n=n()) %>%
ungroup() %>%
group_by(order_,reason) %>%
mutate(reason_n=n()) %>%
mutate(percent = (reason_n/total_n)*100) %>% 
select(reason,order_,total_n,reason_n,percent) %>% 
ungroup() %>% 
unique() 

fct_lev_group = d %>% 
filter(reason == "other") %>%
select(order_,total_n) %>% 
arrange(total_n) %>% 
glimpse() %>%
pull(order_) %>% 
unique()

fct_lev_reason = c("below_species","too_many_choices","hybrid","bad_name","other")

d = d %>%
tidyr::gather("key","value",-"reason",-"order_",-"total_n") %>%
glimpse() 

pd = d %>%
mutate(order_ = forcats::fct_relevel(order_,fct_lev_group)) %>%
mutate(reason = forcats::fct_relevel(reason,fct_lev_reason)) %>%
mutate(key = recode(key, reason_n = "Total Name Count", percent = "Percent")) %>%
glimpse()

library(ggplot2) 

p = ggplot(pd,aes(order_,value)) +
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
gbifapi::save_ggplot_formats(p,save_dir,"reason_buckets",height=8.5,width=8.5,formats=c("pdf","jpg","svg"))

quit(save="no")



if(FALSE) { 

pd = name_df %>%
mutate(reason = forcats::fct_reorder(reason, )) %>%
group_by(name_source,genus) %>% 
count() %>% 
group_by(genus) %>% 
mutate(total_count=sum(n)) %>%
ungroup() %>% 
filter(total_count > 250) %>% 
mutate(genus = forcats::fct_reorder(genus, total_count)) %>%
mutate(name_source = as.factor(name_source)) %>%
mutate(name_source = forcats::fct_relevel(name_source,fct_lev)) %>%
glimpse() 

breaks = scales::pretty_breaks(n = 7)(c(0,12e3))
labels = gbifapi::plot_label_maker(breaks,unit_MK = "K",unit_scale = 1e-3)

readr::write_tsv(pd,"C:/Users/ftw712/Desktop/data_legume_name_source_genus.tsv")

p = ggplot(pd,aes(genus,n)) +
geom_bar(position="stack",stat="identity",aes(fill=name_source)) +

p = ggplot(pd,aes(genus,n)) +
geom_bar(position="stack",stat="identity",aes(fill=name_source)) +
coord_flip() +
theme_bw() +
scale_y_continuous(expand=c(0.01,0.1)) +
xlab("") +
ylab("") +
theme(axis.title.x = element_text(margin = margin(t = 8, r = 0, b = 5, l = 0), size = 11, face="plain")) +
theme(axis.text.y=element_text(face="plain",size=10,color="#535362")) +
theme(plot.margin = unit(c(0.2,0.5,0.1,0.1), "cm")) +
theme(plot.title = element_text(family = "sans", size = 12, margin=unit(c(0.2,0.5,0.3,0.1), "cm"))) + 
theme(legend.title = element_blank()) +
theme(
legend.position="top", 
legend.justification="left",
legend.direction="horizontal") +
labs(
title = "Legume (Fabaceae) names in <b>GBIF Backbone<b>",
caption = 
"The World Checklist of Vascular Plants (<b>WCVP</b>): Fabaceae<br><b>Old names</b> come from the 2021-09-14 backbone<br> <b>New names</b> come from the 2021-12-03 backbone<br>Only Genera with greater than 250 total names shown<br>") +
theme(
plot.title = element_textbox_simple(
size = 16,
lineheight = 1,
padding = margin(1, 1, 5, 1),
margin = margin(1, 1, 2, -5),
fill = "#ffffff",
hjust = 1
),
plot.caption.position = "plot",
plot.caption = element_textbox_simple(
size = 8,
lineheight = 1,
padding = margin(1, 1, 1, 1),
margin = margin(0, 4, 6, 230),
fill = "#ffffff",
hjust = 1
)) + 
guides(fill = guide_legend(reverse = TRUE)) + 
scale_fill_manual(
values = c("#6885C0","#BCC7DE","#E37C72","#EC9F9A")
) + 
scale_y_continuous(breaks = breaks,label = labels,limits=c(0,12e3),expand=c(0.01,0.1))

save_dir = "C:/Users/ftw712/Desktop/Legume/plots/"
gbifapi::save_ggplot_formats(p,save_dir,"legume_name_source_genus",height=10.5,width=6.5,formats=c("pdf","jpg","svg"))


}








