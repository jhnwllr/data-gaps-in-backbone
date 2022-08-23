## Finding data gaps in the GBIF backbone. 

This a companion for this [blog post](https://data-blog.gbif.org/post/2022-03-24-reasons-why-names-don-t-match-to-the-gbif-backbone/).

You need to have permission on GBIF servers to run.

## Filter summary 

This project is essential a series of filters to get to  classical binomial names. Some choices were made in order to limit the number of names that are run through the name matcher. Here is a summary of the most important filters used. 
The target of the filters is to produce plausible looking names that can be reviewed by experts or used in statistics about backbone progress. 

* Get only v_scientificname that start with two words. Capitalized first letter first word and lowercase first letter second word. "Genus species", "Dog dog", "Fake species" regex: "^[A-Z][^ ]+[[:space:]][a-z][^ ]+"
* No v_scientificname that is all caps. ALL CAPS does not work in the GBIF name matcher. regex : "^[^a-z]*$"
* Remove v_scientificnames with special character v_scientificname. Symbols indicative of ids or hybrids.  regex : "[_#?:+*-]" 
* Filter "word (word) word" pattern in v_scientificname. I might want to remove this filter since I was told it is handled by the name parser. regex: "^[^ ]+[[:space:]][(][A-Za-z]+[)][[:space:]][A-Za-z]+" 
* Filter v_scientificname for only numbers that are years. regex : "\\d{4}" 
* Filter any "Sp. Gen. Hal." patterns at start of v_scientificname. regex :  "^[A-Za-z]+\\."  
* Filter v_scientificname for anything in the blacklist
* Only consider "Plantae", "Animalia", "Fungi". Don't consider bacteria ect...
* Some publishers have long lists of names that look ok at the beginning but are just a collapsed lists. Filter any v_scientificname over 100 characters or with more than two commas. 
* Remove names that might not match due to "too many choices"
* Only keep type_parsed = "SCIENTIFIC" from the name parser
* Only keep rank "sp.","infrasp." from name parser 

## Installation

```r
install.packages("tidyverse") # might need more
devtools::install_github("jhnwllr/gbifapi")
```

## Run

```
cd data-gaps-in-backbone
bash run.sh
```

## Output

* table of candidate missing names `data/possibly_missing_table.tsv`
* A few plots

![](https://raw.githubusercontent.com/jhnwllr/data-gaps-in-backbone/main/plots/reason_buckets.svg)

