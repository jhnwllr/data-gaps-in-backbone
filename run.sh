#!/bin/bash
eval `ssh-agent -s`
ssh-add
# scp -r scala/wanted_names.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i wanted_names.scala"
# ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < shell/export_parquet.sh

# download and unzip 
# rm -r data/wanted_names_unfiltered.parquet.zip
# wget -O data/wanted_names_unfiltered.parquet.zip http://download.gbif.org/custom_download/jwaller/wanted_names_unfiltered.parquet.zip
# rm -r data/wanted_names_unfiltered.parquet
# unzip data/wanted_names_unfiltered.parquet.zip -d data/wanted_names_unfiltered.parquet
# rm -r data/wanted_names_unfiltered.parquet.zip

# # download current backbone
# wget -O data/backbone.zip https://hosted-datasets.gbif.org/datasets/backbone/current/backbone.zip
# rm -r data/Taxon.tsv
# unzip -p data/backbone.zip backbone/Taxon.tsv > data/Taxon.tsv
# rm -r data/backbone.zip

# Final analysis in R
# Rscript.exe --vanilla R/filter_names.R 
Rscript.exe --vanilla R/make_plot.R
Rscript.exe --vanilla R/make_plot2.R
Rscript.exe --vanilla R/possibly_missing_table.R

