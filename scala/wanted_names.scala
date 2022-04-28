// minimally filtered wanted v_scientificname names for filtering later in R

val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext.implicits._

val df = sqlContext.sql("SELECT * FROM prod_h.occurrence").
filter(array_contains(col("issue"), "TAXON_MATCH_HIGHERRANK")).
groupBy("kingdom","phylum","class","order_","family","v_kingdom","v_phylum","v_class","v_order","v_family","v_genus","kingdomkey","phylumkey","orderkey","classkey","familykey","scientificname","v_scientificname","v_taxonrank","taxonrank").
agg(
count(lit(1)).alias("n_occ"),
countDistinct("datasetkey").as("n_dataset"),
countDistinct("publishingorgkey").as("n_publisher")
).
orderBy(desc("n_occ"))

df.show()

import org.apache.spark.sql.SaveMode
df.write.mode("overwrite").parquet("wanted_names_unfiltered.parquet")

System.exit(0)




