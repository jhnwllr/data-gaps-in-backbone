#!/bin/bash
eval `ssh-agent -s`
ssh-add
# cd /mnt/c/Users/ftw712/Desktop/data-gaps-in-backbone/progress-table/
# ssh jwaller@c5gateway-vh.gbif.org
# cd /mnt/auto/scratch/jwaller/

# process occurrenct 
unzip -p 0009296-180412121330197.zip occurrence.txt | split --numeric-suffixes --line-bytes=1024M --filter='gzip > $FILE.gz' - occurrence-part-

for i in occurrence-part-*;
do echo "$i";
gzip -d -c $i > output.txt;
awk -F'\t' '{ print $1,$64,$216,$191,$192,$193,$194,$195,$196,$183,$176,$177,$184,$42,$59}' output.txt > $i"_reduced";
cat $i"_reduced" >> occurrence.txt
rm $i
rm $i"_reduced"
done
rm output.txt

# process verbatim 
# df -h /mnt/auto/scratch
hdfs dfs -get "/occurrence-download/prod-downloads/0009296-180412121330197.zip"
unzip -p 0009296-180412121330197.zip verbatim.txt | split --numeric-suffixes --line-bytes=1024M --filter='gzip > $FILE.gz' - verbatim-part-
# zcat verbatim-part-00.gz | head -n 1 > header

for i in verbatim-part-*;
do echo "$i";
gzip -d -c $i > output.txt;
awk -F'\t' '{ print $1 $201 $202 $203 $204 $205 $206 $193 $210}' output.txt > $i"_reduced";
cat $i"_reduced" >> verbatim.txt
rm $i
rm $i"_reduced"
done
rm output.txt


scp -r jwaller@c4gateway-vh.gbif.org:/mnt/auto/scratch/jwaller/header /mnt/c/Users/ftw712/Desktop/

# awk '{gsub(".gz", "")}1' $i | awk -F'\t' '{ print $1 }'
# awk -F'\t' '{ print $1,$62,$213,$188,$189,$190,$191,$192,$193,$180,$173,$174,$181,$41,$57}' output.txt > $i"_reduced";

# echo "$i" | awk '{gsub(".gz", "")}1';
# echo "$SAVEFILE";


# echo "occurrence-part-01.gz" | awk '{gsub(".gz", "")}1'

# for i in 0009296-180412121330197-part-*; do echo "$i"; hdfs dfs -put "$i"; done


# zcat test.txt.gz | awk -F'\t' '{ print $1,$3}' test2.txt - > output.txt

# zcat inputfile2.gz | awk 'NR==FNR {a[$1]; next}$1 in a' inputfile1.txt - > output.txt

# awk -F'\t' '{ print $1,$62,$213,$188,$189,$190,$191,$192,$193,$180,$173,$174,$181,$41,$57}' occurrence-part-00 > r-occurrence-part-00

# awk '{gsub(".gz", "")}1' test.txt.gz | awk -F'\t' '{ print $1 }'

# occurrence-part-00.gz
# awk -F'\t' '{ print $7 }'
# 1  62 213 188 189 190 191 192 193 180 173 174 181  41  57
# occurrence-part-00.gz

# for i in 0009296-180412121330197-part-*; do echo "$i"; hdfs dfs -put "$i"; done
# for i in 0009296-180412121330197-part-*; do echo "$i"; hdfs dfs -rm "$i"; done







# split --verbose -l50000000 verbatim.txt

# remove header from xaa
# sed '1d' xaa > xxx
# rm xaa 

