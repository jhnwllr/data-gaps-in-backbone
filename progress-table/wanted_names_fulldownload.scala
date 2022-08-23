
val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext.implicits.

// val files = List("xaa","xab","xac","xad","xae","xaf","xag","xah","xai","xaj","xak","xal","xam","xan","xao","xap","xaq","xar","xas","xat")

// val df_published = snapshots.
// map(snapshot => {
// val df_output = sqlContext.sql("SELECT * FROM snapshot." + snapshot).
// groupBy("publisher_country").
// agg(count(lit(1)).alias("num_occ"),countDistinct("species_id").as("num_species")).
// withColumn("snapshot",lit(snapshot)).
// withColumn("type",lit("published")).
// withColumnRenamed("publisher_country","country").
// coalesce(1)
// df_output
// })

val df = spark.read.
option("sep", "\t").
option("header", "false").
option("inferSchema", "true").
csv("xxx").
withColumnRenamed("_c65", "basisofrecord").
withColumnRenamed("_c215", "issue").
withColumnRenamed("_c190", "kingdom").
withColumnRenamed("_c191", "phylum").
withColumnRenamed("_c192", "class").
withColumnRenamed("_c193", "order_").
withColumnRenamed("_c194", "family").
withColumnRenamed("_c195", "genus").
withColumnRenamed("_c220", "kingdomkey").
withColumnRenamed("_c221", "phylumkey").
withColumnRenamed("_c223", "orderkey").
withColumnRenamed("_c222", "classkey").
withColumnRenamed("_c224", "familykey").
withColumnRenamed("_c225", "genuskey").
withColumnRenamed("_c219", "taxonkey").
withColumnRenamed("_c182", "scientificname").
withColumnRenamed("_c65", "v_scientificname").
withColumnRenamed("_c65", "v_taxonrank").
withColumnRenamed("_c65", "taxonrank").
withColumnRenamed("_c65", "acceptednameusageid").
withColumnRenamed("_c65", "acceptedscientificname").
filter($"basisofrecord" =!= "FOSSIL_SPECIMEN").
filter(array_contains(col("issue"), "TAXON_MATCH_HIGHERRANK")).
groupBy("kingdom","phylum","class","order_","family","genus","kingdomkey","phylumkey","orderkey","classkey","familykey","genuskey","taxonkey","scientificname","v_scientificname","v_taxonrank","taxonrank","acceptednameusageid","acceptedscientificname").
agg(
count(lit(1)).alias("n_occ"),
countDistinct("datasetkey").as("n_dataset"),
countDistinct("publishingorgkey").as("n_publisher"),
collect_set("datasetkey").as("datasetkeys_array")
).
withColumn("datasetkeys",concat_ws(";", $"datasetkeys_array")).
drop("datasetkeys_array").
orderBy(desc("n_occ"))

df.printSchema
df.count()







