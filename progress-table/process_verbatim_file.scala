val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext.implicits._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.SaveMode

// process occurrence.txt
val files = (1 to 10).toList.flatMap(i => List("0009296-180412121330197-part-" + i + ".gz"))

files.
map(file => {
val df = spark.read.
option("sep", "\t").
option("header", "false").
option("inferSchema", "true").
csv(file)

// toDF(col_names_v:_*)

// select("gbifID","basisOfRecord","issue","kingdom","phylum","class","order","family","genus","scientificName","scientificNameID","acceptedNameUsageID","acceptedNameUsage","publisher","datasetID")
df.printSchema
df.count()
// df.
// write.
// option("sep", "\t").
// option("header", "false").
// mode(SaveMode.Append).
// csv("occurrence_reduced")
})

// val files = List("xab","xac","xad","xae","xaf","xag","xah","xai","xaj","xak","xal","xam","xan","xao","xap","xaq","xar","xas","xat","xxx")

// files.
// map(file => {
// val df = spark.read.
// option("sep", "\t").
// option("header", "true").
// option("inferSchema", "true").
// csv(file).
// select("gbifID","kingdom","phylum","class","order","family","genus","scientificName","taxonRank")
// df.printSchema
// df.
// write.
// option("sep", "\t").
// option("header", "false").
// mode(SaveMode.Append).
// csv("verbatim_reduced")
// })

// val df = spark.read.
// option("sep", "\t").
// option("header", "false").
// option("inferSchema", "true").
// csv("verbatim_reduced")

// df.count
// df.printSchema
// df.show(100,false)


// joining and post processing 
// val col_names_v = List("gbifID","v_kingdom","v_phylum","v_class","v_order","v_family","v_genus","v_scientificName","v_taxonRank")

// val df_v = spark.read.
// option("sep", "\t").
// option("header", "false").
// option("inferSchema", "true").
// csv("verbatim_reduced").
// toDF(col_names_v:_*)

// val col_names_o = List("gbifID","basisOfRecord","issue","kingdom","phylum","class","order","family","genus","scientificName","scientificNameID","acceptedNameUsageID","acceptedNameUsage","publisher","datasetID")

// val df_o = spark.read.
// option("sep", "\t").
// option("header", "false").
// option("inferSchema", "true").
// csv("occurrence_reduced").
// toDF(col_names_o:_*)

// val df = df_o.join(df_v,"gbifID")

// df_v.count
// df_o.count
// df.count
// df.printSchema 


// df_v.
// df.count
// df.printSchema
// df.show(100,false)






// .reduce(_ union _).
// cache()



// val renamedColumns = df.columns.map(name => col(name).as(s"v_$name"))

// val df2 = df.select(renamedColumns : _*)

// df2.printSchema
// df2.show(100,false) 

// withColumnRenamed("season_high_player", "player")

// df2.show()


// df.count() 
// df.filter($"kingdom".isNotNull).show(100,false)

System.exit(0)