# HEADER="gbifID\tabstract\taccessRights\taccrualMethod\taccrualPeriodicity\taccrualPolicy\talternative\taudience\tavailable\tbibliographicCitation\tconformsTo\tcontributor\tcoverage\tcreated\tcreator\tdate\tdateAccepted\tdateCopyrighted\tdateSubmitted\tdescription\teducationLevel\textent\tformat\thasFormat\thasPart\thasVersion\tidentifier\tinstructionalMethod\tisFormatOf\tisPartOf\tisReferencedBy\tisReplacedBy\tisRequiredBy\tisVersionOf\tissued\tlanguage\tlicense\tmediator\tmedium\tmodified\tprovenance\tpublisher\treferences\trelation\treplaces\trequires\trights\trightsHolder\tsource\tspatial\tsubject\ttableOfContents\ttemporal\ttitle\ttype\tvalid\tinstitutionID\tcollectionID\tdatasetID\tinstitutionCode\tcollectionCode\tdatasetName\townerInstitutionCode\tbasisOfRecord\tinformationWithheld\tdataGeneralizations\tdynamicProperties\toccurrenceID\tcatalogNumber\trecordNumber\trecordedBy\tindividualCount\torganismQuantity\torganismQuantityType\tsex\tlifeStage\treproductiveCondition\tbehavior\testablishmentMeans\toccurrenceStatus\tpreparations\tdisposition\tassociatedMedia\tassociatedReferences\tassociatedSequences\tassociatedTaxa\totherCatalogNumbers\toccurrenceRemarks\torganismID\torganismName\torganismScope\tassociatedOccurrences\tassociatedOrganisms\tpreviousIdentifications\torganismRemarks\tmaterialSampleID\teventID\tparentEventID\tfieldNumber\teventDate\teventTime\tstartDayOfYear\tendDayOfYear\tyear\tmonth\tday\tverbatimEventDate\thabitat\tsamplingProtocol\tsamplingEffort\tsampleSizeValue\tsampleSizeUnit\tfieldNotes\teventRemarks\tlocationID\thigherGeographyID\thigherGeography\tcontinent\twaterBody\tislandGroup\tisland\tcountry\tcountryCode\tstateProvince\tcounty\tmunicipality\tlocality\tverbatimLocality\tminimumElevationInMeters\tmaximumElevationInMeters\tverbatimElevation\tminimumDepthInMeters\tmaximumDepthInMeters\tverbatimDepth\tminimumDistanceAboveSurfaceInMeters\tmaximumDistanceAboveSurfaceInMeters\tlocationAccordingTo\tlocationRemarks\tdecimalLatitude\tdecimalLongitude\tgeodeticDatum\tcoordinateUncertaintyInMeters\tcoordinatePrecision\tpointRadiusSpatialFit\tverbatimCoordinates\tverbatimLatitude\tverbatimLongitude\tverbatimCoordinateSystem\tverbatimSRS\tfootprintWKT\tfootprintSRS\tfootprintSpatialFit\tgeoreferencedBy\tgeoreferencedDate\tgeoreferenceProtocol\tgeoreferenceSources\tgeoreferenceVerificationStatus\tgeoreferenceRemarks\tgeologicalContextID\tearliestEonOrLowestEonothem\tlatestEonOrHighestEonothem\tearliestEraOrLowestErathem\tlatestEraOrHighestErathem\tearliestPeriodOrLowestSystem\tlatestPeriodOrHighestSystem\tearliestEpochOrLowestSeries\tlatestEpochOrHighestSeries\tearliestAgeOrLowestStage\tlatestAgeOrHighestStage\tlowestBiostratigraphicZone\thighestBiostratigraphicZone\tlithostratigraphicTerms\tgroup\tformation\tmember\tbed\tidentificationID\tidentificationQualifier\ttypeStatus\tidentifiedBy\tdateIdentified\tidentificationReferences\tidentificationVerificationStatus\tidentificationRemarks\ttaxonID\tscientificNameID\tacceptedNameUsageID\tparentNameUsageID\toriginalNameUsageID\tnameAccordingToID\tnamePublishedInID\ttaxonConceptID\tscientificName\tacceptedNameUsage\tparentNameUsage\toriginalNameUsage\tnameAccordingTo\tnamePublishedIn\tnamePublishedInYear\thigherClassification\tkingdom\tphylum\tclass\torder\tfamily\tgenus\tsubgenus\tspecificEpithet\tinfraspecificEpithet\ttaxonRank\tverbatimTaxonRank\tscientificNameAuthorship\tvernacularName\tnomenclaturalCode\ttaxonomicStatus\tnomenclaturalStatus\ttaxonRemarks"
# sed -i '1i '$HEADER xxx;

