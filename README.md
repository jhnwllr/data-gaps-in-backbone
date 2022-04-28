## Finding data gaps in the GBIF backbone. 

This a companion for this [blog post](https://data-blog.gbif.org/post/2022-03-24-reasons-why-names-don-t-match-to-the-gbif-backbone/).

You need to have permission on GBIF servers to run.

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