# HEADER="gbifID\tabstract\taccessRights\taccrualMethod\taccrualPeriodicity\taccrualPolicy\talternative\taudience\tavailable\tbibliographicCitation\tconformsTo\tcontributor\tcoverage\tcreated\tcreator\tdate\tdateAccepted\tdateCopyrighted\tdateSubmitted\tdescription\teducationLevel\textent\tformat\thasFormat\thasPart\thasVersion\tidentifier\tinstructionalMethod\tisFormatOf\tisPartOf\tisReferencedBy\tisReplacedBy\tisRequiredBy\tisVersionOf\tissued\tlanguage\tlicense\tmediator\tmedium\tmodified\tprovenance\tpublisher\treferences\trelation\treplaces\trequires\trights\trightsHolder\tsource\tspatial\tsubject\ttableOfContents\ttemporal\ttitle\ttype\tvalid\tinstitutionID\tcollectionID\tdatasetID\tinstitutionCode\tcollectionCode\tdatasetName\townerInstitutionCode\tbasisOfRecord\tinformationWithheld\tdataGeneralizations\tdynamicProperties\toccurrenceID\tcatalogNumber\trecordNumber\trecordedBy\tindividualCount\torganismQuantity\torganismQuantityType\tsex\tlifeStage\treproductiveCondition\tbehavior\testablishmentMeans\toccurrenceStatus\tpreparations\tdisposition\tassociatedMedia\tassociatedReferences\tassociatedSequences\tassociatedTaxa\totherCatalogNumbers\toccurrenceRemarks\torganismID\torganismName\torganismScope\tassociatedOccurrences\tassociatedOrganisms\tpreviousIdentifications\torganismRemarks\tmaterialSampleID\teventID\tparentEventID\tfieldNumber\teventDate\teventTime\tstartDayOfYear\tendDayOfYear\tyear\tmonth\tday\tverbatimEventDate\thabitat\tsamplingProtocol\tsamplingEffort\tsampleSizeValue\tsampleSizeUnit\tfieldNotes\teventRemarks\tlocationID\thigherGeographyID\thigherGeography\tcontinent\twaterBody\tislandGroup\tisland\tcountry\tcountryCode\tstateProvince\tcounty\tmunicipality\tlocality\tverbatimLocality\tminimumElevationInMeters\tmaximumElevationInMeters\tverbatimElevation\tminimumDepthInMeters\tmaximumDepthInMeters\tverbatimDepth\tminimumDistanceAboveSurfaceInMeters\tmaximumDistanceAboveSurfaceInMeters\tlocationAccordingTo\tlocationRemarks\tdecimalLatitude\tdecimalLongitude\tgeodeticDatum\tcoordinateUncertaintyInMeters\tcoordinatePrecision\tpointRadiusSpatialFit\tverbatimCoordinates\tverbatimLatitude\tverbatimLongitude\tverbatimCoordinateSystem\tverbatimSRS\tfootprintWKT\tfootprintSRS\tfootprintSpatialFit\tgeoreferencedBy\tgeoreferencedDate\tgeoreferenceProtocol\tgeoreferenceSources\tgeoreferenceVerificationStatus\tgeoreferenceRemarks\tgeologicalContextID\tearliestEonOrLowestEonothem\tlatestEonOrHighestEonothem\tearliestEraOrLowestErathem\tlatestEraOrHighestErathem\tearliestPeriodOrLowestSystem\tlatestPeriodOrHighestSystem\tearliestEpochOrLowestSeries\tlatestEpochOrHighestSeries\tearliestAgeOrLowestStage\tlatestAgeOrHighestStage\tlowestBiostratigraphicZone\thighestBiostratigraphicZone\tlithostratigraphicTerms\tgroup\tformation\tmember\tbed\tidentificationID\tidentificationQualifier\ttypeStatus\tidentifiedBy\tdateIdentified\tidentificationReferences\tidentificationVerificationStatus\tidentificationRemarks\ttaxonID\tscientificNameID\tacceptedNameUsageID\tparentNameUsageID\toriginalNameUsageID\tnameAccordingToID\tnamePublishedInID\ttaxonConceptID\tscientificName\tacceptedNameUsage\tparentNameUsage\toriginalNameUsage\tnameAccordingTo\tnamePublishedIn\tnamePublishedInYear\thigherClassification\tkingdom\tphylum\tclass\torder\tfamily\tgenus\tsubgenus\tspecificEpithet\tinfraspecificEpithet\ttaxonRank\tverbatimTaxonRank\tscientificNameAuthorship\tvernacularName\tnomenclaturalCode\ttaxonomicStatus\tnomenclaturalStatus\ttaxonRemarks"
# for i in x*; do echo "$i"; sed -i '1i '$HEADER $i; done

# for i in x*; do echo "$i"; hdfs dfs -rm "$i"; done
# for i in x*; do echo "$i"; hdfs dfs -put "$i"; done

# scp -r process_verbatim_file.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i process_verbatim_file.scala"

# for i in x*; do echo "$i"; sed -i '1d' $i; done 


# process occurrence.txt
# unzip -p 0009296-180412121330197.zip occurrence.txt > occurrence.txt
# split --verbose -l50000000 occurrence.txt

# remove header from xaa
# sed '1d' xaa > xxx; rm xaa

# HEADER="gbifID\tabstract\taccessRights\taccrualMethod\taccrualPeriodicity\taccrualPolicy\talternative\taudience\tavailable\tbibliographicCitation\tconformsTo\tcontributor\tcoverage\tcreated\tcreator\tdate\tdateAccepted\tdateCopyrightedateSubmitted\tdescription\teducationLevel\textent\tformat\thasFormat\thasPart\thasVersion\tidentifier\tinstructionalMethod\tisFormatOf\tisPartOf\tisReferencedBy\tisReplacedBy\tisRequiredBy\tisVersionOf\tissued\tlanguage\tlicense\tmediator\tmedium\tmodified\tprovenance\tpublisher\treferences\trelation\treplaces\trequires\trightsrightsHolder\tsource\tspatial\tsubject\ttableOfContents\ttemporal\ttitle\ttype\tvalid\tinstitutionID\tcollectionID\tdatasetID\tinstitutionCode\tcollectionCode\tdatasetName\townerInstitutionCode\tbasisOfRecord\tinformationWithheld\tdataGeneralizations\tdynamicProperties\toccurrenceID\tcatalogNumber\trecordNumber\trecordedBy\tindividualCount\torganismQuantity\torganismQuantityType\tsex\tlifeStage\treproductiveCondition\tbehavior\testablishmentMeans\toccurrenceStatus\tpreparations\tdisposition\tassociatedReferences\tassociatedSequences\tassociatedTaxa\totherCatalogNumbers\toccurrenceRemarks\torganismID\torganismName\torganismScope\tassociatedOccurrences\tassociatedOrganisms\tpreviousIdentifications\torganismRemarks\tmaterialSampleID\teventID\tparentEventID\tfieldNumber\teventDate\teventTime\tstartDayOfYear\tendDayOfYear\tyear\tmonth\tday\tverbatimEventDate\thabitat\tsamplingProtocol\tsamplingEffort\tsampleSizeValue\tsampleSizeUnitfieldNotes\teventRemarks\tlocationID\thigherGeographyID\thigherGeography\tcontinent\twaterBody\tislandGroup\tisland\tcountryCode\tstateProvince\tcounty\tmunicipality\tlocality\tverbatimLocality\tverbatimElevation\tverbatimDepth\tminimumDistanceAboveSurfaceInMeters\tmaximumDistanceAboveSurfaceInMeters\tlocationAccordingTo\tlocationRemarks\tdecimalLatitude\tdecimalLongitude\tcoordinateUncertaintyInMeters\tcoordinatePrecision\tpointRadiusSpatialFit\tverbatimCoordinateSystem\tverbatimSRS\tfootprintWKT\tfootprintSRS\tfootprintSpatialFit\tgeoreferencedBy\tgeoreferencedDate\tgeoreferenceProtocol\tgeoreferenceSources\tgeoreferenceVerificationStatus\tgeoreferenceRemarks\tgeologicalContextID\tearliestEonOrLowestEonothem\tlatestEonOrHighestEonothem\tearliestEraOrLowestErathem\tlatestEraOrHighestErathem\tearliestPeriodOrLowestSystem\tlatestPeriodOrHighestSystem\tearliestEpochOrLowestSeries\tlatestEpochOrHighestSeries\tearliestAgeOrLowestStage\tlatestAgeOrHighestStage\tlowestBiostratigraphicZone\thighestBiostratigraphicZone\tlithostratigraphicTerms\tgroup\tformation\tmember\tbed\tidentificationID\tidentificationQualifier\ttypeStatus\tidentifiedBy\tdateIdentified\tidentificationReferences\tidentificationVerificationStatus\tidentificationRemarks\ttaxonID\tscientificNameID\tacceptedNameUsageID\tparentNameUsageID\toriginalNameUsageID\tnameAccordingToID\tnamePublishedInID\ttaxonConceptID\tscientificName\tacceptedNameUsage\tparentNameUsage\toriginalNameUsage\tnameAccordingTo\tnamePublishedIn\tnamePublishedInYear\thigherClassification\tkingdom\tphylum\tclass\torder\tfamily\tgenus\tsubgenus\tspecificEpithet\tinfraspecificEpithet\ttaxonRank\tverbatimTaxonRank\tvernacularName\tnomenclaturalCode\ttaxonomicStatus\tnomenclaturalStatus\ttaxonRemarks\tdatasetKey\tpublishingCountry\tlastInterpreted\televation\televationAccuracy\tdepth\tdepthAccuracy\tdistanceAboveSurface\tdistanceAboveSurfaceAccuracy\tissue\tmediaType\thasCoordinate\thasGeospatialIssues\ttaxonKey\tkingdomKey\tphylumKey\tclassKey\torderKey\tfamilyKey\tgenusKey\tsubgenusKey\tspeciesKey\tspecies\tgenericName\ttypifiedName\tprotocol\tlastParsed\tlastCrawled\trepatriated"
# for i in x*; do echo "$i"; sed -i '1i '$HEADER $i; done

# for i in x*; do echo "$i"; hdfs dfs -rm "$i"; done
# for i in x*; do echo "$i"; hdfs dfs -put "$i"; done

# scp -r process_verbatim_file.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i process_verbatim_file.scala"



# hadoop fs -get

# ssh jwaller@c5gateway-vh.gbif.org "
# cd /mnt/auto/scratch/jwaller
# for i in x*; do echo "$i"; hdfs dfs -put "$i"; done
# download full downloads to 
# ssh jwaller@c5gateway-vh.gbif.org "
# cd /mnt/auto/scratch/jwaller
# wget -q https://api.gbif.org/v1/occurrence/download/request/0009296-180412121330197.zip
# unzip -p 0009296-180412121330197.zip occurrence.txt > occurrence.txt
# unzip -p 0009296-180412121330197.zip verbatim.txt > verbatim.txt
# "

# scp -r wanted_names_fulldownload.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i wanted_names_fulldownload.scala"


# ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < shell/export_parquet.sh

# hdfs dfs -get "/occurrence-download/prod-downloads/0009296-180412121330197.zip"

# split --verbose -l50000000 occurrence.txt
# wget -q https://api.gbif.org/v1/occurrence/download/request/0088445-210914110416597.zip
# 
# unzip -l 0009296-180412121330197.zip
# 2018 download 
# split --verbose -b50G occurrece.txt

# 0009296-180412121330197
# val conf = sc.hadoopConfiguration
# val fs = org.apache.hadoop.fs.FileSystem.get(conf)
# fs.exists(new org.apache.hadoop.fs.Path("/occurrence-download/prod-downloads/0009296-180412121330197"))
